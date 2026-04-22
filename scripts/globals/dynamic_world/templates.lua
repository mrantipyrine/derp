-----------------------------------
-- Dynamic World: Entity Templates
-----------------------------------
-- All groupId/groupZoneId values confirmed against live DB.
-----------------------------------

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.tier = xi.dynamicWorld.tier or {
    WANDERER   = 1,
    NOMAD      = 2,
    ELITE      = 3,
    APEX       = 4,
    POWER_KING = 5,
}
xi.dynamicWorld.tierName = xi.dynamicWorld.tierName or {
    [1] = 'Wanderer',
    [2] = 'Nomad',
    [3] = 'Elite',
    [4] = 'Apex',
    [5] = 'Power King',
}
xi.dynamicWorld.templates = xi.dynamicWorld.templates or {}

xi.dynamicWorld.templates.db = {}
local db = xi.dynamicWorld.templates.db

-----------------------------------
-- TIER 1: WANDERERS
-----------------------------------

db.empowered_crawler =
{
    name        = 'Empowered Crawler',
    packetName  = 'Empowered Crawler',
    -- Crawler: zone 115 (W.Sarutabaruta lv3-8), zone 116 (E.Saruta lv3-6)
    groupRefs = {
        { groupId = 10, groupZoneId = 115 },
        { groupId = 22, groupZoneId = 115 },
        { groupId = 9,  groupZoneId = 116 },
    },
    tier          = { xi.dynamicWorld.tier.WANDERER },
    levelOffset   = { 2, 5 },
    regions       = { 'sarutabaruta', 'ronfaure', 'gustaberg' },
    behavior      = 'wanderer_standard',
    lootTable     = 'wanderer_common',
    isAggro       = false,
    expMultiplier = 1.0,
    description   = 'A crawler pulsing with strange energy.',
}

db.frenzied_bat =
{
    name        = 'Frenzied Bat',
    packetName  = 'Frenzied Bat',
    -- Acro_Bat: zone 102 (La Theine lv8-11)
    -- Ancient_Bat: zone 121 (Zi Tah lv26-28), zone 126 (Qufim lv27-29)
    groupRefs = {
        { groupId = 20, groupZoneId = 102 },
        { groupId = 9,  groupZoneId = 121 },
        { groupId = 29, groupZoneId = 126 },
    },
    tier          = { xi.dynamicWorld.tier.WANDERER, xi.dynamicWorld.tier.NOMAD },
    levelOffset   = { 2, 6 },
    regions       = { 'ronfaure', 'midlands', 'sarutabaruta' },
    behavior      = 'wanderer_aggressive',
    lootTable     = 'wanderer_common',
    isAggro       = true,
    expMultiplier = 1.0,
    description   = 'A bat driven into a frenzy by strange energies.',
}

db.enraged_bomb =
{
    name        = 'Enraged Bomb',
    packetName  = 'Enraged Bomb',
    -- Bomb: zone 100 (W.Ronfaure lv8-10), zone 101 (E.Ronfaure lv8-10)
    -- Grenade: zone 102 (La Theine lv15-17), zone 108 (Konschtat lv15-17), zone 117 (Tahrongi lv15-17)
    groupRefs = {
        { groupId = 24, groupZoneId = 100 },
        { groupId = 24, groupZoneId = 101 },
        { groupId = 26, groupZoneId = 102 },
        { groupId = 21, groupZoneId = 108 },
        { groupId = 28, groupZoneId = 117 },
    },
    tier          = { xi.dynamicWorld.tier.WANDERER },
    levelOffset   = { 1, 4 },
    regions       = { 'ronfaure', 'gustaberg', 'sarutabaruta' },
    behavior      = 'wanderer_aggressive',
    lootTable     = 'wanderer_common',
    isAggro       = true,
    expMultiplier = 1.1,
    description   = 'A bomb pulsing with unstable energy.',
}

db.rogue_quadav =
{
    name        = 'Rogue Quadav',
    packetName  = 'Rogue Quadav',
    -- Amber/Amethyst Quadav: zones 106/107/108 lv3-10
    -- Brass Quadav: zones 106/109 lv20-26
    groupRefs = {
        { groupId = 23, groupZoneId = 106 },
        { groupId = 25, groupZoneId = 107 },
        { groupId = 12, groupZoneId = 108 },
        { groupId = 21, groupZoneId = 109 },
    },
    tier          = { xi.dynamicWorld.tier.WANDERER, xi.dynamicWorld.tier.NOMAD },
    levelOffset   = { 3, 7 },
    regions       = { 'gustaberg' },
    behavior      = 'wanderer_aggressive',
    lootTable     = 'wanderer_uncommon',
    isAggro       = true,
    expMultiplier = 1.1,
    description   = 'A Quadav warrior separated from its battalion, wandering and hostile.',
}

-----------------------------------
-- TIER 2: NOMADS
-----------------------------------

db.frenzied_tiger =
{
    name        = 'Frenzied Tiger',
    packetName  = 'Frenzied Tiger',
    -- Forest_Tiger: zone 104 (Jugner lv22-25), zone 2 (lv22-25)
    groupRefs = {
        { groupId = 16, groupZoneId = 104 },
        { groupId = 28, groupZoneId = 2   },
    },
    tier          = { xi.dynamicWorld.tier.NOMAD },
    levelOffset   = { 3, 8 },
    regions       = { 'ronfaure', 'midlands', 'elshimo' },
    behavior      = 'nomad_predator',
    lootTable     = 'nomad_predator',
    isAggro       = true,
    expMultiplier = 1.1,
    description   = 'A tiger with bloodshot eyes and unnatural speed.',
}

db.wandering_shade =
{
    name        = 'Wandering Shade',
    packetName  = 'Wandering Shade',
    -- Ghost: zone 102 (La Theine lv15-17), zone 108 (Konschtat lv15-17), zone 117 (Tahrongi lv15-17)
    groupRefs = {
        { groupId = 33, groupZoneId = 102 },
        { groupId = 14, groupZoneId = 108 },
        { groupId = 7,  groupZoneId = 117 },
    },
    tier          = { xi.dynamicWorld.tier.NOMAD },
    levelOffset   = { 5, 12 },
    regions       = nil,
    behavior      = 'nomad_ghost',
    lootTable     = 'nomad_arcane',
    isAggro       = true,
    expMultiplier = 1.2,
    description   = 'A restless spirit drifting between zones.',
}

db.treasure_goblin =
{
    name        = 'Treasure Goblin',
    packetName  = 'Treasure Goblin',
    -- Grenade/Cluster models for a chubby explosive look
    -- Cluster: zone 24 (Lufaise lv38-40) for the big variant
    groupRefs = {
        { groupId = 26, groupZoneId = 102 },
        { groupId = 21, groupZoneId = 108 },
        { groupId = 28, groupZoneId = 117 },
        { groupId = 15, groupZoneId = 24  },
    },
    tier          = { xi.dynamicWorld.tier.NOMAD, xi.dynamicWorld.tier.ELITE },
    levelOffset   = { 0, 3 },
    regions       = nil,
    behavior      = 'treasure_goblin',
    lootTable     = 'treasure_goblin',
    isAggro       = false,
    expMultiplier = 0.5,
    description   = 'A bomb stuffed with stolen loot. It WILL try to run.',
}

db.roaming_merchant =
{
    name        = 'Pilgrim Merchant',
    packetName  = 'Pilgrim Merchant',
    -- Goobbue zone 109 (Pashhow lv22-25)
    groupRefs = {
        { groupId = 15, groupZoneId = 109 },
    },
    tier          = { xi.dynamicWorld.tier.NOMAD },
    levelOffset   = { 0, 0 },
    regions       = nil,
    behavior      = 'nomad_merchant',
    lootTable     = 'none',
    isAggro       = false,
    expMultiplier = 0,
    isMerchant    = true,
    description   = 'A traveling merchant. Protect them for rare wares.',
}

db.rampaging_goobbue =
{
    name        = 'Rampaging Goobbue',
    packetName  = 'Rampagng Goobbue',
    -- Goobbue: zone 109 (lv22-25), zone 90 (lv71-73)
    groupRefs = {
        { groupId = 15, groupZoneId = 109 },
        { groupId = 16, groupZoneId = 90  },
    },
    tier          = { xi.dynamicWorld.tier.NOMAD, xi.dynamicWorld.tier.ELITE },
    levelOffset   = { 5, 10 },
    regions       = { 'midlands', 'sarutabaruta', 'shadowreign' },
    behavior      = 'nomad_predator',
    lootTable     = 'nomad_predator',
    isAggro       = true,
    expMultiplier = 1.2,
    description   = 'A goobbue torn from its grove, rampaging across open fields.',
}

-----------------------------------
-- TIER 3: ELITES
-----------------------------------

db.dread_hunter =
{
    name        = 'Dread Hunter',
    packetName  = 'Dread Hunter',
    -- Coeurl: zone 119 (Meriphataud lv22-26)
    -- Carnivorous_Crawler: zone 109 lv20-23, zone 118 lv20-23
    groupRefs = {
        { groupId = 35, groupZoneId = 119 },
        { groupId = 26, groupZoneId = 109 },
        { groupId = 24, groupZoneId = 118 },
    },
    tier          = { xi.dynamicWorld.tier.ELITE },
    levelOffset   = { 8, 15 },
    regions       = { 'midlands', 'sarutabaruta', 'aradjiah', 'shadowreign' },
    behavior      = 'elite_hunter',
    lootTable     = 'elite_predator',
    isAggro       = true,
    expMultiplier = 1.0,
    description   = 'A coeurl that has consumed too many crystals. Glows with malice.',
}

db.fell_commander =
{
    name        = 'Fell Commander',
    packetName  = 'Fell Commander',
    -- Brass_Quadav: zone 109 lv20-26, zone 106 lv20-25
    -- Bronze_Quadav: zone 110 lv30-36
    groupRefs = {
        { groupId = 21, groupZoneId = 109 },
        { groupId = 37, groupZoneId = 106 },
        { groupId = 13, groupZoneId = 110 },
    },
    tier          = { xi.dynamicWorld.tier.ELITE },
    levelOffset   = { 10, 15 },
    regions       = { 'gustaberg', 'midlands', 'shadowreign' },
    behavior      = 'elite_commander',
    lootTable     = 'elite_beastman',
    isAggro       = true,
    expMultiplier = 1.2,
    description   = 'A Quadav war-leader rallying scattered forces across the frontier.',
}

db.storm_elemental =
{
    name        = 'Storm Nexus',
    packetName  = 'Storm Nexus',
    -- Dark_Elemental: zone 111 lv44-46, zone 112 lv48-50, zone 25 lv42-44, zone 79 lv74-76
    -- Fire_Elemental: zone 103 lv28-30, zone 119 lv27-29, zone 110 lv38-40
    groupRefs = {
        { groupId = 19, groupZoneId = 111 },
        { groupId = 9,  groupZoneId = 112 },
        { groupId = 22, groupZoneId = 103 },
        { groupId = 28, groupZoneId = 119 },
        { groupId = 16, groupZoneId = 25  },
        { groupId = 34, groupZoneId = 79  },
    },
    tier          = { xi.dynamicWorld.tier.ELITE },
    levelOffset   = { 5, 12 },
    regions       = nil,
    behavior      = 'elite_elemental',
    lootTable     = 'elite_elemental',
    isAggro       = true,
    expMultiplier = 1.5,
    hasAura       = true,
    description   = 'A convergence of elemental energy. Empowers nearby adventurers.',
}

db.crystal_golem =
{
    name        = 'Crystal Golem',
    packetName  = 'Crystal Golem',
    -- Goobbue large zone 90 (lv71-73) as hulking construct stand-in
    groupRefs = {
        { groupId = 16, groupZoneId = 90  },
        { groupId = 15, groupZoneId = 109 },
    },
    tier          = { xi.dynamicWorld.tier.ELITE },
    levelOffset   = { 10, 18 },
    regions       = { 'midlands', 'tavnazia' },
    behavior      = 'elite_tank',
    lootTable     = 'elite_arcane',
    isAggro       = true,
    expMultiplier = 1.3,
    description   = 'A construct of fused crystals. Incredibly durable.',
}

-----------------------------------
-- TIER 4: APEX
-----------------------------------

db.void_wyrm =
{
    name        = 'Void Wyrm',
    packetName  = 'Void Wyrm',
    -- Fafnir: zone 77 lv80 (large), zone 154 lv90 (massive)
    groupRefs = {
        { groupId = 162, groupZoneId = 77  },
        { groupId = 5,   groupZoneId = 154 },
    },
    tier          = { xi.dynamicWorld.tier.APEX },
    levelOffset   = { 15, 25 },
    regions       = { 'midlands', 'aradjiah' },
    behavior      = 'apex_dragon',
    lootTable     = 'apex_dragon',
    isAggro       = true,
    expMultiplier = 1.0,
    minionTemplate  = 'frenzied_tiger',
    description   = 'A wyrm torn from the void. The earth trembles in its wake.',
}

db.abyssal_demon =
{
    name        = 'Abyssal Tyrant',
    packetName  = 'Abyssal Tyrant',
    -- Dark_Elemental high-level: zone 112 lv48-50, zone 79 lv74-76, zone 25 lv42-44
    groupRefs = {
        { groupId = 9,  groupZoneId = 112 },
        { groupId = 34, groupZoneId = 79  },
        { groupId = 16, groupZoneId = 25  },
    },
    tier          = { xi.dynamicWorld.tier.APEX },
    levelOffset   = { 15, 25 },
    regions       = { 'midlands', 'shadowreign' },
    behavior      = 'apex_demon',
    lootTable     = 'apex_demon',
    isAggro       = true,
    expMultiplier = 1.2,
    minionTemplate  = 'wandering_shade',
    description   = 'A demon lord who tears open rifts, summoning shades from the beyond.',
}

db.ancient_king =
{
    name        = 'Ancient King',
    packetName  = 'Ancient King',
    -- Adamantoise: zone 128 lv70, zone 77 lv80
    groupRefs = {
        { groupId = 6,   groupZoneId = 128 },
        { groupId = 260, groupZoneId = 77  },
    },
    tier          = { xi.dynamicWorld.tier.APEX },
    levelOffset   = { 12, 20 },
    regions       = nil,
    behavior      = 'apex_king',
    lootTable     = 'apex_king',
    isAggro       = true,
    expMultiplier = 1.5,
    minionTemplate  = 'rogue_quadav',
    description   = 'An ancient king walking again. Its shell alone could shelter a village.',
}

-----------------------------------
-- TIER 5: POWER KINGS
-----------------------------------

db.void_emperor =
{
    name        = 'Void Emperor',
    packetName  = 'Void Emperor',
    -- Fafnir/Vrtra silhouettes for true top-end dungeon kings.
    groupRefs = {
        { groupId = 162, groupZoneId = 77  },
        { groupId = 5,   groupZoneId = 154 },
    },
    tier          = { xi.dynamicWorld.tier.POWER_KING },
    levelOffset   = { 28, 35 },
    levelCap      = 115,
    regions       = nil,
    behavior      = 'power_king_dragon',
    lootTable     = 'power_king',
    isAggro       = true,
    expMultiplier = 2.0,
    minionTemplate = 'void_wyrm',
    description   = 'A dungeon tyrant awakened by the new weapons adventurers carry.',
}

db.hellforged_overlord =
{
    name        = 'Hellforged Overlord',
    packetName  = 'Hellforged Overlord',
    -- Demon/elemental bodies read well in deep dungeon spaces.
    groupRefs = {
        { groupId = 9,  groupZoneId = 112 },
        { groupId = 34, groupZoneId = 79  },
        { groupId = 16, groupZoneId = 25  },
    },
    tier          = { xi.dynamicWorld.tier.POWER_KING },
    levelOffset   = { 25, 35 },
    levelCap      = 112,
    regions       = nil,
    behavior      = 'power_king_demon',
    lootTable     = 'power_king',
    isAggro       = true,
    expMultiplier = 2.2,
    minionTemplate = 'abyssal_demon',
    description   = 'A spell-warped tyrant built to punish careless level 75 gods.',
}

db.primeval_monarch =
{
    name        = 'Primeval Monarch',
    packetName  = 'Primeval Monarch',
    -- Adamantoise-style monarchs for king fights that feel heavy.
    groupRefs = {
        { groupId = 6,   groupZoneId = 128 },
        { groupId = 260, groupZoneId = 77  },
    },
    tier          = { xi.dynamicWorld.tier.POWER_KING },
    levelOffset   = { 25, 32 },
    levelCap      = 110,
    regions       = nil,
    behavior      = 'power_king_monarch',
    lootTable     = 'power_king',
    isAggro       = true,
    expMultiplier = 2.5,
    minionTemplate = 'ancient_king',
    description   = 'An old-world monarch made relevant again by broken adventurer gear.',
}

db.dude =
{
    name        = 'Dude',
    packetName  = 'Dude',
    -- Smaller dragon bodies.
    groupRefs = {
        { groupId = 5,  groupZoneId = 112 }, -- Shadow Dragon
        { groupId = 1,  groupZoneId = 146 }, -- Black Dragon
        { groupId = 35, groupZoneId = 140 }, -- Carrion Dragon
    },
    tier          = {},
    levelOffset   = { 38, 42 },
    levelCap      = 122,
    regions       = nil,
    behavior      = 'dude_dragon',
    lootTable     = 'power_king',
    isAggro       = true,
    expMultiplier = 2.0,
    description   = 'A tiny dragon with absolutely unreasonable confidence.',
}

db.dude_bro =
{
    name        = 'Dude Bro',
    packetName  = 'Dude Bro',
    -- Mid-sized named dragon bodies.
    groupRefs = {
        { groupId = 17, groupZoneId = 30 }, -- Ouryu
        { groupId = 17, groupZoneId = 29 }, -- Bahamut
        { groupId = 6,  groupZoneId = 154 }, -- Nidhogg
    },
    tier          = {},
    levelOffset   = { 40, 44 },
    levelCap      = 124,
    regions       = nil,
    behavior      = 'dude_bro_dragon',
    lootTable     = 'power_king',
    isAggro       = true,
    expMultiplier = 2.2,
    description   = 'The loud one. Somehow worse.',
}

db.sir_dude =
{
    name        = 'Sir Dude',
    packetName  = 'Sir Dude',
    -- Biggest available wyrm-style bodies.
    groupRefs = {
        { groupId = 37, groupZoneId = 190 }, -- Vrtra
        { groupId = 46, groupZoneId = 7   }, -- Tiamat
        { groupId = 40, groupZoneId = 5   }, -- Jormungand
    },
    tier          = { xi.dynamicWorld.tier.POWER_KING },
    levelOffset   = { 45, 50 },
    levelCap      = 125,
    regions       = nil,
    behavior      = 'sir_dude_dragon',
    lootTable     = 'king_of_kings',
    isAggro       = true,
    expMultiplier = 3.0,
    dudeCompanions = { 'dude', 'dude_bro' },
    description   = 'King of Kings. Etiquette optional. Survival unlikely.',
}

-----------------------------------
-- Template Lookup Helpers
-----------------------------------

xi.dynamicWorld.templates.getForTierAndRegion = function(tier, regionName)
    local results = {}
    for key, template in pairs(db) do
        local tierMatch = false
        for _, t in ipairs(template.tier) do
            if t == tier then
                tierMatch = true
                break
            end
        end

        if tierMatch then
            if template.regions == nil then
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

xi.dynamicWorld.templates.get = function(key)
    return db[key]
end

xi.dynamicWorld.templates.getAllKeys = function()
    local keys = {}
    for key, _ in pairs(db) do
        table.insert(keys, key)
    end
    return keys
end
