-----------------------------------
-- Dynamic World System
-----------------------------------
-- A living world layer that spawns roaming entities across the overworld.
-- Entities are tiered: Wanderer, Nomad, Elite, Apex.
-- Each tier has different behaviors, rewards, and danger levels.
--
-- Architecture:
--   settings/dynamic_world.lua       - All tunables
--   scripts/globals/dynamic_world.lua - This file (namespace, init, tick, public API)
--   scripts/globals/dynamic_world/
--     templates.lua                   - Entity archetype definitions
--     spawner.lua                     - Spawn budget, placement, lifecycle
--     roaming.lua                     - Zone migration and pathing
--     loot.lua                        - Dynamic loot generation
--     behaviors.lua                   - Mob AI callbacks (onSpawn, onRoam, onDeath, etc.)
--     synergies.lua                   - Item/ability synergy effects
--
-- Hooks into server via:
--   modules/custom/lua/dynamic_world_module.lua
--
-- GM commands:
--   scripts/commands/dynworld.lua
-----------------------------------
-----------------------------------

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}

-----------------------------------
-- Tier Enum
-----------------------------------
xi.dynamicWorld.tier =
{
    WANDERER = 1,   -- Common, zone-bound
    NOMAD    = 2,   -- Cross-zone roamers
    ELITE    = 3,   -- Rare, dangerous, great rewards
    APEX     = 4,   -- Boss-tier, spawns minions, aura buffs
}

xi.dynamicWorld.tierName =
{
    [1] = 'Wanderer',
    [2] = 'Nomad',
    [3] = 'Elite',
    [4] = 'Apex',
}

-----------------------------------
-- Runtime State
-----------------------------------
xi.dynamicWorld.state =
{
    initialized     = false,
    running         = false,
    globalCount     = 0,                -- Total active dynamic world entities
    zoneData        = {},               -- [zoneId] = { entities = {}, lastTick = 0, lastRoamCheck = 0 }
    eligibleZones   = {},               -- Set of eligible zone IDs (for fast lookup)
    zoneToRegion    = {},               -- [zoneId] = regionName
    regionData      = {},               -- [regionName] = { zones = {}, levelRange = {} }
    playerChains    = {},               -- [charId] = { count = 0, lastKill = 0, tier = 0 }
}

-----------------------------------
-- Load Submodules
-----------------------------------
xi.dynamicWorld.templates = xi.dynamicWorld.templates or {}
xi.dynamicWorld.spawner   = xi.dynamicWorld.spawner or {}
xi.dynamicWorld.roaming   = xi.dynamicWorld.roaming or {}
xi.dynamicWorld.loot      = xi.dynamicWorld.loot or {}
xi.dynamicWorld.behaviors = xi.dynamicWorld.behaviors or {}
xi.dynamicWorld.synergies = xi.dynamicWorld.synergies or {}

require('scripts/globals/dynamic_world/templates')
require('scripts/globals/dynamic_world/spawner')
require('scripts/globals/dynamic_world/roaming')
require('scripts/globals/dynamic_world/loot')
require('scripts/globals/dynamic_world/behaviors')
require('scripts/globals/dynamic_world/synergies')
require('scripts/globals/dynamic_world/named_rares')

-----------------------------------
-- Utility: Safe settings access
-----------------------------------
local function getSetting(key)
    local settings = xi.settings.dynamicworld
    return settings and settings[key] or nil
end

-----------------------------------
-- Zone and Region Config
-- Kept here (not in settings/) because the C++ settings loader only
-- pushes back primitive values — tables like ELIGIBLE_ZONES and REGIONS
-- get silently dropped during the push-back phase.
-----------------------------------
local ELIGIBLE_ZONES =
{
    -- Original Outdoor Zones
    100, 101, 102, 103, 104, 105,
    106, 107, 108, 109, 110, 111,
    112, 113, 114, 115, 116, 117,
    118, 119, 120, 121, 122, 123,
    124, 125, 126, 127, 128,
    -- CoP
    24, 25,
    -- ToAU
    51, 52, 61, 65, 68, 79,
    -- WotG
    81, 82, 83, 84, 88, 89,
    90, 91, 95, 97, 98, 136, 137,
    -- SoA
    260, 261,
}

local REGIONS =
{
    ronfaure     = { zones = { 100, 101, 102, 104, 105 },                   levelRange = { 1,  15 } },
    gustaberg    = { zones = { 106, 107, 108, 109, 110 },                   levelRange = { 1,  15 } },
    sarutabaruta = { zones = { 115, 116, 117, 118, 119, 120 },              levelRange = { 1,  15 } },
    midlands     = { zones = { 103, 111, 112, 113, 114, 121, 122, 125, 126, 127, 128 }, levelRange = { 20, 75 } },
    elshimo      = { zones = { 123, 124 },                                  levelRange = { 25, 55 } },
    tavnazia     = { zones = { 24,  25  },                                  levelRange = { 30, 60 } },
    aradjiah     = { zones = { 51,  52,  61, 65, 68, 79 },                  levelRange = { 55, 80 } },
    shadowreign  = { zones = { 81,  82,  83, 84, 88, 89, 90, 91, 95, 97, 98, 136, 137 }, levelRange = { 50, 80 } },
}

local ZONE_LEVELS =
{
    [100]={1,9}, [101]={1,9},   [102]={10,21}, [103]={10,22}, [104]={15,28},
    [105]={25,40},[106]={1,9},  [107]={1,9},   [108]={10,22}, [109]={20,33},
    [110]={30,43},[111]={40,52},[112]={47,58}, [113]={40,52}, [114]={45,58},
    [115]={1,9},  [116]={1,9},  [117]={10,22}, [118]={15,27}, [119]={25,38},
    [120]={33,48},[121]={35,50},[122]={42,58}, [123]={38,52}, [124]={44,58},
    [125]={45,58},[126]={20,33},[127]={60,72}, [128]={65,75},
    [24]={30,52}, [25]={35,55},
    [51]={55,72}, [52]={55,72}, [61]={60,75},  [65]={62,75},  [68]={63,75}, [79]={65,75},
    [81]={1,12},  [82]={18,32}, [83]={22,40},  [84]={30,48},  [88]={1,12},
    [89]={22,40}, [90]={28,45}, [91]={35,52},  [95]={1,12},   [97]={30,48},
    [98]={38,55}, [136]={48,62},[137]={55,70},
    [260]={90,99},[261]={90,99},
}

-----------------------------------
-- Initialize
-----------------------------------
xi.dynamicWorld.init = function()
    -- ENABLED check: default true, only skip if explicitly set false
    local settings = xi.settings.dynamicworld
    if settings and settings.ENABLED == false then
        printf('[DynamicWorld] Disabled via settings.')
        return
    end

    local state = xi.dynamicWorld.state

    -- Build eligible zone lookup set from local config (not settings tables)
    state.eligibleZones = {}
    for _, zoneId in ipairs(ELIGIBLE_ZONES) do
        state.eligibleZones[zoneId] = true
    end

    -- Build region maps from local config
    state.zoneToRegion = {}
    state.regionData = {}
    for regionName, regionInfo in pairs(REGIONS) do
        state.regionData[regionName] = {
            zones      = regionInfo.zones,
            levelRange = regionInfo.levelRange,
        }
        for _, zoneId in ipairs(regionInfo.zones) do
            state.zoneToRegion[zoneId] = regionName
        end
    end

    -- Initialize per-zone state
    state.zoneData = {}
    for zoneId, _ in pairs(state.eligibleZones) do
        state.zoneData[zoneId] = {
            entities      = {},
            count         = 0,
            lastTick      = 0,
            lastRoamCheck = 0,
            pendingSpawns = 0,
        }
    end

    state.playerChains = {}
    state.globalCount = 0
    state.initialized = true
    state.running = true

    xi.dynamicWorld.namedRares.init()

    printf('[DynamicWorld] Initialized. %d eligible zones, %d regions, %d named rares.',
        xi.dynamicWorld.countKeys(state.eligibleZones),
        xi.dynamicWorld.countKeys(state.regionData),
        xi.dynamicWorld.countKeys(xi.dynamicWorld.namedRares.db))
end

-----------------------------------
-- Main Tick (called from module on zone tick)
-- Staggered: each zone ticks independently based on its own timer
-----------------------------------
xi.dynamicWorld.onZoneTick = function(zone)
    local state = xi.dynamicWorld.state
    if not state.running then
        return
    end

    local zoneId = zone:getID()
    if not state.eligibleZones[zoneId] then
        return
    end

    local zd = state.zoneData[zoneId]
    if not zd then
        return
    end

    local now = os.time()
    local spawnInterval = getSetting('SPAWN_CHECK_INTERVAL') or 120

    -- Spawn check
    if now - zd.lastTick >= spawnInterval then
        zd.lastTick = now
        xi.dynamicWorld.spawner.evaluate(zone, zd, state)
    end

    -- Roam check (for nomads)
    local roamInterval = getSetting('ROAM_CHECK_INTERVAL') or 300
    if now - zd.lastRoamCheck >= roamInterval then
        zd.lastRoamCheck = now
        xi.dynamicWorld.roaming.evaluate(zone, zd, state)
    end

    -- Cleanup stale chains
    xi.dynamicWorld.cleanupChains(now)

    -- Named rare tick (rate-limited to once every 5 minutes globally)
    local nrInterval = 300
    if not state.lastNamedRareTick then state.lastNamedRareTick = 0 end
    if now - state.lastNamedRareTick >= nrInterval then
        state.lastNamedRareTick = now
        xi.dynamicWorld.namedRares.tick()
    end
end

-----------------------------------
-- Chain Cleanup
-----------------------------------
xi.dynamicWorld.cleanupChains = function(now)
    local state = xi.dynamicWorld.state
    local window = getSetting('CHAIN_WINDOW') or 180

    for charId, chain in pairs(state.playerChains) do
        if now - chain.lastKill > window then
            state.playerChains[charId] = nil
        end
    end
end

-----------------------------------
-- Player Chain Tracking
-----------------------------------
xi.dynamicWorld.recordKill = function(player, mob, tier)
    if not getSetting('CHAIN_ENABLED') then
        return 0
    end

    local state = xi.dynamicWorld.state
    local charId = player:getID()
    local now = os.time()
    local window = getSetting('CHAIN_WINDOW') or 180

    local chain = state.playerChains[charId]
    if not chain or now - chain.lastKill > window then
        chain = { count = 0, lastKill = now, tier = tier }
    end

    chain.count = chain.count + 1
    chain.lastKill = now
    chain.tier = math.max(chain.tier, tier)
    state.playerChains[charId] = chain

    -- Announce chain milestones
    local announceInterval = getSetting('CHAIN_ANNOUNCE_INTERVAL') or 3
    if chain.count > 1 and chain.count % announceInterval == 0 then
        local bonus = math.min(
            chain.count * (getSetting('CHAIN_BONUS_PER_KILL') or 0.15),
            getSetting('CHAIN_BONUS_MAX') or 2.0
        )
        player:printToPlayer(
            string.format('[Dynamic World] Hunt Chain x%d! (EXP +%d%%)', chain.count, math.floor(bonus * 100)),
            xi.msg.channel.SYSTEM_3
        )
    end

    return chain.count
end

xi.dynamicWorld.getChainBonus = function(player)
    local state = xi.dynamicWorld.state
    local charId = player:getID()
    local chain = state.playerChains[charId]
    if not chain then
        return 0
    end

    local now = os.time()
    local window = getSetting('CHAIN_WINDOW') or 180
    if now - chain.lastKill > window then
        state.playerChains[charId] = nil
        return 0
    end

    return math.min(
        chain.count * (getSetting('CHAIN_BONUS_PER_KILL') or 0.15),
        getSetting('CHAIN_BONUS_MAX') or 2.0
    )
end

-----------------------------------
-- Public API
-----------------------------------
xi.dynamicWorld.start = function()
    if not xi.dynamicWorld.state.initialized then
        xi.dynamicWorld.init()
    end
    xi.dynamicWorld.state.running = true
    printf('[DynamicWorld] Started.')
end

xi.dynamicWorld.stop = function()
    xi.dynamicWorld.state.running = false
    printf('[DynamicWorld] Stopped.')
end

xi.dynamicWorld.getStatus = function()
    local state = xi.dynamicWorld.state
    local zoneCount = 0
    local entityBreakdown = { 0, 0, 0, 0 }

    for zoneId, zd in pairs(state.zoneData) do
        if zd.count > 0 then
            zoneCount = zoneCount + 1
        end
        for _, entData in pairs(zd.entities) do
            entityBreakdown[entData.tier] = (entityBreakdown[entData.tier] or 0) + 1
        end
    end

    return {
        running      = state.running,
        globalCount  = state.globalCount,
        activeZones  = zoneCount,
        wanderers    = entityBreakdown[1] or 0,
        nomads       = entityBreakdown[2] or 0,
        elites       = entityBreakdown[3] or 0,
        apex         = entityBreakdown[4] or 0,
    }
end

-- Force spawn a specific tier in a zone (for GM use)
xi.dynamicWorld.forceSpawn = function(zone, tier, count)
    local state = xi.dynamicWorld.state
    local zoneId = zone:getID()

    if not state.zoneData[zoneId] then
        state.zoneData[zoneId] = {
            entities = {}, count = 0, lastTick = 0, lastRoamCheck = 0, pendingSpawns = 0,
        }
    end

    local zd = state.zoneData[zoneId]
    count = count or 1

    local spawned = 0
    for i = 1, count do
        local entity = xi.dynamicWorld.spawner.spawnEntity(zone, zd, state, tier)
        if entity then
            spawned = spawned + 1
        end
    end

    return spawned
end

-- Despawn all dynamic world entities in a zone
xi.dynamicWorld.clearZone = function(zone)
    local state = xi.dynamicWorld.state
    local zoneId = zone:getID()
    local zd = state.zoneData[zoneId]
    if not zd then
        return 0
    end

    local cleared = 0
    for targid, entData in pairs(zd.entities) do
        if entData.entity and entData.entity:isAlive() then
            entData.entity:setHP(0)
            cleared = cleared + 1
        end
    end

    return cleared
end

-----------------------------------
-- Helpers
-----------------------------------
xi.dynamicWorld.countKeys = function(tbl)
    local n = 0
    for _ in pairs(tbl) do
        n = n + 1
    end
    return n
end

xi.dynamicWorld.weightedRandom = function(weights)
    local total = 0
    for _, w in ipairs(weights) do
        total = total + w
    end

    local roll = math.random() * total
    local cumulative = 0
    for i, w in ipairs(weights) do
        cumulative = cumulative + w
        if roll <= cumulative then
            return i
        end
    end

    return #weights
end

-- Get a random valid spawn position in a zone.
-- First tries positions derived from existing mobs (guaranteed valid navmesh
-- locations). If the zone has no mobs (e.g. no players present), falls back
-- to player positions. Returns nil only if truly nothing is available.
xi.dynamicWorld.getRandomSpawnPoint = function(zone, anchorEntity)
    -- Build a list of anchor entities to sample positions from.
    -- Priority: existing mobs > players in zone > provided anchorEntity.
    local anchors = {}

    local mobs = zone:getMobs()
    if mobs then
        for _, mob in pairs(mobs) do
            table.insert(anchors, mob)
        end
    end

    -- If no mobs, try players as anchor points
    if #anchors == 0 then
        local players = zone:getPlayers()
        if players then
            for _, p in pairs(players) do
                table.insert(anchors, p)
            end
        end
    end

    -- If a specific anchor entity was passed (e.g. the calling player), use it
    if anchorEntity then
        table.insert(anchors, anchorEntity)
    end

    -- Fallback: zone has no mobs or players yet (e.g. server just started,
    -- zone has never been visited). Sample random points from the zone's
    -- known bounds and validate against the navmesh.
    if #anchors == 0 then
        local zoneId = zone:getID()
        local b = _zoneBounds[zoneId]
        if b then
            for attempt = 1, 30 do
                local x = b[1] + math.random() * (b[2] - b[1])
                local z = b[3] + math.random() * (b[4] - b[3])
                -- Y=0 is almost always correct for outdoor zones; navmesh
                -- will reject the point if the terrain doesn't exist there.
                if zone:isNavigablePoint({ x = x, y = 0, z = z }) then
                    return {
                        x   = x,
                        y   = 0,
                        z   = z,
                        rot = math.random(0, 255),
                    }
                end
            end
        end
        -- No bounds entry or all navmesh checks failed — can't spawn here yet.
        return nil
    end

    -- Try up to 15 times to find a valid, navigable position near an anchor
    for attempt = 1, 15 do
        local anchor = anchors[math.random(#anchors)]
        if anchor then
            local x = anchor:getXPos()
            local y = anchor:getYPos()
            local z = anchor:getZPos()

            -- Skip (0,0,0) — often a default/invalid position
            if x ~= 0 or y ~= 0 or z ~= 0 then
                -- Add random offset to avoid stacking on the anchor
                local offsetX = math.random() * 8 - 4
                local offsetZ = math.random() * 8 - 4
                local testX = x + offsetX
                local testZ = z + offsetZ

                -- Validate against the zone's navmesh
                if zone:isNavigablePoint({ x = testX, y = y, z = testZ }) then
                    return {
                        x = testX,
                        y = y,
                        z = testZ,
                        rot = math.random(0, 255),
                    }
                else
                    -- Offset invalid, use exact anchor position (known good)
                    return {
                        x = x,
                        y = y,
                        z = z,
                        rot = math.random(0, 255),
                    }
                end
            end
        end
    end

    return nil
end

-----------------------------------
-- Convert world coordinates to FFXI map grid notation (e.g. "H-6").
-- Each zone has different coordinate extents so we use a per-zone bounds
-- table derived from zone NPC/mob positions.  Bounds are estimates —
-- they're accurate enough for a GM to locate a mob on the in-game map.
-- Column A = west edge, P = east edge.  Row 1 = north, 16 = south.
-----------------------------------
local _zoneBounds =
{
    -- { minX, maxX, minZ, maxZ }  (Z increases going south)
    -- ── Original Zones ───────────────────────────────────────────────
    [100] = { -700,  700, -700,  700 },   -- West Ronfaure
    [101] = {  100,  600, -100,  700 },   -- East Ronfaure
    [102] = { -650,  600, -600,  800 },   -- La Theine Plateau
    [103] = { -800, 1000, -550,  300 },   -- Valkurm Dunes
    [104] = { -250,  700, -650,  700 },   -- Jugner Forest
    [105] = { -800,  150,    0,  600 },   -- Batallia Downs
    [106] = { -700,  800, -100,  750 },   -- North Gustaberg
    [107] = {  100,  900, -800,    0 },   -- South Gustaberg
    [108] = { -400,  400,  -50,  550 },   -- Konschtat Highlands
    [109] = {  250,  700, -200,  850 },   -- Pashhow Marshlands
    [110] = { -800,  450, -600,  650 },   -- Rolanberry Fields
    [111] = { -550,  450, -700,  500 },   -- Beaucedine Glacier
    [112] = { -500,  750, -700,  600 },   -- Xarcabard
    [113] = { -450,  300, -350,  700 },   -- Cape Teriggan
    [114] = { -450,  400, -500,  600 },   -- Eastern Altepa Desert
    [115] = { -200,  600, -350,  900 },   -- West Sarutabaruta
    [116] = { -200,  600, -350,  900 },   -- East Sarutabaruta
    [117] = { -500,  450, -600,  550 },   -- Tahrongi Canyon
    [118] = { -750,  350, -400,  350 },   -- Buburimu Peninsula
    [119] = { -450,  800, -800,  650 },   -- Meriphataud Mountains
    [120] = {    0,  850, -600,  600 },   -- Sauromugue Champaign
    [121] = { -500,  500, -500,  500 },   -- Sanctuary of Zi'Tah
    [122] = { -500,  500, -500,  500 },   -- Ro'Maeve
    [123] = { -750,  550, -700,  700 },   -- Yuhtunga Jungle
    [124] = { -700,  750, -700,  450 },   -- Yhoator Jungle
    [125] = { -950,  700, -900,  600 },   -- Western Altepa Desert
    [126] = { -600,  350, -450,  550 },   -- Qufim Island
    [127] = { -600,  600, -600,  600 },   -- Behemoth's Dominion
    [128] = { -600,  600, -600,  600 },   -- Valley of Sorrows
    -- ── Chains of Promathia ──────────────────────────────────────────
    [ 24] = { -650,  550, -500,  400 },   -- Lufaise Meadows
    [ 25] = { -650,  400, -100,  700 },   -- Misareaux Coast
    -- ── Treasures of Aht Urhgan ──────────────────────────────────────
    [ 51] = { -800,  400, -850,  800 },   -- Wajaom Woodlands
    [ 52] = { -550,  500, -950,  750 },   -- Bhaflau Thickets
    [ 61] = { -650,  800, -700,  500 },   -- Mount Zhayolm
    [ 65] = { -400,  350, -450,  100 },   -- Mamook
    [ 68] = { -500,  500, -500,  500 },   -- Aydeewa Subterrane
    [ 79] = { -900,  900, -900,  800 },   -- Caedarva Mire
    -- ── Wings of the Goddess [S] ─────────────────────────────────────
    [ 81] = {  100,  600, -100,  700 },   -- East Ronfaure [S]
    [ 82] = { -250,  700, -650,  700 },   -- Jugner Forest [S]
    [ 83] = { -500,  500, -500,  500 },   -- Vunkerl Inlet [S]
    [ 84] = { -800,  150,    0,  600 },   -- Batallia Downs [S]
    [ 88] = { -700,  800, -100,  750 },   -- North Gustaberg [S]
    [ 89] = { -500,  500, -500,  500 },   -- Grauberg [S]
    [ 90] = {  250,  700, -200,  850 },   -- Pashhow Marshlands [S]
    [ 91] = { -800,  450, -600,  650 },   -- Rolanberry Fields [S]
    [ 95] = { -200,  600, -350,  900 },   -- West Sarutabaruta [S]
    [ 97] = { -450,  800, -800,  650 },   -- Meriphataud Mountains [S]
    [ 98] = {    0,  850, -600,  600 },   -- Sauromugue Champaign [S]
    [136] = { -550,  450, -700,  500 },   -- Beaucedine Glacier [S]
    [137] = { -500,  750, -700,  600 },   -- Xarcabard [S]
    -- ── Seekers of Adoulin ───────────────────────────────────────────
    [260] = { -400,  550, -400,  250 },   -- Yahse Hunting Grounds
    [261] = { -550,  450, -500,  400 },   -- Ceizak Battlegrounds
}

xi.dynamicWorld.posToGrid = function(x, z, zoneId)
    local b = _zoneBounds[zoneId] or { -700, 700, -700, 700 }
    local minX, maxX, minZ, maxZ = b[1], b[2], b[3], b[4]
    local col = math.floor((x - minX) / ((maxX - minX) / 16.0)) + 1
    local row = math.floor((z - minZ) / ((maxZ - minZ) / 16.0)) + 1
    col = math.max(1, math.min(16, col))
    row = math.max(1, math.min(16, row))
    return string.format('%s-%d', string.char(64 + col), row)
end

-- Get zone's appropriate level range.
-- Priority: per-zone ZONE_LEVELS override > region levelRange > default.
xi.dynamicWorld.getZoneLevelRange = function(zoneId)
    -- 1. Check local ZONE_LEVELS table (C++ settings drops table values so we own this)
    if ZONE_LEVELS[zoneId] then
        return ZONE_LEVELS[zoneId]
    end

    -- 2. Fall back to region-level range
    local state = xi.dynamicWorld.state
    local regionName = state.zoneToRegion[zoneId]
    if regionName and state.regionData[regionName] then
        return state.regionData[regionName].levelRange
    end

    -- 3. Last resort default
    return { 20, 40 }
end

-- Get all zones in same region as given zone
xi.dynamicWorld.getRegionZones = function(zoneId)
    local state = xi.dynamicWorld.state
    local regionName = state.zoneToRegion[zoneId]
    if not regionName or not state.regionData[regionName] then
        return {}
    end
    return state.regionData[regionName].zones
end
