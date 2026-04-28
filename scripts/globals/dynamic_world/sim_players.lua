-----------------------------------
-- Dynamic World: Sim Players
-----------------------------------
-- Autonomous player-like entities that inhabit the world.
-- They roam zones, simulate hunting, accumulate gear and gil,
-- sell on the AH, die and respawn, and level over time.
--
-- They are TYPE_NPC dynamic entities with MODEL_EQUIPPED look strings,
-- so they render as player characters in-world. Their "activities"
-- (combat, looting, gear evaluation) are simulated on a tick rather
-- than through real server combat. This avoids all socket/packet
-- constraints while still producing a lived-in world.
--
-- State persistence:
--   Runtime  → server variables (DW_SIM_<name>_*)  [fast, integer-only]
--   Complex  → JSON files in data/sim_players/<name>.json [inventory, equip]
--
-- New C++ globals used:
--   SimPostAH(sellerName, sellerId, itemId, price, isStack)
--   SimGetRecentAHSale(itemId, isStack) -> price
-----------------------------------

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.simPlayers = xi.dynamicWorld.simPlayers or {}

local sim = xi.dynamicWorld.simPlayers

-----------------------------------
-- Helpers
-----------------------------------
local function getSetting(key)
    local s = xi.settings.dynamicworld
    return s and s[key]
end

local function svKey(name, field)
    return string.format('DW_SIM_%s_%s', name:upper():gsub('[^A-Z0-9]', ''), field)
end

local function svGet(name, field, default)
    local v = GetServerVariable(svKey(name, field))
    if v == nil or v == 0 then return default end
    return v
end

local function svSet(name, field, value)
    SetServerVariable(svKey(name, field), value or 0)
end

-----------------------------------
-- JSON file persistence
-- Stored in data/sim_players/<name>.json
-- Contains: inventory {[itemid]=qty}, equip {[slot]=itemid}
-----------------------------------
local DATA_DIR = 'data/sim_players/'

local function ensureDir()
    -- io.open with 'a' will create the file but not the dir;
    -- we rely on the directory being created once at setup.
    -- The first write attempt will fail gracefully if missing.
end

local function readJson(name)
    local path = DATA_DIR .. name .. '.json'
    local f = io.open(path, 'r')
    if not f then return { inventory = {}, equip = {} } end
    local raw = f:read('*a')
    f:close()

    -- Minimal JSON parser for our simple format.
    -- We write the JSON ourselves so we know its exact shape.
    local data = { inventory = {}, equip = {} }

    -- Extract inventory section: "inventory":{"12345":3,"12346":1}
    local invSection = raw:match('"inventory"%s*:%s*(%b{})')
    if invSection then
        for id, qty in invSection:gmatch('"(%d+)"%s*:%s*(%d+)') do
            data.inventory[tonumber(id)] = tonumber(qty)
        end
    end

    -- Extract equip section: "equip":{"0":12345,"4":12346}
    local eqSection = raw:match('"equip"%s*:%s*(%b{})')
    if eqSection then
        for slot, id in eqSection:gmatch('"(%d+)"%s*:%s*(%d+)') do
            data.equip[tonumber(slot)] = tonumber(id)
        end
    end

    return data
end

local function writeJson(name, data)
    -- Ensure data directory exists (best-effort)
    os.execute('mkdir -p ' .. DATA_DIR)

    local path = DATA_DIR .. name .. '.json'
    local f = io.open(path, 'w')
    if not f then return end

    -- Inventory
    local invParts = {}
    for id, qty in pairs(data.inventory) do
        invParts[#invParts + 1] = string.format('"%d":%d', id, qty)
    end

    -- Equip
    local eqParts = {}
    for slot, id in pairs(data.equip) do
        eqParts[#eqParts + 1] = string.format('"%d":%d', slot, id)
    end

    f:write(string.format(
        '{"inventory":{%s},"equip":{%s}}\n',
        table.concat(invParts, ','),
        table.concat(eqParts, ',')
    ))
    f:close()
end

-----------------------------------
-- Look string generation
-- Format: 40-char hex string (10 × uint16 groups of 4 hex chars).
-- Each group is written big-endian then byte-swapped internally:
--   "XXYY" in string → value 0xXXYY → swap → 0xYYXX stored.
--
-- Group layout:
--   [0] size  → "0100" = MODEL_EQUIPPED (1)
--   [1] face(hi) + race(lo)  → string.format("%02X%02X", face, race)
--   [2] head, [3] body, [4] hands, [5] legs, [6] feet
--   [7] main,  [8] sub,  [9] ranged
-----------------------------------
local function buildLookString(race, face, head, body, hands, legs, feet, main, sub, ranged)
    local function g(hi, lo)
        return string.format('%04X', (hi * 256 + lo))
    end
    local function gItem(id)
        -- Item IDs in look slots: low byte first in group.
        -- "LLOHI" → 0xHILO after internal swap → id = HI*256+LO
        local hi = math.floor(id / 256)
        local lo = id % 256
        return string.format('%02X%02X', lo, hi)
    end

    return '0100'
        .. g(face or 1, race or 1)
        .. gItem(head   or 0)
        .. gItem(body   or 0)
        .. gItem(hands  or 0)
        .. gItem(legs   or 0)
        .. gItem(feet   or 0)
        .. gItem(main   or 0)
        .. gItem(sub    or 0)
        .. gItem(ranged or 0)
end

-----------------------------------
-- XP table (total XP to reach each level)
-- Simplified — roughly follows FFXI's curve.
-----------------------------------
local XP_TO_LEVEL = {}
do
    local xp = 0
    local base = 100
    for i = 1, 75 do
        XP_TO_LEVEL[i] = xp
        xp = xp + math.floor(base * (1 + (i - 1) * 0.18))
    end
end

local function xpForLevel(lvl)
    return XP_TO_LEVEL[math.min(lvl, 75)] or XP_TO_LEVEL[75]
end

-----------------------------------
-- Sim player roster
-----------------------------------
-- Each entry defines one persistent autonomous player.
-- fakeId must be unique and well above real charid range (9,000,000+).
-- archetype: 'melee' | 'mage' | 'support' | 'ranger' | 'thief'
--   Affects preferred gear, combat style, and loot priorities.
-----------------------------------
local ROSTER =
{
    {
        name      = 'Thalindra',
        race      = 4,          -- xi.race.ELVAAN_F
        face      = 2,
        job       = 7,          -- xi.job.WHM
        nation    = 1,          -- xi.nation.SANDORIA
        archetype = 'support',
        homeZone  = 100,        -- West Ronfaure
        fakeId    = 9000001,
        startLevel = 15,
        personality = 'meticulous',  -- flavour for log messages
    },
    {
        name      = 'Brukkaz',
        race      = 8,          -- xi.race.GALKA
        face      = 0,
        job       = 1,          -- xi.job.WAR
        nation    = 2,          -- xi.nation.BASTOK
        archetype = 'melee',
        homeZone  = 106,        -- North Gustaberg
        fakeId    = 9000002,
        startLevel = 20,
        personality = 'brash',
    },
    {
        name      = 'Shivari',
        race      = 7,          -- xi.race.MITHRA
        face      = 3,
        job       = 6,          -- xi.job.THF
        nation    = 2,          -- xi.nation.BASTOK
        archetype = 'thief',
        homeZone  = 103,        -- Valkurm Dunes
        fakeId    = 9000003,
        startLevel = 25,
        personality = 'sly',
    },
    {
        name      = 'Ozric',
        race      = 1,          -- xi.race.HUME_M
        face      = 5,
        job       = 4,          -- xi.job.BLM
        nation    = 3,          -- xi.nation.WINDURST
        archetype = 'mage',
        homeZone  = 115,        -- West Sarutabaruta
        fakeId    = 9000004,
        startLevel = 30,
        personality = 'scholarly',
    },
}

-----------------------------------
-- Runtime state table
-- Keyed by sim player name.  Populated at init from server vars + JSON files.
-----------------------------------
local state = {}

-----------------------------------
-- Loot value table
-- Approximate market values for common dynamic world drop categories.
-- Used to decide what to sell vs. keep.
-----------------------------------
local SELL_THRESHOLD_GIL = 500  -- items worth less than this just get discarded

-----------------------------------
-- Gear tiers: approximate item IDs for basic gear by tier and slot.
-- Tier 0 = starter gear, Tier 5 = high-end.
-- These are representative item IDs from the game's actual item tables.
-- Sim players "find" items from these tables based on kill tier.
-- Slot keys: head, body, hands, legs, feet, main, sub
-----------------------------------
local GEAR_TIERS =
{
    -- Tier 0-1: Starter through Dunes (level 1-20)
    [0] = {
        melee   = { main = 16393, body = 13505, legs = 13507, feet = 13508 },
        mage    = { main = 17441, body = 14081, legs = 14083 },
        support = { main = 17441, body = 14081 },
        thief   = { main = 16645, body = 13505 },
        ranger  = { main = 18817, legs = 13507 },
    },
    -- Tier 1-2: Post-dunes (level 20-40)
    [1] = {
        melee   = { main = 16449, head = 13073, body = 13313, legs = 13315, feet = 13316 },
        mage    = { main = 17473, head = 13825, body = 13825 },
        support = { main = 17473, head = 13825 },
        thief   = { main = 16647, head = 13073, body = 13313 },
        ranger  = { main = 18835, head = 13073 },
    },
    -- Tier 2-3: Mid-range (level 40-55)
    [2] = {
        melee   = { main = 16513, head = 13089, body = 13329, hands = 13331, legs = 13332 },
        mage    = { main = 17505, head = 13841, body = 13841 },
        support = { main = 17505, head = 13841 },
        thief   = { main = 16705, head = 13089 },
        ranger  = { main = 18849, head = 13089 },
    },
    -- Tier 3-4: Endgame approach (level 55-70)
    [3] = {
        melee   = { main = 16577, head = 13105, body = 13345, hands = 13347, legs = 13348, feet = 13350 },
        mage    = { main = 17537, head = 13857 },
        support = { main = 17537, head = 13857 },
        thief   = { main = 16769, head = 13105 },
        ranger  = { main = 18867, head = 13105 },
    },
    -- Tier 4-5: Endgame / 75 gear (level 70-75)
    [4] = {
        melee   = { main = 16641, head = 13121, body = 13361, hands = 13363, legs = 13364, feet = 13366 },
        mage    = { main = 17569, head = 13873, body = 13873 },
        support = { main = 17569, head = 13873 },
        thief   = { main = 16835, head = 13121 },
        ranger  = { main = 18881, head = 13121 },
    },
}

-- Stat bonuses granted by each gear tier (applied as mob mods to the entity)
local TIER_STAT_BONUS =
{
    [0] = { att = 0,  def = 0,  acc = 0,  hp = 0   },
    [1] = { att = 15, def = 12, acc = 8,  hp = 50  },
    [2] = { att = 35, def = 28, acc = 18, hp = 120 },
    [3] = { att = 60, def = 50, acc = 30, hp = 250 },
    [4] = { att = 95, def = 80, acc = 45, hp = 420 },
    [5] = { att = 140, def = 115, acc = 65, hp = 650 },
}

-----------------------------------
-- Activity flavour messages
-- Broadcast to the zone occasionally so real players see them being "active"
-----------------------------------
local HUNT_MESSAGES =
{
    melee   = { '%s engages %s and cuts it down.', '%s charges headlong into %s.', '%s finishes off %s with a decisive blow.' },
    mage    = { '%s weaves a spell and %s collapses.', '%s silences %s with a burst of magic.', '%s reduces %s to ashes.' },
    support = { '%s supports the attack and %s falls.', '%s heals through the fight with %s and wins.', '%s buffs up and dispatches %s cleanly.' },
    thief   = { '%s shadows %s and lands a critical hit.', '%s steals an opening and drops %s.', '%s vanishes and %s is left confused.' },
    ranger  = { '%s peppers %s from range.', '%s lines up a perfect shot on %s.', '%s fires and %s never gets close.' },
}

local DEATH_MESSAGES =
{
    '%s is defeated and retreats to recover.',
    '%s falls in battle and needs time to recover.',
    '%s pushed too hard and paid for it.',
    '%s will be back — probably.',
}

local RESPAWN_MESSAGES =
{
    '%s returns to the field, ready to fight again.',
    '%s has recovered and is back in action.',
    '%s rises again, more cautious this time.',
    '%s is back on their feet.',
}

local function pickMessage(tbl, ...)
    local t = tbl[math.random(#tbl)]
    return string.format(t, ...)
end

-----------------------------------
-- Resolve which zone-appropriate mob name to use in messages
-----------------------------------
local ZONE_MOB_NAMES =
{
    [100] = { 'Orc', 'Forest Hare', 'Goblin Bandit', 'Wild Rabbit' },
    [101] = { 'Orc', 'Giant Bee', 'Goblin Digger', 'Wild Rabbit' },
    [102] = { 'Goblin', 'La Theine Coeurl', 'Hill Lizard', 'Dhalmel' },
    [103] = { 'Goblin', 'Snipper', 'Damselfly', 'Pugil' },
    [104] = { 'Orc', 'Goblin', 'Skeleton', 'Goobbue' },
    [105] = { 'Orc', 'Goobbue', 'Skeleton', 'Goblin Shaman' },
    [106] = { 'Quadav', 'Goblin Digger', 'Mining Beetle', 'Goblin Bandit' },
    [107] = { 'Quadav', 'Wight', 'Goblin Alchemist', 'Mining Beetle' },
    [108] = { 'Quadav', 'Goblin', 'Manticore', 'Giant Bat' },
    [109] = { 'Quadav', 'Goblin Leecher', 'Marsh Murex', 'River Crab' },
    [110] = { 'Quadav', 'Goblin', 'Treant', 'Worker Crawler' },
    [115] = { 'Yagudo', 'Goblin Bandit', 'Funguar', 'Clipper' },
    [116] = { 'Yagudo', 'Goblin', 'Mandragora', 'Goobbue' },
    [117] = { 'Yagudo', 'Goblin', 'Canyon Crawler', 'Rock Lizard' },
    [118] = { 'Yagudo', 'Goblin Leecher', 'Boggart', 'Goblin Bandit' },
    [119] = { 'Yagudo', 'Goblin', 'Dhalmel', 'Cockatrice' },
    [120] = { 'Yagudo', 'Goblin', 'Goobbue', 'Morbol' },
}

local function getZoneMobName(zoneId)
    local names = ZONE_MOB_NAMES[zoneId]
    if names then return names[math.random(#names)] end
    return 'monster'
end

-----------------------------------
-- State variable accessors
-----------------------------------
local function getLevel(sp)    return svGet(sp.name, 'LV', sp.startLevel or 1) end
local function getXP(sp)       return svGet(sp.name, 'XP', 0) end
local function getHP(sp)       return svGet(sp.name, 'HP', 100) end
local function getMaxHP(sp)    return svGet(sp.name, 'MHP', math.floor(50 + getLevel(sp) * 8)) end
local function getGil(sp)      return svGet(sp.name, 'GIL', 0) end
local function getGearTier(sp) return svGet(sp.name, 'TIER', 0) end
local function getZone(sp)     return svGet(sp.name, 'ZONE', sp.homeZone) end
local function isDead(sp)      return svGet(sp.name, 'DEAD', 0) == 1 end
local function getDeathTime(sp)return svGet(sp.name, 'DT', 0) end

local function setLevel(sp, v)    svSet(sp.name, 'LV', v) end
local function setXP(sp, v)       svSet(sp.name, 'XP', v) end
local function setHP(sp, v)       svSet(sp.name, 'HP', math.max(0, v)) end
local function setMaxHP(sp, v)    svSet(sp.name, 'MHP', v) end
local function setGil(sp, v)      svSet(sp.name, 'GIL', math.max(0, v)) end
local function setGearTier(sp, v) svSet(sp.name, 'TIER', v) end
local function setZone(sp, v)     svSet(sp.name, 'ZONE', v) end
local function setDead(sp, isDead, deathTime)
    svSet(sp.name, 'DEAD', isDead and 1 or 0)
    svSet(sp.name, 'DT',   deathTime or 0)
end

-----------------------------------
-- Inventory helpers (JSON-backed)
-----------------------------------
local function loadData(sp)
    if not state[sp.name] then
        state[sp.name] = readJson(sp.name)
    end
    return state[sp.name]
end

local function saveData(sp)
    if state[sp.name] then
        writeJson(sp.name, state[sp.name])
    end
end

local function addToInventory(sp, itemId, qty)
    local data = loadData(sp)
    data.inventory[itemId] = (data.inventory[itemId] or 0) + (qty or 1)
end

local function removeFromInventory(sp, itemId, qty)
    local data = loadData(sp)
    local current = data.inventory[itemId] or 0
    local newQty = math.max(0, current - (qty or current))
    if newQty == 0 then
        data.inventory[itemId] = nil
    else
        data.inventory[itemId] = newQty
    end
end

local function getInventoryCount(sp, itemId)
    local data = loadData(sp)
    return data.inventory[itemId] or 0
end

local function getEquipped(sp, slot)
    local data = loadData(sp)
    return data.equip[slot] or 0
end

local function setEquipped(sp, slot, itemId)
    local data = loadData(sp)
    data.equip[slot] = itemId
end

-----------------------------------
-- Entity tracking (in-world entities)
-----------------------------------
local entities = {}   -- name → entity object (or nil if not spawned)

local function getEntity(sp)
    return entities[sp.name]
end

local function applyGearStats(sp, entity)
    if not entity then return end

    local tier = math.min(getGearTier(sp), 5)
    local bonus = TIER_STAT_BONUS[tier] or TIER_STAT_BONUS[0]

    -- Clear previous mods before applying (use 0 base then add delta)
    -- We track prev tier so we can remove old bonus first
    local prevTier = svGet(sp.name, 'PREV_TIER', -1)
    if prevTier >= 0 then
        local prev = TIER_STAT_BONUS[prevTier] or TIER_STAT_BONUS[0]
        if entity.addMod then
            entity:addMod(xi.mod.ATT, -(prev.att))
            entity:addMod(xi.mod.DEF, -(prev.def))
            entity:addMod(xi.mod.ACC, -(prev.acc))
            entity:addMod(xi.mod.HP,  -(prev.hp))
        end
    end

    if entity.addMod then
        entity:addMod(xi.mod.ATT, bonus.att)
        entity:addMod(xi.mod.DEF, bonus.def)
        entity:addMod(xi.mod.ACC, bonus.acc)
        entity:addMod(xi.mod.HP,  bonus.hp)
    end

    svSet(sp.name, 'PREV_TIER', tier)
end

local function buildEntityLook(sp)
    local data = loadData(sp)
    local e    = data.equip
    return buildLookString(
        sp.race, sp.face,
        e[4] or 0,  -- head
        e[5] or 0,  -- body
        e[6] or 0,  -- hands (slot 6 = hands)
        e[7] or 0,  -- legs
        e[8] or 0,  -- feet
        e[0] or 0,  -- main
        e[1] or 0,  -- sub
        e[2] or 0   -- ranged
    )
end

-----------------------------------
-- Spawn / despawn
-----------------------------------
local function spawnSimPlayer(sp)
    local zoneId = getZone(sp)
    local zone   = GetZone(zoneId)
    if not zone then return end

    local pos = xi.dynamicWorld.getRandomSpawnPoint(zone)
    if not pos then return end

    local name = sp.name

    local entity = zone:insertDynamicEntity(
    {
        objtype              = xi.objType.NPC,
        name                 = 'SIM_' .. name,
        packetName           = name,
        x                    = pos.x,
        y                    = pos.y,
        z                    = pos.z,
        rotation             = pos.rot,
        look                 = buildEntityLook(sp),
        releaseIdOnDisappear = true,

        onTrigger = function(npc, player)
            -- Players can /check or talk to sim players
            local lvl  = getLevel(sp)
            local tier = getGearTier(sp)
            player:printToPlayer(
                string.format(
                    '[%s] Level %d. Gear tier %d. %s',
                    name, lvl, tier,
                    isDead(sp) and 'Currently recovering.' or 'Looking for a fight.'
                ),
                xi.msg.channel.SYSTEM_3
            )
        end,
    })

    if not entity then return end

    entity:setSpawn(pos.x, pos.y, pos.z, pos.rot)
    entity:spawn()

    applyGearStats(sp, entity)
    entities[name] = entity
end

local function despawnSimPlayer(sp)
    local entity = getEntity(sp)
    if entity and entity.despawn then
        entity:despawn()
    end
    entities[sp.name] = nil
end

-----------------------------------
-- Death handling
-----------------------------------
local RESPAWN_SECONDS = 300  -- 5 minutes; configurable

local function killSimPlayer(sp)
    if isDead(sp) then return end

    setDead(sp, true, os.time())
    setHP(sp, 0)

    local zone = GetZone(getZone(sp))
    if zone then
        xi.dynamicWorld.announceZone(zone,
            string.format('[Sim] %s', pickMessage(DEATH_MESSAGES, sp.name)))
    end

    -- Remove from world while dead
    despawnSimPlayer(sp)
end

local function respawnSimPlayer(sp)
    if not isDead(sp) then return end

    setDead(sp, false, 0)

    -- Restore HP to 50% on respawn (harsh, but FFXI-appropriate)
    local newMaxHp = math.floor(50 + getLevel(sp) * 8)
    setMaxHP(sp, newMaxHp)
    setHP(sp, math.floor(newMaxHp * 0.5))

    local zone = GetZone(getZone(sp))
    if zone then
        xi.dynamicWorld.announceZone(zone,
            string.format('[Sim] %s', pickMessage(RESPAWN_MESSAGES, sp.name)))
    end

    spawnSimPlayer(sp)
end

-----------------------------------
-- Leveling
-----------------------------------
local function checkLevelUp(sp)
    local lvl = getLevel(sp)
    if lvl >= 75 then return end

    local xp        = getXP(sp)
    local xpNeeded  = xpForLevel(lvl + 1)
    local didLevel  = false

    while lvl < 75 and xp >= xpForLevel(lvl + 1) do
        lvl    = lvl + 1
        didLevel = true
    end

    if didLevel then
        setLevel(sp, lvl)
        setXP(sp, xp)

        -- Update max HP
        local newMaxHp = math.floor(50 + lvl * 8)
        setMaxHP(sp, newMaxHp)

        local zone = GetZone(getZone(sp))
        if zone then
            xi.dynamicWorld.announceZone(zone,
                string.format('[Sim] %s has reached level %d!', sp.name, lvl))
        end

        -- Check if gear tier should increase
        local newTier = math.min(5, math.floor(lvl / 15))
        if newTier > getGearTier(sp) then
            setGearTier(sp, newTier)
            applyGearStats(sp, getEntity(sp))

            -- Grant representative gear items for the new tier
            local tierGear = GEAR_TIERS[newTier - 1]
            if tierGear and tierGear[sp.archetype] then
                for slot, itemId in pairs(tierGear[sp.archetype]) do
                    addToInventory(sp, itemId, 1)
                end
            end
            saveData(sp)
        end
    end
end

-----------------------------------
-- Simulated combat encounter
-- Returns: won (bool), xpGained (int), gilGained (int), loot (table of {id,qty})
-----------------------------------
local function simulateCombat(sp)
    local lvl  = getLevel(sp)
    local tier = getGearTier(sp)

    -- Effectiveness modifier: gear quality + level relative to zone
    local zoneId    = getZone(sp)
    local zoneRange = xi.dynamicWorld.getZoneLevelRange(zoneId)
    local zoneMid   = zoneRange and math.floor((zoneRange[1] + zoneRange[2]) / 2) or 30

    local levelDelta = lvl - zoneMid
    -- Win chance: 70% baseline, ±2% per level difference, +5% per gear tier
    local winChance = 0.70 + (levelDelta * 0.02) + (tier * 0.05)
    winChance = math.max(0.10, math.min(0.97, winChance))

    local won = math.random() < winChance

    if won then
        -- XP: 100-250 base, scaled by zone level
        local xpBase = math.random(100, 250) + math.floor(zoneMid * 0.8)
        -- Gil: 50-300 base
        local gilBase = math.random(50, 300) + tier * 50

        -- Simple loot: use dynamic world loot tables if available
        local loot = {}
        if xi.dynamicWorld.loot and xi.dynamicWorld.loot.roll then
            -- roll against a tier-appropriate loot table
            local rollTier = math.min(tier + 1, 5)
            local dropped = xi.dynamicWorld.loot.roll(rollTier)
            if dropped then
                for _, item in ipairs(dropped) do
                    loot[#loot + 1] = { id = item.id, qty = item.qty or 1 }
                end
            end
        else
            -- Fallback: random gil bonus only
            gilBase = gilBase + math.random(0, 100)
        end

        return true, xpBase, gilBase, loot
    else
        -- Loss: take damage
        local dmgPct = math.random(15, 45) / 100  -- lose 15-45% HP
        local dmg    = math.floor(getMaxHP(sp) * dmgPct)
        return false, 0, 0, {}, dmg
    end
end

-----------------------------------
-- AH selling logic
-----------------------------------
-- Items with more than KEEP_QTY copies get listed on AH.
-- Price = recent sale price * 90% (undercutting), or BaseSell * 3 if no data.
-----------------------------------
local KEEP_QTY = 1   -- always keep at least 1 of each item

local function evaluateAH(sp)
    local data = loadData(sp)
    local sold = false

    for itemId, qty in pairs(data.inventory) do
        if qty > KEEP_QTY then
            local sellQty = qty - KEEP_QTY
            local recentPrice = SimGetRecentAHSale(itemId, false)
            local price = recentPrice > 0
                and math.floor(recentPrice * 0.9)
                or  math.random(200, 2000)   -- no data: rough random price

            if price >= SELL_THRESHOLD_GIL then
                SimPostAH(sp.name, sp.fakeId, itemId, price, false)
                removeFromInventory(sp, itemId, sellQty)
                sold = true
            end
        end
    end

    if sold then saveData(sp) end
end

-----------------------------------
-- Zone migration
-- Sim players occasionally move to a new zone appropriate for their level.
-----------------------------------
local MIGRATE_CHANCE = 0.08   -- 8% chance per slow tick

local LEVEL_ZONES =
{
    -- { minLevel, maxLevel, zoneIds... }
    { 1,  15,  { 100, 101, 106, 107, 115, 116 } },
    { 15, 25,  { 102, 103, 108, 117, 118, 126 } },
    { 25, 40,  { 104, 109, 119, 120 } },
    { 40, 55,  { 105, 110, 121, 122 } },
    { 55, 70,  { 111, 112, 123, 124, 125 } },
    { 70, 75,  { 127, 128 } },
}

local function pickZoneForLevel(lvl)
    local eligible = {}
    for _, entry in ipairs(LEVEL_ZONES) do
        if lvl >= entry[1] and lvl < entry[2] then
            for _, zid in ipairs(entry[3]) do
                eligible[#eligible + 1] = zid
            end
        end
    end
    if #eligible == 0 then return nil end
    return eligible[math.random(#eligible)]
end

local function maybeMigrate(sp)
    if math.random() > MIGRATE_CHANCE then return end

    local newZone = pickZoneForLevel(getLevel(sp))
    if not newZone or newZone == getZone(sp) then return end

    despawnSimPlayer(sp)
    setZone(sp, newZone)
    spawnSimPlayer(sp)
end

-----------------------------------
-- Main tick  (called every FAST_INTERVAL seconds)
-----------------------------------
local FAST_INTERVAL   = 60    -- combat/HP/XP tick
local SLOW_INTERVAL   = 300   -- AH/gear/migration tick

local lastSlowTick = 0

sim.tick = function()
    if not getSetting('SIM_PLAYERS_ENABLED') then return end

    local now = os.time()
    local doSlow = (now - lastSlowTick) >= SLOW_INTERVAL

    for _, sp in ipairs(ROSTER) do
        -- ── Dead → respawn check ──────────────────────────────────────────
        if isDead(sp) then
            local dt = getDeathTime(sp)
            if dt > 0 and (now - dt) >= RESPAWN_SECONDS then
                respawnSimPlayer(sp)
            end

        -- ── Alive → simulate activity ─────────────────────────────────────
        else
            -- Make sure entity is in world (may have been wiped on server restart)
            if not getEntity(sp) then
                spawnSimPlayer(sp)
            end

            -- Run 1-3 combat encounters this tick
            local encounters = math.random(1, 3)
            local totalXP    = 0
            local totalGil   = 0

            for _ = 1, encounters do
                local won, xpGain, gilGain, loot, dmg = simulateCombat(sp)

                if won then
                    totalXP  = totalXP  + xpGain
                    totalGil = totalGil + gilGain

                    -- Add loot to inventory
                    for _, drop in ipairs(loot) do
                        addToInventory(sp, drop.id, drop.qty)
                    end

                    -- Occasionally announce the kill (1-in-6 chance per win)
                    if math.random(6) == 1 then
                        local zone = GetZone(getZone(sp))
                        if zone then
                            local mobName = getZoneMobName(getZone(sp))
                            local msgs    = HUNT_MESSAGES[sp.archetype] or HUNT_MESSAGES.melee
                            xi.dynamicWorld.announceZone(zone,
                                string.format('[Sim] %s',
                                    pickMessage(msgs, sp.name, mobName)))
                        end
                    end
                else
                    -- Take damage
                    local dmgTaken = dmg or 0
                    local newHp    = getHP(sp) - dmgTaken
                    setHP(sp, newHp)

                    if newHp <= 0 then
                        killSimPlayer(sp)
                        break  -- stop encounters for this tick
                    end
                end
            end

            -- Apply XP and gil gains
            if totalXP > 0 then
                setXP(sp, getXP(sp) + totalXP)
                checkLevelUp(sp)
            end
            if totalGil > 0 then
                setGil(sp, getGil(sp) + totalGil)
            end

            -- Regen HP slightly each tick (1/20th of max)
            if not isDead(sp) then
                local regen  = math.floor(getMaxHP(sp) / 20)
                local newHp  = math.min(getMaxHP(sp), getHP(sp) + regen)
                setHP(sp, newHp)
            end
        end

        -- ── Slow tick: AH + migration ─────────────────────────────────────
        if doSlow then
            if not isDead(sp) then
                evaluateAH(sp)
                maybeMigrate(sp)
            end
            saveData(sp)
        end
    end

    if doSlow then
        lastSlowTick = now
    end
end

-----------------------------------
-- Init
-----------------------------------
sim.init = function()
    if not getSetting('SIM_PLAYERS_ENABLED') then return end

    -- Ensure data directory exists
    os.execute('mkdir -p ' .. DATA_DIR)

    for _, sp in ipairs(ROSTER) do
        -- Bootstrap level if never set
        local existing = GetServerVariable(svKey(sp.name, 'LV'))
        if existing == 0 then
            setLevel(sp, sp.startLevel or 1)
            local newMaxHp = math.floor(50 + (sp.startLevel or 1) * 8)
            setMaxHP(sp, newMaxHp)
            setHP(sp, newMaxHp)
            setZone(sp, sp.homeZone)
        end

        -- Spawn in world if alive
        if not isDead(sp) then
            spawnSimPlayer(sp)
        end
    end

    -- Stagger slow tick so first pass doesn't fire immediately
    lastSlowTick = os.time() - math.random(0, SLOW_INTERVAL - 1)

    print(string.format('[DynWorld] Sim Players initialised: %d active personas', #ROSTER))
end

-----------------------------------
-- Public accessors (for GM commands)
-----------------------------------
sim.getRoster = function()
    return ROSTER
end

sim.getStatus = function(name)
    for _, sp in ipairs(ROSTER) do
        if sp.name == name then
            return {
                name      = sp.name,
                race      = sp.race,
                job       = sp.job,
                level     = getLevel(sp),
                xp        = getXP(sp),
                hp        = getHP(sp),
                maxHp     = getMaxHP(sp),
                gil       = getGil(sp),
                gearTier  = getGearTier(sp),
                zone      = getZone(sp),
                dead      = isDead(sp),
                deathTime = getDeathTime(sp),
                inventory = loadData(sp).inventory,
                equip     = loadData(sp).equip,
            }
        end
    end
    return nil
end

sim.forceRespawn = function(name)
    for _, sp in ipairs(ROSTER) do
        if sp.name == name then
            setDead(sp, false, 0)
            setHP(sp, getMaxHP(sp))
            spawnSimPlayer(sp)
            return true
        end
    end
    return false
end

sim.forceKill = function(name)
    for _, sp in ipairs(ROSTER) do
        if sp.name == name then
            killSimPlayer(sp)
            return true
        end
    end
    return false
end

sim.teleport = function(name, zoneId)
    for _, sp in ipairs(ROSTER) do
        if sp.name == name then
            despawnSimPlayer(sp)
            setZone(sp, zoneId)
            if not isDead(sp) then
                spawnSimPlayer(sp)
            end
            return true
        end
    end
    return false
end
