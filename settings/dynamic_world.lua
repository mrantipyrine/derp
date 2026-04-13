-----------------------------------
-- Dynamic World Settings
-----------------------------------
-- A living world system that spawns roaming entities across the overworld.
-- Entities range from common wanderers to rare apex predators.
-- Supports zone-bound mobs, regional roamers, dynamic loot, EXP bonuses,
-- item/ability synergies, and entities that spawn other entities.
-----------------------------------

xi = xi or {}
xi.settings = xi.settings or {}

xi.settings.dynamicWorld =
{
    -- Master switch
    ENABLED = true,

    -----------------------------------------------------------------------
    -- Spawn Budget
    -----------------------------------------------------------------------
    MAX_ENTITIES_PER_ZONE       = 15,       -- Hard cap per zone (of 511 dynamic entity max)
    GLOBAL_ENTITY_CAP           = 500,      -- Server-wide cap across all zones
    SPAWN_CHECK_INTERVAL        = 120,      -- Seconds between spawn evaluation ticks
    STAGGER_DELAY               = 5,        -- Seconds between individual spawns (prevents packet storm)
    DESPAWN_EMPTY_ZONE_TIME     = 600,      -- Seconds before despawning entities in empty zones

    -----------------------------------------------------------------------
    -- Tier Weights (must total 100)
    -----------------------------------------------------------------------
    TIER_WEIGHT_WANDERER        = 55,       -- Common roaming mobs, zone-bound
    TIER_WEIGHT_NOMAD           = 20,       -- Cross-zone roamers within a region
    TIER_WEIGHT_ELITE           = 15,       -- Rare, dangerous, great rewards
    TIER_WEIGHT_APEX            = 10,       -- Boss-tier, spawns minions, aura buffs

    -----------------------------------------------------------------------
    -- EXP Multipliers (applied on top of base EXP)
    -----------------------------------------------------------------------
    EXP_MULTIPLIER_WANDERER     = 1.5,
    EXP_MULTIPLIER_NOMAD        = 2.0,
    EXP_MULTIPLIER_ELITE        = 3.0,
    EXP_MULTIPLIER_APEX         = 5.0,

    -----------------------------------------------------------------------
    -- Chain System
    -- Killing dynamic world entities in sequence builds a chain multiplier
    -----------------------------------------------------------------------
    CHAIN_ENABLED               = true,
    CHAIN_WINDOW                = 180,      -- Seconds to maintain chain between kills
    CHAIN_BONUS_PER_KILL        = 0.15,     -- +15% EXP per chain step
    CHAIN_BONUS_MAX             = 2.0,      -- +200% max chain bonus
    CHAIN_ANNOUNCE_INTERVAL     = 3,        -- Announce chain every N kills

    -----------------------------------------------------------------------
    -- Apex Aura
    -- Apex entities radiate an EXP buff to nearby players
    -----------------------------------------------------------------------
    APEX_AURA_RANGE             = 50.0,     -- Distance in yalms
    APEX_AURA_EXP_BONUS         = 0.25,     -- +25% EXP while in aura
    APEX_AURA_DURATION          = 300,      -- Buff duration in seconds after leaving range
    APEX_AURA_TICK_INTERVAL     = 10,       -- Seconds between aura pulse checks

    -----------------------------------------------------------------------
    -- Roaming (Nomads)
    -----------------------------------------------------------------------
    ROAM_CHECK_INTERVAL         = 300,      -- Seconds between migration checks
    ROAM_MIGRATION_CHANCE       = 0.30,     -- 30% chance per check to migrate zones
    ROAM_ANNOUNCE               = true,     -- Announce migrations to zone players
    ROAM_WALK_TO_ZONELINE       = true,     -- Physically walk to zone boundary before migrating

    -----------------------------------------------------------------------
    -- Apex Minion Spawning
    -----------------------------------------------------------------------
    APEX_MINION_MIN             = 2,
    APEX_MINION_MAX             = 5,
    APEX_MINION_SPAWN_ON_ENGAGE = true,     -- Spawn minions when first engaged
    APEX_MINION_SPAWN_ON_HP     = { 0.75, 0.50, 0.25 }, -- Spawn wave at HP thresholds

    -----------------------------------------------------------------------
    -- Loot
    -----------------------------------------------------------------------
    LOOT_ENABLED                = true,
    LOOT_GIL_MULTIPLIER         = 2.0,      -- Gil drop multiplier for dynamic world mobs
    DYNAMIC_LOOT_BONUS_RATE     = 1.5,      -- Drop rate multiplier for dynamic loot tables

    -----------------------------------------------------------------------
    -- Synergies
    -- Item/ability synergy effects that activate during dynamic world fights
    -----------------------------------------------------------------------
    SYNERGIES_ENABLED           = true,

    -----------------------------------------------------------------------
    -- Revenge Spawns
    -- Killing a dynamic entity may spawn a stronger "relative" at the
    -- same location. Each generation is tougher with a sillier name.
    -- Gen 1: "X Jr." -> Gen 2: "X Sr." -> Gen 3: "Big X" ->
    -- Gen 4: "X the Patriarch" -> Gen 5: "Legendary X"
    -----------------------------------------------------------------------
    REVENGE_SPAWNS_ENABLED      = true,
    REVENGE_MAX_GENERATION      = 5,        -- Max revenge chain depth (1-5)
    REVENGE_CHANCE_MULTIPLIER   = 1.0,      -- Multiply base chances (0.5 = half, 2.0 = double)

    -----------------------------------------------------------------------
    -- Performance
    -----------------------------------------------------------------------
    MAX_SPAWN_BATCH_SIZE        = 3,        -- Max entities spawned per tick per zone
    TICK_BUDGET_MS              = 50,       -- Max time spent on dynamic world per server tick
    CLEANUP_INTERVAL            = 60,       -- Seconds between cleanup passes

    -----------------------------------------------------------------------
    -- Zone Eligibility
    -- Only outdoor overworld zones participate. Add/remove zone IDs here.
    -- By default, all major outdoor zones from each expansion are included.
    -----------------------------------------------------------------------
    ELIGIBLE_ZONES =
    {
        -- Original Outdoor Zones
        100, -- West Ronfaure
        101, -- East Ronfaure
        102, -- La Theine Plateau
        103, -- Valkurm Dunes
        104, -- Jugner Forest
        105, -- Batallia Downs
        106, -- North Gustaberg
        107, -- South Gustaberg
        108, -- Konschtat Highlands
        109, -- Pashhow Marshlands
        110, -- Rolanberry Fields
        111, -- Beaucedine Glacier
        112, -- Xarcabard
        113, -- Cape Teriggan
        114, -- Eastern Altepa Desert
        115, -- West Sarutabaruta
        116, -- East Sarutabaruta
        117, -- Tahrongi Canyon
        118, -- Buburimu Peninsula
        119, -- Meriphataud Mountains
        120, -- Sauromugue Champaign
        121, -- Sanctuary of Zi'Tah
        122, -- Ro'Maeve
        123, -- Yuhtunga Jungle
        124, -- Yhoator Jungle
        125, -- Western Altepa Desert
        126, -- Qufim Island
        127, -- Behemoth's Dominion
        128, -- Valley of Sorrows

        -- CoP Zones
        24,  -- Lufaise Meadows
        25,  -- Misareaux Coast

        -- ToAU Outdoor Zones
        51,  -- Wajaom Woodlands
        52,  -- Bhaflau Thickets
        61,  -- Mount Zhayolm
        65,  -- Mamook
        68,  -- Aydeewa Subterrane
        79,  -- Caedarva Mire

        -- WotG Outdoor Zones
        81,  -- East Ronfaure [S]
        82,  -- Jugner Forest [S]
        83,  -- Vunkerl Inlet [S]
        84,  -- Batallia Downs [S]
        88,  -- North Gustaberg [S]
        89,  -- Grauberg [S]
        90,  -- Pashhow Marshlands [S]
        91,  -- Rolanberry Fields [S]
        95,  -- West Sarutabaruta [S]
        97,  -- Meriphataud Mountains [S]
        98,  -- Sauromugue Champaign [S]
        136, -- Beaucedine Glacier [S]
        137, -- Xarcabard [S]

        -- SoA Zones
        260, -- Yahse Hunting Grounds
        261, -- Ceizak Battlegrounds
    },

    -----------------------------------------------------------------------
    -- Region Connectivity (for Nomad roaming)
    -- Maps region names to lists of connected zone IDs.
    -- Nomads can migrate between any zones in their region.
    -----------------------------------------------------------------------
    REGIONS =
    {
        ronfaure =
        {
            zones = { 100, 101, 102, 104, 105 },
            levelRange = { 1, 35 },
        },
        gustaberg =
        {
            zones = { 106, 107, 108, 109, 110 },
            levelRange = { 1, 35 },
        },
        sarutabaruta =
        {
            zones = { 115, 116, 117, 118, 119, 120 },
            levelRange = { 1, 35 },
        },
        midlands =
        {
            zones = { 103, 111, 112, 113, 114, 121, 122, 125, 126, 127, 128 },
            levelRange = { 20, 75 },
        },
        elshimo =
        {
            zones = { 123, 124 },
            levelRange = { 25, 55 },
        },
        tavnazia =
        {
            zones = { 24, 25 },
            levelRange = { 30, 60 },
        },
        aradjiah =
        {
            zones = { 51, 52, 61, 65, 68, 79 },
            levelRange = { 55, 80 },
        },
        shadowreign =
        {
            zones = { 81, 82, 83, 84, 88, 89, 90, 91, 95, 97, 98, 136, 137 },
            levelRange = { 50, 80 },
        },
    },
}
