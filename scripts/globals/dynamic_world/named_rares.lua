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
-- Loot rates are per-1000. Loot tables only include mapped equipment/weapon
-- items; trophy-only item_basic drops are intentionally omitted.
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

-- Reusable visual families for named rares.  Dynamic entities borrow an
-- existing mob_groups row for model, family, skills, and base behavior, so
-- these references are deliberately spread across many monster families.
local familyGroupRefs =
{
    sheep       = { { groupId = 13, groupZoneId = 24 }, { groupId = 6, groupZoneId = 25 }, { groupId = 13, groupZoneId = 81 } },
    rabbit      = { { groupId = 19, groupZoneId = 4 }, { groupId = 1, groupZoneId = 5 }, { groupId = 2, groupZoneId = 6 } },
    crab        = { { groupId = 1, groupZoneId = 1 }, { groupId = 2, groupZoneId = 2 }, { groupId = 1, groupZoneId = 11 } },
    funguar     = { { groupId = 7, groupZoneId = 2 }, { groupId = 26, groupZoneId = 2 }, { groupId = 16, groupZoneId = 68 } },
    goblin      = { { groupId = 23, groupZoneId = 4 }, { groupId = 25, groupZoneId = 4 }, { groupId = 27, groupZoneId = 4 } },
    coeurl      = { { groupId = 9, groupZoneId = 7 }, { groupId = 17, groupZoneId = 7 }, { groupId = 15, groupZoneId = 45 } },
    tiger       = { { groupId = 28, groupZoneId = 2 }, { groupId = 34, groupZoneId = 2 }, { groupId = 2, groupZoneId = 5 } },
    mandragora  = { { groupId = 13, groupZoneId = 4 }, { groupId = 38, groupZoneId = 38 }, { groupId = 1, groupZoneId = 45 } },
    beetle      = { { groupId = 6, groupZoneId = 2 }, { groupId = 19, groupZoneId = 2 }, { groupId = 32, groupZoneId = 2 } },
    crawler     = { { groupId = 13, groupZoneId = 68 }, { groupId = 20, groupZoneId = 91 }, { groupId = 30, groupZoneId = 91 } },
    bird        = { { groupId = 14, groupZoneId = 4 }, { groupId = 21, groupZoneId = 4 }, { groupId = 2, groupZoneId = 30 } },
    bee         = { { groupId = 10, groupZoneId = 2 }, { groupId = 30, groupZoneId = 2 }, { groupId = 12, groupZoneId = 24 } },
    worm        = { { groupId = 25, groupZoneId = 7 }, { groupId = 21, groupZoneId = 68 }, { groupId = 24, groupZoneId = 68 } },
    lizard      = { { groupId = 10, groupZoneId = 7 }, { groupId = 21, groupZoneId = 7 }, { groupId = 44, groupZoneId = 9 } },
    orc         = { { groupId = 14, groupZoneId = 2 }, { groupId = 15, groupZoneId = 2 }, { groupId = 21, groupZoneId = 2 } },
    yagudo      = { { groupId = 82, groupZoneId = 37 }, { groupId = 83, groupZoneId = 37 }, { groupId = 84, groupZoneId = 37 } },
    quadav      = { { groupId = 76, groupZoneId = 37 }, { groupId = 77, groupZoneId = 37 }, { groupId = 78, groupZoneId = 37 } },
    bat         = { { groupId = 8, groupZoneId = 2 }, { groupId = 9, groupZoneId = 2 }, { groupId = 7, groupZoneId = 5 } },
    snake       = { { groupId = 36, groupZoneId = 89 }, { groupId = 6, groupZoneId = 90 }, { groupId = 14, groupZoneId = 90 } },
    leech       = { { groupId = 31, groupZoneId = 15 }, { groupId = 9, groupZoneId = 24 }, { groupId = 24, groupZoneId = 24 } },
    skeleton    = { { groupId = 24, groupZoneId = 2 }, { groupId = 25, groupZoneId = 2 }, { groupId = 19, groupZoneId = 5 } },
    scorpion    = { { groupId = 5, groupZoneId = 7 }, { groupId = 29, groupZoneId = 7 }, { groupId = 35, groupZoneId = 7 } },
    spider      = { { groupId = 44, groupZoneId = 27 }, { groupId = 23, groupZoneId = 51 }, { groupId = 6, groupZoneId = 52 } },
    slime       = { { groupId = 9, groupZoneId = 1 }, { groupId = 9, groupZoneId = 3 }, { groupId = 5, groupZoneId = 11 } },
    pugil       = { { groupId = 2, groupZoneId = 1 }, { groupId = 7, groupZoneId = 1 }, { groupId = 17, groupZoneId = 2 } },
    golem       = { { groupId = 57, groupZoneId = 9 }, { groupId = 85, groupZoneId = 41 }, { groupId = 53, groupZoneId = 77 } },
    gigas       = { { groupId = 26, groupZoneId = 24 }, { groupId = 27, groupZoneId = 24 }, { groupId = 54, groupZoneId = 24 } },
    treant      = { { groupId = 66, groupZoneId = 24 }, { groupId = 67, groupZoneId = 24 }, { groupId = 39, groupZoneId = 15 } },
    pixie       = { { groupId = 24, groupZoneId = 81 }, { groupId = 36, groupZoneId = 81 }, { groupId = 88, groupZoneId = 80 } },
    tonberry    = { { groupId = 42, groupZoneId = 2 }, { groupId = 43, groupZoneId = 2 }, { groupId = 20, groupZoneId = 9 } },
    seaMonk     = { { groupId = 3, groupZoneId = 3 }, { groupId = 10, groupZoneId = 3 }, { groupId = 16, groupZoneId = 4 } },
    hippogryph  = { { groupId = 3, groupZoneId = 29 }, { groupId = 5, groupZoneId = 29 }, { groupId = 12, groupZoneId = 29 } },
    roc         = { { groupId = 120, groupZoneId = 77 }, { groupId = 41, groupZoneId = 110 }, { groupId = 6, groupZoneId = 222 } },
    dhalmel     = { { groupId = 20, groupZoneId = 4 }, { groupId = 33, groupZoneId = 4 }, { groupId = 52, groupZoneId = 38 } },
    cactuar     = { { groupId = 10, groupZoneId = 125 }, { groupId = 24, groupZoneId = 125 }, { groupId = 52, groupZoneId = 77 } },
    buffalo     = { { groupId = 5, groupZoneId = 5 }, { groupId = 13, groupZoneId = 5 }, { groupId = 45, groupZoneId = 5 } },
    antlion     = { { groupId = 1, groupZoneId = 7 }, { groupId = 20, groupZoneId = 7 }, { groupId = 49, groupZoneId = 7 } },
    dragon      = { { groupId = 93, groupZoneId = 37 }, { groupId = 102, groupZoneId = 40 }, { groupId = 46, groupZoneId = 15 } },
    automaton   = { { groupId = 15, groupZoneId = 13 }, { groupId = 62, groupZoneId = 48 }, { groupId = 64, groupZoneId = 48 } },
    evilWeapon  = { { groupId = 35, groupZoneId = 38 }, { groupId = 36, groupZoneId = 38 }, { groupId = 77, groupZoneId = 41 } },
    ghost       = { { groupId = 18, groupZoneId = 8 }, { groupId = 17, groupZoneId = 5 }, { groupId = 50, groupZoneId = 15 } },
    ahriman     = { { groupId = 20, groupZoneId = 5 }, { groupId = 31, groupZoneId = 5 }, { groupId = 43, groupZoneId = 15 } },
    vulture     = { { groupId = 21, groupZoneId = 106 }, { groupId = 2, groupZoneId = 30 }, { groupId = 26, groupZoneId = 25 } },
    opoOpo      = { { groupId = 12, groupZoneId = 4 }, { groupId = 5, groupZoneId = 38 }, { groupId = 49, groupZoneId = 38 } },
    hound       = { { groupId = 10, groupZoneId = 109 }, { groupId = 18, groupZoneId = 88 }, { groupId = 30, groupZoneId = 68 } },
    adamantoise = { { groupId = 23, groupZoneId = 38 }, { groupId = 18, groupZoneId = 45 }, { groupId = 32, groupZoneId = 76 } },
    morbol      = { { groupId = 41, groupZoneId = 2 }, { groupId = 41, groupZoneId = 25 }, { groupId = 6, groupZoneId = 29 } },
    wamoura     = { { groupId = 43, groupZoneId = 48 }, { groupId = 47, groupZoneId = 48 }, { groupId = 24, groupZoneId = 61 } },
    flytrap     = { { groupId = 8, groupZoneId = 1 }, { groupId = 13, groupZoneId = 2 }, { groupId = 20, groupZoneId = 2 } },
    elemental   = { { groupId = 10, groupZoneId = 1 }, { groupId = 11, groupZoneId = 1 }, { groupId = 6, groupZoneId = 5 }, { groupId = 27, groupZoneId = 7 } },
    bomb        = { { groupId = 11, groupZoneId = 2 }, { groupId = 20, groupZoneId = 11 }, { groupId = 19, groupZoneId = 15 } },
    raptor      = { { groupId = 30, groupZoneId = 97 }, { groupId = 20, groupZoneId = 119 }, { groupId = 15, groupZoneId = 113 } },
    ram         = { { groupId = 30, groupZoneId = 102 }, { groupId = 28, groupZoneId = 108 }, { groupId = 29, groupZoneId = 108 } },
    manticore   = { { groupId = 32, groupZoneId = 77 }, { groupId = 33, groupZoneId = 114 }, { groupId = 16, groupZoneId = 125 } },
    eft         = { { groupId = 22, groupZoneId = 4 }, { groupId = 6, groupZoneId = 45 }, { groupId = 29, groupZoneId = 76 } },
    gargoyle    = { { groupId = 1, groupZoneId = 9 }, { groupId = 47, groupZoneId = 9 }, { groupId = 51, groupZoneId = 9 } },
    demon       = { { groupId = 21, groupZoneId = 5 }, { groupId = 24, groupZoneId = 5 }, { groupId = 10, groupZoneId = 112 }, { groupId = 2, groupZoneId = 138 } },
}

local rareVisualOverrides =
{
    big_jim =
    {
        { groupId = 20, groupZoneId = 100 }, -- Goblin Weaver
        { groupId = 22, groupZoneId = 101 }, -- Goblin Weaver
        { groupId = 15, groupZoneId = 106 }, -- Goblin Weaver
    },

    little_jim =
    {
        { groupId = 37, groupZoneId = 103 }, -- Hobgoblin Warrior
        { groupId = 34, groupZoneId = 111 }, -- Hobgoblin Warrior
        { groupId = 29, groupZoneId = 113 }, -- Hobgoblin Warrior
    },

    earthcrawler_ern =
    {
        { groupId = 48, groupZoneId = 5 },  -- Mountain Worm NM
        { groupId = 37, groupZoneId = 81 }, -- Sandworm
        { groupId = 35, groupZoneId = 84 }, -- Sandworm
    },
    earthcrawler_ernest =
    {
        { groupId = 48, groupZoneId = 5 },  -- Mountain Worm NM
        { groupId = 37, groupZoneId = 81 }, -- Sandworm
        { groupId = 35, groupZoneId = 84 }, -- Sandworm
    },
}

local rareFamilyRules =
{
    { 'wooly', 'sheep' }, { 'baarbara', 'sheep' }, { 'lambchop', 'sheep' }, { 'shear', 'sheep' },
    { 'bouncy', 'rabbit' }, { 'cottontail', 'rabbit' }, { 'hopscotch', 'rabbit' }, { 'bunbun', 'rabbit' }, { 'twitchy', 'rabbit' },
    { 'crushing', 'crab' }, { 'crab', 'crab' }, { 'bay_', 'crab' }, { 'bisque', 'crab' }, { 'dungeness', 'crab' },
    { 'mushroom', 'funguar' }, { 'chanterelle', 'funguar' }, { 'portobello', 'funguar' }, { 'truffle', 'funguar' },
    { 'bargain', 'goblin' }, { 'swindler', 'goblin' }, { 'shiny', 'goblin' }, { 'sneaky', 'goblin' }, { 'jim', 'goblin' },
    { 'whiskers', 'coeurl' }, { 'purring', 'coeurl' }, { 'nine_lives', 'coeurl' },
    { 'stripey', 'tiger' }, { 'mauler', 'tiger' }, { 'saber', 'tiger' },
    { 'root_', 'mandragora' }, { 'sprout', 'mandragora' }, { 'mandrake', 'mandragora' }, { 'manic', 'mandragora' },
    { 'click', 'beetle' }, { 'dung_', 'beetle' }, { 'scarab', 'beetle' }, { 'venerable', 'beetle' },
    { 'silk', 'crawler' }, { 'cocoon', 'crawler' }, { 'larval', 'crawler' }, { 'spinning', 'crawler' }, { 'metamorphing', 'wamoura' }, { 'melpomene', 'wamoura' },
    { 'feather', 'bird' }, { 'beaky', 'bird' }, { 'plume', 'bird' }, { 'fledgling_fiorentina', 'roc' }, { 'stormrider', 'roc' }, { 'tempest_lord', 'roc' }, { 'ancient_roc', 'roc' },
    { 'honey', 'bee' }, { 'buzzard_barry', 'bee' }, { 'queen_quentin', 'bee' }, { 'buzzing', 'bee' }, { 'droning', 'bee' }, { 'plague_bearer', 'bee' }, { 'swarm', 'bee' },
    { 'wiggles', 'worm' }, { 'squirmy', 'worm' }, { 'earthcrawler', 'worm' },
    { 'scaly', 'lizard' }, { 'coldblooded', 'lizard' }, { 'basilisk', 'lizard' },
    { 'grunt', 'orc' }, { 'sergeant', 'orc' }, { 'raging', 'orc' }, { 'overlord', 'orc' },
    { 'fledgling_fenwick', 'yagudo' }, { 'devout', 'yagudo' }, { 'high_priest', 'yagudo' }, { 'divine', 'yagudo' },
    { 'copper', 'quadav' }, { 'silver', 'quadav' }, { 'boulder', 'quadav' }, { 'diamond', 'quadav' },
    { 'flittering', 'bat' }, { 'echo', 'bat' }, { 'vampiric', 'bat' }, { 'ancient_araminta', 'bat' },
    { 'slithering', 'snake' }, { 'hypnotic', 'snake' }, { 'constrictor', 'snake' }, { 'venom_duchess', 'snake' }, { 'coiling', 'snake' }, { 'charming', 'snake' }, { 'seductive', 'snake' }, { 'serpent', 'snake' },
    { 'gnawing', 'leech' }, { 'festering', 'leech' }, { 'hunger', 'leech' }, { 'bloodsucking', 'leech' }, { 'gorging', 'leech' }, { 'plasma', 'leech' }, { 'lamprey', 'leech' },
    { 'rattling', 'skeleton' }, { 'cursed_cavendish', 'skeleton' }, { 'bonewalker', 'skeleton' }, { 'lich', 'skeleton' },
    { 'deathstalker', 'scorpion' }, { 'snapping_simeon', 'scorpion' }, { 'venomous_vespera', 'scorpion' }, { 'pincer_patriarch', 'scorpion' },
    { 'weaving', 'spider' }, { 'sticky', 'spider' }, { 'ensnaring', 'spider' }, { 'great_weaver', 'spider' },
    { 'oozing', 'slime' }, { 'bubbling', 'slime' }, { 'corrosive', 'slime' }, { 'primordial', 'slime' },
    { 'splashing', 'pugil' }, { 'snapping_sicily', 'pugil' }, { 'torrent', 'pugil' }, { 'deep_king', 'pugil' },
    { 'lumbering', 'golem' }, { 'thundering', 'golem' }, { 'crasher', 'golem' }, { 'patriarch_percival', 'golem' },
    { 'clumsy', 'gigas' }, { 'booming', 'gigas' }, { 'crusher_conrad', 'gigas' }, { 'titan', 'gigas' },
    { 'mossy', 'treant' }, { 'ancient_aldric', 'treant' }, { 'elder_grove', 'treant' }, { 'world_tree', 'treant' },
    { 'mischief', 'pixie' }, { 'trickster', 'pixie' }, { 'hexing', 'pixie' }, { 'grand_trickster', 'pixie' },
    { 'tortuga', 'tonberry' }, { 'shuffling', 'tonberry' }, { 'grudge', 'tonberry' }, { 'last_tonberry', 'tonberry' },
    { 'rippling', 'seaMonk' }, { 'tidecaller', 'seaMonk' }, { 'brine', 'seaMonk' }, { 'deep_sovereign', 'seaMonk' },
    { 'prancing', 'hippogryph' }, { 'thunderwing', 'hippogryph' }, { 'skydancer', 'hippogryph' }, { 'heavenrider', 'hippogryph' },
    { 'stumbling', 'dhalmel' }, { 'pirouetting', 'dhalmel' }, { 'spiky', 'cactuar' }, { 'desert_lazaro', 'cactuar' },
    { 'lowing', 'buffalo' }, { 'thunderhoof', 'buffalo' }, { 'gore_king', 'buffalo' }, { 'primal', 'buffalo' },
    { 'sand_trap', 'antlion' }, { 'burrowing', 'antlion' }, { 'crusher_crescentia', 'antlion' }, { 'antlion', 'antlion' },
    { 'winged', 'dragon' }, { 'drake', 'dragon' }, { 'venomfang', 'dragon' }, { 'wyrm', 'dragon' },
    { 'wind_up', 'automaton' }, { 'clockwork', 'automaton' }, { 'armature', 'automaton' }, { 'puppet', 'automaton' },
    { 'dancing', 'evilWeapon' }, { 'whirling', 'evilWeapon' }, { 'cursed_blade', 'evilWeapon' }, { 'executioner', 'evilWeapon' },
    { 'wailing', 'ghost' }, { 'shrieking', 'ghost' }, { 'phantom', 'ghost' }, { 'mourner', 'ghost' },
    { 'blinking', 'ahriman' }, { 'staring', 'ahriman' }, { 'paralytic', 'ahriman' }, { 'all_seeing', 'ahriman' },
    { 'scavenging', 'vulture' }, { 'carrion_circling', 'vulture' }, { 'carrion_cornelius', 'vulture' }, { 'bone_picker', 'vulture' }, { 'sky_sovereign', 'vulture' },
    { 'chittering', 'opoOpo' }, { 'thieving', 'opoOpo' }, { 'banana', 'opoOpo' }, { 'primate', 'opoOpo' },
    { 'gnashing', 'hound' }, { 'pack_lord', 'hound' }, { 'mauling', 'hound' }, { 'alpha', 'hound' },
    { 'tortoise', 'adamantoise' }, { 'armored', 'adamantoise' }, { 'elder_shell', 'adamantoise' }, { 'adamantoise', 'adamantoise' },
    { 'crackling', 'flytrap' }, { 'ferocious', 'flytrap' }, { 'brutal', 'gigas' }, { 'gale', 'bird' }, { 'venomous_valentina', 'morbol' }, { 'deep_dweller', 'slime' },
    { 'flickering', 'elemental' }, { 'glowing', 'elemental' }, { 'prismatic', 'elemental' },
    { 'volatile', 'bomb' }, { 'explosive', 'bomb' }, { 'fused', 'bomb' },
    { 'velociraptor', 'raptor' }, { 'vicious', 'raptor' }, { 'talon', 'raptor' },
    { 'battering', 'ram' }, { 'tremor', 'ram' }, { 'mountain_king', 'ram' },
    { 'lesser_manticore', 'manticore' }, { 'greater_manticore', 'manticore' }, { 'desert_manticore', 'manticore' },
    { 'deft', 'eft' }, { 'nimble', 'eft' }, { 'toxic', 'eft' },
    { 'stony', 'gargoyle' }, { 'obsidian', 'gargoyle' }, { 'monolithic', 'gargoyle' },
    { 'dread', 'demon' }, { 'stygian', 'demon' }, { 'abyssal', 'demon' },
}

local function normalizeRareKey(key)
    if type(key) ~= 'string' then
        return nil
    end

    local normalized = key:lower()
    normalized = string.gsub(normalized, '[^%w]+', '_')
    normalized = string.gsub(normalized, '^_+', '')
    normalized = string.gsub(normalized, '_+$', '')

    return normalized
end

local function getVisualOverride(config)
    local groupKey = normalizeRareKey(config.groupRef)
    if groupKey and rareVisualOverrides[groupKey] then
        return rareVisualOverrides[groupKey]
    end

    local nameKey = normalizeRareKey(config.name)
    if nameKey and rareVisualOverrides[nameKey] then
        return rareVisualOverrides[nameKey]
    end

    return nil
end

local function getFamilyForKey(key)
    if type(key) ~= 'string' then
        return nil
    end

    local normalized = key:lower()
    for _, rule in ipairs(rareFamilyRules) do
        if string.find(normalized, rule[1], 1, true) then
            return rule[2]
        end
    end

    return nil
end

local function getItemDisplayName(itemId)
    local item = GetItemByID(itemId)
    if not item then
        return string.format('item #%d', itemId)
    end

    local name = item:getName()
    if not name or name == '' then
        return string.format('item #%d', itemId)
    end

    return (name:gsub('_', ' '))
end

-- Pick a random groupRef from a config entry.
-- Supports either a single 'groupRef' or a 'groupRefs' array for visual variety.
local function pickGroupRef(config)
    local visualRefs = getVisualOverride(config)
    if visualRefs and #visualRefs > 0 then
        return visualRefs[math.random(#visualRefs)]
    end

    local refs = config.groupRefs
    if refs and #refs > 0 then
        return refs[math.random(#refs)]
    end

    local family = config.family or getFamilyForKey(config.groupRef) or getFamilyForKey(config.name)
    local familyRefs = family and familyGroupRefs[family]
    if familyRefs and #familyRefs > 0 then
        return familyRefs[math.random(#familyRefs)]
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

    -- Never go below the config's own floor (some rares are intentionally high).
    -- Hand-authored rares use { min, max }; generated rares may use a single level.
    if type(config.level) == 'table' then
        minLv = math.max(minLv, config.level[1] or minLv)
        maxLv = math.max(maxLv, config.level[2] or config.level[1] or maxLv)
    elseif type(config.level) == 'number' then
        minLv = math.max(minLv, config.level)
        maxLv = math.max(maxLv, config.level)
    end

    return minLv, maxLv
end

-----------------------------------
-- Named Rare Database
-----------------------------------
-- groupRef: find valid IDs with:
--   SELECT groupid, zoneid, name FROM mob_groups WHERE name LIKE '%Sheep%' LIMIT 10;
-- zones: which zone IDs this rare can appear in (picks one randomly)
-- loot: { itemId, rate (per 1000) }
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
            { itemId = 23438, rate = 10479  },    -- William's Woolcap
            { itemId = 23539, rate = 150  },    -- William's Woolmitt
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
            { itemId = 18528, rate = 1000 },    -- Baa-rbara's Bell
            { itemId = 26007, rate = 10479  },    -- Baa-rbara's Collar
            { itemId = 28441, rate = 150  },    -- Baa-rbara's Ribbon
            { itemId = 18831, rate = 240 }, -- Pixie Piccolo
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
            { itemId = 28611, rate = 10479  },    -- Larry's Lucky Fleece
            { itemId = 26008, rate = 150  },    -- Larry's Lanyard
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
            { itemId = 23529, rate = 10479  },    -- Sharon's Shearing Shears
            { itemId = 28612, rate = 150  },    -- Sharon's Silken Mantle
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
            { itemId = 10294, rate = 10479  },
            { itemId = 23751, rate = 150  },
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
            { itemId = 10374, rate = 10479  },
            { itemId = 27526, rate = 150  },
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
            { itemId = 23439, rate = 10479  },
            { itemId = 28442, rate = 150  },
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
            { itemId = 23752, rate = 10479  },
            { itemId = 27527, rate = 150  },
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
            { itemId = 23530, rate = 10479  },
            { itemId = 28529, rate = 150  },
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
            { itemId = 23531, rate = 10479  },
            { itemId = 28443, rate = 150  },
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
            { itemId = 25692, rate = 10479  },
            { itemId = 27528, rate = 150  },
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
            { itemId = 23440, rate = 10479  },
            { itemId = 28567, rate = 150  },
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
            { itemId = 23437, rate = 10479  },    -- Morris's Wide Brim
            { itemId = 26117, rate = 150  },    -- Mycelium Medal
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
            { itemId = 23441, rate = 10479  },
            { itemId = 28445, rate = 150  },
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
            { itemId = 25693, rate = 10479  },
            { itemId = 26009, rate = 150  },
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
            { itemId = 23710, rate = 10479  },
            { itemId = 11628, rate = 150  },
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
            { itemId = 23711, rate = 10479  },
            { itemId = 28446, rate = 150  },
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
            { itemId = 25694, rate = 10479  },
            { itemId = 27529, rate = 150  },
            { itemId = 18976, rate = 220 }, -- Sam Sticker
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
            { itemId = 25695, rate = 10479  },
            { itemId = 11630, rate = 150  },
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
            { itemId = 26010, rate = 10479  },
            { itemId = 23253, rate = 150  },
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
            { itemId = 23532, rate = 10479  },
            { itemId = 28614, rate = 150  },
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
            { itemId = 25696, rate = 10479  },
            { itemId = 11631, rate = 150  },
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
            { itemId = 26011, rate = 10479  },
            { itemId = 28615, rate = 150  },
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
            { itemId = 23712, rate = 10479  },
            { itemId = 28447, rate = 150  },
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
            { itemId = 23265, rate = 10479  },    -- Sabrina's Feral Legs
            { itemId = 11641, rate = 150  },    -- Sabrina's Apex Ring
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
            { itemId = 27530, rate = 10479  },
            { itemId = 23533, rate = 150  },
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
            { itemId = 23713, rate = 10479  },
            { itemId = 11632, rate = 150  },
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
            { itemId = 23732, rate = 10479  },
            { itemId = 28448, rate = 150  },
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
            { itemId = 23259, rate = 10479  },
            { itemId = 11634, rate = 150  },
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
            { itemId = 23783, rate = 10479  },
            { itemId = 26012, rate = 150  },
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
            { itemId = 23738, rate = 10479  },
            { itemId = 11635, rate = 150  },
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
            { itemId = 23534, rate = 10479  },
            { itemId = 28616, rate = 150  },
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
            { itemId = 25697, rate = 10479  },
            { itemId = 14646, rate = 150  },
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
            { itemId = 25698, rate = 10479  },
            { itemId = 15549, rate = 150  },
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
            { itemId = 23739, rate = 10479  },
            { itemId = 27531, rate = 150  },
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
            { itemId = 25699, rate = 10479  },
            { itemId = 15550, rate = 150  },
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
            { itemId = 27532, rate = 10479  },
            { itemId = 15780, rate = 150  },
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
            { itemId = 23535, rate = 10479  },
            { itemId = 26013, rate = 150  },
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
            { itemId = 23740, rate = 10479  },
            { itemId = 15781, rate = 150  },
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
        spawnChance = 28624,
        isAggro     = false,
        loot        =
        {
            { itemId = 15794, rate = 10479  },
            { itemId = 28449, rate = 150  },
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
            { itemId = 23755, rate = 10479  },
            { itemId = 27533, rate = 150  },
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
            { itemId = 25689, rate = 10479  },    -- Ernest's Burrower Vest
            { itemId = 23750, rate = 150  },    -- Ernest's Tremor Boots
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
            { itemId = 11642, rate = 10479  },    -- Sally Scale
            { itemId = 28440, rate = 150  },    -- Sally's Tail Belt
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
            { itemId = 25690, rate = 10479  },    -- Carlos's Reptile Vest
            { itemId = 26118, rate = 150  },    -- Carlos's Venom Earring
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
            { itemId = 25691, rate = 10479  },    -- Boris's Granite Carapace
            { itemId = 11643, rate = 150  },    -- Boris's Stone Gaze Ring
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
            { itemId = 23784, rate = 10479  },    -- Little Jim's Big Boots
            { itemId = 15795, rate = 150  },    -- Little Jim's Big Ring
            { itemId = 18972, rate = 220 }, -- Storm Knucks
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
            { itemId = 23756, rate = 10479  },    -- Big Jim's Small Hat
            { itemId = 15796, rate = 150  },    -- Big Jim Cape
            { itemId = 18971, rate = 220 }, -- Jim Cleaver
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
            { itemId = 23757, rate = 700 },
            { itemId = 23536, rate = 500 },
            { itemId = 18832, rate = 220 }, -- Dirge Flute
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
            { itemId = 23786, rate = 700 },
            { itemId = 23260, rate = 500 },
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
            { itemId = 23537, rate = 700 },
            { itemId = 28450, rate = 500 },
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
            { itemId = 23787, rate = 700 },
            { itemId = 15798, rate = 500 },
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
            { itemId = 27536, rate = 700 },
            { itemId = 28619, rate = 500 },
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
            { itemId = 28618, rate = 700 },
            { itemId = 23261, rate = 500 },
            { itemId = 18979, rate = 180 }, -- Beast Axe
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
            { itemId = 23758, rate = 700 },
            { itemId = 23538, rate = 500 },
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
            { itemId = 25700, rate = 700 },
            { itemId = 23788, rate = 500 },
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
            { itemId = 28599, rate = 700 },
            { itemId = 23706, rate = 500 },
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
            { itemId = 23759, rate = 700 },
            { itemId = 15797, rate = 500 },
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
            { itemId = 24076, rate = 700 },
            { itemId = 28451, rate = 500 },
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
            { itemId = 23252, rate = 700 },
            { itemId = 11665, rate = 500 },
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
            { itemId = 23511, rate = 700 },
            { itemId = 28430, rate = 500 },
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
            { itemId = 23418, rate = 700 },
            { itemId = 28604, rate = 500 },
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
            { itemId = 25701, rate = 700 },
            { itemId = 24077, rate = 500 },
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
            { itemId = 25702, rate = 700 },
            { itemId = 14631, rate = 500 },
            { itemId = 18977, rate = 180 }, -- Guardbreak
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
            { itemId = 24075, rate = 700 },
            { itemId = 28429, rate = 500 },
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
            { itemId = 26014, rate = 700 },
            { itemId = 27537, rate = 500 },
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
            { itemId = 23895, rate = 700 },
            { itemId = 14641, rate = 500 },
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
            { itemId = 25703, rate = 700 },
            { itemId = 23797, rate = 500 },
            { itemId = 18973, rate = 180 }, -- Saintbell
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
            { itemId = 23544, rate = 700 },
            { itemId = 23785, rate = 500 },
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
            { itemId = 23978, rate = 700 },
            { itemId = 26015, rate = 500 },
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
            { itemId = 23728, rate = 700 },
            { itemId = 14639, rate = 500 },
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
            { itemId = 25705, rate = 700 },
            { itemId = 23896, rate = 500 },
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
            { itemId = 27538, rate = 700 },
            { itemId = 23707, rate = 500 },
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
            { itemId = 27539, rate = 700 },
            { itemId = 23543, rate = 500 },
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
            { itemId = 23761, rate = 700 },
            { itemId = 14637, rate = 500 },
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
            { itemId = 28620, rate = 700 },
            { itemId = 23708, rate = 500 },
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
            { itemId = 23729, rate = 700 },
            { itemId = 28438, rate = 500 },
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
            { itemId = 25538, rate = 700 },
            { itemId = 27535, rate = 500 },
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
            { itemId = 23541, rate = 700 },
            { itemId = 28435, rate = 500 },
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
            { itemId = 23415, rate = 700 },
            { itemId = 14645, rate = 500 },
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
            { itemId = 26003, rate = 700 },
            { itemId = 23709, rate = 500 },
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
            { itemId = 25706, rate = 700 },
            { itemId = 14633, rate = 500 },
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
            { itemId = 23417, rate = 700 },
            { itemId = 28617, rate = 500 },
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
            { itemId = 23416, rate = 700 },
            { itemId = 23264, rate = 500 },
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
            { itemId = 23542, rate = 700 },
            { itemId = 23726, rate = 500 },
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
            { itemId = 27534, rate = 700 },
            { itemId = 14635, rate = 500 },
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
            { itemId = 23979, rate = 700 },
            { itemId = 23540, rate = 500 },
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
            { itemId = 23980, rate = 700 },
            { itemId = 11640, rate = 500 },
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
            { itemId = 26107, rate = 700 },
            { itemId = 23727, rate = 500 },
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
            { itemId = 25537, rate = 700 },
            { itemId = 26105, rate = 500 },
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
            { itemId = 23736, rate = 700 },
            { itemId = 28434, rate = 500 },
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
            { itemId = 23977, rate = 700 },
            { itemId = 14643, rate = 500 },
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
            { itemId = 23510, rate = 700 },
            { itemId = 26106, rate = 500 },
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
            { itemId = 28598, rate = 700 },
            { itemId = 28433, rate = 500 },
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
            { itemId = 23263, rate = 700 },
            { itemId = 15857, rate = 500 },
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
            { itemId = 25682, rate = 700 },
            { itemId = 26116, rate = 500 },
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
            { itemId = 15856, rate = 700 },
            { itemId = 23789, rate = 500 },
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
            { itemId = 26002, rate = 700 },
            { itemId = 27928, rate = 500 },
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
            { itemId = 25683, rate = 700 },
            { itemId = 28432, rate = 500 },
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
            { itemId = 23435, rate = 700 },
            { itemId = 28597, rate = 500 },
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
            { itemId = 11062, rate = 700 },
            { itemId = 28208, rate = 500 },
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
            { itemId = 26001, rate = 700 },
            { itemId = 26108, rate = 500 },
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
            { itemId = 27937, rate = 700 },
            { itemId = 27564, rate = 500 },
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
            { itemId = 25680, rate = 700 },
            { itemId = 27574, rate = 500 },
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
            { itemId = 26115, rate = 700 },
            { itemId = 23661, rate = 500 },
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
            { itemId = 28431, rate = 700 },
            { itemId = 25681, rate = 500 },
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
            { itemId = 28609, rate = 700 },
            { itemId = 28575, rate = 500 },
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
            { itemId = 23434, rate = 700 },
            { itemId = 27568, rate = 500 },
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
            { itemId = 25545, rate = 700 },
            { itemId = 23684, rate = 500 },
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
            { itemId = 28606, rate = 700 },
            { itemId = 26349, rate = 500 },
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
            { itemId = 23262, rate = 700 },
            { itemId = 28550, rate = 500 },
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
            { itemId = 23983, rate = 700 },
            { itemId = 25544, rate = 500 },
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
            { itemId = 23512, rate = 700 },
            { itemId = 10789, rate = 500 },
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
            { itemId = 23419, rate = 700 },
            { itemId = 26345, rate = 500 },
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
            { itemId = 23981, rate = 700 },
            { itemId = 23685, rate = 500 },
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
            { itemId = 23982, rate = 700 },
            { itemId = 28547, rate = 500 },
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
            { itemId = 28534, rate = 700 },
            { itemId = 23686, rate = 500 },
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
            { itemId = 28523, rate = 700 },
            { itemId = 26042, rate = 500 },
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
            { itemId = 28608, rate = 700 },
            { itemId = 28542, rate = 500 },
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
            { itemId = 25687, rate = 700 },
            { itemId = 28564, rate = 500 },
            { itemId = 18985, rate = 180 }, -- Avatar Spire
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
            { itemId = 26082, rate = 700 },
            { itemId = 10786, rate = 500 },
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
            { itemId = 23420, rate = 700 },
            { itemId = 26000, rate = 500 },
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
            { itemId = 25684, rate = 700 },
            { itemId = 28553, rate = 500 },
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
            { itemId = 28607, rate = 700 },
            { itemId = 28579, rate = 500 },
            { itemId = 18883, rate = 180 }, -- Luck Mallet
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
            { itemId = 28549, rate = 700 },
            { itemId = 23687, rate = 500 },
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
            { itemId = 26006, rate = 700 },
            { itemId = 25685, rate = 500 },
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
            { itemId = 28605, rate = 700 },
            { itemId = 11059, rate = 500 },
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
            { itemId = 25686, rate = 700 },
            { itemId = 10785, rate = 500 },
            { itemId = 18983, rate = 170 }, -- Blinksteel
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
            { itemId = 23688, rate = 700 },
            { itemId = 26083, rate = 500 },
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
            { itemId = 26005, rate = 700 },
            { itemId = 28601, rate = 500 },
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
            { itemId = 23421, rate = 700 },
            { itemId = 10783, rate = 500 },
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
            { itemId = 25688, rate = 700 },
            { itemId = 10787, rate = 500 },
            { itemId = 18840, rate = 160 }, -- Doom Horn
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
            { itemId = 26089, rate = 700 },
            { itemId = 28217, rate = 500 },
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
            { itemId = 11007, rate = 700 },
            { itemId = 10791, rate = 500 },
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
            { itemId = 23423, rate = 700 },
            { itemId = 28436, rate = 500 },
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
            { itemId = 23984, rate = 700 },
            { itemId = 10792, rate = 500 },
            { itemId = 18937, rate = 170 }, -- Boomstick
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
            { itemId = 26099, rate = 700 },
            { itemId = 10794, rate = 500 },
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
            { itemId = 23424, rate = 700 },
            { itemId = 11000, rate = 500 },
            { itemId = 18933, rate = 180 }, -- Sky Bow
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
            { itemId = 25704, rate = 700 },
            { itemId = 10795, rate = 500 },
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
            { itemId = 23717, rate = 700 },
            { itemId = 10793, rate = 500 },
            { itemId = 18984, rate = 170 }, -- Wyvern Pike
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
            { itemId = 10790, rate = 700 },
            { itemId = 28339, rate = 500 },
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
            { itemId = 27620, rate = 700 },
            { itemId = 28410, rate = 500 },
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
            { itemId = 23425, rate = 700 },
            { itemId = 10761, rate = 500 },
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
            { itemId = 27797, rate = 700 },
            { itemId = 10755, rate = 500 },
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
            { itemId = 28437, rate = 700 },
            { itemId = 23697, rate = 500 },
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
            { itemId = 28602, rate = 700 },
            { itemId = 26004, rate = 500 },
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
            { itemId = 23422, rate = 700 },
            { itemId = 10756, rate = 500 },
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
            { itemId = 27916, rate = 700 },
            { itemId = 10759, rate = 500 },
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
            { itemId = 23698, rate = 700 },
            { itemId = 10763, rate = 500 },
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
            { itemId = 23513, rate = 700 },
            { itemId = 26325, rate = 500 },
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
            { itemId = 10487, rate = 700 },
            { itemId = 10758, rate = 500 },
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
            { itemId = 10479, rate = 700 },
            { itemId = 10760, rate = 500 },
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
            { itemId = 10762, rate = 700 },
            { itemId = 23699, rate = 500 },
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
            { itemId = 23436, rate = 700 },
            { itemId = 28594, rate = 500 },
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
            { itemId = 23950, rate = 700 },
            { itemId = 10754, rate = 500 },
            { itemId = 18978, rate = 180 }, -- Grave Scythe
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
            { itemId = 23951, rate = 700 },
            { itemId = 10757, rate = 500 },
            { itemId = 18982, rate = 170 }, -- Moon Fang
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
            { itemId = 10750, rate = 700 },
            { itemId = 23700, rate = 500 },
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
            { itemId = 25419, rate = 700 },
            { itemId = 28414, rate = 500 },
            { itemId = 18986, rate = 180 }, -- Blue Maw
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
            { itemId = 23952, rate = 700 },
            { itemId = 10753, rate = 500 },
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
            { itemId = 23953, rate = 700 },
            { itemId = 10751, rate = 500 },
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
            { itemId = 11660, rate = 700 },
            { itemId = 26339, rate = 500 },
            { itemId = 18980, rate = 200 }, -- Siren Dagger
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
            { itemId = 28521, rate = 700 },
            { itemId = 28595, rate = 500 },
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
            { itemId = 23954, rate = 700 },
            { itemId = 11659, rate = 500 },
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
            { itemId = 23955, rate = 700 },
            { itemId = 11657, rate = 500 },
            { itemId = 18974, rate = 170 }, -- Ember Staff
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
            { itemId = 26080, rate = 700 },
            { itemId = 11658, rate = 500 },
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
            { itemId = 25431, rate = 700 },
            { itemId = 23514, rate = 500 },
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
            { itemId = 23956, rate = 700 },
            { itemId = 11661, rate = 500 },
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
            { itemId = 23957, rate = 700 },
            { itemId = 11662, rate = 500 },
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
            { itemId = 26100, rate = 700 },
            { itemId = 11669, rate = 500 },
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
            { itemId = 25526, rate = 700 },
            { itemId = 23526, rate = 500 },
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
            { itemId = 23760, rate = 700 },
            { itemId = 11674, rate = 500 },
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
            { itemId = 23958, rate = 700 },
            { itemId = 11656, rate = 500 },
            { itemId = 18884, rate = 170 }, -- Mana Wand
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
            { itemId = 26101, rate = 700 },
            { itemId = 23701, rate = 500 },
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
            { itemId = 28596, rate = 700 },
            { itemId = 11663, rate = 500 },
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
            { itemId = 23393, rate = 700 },
            { itemId = 28467, rate = 500 },
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
            { itemId = 23959, rate = 700 },
            { itemId = 11651, rate = 500 },
            { itemId = 18981, rate = 170 }, -- Railgun
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
            { itemId = 11670, rate = 700 },
            { itemId = 23702, rate = 500 },
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
            { itemId = 23515, rate = 700 },
            { itemId = 26102, rate = 500 },
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
            { itemId = 23411, rate = 700 },
            { itemId = 28426, rate = 500 },
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
            { itemId = 23960, rate = 700 },
            { itemId = 11672, rate = 500 },
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
            { itemId = 23516, rate = 700 },
            { itemId = 28427, rate = 500 },
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
            { itemId = 23412, rate = 700 },
            { itemId = 11671, rate = 500 },
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
            { itemId = 23961, rate = 700 },
            { itemId = 11668, rate = 500 },
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
            { itemId = 23969, rate = 700 },
            { itemId = 23413, rate = 500 },
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
            { itemId = 11667, rate = 700 },
            { itemId = 23703, rate = 500 },
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
            { itemId = 25527, rate = 700 },
            { itemId = 23704, rate = 500 },
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
            { itemId = 23970, rate = 700 },
            { itemId = 11647, rate = 500 },
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
            { itemId = 23971, rate = 700 },
            { itemId = 11648, rate = 500 },
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
            { itemId = 26103, rate = 700 },
            { itemId = 28428, rate = 500 },
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
            { itemId = 25531, rate = 700 },
            { itemId = 11649, rate = 500 },
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
            { itemId = 23972, rate = 700 },
            { itemId = 11650, rate = 500 },
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
            { itemId = 23414, rate = 700 },
            { itemId = 11646, rate = 500 },
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
            { itemId = 26104, rate = 700 },
            { itemId = 15858, rate = 500 },
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
            { itemId = 25532, rate = 700 },
            { itemId = 23520, rate = 500 },
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
            { itemId = 23973, rate = 700 },
            { itemId = 11637, rate = 500 },
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
            { itemId = 23974, rate = 700 },
            { itemId = 11639, rate = 500 },
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
            { itemId = 11644, rate = 700 },
            { itemId = 23705, rate = 500 },
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
            { itemId = 25533, rate = 700 },
            { itemId = 23528, rate = 500 },
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
            { itemId = 23975, rate = 700 },
            { itemId = 11645, rate = 500 },
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
            { itemId = 23976, rate = 700 },
            { itemId = 11664, rate = 500 },
        },
        deathMsg = "Melpomene has been slain! Its rare treasures await...",
    },
    ["flickering_flavius"] = {
        name = "Flickering Flavius",
        packetName = "FlckrFlavs",
        groupRef = "flickering_flavius",
        zones = { xi.zone.ULEGUERAND_RANGE, xi.zone.ATTOHWA_CHASM },
        level = { 38, 42 },
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 750,
        isAggro = true,
        loot = {
            { itemId = 792, rate = 1000 },
            { itemId = 23977, rate = 700 },
            { itemId = 11665, rate = 500 },
        },
        deathMsg = "Flickering Flavius has been dissipated! Its rare treasures await...",
    },
    ["volatile_valerius"] = {
        name = "Volatile Valerius",
        packetName = "VltleVlrs",
        groupRef = "volatile_valerius",
        zones = { xi.zone.OLDTON_MOVALPOLOS, xi.zone.MINE_SHAFT_2716 },
        level = { 42, 45 },
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 750,
        isAggro = true,
        loot = {
            { itemId = 795, rate = 1000 },
            { itemId = 23978, rate = 700 },
            { itemId = 11666, rate = 500 },
        },
        deathMsg = "Volatile Valerius has exploded! Its rare treasures await...",
    },
    ["vicious_valentinian"] = {
        name = "Vicious Valentinian",
        packetName = "VicsVlntn",
        groupRef = "vicious_valentinian",
        zones = { xi.zone.BIBIKI_BAY, xi.zone.ULEGUERAND_RANGE },
        level = { 45, 48 },
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 750,
        isAggro = true,
        loot = {
            { itemId = 798, rate = 1000 },
            { itemId = 23979, rate = 700 },
            { itemId = 11667, rate = 500 },
        },
        deathMsg = "Vicious Valentinian has been slain! Its rare treasures await...",
    },
    ["battering_basilius"] = {
        name = "Battering Basilius",
        packetName = "BtrngBsls",
        groupRef = "battering_basilius",
        zones = { xi.zone.LUFAISE_MEADOWS, xi.zone.MISAREAUX_COAST },
        level = { 48, 52 },
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 750,
        isAggro = true,
        loot = {
            { itemId = 801, rate = 1000 },
            { itemId = 23980, rate = 700 },
            { itemId = 11668, rate = 500 },
        },
        deathMsg = "Battering Basilius has been toppled! Its rare treasures await...",
    },
    ["lesser_manticore_lucilius"] = {
        name = "Lesser Manticore Lucilius",
        packetName = "LssrMntcLcl",
        groupRef = "lesser_manticore_lucilius",
        zones = { xi.zone.EASTERN_ALTEPA_DESERT, xi.zone.WESTERN_ALTEPA_DESERT },
        level = { 50, 55 },
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 750,
        isAggro = true,
        loot = {
            { itemId = 804, rate = 1000 },
            { itemId = 23981, rate = 700 },
            { itemId = 11669, rate = 500 },
        },
        deathMsg = "Lesser Manticore Lucilius has been slain! Its rare treasures await...",
    },
    ["deft_drusus"] = {
        name = "Deft Drusus",
        packetName = "DeftDrusus",
        groupRef = "deft_drusus",
        zones = { xi.zone.BIBIKI_BAY, xi.zone.ABYSSEA_KONSCHTAT },
        level = { 52, 56 },
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 750,
        isAggro = true,
        loot = {
            { itemId = 807, rate = 1000 },
            { itemId = 23982, rate = 700 },
            { itemId = 11670, rate = 500 },
        },
        deathMsg = "Deft Drusus has been slain! Its rare treasures await...",
    },
    ["stony_stefanus"] = {
        name = "Stony Stefanus",
        packetName = "StnyStfns",
        groupRef = "stony_stefanus",
        zones = { xi.zone.PSOXJA },
        level = { 55, 60 },
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 750,
        isAggro = true,
        loot = {
            { itemId = 810, rate = 1000 },
            { itemId = 23983, rate = 700 },
            { itemId = 11671, rate = 500 },
        },
        deathMsg = "Stony Stefanus has been shattered! Its rare treasures await...",
    },
    ["dread_decimus"] = {
        name = "Dread Decimus",
        packetName = "DreadDecms",
        groupRef = "dread_decimus",
        zones = { xi.zone.ULEGUERAND_RANGE, xi.zone.TEMENOS },
        level = { 58, 65 },
        spawnTimer = 10800,
        spawnWindow = 3600,
        spawnChance = 750,
        isAggro = true,
        loot = {
            { itemId = 813, rate = 1000 },
            { itemId = 23984, rate = 700 },
            { itemId = 11672, rate = 500 },
            { itemId = 18886, rate = 150 }, -- Sage Rod
        },
        deathMsg = "Dread Decimus has been banished! Its rare treasures await...",
    },
}

-----------------------------------
-- Award named rare loot to the killing player
-----------------------------------
nr.awardLoot = function(key, mob, player)
    local config = nr.db[key]
    if not config or not player then return end

    local gotSomething = false
    local awardedItems = {}
    for _, entry in ipairs(config.loot) do
        if math.random(1000) <= entry.rate then
            local added = player:addItem(entry.itemId, 1)
            if added then
                gotSomething = true
                table.insert(awardedItems, getItemDisplayName(entry.itemId))
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

        player:printToPlayer(
            string.format('[Named Rare] %s dropped: %s', config.name, table.concat(awardedItems, ', ')),
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
nr.resolveKey = function(query)
    if not query then
        return nil
    end

    if nr.db[query] then
        return query
    end

    local normalizedQuery = normalizeRareKey(query)
    if not normalizedQuery then
        return nil
    end

    for key, config in pairs(nr.db) do
        if normalizeRareKey(key) == normalizedQuery or
            normalizeRareKey(config.name) == normalizedQuery or
            normalizeRareKey(config.packetName) == normalizedQuery
        then
            return key
        end
    end

    return nil
end

nr.forceSpawn = function(key, player)
    local query = key
    key = nr.resolveKey(query)
    local config = nr.db[key]
    if not config then
        return false, 'Unknown named rare: ' .. tostring(query)
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
