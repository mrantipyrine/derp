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

-----------------------------------
-- Utility: Safe settings access
-----------------------------------
local function getSetting(key)
    local settings = xi.settings.dynamicworld
    if settings == nil then
        return nil
    end
    return settings[key]
end

-----------------------------------
-- Initialize
-----------------------------------
xi.dynamicWorld.init = function()
    local settings = xi.settings.dynamicworld
    if not settings or not settings.ENABLED then
        printf('[DynamicWorld] System is DISABLED in settings.')
        return
    end

    local state = xi.dynamicWorld.state

    -- Build eligible zone lookup set
    state.eligibleZones = {}
    for _, zoneId in ipairs(settings.ELIGIBLE_ZONES or {}) do
        state.eligibleZones[zoneId] = true
    end

    -- Build region maps
    state.zoneToRegion = {}
    state.regionData = {}
    for regionName, regionInfo in pairs(settings.REGIONS or {}) do
        state.regionData[regionName] = {
            zones = regionInfo.zones or {},
            levelRange = regionInfo.levelRange or { 1, 75 },
        }
        for _, zoneId in ipairs(regionInfo.zones or {}) do
            state.zoneToRegion[zoneId] = regionName
        end
    end

    -- Initialize per-zone state
    state.zoneData = {}
    for zoneId, _ in pairs(state.eligibleZones) do
        state.zoneData[zoneId] = {
            entities    = {},           -- [targid] = { template, tier, spawnTime, ... }
            count       = 0,
            lastTick    = 0,
            lastRoamCheck = 0,
            pendingSpawns = 0,
        }
    end

    state.playerChains = {}
    state.globalCount = 0
    state.initialized = true
    state.running = true

    printf('[DynamicWorld] Initialized. %d eligible zones, %d regions.',
        xi.dynamicWorld.countKeys(state.eligibleZones),
        xi.dynamicWorld.countKeys(state.regionData))
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

-- Get a random valid spawn position from existing mobs in a zone.
-- Uses existing mob positions as known-good navmesh locations,
-- then validates the offset position with zone:isNavigablePoint().
xi.dynamicWorld.getRandomSpawnPoint = function(zone)
    local mobs = zone:getMobs()
    if mobs == nil then
        return nil
    end

    -- getMobs may return a table or userdata; handle both
    local mobList = {}
    for _, mob in pairs(mobs) do
        table.insert(mobList, mob)
    end

    if #mobList == 0 then
        return nil
    end

    -- Try up to 15 times to find a valid, navigable position
    for attempt = 1, math.min(15, #mobList) do
        local mob = mobList[math.random(#mobList)]
        if mob then
            local x = mob:getXPos()
            local y = mob:getYPos()
            local z = mob:getZPos()

            -- Skip (0,0,0) — often a default/invalid position
            if x ~= 0 or y ~= 0 or z ~= 0 then
                -- Add random offset to avoid stacking on the source mob
                local offsetX = math.random() * 8 - 4
                local offsetZ = math.random() * 8 - 4
                local testX = x + offsetX
                local testZ = z + offsetZ

                -- Validate against the zone's navmesh
                if zone:isNavigablePoint(testX, y, testZ) then
                    return {
                        x = testX,
                        y = y,
                        z = testZ,
                        rot = math.random(0, 255),
                    }
                else
                    -- Fallback: use exact mob position (guaranteed valid)
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

-- Get zone's appropriate level range based on region or existing mobs
xi.dynamicWorld.getZoneLevelRange = function(zoneId)
    local state = xi.dynamicWorld.state
    local regionName = state.zoneToRegion[zoneId]

    if regionName and state.regionData[regionName] then
        return state.regionData[regionName].levelRange
    end

    -- Fallback: use a mid-range default
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
