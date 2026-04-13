-----------------------------------
-- Dynamic World: Entity Templates
-----------------------------------
-- Defines the archetypes for dynamic world entities.
-- Each template specifies a mob_groups reference (groupId + groupZoneId)
-- for visual appearance, plus level scaling, behavior flags, and flavor.
--
-- IMPORTANT: groupId/groupZoneId must reference valid mob_groups rows
-- in YOUR database. The defaults below use common mobs found on most
-- FFXI servers. Adjust if your DB has different IDs.
--
-- To find valid group references:
--   SELECT groupid, zoneid, poolid, name, minLevel, maxLevel
--   FROM mob_groups WHERE name LIKE '%Tiger%';
-----------------------------------

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.templates = xi.dynamicWorld.templates or {}

-----------------------------------
-- Template Database
-- Each entry:
--   name           - Internal name (shown to GMs)
--   packetName     - Display name players see
--   groupRefs      - Array of { groupId, groupZoneId } entries. One is picked
--                    randomly at each spawn, giving visual variety (different
--                    mob_groups rows can reference different model sizes/variants).
--                    A single-entry array is fine if no variants exist.
--                    FALLBACK: groupRef = { groupId, groupZoneId } still works.
--
--   To find size variants for a mob family, query:
--     SELECT groupid, zoneid, name, minLevel
--       FROM mob_groups
--      WHERE name LIKE '%Rabbit%'
--      ORDER BY minLevel;
--   Lower-level entries often reference smaller models; higher-level = bigger.
--
--   tier           - Which tier(s) this template can be used for
--   levelOffset    - { min, max } added to zone's base level range
--   regions        - nil (all) or list of region names this can spawn in
--   behavior       - string key into behaviors table
--   lootTable      - string key into loot tables
--   isAggro        - Does it aggro?
--   expMultiplier  - Additional multiplier on top of tier multiplier
--   description    - Flavor text for GM tools
-----------------------------------

xi.dynamicWorld.templates.db = {}
local db = xi.dynamicWorld.templates.db

-----------------------------------
-- TIER 1: WANDERERS
-- Common mobs. Slightly tougher than normal, small EXP bonus.
-- Zone-bound, standard roaming.
-----------------------------------

db.empowered_hare =
{
    name            = 'Empowered Hare',
    packetName      = 'Empowered Hare',
    -- Multiple groupRefs = random visual variant picked each spawn.
    -- TODO: replace with real results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Rabbit%' OR name LIKE '%Hare%' ORDER BY minLevel;
    groupRefs = {
        { groupId = 6, groupZoneId = 100 },  -- Wild Rabbit (small, low lv)
        { groupId = 6, groupZoneId = 100 },  -- TODO: replace with mid-size rabbit variant
        { groupId = 6, groupZoneId = 100 },  -- TODO: replace with large rabbit variant
    },
    tier            = { xi.dynamicWorld.tier.WANDERER },
    levelOffset     = { 2, 5 },
    regions         = { 'ronfaure', 'sarutabaruta', 'gustaberg' },
    behavior        = 'wanderer_standard',
    lootTable       = 'wanderer_common',
    isAggro         = false,
    expMultiplier   = 1.0,
    description     = 'A rabbit crackling with strange energy. Tougher than it looks.',
}

db.frenzied_tiger =
{
    name            = 'Frenzied Tiger',
    packetName      = 'Frenzied Tiger',
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Tiger%' ORDER BY minLevel;
    groupRefs = {
        { groupId = 28, groupZoneId = 2 },   -- Forest Tiger (smaller/younger)
        { groupId = 28, groupZoneId = 2 },   -- TODO: mid-size tiger variant
        { groupId = 28, groupZoneId = 2 },   -- TODO: large tiger variant (e.g. Tigon, Sabertooth)
    },
    tier            = { xi.dynamicWorld.tier.WANDERER, xi.dynamicWorld.tier.NOMAD },
    levelOffset     = { 3, 7 },
    regions         = { 'ronfaure', 'midlands', 'elshimo' },
    behavior        = 'wanderer_aggressive',
    lootTable       = 'wanderer_uncommon',
    isAggro         = true,
    expMultiplier   = 1.1,
    description     = 'A tiger with bloodshot eyes and unnatural speed.',
}

db.glinting_beetle =
{
    name            = 'Glinting Beetle',
    packetName      = 'Glinting Beetle',
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Beetle%' OR name LIKE '%Crawler%' ORDER BY minLevel;
    groupRefs = {
        { groupId = 6, groupZoneId = 100 },  -- TODO: small beetle variant
        { groupId = 6, groupZoneId = 100 },  -- TODO: medium beetle variant
        { groupId = 6, groupZoneId = 100 },  -- TODO: large beetle variant
    },
    tier            = { xi.dynamicWorld.tier.WANDERER },
    levelOffset     = { 1, 4 },
    regions         = { 'gustaberg', 'midlands' },
    behavior        = 'wanderer_standard',
    lootTable       = 'wanderer_common',
    isAggro         = false,
    expMultiplier   = 1.0,
    description     = 'A beetle whose shell shimmers with an otherworldly sheen.',
}

db.emboldened_orc =
{
    name            = 'Emboldened Orc',
    packetName      = 'Emboldened Orc',
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Orc%' ORDER BY minLevel;
    -- Orcs have noticeably different models: Grunt (small) → Warrior → Brawler (large)
    groupRefs = {
        { groupId = 14, groupZoneId = 2 },  -- TODO: Orcish Grunt (small)
        { groupId = 14, groupZoneId = 2 },  -- TODO: Orcish Warrior (medium)
        { groupId = 14, groupZoneId = 2 },  -- TODO: Orcish Brawler (large/hulking)
    },
    tier            = { xi.dynamicWorld.tier.WANDERER, xi.dynamicWorld.tier.NOMAD },
    levelOffset     = { 3, 6 },
    regions         = { 'ronfaure', 'gustaberg', 'midlands' },
    behavior        = 'wanderer_aggressive',
    lootTable       = 'wanderer_uncommon',
    isAggro         = true,
    expMultiplier   = 1.1,
    description     = 'An orc scout, bolder than its kin, ranging far from the stronghold.',
}

-----------------------------------
-- TIER 2: NOMADS
-- Cross-zone roamers. Moderate power, good rewards.
-- Migrate between connected zones in their region.
-----------------------------------

db.vagrant_coeurl =
{
    name            = 'Vagrant Coeurl',
    packetName      = 'Vagrant Coeurl',
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Coeurl%' OR name LIKE '%Lynx%' ORDER BY minLevel;
    groupRefs = {
        { groupId = 9, groupZoneId = 7 },   -- TODO: smaller/younger coeurl variant
        { groupId = 9, groupZoneId = 7 },   -- TODO: standard coeurl
        { groupId = 9, groupZoneId = 7 },   -- TODO: large/elder coeurl variant
    },
    tier            = { xi.dynamicWorld.tier.NOMAD },
    levelOffset     = { 5, 10 },
    regions         = { 'midlands', 'elshimo', 'aradjiah' },
    behavior        = 'nomad_predator',
    lootTable       = 'nomad_predator',
    isAggro         = true,
    expMultiplier   = 1.0,
    description     = 'A coeurl with no territory, roaming between zones hunting prey.',
}

db.wandering_shade =
{
    name            = 'Wandering Shade',
    packetName      = 'Wandering Shade',
    -- Undead vary a lot visually. Mix Wight / Ghost / Specter models for variety.
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Wight%' OR name LIKE '%Ghost%' OR name LIKE '%Specter%'
    --   ORDER BY minLevel;
    groupRefs = {
        { groupId = 35, groupZoneId = 2 },  -- TODO: Wight (small wispy)
        { groupId = 35, groupZoneId = 2 },  -- TODO: Ghost variant (different silhouette)
        { groupId = 35, groupZoneId = 2 },  -- TODO: Specter / Wraith (larger)
    },
    tier            = { xi.dynamicWorld.tier.NOMAD },
    levelOffset     = { 5, 12 },
    regions         = nil,  -- Can appear anywhere
    behavior        = 'nomad_ghost',
    lootTable       = 'nomad_arcane',
    isAggro         = true,
    expMultiplier   = 1.2,
    description     = 'A restless spirit drifting between the boundaries of zones.',
}

db.treasure_goblin =
{
    name            = 'Treasure Goblin',
    packetName      = 'Treasure Goblin',
    -- Goblins have skinny/standard/big variants. Use them!
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Goblin%' ORDER BY minLevel LIMIT 20;
    groupRefs = {
        { groupId = 14, groupZoneId = 2 },  -- TODO: small goblin (Goblin Mugger / Robber type)
        { groupId = 14, groupZoneId = 2 },  -- TODO: standard goblin (Goblin Trader)
        { groupId = 14, groupZoneId = 2 },  -- TODO: chubby goblin (Goblin Butcher / large variant)
    },
    tier            = { xi.dynamicWorld.tier.NOMAD, xi.dynamicWorld.tier.ELITE },
    levelOffset     = { 0, 3 },
    regions         = nil,  -- Can appear anywhere
    behavior        = 'treasure_goblin',
    lootTable       = 'treasure_goblin',
    isAggro         = false,
    expMultiplier   = 0.5,      -- Low EXP, all about the loot
    description     = 'A goblin stuffed with treasure. It WILL try to run away.',
}

db.roaming_merchant =
{
    name            = 'Pilgrim Merchant',
    packetName      = 'Pilgrim Merchant',
    -- Merchants can appear as different beastman/humanoid types for flavor.
    -- TODO: ideally use actual NPC-type humanoid models. Query:
    --   SELECT groupid, zoneid, name FROM mob_groups
    --   WHERE name LIKE '%Goblin%Trader%' OR name LIKE '%Merchant%' LIMIT 10;
    groupRefs = {
        { groupId = 14, groupZoneId = 2 },  -- TODO: goblin merchant look
        { groupId = 14, groupZoneId = 2 },  -- TODO: alternative merchant look
    },
    tier            = { xi.dynamicWorld.tier.NOMAD },
    levelOffset     = { 0, 0 },
    regions         = nil,
    behavior        = 'nomad_merchant',
    lootTable       = 'none',
    isAggro         = false,
    expMultiplier   = 0,
    isMerchant      = true,     -- Special flag: spawns as NPC, not mob
    description     = 'A traveling merchant. Protect them for rare wares.',
}

-----------------------------------
-- TIER 3: ELITES
-- Rare, dangerous. High EXP, dynamic loot.
-- Can be zone-bound or regional.
-----------------------------------

db.dread_hunter =
{
    name            = 'Dread Hunter',
    packetName      = 'Dread Hunter',
    -- Elite coeurls. Higher-level coeurls tend to be larger models.
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Coeurl%' AND minLevel >= 40 ORDER BY minLevel;
    groupRefs = {
        { groupId = 17, groupZoneId = 7 },  -- TODO: large coeurl variant 1
        { groupId = 17, groupZoneId = 7 },  -- TODO: large coeurl variant 2
    },
    tier            = { xi.dynamicWorld.tier.ELITE },
    levelOffset     = { 8, 15 },
    regions         = { 'midlands', 'aradjiah', 'shadowreign' },
    behavior        = 'elite_hunter',
    lootTable       = 'elite_predator',
    isAggro         = true,
    expMultiplier   = 1.0,
    description     = 'An apex predator that has consumed too many crystals. Glows with malice.',
}

db.fell_commander =
{
    name            = 'Fell Commander',
    packetName      = 'Fell Commander',
    -- Commanders can be Orcs, Quadavs, or Yagudo depending on region. Mix for flavor.
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE (name LIKE '%Orc%' OR name LIKE '%Quadav%' OR name LIKE '%Yagudo%')
    --   AND minLevel >= 30 ORDER BY minLevel LIMIT 20;
    groupRefs = {
        { groupId = 14, groupZoneId = 2 },  -- TODO: Orc commander variant
        { groupId = 14, groupZoneId = 2 },  -- TODO: Quadav commander variant
        { groupId = 14, groupZoneId = 2 },  -- TODO: Yagudo commander variant
    },
    tier            = { xi.dynamicWorld.tier.ELITE },
    levelOffset     = { 10, 15 },
    regions         = { 'ronfaure', 'gustaberg', 'sarutabaruta', 'shadowreign' },
    behavior        = 'elite_commander',
    lootTable       = 'elite_beastman',
    isAggro         = true,
    expMultiplier   = 1.2,
    description     = 'A beastman war leader rallying scattered forces across the frontier.',
}

db.crystal_golem =
{
    name            = 'Crystal Golem',
    packetName      = 'Crystal Golem',
    -- Golems have very distinct size differences between families.
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Golem%' OR name LIKE '%Automaton%' OR name LIKE '%Puppet%'
    --   ORDER BY minLevel;
    groupRefs = {
        { groupId = 6, groupZoneId = 100 },  -- TODO: small/medium golem variant
        { groupId = 6, groupZoneId = 100 },  -- TODO: large/hulking golem variant
    },
    tier            = { xi.dynamicWorld.tier.ELITE },
    levelOffset     = { 10, 18 },
    regions         = { 'midlands', 'tavnazia' },
    behavior        = 'elite_tank',
    lootTable       = 'elite_arcane',
    isAggro         = true,
    expMultiplier   = 1.3,
    description     = 'A construct of fused crystals. Incredibly durable. Drops rare materials.',
}

db.storm_elemental =
{
    name            = 'Storm Nexus',
    packetName      = 'Storm Nexus',
    -- Mix elemental types for visual variety (they all look quite different!)
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Elemental%' ORDER BY name;
    groupRefs = {
        { groupId = 12, groupZoneId = 2 },  -- TODO: Thunder Elemental
        { groupId = 12, groupZoneId = 2 },  -- TODO: Fire Elemental (different glow)
        { groupId = 12, groupZoneId = 2 },  -- TODO: Ice Elemental (different glow)
        { groupId = 12, groupZoneId = 2 },  -- TODO: Dark Elemental (largest/scariest)
    },
    tier            = { xi.dynamicWorld.tier.ELITE },
    levelOffset     = { 5, 12 },
    regions         = nil,
    behavior        = 'elite_elemental',
    lootTable       = 'elite_elemental',
    isAggro         = true,
    expMultiplier   = 1.5,
    hasAura         = true,     -- Grants EXP buff to nearby players even before Apex
    description     = 'A convergence of elemental energy. Being near it empowers adventurers.',
}

-----------------------------------
-- TIER 4: APEX
-- Boss-tier. Massive rewards. Spawns minions.
-- Radiates EXP aura. Region-wide spawn.
-----------------------------------

db.void_wyrm =
{
    name            = 'Void Wyrm',
    packetName      = 'Void Wyrm',
    -- Dragons vary hugely in size. Mix wyrm types for variety.
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Wyrm%' OR name LIKE '%Dragon%' OR name LIKE '%Wyvern%'
    --   ORDER BY minLevel DESC LIMIT 15;
    groupRefs = {
        { groupId = 5, groupZoneId = 154 },  -- TODO: Fafnir-sized dragon (massive)
        { groupId = 5, groupZoneId = 154 },  -- TODO: medium wyrm variant
        { groupId = 5, groupZoneId = 154 },  -- TODO: wyvern variant (smaller, more agile look)
    },
    tier            = { xi.dynamicWorld.tier.APEX },
    levelOffset     = { 15, 25 },
    regions         = { 'midlands', 'aradjiah' },
    behavior        = 'apex_dragon',
    lootTable       = 'apex_dragon',
    isAggro         = true,
    expMultiplier   = 1.0,
    minionTemplate  = 'empowered_hare',     -- What it spawns as minions (overridden by behavior)
    description     = 'A wyrm torn from the void. The earth trembles in its wake.',
}

db.abyssal_demon =
{
    name            = 'Abyssal Tyrant',
    packetName      = 'Abyssal Tyrant',
    -- Demons come in multiple distinct models (Ahriman / Demon / Fomor).
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Demon%' OR name LIKE '%Fomor%' OR name LIKE '%Ahriman%'
    --   ORDER BY minLevel DESC LIMIT 15;
    groupRefs = {
        { groupId = 21, groupZoneId = 5 },  -- TODO: Dread Demon (large humanoid demon)
        { groupId = 21, groupZoneId = 5 },  -- TODO: Ahriman variant (floating eyeball demon)
        { groupId = 21, groupZoneId = 5 },  -- TODO: Fomor variant (ghost-demon hybrid)
    },
    tier            = { xi.dynamicWorld.tier.APEX },
    levelOffset     = { 15, 25 },
    regions         = { 'midlands', 'shadowreign' },
    behavior        = 'apex_demon',
    lootTable       = 'apex_demon',
    isAggro         = true,
    expMultiplier   = 1.2,
    minionTemplate  = 'wandering_shade',
    description     = 'A demon lord who tears open rifts, summoning shades from the beyond.',
}

db.ancient_king =
{
    name            = 'Ancient King',
    packetName      = 'Ancient King',
    -- Big boss types: Ogres, Giants, Titans. Noticeably different sizes.
    -- TODO: replace with results from:
    --   SELECT groupid, zoneid, name, minLevel FROM mob_groups
    --   WHERE name LIKE '%Ogre%' OR name LIKE '%Giant%' OR name LIKE '%Titan%'
    --   ORDER BY minLevel DESC LIMIT 15;
    groupRefs = {
        { groupId = 34, groupZoneId = 2 },  -- TODO: Ogre variant (medium huge)
        { groupId = 34, groupZoneId = 2 },  -- TODO: Giant variant (very large)
        { groupId = 34, groupZoneId = 2 },  -- TODO: Titan/colossus variant (massive)
    },
    tier            = { xi.dynamicWorld.tier.APEX },
    levelOffset     = { 12, 20 },
    regions         = nil,  -- Can appear anywhere
    behavior        = 'apex_king',
    lootTable       = 'apex_king',
    isAggro         = true,
    expMultiplier   = 1.5,
    minionTemplate  = 'emboldened_orc',
    description     = 'A forgotten king who walks again. Commands an army of the risen.',
}

-----------------------------------
-- Template Lookup Helpers
-----------------------------------

-- Get all templates valid for a given tier and region
xi.dynamicWorld.templates.getForTierAndRegion = function(tier, regionName)
    local results = {}
    for key, template in pairs(db) do
        -- Check tier match
        local tierMatch = false
        for _, t in ipairs(template.tier) do
            if t == tier then
                tierMatch = true
                break
            end
        end

        if tierMatch then
            -- Check region match
            if template.regions == nil then
                -- nil means available everywhere
                table.insert(results, { key = key, template = template })
            elseif regionName then
                for _, r in ipairs(template.regions) do
                    if r == regionName then
                        table.insert(results, { key = key, template = template })
                        break
                    end
                end
            end
        end
    end

    return results
end

-- Get a specific template by key
xi.dynamicWorld.templates.get = function(key)
    return db[key]
end

-- Get all template keys
xi.dynamicWorld.templates.getAllKeys = function()
    local keys = {}
    for key, _ in pairs(db) do
        table.insert(keys, key)
    end
    return keys
end
