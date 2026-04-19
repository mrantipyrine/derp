-----------------------------------
-- Dynamic World: Loot System
-----------------------------------
-- Dynamic loot tables for dynamic world entities.
-- Loot is awarded via Lua callbacks (not dropId), giving full control
-- over what drops and when.
--
-- ALL drops are Rare or Rare/Ex equipment items, level-appropriate
-- for the zone. The system picks items from a pool matching the zone's
-- level range, making every kill a chance at usable gear.
--
-- Loot tiers:
--   Wanderer: 1 item roll,  low-mid pool,   common rates
--   Nomad:    2 item rolls, mid pool,        moderate rates
--   Elite:    3 item rolls, mid-high pool,   good rates
--   Apex:     4 item rolls, high pool,       great rates + guaranteed drop
--
-- Item IDs reference the standard FFXI item database.
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
xi.dynamicWorld.loot = xi.dynamicWorld.loot or {}

local loot = xi.dynamicWorld.loot

local function getSetting(key)
    local s = xi.settings.dynamicworld
    return s and s[key]
end

-----------------------------------
-- Rare/Ex Equipment Pools by Level Range
-- Each pool is a list of real item IDs that are Rare or Rare/Ex.
-- Items are drawn from the pool matching the zone's level range.
-----------------------------------

loot.pools = {}

-- Level 1-20: Starter rare/ex items, plus unique dynamic world drops
-- REMOVED: Smithy's Mitts, Carpenter's Gloves, Tanner's Gloves (crafting only)
-- REMOVED: Caver's Shovel, Waders (crafting tools with no combat value)
-- REMOVED: Mandraguard (DEF+1), Chocobo Shield (DEF+1), Drover's Mantle (DEF+1)
-- ADDED: Unique monster-themed drops from IDs 30014-30017
loot.pools.low =
{
    -- Weapons
    17566,  -- Treat Staff (R/Ex, HP+5 MP+5)
    20781,  -- Sowilo Claymore (R/Ex, HP+5)
    17058,  -- Caduceus (R/Ex)
    16637,  -- Deathbringer (Rare, DEF-6 ATT+8)
    16656,  -- Orcish Axe (R/Ex, STR+2)
    -- Shields
    16185,  -- Pelte (Rare, DEF+6)
    12371,  -- Clipeus (R/Ex, DEF+6)
    -- Head
    10446,  -- Ahriman Cap (R/Ex, Dark DEF+5)
    13916,  -- Pumpkin Head (R/Ex)
    13945,  -- Shaded Spectacles (R/Ex)
    11811,  -- Destrier Beret (R/Ex, DEF+7)
    30017,  -- Rogue Scout's Beret (Custom: DEF+8 DEX+7 ACC+10 EVA+8 HP+30)
    -- Body
    10293,  -- Chocobo Shirt (R/Ex, DEF+2 — a classic!)
    10250,  -- Moogle Suit (R/Ex, DEF+1 — iconic)
    -- Feet
    13014,  -- Leaping Boots (Rare, DEF+3 DEX+3 AGI+3)
    15351,  -- Bounding Boots (R/Ex, DEF+3 DEX+3 AGI+3)
    -- Neck
    13112,  -- Rabbit Charm (Rare, DEF+1 DEX+1 AGI+1)
    13117,  -- Ranger's Necklace (Rare, RATT+5 RACC+5)
    16279,  -- Pile Chain (R/Ex, HP+3 ACC+1)
    -- Waist
    15880,  -- Key Ring Belt (R/Ex, DEF+2 DEX+1)
    -- Earrings
    30015,  -- Bat Sonar Earring (Custom: ACC+10 MACC+8 AGI+5)
    -- Rings
    13495,  -- San d'Orian Ring (R/Ex, DEF+2 STR+1 MND+1)
    13496,  -- Windurstian Ring (R/Ex, MP+3 AGI+1 INT+1)
    13497,  -- Bastokan Ring (R/Ex, HP+3 DEX+1 VIT+1)
    30016,  -- Bomb Core Fragment (Custom: ATT+15 MATT+12 STR+5 HP-30)
    -- Back
    13607,  -- Mist Silk Cape (Rare, DEF+3 MND+1 Light DEF+3)
    30014,  -- Crawler's Silk Mantle (Custom: DEF+5 AGI+8 EVA+10 Haste+5)
    -- Ranged
    19221,  -- Firefly (R/Ex, AGI+1)
    21460,  -- Matre Bell (R/Ex, MP+5)
}

-- Level 21-40: Mid-low gear with quest/NM flavor + nomad tier unique drops
-- ADDED: Tiger's Bloodmane Cloak, Shade Wraith Tabard, Goblin's Overstuffed Satchel,
--        Goblin's Jackpot Bell
loot.pools.mid_low =
{
    -- Weapons
    18503,  -- Mammut (R/Ex, Lv21)
    16434,  -- Sonic Knuckles (Rare, Lv22)
    18040,  -- Webcutter (R/Ex, Lv24)
    18604,  -- Astaroth Cane (Rare, Lv27)
    -- Shields
    16182,  -- Town Moogle Shield (R/Ex, Lv30)
    16183,  -- Nomad Moogle Shield (R/Ex, Lv30)
    12389,  -- Mercenary's Targe (Rare, Lv30)
    -- Head
    12486,  -- Emperor Hairpin (Rare, Lv24 - THE classic)
    15224,  -- Empress Hairpin (R/Ex, Lv24)
    11493,  -- Precision Bandana (Rare, Lv25, DEF+8 ACC+3)
    16086,  -- Phobos's Mask (R/Ex, Lv25)
    -- Body
    14548,  -- Phobos's Cuirass (R/Ex, Lv25)
    14556,  -- Tsukikazu Togi (R/Ex, Lv25)
    14552,  -- Freyr's Jerkin (R/Ex, Lv25)
    30019,  -- Shade Wraith Tabard (Custom: MP+100 INT+12 MND+10 MATT+18 MDEF+10)
    -- Hands
    14884,  -- Mycophile Cuffs (R/Ex, Lv25)
    14963,  -- Phobos's Gauntlets (R/Ex, Lv25)
    14967,  -- Freyr's Gloves (R/Ex, Lv25)
    14971,  -- Tsukikazu Gote (R/Ex, Lv25)
    -- Legs
    15627,  -- Phobos's Cuisses (R/Ex, Lv25)
    15635,  -- Tsukikazu Haidate (R/Ex, Lv25)
    15631,  -- Freyr's Trousers (R/Ex, Lv25)
    16368,  -- Herder's Subligar (R/Ex, Lv25)
    -- Feet
    13013,  -- Stumbling Sandals (Rare, Lv22)
    11401,  -- Rambler's Gaiters (R/Ex, Lv25)
    15713,  -- Phobos's Sabatons (R/Ex, Lv25)
    -- Neck
    13095,  -- Sand Charm (R/Ex, Lv27)
    15504,  -- Ajase Bead Necklace (R/Ex, Lv30)
    15505,  -- Dhalmel Whistle (R/Ex, Lv31)
    13129,  -- Spirit Torque (Rare, Lv38)
    -- Waist
    15940,  -- Gosha Sarashi (R/Ex, Lv33)
    15296,  -- Tathlum Belt (R/Ex, Lv35)
    13237,  -- Survival Belt (Rare, Lv38)
    13238,  -- Druid's Rope (Rare, Lv40)
    30020,  -- Goblin's Overstuffed Satchel (Custom: ALL STATS+6 HP+50 MP+30)
    -- Earrings
    11043,  -- Giant's Earring (Rare, Lv30, HP+10 STR+1)
    13359,  -- Bloodbead Earring (Rare, Lv32)
    14767,  -- Evasion Earring (Rare, Lv35)
    30031,  -- Goblin's Jackpot Bell (Custom: ACC+20 ATT+20 Haste+10 HP+50)
    -- Rings
    14667,  -- Carect Ring (R/Ex, Lv25)
    14660,  -- Bowyer Ring (Rare, Lv29)
    15544,  -- Sattva Ring (R/Ex, Lv30)
    -- Back
    13576,  -- Night Cape (Rare, Lv21)
    11529,  -- Frugal Cape (R/Ex, Lv23)
    13680,  -- Variable Mantle (R/Ex, Lv20)
    13659,  -- Mercenary Mantle (Rare, Lv30)
    30018,  -- Tiger's Bloodmane Cloak (Custom: ATT+22 STR+10 Haste+7 HP+40)
    -- Ranged
    17843,  -- Oliphant (Rare, Lv40)
    19222,  -- Wurger (R/Ex, Lv21)
    17211,  -- Almogavar Bow (Rare, Lv20)
}

-- Level 41-55: Mid-level gear with solid stats
loot.pools.mid =
{
    -- Weapons
    17532,  -- Kukulcan's Staff (R/Ex, Lv41)
    16829,  -- Fencing Degen (R/Ex, Lv41, MP+10 INT+1 MND+1)
    17422,  -- Blessed Hammer (R/Ex, Lv41)
    16798,  -- Raven Scythe (R/Ex, Lv43, STR+2 INT+2)
    17478,  -- Beat Cesti (R/Ex, Lv42)
    17643,  -- Honor Sword (R/Ex, Lv42)
    17812,  -- Magoroku (R/Ex, Lv42)
    18607,  -- Ceres Spica (Rare, Lv43)
    18075,  -- Rossignol (R/Ex, Lv43)
    16727,  -- Eisentaenzer (R/Ex, Lv46)
    -- Shields
    16186,  -- Spellcaster's Ecu (Rare, Lv42)
    12348,  -- Serket Shield (Rare, Lv51)
    -- Head
    15220,  -- Rain Hat (R/Ex, Lv41)
    15184,  -- Voyager Sallet (R/Ex, Lv41)
    27661,  -- Namru's Tiara (R/Ex, Lv45)
    -- Body
    27800,  -- Genta Hara-ate (R/Ex, Lv45)
    27798,  -- Ate's Cuirass (R/Ex, Lv45)
    27799,  -- Idis Jerkin (R/Ex, Lv45)
    -- Hands
    15042,  -- Gothic Gauntlets (R/Ex, Lv43)
    27940,  -- Genta Gote (R/Ex, Lv45)
    27941,  -- Namru's Dastanas (R/Ex, Lv45)
    27942,  -- Neit's Cuffs (R/Ex, Lv45)
    -- Legs
    28085,  -- Neit's Slops (R/Ex, Lv45)
    28081,  -- Ate's Flanchard (R/Ex, Lv45)
    28084,  -- Namru's Shalwar (R/Ex, Lv45)
    -- Feet
    11402,  -- Gothic Sabatons (R/Ex, Lv43)
    28218,  -- Ate's Sollerets (R/Ex, Lv45)
    28222,  -- Neit's Pigaches (R/Ex, Lv45)
    -- Neck
    13178,  -- Auditory Torque (R/Ex, Lv47)
    15506,  -- Parade Gorget (R/Ex, Lv50)
    -- Waist
    15882,  -- Storm Belt (R/Ex, Lv50, STR+4 VIT+4)
    15286,  -- Tilt Belt (Rare, Lv40, ACC+5)
    30021,  -- Goobbue Rootbelt (Custom: HP+120 VIT+14 STR+10 DEF+20 ATT+15)
    -- Earrings
    14724,  -- Moldavite Earring (R/Ex, Lv47, MACC+5)
    14782,  -- Astral Earring (Rare, Lv45)
    -- Rings
    14676,  -- Assailant's Ring (Rare, Lv42, ATT+5)
    14626,  -- Mermaid's Ring (Rare, Lv43)
    14687,  -- Kshama Ring No.6 (R/Ex, Lv49)
    -- Back
    15467,  -- Lucent Cape (Rare, Lv42)
    16251,  -- Casaba Melon Tank (R/Ex, Lv42)
    13598,  -- Bat Cape (Rare, Lv46)
    -- Ranged
    18714,  -- Valis Bow (R/Ex, Lv55)
    17188,  -- Sniping Bow (R/Ex, Lv41)
    18702,  -- Trump Gun (R/Ex, Lv40)
}

-- Level 56-70: Upper-mid gear, AF-tier items
loot.pools.mid_high =
{
    -- Weapons
    16728,  -- Schwarz Axt (R/Ex, Lv56)
    17814,  -- Raikiri (Rare, Lv56)
    16945,  -- Arondight (R/Ex, Lv62)
    17925,  -- Fransisca (R/Ex, Lv63)
    17981,  -- Bano del Sol (R/Ex, Lv61)
    19121,  -- Sleight Kukri (R/Ex, Lv62)
    16882,  -- Calamar (R/Ex, Lv56)
    -- Shields
    16187,  -- Adoubeur's Pavise (R/Ex, Lv59)
    16172,  -- Iron Ram Shield (Rare, Lv60)
    12351,  -- Astral Shield (Rare, Lv58)
    -- Head
    12517,  -- Beast Helm (R/Ex, Lv56)
    12511,  -- Fighter's Mask (R/Ex, Lv56)
    12515,  -- Gallant Coronet (R/Ex, Lv56)
    -- Body
    14516,  -- Hydra Harness (R/Ex, Lv70)
    14518,  -- Hydra Jupon (R/Ex, Lv70)
    -- Hands
    13974,  -- Drachen Finger Gauntlets (R/Ex, Lv56)
    13972,  -- Myochin Kote (R/Ex, Lv56)
    14063,  -- Protecting Bangles (R/Ex, Lv56)
    -- Legs
    14223,  -- Choral Cannions (R/Ex, Lv56)
    14287,  -- Luna Subligar (R/Ex, Lv62)
    16316,  -- Fourth Division Schoss (R/Ex, Lv68)
    -- Feet
    14103,  -- Evoker's Pigaches (R/Ex, Lv56)
    15685,  -- Corsair's Bottes (R/Ex, Lv56)
    14094,  -- Rogue's Poulaines (R/Ex, Lv60)
    -- Neck
    13128,  -- Spectacles (Rare, Lv59)
    13136,  -- Star Necklace (R/Ex, Lv59)
    16293,  -- Cougar Pendant (R/Ex, Lv60)
    13148,  -- Evasion Torque (Rare, Lv65)
    13152,  -- Divine Torque (Rare, Lv65)
    13157,  -- Healing Torque (Rare, Lv65)
    30022,  -- Dread Hunter's Choker (Custom: ATT+28 ACC+20 DEX+12 Haste+8 HP+60)
    -- Waist
    15300,  -- Nebimonite Belt (R/Ex, Lv56)
    15897,  -- Grace Corset (R/Ex, Lv58)
    13236,  -- Master Belt (Rare, Lv58)
    -- Earrings
    13400,  -- Bitter Earring (Rare, Lv56)
    13403,  -- Assault Earring (Rare, Lv58)
    14758,  -- Knightly Earring (Rare, Lv59)
    14764,  -- Minuet Earring (Rare, Lv61)
    30025,  -- Crystal Golem's Heart (Custom: DEF+12 HP+100 VIT+15 MDEF+20)
    -- Rings
    14668,  -- Zoredonite Ring (R/Ex, Lv56)
    13555,  -- Peace Ring (Rare, Lv59)
    11636,  -- Royal Knight Sigil Ring (R/Ex, Lv60)
    13560,  -- Fire Ring (R/Ex, Lv65)
    13561,  -- Ice Ring (R/Ex, Lv65)
    13562,  -- Wind Ring (R/Ex, Lv65)
    -- Head
    30024,  -- Nexus Core Helm (Custom: MATT+25 MACC+18 INT+15 MP+80 Haste+8)
    -- Hands
    30023,  -- Fell Commander's Vambrace (Custom: DEF+20 STR+12 ATT+20 ACC+15 HP+80 ENMITY+10)
    -- Back
    13624,  -- Enhancing Mantle (Rare, Lv59)
    11533,  -- Lyricist's Gonnelle (R/Ex, Lv64)
    13655,  -- Sand Mantle (Rare, Lv65)
    -- Ranged
    17199,  -- Loxley Bow (R/Ex, Lv57)
    17235,  -- Armbrust (Rare, Lv58)
    17379,  -- Hamelin Flute (Rare, Lv58)
}

-- Level 71-99: Endgame-tier rare/ex items + apex unique dynamic world drops
-- ADDED: Void Wyrm's Fang, Abyssal Tyrant's Diadem, Ancient King's Carapace,
--        Apex Soulstone, Wanderer's Legacy, Void Wyrm Scale
loot.pools.high =
{
    -- Weapons
    16735,  -- Axe of Trials (R/Ex, Lv71)
    16793,  -- Scythe of Trials (R/Ex, Lv71)
    16892,  -- Spear of Trials (R/Ex, Lv71)
    16428,  -- Afflictors (R/Ex, Lv77)
    17185,  -- Siege Bow (R/Ex, Lv79)
    -- Shields
    16177,  -- Legion Scutum (R/Ex, Lv71)
    16173,  -- Pallas's Shield (Rare, Lv72)
    12408,  -- Absorbing Shield (Rare, Lv71)
    -- Head
    15077,  -- Assassin's Bonnet (R/Ex, Lv71)
    16159,  -- Zhago's Barbut (R/Ex, Lv71)
    16152,  -- Hissho Hachimaki (R/Ex, Lv71)
    30027,  -- Abyssal Tyrant's Diadem (Custom: STR+15 INT+15 MND+12 ATT+30 MATT+28 ACC+20 HP+120)
    -- Body
    30028,  -- Ancient King's Carapace (Custom: DEF+50 HP+300 VIT+20 MDEF+35 ENMITY+15)
    -- Hands
    15038,  -- Etoile Bangles (R/Ex, Lv71)
    15040,  -- Argute Bracers (R/Ex, Lv71)
    15056,  -- Rover's Gloves (R/Ex, Lv71)
    -- Legs
    16339,  -- Paddock Trousers (R/Ex, Lv71)
    15604,  -- Amir Dirs (R/Ex, Lv72)
    15609,  -- Pahluwan Seraweels (R/Ex, Lv72)
    -- Feet
    15134,  -- Cleric's Duckbills (R/Ex, Lv71)
    15133,  -- Melee Gaiters (R/Ex, Lv71)
    11382,  -- Mirage Charuqs (R/Ex, Lv71)
    -- Neck
    16272,  -- Naraenten Bead Necklace (Rare, Lv71)
    27510,  -- Fotia Gorget (R/Ex, Lv72)
    11591,  -- Ravager's Gorget (R/Ex, Lv80)
    11593,  -- Goetia Chain (R/Ex, Lv80)
    30026,  -- Void Wyrm's Fang (Custom: ATT+40 MATT+35 STR+15 INT+12 Haste+12 HP+80)
    -- Waist
    15918,  -- Witch Sash (Rare, Lv71)
    28419,  -- Hachirin-no-Obi (R/Ex, Lv71)
    15916,  -- Corsair's Belt (R/Ex, Lv71)
    -- Earrings
    15963,  -- Magnetic Earring (R/Ex, Lv72)
    15965,  -- Ethereal Earring (R/Ex, Lv72)
    14739,  -- Suppanomimi (R/Ex, Lv72)
    15980,  -- Magnifying Earring (R/Ex, Lv62)
    -- Rings
    15831,  -- Fenian Ring (R/Ex, Lv71)
    14625,  -- Evoker's Ring (R/Ex, Lv71)
    15833,  -- Diverter's Ring (R/Ex, Lv71)
    11643,  -- Odium Ring (Rare, Lv76)
    30029,  -- Apex Soulstone (Custom: HP+120 MP+80 STR+12 INT+12 ATT+20 MATT+20 Haste+10)
    30030,  -- Wanderer's Legacy (Custom: HP+150 MP+100 ALL STATS+10 Haste+15)
    -- Back
    16239,  -- Solitaire Cape (R/Ex, Lv71)
    16221,  -- Aileron Mantle (R/Ex, Lv71)
    15464,  -- Corse Cape (Rare, Lv71)
    11553,  -- Cavaro's Mantle (R/Ex, Lv80)
    11555,  -- Ferine Mantle (R/Ex, Lv80)
    30032,  -- Void Wyrm Scale (Custom: DEF+30 ATT+35 STR+15 VIT+15 HP+150 Haste+10)
    -- Ranged
    18144,  -- Bow of Trials (R/Ex, Lv71)
    18146,  -- Gun of Trials (R/Ex, Lv71)
    17246,  -- Ziska's Crossbow (Rare, Lv71)
}

-----------------------------------
-- Level Range -> Pool Mapping
-----------------------------------
loot.getPoolForLevel = function(zoneLevelRange)
    local avgLevel = math.floor((zoneLevelRange[1] + zoneLevelRange[2]) / 2)

    if avgLevel <= 20 then
        return loot.pools.low
    elseif avgLevel <= 40 then
        return loot.pools.mid_low
    elseif avgLevel <= 55 then
        return loot.pools.mid
    elseif avgLevel <= 70 then
        return loot.pools.mid_high
    else
        return loot.pools.high
    end
end

-----------------------------------
-- Loot Table Definitions (now tier-based with item pool lookups)
-- rate = chance per 1000 that any given item from the pool drops
-- rolls = how many items to attempt from the pool
-----------------------------------

loot.tables = {}

loot.tables.wanderer_common =
{
    gil     = { min = 100, max = 800 },
    rolls   = 1,
    rate    = 150,  -- 15% per roll
}

loot.tables.wanderer_uncommon =
{
    gil     = { min = 200, max = 1200 },
    rolls   = 1,
    rate    = 200,  -- 20% per roll
}

loot.tables.nomad_predator =
{
    gil     = { min = 500, max = 3000 },
    rolls   = 2,
    rate    = 200,  -- 20% per roll
}

loot.tables.nomad_arcane =
{
    gil     = { min = 800, max = 4000 },
    rolls   = 2,
    rate    = 250,  -- 25% per roll
}

loot.tables.treasure_goblin =
{
    gil     = { min = 5000, max = 30000 },
    rolls   = 5,
    rate    = 500,  -- 50% per roll (jackpot!)
}

loot.tables.elite_predator =
{
    gil     = { min = 3000, max = 12000 },
    rolls   = 3,
    rate    = 300,  -- 30% per roll
}

loot.tables.elite_beastman =
{
    gil     = { min = 3000, max = 15000 },
    rolls   = 3,
    rate    = 300,
}

loot.tables.elite_arcane =
{
    gil     = { min = 4000, max = 18000 },
    rolls   = 3,
    rate    = 350,
}

loot.tables.elite_elemental =
{
    gil     = { min = 3000, max = 12000 },
    rolls   = 3,
    rate    = 300,
}

loot.tables.apex_dragon =
{
    gil         = { min = 15000, max = 60000 },
    rolls       = 4,
    rate        = 400,
    guaranteed  = 1,    -- At least 1 item guaranteed
}

loot.tables.apex_demon =
{
    gil         = { min = 20000, max = 80000 },
    rolls       = 4,
    rate        = 400,
    guaranteed  = 1,
}

loot.tables.apex_king =
{
    gil         = { min = 25000, max = 100000 },
    rolls       = 5,
    rate        = 500,
    guaranteed  = 2,    -- At least 2 items guaranteed
}

loot.tables.none =
{
    gil     = { min = 0, max = 0 },
    rolls   = 0,
    rate    = 0,
}

-----------------------------------
-- Award loot to a player from a loot table
-- Uses zone level range to pick the appropriate item pool
-----------------------------------
loot.award = function(mob, player, template, tier)
    local tableName = template.lootTable or 'none'
    local lt = loot.tables[tableName]
    if not lt then
        return
    end

    local rateMultiplier = getSetting('DYNAMIC_LOOT_BONUS_RATE') or 1.5
    local gilMultiplier  = getSetting('LOOT_GIL_MULTIPLIER') or 2.0

    -- Award gil
    if lt.gil and lt.gil.max > 0 then
        local gilAmount = math.random(lt.gil.min, lt.gil.max)
        gilAmount = math.floor(gilAmount * gilMultiplier)
        if gilAmount > 0 then
            player:addGil(gilAmount)
            player:printToPlayer(
                string.format('[Dynamic World] Obtained %d gil!', gilAmount),
                xi.msg.channel.SYSTEM_3
            )
        end
    end

    -- Get the zone's level range for pool selection
    local zoneId = mob:getZoneID()
    local zoneLevelRange = xi.dynamicWorld.getZoneLevelRange(zoneId)
    local pool = loot.getPoolForLevel(zoneLevelRange)

    if not pool or #pool == 0 or lt.rolls == 0 then
        return
    end

    -- Roll for items from the level-appropriate pool
    local itemsAwarded = 0
    local rolls = lt.rolls or 1
    local baseRate = lt.rate or 100

    -- Apply chain bonus to loot rate
    local chainBonus = xi.dynamicWorld.getChainBonus(player)
    local adjustedRate = math.min(900, math.floor(baseRate * rateMultiplier * (1 + chainBonus * 0.5)))

    for i = 1, rolls do
        if math.random(1, 1000) <= adjustedRate then
            -- Pick a random item from the pool
            local itemId = pool[math.random(#pool)]
            local added = player:addItem(itemId, 1)
            if added then
                itemsAwarded = itemsAwarded + 1
            end
        end
    end

    -- Handle guaranteed drops (Apex tier)
    local guaranteed = lt.guaranteed or 0
    if guaranteed > 0 and itemsAwarded < guaranteed then
        for i = 1, (guaranteed - itemsAwarded) do
            local itemId = pool[math.random(#pool)]
            local added = player:addItem(itemId, 1)
            if added then
                itemsAwarded = itemsAwarded + 1
            end
        end
    end

    if itemsAwarded > 0 then
        local tierName = xi.dynamicWorld.tierName[tier] or 'Unknown'
        player:printToPlayer(
            string.format('[Dynamic World] %s defeated! Obtained %d rare item(s)!', tierName, itemsAwarded),
            xi.msg.channel.SYSTEM_3
        )
    end
end
