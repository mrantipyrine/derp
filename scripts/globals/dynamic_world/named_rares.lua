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
        name        = 'Cottontail Tommy',
        packetName  = 'Cottontail Tommy',
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
        name        = 'Hopscotch Harvey',
        packetName  = 'Hopscotch Harvey',
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
        name        = 'Bun-bun Benedict',
        packetName  = 'Bun-bun Benedict',
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
        name        = 'Twitchy Theodore',
        packetName  = 'Twitchy Theodore',
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
        name        = 'Crab Leg Cameron',
        packetName  = 'Crab Leg Cameron',
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
        name        = 'Dungeness Duncan',
        packetName  = 'Dungeness Duncan',
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
    capn_chanterelle =
    {
        name        = "Cap'n Chanterelle",
        packetName  = "Cap'n Chanterelle",
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
        name        = 'Whiskers Wilhelmina',
        packetName  = 'Whiskers Wilhelmina',
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
        name        = 'Purring Patricia',
        packetName  = 'Purring Patricia',
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
        name        = 'Nine Lives Nigel',
        packetName  = 'Nine Lives Nigel',
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
        name        = 'Click Clack Clayton',
        packetName  = 'Click Clack Clayton',
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
        name        = 'Scarab Sebastian',
        packetName  = 'Scarab Sebastian',
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
}

-----------------------------------
-- Award named rare loot to the killing player
-----------------------------------
nr.awardLoot = function(key, mob, player)
    local config = nr.db[key]
    if not config or not player then return end

    for _, entry in ipairs(config.loot) do
        if math.random(1000) <= entry.rate then
            local added = player:addItem(entry.itemId, 1)
            if added then
                player:printToPlayer(
                    string.format('[Named Rare] Obtained: %s!', entry.itemId),
                    xi.msg.channel.SYSTEM_3
                )
            end
        end
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
        minLevel              = config.level[1],
        maxLevel              = config.level[2],
        releaseIdOnDisappear  = true,
        specialSpawnAnimation = true,
        isAggro               = config.isAggro or false,
        onMobDeath            = function(mob, player, optParams)
            -- Record kill time for respawn timer
            SetServerVariable('DW_NR_' .. key, os.time())
            nr.alive[key] = nil

            -- Announce the kill to the zone
            if config.deathMsg then
                local z = mob:getZone()
                if z then
                    z:broadcastMessage(config.deathMsg)
                end
            end

            -- Give loot
            if player then
                nr.awardLoot(key, mob, player)
            end
        end,
    }

    -- Use insertDynamicEntity (same as regular spawner) so the mob is
    -- properly registered as a dynamic entity with all lifecycle hooks.
    local mob = zone:insertDynamicEntity(entityTable)
    if mob then
        mob:setSpawn(pos.x, pos.y, pos.z, pos.rot)
        mob:spawn()

        nr.alive[key] = mob

        -- Announce the spawn to the zone
        local z = mob:getZone()
        if z then
            z:broadcastMessage(string.format(
                'A strange presence stirs in the area... %s has appeared!',
                config.packetName
            ))
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
-- GM helper: force spawn a specific named rare by key
-----------------------------------
nr.forceSpawn = function(key)
    local config = nr.db[key]
    if not config then
        return false, 'Unknown named rare: ' .. tostring(key)
    end

    -- Set kill time to exactly (now - spawnTimer) so the rare is ready
    -- AND the spawn window is still fully open. Setting to 0 broke the
    -- window check because windowEnd = 0 + spawnTimer + spawnWindow, which
    -- is a unix timestamp from 1970 — always expired.
    SetServerVariable('DW_NR_' .. key, os.time() - config.spawnTimer)

    -- Clear alive reference so trySpawn won't bail
    nr.alive[key] = nil

    -- Override spawn chance to guarantee a spawn
    local savedChance = config.spawnChance
    config.spawnChance = 1000
    local result = nr.trySpawn(key)
    config.spawnChance = savedChance

    if result then
        return true, string.format('%s forced into the world.', config.name)
    end

    return false, string.format('Failed to spawn %s (no valid spawn point?)', config.name)
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
