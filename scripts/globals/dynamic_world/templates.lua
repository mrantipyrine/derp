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
--   groupRef       - { groupId, groupZoneId } referencing mob_groups for base model
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
    groupRef        = { groupId = 6, groupZoneId = 100 },  -- Wild Rabbit, West Ronfaure
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
    groupRef        = { groupId = 28, groupZoneId = 2 },   -- Forest Tiger, Carpenters Landing
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
    groupRef        = { groupId = 6, groupZoneId = 100 },  -- Placeholder: replace with beetle groupRef
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
    groupRef        = { groupId = 14, groupZoneId = 2 },   -- Orcish Grunt, Carpenters Landing
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
    groupRef        = { groupId = 9, groupZoneId = 7 },    -- Attohwa Coeurl, Attohwa Chasm
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
    groupRef        = { groupId = 35, groupZoneId = 2 },   -- Wight, Carpenters Landing
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
    groupRef        = { groupId = 14, groupZoneId = 2 },   -- Placeholder: replace with goblin groupRef
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
    groupRef        = { groupId = 14, groupZoneId = 2 },   -- Placeholder: NPC type preferred
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
    groupRef        = { groupId = 17, groupZoneId = 7 },   -- Master Coeurl, Attohwa Chasm
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
    groupRef        = { groupId = 14, groupZoneId = 2 },   -- Placeholder: beastman NM ref
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
    groupRef        = { groupId = 6, groupZoneId = 100 },  -- Placeholder: arcana/golem ref
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
    groupRef        = { groupId = 12, groupZoneId = 2 },   -- Thunder Elemental, Carpenters
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
    groupRef        = { groupId = 5, groupZoneId = 154 },  -- Fafnir, Dragon's Aery
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
    groupRef        = { groupId = 21, groupZoneId = 5 },   -- Dread Demon, Uleguerand
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
    groupRef        = { groupId = 34, groupZoneId = 2 },   -- Sabertooth Tiger (placeholder for NM)
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
