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
            { itemId = 6, rate = 1000 },    -- William's Wool (trophy, always)
            { itemId = 20, rate = 400  },    -- William's Woolcap
            { itemId = 79, rate = 150  },    -- William's Woolmitt
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
            { itemId = 80, rate = 1000 },    -- Baa-rbara's Bell (trophy)
            { itemId = 81, rate = 400  },    -- Baa-rbara's Collar
            { itemId = 83, rate = 150  },    -- Baa-rbara's Ribbon
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
            { itemId = 84, rate = 1000 },    -- Larry's Lambchop (trophy)
            { itemId = 85, rate = 400  },    -- Larry's Lucky Fleece
            { itemId = 86, rate = 150  },    -- Larry's Lanyard
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
            { itemId = 89, rate = 1000 },    -- Sharon's Golden Fleece (trophy)
            { itemId = 90, rate = 400  },    -- Sharon's Shearing Shears
            { itemId = 94, rate = 150  },    -- Sharon's Silken Mantle
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
            { itemId = 97, rate = 1000 },
            { itemId = 145, rate = 400  },
            { itemId = 150, rate = 150  },
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
            { itemId = 153, rate = 1000 },
            { itemId = 155, rate = 400  },
            { itemId = 156, rate = 150  },
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
            { itemId = 158, rate = 1000 },
            { itemId = 159, rate = 400  },
            { itemId = 160, rate = 150  },
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
            { itemId = 161, rate = 1000 },
            { itemId = 162, rate = 400  },
            { itemId = 163, rate = 150  },
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
            { itemId = 165, rate = 1000 },
            { itemId = 166, rate = 400  },
            { itemId = 167, rate = 150  },
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
            { itemId = 168, rate = 1000 },
            { itemId = 169, rate = 400  },
            { itemId = 170, rate = 150  },
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
            { itemId = 171, rate = 1000 },
            { itemId = 172, rate = 400  },
            { itemId = 173, rate = 150  },
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
            { itemId = 174, rate = 1000 },
            { itemId = 175, rate = 400  },
            { itemId = 176, rate = 150  },
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
            { itemId = 793, rate = 1000 },    -- Morris's Sporeling (trophy, always)
            { itemId = 792, rate = 400  },    -- Morris's Wide Brim
            { itemId = 794, rate = 150  },    -- Mycelium Medal
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
            { itemId = 177, rate = 1000 },
            { itemId = 178, rate = 400  },
            { itemId = 179, rate = 150  },
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
            { itemId = 180, rate = 1000 },
            { itemId = 181, rate = 400  },
            { itemId = 182, rate = 150  },
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
            { itemId = 183, rate = 1000 },
            { itemId = 184, rate = 400  },
            { itemId = 185, rate = 150  },
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
            { itemId = 186, rate = 1000 },
            { itemId = 187, rate = 400  },
            { itemId = 188, rate = 150  },
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
            { itemId = 189, rate = 1000 },
            { itemId = 190, rate = 400  },
            { itemId = 191, rate = 150  },
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
            { itemId = 195, rate = 1000 },
            { itemId = 196, rate = 400  },
            { itemId = 201, rate = 150  },
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
            { itemId = 202, rate = 1000 },
            { itemId = 207, rate = 400  },
            { itemId = 212, rate = 150  },
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
            { itemId = 217, rate = 1000 },
            { itemId = 218, rate = 400  },
            { itemId = 223, rate = 150  },
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
            { itemId = 250, rate = 1000 },
            { itemId = 251, rate = 400  },
            { itemId = 252, rate = 150  },
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
            { itemId = 253, rate = 1000 },
            { itemId = 254, rate = 400  },
            { itemId = 255, rate = 150  },
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
            { itemId = 256, rate = 1000 },
            { itemId = 257, rate = 400  },
            { itemId = 258, rate = 150  },
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
            { itemId = 799, rate = 1000 },    -- Sabrina's Saber-Fang (trophy)
            { itemId = 800, rate = 400  },    -- Sabrina's Feral Legs
            { itemId = 801, rate = 150  },    -- Sabrina's Apex Ring
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
            { itemId = 259, rate = 1000 },
            { itemId = 260, rate = 400  },
            { itemId = 261, rate = 150  },
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
            { itemId = 262, rate = 1000 },
            { itemId = 263, rate = 400  },
            { itemId = 264, rate = 150  },
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
            { itemId = 265, rate = 1000 },
            { itemId = 266, rate = 400  },
            { itemId = 267, rate = 150  },
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
            { itemId = 268, rate = 1000 },
            { itemId = 269, rate = 400  },
            { itemId = 270, rate = 150  },
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
            { itemId = 271, rate = 1000 },
            { itemId = 273, rate = 400  },
            { itemId = 274, rate = 150  },
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
            { itemId = 275, rate = 1000 },
            { itemId = 276, rate = 400  },
            { itemId = 282, rate = 150  },
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
            { itemId = 287, rate = 1000 },
            { itemId = 298, rate = 400  },
            { itemId = 303, rate = 150  },
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
            { itemId = 314, rate = 1000 },
            { itemId = 315, rate = 400  },
            { itemId = 316, rate = 150  },
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
            { itemId = 318, rate = 1000 },
            { itemId = 319, rate = 400  },
            { itemId = 320, rate = 150  },
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
            { itemId = 321, rate = 1000 },
            { itemId = 322, rate = 400  },
            { itemId = 323, rate = 150  },
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
            { itemId = 324, rate = 1000 },
            { itemId = 325, rate = 400  },
            { itemId = 326, rate = 150  },
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
            { itemId = 327, rate = 1000 },
            { itemId = 328, rate = 400  },
            { itemId = 329, rate = 150  },
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
            { itemId = 330, rate = 1000 },
            { itemId = 331, rate = 400  },
            { itemId = 332, rate = 150  },
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
            { itemId = 333, rate = 1000 },
            { itemId = 334, rate = 400  },
            { itemId = 335, rate = 150  },
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
            { itemId = 4133, rate = 1000 },
            { itemId = 4149, rate = 400  },
            { itemId = 4164, rate = 150  },
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
            { itemId = 4170, rate = 1000 },
            { itemId = 4207, rate = 400  },
            { itemId = 4232, rate = 150  },
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
            { itemId = 802, rate = 1000 },    -- Ernest's Earthen Core (trophy)
            { itemId = 803, rate = 400  },    -- Ernest's Burrower Vest
            { itemId = 804, rate = 150  },    -- Ernest's Tremor Boots
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
            { itemId = 805, rate = 1000 },    -- Sally's Scale Chip (trophy)
            { itemId = 806, rate = 400  },    -- Sally's Scale Ring
            { itemId = 807, rate = 150  },    -- Sally's Tail Belt
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
            { itemId = 808, rate = 1000 },    -- Carlos's Cold Scale (trophy)
            { itemId = 809, rate = 400  },    -- Carlos's Reptile Vest
            { itemId = 810, rate = 150  },    -- Carlos's Venom Earring
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
            { itemId = 811, rate = 1000 },    -- Boris's Basilisk Eye (trophy)
            { itemId = 812, rate = 400  },    -- Boris's Granite Carapace
            { itemId = 813, rate = 150  },    -- Boris's Stone Gaze Ring
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
            { itemId = 4262, rate = 1000 },    -- Little Jim's Big Trophy (trophy)
            { itemId = 4266, rate = 400  },    -- Little Jim's Big Boots
            { itemId = 4274, rate = 150  },    -- Little Jim's Big Ring
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
            { itemId = 4319, rate = 1000 },    -- Big Jim's Small Trophy (trophy)
            { itemId = 4341, rate = 400  },    -- Big Jim's Small Hat
            { itemId = 4348, rate = 150  },    -- Big Jim's Small Ring
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
            { itemId = 336, rate = 1000 },
            { itemId = 337, rate = 700 },
            { itemId = 338, rate = 500 },
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
            { itemId = 339, rate = 1000 },
            { itemId = 340, rate = 700 },
            { itemId = 341, rate = 500 },
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
            { itemId = 342, rate = 1000 },
            { itemId = 343, rate = 700 },
            { itemId = 344, rate = 500 },
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
            { itemId = 345, rate = 1000 },
            { itemId = 346, rate = 700 },
            { itemId = 347, rate = 500 },
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
            { itemId = 348, rate = 1000 },
            { itemId = 349, rate = 700 },
            { itemId = 350, rate = 500 },
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
            { itemId = 351, rate = 1000 },
            { itemId = 352, rate = 700 },
            { itemId = 353, rate = 500 },
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
            { itemId = 354, rate = 1000 },
            { itemId = 355, rate = 700 },
            { itemId = 356, rate = 500 },
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
            { itemId = 357, rate = 1000 },
            { itemId = 358, rate = 700 },
            { itemId = 359, rate = 500 },
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
            { itemId = 360, rate = 1000 },
            { itemId = 361, rate = 700 },
            { itemId = 362, rate = 500 },
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
            { itemId = 363, rate = 1000 },
            { itemId = 364, rate = 700 },
            { itemId = 365, rate = 500 },
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
            { itemId = 366, rate = 1000 },
            { itemId = 367, rate = 700 },
            { itemId = 368, rate = 500 },
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
            { itemId = 369, rate = 1000 },
            { itemId = 370, rate = 700 },
            { itemId = 371, rate = 500 },
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
            { itemId = 372, rate = 1000 },
            { itemId = 373, rate = 700 },
            { itemId = 374, rate = 500 },
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
            { itemId = 375, rate = 1000 },
            { itemId = 376, rate = 700 },
            { itemId = 377, rate = 500 },
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
            { itemId = 378, rate = 1000 },
            { itemId = 379, rate = 700 },
            { itemId = 380, rate = 500 },
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
            { itemId = 381, rate = 1000 },
            { itemId = 382, rate = 700 },
            { itemId = 383, rate = 500 },
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
            { itemId = 384, rate = 1000 },
            { itemId = 385, rate = 700 },
            { itemId = 386, rate = 500 },
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
            { itemId = 387, rate = 1000 },
            { itemId = 388, rate = 700 },
            { itemId = 389, rate = 500 },
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
            { itemId = 390, rate = 1000 },
            { itemId = 391, rate = 700 },
            { itemId = 392, rate = 500 },
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
            { itemId = 393, rate = 1000 },
            { itemId = 394, rate = 700 },
            { itemId = 395, rate = 500 },
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
            { itemId = 396, rate = 1000 },
            { itemId = 397, rate = 700 },
            { itemId = 398, rate = 500 },
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
            { itemId = 399, rate = 1000 },
            { itemId = 400, rate = 700 },
            { itemId = 401, rate = 500 },
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
            { itemId = 402, rate = 1000 },
            { itemId = 403, rate = 700 },
            { itemId = 404, rate = 500 },
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
            { itemId = 405, rate = 1000 },
            { itemId = 406, rate = 700 },
            { itemId = 407, rate = 500 },
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
            { itemId = 408, rate = 1000 },
            { itemId = 409, rate = 700 },
            { itemId = 410, rate = 500 },
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
            { itemId = 411, rate = 1000 },
            { itemId = 412, rate = 700 },
            { itemId = 413, rate = 500 },
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
            { itemId = 414, rate = 1000 },
            { itemId = 415, rate = 700 },
            { itemId = 416, rate = 500 },
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
            { itemId = 417, rate = 1000 },
            { itemId = 418, rate = 700 },
            { itemId = 419, rate = 500 },
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
            { itemId = 420, rate = 1000 },
            { itemId = 421, rate = 700 },
            { itemId = 422, rate = 500 },
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
            { itemId = 423, rate = 1000 },
            { itemId = 424, rate = 700 },
            { itemId = 425, rate = 500 },
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
            { itemId = 426, rate = 1000 },
            { itemId = 427, rate = 700 },
            { itemId = 428, rate = 500 },
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
            { itemId = 429, rate = 1000 },
            { itemId = 430, rate = 700 },
            { itemId = 431, rate = 500 },
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
            { itemId = 432, rate = 1000 },
            { itemId = 433, rate = 700 },
            { itemId = 434, rate = 500 },
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
            { itemId = 435, rate = 1000 },
            { itemId = 436, rate = 700 },
            { itemId = 437, rate = 500 },
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
            { itemId = 438, rate = 1000 },
            { itemId = 439, rate = 700 },
            { itemId = 440, rate = 500 },
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
            { itemId = 441, rate = 1000 },
            { itemId = 442, rate = 700 },
            { itemId = 443, rate = 500 },
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
            { itemId = 444, rate = 1000 },
            { itemId = 445, rate = 700 },
            { itemId = 446, rate = 500 },
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
            { itemId = 447, rate = 1000 },
            { itemId = 448, rate = 700 },
            { itemId = 449, rate = 500 },
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
            { itemId = 450, rate = 1000 },
            { itemId = 451, rate = 700 },
            { itemId = 452, rate = 500 },
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
            { itemId = 453, rate = 1000 },
            { itemId = 454, rate = 700 },
            { itemId = 455, rate = 500 },
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
            { itemId = 456, rate = 1000 },
            { itemId = 457, rate = 700 },
            { itemId = 458, rate = 500 },
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
            { itemId = 459, rate = 1000 },
            { itemId = 460, rate = 700 },
            { itemId = 461, rate = 500 },
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
            { itemId = 462, rate = 1000 },
            { itemId = 463, rate = 700 },
            { itemId = 464, rate = 500 },
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
            { itemId = 465, rate = 1000 },
            { itemId = 466, rate = 700 },
            { itemId = 467, rate = 500 },
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
            { itemId = 468, rate = 1000 },
            { itemId = 469, rate = 700 },
            { itemId = 470, rate = 500 },
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
            { itemId = 471, rate = 1000 },
            { itemId = 472, rate = 700 },
            { itemId = 473, rate = 500 },
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
            { itemId = 474, rate = 1000 },
            { itemId = 475, rate = 700 },
            { itemId = 476, rate = 500 },
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
            { itemId = 477, rate = 1000 },
            { itemId = 478, rate = 700 },
            { itemId = 479, rate = 500 },
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
            { itemId = 480, rate = 1000 },
            { itemId = 481, rate = 700 },
            { itemId = 482, rate = 500 },
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
            { itemId = 483, rate = 1000 },
            { itemId = 484, rate = 700 },
            { itemId = 485, rate = 500 },
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
            { itemId = 486, rate = 1000 },
            { itemId = 487, rate = 700 },
            { itemId = 488, rate = 500 },
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
            { itemId = 489, rate = 1000 },
            { itemId = 490, rate = 700 },
            { itemId = 491, rate = 500 },
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
            { itemId = 492, rate = 1000 },
            { itemId = 493, rate = 700 },
            { itemId = 494, rate = 500 },
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
            { itemId = 495, rate = 1000 },
            { itemId = 496, rate = 700 },
            { itemId = 497, rate = 500 },
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
            { itemId = 498, rate = 1000 },
            { itemId = 499, rate = 700 },
            { itemId = 500, rate = 500 },
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
            { itemId = 501, rate = 1000 },
            { itemId = 502, rate = 700 },
            { itemId = 503, rate = 500 },
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
            { itemId = 504, rate = 1000 },
            { itemId = 505, rate = 700 },
            { itemId = 506, rate = 500 },
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
            { itemId = 507, rate = 1000 },
            { itemId = 508, rate = 700 },
            { itemId = 509, rate = 500 },
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
            { itemId = 510, rate = 1000 },
            { itemId = 511, rate = 700 },
            { itemId = 512, rate = 500 },
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
            { itemId = 513, rate = 1000 },
            { itemId = 514, rate = 700 },
            { itemId = 515, rate = 500 },
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
            { itemId = 516, rate = 1000 },
            { itemId = 517, rate = 700 },
            { itemId = 518, rate = 500 },
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
            { itemId = 519, rate = 1000 },
            { itemId = 520, rate = 700 },
            { itemId = 521, rate = 500 },
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
            { itemId = 522, rate = 1000 },
            { itemId = 523, rate = 700 },
            { itemId = 524, rate = 500 },
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
            { itemId = 525, rate = 1000 },
            { itemId = 526, rate = 700 },
            { itemId = 527, rate = 500 },
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
            { itemId = 528, rate = 1000 },
            { itemId = 529, rate = 700 },
            { itemId = 530, rate = 500 },
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
            { itemId = 531, rate = 1000 },
            { itemId = 532, rate = 700 },
            { itemId = 533, rate = 500 },
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
            { itemId = 534, rate = 1000 },
            { itemId = 535, rate = 700 },
            { itemId = 536, rate = 500 },
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
            { itemId = 537, rate = 1000 },
            { itemId = 538, rate = 700 },
            { itemId = 539, rate = 500 },
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
            { itemId = 540, rate = 1000 },
            { itemId = 541, rate = 700 },
            { itemId = 542, rate = 500 },
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
            { itemId = 543, rate = 1000 },
            { itemId = 544, rate = 700 },
            { itemId = 545, rate = 500 },
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
            { itemId = 546, rate = 1000 },
            { itemId = 547, rate = 700 },
            { itemId = 548, rate = 500 },
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
            { itemId = 549, rate = 1000 },
            { itemId = 550, rate = 700 },
            { itemId = 551, rate = 500 },
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
            { itemId = 552, rate = 1000 },
            { itemId = 553, rate = 700 },
            { itemId = 554, rate = 500 },
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
            { itemId = 555, rate = 1000 },
            { itemId = 556, rate = 700 },
            { itemId = 557, rate = 500 },
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
            { itemId = 558, rate = 1000 },
            { itemId = 559, rate = 700 },
            { itemId = 560, rate = 500 },
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
            { itemId = 561, rate = 1000 },
            { itemId = 562, rate = 700 },
            { itemId = 563, rate = 500 },
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
            { itemId = 564, rate = 1000 },
            { itemId = 565, rate = 700 },
            { itemId = 566, rate = 500 },
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
            { itemId = 567, rate = 1000 },
            { itemId = 568, rate = 700 },
            { itemId = 569, rate = 500 },
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
            { itemId = 570, rate = 1000 },
            { itemId = 571, rate = 700 },
            { itemId = 572, rate = 500 },
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
            { itemId = 573, rate = 1000 },
            { itemId = 574, rate = 700 },
            { itemId = 575, rate = 500 },
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
            { itemId = 576, rate = 1000 },
            { itemId = 577, rate = 700 },
            { itemId = 578, rate = 500 },
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
            { itemId = 579, rate = 1000 },
            { itemId = 580, rate = 700 },
            { itemId = 581, rate = 500 },
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
            { itemId = 582, rate = 1000 },
            { itemId = 583, rate = 700 },
            { itemId = 584, rate = 500 },
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
            { itemId = 585, rate = 1000 },
            { itemId = 586, rate = 700 },
            { itemId = 587, rate = 500 },
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
            { itemId = 588, rate = 1000 },
            { itemId = 589, rate = 700 },
            { itemId = 590, rate = 500 },
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
            { itemId = 591, rate = 1000 },
            { itemId = 592, rate = 700 },
            { itemId = 593, rate = 500 },
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
            { itemId = 594, rate = 1000 },
            { itemId = 595, rate = 700 },
            { itemId = 596, rate = 500 },
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
            { itemId = 597, rate = 1000 },
            { itemId = 598, rate = 700 },
            { itemId = 599, rate = 500 },
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
            { itemId = 600, rate = 1000 },
            { itemId = 601, rate = 700 },
            { itemId = 602, rate = 500 },
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
            { itemId = 603, rate = 1000 },
            { itemId = 604, rate = 700 },
            { itemId = 605, rate = 500 },
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
            { itemId = 606, rate = 1000 },
            { itemId = 607, rate = 700 },
            { itemId = 608, rate = 500 },
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
            { itemId = 609, rate = 1000 },
            { itemId = 610, rate = 700 },
            { itemId = 611, rate = 500 },
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
            { itemId = 612, rate = 1000 },
            { itemId = 613, rate = 700 },
            { itemId = 614, rate = 500 },
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
            { itemId = 615, rate = 1000 },
            { itemId = 616, rate = 700 },
            { itemId = 617, rate = 500 },
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
            { itemId = 618, rate = 1000 },
            { itemId = 619, rate = 700 },
            { itemId = 620, rate = 500 },
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
            { itemId = 621, rate = 1000 },
            { itemId = 622, rate = 700 },
            { itemId = 623, rate = 500 },
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
            { itemId = 624, rate = 1000 },
            { itemId = 625, rate = 700 },
            { itemId = 626, rate = 500 },
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
            { itemId = 627, rate = 1000 },
            { itemId = 628, rate = 700 },
            { itemId = 629, rate = 500 },
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
            { itemId = 630, rate = 1000 },
            { itemId = 631, rate = 700 },
            { itemId = 632, rate = 500 },
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
            { itemId = 633, rate = 1000 },
            { itemId = 634, rate = 700 },
            { itemId = 635, rate = 500 },
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
            { itemId = 636, rate = 1000 },
            { itemId = 637, rate = 700 },
            { itemId = 638, rate = 500 },
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
            { itemId = 639, rate = 1000 },
            { itemId = 640, rate = 700 },
            { itemId = 641, rate = 500 },
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
            { itemId = 642, rate = 1000 },
            { itemId = 643, rate = 700 },
            { itemId = 644, rate = 500 },
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
            { itemId = 645, rate = 1000 },
            { itemId = 646, rate = 700 },
            { itemId = 647, rate = 500 },
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
            { itemId = 648, rate = 1000 },
            { itemId = 649, rate = 700 },
            { itemId = 650, rate = 500 },
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
            { itemId = 651, rate = 1000 },
            { itemId = 652, rate = 700 },
            { itemId = 653, rate = 500 },
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
            { itemId = 654, rate = 1000 },
            { itemId = 655, rate = 700 },
            { itemId = 656, rate = 500 },
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
            { itemId = 657, rate = 1000 },
            { itemId = 658, rate = 700 },
            { itemId = 659, rate = 500 },
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
            { itemId = 660, rate = 1000 },
            { itemId = 661, rate = 700 },
            { itemId = 662, rate = 500 },
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
            { itemId = 663, rate = 1000 },
            { itemId = 664, rate = 700 },
            { itemId = 665, rate = 500 },
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
            { itemId = 666, rate = 1000 },
            { itemId = 667, rate = 700 },
            { itemId = 668, rate = 500 },
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
            { itemId = 669, rate = 1000 },
            { itemId = 670, rate = 700 },
            { itemId = 671, rate = 500 },
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
            { itemId = 672, rate = 1000 },
            { itemId = 673, rate = 700 },
            { itemId = 674, rate = 500 },
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
            { itemId = 675, rate = 1000 },
            { itemId = 676, rate = 700 },
            { itemId = 677, rate = 500 },
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
            { itemId = 678, rate = 1000 },
            { itemId = 679, rate = 700 },
            { itemId = 680, rate = 500 },
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
            { itemId = 681, rate = 1000 },
            { itemId = 682, rate = 700 },
            { itemId = 683, rate = 500 },
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
            { itemId = 684, rate = 1000 },
            { itemId = 685, rate = 700 },
            { itemId = 686, rate = 500 },
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
            { itemId = 687, rate = 1000 },
            { itemId = 688, rate = 700 },
            { itemId = 689, rate = 500 },
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
            { itemId = 690, rate = 1000 },
            { itemId = 691, rate = 700 },
            { itemId = 692, rate = 500 },
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
            { itemId = 693, rate = 1000 },
            { itemId = 694, rate = 700 },
            { itemId = 695, rate = 500 },
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
            { itemId = 696, rate = 1000 },
            { itemId = 697, rate = 700 },
            { itemId = 698, rate = 500 },
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
            { itemId = 699, rate = 1000 },
            { itemId = 700, rate = 700 },
            { itemId = 701, rate = 500 },
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
            { itemId = 702, rate = 1000 },
            { itemId = 703, rate = 700 },
            { itemId = 704, rate = 500 },
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
            { itemId = 705, rate = 1000 },
            { itemId = 706, rate = 700 },
            { itemId = 707, rate = 500 },
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
            { itemId = 708, rate = 1000 },
            { itemId = 709, rate = 700 },
            { itemId = 710, rate = 500 },
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
            { itemId = 711, rate = 1000 },
            { itemId = 712, rate = 700 },
            { itemId = 713, rate = 500 },
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
            { itemId = 714, rate = 1000 },
            { itemId = 715, rate = 700 },
            { itemId = 716, rate = 500 },
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
            { itemId = 717, rate = 1000 },
            { itemId = 718, rate = 700 },
            { itemId = 719, rate = 500 },
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
            { itemId = 720, rate = 1000 },
            { itemId = 721, rate = 700 },
            { itemId = 722, rate = 500 },
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
            { itemId = 723, rate = 1000 },
            { itemId = 724, rate = 700 },
            { itemId = 725, rate = 500 },
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
            { itemId = 726, rate = 1000 },
            { itemId = 727, rate = 700 },
            { itemId = 728, rate = 500 },
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
            { itemId = 729, rate = 1000 },
            { itemId = 730, rate = 700 },
            { itemId = 731, rate = 500 },
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
            { itemId = 732, rate = 1000 },
            { itemId = 733, rate = 700 },
            { itemId = 734, rate = 500 },
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
            { itemId = 735, rate = 1000 },
            { itemId = 736, rate = 700 },
            { itemId = 737, rate = 500 },
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
            { itemId = 738, rate = 1000 },
            { itemId = 739, rate = 700 },
            { itemId = 740, rate = 500 },
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
            { itemId = 741, rate = 1000 },
            { itemId = 742, rate = 700 },
            { itemId = 743, rate = 500 },
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
            { itemId = 744, rate = 1000 },
            { itemId = 745, rate = 700 },
            { itemId = 746, rate = 500 },
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
            { itemId = 747, rate = 1000 },
            { itemId = 748, rate = 700 },
            { itemId = 749, rate = 500 },
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
            { itemId = 750, rate = 1000 },
            { itemId = 751, rate = 700 },
            { itemId = 752, rate = 500 },
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
            { itemId = 753, rate = 1000 },
            { itemId = 754, rate = 700 },
            { itemId = 755, rate = 500 },
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
            { itemId = 756, rate = 1000 },
            { itemId = 757, rate = 700 },
            { itemId = 758, rate = 500 },
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
            { itemId = 759, rate = 1000 },
            { itemId = 760, rate = 700 },
            { itemId = 761, rate = 500 },
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
            { itemId = 762, rate = 1000 },
            { itemId = 763, rate = 700 },
            { itemId = 764, rate = 500 },
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
            { itemId = 765, rate = 1000 },
            { itemId = 766, rate = 700 },
            { itemId = 767, rate = 500 },
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
            { itemId = 768, rate = 1000 },
            { itemId = 769, rate = 700 },
            { itemId = 770, rate = 500 },
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
            { itemId = 771, rate = 1000 },
            { itemId = 772, rate = 700 },
            { itemId = 773, rate = 500 },
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
            { itemId = 774, rate = 1000 },
            { itemId = 775, rate = 700 },
            { itemId = 776, rate = 500 },
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
            { itemId = 777, rate = 1000 },
            { itemId = 778, rate = 700 },
            { itemId = 779, rate = 500 },
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
            { itemId = 780, rate = 1000 },
            { itemId = 781, rate = 700 },
            { itemId = 782, rate = 500 },
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
            { itemId = 783, rate = 1000 },
            { itemId = 784, rate = 700 },
            { itemId = 785, rate = 500 },
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
            { itemId = 786, rate = 1000 },
            { itemId = 787, rate = 700 },
            { itemId = 788, rate = 500 },
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
            { itemId = 789, rate = 1000 },
            { itemId = 790, rate = 700 },
            { itemId = 791, rate = 500 },
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
