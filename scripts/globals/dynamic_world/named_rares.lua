-----------------------------------
-- Dynamic World: Named Rare Mobs
-----------------------------------
-- Personality-driven rare spawns with long respawn timers.
-- Shorter timers = lower level + weaker loot.
-- Longer timers = higher level + best loot.
--
-- Spawn state persists across restarts via server variables:
--   DW_NR_<key>  = UNIX timestamp of last kill (0 = never killed / ready)
--
-- Each rare has:
--   spawnTimer  = seconds after death before it CAN spawn again
--   spawnWindow = seconds the spawn window stays open (random check each tick)
--   spawnChance = per-tick probability during window (out of 1000)
--
-- Loot rates are per-1000. Trophy is always 1000 (guaranteed).
-----------------------------------

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.tier = xi.dynamicWorld.tier or {
    WANDERER = 1,
    NOMAD    = 2,
    ELITE    = 3,
    APEX     = 4,
}
xi.dynamicWorld.tierName = xi.dynamicWorld.tierName or {
    [1] = 'Wanderer',
    [2] = 'Nomad',
    [3] = 'Elite',
    [4] = 'Apex',
}
xi.dynamicWorld.namedRares = xi.dynamicWorld.namedRares or {}

local nr = xi.dynamicWorld.namedRares

-- Track currently alive named rares: key -> mob entity reference
nr.alive = nr.alive or {}

-- Pick a random groupRef from a config entry.
-- Supports either a single 'groupRef' or a 'groupRefs' array for visual variety.
local function pickGroupRef(config)
    local refs = config.groupRefs
    if refs and #refs > 0 then
        return refs[math.random(#refs)]
    end
    return config.groupRef
end

-----------------------------------
-- Roll a tier for this rare spawn.
-- Named rares are always at least Elite — they're Notorious Monsters.
-- 70% chance Elite, 30% chance Apex.
-----------------------------------
local RARE_TIER_ELITE = xi.dynamicWorld.tier.ELITE
local RARE_TIER_APEX  = xi.dynamicWorld.tier.APEX

local function rollRareTier()
    return math.random(100) <= 30 and RARE_TIER_APEX or RARE_TIER_ELITE
end

-----------------------------------
-- Compute level range for a named rare based on its tier and zone level.
-- Named rares are always well above zone level so they check as IT
-- even without the CHECK_AS_NM flag — but we set that flag too.
-----------------------------------
local function calcRareLevel(config, tier, zoneId)
    local zoneRange = xi.dynamicWorld.getZoneLevelRange(zoneId)
    local zoneMax   = zoneRange[2] or 10

    local minLv, maxLv
    if tier == RARE_TIER_APEX then
        -- Apex: zone max + 25–35 (very scary)
        minLv = math.min(99, zoneMax + 25)
        maxLv = math.min(99, zoneMax + 35)
    else
        -- Elite: zone max + 12–20 (definitely IT)
        minLv = math.min(99, zoneMax + 12)
        maxLv = math.min(99, zoneMax + 20)
    end

    -- Never go below the config's own floor (some rares are intentionally high)
    minLv = math.max(minLv, config.level[1])
    maxLv = math.max(maxLv, config.level[2])

    return minLv, maxLv
end

-----------------------------------
-- Named Rare Database
-----------------------------------
-- groupRef: find valid IDs with:
--   SELECT groupid, zoneid, name FROM mob_groups WHERE name LIKE '%Sheep%' LIMIT 10;
-- zones: which zone IDs this rare can appear in (picks one randomly)
-- loot: { itemId, rate (per 1000) }  Trophy (+0) is always first at rate 1000
-----------------------------------

nr.db = {

    -- ================================================================
    -- SHEEP
    -- ================================================================
    wooly_william =
    {
        name        = 'Wooly William',
        packetName  = 'Wooly William',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify sheep groupRef
        zones       = { 100, 101 },
        level       = { 6, 8 },
        spawnTimer  = 2 * 3600,
        spawnWindow = 1 * 3600,
        spawnChance = 300,
        isAggro     = false,
        loot        =
        {
            { itemId = 30100, rate = 1000 },    -- William's Wool (trophy, always)
            { itemId = 30101, rate = 400  },    -- William's Woolcap
            { itemId = 30102, rate = 150  },    -- William's Woolmitt
        },
        deathMsg = 'Wooly William lets out a final, dramatic baa.',
    },

    baarbara =
    {
        name        = "Baa-rbara",
        packetName  = "Baa-rbara",
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 100, 101, 102 },
        level       = { 10, 13 },
        spawnTimer  = 4 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 250,
        isAggro     = false,
        loot        =
        {
            { itemId = 30103, rate = 1000 },    -- Baa-rbara's Bell (trophy)
            { itemId = 30104, rate = 400  },    -- Baa-rbara's Collar
            { itemId = 30105, rate = 150  },    -- Baa-rbara's Ribbon
        },
        deathMsg = "Baa-rbara's tinkling bell goes silent.",
    },

    lambchop_larry =
    {
        name        = 'Lambchop Larry',
        packetName  = 'Lambchop Larry',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 101, 104, 103 },
        level       = { 20, 24 },
        spawnTimer  = 8 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 200,
        isAggro     = false,
        loot        =
        {
            { itemId = 30106, rate = 1000 },    -- Larry's Lambchop (trophy)
            { itemId = 30107, rate = 400  },    -- Larry's Lucky Fleece
            { itemId = 30108, rate = 150  },    -- Larry's Lanyard
        },
        deathMsg = 'Lambchop Larry falls over. He seems... satisfied.',
    },

    shear_sharon =
    {
        name        = 'Shear Sharon',
        packetName  = 'Shear Sharon',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 101, 104, 103, 111 },
        level       = { 35, 40 },
        spawnTimer  = 16 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 150,
        isAggro     = true,
        loot        =
        {
            { itemId = 30109, rate = 1000 },    -- Sharon's Golden Fleece (trophy)
            { itemId = 30110, rate = 400  },    -- Sharon's Shearing Shears
            { itemId = 30111, rate = 150  },    -- Sharon's Silken Mantle
        },
        deathMsg = "Shear Sharon's legendary fleece shimmers as she fades.",
    },

    -- ================================================================
    -- RABBITS
    -- ================================================================
    cottontail_tommy =
    {
        name        = 'Cottontail Tom',
        packetName  = 'Cottontail Tom',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify rabbit groupRef
        zones       = { 100, 115 },
        level       = { 5, 7 },
        spawnTimer  = 2 * 3600,
        spawnWindow = 1 * 3600,
        spawnChance = 300,
        isAggro     = false,
        loot        =
        {
            { itemId = 30130, rate = 1000 },
            { itemId = 30131, rate = 400  },
            { itemId = 30132, rate = 150  },
        },
        deathMsg = "Cottontail Tommy hops his last hop.",
    },

    hopscotch_harvey =
    {
        name        = 'Hopscotch Harv',
        packetName  = 'Hopscotch Harv',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 101, 116 },
        level       = { 10, 13 },
        spawnTimer  = 5 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 250,
        isAggro     = false,
        loot        =
        {
            { itemId = 30133, rate = 1000 },
            { itemId = 30134, rate = 400  },
            { itemId = 30135, rate = 150  },
        },
        deathMsg = 'Hopscotch Harvey lands badly on his last jump.',
    },

    bunbun_benedict =
    {
        name        = 'Bunbun Benedict',
        packetName  = 'Bunbun Benedict',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 103, 126, 111 },
        level       = { 22, 28 },
        spawnTimer  = 10 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 200,
        isAggro     = false,
        loot        =
        {
            { itemId = 30136, rate = 1000 },
            { itemId = 30137, rate = 400  },
            { itemId = 30138, rate = 150  },
        },
        deathMsg = "Bun-bun Benedict's bonnet drifts to the ground.",
    },

    twitchy_theodore =
    {
        name        = 'Twitchy Theo',
        packetName  = 'Twitchy Theo',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 103, 126, 123 },
        level       = { 38, 45 },
        spawnTimer  = 18 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 120,
        isAggro     = true,
        loot        =
        {
            { itemId = 30139, rate = 1000 },
            { itemId = 30140, rate = 400  },
            { itemId = 30141, rate = 150  },
        },
        deathMsg = "Twitchy Theodore twitches one final time.",
    },

    -- ================================================================
    -- CRABS
    -- ================================================================
    crab_leg_cameron =
    {
        name        = 'Crableg Cameron',
        packetName  = 'Crableg Cameron',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify crab groupRef
        zones       = { 102, 107 },
        level       = { 12, 16 },
        spawnTimer  = 4 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 280,
        isAggro     = true,
        loot        =
        {
            { itemId = 30160, rate = 1000 },
            { itemId = 30161, rate = 400  },
            { itemId = 30162, rate = 150  },
        },
        deathMsg = 'Crab Leg Cameron sidesteps into the afterlife.',
    },

    old_bay_ollie =
    {
        name        = 'Old Bay Ollie',
        packetName  = 'Old Bay Ollie',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 113, 122 },
        level       = { 25, 30 },
        spawnTimer  = 8 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 220,
        isAggro     = true,
        loot        =
        {
            { itemId = 30163, rate = 1000 },
            { itemId = 30164, rate = 400  },
            { itemId = 30165, rate = 150  },
        },
        deathMsg = "Old Bay Ollie smells delicious. Rest well.",
    },

    bisque_bernard =
    {
        name        = 'Bisque Bernard',
        packetName  = 'Bisque Bernard',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 113, 114, 122 },
        level       = { 35, 42 },
        spawnTimer  = 14 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 160,
        isAggro     = true,
        loot        =
        {
            { itemId = 30166, rate = 1000 },
            { itemId = 30167, rate = 400  },
            { itemId = 30168, rate = 150  },
        },
        deathMsg = 'Bisque Bernard returns to the sea, undefeated in spirit.',
    },

    dungeness_duncan =
    {
        name        = 'Dungeness Dunc',
        packetName  = 'Dungeness Dunc',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 123, 124 },
        level       = { 45, 52 },
        spawnTimer  = 20 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 100,
        isAggro     = true,
        loot        =
        {
            { itemId = 30169, rate = 1000 },
            { itemId = 30170, rate = 400  },
            { itemId = 30171, rate = 150  },
        },
        deathMsg = "Dungeness Duncan's claws scrape the ground one last time.",
    },

    -- ================================================================
    -- FUNGARS
    -- ================================================================
    mushroom_morris =
    {
        name        = 'Mushroom Morris',
        packetName  = 'Mushroom Morris',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify fungar groupRef
        zones       = { 100, 115, 116 },
        level       = { 5, 8 },
        spawnTimer  = 2 * 3600,
        spawnWindow = 1.5 * 3600,
        spawnChance = 320,
        isAggro     = false,
        loot        =
        {
            { itemId = 30001, rate = 1000 },    -- Morris's Sporeling (trophy, always)
            { itemId = 30000, rate = 400  },    -- Morris's Wide Brim
            { itemId = 30002, rate = 150  },    -- Mycelium Medal
        },
        deathMsg = 'Mushroom Morris tips his wide brim one last time.',
    },

    capn_chanterelle =
    {
        name        = 'Cap Chanterelle',
        packetName  = 'Cap Chanterelle',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify fungar groupRef
        zones       = { 111, 112, 103 },
        level       = { 18, 22 },
        spawnTimer  = 6 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 240,
        isAggro     = false,
        loot        =
        {
            { itemId = 30190, rate = 1000 },
            { itemId = 30191, rate = 400  },
            { itemId = 30192, rate = 150  },
        },
        deathMsg = "Cap'n Chanterelle releases a final puff of spores. Godspeed.",
    },

    portobello_pete =
    {
        name        = 'Portobello Pete',
        packetName  = 'Portobello Pete',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 113, 114, 122 },
        level       = { 35, 40 },
        spawnTimer  = 14 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 160,
        isAggro     = false,
        loot        =
        {
            { itemId = 30193, rate = 1000 },
            { itemId = 30194, rate = 400  },
            { itemId = 30195, rate = 150  },
        },
        deathMsg = 'Portobello Pete collapses with quiet dignity.',
    },

    truffle_trevor =
    {
        name        = 'Truffle Trevor',
        packetName  = 'Truffle Trevor',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 51, 52, 61 },
        level       = { 55, 62 },
        spawnTimer  = 22 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 80,
        isAggro     = true,
        loot        =
        {
            { itemId = 30196, rate = 1000 },
            { itemId = 30197, rate = 400  },
            { itemId = 30198, rate = 150  },
        },
        deathMsg = "Truffle Trevor was rarer than you knew. Cherish this.",
    },

    -- ================================================================
    -- GOBLINS
    -- ================================================================
    bargain_bruno =
    {
        name        = 'Bargain Bruno',
        packetName  = 'Bargain Bruno',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify goblin groupRef
        zones       = { 103, 111, 112 },
        level       = { 12, 16 },
        spawnTimer  = 4 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 280,
        isAggro     = true,
        loot        =
        {
            { itemId = 30220, rate = 1000 },
            { itemId = 30221, rate = 400  },
            { itemId = 30222, rate = 150  },
        },
        deathMsg = 'Bargain Bruno drops everything. Everything.',
    },

    swindler_sam =
    {
        name        = 'Swindler Sam',
        packetName  = 'Swindler Sam',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 113, 114, 103 },
        level       = { 30, 36 },
        spawnTimer  = 12 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 180,
        isAggro     = true,
        loot        =
        {
            { itemId = 30223, rate = 1000 },
            { itemId = 30224, rate = 400  },
            { itemId = 30225, rate = 150  },
        },
        deathMsg = "Swindler Sam's last con didn't work out.",
    },

    shiny_steve =
    {
        name        = 'Shiny Steve',
        packetName  = 'Shiny Steve',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 113, 51, 68 },
        level       = { 45, 52 },
        spawnTimer  = 20 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 100,
        isAggro     = true,
        loot        =
        {
            { itemId = 30226, rate = 1000 },
            { itemId = 30227, rate = 400  },
            { itemId = 30228, rate = 150  },
        },
        deathMsg = "Shiny Steve's collection of shiny things scatters across the ground.",
    },

    -- ================================================================
    -- COEURLS
    -- ================================================================
    whiskers_wilhelmina =
    {
        name        = 'Whiskers Mina',
        packetName  = 'Whiskers Mina',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify coeurl groupRef
        zones       = { 113, 114, 122 },
        level       = { 30, 36 },
        spawnTimer  = 8 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 220,
        isAggro     = true,
        loot        =
        {
            { itemId = 30250, rate = 1000 },
            { itemId = 30251, rate = 400  },
            { itemId = 30252, rate = 150  },
        },
        deathMsg = "Whiskers Wilhelmina lands gracefully. Even in defeat.",
    },

    purring_patricia =
    {
        name        = 'Purring Patty',
        packetName  = 'Purring Patty',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 113, 123, 124 },
        level       = { 42, 48 },
        spawnTimer  = 14 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 150,
        isAggro     = true,
        loot        =
        {
            { itemId = 30253, rate = 1000 },
            { itemId = 30254, rate = 400  },
            { itemId = 30255, rate = 150  },
        },
        deathMsg = "Purring Patricia's purr fades into silence.",
    },

    nine_lives_nigel =
    {
        name        = 'NineLives Nigel',
        packetName  = 'NineLives Nigel',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 51, 61, 68 },
        level       = { 58, 65 },
        spawnTimer  = 22 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 80,
        isAggro     = true,
        loot        =
        {
            { itemId = 30256, rate = 1000 },
            { itemId = 30257, rate = 400  },
            { itemId = 30258, rate = 150  },
        },
        deathMsg = "Nine Lives Nigel. This was life number nine.",
    },

    -- ================================================================
    -- TIGERS
    -- ================================================================
    stripey_steve =
    {
        name        = 'Stripey Steve',
        packetName  = 'Stripey Steve',
        groupRef    = { groupId = 28, groupZoneId = 2 },    -- Forest Tiger ref (verify)
        zones       = { 103, 112, 111 },
        level       = { 22, 28 },
        spawnTimer  = 6 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 240,
        isAggro     = true,
        loot        =
        {
            { itemId = 30280, rate = 1000 },
            { itemId = 30281, rate = 400  },
            { itemId = 30282, rate = 150  },
        },
        deathMsg = "Stripey Steve's stripes are forever.",
    },

    mauler_maurice =
    {
        name        = 'Mauler Maurice',
        packetName  = 'Mauler Maurice',
        groupRef    = { groupId = 28, groupZoneId = 2 },
        zones       = { 113, 125, 122 },
        level       = { 38, 46 },
        spawnTimer  = 16 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 130,
        isAggro     = true,
        loot        =
        {
            { itemId = 30283, rate = 1000 },
            { itemId = 30284, rate = 400  },
            { itemId = 30285, rate = 150  },
        },
        deathMsg = "Mauler Maurice lived up to his name. Right up until the end.",
    },

    saber_sabrina =
    {
        name        = 'Saber Sabrina',
        packetName  = 'Saber Sabrina',
        groupRef    = { groupId = 28, groupZoneId = 2 },
        zones       = { 51, 61, 68 },
        level       = { 58, 65 },
        spawnTimer  = 24 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 60,
        isAggro     = true,
        loot        =
        {
            { itemId = 30286, rate = 1000 },    -- Sabrina's Saber-Fang (trophy)
            { itemId = 30287, rate = 400  },    -- Sabrina's Feral Legs
            { itemId = 30288, rate = 150  },    -- Sabrina's Apex Ring
        },
        deathMsg = "Saber Sabrina's enormous fangs finally still.",
    },

    -- ================================================================
    -- MANDRAGORAS
    -- ================================================================
    root_rita =
    {
        name        = 'Root Rita',
        packetName  = 'Root Rita',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify mandragora groupRef
        zones       = { 100, 115, 116 },
        level       = { 6, 10 },
        spawnTimer  = 3 * 3600,
        spawnWindow = 1.5 * 3600,
        spawnChance = 300,
        isAggro     = false,
        loot        =
        {
            { itemId = 30310, rate = 1000 },
            { itemId = 30311, rate = 400  },
            { itemId = 30312, rate = 150  },
        },
        deathMsg = "Root Rita's scream was... actually quite melodic.",
    },

    sprout_spencer =
    {
        name        = 'Sprout Spencer',
        packetName  = 'Sprout Spencer',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 103, 112, 111 },
        level       = { 22, 28 },
        spawnTimer  = 10 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 200,
        isAggro     = false,
        loot        =
        {
            { itemId = 30313, rate = 1000 },
            { itemId = 30314, rate = 400  },
            { itemId = 30315, rate = 150  },
        },
        deathMsg = "Sprout Spencer returns to the earth. Literally.",
    },

    mandrake_max =
    {
        name        = 'Mandrake Max',
        packetName  = 'Mandrake Max',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 113, 122, 51 },
        level       = { 40, 48 },
        spawnTimer  = 18 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 110,
        isAggro     = true,
        loot        =
        {
            { itemId = 30316, rate = 1000 },
            { itemId = 30317, rate = 400  },
            { itemId = 30318, rate = 150  },
        },
        deathMsg = "Mandrake Max's final scream is heard across three zones.",
    },

    -- ================================================================
    -- BEETLES
    -- ================================================================
    click_clack_clayton =
    {
        name        = 'Click Clayton',
        packetName  = 'Click Clayton',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify beetle groupRef
        zones       = { 106, 107, 108 },
        level       = { 10, 15 },
        spawnTimer  = 4 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 280,
        isAggro     = false,
        loot        =
        {
            { itemId = 30340, rate = 1000 },
            { itemId = 30341, rate = 400  },
            { itemId = 30342, rate = 150  },
        },
        deathMsg = "Click Clack Clayton clicks and clacks no more.",
    },

    dung_douglas =
    {
        name        = 'Dung Douglas',
        packetName  = 'Dung Douglas',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 111, 112, 103 },
        level       = { 28, 34 },
        spawnTimer  = 12 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 180,
        isAggro     = false,
        loot        =
        {
            { itemId = 30343, rate = 1000 },
            { itemId = 30344, rate = 400  },
            { itemId = 30345, rate = 150  },
        },
        deathMsg = "Dung Douglas's prized dung ball rolls away, unclaimed.",
    },

    scarab_sebastian =
    {
        name        = 'Scarab Bastian',
        packetName  = 'Scarab Bastian',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 68, 79, 65 },
        level       = { 45, 52 },
        spawnTimer  = 20 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 100,
        isAggro     = true,
        loot        =
        {
            { itemId = 30346, rate = 1000 },
            { itemId = 30347, rate = 400  },
            { itemId = 30348, rate = 150  },
        },
        deathMsg = "Scarab Sebastian's sacred scarab glows faintly as he falls.",
    },

    -- ================================================================
    -- CRAWLERS
    -- ================================================================
    silk_simon =
    {
        name        = 'Silk Simon',
        packetName  = 'Silk Simon',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify crawler groupRef
        zones       = { 103, 112, 111 },
        level       = { 15, 20 },
        spawnTimer  = 6 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 240,
        isAggro     = false,
        loot        =
        {
            { itemId = 30370, rate = 1000 },
            { itemId = 30371, rate = 400  },
            { itemId = 30372, rate = 150  },
        },
        deathMsg = "Silk Simon leaves behind only the finest threads.",
    },

    cocoon_carl =
    {
        name        = 'Cocoon Carl',
        packetName  = 'Cocoon Carl',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 51, 83, 88 },
        level       = { 50, 58 },
        spawnTimer  = 20 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 100,
        isAggro     = true,
        loot        =
        {
            { itemId = 30373, rate = 1000 },
            { itemId = 30374, rate = 400  },
            { itemId = 30375, rate = 150  },
        },
        deathMsg = "Cocoon Carl will emerge again. Eventually.",
    },

    -- ================================================================
    -- BIRDS
    -- ================================================================
    feather_fred =
    {
        name        = 'Feather Fred',
        packetName  = 'Feather Fred',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify bird groupRef
        zones       = { 103, 112, 111 },
        level       = { 10, 15 },
        spawnTimer  = 4 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 280,
        isAggro     = false,
        loot        =
        {
            { itemId = 30400, rate = 1000 },
            { itemId = 30401, rate = 400  },
            { itemId = 30402, rate = 150  },
        },
        deathMsg = "Feather Fred sheds his finest feather on the way out.",
    },

    beaky_beatrice =
    {
        name        = 'Beaky Beatrice',
        packetName  = 'Beaky Beatrice',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 113, 122, 125 },
        level       = { 28, 35 },
        spawnTimer  = 12 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 180,
        isAggro     = false,
        loot        =
        {
            { itemId = 30403, rate = 1000 },
            { itemId = 30404, rate = 400  },
            { itemId = 30405, rate = 150  },
        },
        deathMsg = "Beaky Beatrice lets out one final, indignant squawk.",
    },

    plume_patricia =
    {
        name        = 'Plume Patricia',
        packetName  = 'Plume Patricia',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 51, 61, 65 },
        level       = { 50, 58 },
        spawnTimer  = 20 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 100,
        isAggro     = true,
        loot        =
        {
            { itemId = 30406, rate = 1000 },
            { itemId = 30407, rate = 400  },
            { itemId = 30408, rate = 150  },
        },
        deathMsg = "Plume Patricia's magnificent tail feathers drift to the ground.",
    },

    -- ================================================================
    -- BEES
    -- ================================================================
    honey_harold =
    {
        name        = 'Honey Harold',
        packetName  = 'Honey Harold',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify bee groupRef
        zones       = { 100, 115, 116 },
        level       = { 10, 15 },
        spawnTimer  = 4 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 280,
        isAggro     = false,
        loot        =
        {
            { itemId = 30430, rate = 1000 },
            { itemId = 30431, rate = 400  },
            { itemId = 30432, rate = 150  },
        },
        deathMsg = "Honey Harold's buzzzzz fades away.",
    },

    buzzard_barry =
    {
        name        = 'Buzzard Barry',
        packetName  = 'Buzzard Barry',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 103, 111, 112 },
        level       = { 30, 38 },
        spawnTimer  = 14 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 160,
        isAggro     = true,
        loot        =
        {
            { itemId = 30433, rate = 1000 },
            { itemId = 30434, rate = 400  },
            { itemId = 30435, rate = 150  },
        },
        deathMsg = "Buzzard Barry's angry buzzing finally stops.",
    },

    queen_quentin =
    {
        name        = 'Queen Quentin',
        packetName  = 'Queen Quentin',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 51, 68, 79 },
        level       = { 62, 70 },
        spawnTimer  = 24 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 60,
        isAggro     = true,
        loot        =
        {
            { itemId = 30436, rate = 1000 },
            { itemId = 30437, rate = 400  },
            { itemId = 30438, rate = 150  },
        },
        deathMsg = "Queen Quentin ruled for exactly one day. A good reign.",
    },

    -- ================================================================
    -- WORMS
    -- ================================================================
    wiggles_winston =
    {
        name        = 'Wiggles Winston',
        packetName  = 'Wiggles Winston',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify worm groupRef
        zones       = { 100, 115, 106 },
        level       = { 1, 5 },
        spawnTimer  = 2 * 3600,
        spawnWindow = 1 * 3600,
        spawnChance = 350,
        isAggro     = false,
        loot        =
        {
            { itemId = 30460, rate = 1000 },
            { itemId = 30461, rate = 400  },
            { itemId = 30462, rate = 150  },
        },
        deathMsg = "Wiggles Winston wiggles no more.",
    },

    squirmy_sherman =
    {
        name        = 'Squirmy Sherman',
        packetName  = 'Squirmy Sherman',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 103, 111, 112 },
        level       = { 18, 24 },
        spawnTimer  = 8 * 3600,
        spawnWindow = 2 * 3600,
        spawnChance = 220,
        isAggro     = false,
        loot        =
        {
            { itemId = 30463, rate = 1000 },
            { itemId = 30464, rate = 400  },
            { itemId = 30465, rate = 150  },
        },
        deathMsg = "Squirmy Sherman squirms his last squirm.",
    },

    earthcrawler_ernest =
    {
        name        = 'Earthcrawler Ern',
        packetName  = 'Earthcrawler Ern',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 113, 122, 51 },
        level       = { 40, 48 },
        spawnTimer  = 18 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 110,
        isAggro     = true,
        loot        =
        {
            { itemId = 30466, rate = 1000 },    -- Ernest's Earthen Core (trophy)
            { itemId = 30467, rate = 400  },    -- Ernest's Burrower Vest
            { itemId = 30468, rate = 150  },    -- Ernest's Tremor Boots
        },
        deathMsg = "Earthcrawler Ernest sinks back into the earth. He was always more comfortable underground.",
    },

    -- ================================================================
    -- LIZARDS
    -- ================================================================
    scaly_sally =
    {
        name        = 'Scaly Sally',
        packetName  = 'Scaly Sally',
        groupRef    = { groupId = 6, groupZoneId = 100 },   -- TODO: verify lizard groupRef
        zones       = { 116, 115, 100 },
        level       = { 8, 12 },
        spawnTimer  = 3 * 3600,
        spawnWindow = 1.5 * 3600,
        spawnChance = 310,
        isAggro     = true,
        loot        =
        {
            { itemId = 30490, rate = 1000 },    -- Sally's Scale Chip (trophy)
            { itemId = 30491, rate = 400  },    -- Sally's Scale Ring
            { itemId = 30492, rate = 150  },    -- Sally's Tail Belt
        },
        deathMsg = "Scaly Sally's iridescent scales scatter across the ground.",
    },

    coldblooded_carlos =
    {
        name        = 'Coldblooded Carl',
        packetName  = 'Coldblooded Carl',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 113, 112, 103 },
        level       = { 30, 36 },
        spawnTimer  = 12 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 180,
        isAggro     = true,
        loot        =
        {
            { itemId = 30493, rate = 1000 },    -- Carlos's Cold Scale (trophy)
            { itemId = 30494, rate = 400  },    -- Carlos's Reptile Vest
            { itemId = 30495, rate = 150  },    -- Carlos's Venom Earring
        },
        deathMsg = "Cold-blooded Carlos stares at you with cold, unblinking eyes. Then he falls over.",
    },

    basilisk_boris =
    {
        name        = 'Basilisk Boris',
        packetName  = 'Basilisk Boris',
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 51, 65, 68 },
        level       = { 52, 60 },
        spawnTimer  = 22 * 3600,
        spawnWindow = 4 * 3600,
        spawnChance = 80,
        isAggro     = true,
        loot        =
        {
            { itemId = 30496, rate = 1000 },    -- Boris's Basilisk Eye (trophy)
            { itemId = 30497, rate = 400  },    -- Boris's Granite Carapace
            { itemId = 30498, rate = 150  },    -- Boris's Stone Gaze Ring
        },
        deathMsg = "Basilisk Boris's legendary gaze dims. You'll never be turned to stone again.",
    },

    -- ================================================================
    -- THE JIMS  (goblin size joke)
    -- "Little Jim" is enormous. "Big Jim" is tiny.
    -- ================================================================
    --
    -- To find appropriately sized goblin groupRefs, run on your DB:
    --   SELECT groupid, zoneid, name FROM mob_groups WHERE name LIKE '%Goblin%' ORDER BY name LIMIT 30;
    --
    -- Pick a large variant (Goblin Lord / Chief / Ambusher) for Little Jim's groupRef.
    -- Pick a small variant (Goblin Peddler / Tapster / Weaver) for Big Jim's groupRef.
    -- Replace groupId/groupZoneId below with your findings.
    -- ================================================================

    little_jim =
    {
        name        = 'Little Jim',
        packetName  = 'Little Jim',
        -- TODO: set this to a LARGE goblin variant (Goblin Lord, Chief, etc.)
        -- e.g. { groupId = ???, groupZoneId = ??? }
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 103, 111, 112, 113 },
        level       = { 25, 32 },
        spawnTimer  = 10 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 180,
        isAggro     = true,
        loot        =
        {
            { itemId = 30520, rate = 1000 },    -- Little Jim's Big Trophy (trophy)
            { itemId = 30521, rate = 400  },    -- Little Jim's Big Boots
            { itemId = 30522, rate = 150  },    -- Little Jim's Big Ring
        },
        deathMsg    = 'Little Jim falls. He was not, in fact, little.',
    },

    big_jim =
    {
        name        = 'Big Jim',
        packetName  = 'Big Jim',
        -- TODO: set this to a SMALL goblin variant (Goblin Peddler, Tapster, etc.)
        -- e.g. { groupId = ???, groupZoneId = ??? }
        groupRef    = { groupId = 6, groupZoneId = 100 },
        zones       = { 103, 111, 112, 113 },
        level       = { 25, 32 },
        spawnTimer  = 10 * 3600,
        spawnWindow = 3 * 3600,
        spawnChance = 180,
        isAggro     = true,
        loot        =
        {
            { itemId = 30523, rate = 1000 },    -- Big Jim's Small Trophy (trophy)
            { itemId = 30524, rate = 400  },    -- Big Jim's Small Hat
            { itemId = 30525, rate = 150  },    -- Big Jim's Small Ring
        },
        deathMsg    = 'Big Jim falls. He was not, in fact, big.',
    },

    -- AUTO-GENERATED: 152 new named rares
    ["wooly_winifred"] = {
        name = "Wooly Winifred",
        packetName = "WolyWnfrd",
        groupRef = "wooly_winifred",
        zones = { {xi.zone.KONSCHTAT_HIGHLANDS}, {xi.zone.PASHHOW_MARSHLANDS} },
        level = 28,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30530, rate = 1000 },
            { itemId = 30531, rate = 700 },
            { itemId = 30532, rate = 500 },
        },
        deathMsg = "Wooly Winifred has been slain! Its rare treasures await...",
    },
    ["bouncy_beatrice"] = {
        name = "Bouncy Beatrice",
        packetName = "BncyBtrce",
        groupRef = "bouncy_beatrice",
        zones = { {xi.zone.VALKURM_DUNES}, {xi.zone.BUBURIMU_PENINSULA} },
        level = 22,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30533, rate = 1000 },
            { itemId = 30534, rate = 700 },
            { itemId = 30535, rate = 500 },
        },
        deathMsg = "Bouncy Beatrice has been slain! Its rare treasures await...",
    },
    ["crushing_clyde"] = {
        name = "Crushing Clyde",
        packetName = "CrshClyde",
        groupRef = "crushing_clyde",
        zones = { {xi.zone.QUFIM_ISLAND}, {xi.zone.BATALLIA_DOWNS} },
        level = 32,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30536, rate = 1000 },
            { itemId = 30537, rate = 700 },
            { itemId = 30538, rate = 500 },
        },
        deathMsg = "Crushing Clyde has been slain! Its rare treasures await...",
    },
    ["sneaky_seraphine"] = {
        name = "Sneaky Seraphine",
        packetName = "SnkySrphn",
        groupRef = "sneaky_seraphine",
        zones = { {xi.zone.JUGNER_FOREST}, {xi.zone.PASHHOW_MARSHLANDS} },
        level = 35,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30539, rate = 1000 },
            { itemId = 30540, rate = 700 },
            { itemId = 30541, rate = 500 },
        },
        deathMsg = "Sneaky Seraphine has been slain! Its rare treasures await...",
    },
    ["crackling_cordelia"] = {
        name = "Crackling Cordelia",
        packetName = "CrklCrdla",
        groupRef = "crackling_cordelia",
        zones = { {xi.zone.ROLANBERRY_FIELDS}, {xi.zone.SAUROMUGUE_CHAMPAIGN} },
        level = 45,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30542, rate = 1000 },
            { itemId = 30543, rate = 700 },
            { itemId = 30544, rate = 500 },
        },
        deathMsg = "Crackling Cordelia has been slain! Its rare treasures await...",
    },
    ["ferocious_frederica"] = {
        name = "Ferocious Frederica",
        packetName = "FrcsFrdrc",
        groupRef = "ferocious_frederica",
        zones = { {xi.zone.BEAUCEDINE_GLACIER}, {xi.zone.XARCABARD} },
        level = 52,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30545, rate = 1000 },
            { itemId = 30546, rate = 700 },
            { itemId = 30547, rate = 500 },
        },
        deathMsg = "Ferocious Frederica has been slain! Its rare treasures await...",
    },
    ["manic_millicent"] = {
        name = "Manic Millicent",
        packetName = "MncMllcnt",
        groupRef = "manic_millicent",
        zones = { {xi.zone.SANCTUARY_OF_ZITAH}, {xi.zone.EAST_SARUTABARUTA} },
        level = 28,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30548, rate = 1000 },
            { itemId = 30549, rate = 700 },
            { itemId = 30550, rate = 500 },
        },
        deathMsg = "Manic Millicent has been slain! Its rare treasures await...",
    },
    ["brutal_brendan"] = {
        name = "Brutal Brendan",
        packetName = "BrtlBrndn",
        groupRef = "brutal_brendan",
        zones = { {xi.zone.CRAWLER_S_NEST}, {xi.zone.GARLAIGE_CITADEL} },
        level = 40,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30551, rate = 1000 },
            { itemId = 30552, rate = 700 },
            { itemId = 30553, rate = 500 },
        },
        deathMsg = "Brutal Brendan has been slain! Its rare treasures await...",
    },
    ["gale_gertrude"] = {
        name = "Gale Gertrude",
        packetName = "GaleGrtrd",
        groupRef = "gale_gertrude",
        zones = { {xi.zone.ROLANBERRY_FIELDS}, {xi.zone.SAUROMUGUE_CHAMPAIGN} },
        level = 42,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30554, rate = 1000 },
            { itemId = 30555, rate = 700 },
            { itemId = 30556, rate = 500 },
        },
        deathMsg = "Gale Gertrude has been slain! Its rare treasures await...",
    },
    ["venomous_valentina"] = {
        name = "Venomous Valentina",
        packetName = "VnmVlntn",
        groupRef = "venomous_valentina",
        zones = { {xi.zone.SANCTUARY_OF_ZITAH}, {xi.zone.YUHTUNGA_JUNGLE} },
        level = 36,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30557, rate = 1000 },
            { itemId = 30558, rate = 700 },
            { itemId = 30559, rate = 500 },
        },
        deathMsg = "Venomous Valentina has been slain! Its rare treasures await...",
    },
    ["deep_dweller_deidre"] = {
        name = "Deep Dweller Deidre",
        packetName = "DpDwlDdr",
        groupRef = "deep_dweller_deidre",
        zones = { {xi.zone.GARLAIGE_CITADEL}, {xi.zone.ELDIEME_NECROPOLIS} },
        level = 44,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30560, rate = 1000 },
            { itemId = 30561, rate = 700 },
            { itemId = 30562, rate = 500 },
        },
        deathMsg = "Deep Dweller Deidre has been slain! Its rare treasures await...",
    },
    ["venerable_vincenzo"] = {
        name = "Venerable Vincenzo",
        packetName = "VnrVnczn",
        groupRef = "venerable_vincenzo",
        zones = { {xi.zone.CAPE_TERIGGAN}, {xi.zone.EASTERN_ALTEPA_DESERT} },
        level = 50,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30563, rate = 1000 },
            { itemId = 30564, rate = 700 },
            { itemId = 30565, rate = 500 },
        },
        deathMsg = "Venerable Vincenzo has been slain! Its rare treasures await...",
    },
    ["grunt_gideon"] = {
        name = "Grunt Gideon",
        packetName = "GrntGdn",
        groupRef = "grunt_gideon",
        zones = { {xi.zone.GHELSBA_OUTPOST} },
        level = 10,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30566, rate = 1000 },
            { itemId = 30567, rate = 700 },
            { itemId = 30568, rate = 500 },
        },
        deathMsg = "Grunt Gideon has been slain! Its rare treasures await...",
    },
    ["sergeant_sven"] = {
        name = "Sergeant Sven",
        packetName = "SrgtSvn",
        groupRef = "sergeant_sven",
        zones = { {xi.zone.CASTLE_OZTROJA}, {xi.zone.DAVOI} },
        level = 22,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30569, rate = 1000 },
            { itemId = 30570, rate = 700 },
            { itemId = 30571, rate = 500 },
        },
        deathMsg = "Sergeant Sven has been slain! Its rare treasures await...",
    },
    ["raging_reginald"] = {
        name = "Raging Reginald",
        packetName = "RgngRgnld",
        groupRef = "raging_reginald",
        zones = { {xi.zone.DAVOI}, {xi.zone.MONASTIC_CAVERN} },
        level = 35,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30572, rate = 1000 },
            { itemId = 30573, rate = 700 },
            { itemId = 30574, rate = 500 },
        },
        deathMsg = "Raging Reginald has been slain! Its rare treasures await...",
    },
    ["overlord_ophelia"] = {
        name = "Overlord Ophelia",
        packetName = "OvrlOphl",
        groupRef = "overlord_ophelia",
        zones = { {xi.zone.MONASTIC_CAVERN}, {xi.zone.CASTLE_ZVAHL_KEEP} },
        level = 50,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30575, rate = 1000 },
            { itemId = 30576, rate = 700 },
            { itemId = 30577, rate = 500 },
        },
        deathMsg = "Overlord Ophelia has been slain! Its rare treasures await...",
    },
    ["fledgling_fenwick"] = {
        name = "Fledgling Fenwick",
        packetName = "FldgFnwk",
        groupRef = "fledgling_fenwick",
        zones = { {xi.zone.GIDDEUS} },
        level = 10,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30578, rate = 1000 },
            { itemId = 30579, rate = 700 },
            { itemId = 30580, rate = 500 },
        },
        deathMsg = "Fledgling Fenwick has been slain! Its rare treasures await...",
    },
    ["devout_delilah"] = {
        name = "Devout Delilah",
        packetName = "DvtDllh",
        groupRef = "devout_delilah",
        zones = { {xi.zone.CASTLE_OZTROJA}, {xi.zone.GIDDEUS} },
        level = 22,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30581, rate = 1000 },
            { itemId = 30582, rate = 700 },
            { itemId = 30583, rate = 500 },
        },
        deathMsg = "Devout Delilah has been slain! Its rare treasures await...",
    },
    ["high_priest_horatio"] = {
        name = "High Priest Horatio",
        packetName = "HghPrHrt",
        groupRef = "high_priest_horatio",
        zones = { {xi.zone.CASTLE_OZTROJA} },
        level = 35,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30584, rate = 1000 },
            { itemId = 30585, rate = 700 },
            { itemId = 30586, rate = 500 },
        },
        deathMsg = "High Priest Horatio has been slain! Its rare treasures await...",
    },
    ["divine_diomedea"] = {
        name = "Divine Diomedea",
        packetName = "DvnDmda",
        groupRef = "divine_diomedea",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH}, {xi.zone.DEN_OF_RANCOR} },
        level = 50,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30587, rate = 1000 },
            { itemId = 30588, rate = 700 },
            { itemId = 30589, rate = 500 },
        },
        deathMsg = "Divine Diomedea has been slain! Its rare treasures await...",
    },
    ["copper_cornelius"] = {
        name = "Copper Cornelius",
        packetName = "CprCrnls",
        groupRef = "copper_cornelius",
        zones = { {xi.zone.PALBOROUGH_MINES} },
        level = 10,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30590, rate = 1000 },
            { itemId = 30591, rate = 700 },
            { itemId = 30592, rate = 500 },
        },
        deathMsg = "Copper Cornelius has been slain! Its rare treasures await...",
    },
    ["silver_sylvester"] = {
        name = "Silver Sylvester",
        packetName = "SlvrSlvst",
        groupRef = "silver_sylvester",
        zones = { {xi.zone.PALBOROUGH_MINES}, {xi.zone.BEADEAUX} },
        level = 22,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30593, rate = 1000 },
            { itemId = 30594, rate = 700 },
            { itemId = 30595, rate = 500 },
        },
        deathMsg = "Silver Sylvester has been slain! Its rare treasures await...",
    },
    ["boulder_basil"] = {
        name = "Boulder Basil",
        packetName = "BldrBsl",
        groupRef = "boulder_basil",
        zones = { {xi.zone.BEADEAUX}, {xi.zone.QULUN_DOME} },
        level = 35,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30596, rate = 1000 },
            { itemId = 30597, rate = 700 },
            { itemId = 30598, rate = 500 },
        },
        deathMsg = "Boulder Basil has been slain! Its rare treasures await...",
    },
    ["diamond_desmond"] = {
        name = "Diamond Desmond",
        packetName = "DmndDsmnd",
        groupRef = "diamond_desmond",
        zones = { {xi.zone.QULUN_DOME}, {xi.zone.CASTLE_ZVAHL_KEEP} },
        level = 50,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30599, rate = 1000 },
            { itemId = 30600, rate = 700 },
            { itemId = 30601, rate = 500 },
        },
        deathMsg = "Diamond Desmond has been slain! Its rare treasures await...",
    },
    ["flittering_fiona"] = {
        name = "Flittering Fiona",
        packetName = "FltFna",
        groupRef = "flittering_fiona",
        zones = { {xi.zone.INNER_HORUTOTO_RUINS}, {xi.zone.OUTER_HORUTOTO_RUINS} },
        level = 8,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30602, rate = 1000 },
            { itemId = 30603, rate = 700 },
            { itemId = 30604, rate = 500 },
        },
        deathMsg = "Flittering Fiona has been slain! Its rare treasures await...",
    },
    ["echo_edgar"] = {
        name = "Echo Edgar",
        packetName = "EchoEdgr",
        groupRef = "echo_edgar",
        zones = { {xi.zone.GUSGEN_MINES}, {xi.zone.MAZE_OF_SHAKHRAMI} },
        level = 18,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30605, rate = 1000 },
            { itemId = 30606, rate = 700 },
            { itemId = 30607, rate = 500 },
        },
        deathMsg = "Echo Edgar has been slain! Its rare treasures await...",
    },
    ["vampiric_valerian"] = {
        name = "Vampiric Valerian",
        packetName = "VmpVlrn",
        groupRef = "vampiric_valerian",
        zones = { {xi.zone.ELDIEME_NECROPOLIS}, {xi.zone.GARLAIGE_CITADEL} },
        level = 32,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30608, rate = 1000 },
            { itemId = 30609, rate = 700 },
            { itemId = 30610, rate = 500 },
        },
        deathMsg = "Vampiric Valerian has been slain! Its rare treasures await...",
    },
    ["ancient_araminta"] = {
        name = "Ancient Araminta",
        packetName = "AncArmnt",
        groupRef = "ancient_araminta",
        zones = { {xi.zone.CRAWLERS_NEST}, {xi.zone.TEMPLE_OF_UGGALEPIH} },
        level = 45,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30611, rate = 1000 },
            { itemId = 30612, rate = 700 },
            { itemId = 30613, rate = 500 },
        },
        deathMsg = "Ancient Araminta has been slain! Its rare treasures await...",
    },
    ["slithering_silas"] = {
        name = "Slithering Silas",
        packetName = "SlthrSls",
        groupRef = "slithering_silas",
        zones = { {xi.zone.WEST_RONFAURE}, {xi.zone.SOUTH_GUSTABERG} },
        level = 8,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30614, rate = 1000 },
            { itemId = 30615, rate = 700 },
            { itemId = 30616, rate = 500 },
        },
        deathMsg = "Slithering Silas has been slain! Its rare treasures await...",
    },
    ["hypnotic_heloise"] = {
        name = "Hypnotic Heloise",
        packetName = "HypHlse",
        groupRef = "hypnotic_heloise",
        zones = { {xi.zone.VALKURM_DUNES}, {xi.zone.BUBURIMU_PENINSULA} },
        level = 20,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30617, rate = 1000 },
            { itemId = 30618, rate = 700 },
            { itemId = 30619, rate = 500 },
        },
        deathMsg = "Hypnotic Heloise has been slain! Its rare treasures await...",
    },
    ["constrictor_cressida"] = {
        name = "Constrictor Cressida",
        packetName = "CnstCrsd",
        groupRef = "constrictor_cressida",
        zones = { {xi.zone.GARLAIGE_CITADEL}, {xi.zone.CRAWLER_S_NEST} },
        level = 34,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30620, rate = 1000 },
            { itemId = 30621, rate = 700 },
            { itemId = 30622, rate = 500 },
        },
        deathMsg = "Constrictor Cressida has been slain! Its rare treasures await...",
    },
    ["venom_duchess_viviane"] = {
        name = "Venom Duchess Viviane",
        packetName = "VnmDVvn",
        groupRef = "venom_duchess_viviane",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH}, {xi.zone.DEN_OF_RANCOR} },
        level = 48,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30623, rate = 1000 },
            { itemId = 30624, rate = 700 },
            { itemId = 30625, rate = 500 },
        },
        deathMsg = "Venom Duchess Viviane has been slain! Its rare treasures await...",
    },
    ["buzzing_barnabas"] = {
        name = "Buzzing Barnabas",
        packetName = "BzzBrnbs",
        groupRef = "buzzing_barnabas",
        zones = { {xi.zone.WEST_SARUTABARUTA}, {xi.zone.TAHRONGI_CANYON} },
        level = 10,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30626, rate = 1000 },
            { itemId = 30627, rate = 700 },
            { itemId = 30628, rate = 500 },
        },
        deathMsg = "Buzzing Barnabas has been slain! Its rare treasures await...",
    },
    ["droning_dorothea"] = {
        name = "Droning Dorothea",
        packetName = "DrnDrtha",
        groupRef = "droning_dorothea",
        zones = { {xi.zone.SANCTUARY_OF_ZITAH}, {xi.zone.YUHTUNGA_JUNGLE} },
        level = 25,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30629, rate = 1000 },
            { itemId = 30630, rate = 700 },
            { itemId = 30631, rate = 500 },
        },
        deathMsg = "Droning Dorothea has been slain! Its rare treasures await...",
    },
    ["plague_bearer_percival"] = {
        name = "Plague Bearer Percival",
        packetName = "PlgBPrcvl",
        groupRef = "plague_bearer_percival",
        zones = { {xi.zone.CRAWLER_S_NEST}, {xi.zone.GARLAIGE_CITADEL} },
        level = 38,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30632, rate = 1000 },
            { itemId = 30633, rate = 700 },
            { itemId = 30634, rate = 500 },
        },
        deathMsg = "Plague Bearer Percival has been slain! Its rare treasures await...",
    },
    ["swarm_queen_sophonias"] = {
        name = "Swarm Queen Sophonias",
        packetName = "SwrmQSphn",
        groupRef = "swarm_queen_sophonias",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH} },
        level = 52,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30635, rate = 1000 },
            { itemId = 30636, rate = 700 },
            { itemId = 30637, rate = 500 },
        },
        deathMsg = "Swarm Queen Sophonias has been slain! Its rare treasures await...",
    },
    ["gnawing_nathaniel"] = {
        name = "Gnawing Nathaniel",
        packetName = "GnwNthnl",
        groupRef = "gnawing_nathaniel",
        zones = { {xi.zone.GUSGEN_MINES}, {xi.zone.MAZE_OF_SHAKHRAMI} },
        level = 14,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30638, rate = 1000 },
            { itemId = 30639, rate = 700 },
            { itemId = 30640, rate = 500 },
        },
        deathMsg = "Gnawing Nathaniel has been slain! Its rare treasures await...",
    },
    ["festering_francesca"] = {
        name = "Festering Francesca",
        packetName = "FstrFrncs",
        groupRef = "festering_francesca",
        zones = { {xi.zone.ELDIEME_NECROPOLIS} },
        level = 26,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30641, rate = 1000 },
            { itemId = 30642, rate = 700 },
            { itemId = 30643, rate = 500 },
        },
        deathMsg = "Festering Francesca has been slain! Its rare treasures await...",
    },
    ["hunger_ravaged_hortensia"] = {
        name = "Hunger Ravaged Hortensia",
        packetName = "HngrHrtn",
        groupRef = "hunger_ravaged_hortensia",
        zones = { {xi.zone.ELDIEME_NECROPOLIS}, {xi.zone.GARLAIGE_CITADEL} },
        level = 38,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30644, rate = 1000 },
            { itemId = 30645, rate = 700 },
            { itemId = 30646, rate = 500 },
        },
        deathMsg = "Hunger Ravaged Hortensia has been slain! Its rare treasures await...",
    },
    ["carrion_cornelius"] = {
        name = "Carrion Cornelius",
        packetName = "CrrnCrnls",
        groupRef = "carrion_cornelius",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH}, {xi.zone.DEN_OF_RANCOR} },
        level = 50,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30647, rate = 1000 },
            { itemId = 30648, rate = 700 },
            { itemId = 30649, rate = 500 },
        },
        deathMsg = "Carrion Cornelius has been slain! Its rare treasures await...",
    },
    ["rattling_roderick"] = {
        name = "Rattling Roderick",
        packetName = "RttlRdrck",
        groupRef = "rattling_roderick",
        zones = { {xi.zone.GUSGEN_MINES}, {xi.zone.INNER_HORUTOTO_RUINS} },
        level = 12,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30650, rate = 1000 },
            { itemId = 30651, rate = 700 },
            { itemId = 30652, rate = 500 },
        },
        deathMsg = "Rattling Roderick has been slain! Its rare treasures await...",
    },
    ["cursed_cavendish"] = {
        name = "Cursed Cavendish",
        packetName = "CrsdCvnds",
        groupRef = "cursed_cavendish",
        zones = { {xi.zone.ELDIEME_NECROPOLIS} },
        level = 26,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30653, rate = 1000 },
            { itemId = 30654, rate = 700 },
            { itemId = 30655, rate = 500 },
        },
        deathMsg = "Cursed Cavendish has been slain! Its rare treasures await...",
    },
    ["bonewalker_benedict"] = {
        name = "Bonewalker Benedict",
        packetName = "BnwlkBndc",
        groupRef = "bonewalker_benedict",
        zones = { {xi.zone.ELDIEME_NECROPOLIS}, {xi.zone.GARLAIGE_CITADEL} },
        level = 38,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30656, rate = 1000 },
            { itemId = 30657, rate = 700 },
            { itemId = 30658, rate = 500 },
        },
        deathMsg = "Bonewalker Benedict has been slain! Its rare treasures await...",
    },
    ["lich_lord_leontine"] = {
        name = "Lich Lord Leontine",
        packetName = "LchLrdLnt",
        groupRef = "lich_lord_leontine",
        zones = { {xi.zone.CASTLE_ZVAHL_KEEP}, {xi.zone.ELDIEME_NECROPOLIS} },
        level = 52,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30659, rate = 1000 },
            { itemId = 30660, rate = 700 },
            { itemId = 30661, rate = 500 },
        },
        deathMsg = "Lich Lord Leontine has been slain! Its rare treasures await...",
    },
    ["snapping_simeon"] = {
        name = "Snapping Simeon",
        packetName = "SnpSmn",
        groupRef = "snapping_simeon",
        zones = { {xi.zone.MAZE_OF_SHAKHRAMI}, {xi.zone.TAHRONGI_CANYON} },
        level = 14,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30662, rate = 1000 },
            { itemId = 30663, rate = 700 },
            { itemId = 30664, rate = 500 },
        },
        deathMsg = "Snapping Simeon has been slain! Its rare treasures await...",
    },
    ["venomous_vespera"] = {
        name = "Venomous Vespera",
        packetName = "VnmVspr",
        groupRef = "venomous_vespera",
        zones = { {xi.zone.EASTERN_ALTEPA_DESERT}, {xi.zone.WESTERN_ALTEPA_DESERT} },
        level = 28,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30665, rate = 1000 },
            { itemId = 30666, rate = 700 },
            { itemId = 30667, rate = 500 },
        },
        deathMsg = "Venomous Vespera has been slain! Its rare treasures await...",
    },
    ["pincer_patriarch_ptolemy"] = {
        name = "Pincer Patriarch Ptolemy",
        packetName = "PncPtlmy",
        groupRef = "pincer_patriarch_ptolemy",
        zones = { {xi.zone.WESTERN_ALTEPA_DESERT}, {xi.zone.CRAWLER_S_NEST} },
        level = 40,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30668, rate = 1000 },
            { itemId = 30669, rate = 700 },
            { itemId = 30670, rate = 500 },
        },
        deathMsg = "Pincer Patriarch Ptolemy has been slain! Its rare treasures await...",
    },
    ["deathstalker_dagny"] = {
        name = "Deathstalker Dagny",
        packetName = "DthstkDgn",
        groupRef = "deathstalker_dagny",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH}, {xi.zone.EASTERN_ALTEPA_DESERT} },
        level = 52,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30671, rate = 1000 },
            { itemId = 30672, rate = 700 },
            { itemId = 30673, rate = 500 },
        },
        deathMsg = "Deathstalker Dagny has been slain! Its rare treasures await...",
    },
    ["weaving_wendy"] = {
        name = "Weaving Wendy",
        packetName = "WvngWndy",
        groupRef = "weaving_wendy",
        zones = { {xi.zone.WEST_SARUTABARUTA}, {xi.zone.TAHRONGI_CANYON} },
        level = 10,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30674, rate = 1000 },
            { itemId = 30675, rate = 700 },
            { itemId = 30676, rate = 500 },
        },
        deathMsg = "Weaving Wendy has been slain! Its rare treasures await...",
    },
    ["sticky_stanislava"] = {
        name = "Sticky Stanislava",
        packetName = "StkyStnsl",
        groupRef = "sticky_stanislava",
        zones = { {xi.zone.MAZE_OF_SHAKHRAMI}, {xi.zone.CRAWLER_S_NEST} },
        level = 24,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30677, rate = 1000 },
            { itemId = 30678, rate = 700 },
            { itemId = 30679, rate = 500 },
        },
        deathMsg = "Sticky Stanislava has been slain! Its rare treasures await...",
    },
    ["ensnaring_eleanor"] = {
        name = "Ensnaring Eleanor",
        packetName = "EnsnElnr",
        groupRef = "ensnaring_eleanor",
        zones = { {xi.zone.CRAWLER_S_NEST}, {xi.zone.GARLAIGE_CITADEL} },
        level = 36,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30680, rate = 1000 },
            { itemId = 30681, rate = 700 },
            { itemId = 30682, rate = 500 },
        },
        deathMsg = "Ensnaring Eleanor has been slain! Its rare treasures await...",
    },
    ["great_weaver_gwendolyn"] = {
        name = "Great Weaver Gwendolyn",
        packetName = "GrtwvGwnd",
        groupRef = "great_weaver_gwendolyn",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH}, {xi.zone.DEN_OF_RANCOR} },
        level = 50,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30683, rate = 1000 },
            { itemId = 30684, rate = 700 },
            { itemId = 30685, rate = 500 },
        },
        deathMsg = "Great Weaver Gwendolyn has been slain! Its rare treasures await...",
    },
    ["oozing_oswald"] = {
        name = "Oozing Oswald",
        packetName = "OzngOswld",
        groupRef = "oozing_oswald",
        zones = { {xi.zone.INNER_HORUTOTO_RUINS}, {xi.zone.OUTER_HORUTOTO_RUINS} },
        level = 8,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30686, rate = 1000 },
            { itemId = 30687, rate = 700 },
            { itemId = 30688, rate = 500 },
        },
        deathMsg = "Oozing Oswald has been slain! Its rare treasures await...",
    },
    ["bubbling_borghild"] = {
        name = "Bubbling Borghild",
        packetName = "BblBrghld",
        groupRef = "bubbling_borghild",
        zones = { {xi.zone.GUSGEN_MINES}, {xi.zone.PALBOROUGH_MINES} },
        level = 20,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30689, rate = 1000 },
            { itemId = 30690, rate = 700 },
            { itemId = 30691, rate = 500 },
        },
        deathMsg = "Bubbling Borghild has been slain! Its rare treasures await...",
    },
    ["corrosive_callista"] = {
        name = "Corrosive Callista",
        packetName = "CrsvCllst",
        groupRef = "corrosive_callista",
        zones = { {xi.zone.CRAWLER_S_NEST}, {xi.zone.GARLAIGE_CITADEL} },
        level = 34,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30692, rate = 1000 },
            { itemId = 30693, rate = 700 },
            { itemId = 30694, rate = 500 },
        },
        deathMsg = "Corrosive Callista has been slain! Its rare treasures await...",
    },
    ["primordial_proteus"] = {
        name = "Primordial Proteus",
        packetName = "PrmrdlPrt",
        groupRef = "primordial_proteus",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH}, {xi.zone.DEN_OF_RANCOR} },
        level = 48,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30695, rate = 1000 },
            { itemId = 30696, rate = 700 },
            { itemId = 30697, rate = 500 },
        },
        deathMsg = "Primordial Proteus has been slain! Its rare treasures await...",
    },
    ["splashing_salvatore"] = {
        name = "Splashing Salvatore",
        packetName = "SplshSlvt",
        groupRef = "splashing_salvatore",
        zones = { {xi.zone.VALKURM_DUNES}, {xi.zone.BUBURIMU_PENINSULA} },
        level = 12,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30698, rate = 1000 },
            { itemId = 30699, rate = 700 },
            { itemId = 30700, rate = 500 },
        },
        deathMsg = "Splashing Salvatore has been slain! Its rare treasures await...",
    },
    ["snapping_sicily"] = {
        name = "Snapping Sicily",
        packetName = "SnpSclly",
        groupRef = "snapping_sicily",
        zones = { {xi.zone.QUFIM_ISLAND}, {xi.zone.BATTALIA_DOWNS} },
        level = 24,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30701, rate = 1000 },
            { itemId = 30702, rate = 700 },
            { itemId = 30703, rate = 500 },
        },
        deathMsg = "Snapping Sicily has been slain! Its rare treasures await...",
    },
    ["torrent_tiberius"] = {
        name = "Torrent Tiberius",
        packetName = "TrntTbrs",
        groupRef = "torrent_tiberius",
        zones = { {xi.zone.CAPE_TERIGGAN}, {xi.zone.WESTERN_ALTEPA_DESERT} },
        level = 36,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30704, rate = 1000 },
            { itemId = 30705, rate = 700 },
            { itemId = 30706, rate = 500 },
        },
        deathMsg = "Torrent Tiberius has been slain! Its rare treasures await...",
    },
    ["deep_king_delacroix"] = {
        name = "Deep King Delacroix",
        packetName = "DpKngDlcx",
        groupRef = "deep_king_delacroix",
        zones = { {xi.zone.SEA_SERPENT_GROTTO}, {xi.zone.QUFIM_ISLAND} },
        level = 48,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30707, rate = 1000 },
            { itemId = 30708, rate = 700 },
            { itemId = 30709, rate = 500 },
        },
        deathMsg = "Deep King Delacroix has been slain! Its rare treasures await...",
    },
    ["lumbering_loretta"] = {
        name = "Lumbering Loretta",
        packetName = "LmbrLrtta",
        groupRef = "lumbering_loretta",
        zones = { {xi.zone.TAHRONGI_CANYON}, {xi.zone.BUBURIMU_PENINSULA} },
        level = 14,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30710, rate = 1000 },
            { itemId = 30711, rate = 700 },
            { itemId = 30712, rate = 500 },
        },
        deathMsg = "Lumbering Loretta has been slain! Its rare treasures await...",
    },
    ["thundering_thaddeus"] = {
        name = "Thundering Thaddeus",
        packetName = "ThndrThds",
        groupRef = "thundering_thaddeus",
        zones = { {xi.zone.ROLANBERRY_FIELDS}, {xi.zone.SAUROMUGUE_CHAMPAIGN} },
        level = 28,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30713, rate = 1000 },
            { itemId = 30714, rate = 700 },
            { itemId = 30715, rate = 500 },
        },
        deathMsg = "Thundering Thaddeus has been slain! Its rare treasures await...",
    },
    ["crasher_crisanta"] = {
        name = "Crasher Crisanta",
        packetName = "CrshrCrsnt",
        groupRef = "crasher_crisanta",
        zones = { {xi.zone.CAPE_TERIGGAN}, {xi.zone.EASTERN_ALTEPA_DESERT} },
        level = 40,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30716, rate = 1000 },
            { itemId = 30717, rate = 700 },
            { itemId = 30718, rate = 500 },
        },
        deathMsg = "Crasher Crisanta has been slain! Its rare treasures await...",
    },
    ["patriarch_percival"] = {
        name = "Patriarch Percival",
        packetName = "PtrkPrcvl",
        groupRef = "patriarch_percival",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION}, {xi.zone.CAPE_TERIGGAN} },
        level = 54,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30719, rate = 1000 },
            { itemId = 30720, rate = 700 },
            { itemId = 30721, rate = 500 },
        },
        deathMsg = "Patriarch Percival has been slain! Its rare treasures await...",
    },
    ["clumsy_clemens"] = {
        name = "Clumsy Clemens",
        packetName = "ClmsyClmns",
        groupRef = "clumsy_clemens",
        zones = { {xi.zone.KONSCHTAT_HIGHLANDS}, {xi.zone.LA_THEINE_PLATEAU} },
        level = 18,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30722, rate = 1000 },
            { itemId = 30723, rate = 700 },
            { itemId = 30724, rate = 500 },
        },
        deathMsg = "Clumsy Clemens has been slain! Its rare treasures await...",
    },
    ["booming_bartholomew"] = {
        name = "Booming Bartholomew",
        packetName = "BmngBrthlm",
        groupRef = "booming_bartholomew",
        zones = { {xi.zone.BATALLIA_DOWNS}, {xi.zone.JUGNER_FOREST} },
        level = 30,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30725, rate = 1000 },
            { itemId = 30726, rate = 700 },
            { itemId = 30727, rate = 500 },
        },
        deathMsg = "Booming Bartholomew has been slain! Its rare treasures await...",
    },
    ["crusher_conrad"] = {
        name = "Crusher Conrad",
        packetName = "CrshrCnrd",
        groupRef = "crusher_conrad",
        zones = { {xi.zone.ROLANBERRY_FIELDS}, {xi.zone.SAUROMUGUE_CHAMPAIGN} },
        level = 42,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30728, rate = 1000 },
            { itemId = 30729, rate = 700 },
            { itemId = 30730, rate = 500 },
        },
        deathMsg = "Crusher Conrad has been slain! Its rare treasures await...",
    },
    ["titan_theobald"] = {
        name = "Titan Theobald",
        packetName = "TtnThbld",
        groupRef = "titan_theobald",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION}, {xi.zone.CASTLE_ZVAHL_KEEP} },
        level = 55,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30731, rate = 1000 },
            { itemId = 30732, rate = 700 },
            { itemId = 30733, rate = 500 },
        },
        deathMsg = "Titan Theobald has been slain! Its rare treasures await...",
    },
    ["mossy_mortimer"] = {
        name = "Mossy Mortimer",
        packetName = "MssyMrtmr",
        groupRef = "mossy_mortimer",
        zones = { {xi.zone.WEST_RONFAURE}, {xi.zone.NORTH_GUSTABERG} },
        level = 12,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30734, rate = 1000 },
            { itemId = 30735, rate = 700 },
            { itemId = 30736, rate = 500 },
        },
        deathMsg = "Mossy Mortimer has been slain! Its rare treasures await...",
    },
    ["ancient_aldric"] = {
        name = "Ancient Aldric",
        packetName = "AncntAldr",
        groupRef = "ancient_aldric",
        zones = { {xi.zone.JUGNER_FOREST}, {xi.zone.BATALLIA_DOWNS} },
        level = 26,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30737, rate = 1000 },
            { itemId = 30738, rate = 700 },
            { itemId = 30739, rate = 500 },
        },
        deathMsg = "Ancient Aldric has been slain! Its rare treasures await...",
    },
    ["elder_grove_elspeth"] = {
        name = "Elder Grove Elspeth",
        packetName = "EldrGrvElsp",
        groupRef = "elder_grove_elspeth",
        zones = { {xi.zone.BATALLIA_DOWNS}, {xi.zone.ROLANBERRY_FIELDS} },
        level = 38,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30740, rate = 1000 },
            { itemId = 30741, rate = 700 },
            { itemId = 30742, rate = 500 },
        },
        deathMsg = "Elder Grove Elspeth has been slain! Its rare treasures await...",
    },
    ["world_tree_wilhelmina"] = {
        name = "World Tree Wilhelmina",
        packetName = "WrldTrWhlm",
        groupRef = "world_tree_wilhelmina",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION}, {xi.zone.ROLANBERRY_FIELDS} },
        level = 52,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30743, rate = 1000 },
            { itemId = 30744, rate = 700 },
            { itemId = 30745, rate = 500 },
        },
        deathMsg = "World Tree Wilhelmina has been slain! Its rare treasures await...",
    },
    ["mischief_marcelino"] = {
        name = "Mischief Marcelino",
        packetName = "MschfMrcln",
        groupRef = "mischief_marcelino",
        zones = { {xi.zone.RANGUEMONT_PASS}, {xi.zone.BEAUCEDINE_GLACIER} },
        level = 20,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30746, rate = 1000 },
            { itemId = 30747, rate = 700 },
            { itemId = 30748, rate = 500 },
        },
        deathMsg = "Mischief Marcelino has been slain! Its rare treasures await...",
    },
    ["trickster_temperance"] = {
        name = "Trickster Temperance",
        packetName = "TrkstrTmpr",
        groupRef = "trickster_temperance",
        zones = { {xi.zone.BEAUCEDINE_GLACIER}, {xi.zone.XARCABARD} },
        level = 32,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30749, rate = 1000 },
            { itemId = 30750, rate = 700 },
            { itemId = 30751, rate = 500 },
        },
        deathMsg = "Trickster Temperance has been slain! Its rare treasures await...",
    },
    ["hexing_hieronymus"] = {
        name = "Hexing Hieronymus",
        packetName = "HxngHrnms",
        groupRef = "hexing_hieronymus",
        zones = { {xi.zone.XARCABARD}, {xi.zone.CASTLE_ZVAHL_KEEP} },
        level = 44,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30752, rate = 1000 },
            { itemId = 30753, rate = 700 },
            { itemId = 30754, rate = 500 },
        },
        deathMsg = "Hexing Hieronymus has been slain! Its rare treasures await...",
    },
    ["grand_trickster_gregoire"] = {
        name = "Grand Trickster Gregoire",
        packetName = "GrndTrkGrg",
        groupRef = "grand_trickster_gregoire",
        zones = { {xi.zone.CASTLE_ZVAHL_KEEP}, {xi.zone.CASTLE_ZVAHL_BAILEYS} },
        level = 54,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30755, rate = 1000 },
            { itemId = 30756, rate = 700 },
            { itemId = 30757, rate = 500 },
        },
        deathMsg = "Grand Trickster Gregoire has been slain! Its rare treasures await...",
    },
    ["tiny_tortuga"] = {
        name = "Tiny Tortuga",
        packetName = "TnyTrtga",
        groupRef = "tiny_tortuga",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH} },
        level = 30,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30758, rate = 1000 },
            { itemId = 30759, rate = 700 },
            { itemId = 30760, rate = 500 },
        },
        deathMsg = "Tiny Tortuga has been slain! Its rare treasures await...",
    },
    ["shuffling_sebastiano"] = {
        name = "Shuffling Sebastiano",
        packetName = "ShflSbstn",
        groupRef = "shuffling_sebastiano",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH} },
        level = 40,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30761, rate = 1000 },
            { itemId = 30762, rate = 700 },
            { itemId = 30763, rate = 500 },
        },
        deathMsg = "Shuffling Sebastiano has been slain! Its rare treasures await...",
    },
    ["grudge_bearer_giuliana"] = {
        name = "Grudge Bearer Giuliana",
        packetName = "GrdgBGlna",
        groupRef = "grudge_bearer_giuliana",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH}, {xi.zone.DEN_OF_RANCOR} },
        level = 50,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30764, rate = 1000 },
            { itemId = 30765, rate = 700 },
            { itemId = 30766, rate = 500 },
        },
        deathMsg = "Grudge Bearer Giuliana has been slain! Its rare treasures await...",
    },
    ["the_last_tonberry"] = {
        name = "The Last Tonberry",
        packetName = "LstTnbry",
        groupRef = "the_last_tonberry",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH} },
        level = 60,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30767, rate = 1000 },
            { itemId = 30768, rate = 700 },
            { itemId = 30769, rate = 500 },
        },
        deathMsg = "The Last Tonberry has been slain! Its rare treasures await...",
    },
    ["rippling_rocco"] = {
        name = "Rippling Rocco",
        packetName = "RpplRcco",
        groupRef = "rippling_rocco",
        zones = { {xi.zone.QUFIM_ISLAND}, {xi.zone.VALKURM_DUNES} },
        level = 16,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30770, rate = 1000 },
            { itemId = 30771, rate = 700 },
            { itemId = 30772, rate = 500 },
        },
        deathMsg = "Rippling Rocco has been slain! Its rare treasures await...",
    },
    ["tidecaller_thessaly"] = {
        name = "Tidecaller Thessaly",
        packetName = "TdclThsly",
        groupRef = "tidecaller_thessaly",
        zones = { {xi.zone.SEA_SERPENT_GROTTO}, {xi.zone.QUFIM_ISLAND} },
        level = 30,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30773, rate = 1000 },
            { itemId = 30774, rate = 700 },
            { itemId = 30775, rate = 500 },
        },
        deathMsg = "Tidecaller Thessaly has been slain! Its rare treasures await...",
    },
    ["brine_baron_baldassare"] = {
        name = "Brine Baron Baldassare",
        packetName = "BrnBrnBlds",
        groupRef = "brine_baron_baldassare",
        zones = { {xi.zone.SEA_SERPENT_GROTTO} },
        level = 42,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30776, rate = 1000 },
            { itemId = 30777, rate = 700 },
            { itemId = 30778, rate = 500 },
        },
        deathMsg = "Brine Baron Baldassare has been slain! Its rare treasures await...",
    },
    ["deep_sovereign_desideria"] = {
        name = "Deep Sovereign Desideria",
        packetName = "DpSvDesdr",
        groupRef = "deep_sovereign_desideria",
        zones = { {xi.zone.SEA_SERPENT_GROTTO}, {xi.zone.TEMPLE_OF_UGGALEPIH} },
        level = 54,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30779, rate = 1000 },
            { itemId = 30780, rate = 700 },
            { itemId = 30781, rate = 500 },
        },
        deathMsg = "Deep Sovereign Desideria has been slain! Its rare treasures await...",
    },
    ["prancing_persephone"] = {
        name = "Prancing Persephone",
        packetName = "PrncPrsph",
        groupRef = "prancing_persephone",
        zones = { {xi.zone.SAUROMUGUE_CHAMPAIGN}, {xi.zone.BATALLIA_DOWNS} },
        level = 24,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30782, rate = 1000 },
            { itemId = 30783, rate = 700 },
            { itemId = 30784, rate = 500 },
        },
        deathMsg = "Prancing Persephone has been slain! Its rare treasures await...",
    },
    ["thunderwing_theron"] = {
        name = "Thunderwing Theron",
        packetName = "ThndwngThrn",
        groupRef = "thunderwing_theron",
        zones = { {xi.zone.ROLANBERRY_FIELDS}, {xi.zone.SAUROMUGUE_CHAMPAIGN} },
        level = 36,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30785, rate = 1000 },
            { itemId = 30786, rate = 700 },
            { itemId = 30787, rate = 500 },
        },
        deathMsg = "Thunderwing Theron has been slain! Its rare treasures await...",
    },
    ["skydancer_sabastienne"] = {
        name = "Skydancer Sabastienne",
        packetName = "SkyDncSbst",
        groupRef = "skydancer_sabastienne",
        zones = { {xi.zone.CAPE_TERIGGAN}, {xi.zone.ROLANBERRY_FIELDS} },
        level = 46,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30788, rate = 1000 },
            { itemId = 30789, rate = 700 },
            { itemId = 30790, rate = 500 },
        },
        deathMsg = "Skydancer Sabastienne has been slain! Its rare treasures await...",
    },
    ["heavenrider_hieronyma"] = {
        name = "Heavenrider Hieronyma",
        packetName = "HvnRdrHrnym",
        groupRef = "heavenrider_hieronyma",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION}, {xi.zone.CAPE_TERIGGAN} },
        level = 56,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30791, rate = 1000 },
            { itemId = 30792, rate = 700 },
            { itemId = 30793, rate = 500 },
        },
        deathMsg = "Heavenrider Hieronyma has been slain! Its rare treasures await...",
    },
    ["fledgling_fiorentina"] = {
        name = "Fledgling Fiorentina",
        packetName = "FldgFrntn",
        groupRef = "fledgling_fiorentina",
        zones = { {xi.zone.TAHRONGI_CANYON}, {xi.zone.BUBURIMU_PENINSULA} },
        level = 18,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30794, rate = 1000 },
            { itemId = 30795, rate = 700 },
            { itemId = 30796, rate = 500 },
        },
        deathMsg = "Fledgling Fiorentina has been slain! Its rare treasures await...",
    },
    ["stormrider_sigismund"] = {
        name = "Stormrider Sigismund",
        packetName = "StrmrdrSgsm",
        groupRef = "stormrider_sigismund",
        zones = { {xi.zone.SAUROMUGUE_CHAMPAIGN}, {xi.zone.ROLANBERRY_FIELDS} },
        level = 32,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30797, rate = 1000 },
            { itemId = 30798, rate = 700 },
            { itemId = 30799, rate = 500 },
        },
        deathMsg = "Stormrider Sigismund has been slain! Its rare treasures await...",
    },
    ["tempest_lord_tancred"] = {
        name = "Tempest Lord Tancred",
        packetName = "TmpstLrdTnc",
        groupRef = "tempest_lord_tancred",
        zones = { {xi.zone.CAPE_TERIGGAN}, {xi.zone.BEHEMOTH_S_DOMINION} },
        level = 46,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30800, rate = 1000 },
            { itemId = 30801, rate = 700 },
            { itemId = 30802, rate = 500 },
        },
        deathMsg = "Tempest Lord Tancred has been slain! Its rare treasures await...",
    },
    ["ancient_roc_andromeda"] = {
        name = "Ancient Roc Andromeda",
        packetName = "AncRocAndr",
        groupRef = "ancient_roc_andromeda",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION} },
        level = 58,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30803, rate = 1000 },
            { itemId = 30804, rate = 700 },
            { itemId = 30805, rate = 500 },
        },
        deathMsg = "Ancient Roc Andromeda has been slain! Its rare treasures await...",
    },
    ["stumbling_sebastiano"] = {
        name = "Stumbling Sebastiano",
        packetName = "StmbSbstn2",
        groupRef = "stumbling_sebastiano",
        zones = { {xi.zone.WESTERN_ALTEPA_DESERT}, {xi.zone.EASTERN_ALTEPA_DESERT} },
        level = 22,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30806, rate = 1000 },
            { itemId = 30807, rate = 700 },
            { itemId = 30808, rate = 500 },
        },
        deathMsg = "Stumbling Sebastiano has been slain! Its rare treasures await...",
    },
    ["pirouetting_pradinelda"] = {
        name = "Pirouetting Pradinelda",
        packetName = "PrtPrdnld",
        groupRef = "pirouetting_pradinelda",
        zones = { {xi.zone.EASTERN_ALTEPA_DESERT} },
        level = 34,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30809, rate = 1000 },
            { itemId = 30810, rate = 700 },
            { itemId = 30811, rate = 500 },
        },
        deathMsg = "Pirouetting Pradinelda has been slain! Its rare treasures await...",
    },
    ["spiky_serafina"] = {
        name = "Spiky Serafina",
        packetName = "SpkySerf",
        groupRef = "spiky_serafina",
        zones = { {xi.zone.WESTERN_ALTEPA_DESERT}, {xi.zone.CAPE_TERIGGAN} },
        level = 46,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30812, rate = 1000 },
            { itemId = 30813, rate = 700 },
            { itemId = 30814, rate = 500 },
        },
        deathMsg = "Spiky Serafina has been slain! Its rare treasures await...",
    },
    ["lord_of_the_desert_lazaro"] = {
        name = "Lord of the Desert Lazaro",
        packetName = "LrdDsrtLzr",
        groupRef = "lord_of_the_desert_lazaro",
        zones = { {xi.zone.WESTERN_ALTEPA_DESERT} },
        level = 58,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30815, rate = 1000 },
            { itemId = 30816, rate = 700 },
            { itemId = 30817, rate = 500 },
        },
        deathMsg = "Lord of the Desert Lazaro has been slain! Its rare treasures await...",
    },
    ["lowing_lorcan"] = {
        name = "Lowing Lorcan",
        packetName = "LwngLrcn",
        groupRef = "lowing_lorcan",
        zones = { {xi.zone.CAPE_TERIGGAN}, {xi.zone.EASTERN_ALTEPA_DESERT} },
        level = 20,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30818, rate = 1000 },
            { itemId = 30819, rate = 700 },
            { itemId = 30820, rate = 500 },
        },
        deathMsg = "Lowing Lorcan has been slain! Its rare treasures await...",
    },
    ["thunderhoof_theokleia"] = {
        name = "Thunderhoof Theokleia",
        packetName = "ThndrhfThkl",
        groupRef = "thunderhoof_theokleia",
        zones = { {xi.zone.CAPE_TERIGGAN}, {xi.zone.BEHEMOTH_S_DOMINION} },
        level = 34,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30821, rate = 1000 },
            { itemId = 30822, rate = 700 },
            { itemId = 30823, rate = 500 },
        },
        deathMsg = "Thunderhoof Theokleia has been slain! Its rare treasures await...",
    },
    ["gore_king_godfrey"] = {
        name = "Gore King Godfrey",
        packetName = "GorKngGdfr",
        groupRef = "gore_king_godfrey",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION}, {xi.zone.CAPE_TERIGGAN} },
        level = 46,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30824, rate = 1000 },
            { itemId = 30825, rate = 700 },
            { itemId = 30826, rate = 500 },
        },
        deathMsg = "Gore King Godfrey has been slain! Its rare treasures await...",
    },
    ["primal_patricia"] = {
        name = "Primal Patricia",
        packetName = "PrmlPatrca",
        groupRef = "primal_patricia",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION} },
        level = 56,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30827, rate = 1000 },
            { itemId = 30828, rate = 700 },
            { itemId = 30829, rate = 500 },
        },
        deathMsg = "Primal Patricia has been slain! Its rare treasures await...",
    },
    ["sand_trap_sigrid"] = {
        name = "Sand Trap Sigrid",
        packetName = "SndTrpSgrd",
        groupRef = "sand_trap_sigrid",
        zones = { {xi.zone.EASTERN_ALTEPA_DESERT}, {xi.zone.WESTERN_ALTEPA_DESERT} },
        level = 18,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30830, rate = 1000 },
            { itemId = 30831, rate = 700 },
            { itemId = 30832, rate = 500 },
        },
        deathMsg = "Sand Trap Sigrid has been slain! Its rare treasures await...",
    },
    ["burrowing_bellancourt"] = {
        name = "Burrowing Bellancourt",
        packetName = "BrrwBllnc",
        groupRef = "burrowing_bellancourt",
        zones = { {xi.zone.WESTERN_ALTEPA_DESERT}, {xi.zone.CAPE_TERIGGAN} },
        level = 30,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30833, rate = 1000 },
            { itemId = 30834, rate = 700 },
            { itemId = 30835, rate = 500 },
        },
        deathMsg = "Burrowing Bellancourt has been slain! Its rare treasures await...",
    },
    ["crusher_crescentia"] = {
        name = "Crusher Crescentia",
        packetName = "CrshrCrscnt",
        groupRef = "crusher_crescentia",
        zones = { {xi.zone.CAPE_TERIGGAN}, {xi.zone.BEHEMOTH_S_DOMINION} },
        level = 42,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30836, rate = 1000 },
            { itemId = 30837, rate = 700 },
            { itemId = 30838, rate = 500 },
        },
        deathMsg = "Crusher Crescentia has been slain! Its rare treasures await...",
    },
    ["antlion_emperor_adalbert"] = {
        name = "Antlion Emperor Adalbert",
        packetName = "AnlnEmprAdlb",
        groupRef = "antlion_emperor_adalbert",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION}, {xi.zone.EASTERN_ALTEPA_DESERT} },
        level = 54,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30839, rate = 1000 },
            { itemId = 30840, rate = 700 },
            { itemId = 30841, rate = 500 },
        },
        deathMsg = "Antlion Emperor Adalbert has been slain! Its rare treasures await...",
    },
    ["winged_wilhelmus"] = {
        name = "Winged Wilhelmus",
        packetName = "WngdWhlms",
        groupRef = "winged_wilhelmus",
        zones = { {xi.zone.RANGUEMONT_PASS}, {xi.zone.BEAUCEDINE_GLACIER} },
        level = 26,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30842, rate = 1000 },
            { itemId = 30843, rate = 700 },
            { itemId = 30844, rate = 500 },
        },
        deathMsg = "Winged Wilhelmus has been slain! Its rare treasures await...",
    },
    ["frost_drake_frederik"] = {
        name = "Frost Drake Frederik",
        packetName = "FrstDrkFrdrk",
        groupRef = "frost_drake_frederik",
        zones = { {xi.zone.BEAUCEDINE_GLACIER}, {xi.zone.XARCABARD} },
        level = 38,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30845, rate = 1000 },
            { itemId = 30846, rate = 700 },
            { itemId = 30847, rate = 500 },
        },
        deathMsg = "Frost Drake Frederik has been slain! Its rare treasures await...",
    },
    ["venomfang_valentinus"] = {
        name = "Venomfang Valentinus",
        packetName = "VnmfngVlntn",
        groupRef = "venomfang_valentinus",
        zones = { {xi.zone.XARCABARD}, {xi.zone.CASTLE_ZVAHL_KEEP} },
        level = 50,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30848, rate = 1000 },
            { itemId = 30849, rate = 700 },
            { itemId = 30850, rate = 500 },
        },
        deathMsg = "Venomfang Valentinus has been slain! Its rare treasures await...",
    },
    ["ancient_wyrm_agrippa"] = {
        name = "Ancient Wyrm Agrippa",
        packetName = "AncWrmAgrp",
        groupRef = "ancient_wyrm_agrippa",
        zones = { {xi.zone.CASTLE_ZVAHL_KEEP}, {xi.zone.CASTLE_ZVAHL_BAILEYS} },
        level = 60,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30851, rate = 1000 },
            { itemId = 30852, rate = 700 },
            { itemId = 30853, rate = 500 },
        },
        deathMsg = "Ancient Wyrm Agrippa has been slain! Its rare treasures await...",
    },
    ["wind_up_wilhelmina"] = {
        name = "Wind Up Wilhelmina",
        packetName = "WndUpWhlm",
        groupRef = "wind_up_wilhelmina",
        zones = { {xi.zone.GARLAIGE_CITADEL}, {xi.zone.CRAWLER_S_NEST} },
        level = 20,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30854, rate = 1000 },
            { itemId = 30855, rate = 700 },
            { itemId = 30856, rate = 500 },
        },
        deathMsg = "Wind Up Wilhelmina has been slain! Its rare treasures await...",
    },
    ["clockwork_calogero"] = {
        name = "Clockwork Calogero",
        packetName = "ClkwrkClgr",
        groupRef = "clockwork_calogero",
        zones = { {xi.zone.CRAWLERS_NEST}, {xi.zone.GARLAIGE_CITADEL} },
        level = 32,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30857, rate = 1000 },
            { itemId = 30858, rate = 700 },
            { itemId = 30859, rate = 500 },
        },
        deathMsg = "Clockwork Calogero has been slain! Its rare treasures await...",
    },
    ["arcane_armature_agatha"] = {
        name = "Arcane Armature Agatha",
        packetName = "ArcArmAgt",
        groupRef = "arcane_armature_agatha",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH}, {xi.zone.DEN_OF_RANCOR} },
        level = 44,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30860, rate = 1000 },
            { itemId = 30861, rate = 700 },
            { itemId = 30862, rate = 500 },
        },
        deathMsg = "Arcane Armature Agatha has been slain! Its rare treasures await...",
    },
    ["prime_puppet_ptolemais"] = {
        name = "Prime Puppet Ptolemais",
        packetName = "PrmPptPtlm",
        groupRef = "prime_puppet_ptolemais",
        zones = { {xi.zone.CASTLE_ZVAHL_KEEP} },
        level = 56,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30863, rate = 1000 },
            { itemId = 30864, rate = 700 },
            { itemId = 30865, rate = 500 },
        },
        deathMsg = "Prime Puppet Ptolemais has been slain! Its rare treasures await...",
    },
    ["dancing_dervish"] = {
        name = "Dancing Dervish",
        packetName = "DncngDrvsh",
        groupRef = "dancing_dervish",
        zones = { {xi.zone.GARLAIGE_CITADEL}, {xi.zone.CRAWLER_S_NEST} },
        level = 24,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30866, rate = 1000 },
            { itemId = 30867, rate = 700 },
            { itemId = 30868, rate = 500 },
        },
        deathMsg = "Dancing Dervish has been slain! Its rare treasures await...",
    },
    ["whirling_wenceslas"] = {
        name = "Whirling Wenceslas",
        packetName = "WhrngWncsl",
        groupRef = "whirling_wenceslas",
        zones = { {xi.zone.GARLAIGE_CITADEL}, {xi.zone.CASTLE_ZVAHL_KEEP} },
        level = 36,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30869, rate = 1000 },
            { itemId = 30870, rate = 700 },
            { itemId = 30871, rate = 500 },
        },
        deathMsg = "Whirling Wenceslas has been slain! Its rare treasures await...",
    },
    ["cursed_blade_corneline"] = {
        name = "Cursed Blade Corneline",
        packetName = "CrsdBldCrnl",
        groupRef = "cursed_blade_corneline",
        zones = { {xi.zone.CASTLE_ZVAHL_KEEP}, {xi.zone.ELDIEME_NECROPOLIS} },
        level = 48,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30872, rate = 1000 },
            { itemId = 30873, rate = 700 },
            { itemId = 30874, rate = 500 },
        },
        deathMsg = "Cursed Blade Corneline has been slain! Its rare treasures await...",
    },
    ["eternal_executioner_emerick"] = {
        name = "Eternal Executioner Emerick",
        packetName = "EtrnlExcEmrk",
        groupRef = "eternal_executioner_emerick",
        zones = { {xi.zone.CASTLE_ZVAHL_KEEP}, {xi.zone.CASTLE_ZVAHL_BAILEYS} },
        level = 58,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30875, rate = 1000 },
            { itemId = 30876, rate = 700 },
            { itemId = 30877, rate = 500 },
        },
        deathMsg = "Eternal Executioner Emerick has been slain! Its rare treasures await...",
    },
    ["wailing_wilhemina"] = {
        name = "Wailing Wilhemina",
        packetName = "WlngWhlmna",
        groupRef = "wailing_wilhemina",
        zones = { {xi.zone.GUSGEN_MINES}, {xi.zone.RANGUEMONT_PASS} },
        level = 16,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30878, rate = 1000 },
            { itemId = 30879, rate = 700 },
            { itemId = 30880, rate = 500 },
        },
        deathMsg = "Wailing Wilhemina has been slain! Its rare treasures await...",
    },
    ["shrieking_sigismonda"] = {
        name = "Shrieking Sigismonda",
        packetName = "ShrknSgsmd",
        groupRef = "shrieking_sigismonda",
        zones = { {xi.zone.ELDIEME_NECROPOLIS}, {xi.zone.GUSGEN_MINES} },
        level = 28,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30881, rate = 1000 },
            { itemId = 30882, rate = 700 },
            { itemId = 30883, rate = 500 },
        },
        deathMsg = "Shrieking Sigismonda has been slain! Its rare treasures await...",
    },
    ["phantom_phantasia"] = {
        name = "Phantom Phantasia",
        packetName = "PhntnPhnts",
        groupRef = "phantom_phantasia",
        zones = { {xi.zone.ELDIEME_NECROPOLIS}, {xi.zone.CASTLE_ZVAHL_KEEP} },
        level = 40,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30884, rate = 1000 },
            { itemId = 30885, rate = 700 },
            { itemId = 30886, rate = 500 },
        },
        deathMsg = "Phantom Phantasia has been slain! Its rare treasures await...",
    },
    ["eternal_mourner_euphemia"] = {
        name = "Eternal Mourner Euphemia",
        packetName = "EtrnlMrnEph",
        groupRef = "eternal_mourner_euphemia",
        zones = { {xi.zone.CASTLE_ZVAHL_KEEP}, {xi.zone.CASTLE_ZVAHL_BAILEYS} },
        level = 52,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30887, rate = 1000 },
            { itemId = 30888, rate = 700 },
            { itemId = 30889, rate = 500 },
        },
        deathMsg = "Eternal Mourner Euphemia has been slain! Its rare treasures await...",
    },
    ["blinking_bartholomea"] = {
        name = "Blinking Bartholomea",
        packetName = "BlnkBrthlm",
        groupRef = "blinking_bartholomea",
        zones = { {xi.zone.GARLAIGE_CITADEL}, {xi.zone.CRAWLER_S_NEST} },
        level = 20,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30890, rate = 1000 },
            { itemId = 30891, rate = 700 },
            { itemId = 30892, rate = 500 },
        },
        deathMsg = "Blinking Bartholomea has been slain! Its rare treasures await...",
    },
    ["staring_stanislao"] = {
        name = "Staring Stanislao",
        packetName = "StrnStnslo",
        groupRef = "staring_stanislao",
        zones = { {xi.zone.GARLAIGE_CITADEL}, {xi.zone.TEMPLE_OF_UGGALEPIH} },
        level = 32,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30893, rate = 1000 },
            { itemId = 30894, rate = 700 },
            { itemId = 30895, rate = 500 },
        },
        deathMsg = "Staring Stanislao has been slain! Its rare treasures await...",
    },
    ["paralytic_paracelsina"] = {
        name = "Paralytic Paracelsina",
        packetName = "PrlytPrcls",
        groupRef = "paralytic_paracelsina",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH}, {xi.zone.DEN_OF_RANCOR} },
        level = 44,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30896, rate = 1000 },
            { itemId = 30897, rate = 700 },
            { itemId = 30898, rate = 500 },
        },
        deathMsg = "Paralytic Paracelsina has been slain! Its rare treasures await...",
    },
    ["all_seeing_arbogast"] = {
        name = "All Seeing Arbogast",
        packetName = "AllSeeArb",
        groupRef = "all_seeing_arbogast",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH} },
        level = 56,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30899, rate = 1000 },
            { itemId = 30900, rate = 700 },
            { itemId = 30901, rate = 500 },
        },
        deathMsg = "All Seeing Arbogast has been slain! Its rare treasures await...",
    },
    ["scavenging_svetlana"] = {
        name = "Scavenging Svetlana",
        packetName = "ScvngSvtln",
        groupRef = "scavenging_svetlana",
        zones = { {xi.zone.EASTERN_ALTEPA_DESERT}, {xi.zone.WESTERN_ALTEPA_DESERT} },
        level = 16,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30902, rate = 1000 },
            { itemId = 30903, rate = 700 },
            { itemId = 30904, rate = 500 },
        },
        deathMsg = "Scavenging Svetlana has been slain! Its rare treasures await...",
    },
    ["carrion_circling_casimira"] = {
        name = "Carrion Circling Casimira",
        packetName = "CrrnCrcCsm",
        groupRef = "carrion_circling_casimira",
        zones = { {xi.zone.CAPE_TERIGGAN}, {xi.zone.EASTERN_ALTEPA_DESERT} },
        level = 28,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30905, rate = 1000 },
            { itemId = 30906, rate = 700 },
            { itemId = 30907, rate = 500 },
        },
        deathMsg = "Carrion Circling Casimira has been slain! Its rare treasures await...",
    },
    ["bone_picker_bonaventura"] = {
        name = "Bone Picker Bonaventura",
        packetName = "BnPckrBnvnt",
        groupRef = "bone_picker_bonaventura",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION}, {xi.zone.CAPE_TERIGGAN} },
        level = 40,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30908, rate = 1000 },
            { itemId = 30909, rate = 700 },
            { itemId = 30910, rate = 500 },
        },
        deathMsg = "Bone Picker Bonaventura has been slain! Its rare treasures await...",
    },
    ["sky_sovereign_seraphinus"] = {
        name = "Sky Sovereign Seraphinus",
        packetName = "SkySovSrphn",
        groupRef = "sky_sovereign_seraphinus",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION} },
        level = 52,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30911, rate = 1000 },
            { itemId = 30912, rate = 700 },
            { itemId = 30913, rate = 500 },
        },
        deathMsg = "Sky Sovereign Seraphinus has been slain! Its rare treasures await...",
    },
    ["chittering_chichester"] = {
        name = "Chittering Chichester",
        packetName = "ChtrChtcst",
        groupRef = "chittering_chichester",
        zones = { {xi.zone.YUHTUNGA_JUNGLE}, {xi.zone.YHOATOR_JUNGLE} },
        level = 18,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30914, rate = 1000 },
            { itemId = 30915, rate = 700 },
            { itemId = 30916, rate = 500 },
        },
        deathMsg = "Chittering Chichester has been slain! Its rare treasures await...",
    },
    ["thieving_theodolinda"] = {
        name = "Thieving Theodolinda",
        packetName = "ThvngThdln",
        groupRef = "thieving_theodolinda",
        zones = { {xi.zone.YHOATOR_JUNGLE}, {xi.zone.TEMPLE_OF_UGGALEPIH} },
        level = 30,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30917, rate = 1000 },
            { itemId = 30918, rate = 700 },
            { itemId = 30919, rate = 500 },
        },
        deathMsg = "Thieving Theodolinda has been slain! Its rare treasures await...",
    },
    ["banana_baron_balthazar"] = {
        name = "Banana Baron Balthazar",
        packetName = "BnnBrnBlth",
        groupRef = "banana_baron_balthazar",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH}, {xi.zone.YHOATOR_JUNGLE} },
        level = 42,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30920, rate = 1000 },
            { itemId = 30921, rate = 700 },
            { itemId = 30922, rate = 500 },
        },
        deathMsg = "Banana Baron Balthazar has been slain! Its rare treasures await...",
    },
    ["primate_prince_pelagius"] = {
        name = "Primate Prince Pelagius",
        packetName = "PrmatPrcPlg",
        groupRef = "primate_prince_pelagius",
        zones = { {xi.zone.TEMPLE_OF_UGGALEPIH}, {xi.zone.DEN_OF_RANCOR} },
        level = 54,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30923, rate = 1000 },
            { itemId = 30924, rate = 700 },
            { itemId = 30925, rate = 500 },
        },
        deathMsg = "Primate Prince Pelagius has been slain! Its rare treasures await...",
    },
    ["gnashing_guildenstern"] = {
        name = "Gnashing Guildenstern",
        packetName = "GnshGldnstrn",
        groupRef = "gnashing_guildenstern",
        zones = { {xi.zone.ROLANBERRY_FIELDS}, {xi.zone.BATALLIA_DOWNS} },
        level = 22,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30926, rate = 1000 },
            { itemId = 30927, rate = 700 },
            { itemId = 30928, rate = 500 },
        },
        deathMsg = "Gnashing Guildenstern has been slain! Its rare treasures await...",
    },
    ["pack_lord_petronio"] = {
        name = "Pack Lord Petronio",
        packetName = "PckLrdPtrn",
        groupRef = "pack_lord_petronio",
        zones = { {xi.zone.BATALLIA_DOWNS}, {xi.zone.JUGNER_FOREST} },
        level = 34,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30929, rate = 1000 },
            { itemId = 30930, rate = 700 },
            { itemId = 30931, rate = 500 },
        },
        deathMsg = "Pack Lord Petronio has been slain! Its rare treasures await...",
    },
    ["mauling_malaclypse"] = {
        name = "Mauling Malaclypse",
        packetName = "MulngMlcly",
        groupRef = "mauling_malaclypse",
        zones = { {xi.zone.SAUROMUGUE_CHAMPAIGN}, {xi.zone.BATALLIA_DOWNS} },
        level = 44,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30932, rate = 1000 },
            { itemId = 30933, rate = 700 },
            { itemId = 30934, rate = 500 },
        },
        deathMsg = "Mauling Malaclypse has been slain! Its rare treasures await...",
    },
    ["alpha_apollinarius"] = {
        name = "Alpha Apollinarius",
        packetName = "AlpAplnrs",
        groupRef = "alpha_apollinarius",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION}, {xi.zone.SAUROMUGUE_CHAMPAIGN} },
        level = 54,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30935, rate = 1000 },
            { itemId = 30936, rate = 700 },
            { itemId = 30937, rate = 500 },
        },
        deathMsg = "Alpha Apollinarius has been slain! Its rare treasures await...",
    },
    ["tiny_tortoise_tibalt"] = {
        name = "Tiny Tortoise Tibalt",
        packetName = "TnyTrtTblt",
        groupRef = "tiny_tortoise_tibalt",
        zones = { {xi.zone.EASTERN_ALTEPA_DESERT} },
        level = 26,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30938, rate = 1000 },
            { itemId = 30939, rate = 700 },
            { itemId = 30940, rate = 500 },
        },
        deathMsg = "Tiny Tortoise Tibalt has been slain! Its rare treasures await...",
    },
    ["armored_archibald"] = {
        name = "Armored Archibald",
        packetName = "ArmrdArchbld",
        groupRef = "armored_archibald",
        zones = { {xi.zone.WESTERN_ALTEPA_DESERT}, {xi.zone.EASTERN_ALTEPA_DESERT} },
        level = 40,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30941, rate = 1000 },
            { itemId = 30942, rate = 700 },
            { itemId = 30943, rate = 500 },
        },
        deathMsg = "Armored Archibald has been slain! Its rare treasures await...",
    },
    ["elder_shell_eleanor"] = {
        name = "Elder Shell Eleanor",
        packetName = "EldrShllElnr",
        groupRef = "elder_shell_eleanor",
        zones = { {xi.zone.CAPE_TERIGGAN}, {xi.zone.WESTERN_ALTEPA_DESERT} },
        level = 52,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30944, rate = 1000 },
            { itemId = 30945, rate = 700 },
            { itemId = 30946, rate = 500 },
        },
        deathMsg = "Elder Shell Eleanor has been slain! Its rare treasures await...",
    },
    ["adamantoise_emperor_alexandros"] = {
        name = "Adamantoise Emperor Alexandros",
        packetName = "AdmtEmprAlxnd",
        groupRef = "adamantoise_emperor_alexandros",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION} },
        level = 60,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30947, rate = 1000 },
            { itemId = 30948, rate = 700 },
            { itemId = 30949, rate = 500 },
        },
        deathMsg = "Adamantoise Emperor Alexandros has been slain! Its rare treasures await...",
    },
    ["coiling_callirhoe"] = {
        name = "Coiling Callirhoe",
        packetName = "ClngCllrhe",
        groupRef = "coiling_callirhoe",
        zones = { {xi.zone.SEA_SERPENT_GROTTO}, {xi.zone.QUFIM_ISLAND} },
        level = 22,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30950, rate = 1000 },
            { itemId = 30951, rate = 700 },
            { itemId = 30952, rate = 500 },
        },
        deathMsg = "Coiling Callirhoe has been slain! Its rare treasures await...",
    },
    ["charming_chrysanthema"] = {
        name = "Charming Chrysanthema",
        packetName = "ChrmChrsnth",
        groupRef = "charming_chrysanthema",
        zones = { {xi.zone.SEA_SERPENT_GROTTO} },
        level = 34,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30953, rate = 1000 },
            { itemId = 30954, rate = 700 },
            { itemId = 30955, rate = 500 },
        },
        deathMsg = "Charming Chrysanthema has been slain! Its rare treasures await...",
    },
    ["seductive_seraphimia"] = {
        name = "Seductive Seraphimia",
        packetName = "SdctvSrphm",
        groupRef = "seductive_seraphimia",
        zones = { {xi.zone.SEA_SERPENT_GROTTO}, {xi.zone.TEMPLE_OF_UGGALEPIH} },
        level = 46,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30956, rate = 1000 },
            { itemId = 30957, rate = 700 },
            { itemId = 30958, rate = 500 },
        },
        deathMsg = "Seductive Seraphimia has been slain! Its rare treasures await...",
    },
    ["serpent_queen_sophronia"] = {
        name = "Serpent Queen Sophronia",
        packetName = "SrpntQnSphr",
        groupRef = "serpent_queen_sophronia",
        zones = { {xi.zone.SEA_SERPENT_GROTTO} },
        level = 58,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30959, rate = 1000 },
            { itemId = 30960, rate = 700 },
            { itemId = 30961, rate = 500 },
        },
        deathMsg = "Serpent Queen Sophronia has been slain! Its rare treasures await...",
    },
    ["bloodsucking_barnard"] = {
        name = "Bloodsucking Barnard",
        packetName = "BldSckBrnd",
        groupRef = "bloodsucking_barnard",
        zones = { {xi.zone.BUBURIMU_PENINSULA}, {xi.zone.VALKURM_DUNES} },
        level = 12,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30962, rate = 1000 },
            { itemId = 30963, rate = 700 },
            { itemId = 30964, rate = 500 },
        },
        deathMsg = "Bloodsucking Barnard has been slain! Its rare treasures await...",
    },
    ["gorging_griselda"] = {
        name = "Gorging Griselda",
        packetName = "GrngGrslda",
        groupRef = "gorging_griselda",
        zones = { {xi.zone.PASHHOW_MARSHLANDS}, {xi.zone.ROLANBERRY_FIELDS} },
        level = 24,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30965, rate = 1000 },
            { itemId = 30966, rate = 700 },
            { itemId = 30967, rate = 500 },
        },
        deathMsg = "Gorging Griselda has been slain! Its rare treasures await...",
    },
    ["plasma_draining_placida"] = {
        name = "Plasma Draining Placida",
        packetName = "PlsmDrnPlcd",
        groupRef = "plasma_draining_placida",
        zones = { {xi.zone.CRAWLER_S_NEST}, {xi.zone.GARLAIGE_CITADEL} },
        level = 36,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30968, rate = 1000 },
            { itemId = 30969, rate = 700 },
            { itemId = 30970, rate = 500 },
        },
        deathMsg = "Plasma Draining Placida has been slain! Its rare treasures await...",
    },
    ["ancient_lamprey_augustine"] = {
        name = "Ancient Lamprey Augustine",
        packetName = "AncLmpAgstn",
        groupRef = "ancient_lamprey_augustine",
        zones = { {xi.zone.SEA_SERPENT_GROTTO}, {xi.zone.TEMPLE_OF_UGGALEPIH} },
        level = 50,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30971, rate = 1000 },
            { itemId = 30972, rate = 700 },
            { itemId = 30973, rate = 500 },
        },
        deathMsg = "Ancient Lamprey Augustine has been slain! Its rare treasures await...",
    },
    ["larval_lavrentiy"] = {
        name = "Larval Lavrentiy",
        packetName = "LrvlLvrnt",
        groupRef = "larval_lavrentiy",
        zones = { {xi.zone.WESTERN_ALTEPA_DESERT} },
        level = 18,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30974, rate = 1000 },
            { itemId = 30975, rate = 700 },
            { itemId = 30976, rate = 500 },
        },
        deathMsg = "Larval Lavrentiy has been slain! Its rare treasures await...",
    },
    ["spinning_sebestyen"] = {
        name = "Spinning Sebestyen",
        packetName = "SpnnSbstyn",
        groupRef = "spinning_sebestyen",
        zones = { {xi.zone.EASTERN_ALTEPA_DESERT}, {xi.zone.WESTERN_ALTEPA_DESERT} },
        level = 30,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30977, rate = 1000 },
            { itemId = 30978, rate = 700 },
            { itemId = 30979, rate = 500 },
        },
        deathMsg = "Spinning Sebestyen has been slain! Its rare treasures await...",
    },
    ["metamorphing_melchior"] = {
        name = "Metamorphing Melchior",
        packetName = "MetaMlchr",
        groupRef = "metamorphing_melchior",
        zones = { {xi.zone.CAPE_TERIGGAN}, {xi.zone.EASTERN_ALTEPA_DESERT} },
        level = 42,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30980, rate = 1000 },
            { itemId = 30981, rate = 700 },
            { itemId = 30982, rate = 500 },
        },
        deathMsg = "Metamorphing Melchior has been slain! Its rare treasures await...",
    },
    ["melpomene"] = {
        name = "Melpomene",
        packetName = "Melpomene",
        groupRef = "melpomene",
        zones = { {xi.zone.BEHEMOTH_S_DOMINION}, {xi.zone.CAPE_TERIGGAN} },
        level = 56,
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 0.75,
        isAggro = true,
        loot = {
            { itemId = 30983, rate = 1000 },
            { itemId = 30984, rate = 700 },
            { itemId = 30985, rate = 500 },
        },
        deathMsg = "Melpomene has been slain! Its rare treasures await...",
    },
}

-----------------------------------
-- Award named rare loot to the killing player
-----------------------------------
nr.awardLoot = function(key, mob, player)
    local config = nr.db[key]
    if not config or not player then return end

    local gotSomething = false
    for _, entry in ipairs(config.loot) do
        if math.random(1000) <= entry.rate then
            -- addItem triggers the standard "You obtained X." message automatically
            local added = player:addItem(entry.itemId, 1)
            if added then
                gotSomething = true
            else
                -- Inventory full — drop on ground near player
                player:printToPlayer('[Named Rare] Your inventory is full! Loot dropped nearby.', xi.msg.channel.SYSTEM_3)
            end
        end
    end

    if gotSomething then
        player:printToPlayer(
            string.format('[Named Rare] You defeated %s!', config.name),
            xi.msg.channel.SYSTEM_3
        )
    end
end

-----------------------------------
-- Check if a named rare is ready to spawn
-----------------------------------
nr.isReady = function(key)
    local config = nr.db[key]
    if not config then return false end
    local lastKill = GetServerVariable('DW_NR_' .. key) or 0
    return os.time() >= lastKill + config.spawnTimer
end

-----------------------------------
-- Try to spawn a named rare into the world
-----------------------------------
nr.trySpawn = function(key)
    local config = nr.db[key]
    if not config then return false end

    -- Already alive
    if nr.alive[key] then
        local mob = nr.alive[key]
        if mob and mob:isAlive() then
            return false
        else
            nr.alive[key] = nil
        end
    end

    -- Not yet ready
    if not nr.isReady(key) then return false end

    -- Window check: only try if we're within the spawn window
    local lastKill  = GetServerVariable('DW_NR_' .. key) or 0
    local windowEnd = lastKill + config.spawnTimer + config.spawnWindow
    if os.time() > windowEnd then
        -- Window expired without spawning — reset timer so it tries next cycle
        SetServerVariable('DW_NR_' .. key, os.time() - config.spawnTimer + 600)
        return false
    end

    -- Probabilistic roll so they don't always pop the instant timer expires
    if math.random(1000) > config.spawnChance then return false end

    -- Pick a random zone from the rare's list
    local zoneId = config.zones[math.random(#config.zones)]
    local zone   = GetZone(zoneId)
    if not zone then return false end

    -- Get a valid spawn point using the shared dynamic world helper
    local pos = xi.dynamicWorld.getRandomSpawnPoint(zone)
    if not pos then return false end

    -- Roll a tier for this spawn (70% Elite, 30% Apex)
    local tier   = rollRareTier()
    local isApex = (tier == RARE_TIER_APEX)
    local minLv, maxLv = calcRareLevel(config, tier, zoneId)

    -- Pick one groupRef variant for this spawn (for visual size variety)
    local chosenRef = pickGroupRef(config)

    local entityTable =
    {
        objtype               = xi.objType.MOB,
        name                  = config.name:gsub(' ', '_'),
        packetName            = config.packetName,
        x                     = pos.x,
        y                     = pos.y,
        z                     = pos.z,
        rotation              = pos.rot,
        groupId               = chosenRef.groupId,
        groupZoneId           = chosenRef.groupZoneId,
        minLevel              = minLv,
        maxLevel              = maxLv,
        releaseIdOnDisappear  = true,
        specialSpawnAnimation = true,
        isAggro               = true,   -- Named rares are always aggressive
        onMobSpawn            = function(mob)
            -- Flag as NM: forces /check to return "Impossible to Gauge"
            mob:setMobMod(xi.mobMod.CHECK_AS_NM, 1)
            -- Never links with nearby mobs
            mob:setMobMod(xi.mobMod.NO_LINK, 1)

            -- Apex rares get a hefty HP bonus on top of their higher level
            if isApex then
                local baseHP = mob:getMaxHP()
                mob:setHP(math.floor(baseHP * 2.0))
            end

            mob:setLocalVar('DW_NR_KEY_HASH', 0) -- placeholder; key stored in closure
            mob:setLocalVar('DW_NR_TIER', tier)
        end,
        onMobDeath            = function(mob, player, optParams)
            -- Record kill time for respawn timer
            SetServerVariable('DW_NR_' .. key, os.time())
            nr.alive[key] = nil

            -- Announce the kill to the zone
            if config.deathMsg then
                local z = mob:getZone()
                if z then xi.dynamicWorld.announceZone(z, config.deathMsg) end
            end

            -- Give loot (tier passed so loot system can scale rates)
            if player then
                nr.awardLoot(key, mob, player, tier)
            end
        end,
    }

    -- Use insertDynamicEntity so the mob is a full dynamic entity
    local mob = zone:insertDynamicEntity(entityTable)
    if mob then
        mob:setSpawn(pos.x, pos.y, pos.z, pos.rot)
        mob:spawn()

        nr.alive[key] = mob

        -- Announce the spawn — Apex rares get a more dramatic message
        local z = mob:getZone()
        if z then
            if isApex then
                xi.dynamicWorld.announceZone(z, string.format(
                    '!! A tremendous evil presence descends upon the area... %s has appeared !!',
                    config.packetName
                ))
            else
                xi.dynamicWorld.announceZone(z, string.format(
                    'A strange presence stirs in the area... %s has appeared!',
                    config.packetName
                ))
            end
        end

        return true
    end

    return false
end

-----------------------------------
-- Tick: called from dynamic_world tick
-- Iterates all named rares and tries to spawn ready ones
-----------------------------------
nr.tick = function()
    for key, _ in pairs(nr.db) do
        nr.trySpawn(key)
    end
end

-----------------------------------
-- Init: zero out any stale alive references on server start
-----------------------------------
nr.init = function()
    nr.alive = {}
end

-----------------------------------
-- GM helper: force spawn a specific named rare by key.
-- Pass the calling player so the rare always spawns near them.
-----------------------------------
nr.forceSpawn = function(key, player)
    local config = nr.db[key]
    if not config then
        return false, 'Unknown named rare: ' .. tostring(key)
    end

    -- Clear alive reference so we don't bail on "already alive"
    nr.alive[key] = nil

    -- Set kill time to (now - spawnTimer) so the rare is ready
    -- AND the spawn window is still fully open.
    SetServerVariable('DW_NR_' .. key, os.time() - config.spawnTimer)

    -- Determine spawn zone and position.
    -- Always spawn near the requesting player so the GM can see the mob.
    local spawnZone = nil
    local spawnPos  = nil

    if player then
        spawnZone = player:getZone()
        if spawnZone then
            local px  = player:getXPos()
            local py  = player:getYPos()
            local pz  = player:getZPos()
            local ang = math.random() * math.pi * 2
            local dist = 5 + math.random() * 5
            spawnPos = {
                x   = px + math.cos(ang) * dist,
                y   = py,
                z   = pz + math.sin(ang) * dist,
                rot = math.random(0, 255),
            }
        end
    end

    -- Fallback: pick from config zones and find a mob-based point
    if not spawnZone then
        local zoneId = config.zones[math.random(#config.zones)]
        spawnZone = GetZone(zoneId)
        if not spawnZone then
            return false, string.format('Failed: could not load zone for %s', config.name)
        end
        spawnPos = xi.dynamicWorld.getRandomSpawnPoint(spawnZone)
        if not spawnPos then
            return false, string.format('Failed: no mobs in zone %d to anchor spawn point for %s. Try being in the zone.', zoneId, config.name)
        end
    end

    -- Roll tier and compute level (same logic as trySpawn)
    local tier        = rollRareTier()
    local isApex      = (tier == RARE_TIER_APEX)
    local spawnZoneId = spawnZone:getID()
    local minLv, maxLv = calcRareLevel(config, tier, spawnZoneId)
    local chosenRef   = pickGroupRef(config)

    local entityTable =
    {
        objtype               = xi.objType.MOB,
        name                  = config.name:gsub(' ', '_'),
        packetName            = config.packetName,
        x                     = spawnPos.x,
        y                     = spawnPos.y,
        z                     = spawnPos.z,
        rotation              = spawnPos.rot,
        groupId               = chosenRef.groupId,
        groupZoneId           = chosenRef.groupZoneId,
        minLevel              = minLv,
        maxLevel              = maxLv,
        releaseIdOnDisappear  = true,
        specialSpawnAnimation = true,
        isAggro               = true,
        onMobSpawn            = function(mob)
            -- Force /check to return "Impossible to Gauge" like a true NM
            mob:setMobMod(xi.mobMod.CHECK_AS_NM, 1)
            mob:setMobMod(xi.mobMod.NO_LINK, 1)
            -- Apex rares are extra beefy
            if isApex then
                local baseHP = mob:getMaxHP()
                mob:setHP(math.floor(baseHP * 2.0))
            end
            mob:setLocalVar('DW_NR_TIER', tier)
        end,
        onMobDeath            = function(mob, killer, optParams)
            SetServerVariable('DW_NR_' .. key, os.time())
            nr.alive[key] = nil
            if config.deathMsg then
                local z = mob:getZone()
                if z then xi.dynamicWorld.announceZone(z, config.deathMsg) end
            end
            if killer then
                nr.awardLoot(key, mob, killer, tier)
            end
        end,
    }

    local mob = spawnZone:insertDynamicEntity(entityTable)
    if not mob then
        return false, string.format('Failed: insertDynamicEntity returned nil for %s — check groupRef (groupId=%d, groupZoneId=%d)',
            config.name, chosenRef.groupId, chosenRef.groupZoneId)
    end

    mob:setSpawn(spawnPos.x, spawnPos.y, spawnPos.z, spawnPos.rot)
    mob:spawn()
    nr.alive[key] = mob

    local z = mob:getZone()
    if z then
        if isApex then
            xi.dynamicWorld.announceZone(z, string.format(
                '!! A tremendous evil presence descends upon the area... %s has appeared !!',
                config.packetName
            ))
        else
            xi.dynamicWorld.announceZone(z, string.format(
                'A strange presence stirs in the area... %s has appeared!',
                config.packetName
            ))
        end
    end

    local tierLabel = isApex and '[APEX] ' or '[ELITE] '
    return true, string.format('%s%s has appeared near you! (Lv%d-%d)', tierLabel, config.name, minLv, maxLv)
end

-----------------------------------
-- GM helper: list status of all named rares
-----------------------------------
nr.getStatus = function()
    local out = {}
    local now = os.time()

    for key, config in pairs(nr.db) do
        local lastKill  = GetServerVariable('DW_NR_' .. key) or 0
        local aliveRef  = nr.alive[key]
        local isAlive   = aliveRef and aliveRef:isAlive()
        local readyAt   = lastKill + config.spawnTimer
        local timeLeft  = math.max(0, readyAt - now)

        table.insert(out,
        {
            key       = key,
            name      = config.name,
            alive     = isAlive or false,
            ready     = nr.isReady(key),
            timeLeft  = timeLeft,
        })
    end

    table.sort(out, function(a, b) return a.name < b.name end)
    return out
end
