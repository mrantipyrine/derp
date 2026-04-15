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

xi.settings.dynamicworld =
{
    -- Master switch
    ENABLED = true,

    -----------------------------------------------------------------------
    -- Spawn Budget
    -----------------------------------------------------------------------
    MAX_ENTITIES_PER_ZONE       = 15,       -- Hard cap per zone (of 511 dynamic entity max)
    MIN_ENTITIES_PER_ZONE       = 10,       -- Minimum entities kept alive in every eligible zone at all times
    GLOBAL_ENTITY_CAP           = 500,      -- Server-wide cap across all zones
    SPAWN_CHECK_INTERVAL        = 30,       -- Seconds between spawn evaluation ticks
    STAGGER_DELAY               = 2,        -- Seconds between individual spawns (prevents packet storm)
    DESPAWN_EMPTY_ZONE_TIME     = 600,      -- Seconds before despawning entities ABOVE the minimum in empty zones

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
    MAX_SPAWN_BATCH_SIZE        = 5,        -- Max entities spawned per tick per zone
    TICK_BUDGET_MS              = 50,       -- Max time spent on dynamic world per server tick
    CLEANUP_INTERVAL            = 60,       -- Seconds between cleanup passes

    -----------------------------------------------------------------------
    -- NOTE: ZONE_LEVELS, ELIGIBLE_ZONES, and REGIONS have been moved to
    -- scripts/globals/dynamic_world.lua as local Lua constants.
    -- The C++ settings loader silently drops table values during push-back,
    -- so they must live in Lua-owned files instead.
    -----------------------------------------------------------------------
}

--[[  REMOVED TABLE CONFIGS (kept here as reference only, not loaded)
    ZONE_LEVELS_REFERENCE =
    {
        -- ── Original Zones ──────────────────────────────────────────────
        [100] = {  1,  9 },   -- West Ronfaure
        [101] = {  1,  9 },   -- East Ronfaure
        [102] = { 10, 21 },   -- La Theine Plateau
        [103] = { 10, 22 },   -- Valkurm Dunes
        [104] = { 15, 28 },   -- Jugner Forest
        [105] = { 25, 40 },   -- Batallia Downs
        [106] = {  1,  9 },   -- North Gustaberg
        [107] = {  1,  9 },   -- South Gustaberg
        [108] = { 10, 22 },   -- Konschtat Highlands
        [109] = { 20, 33 },   -- Pashhow Marshlands
        [110] = { 30, 43 },   -- Rolanberry Fields
        [111] = { 40, 52 },   -- Beaucedine Glacier
        [112] = { 47, 58 },   -- Xarcabard
        [113] = { 40, 52 },   -- Cape Teriggan
        [114] = { 45, 58 },   -- Eastern Altepa Desert
        [115] = {  1,  9 },   -- West Sarutabaruta
        [116] = {  1,  9 },   -- East Sarutabaruta
        [117] = { 10, 22 },   -- Tahrongi Canyon
        [118] = { 15, 27 },   -- Buburimu Peninsula
        [119] = { 25, 38 },   -- Meriphataud Mountains
        [120] = { 33, 48 },   -- Sauromugue Champaign
        [121] = { 35, 50 },   -- Sanctuary of Zi'Tah
        [122] = { 42, 58 },   -- Ro'Maeve
        [123] = { 38, 52 },   -- Yuhtunga Jungle
        [124] = { 44, 58 },   -- Yhoator Jungle
        [125] = { 45, 58 },   -- Western Altepa Desert
        [126] = { 20, 33 },   -- Qufim Island
        [127] = { 60, 72 },   -- Behemoth's Dominion
        [128] = { 65, 75 },   -- Valley of Sorrows

        -- ── Chains of Promathia ─────────────────────────────────────────
        [ 24] = { 30, 52 },   -- Lufaise Meadows
        [ 25] = { 35, 55 },   -- Misareaux Coast

        -- ── Treasures of Aht Urhgan ─────────────────────────────────────
        [ 51] = { 55, 72 },   -- Wajaom Woodlands
        [ 52] = { 55, 72 },   -- Bhaflau Thickets
        [ 61] = { 60, 75 },   -- Mount Zhayolm
        [ 65] = { 62, 75 },   -- Mamook
        [ 68] = { 63, 75 },   -- Aydeewa Subterrane
        [ 79] = { 65, 75 },   -- Caedarva Mire

        -- ── Wings of the Goddess [S] zones ──────────────────────────────
        [ 81] = {  1, 12 },   -- East Ronfaure [S]
        [ 82] = { 18, 32 },   -- Jugner Forest [S]
        [ 83] = { 22, 40 },   -- Vunkerl Inlet [S]
        [ 84] = { 30, 48 },   -- Batallia Downs [S]
        [ 88] = {  1, 12 },   -- North Gustaberg [S]
        [ 89] = { 22, 40 },   -- Grauberg [S]
        [ 90] = { 28, 45 },   -- Pashhow Marshlands [S]
        [ 91] = { 35, 52 },   -- Rolanberry Fields [S]
        [ 95] = {  1, 12 },   -- West Sarutabaruta [S]
        [ 97] = { 30, 48 },   -- Meriphataud Mountains [S]
        [ 98] = { 38, 55 },   -- Sauromugue Champaign [S]
        [136] = { 48, 62 },   -- Beaucedine Glacier [S]
        [137] = { 55, 70 },   -- Xarcabard [S]

        -- ── Seekers of Adoulin ───────────────────────────────────────────
        [260] = { 90, 99 },   -- Yahse Hunting Grounds
        [261] = { 90, 99 },   -- Ceizak Battlegrounds
    },
]]
