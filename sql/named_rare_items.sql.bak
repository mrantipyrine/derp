-- =============================================================================
-- NAMED RARE MOB ITEMS
-- =============================================================================
-- ID ranges by mob type:
--   30100-30129  Sheep
--   30130-30159  Rabbits
--   30160-30189  Crabs
--   30190-30219  Fungars
--   30220-30249  Goblins
--   30250-30279  Coeurls
--   30280-30309  Tigers
--   30310-30339  Mandragoras
--   30340-30369  Beetles
--   30370-30399  Crawlers
--   30400-30429  Birds
--   30430-30459  Bees
--   30460-30489  Worms
--   30490-30519  Lizards
--
-- Each named rare gets 3 slots:
--   +0  = Trophy (Rare/Ex, unsellable, 1 line description flavor)
--   +1  = Main equip drop (~40% from the rare)
--   +2  = Second equip drop (~15% from the rare, better stats)
--
-- flags: 46660 = Rare + Exclusive (no AH/no sale)
-- flags: 12352 = Rare only (can sell to NPC)
--
-- Run with: mariadb -u root -p xidb < sql/named_rare_items.sql
-- Safe to re-run (uses REPLACE INTO everywhere)
-- =============================================================================

USE xidb;

-- =============================================================================
-- SHEEP  (Wooly William, Baa-rbara, Lambchop Larry, Shear Sharon)
-- =============================================================================

-- --- Wooly William (2h timer, lv6-8, Ronfaure) ---
REPLACE INTO `item_basic` VALUES (30100,0,"William's_Wool","williams_wool",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30101,0,"William's_Woolcap","williams_woolcap",1,59476,99,0,400);
REPLACE INTO `item_basic` VALUES (30102,0,"William's_Woolmitt","williams_woolmitt",1,59476,99,0,600);

REPLACE INTO `item_equipment` VALUES (30101,"williams_woolcap",    5,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (30102,"williams_woolmitt",   5,0,4194303,0,0,0,  32,0,0,0); -- HANDS

REPLACE INTO `item_mods` VALUES (30101, 2, 20),(30101, 9, 3),(30101,10, 3);  -- HP+20 MND+3 CHR+3
REPLACE INTO `item_mods` VALUES (30102, 1,  6),(30102, 6, 3),(30102, 2,15);  -- DEF+6 VIT+3 HP+15

-- --- Baa-rbara (4h timer, lv10-13, Ronfaure) ---
REPLACE INTO `item_basic` VALUES (30103,0,"Baa-rbara's_Bell","baarbara_bell",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30104,0,"Baa-rbara's_Collar","baarbara_collar",1,59476,99,0,800);
REPLACE INTO `item_basic` VALUES (30105,0,"Baa-rbara's_Ribbon","baarbara_ribbon",1,59476,99,0,1200);

REPLACE INTO `item_equipment` VALUES (30104,"baarbara_collar",    10,0,4194303,0,0,0,   4,0,0,0); -- NECK
REPLACE INTO `item_equipment` VALUES (30105,"baarbara_ribbon",    10,0,4194303,0,0,0, 512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (30104, 9, 4),(30104,10, 4),(30104, 2,20);  -- MND+4 CHR+4 HP+20
REPLACE INTO `item_mods` VALUES (30105, 9, 3),(30105, 3,10),(30105,47, 3);  -- MND+3 MP+10 Haste+3

-- --- Lambchop Larry (8h timer, lv20-24, Ronfaure/Midlands) ---
REPLACE INTO `item_basic` VALUES (30106,0,"Larry's_Lambchop","larrys_lambchop",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30107,0,"Larry's_Lucky_Fleece","larrys_lucky_fleece",1,59476,99,0,3000);
REPLACE INTO `item_basic` VALUES (30108,0,"Larry's_Lanyard","larrys_lanyard",1,59476,99,0,4500);

REPLACE INTO `item_equipment` VALUES (30107,"larrys_lucky_fleece", 20,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (30108,"larrys_lanyard",      20,0,4194303,0,0,0,   4,0,0,0); -- NECK

REPLACE INTO `item_mods` VALUES (30107, 1, 8),(30107, 6, 5),(30107, 2,40),(30107,11,10);  -- DEF+8 VIT+5 HP+40 ATT+10
REPLACE INTO `item_mods` VALUES (30108, 2,30),(30108, 9, 6),(30108,10, 6),(30108,47, 5);  -- HP+30 MND+6 CHR+6 Haste+5

-- --- Shear Sharon (16h timer, lv35-40, Midlands) ---
REPLACE INTO `item_basic` VALUES (30109,0,"Sharon's_Golden_Fleece","sharons_golden_fleece",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30110,0,"Sharon's_Shearing_Shears","sharons_shearing_shears",1,59476,99,0,8000);
REPLACE INTO `item_basic` VALUES (30111,0,"Sharon's_Silken_Mantle","sharons_silken_mantle",1,59476,99,0,12000);

REPLACE INTO `item_equipment` VALUES (30110,"sharons_shearing_shears",35,0,4194303,0,0,0,  32,0,0,0); -- HANDS
REPLACE INTO `item_equipment` VALUES (30111,"sharons_silken_mantle",  35,0,4194303,0,0,0, 256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (30110, 4, 8),(30110, 5, 8),(30110,12,12),(30110,11,12);  -- STR+8 DEX+8 ACC+12 ATT+12
REPLACE INTO `item_mods` VALUES (30111, 1,12),(30111, 6,10),(30111, 2,60),(30111,47, 8);  -- DEF+12 VIT+10 HP+60 Haste+8

-- =============================================================================
-- RABBITS (Cottontail Tommy, Hopscotch Harvey, Bun-bun Benedict, Twitchy Theodore)
-- =============================================================================

-- --- Cottontail Tommy (2h timer, lv5-7, Ronfaure/Sarutabaruta) ---
REPLACE INTO `item_basic` VALUES (30130,0,"Tommy's_Cotton_Tail","tommys_cotton_tail",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30131,0,"Tommy's_Thumper_Ring","tommys_thumper_ring",1,59476,99,0,500);
REPLACE INTO `item_basic` VALUES (30132,0,"Cottontail_Cloak","cottontail_cloak",1,59476,99,0,700);

REPLACE INTO `item_equipment` VALUES (30131,"tommys_thumper_ring",  5,0,4194303,0,0,0,  64,0,0,0); -- RING1
REPLACE INTO `item_equipment` VALUES (30132,"cottontail_cloak",     5,0,4194303,0,0,0, 256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (30131, 5, 3),(30131, 7, 3),(30131,13, 5);  -- DEX+3 AGI+3 EVA+5
REPLACE INTO `item_mods` VALUES (30132, 7, 4),(30132,13, 6),(30132, 2,20);  -- AGI+4 EVA+6 HP+20

-- --- Hopscotch Harvey (5h timer, lv10-13, Ronfaure/Sarutabaruta) ---
REPLACE INTO `item_basic` VALUES (30133,0,"Harvey's_Lucky_Foot","harveys_lucky_foot",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30134,0,"Harvey's_Hoppers","harveys_hoppers",1,59476,99,0,1500);
REPLACE INTO `item_basic` VALUES (30135,0,"Harvey's_Headband","harveys_headband",1,59476,99,0,2000);

REPLACE INTO `item_equipment` VALUES (30134,"harveys_hoppers",     10,0,4194303,0,0,0,2048,0,0,0); -- FEET
REPLACE INTO `item_equipment` VALUES (30135,"harveys_headband",    10,0,4194303,0,0,0,   1,0,0,0); -- HEAD

REPLACE INTO `item_mods` VALUES (30134, 7, 5),(30134,13, 8),(30134, 5, 3);  -- AGI+5 EVA+8 DEX+3
REPLACE INTO `item_mods` VALUES (30135, 5, 5),(30135, 7, 5),(30135, 2,25);  -- DEX+5 AGI+5 HP+25

-- --- Bun-bun Benedict (10h timer, lv22-28, Midlands) ---
REPLACE INTO `item_basic` VALUES (30136,0,"Benedict's_Bonnet","benedicts_bonnet",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30137,0,"Bun-bun_Bangle","bunbun_bangle",1,59476,99,0,4000);
REPLACE INTO `item_basic` VALUES (30138,0,"Benedict's_Battle_Wrap","benedicts_battle_wrap",1,59476,99,0,6000);

REPLACE INTO `item_equipment` VALUES (30137,"bunbun_bangle",       22,0,4194303,0,0,0,  32,0,0,0); -- HANDS
REPLACE INTO `item_equipment` VALUES (30138,"benedicts_battle_wrap",22,0,4194303,0,0,0, 512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (30137, 5, 7),(30137,13,10),(30137,12, 8);  -- DEX+7 EVA+10 ACC+8
REPLACE INTO `item_mods` VALUES (30138, 7, 8),(30138, 4, 6),(30138,11,12);  -- AGI+8 STR+6 ATT+12

-- --- Twitchy Theodore (18h timer, lv38-45, Midlands/Elshimo) ---
REPLACE INTO `item_basic` VALUES (30139,0,"Theodore's_Twitching_Ear","theodores_twitching_ear",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30140,0,"Theodore's_Earring","theodores_earring",1,59476,99,0,9000);
REPLACE INTO `item_basic` VALUES (30141,0,"Twitchy_Talisman","twitchy_talisman",1,59476,99,0,14000);

REPLACE INTO `item_equipment` VALUES (30140,"theodores_earring",   38,0,4194303,0,0,0,   8,0,0,0); -- EAR
REPLACE INTO `item_equipment` VALUES (30141,"twitchy_talisman",    38,0,4194303,0,0,0,   4,0,0,0); -- NECK

REPLACE INTO `item_mods` VALUES (30140, 7,10),(30140,13,15),(30140, 5, 8),(30140,47, 5);  -- AGI+10 EVA+15 DEX+8 Haste+5
REPLACE INTO `item_mods` VALUES (30141, 7,10),(30141, 5,10),(30141,12,15),(30141,11,15);  -- AGI+10 DEX+10 ACC+15 ATT+15

-- =============================================================================
-- CRABS (Crab Leg Cameron, Old Bay Ollie, Bisque Bernard, Dungeness Duncan)
-- =============================================================================

-- --- Crab Leg Cameron (4h timer, lv12-16, coastal) ---
REPLACE INTO `item_basic` VALUES (30160,0,"Cameron's_Claw","camerons_claw",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30161,0,"Crab_Leg_Ring","crab_leg_ring",1,59476,99,0,1500);
REPLACE INTO `item_basic` VALUES (30162,0,"Cameron's_Carapace_Belt","camerons_carapace_belt",1,59476,99,0,2500);

REPLACE INTO `item_equipment` VALUES (30161,"crab_leg_ring",       12,0,4194303,0,0,0,  64,0,0,0); -- RING
REPLACE INTO `item_equipment` VALUES (30162,"camerons_carapace_belt",12,0,4194303,0,0,0,512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (30161, 4, 5),(30161,11,10),(30161, 1, 4);  -- STR+5 ATT+10 DEF+4
REPLACE INTO `item_mods` VALUES (30162, 1,10),(30162, 6, 6),(30162, 2,30);  -- DEF+10 VIT+6 HP+30

-- --- Old Bay Ollie (8h timer, lv25-30, coastal/midlands) ---
REPLACE INTO `item_basic` VALUES (30163,0,"Ollie's_Old_Bay_Shell","ollies_old_bay_shell",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30164,0,"Old_Bay_Buckler","old_bay_buckler",1,59476,99,0,5000);
REPLACE INTO `item_basic` VALUES (30165,0,"Ollie's_Oven_Mitts","ollies_oven_mitts",1,59476,99,0,7000);

REPLACE INTO `item_equipment` VALUES (30164,"old_bay_buckler",     25,0,4194303,0,0,0,   2,0,0,0); -- NECK
REPLACE INTO `item_equipment` VALUES (30165,"ollies_oven_mitts",   25,0,4194303,0,0,0,  32,0,0,0); -- HANDS

REPLACE INTO `item_mods` VALUES (30164, 1,12),(30164, 2,50),(30164, 6, 8);  -- DEF+12 HP+50 VIT+8
REPLACE INTO `item_mods` VALUES (30165, 1,10),(30165, 4, 8),(30165,11,14);  -- DEF+10 STR+8 ATT+14

-- --- Bisque Bernard (14h timer, lv35-42, midlands) ---
REPLACE INTO `item_basic` VALUES (30166,0,"Bernard's_Bisque_Bowl","bernards_bisque_bowl",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30167,0,"Bisque_Bernard's_Shell","bisque_bernards_shell",1,59476,99,0,8000);
REPLACE INTO `item_basic` VALUES (30168,0,"Bernard's_Briny_Ring","bernards_briny_ring",1,59476,99,0,11000);

REPLACE INTO `item_equipment` VALUES (30167,"bisque_bernards_shell",35,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (30168,"bernards_briny_ring",  35,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30167, 1,16),(30167, 6,10),(30167, 2,70),(30167,47, 6);  -- DEF+16 VIT+10 HP+70 Haste+6
REPLACE INTO `item_mods` VALUES (30168, 4, 8),(30168, 6, 8),(30168,11,18),(30168,12,12);  -- STR+8 VIT+8 ATT+18 ACC+12

-- --- Dungeness Duncan (20h timer, lv45-52, Elshimo/Aradjiah) ---
REPLACE INTO `item_basic` VALUES (30169,0,"Duncan's_Dreadnought_Claw","duncans_dreadnought_claw",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30170,0,"Dungeness_Duncan's_Ring","dungeness_duncans_ring",1,59476,99,0,18000);
REPLACE INTO `item_basic` VALUES (30171,0,"Duncan's_Domain_Belt","duncans_domain_belt",1,59476,99,0,25000);

REPLACE INTO `item_equipment` VALUES (30170,"dungeness_duncans_ring",45,0,4194303,0,0,0, 64,0,0,0); -- RING
REPLACE INTO `item_equipment` VALUES (30171,"duncans_domain_belt",   45,0,4194303,0,0,0,512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (30170, 4,12),(30170, 6,10),(30170,11,20),(30170,12,18),(30170,47, 8);  -- STR+12 VIT+10 ATT+20 ACC+18 Haste+8
REPLACE INTO `item_mods` VALUES (30171, 1,20),(30171, 6,14),(30171, 2,100),(30171,47,10);               -- DEF+20 VIT+14 HP+100 Haste+10

-- =============================================================================
-- FUNGARS (Cap'n Chanterelle, Portobello Pete, Truffle Trevor)
-- (Mushroom Morris is in custom_items.sql at 30000)
-- =============================================================================

-- --- Cap'n Chanterelle (6h timer, lv18-22, Midlands) ---
REPLACE INTO `item_basic` VALUES (30190,0,"Chanterelle's_Cap","chanterelles_cap",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30191,0,"Cap'n_Chanterelle's_Hat","capn_chanterelles_hat",1,59476,99,0,3500);
REPLACE INTO `item_basic` VALUES (30192,0,"Chanterelle_Choker","chanterelle_choker",1,59476,99,0,5000);

REPLACE INTO `item_equipment` VALUES (30191,"capn_chanterelles_hat",18,0,4194303,0,0,0,  1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (30192,"chanterelle_choker",   18,0,4194303,0,0,0,  4,0,0,0); -- NECK

REPLACE INTO `item_mods` VALUES (30191, 8, 6),(30191, 9, 6),(30191, 3,30),(30191,14,10);  -- INT+6 MND+6 MP+30 MATK+10
REPLACE INTO `item_mods` VALUES (30192, 8, 5),(30192, 9, 5),(30192, 2,30),(30192,15, 8);  -- INT+5 MND+5 HP+30 MACC+8

-- --- Portobello Pete (14h timer, lv35-40, Midlands/Aradjiah) ---
REPLACE INTO `item_basic` VALUES (30193,0,"Pete's_Portobello","petes_portobello",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30194,0,"Portobello_Pete's_Parasol","portobello_petes_parasol",1,59476,99,0,10000);
REPLACE INTO `item_basic` VALUES (30195,0,"Pete's_Spore_Ring","petes_spore_ring",1,59476,99,0,14000);

REPLACE INTO `item_equipment` VALUES (30194,"portobello_petes_parasol",35,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (30195,"petes_spore_ring",        35,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30194, 1,12),(30194, 8, 8),(30194, 9, 8),(30194,14,15),(30194,15,12);  -- DEF+12 INT+8 MND+8 MATK+15 MACC+12
REPLACE INTO `item_mods` VALUES (30195, 8,10),(30195, 9,10),(30195,14,20),(30195,23,10);                 -- INT+10 MND+10 MATK+20 MDEF+10

-- --- Truffle Trevor (22h timer, lv55-62, Aradjiah/Shadowreign) ---
REPLACE INTO `item_basic` VALUES (30196,0,"Trevor's_Black_Truffle","trevors_black_truffle",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30197,0,"Truffle_Trevor's_Crown","truffle_trevors_crown",1,59476,99,0,25000);
REPLACE INTO `item_basic` VALUES (30198,0,"Trevor's_Tricorne","trevors_tricorne",1,59476,99,0,35000);

REPLACE INTO `item_equipment` VALUES (30197,"truffle_trevors_crown",55,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (30198,"trevors_tricorne",     55,0,4194303,0,0,0,   1,0,0,0); -- HEAD (alt)

REPLACE INTO `item_mods` VALUES (30197, 8,14),(30197, 9,14),(30197, 3,60),(30197,14,25),(30197,15,20),(30197,47,10);  -- INT+14 MND+14 MP+60 MATK+25 MACC+20 Haste+10
REPLACE INTO `item_mods` VALUES (30198, 8,12),(30198, 9,12),(30198,10,10),(30198, 2,80),(30198,14,20),(30198,23,15);  -- INT+12 MND+12 CHR+10 HP+80 MATK+20 MDEF+15

-- =============================================================================
-- GOBLINS (Bargain Bruno, Swindler Sam, Shiny Steve)
-- =============================================================================

-- --- Bargain Bruno (4h timer, lv12-16, midlands) ---
REPLACE INTO `item_basic` VALUES (30220,0,"Bruno's_Empty_Wallet","brunos_empty_wallet",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30221,0,"Bargain_Bruno's_Blade","bargain_brunos_blade",1,59476,99,0,2000);
REPLACE INTO `item_basic` VALUES (30222,0,"Bruno's_Bargain_Bag","brunos_bargain_bag",1,59476,99,0,3000);

REPLACE INTO `item_equipment` VALUES (30221,"bargain_brunos_blade", 12,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (30222,"brunos_bargain_bag",   12,0,4194303,0,0,0, 256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (30221, 4, 5),(30221, 5, 5),(30221,11,12),(30221,12, 8);  -- STR+5 DEX+5 ATT+12 ACC+8
REPLACE INTO `item_mods` VALUES (30222, 2,35),(30222, 4, 5),(30222,11,10),(30222,47, 5);  -- HP+35 STR+5 ATT+10 Haste+5

-- --- Swindler Sam (12h timer, lv30-36, midlands) ---
REPLACE INTO `item_basic` VALUES (30223,0,"Sam's_Stolen_Goods","sams_stolen_goods",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30224,0,"Swindler_Sam's_Shiv","swindler_sams_shiv",1,59476,99,0,7000);
REPLACE INTO `item_basic` VALUES (30225,0,"Sam's_Slippery_Ring","sams_slippery_ring",1,59476,99,0,10000);

REPLACE INTO `item_equipment` VALUES (30224,"swindler_sams_shiv",  30,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (30225,"sams_slippery_ring",  30,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30224, 5,10),(30224,13,15),(30224,12,15),(30224,47, 8);   -- DEX+10 EVA+15 ACC+15 Haste+8
REPLACE INTO `item_mods` VALUES (30225, 5, 8),(30225, 7, 8),(30225,13,12),(30225,12,12);   -- DEX+8 AGI+8 EVA+12 ACC+12

-- --- Shiny Steve (20h timer, lv45-52, midlands/aradjiah) ---
REPLACE INTO `item_basic` VALUES (30226,0,"Steve's_Shiniest_Shiny","steves_shiniest_shiny",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30227,0,"Shiny_Steve's_Spectacles","shiny_steves_spectacles",1,59476,99,0,20000);
REPLACE INTO `item_basic` VALUES (30228,0,"Steve's_Sparkle_Earring","steves_sparkle_earring",1,59476,99,0,28000);

REPLACE INTO `item_equipment` VALUES (30227,"shiny_steves_spectacles",45,0,4194303,0,0,0,  1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (30228,"steves_sparkle_earring", 45,0,4194303,0,0,0,  8,0,0,0); -- EAR

REPLACE INTO `item_mods` VALUES (30227, 5,12),(30227, 7,12),(30227,12,20),(30227,13,20),(30227,47,10);  -- DEX+12 AGI+12 ACC+20 EVA+20 Haste+10
REPLACE INTO `item_mods` VALUES (30228, 5,10),(30228,12,15),(30228,47, 8),(30228, 4, 8);               -- DEX+10 ACC+15 Haste+8 STR+8

-- =============================================================================
-- COEURLS (Whiskers Wilhelmina, Purring Patricia, Nine Lives Nigel)
-- =============================================================================

-- --- Whiskers Wilhelmina (8h timer, lv30-36, midlands) ---
REPLACE INTO `item_basic` VALUES (30250,0,"Wilhelmina's_Whisker","wilhelminas_whisker",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30251,0,"Mina's_Collar","minas_collar",1,59476,99,0,6000);
REPLACE INTO `item_basic` VALUES (30252,0,"Wilhelmina's_Wristlet","wilhelminas_wristlet",1,59476,99,0,9000);

REPLACE INTO `item_equipment` VALUES (30251,"minas_collar",          30,0,4194303,0,0,0,   4,0,0,0); -- NECK
REPLACE INTO `item_equipment` VALUES (30252,"wilhelminas_wristlet",  30,0,4194303,0,0,0,  32,0,0,0); -- HANDS

REPLACE INTO `item_mods` VALUES (30251, 8, 8),(30251, 9, 8),(30251,10, 8),(30251, 2,40);   -- INT+8 MND+8 CHR+8 HP+40
REPLACE INTO `item_mods` VALUES (30252, 4, 8),(30252, 5, 8),(30252,11,16),(30252,12,12);   -- STR+8 DEX+8 ATT+16 ACC+12

-- --- Purring Patricia (14h timer, lv42-48, midlands/elshimo) ---
REPLACE INTO `item_basic` VALUES (30253,0,"Patricia's_Paw","patricias_paw",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30254,0,"Purring_Patricia's_Ring","purring_patricias_ring",1,59476,99,0,14000);
REPLACE INTO `item_basic` VALUES (30255,0,"Patricia's_Pounce_Boots","patricias_pounce_boots",1,59476,99,0,20000);

REPLACE INTO `item_equipment` VALUES (30254,"purring_patricias_ring",42,0,4194303,0,0,0,  64,0,0,0); -- RING
REPLACE INTO `item_equipment` VALUES (30255,"patricias_pounce_boots",42,0,4194303,0,0,0,2048,0,0,0); -- FEET

REPLACE INTO `item_mods` VALUES (30254, 4,10),(30254, 5,10),(30254,11,18),(30254,47, 8),(30254, 2,50);  -- STR+10 DEX+10 ATT+18 Haste+8 HP+50
REPLACE INTO `item_mods` VALUES (30255, 5,12),(30255, 7,12),(30255,13,18),(30255,47,10);                -- DEX+12 AGI+12 EVA+18 Haste+10

-- --- Nine Lives Nigel (22h timer, lv58-65, Aradjiah/Shadowreign) ---
REPLACE INTO `item_basic` VALUES (30256,0,"Nigel's_Ninth_Life","nigels_ninth_life",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30257,0,"Nine_Lives_Nigel's_Necklace","nine_lives_nigels_necklace",1,59476,99,0,30000);
REPLACE INTO `item_basic` VALUES (30258,0,"Nigel's_Nine-Tail_Cape","nigels_nine_tail_cape",1,59476,99,0,42000);

REPLACE INTO `item_equipment` VALUES (30257,"nine_lives_nigels_necklace",58,0,4194303,0,0,0,  4,0,0,0); -- NECK
REPLACE INTO `item_equipment` VALUES (30258,"nigels_nine_tail_cape",     58,0,4194303,0,0,0,256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (30257, 4,14),(30257, 5,14),(30257,11,25),(30257,12,22),(30257,47,12),(30257, 2,80);   -- STR+14 DEX+14 ATT+25 ACC+22 Haste+12 HP+80
REPLACE INTO `item_mods` VALUES (30258, 8,14),(30258, 9,14),(30258, 2,100),(30258,14,25),(30258,47,12),(30258,23,15);  -- INT+14 MND+14 HP+100 MATK+25 Haste+12 MDEF+15

-- =============================================================================
-- TIGERS (Stripey Steve, Mauler Maurice)
-- =============================================================================

-- --- Stripey Steve (6h timer, lv22-28, midlands) ---
REPLACE INTO `item_basic` VALUES (30280,0,"Steve's_Stripe","steves_stripe",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30281,0,"Stripey_Steve's_Cape","stripey_steves_cape",1,59476,99,0,4500);
REPLACE INTO `item_basic` VALUES (30282,0,"Steve's_Fang_Earring","steves_fang_earring",1,59476,99,0,6500);

REPLACE INTO `item_equipment` VALUES (30281,"stripey_steves_cape",  22,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (30282,"steves_fang_earring",  22,0,4194303,0,0,0,   8,0,0,0); -- EAR

REPLACE INTO `item_mods` VALUES (30281, 4, 8),(30281, 6, 6),(30281, 2,50),(30281,11,14);  -- STR+8 VIT+6 HP+50 ATT+14
REPLACE INTO `item_mods` VALUES (30282, 4, 7),(30282,11,14),(30282,12,10),(30282, 2,30);  -- STR+7 ATT+14 ACC+10 HP+30

-- --- Mauler Maurice (16h timer, lv38-46, midlands/aradjiah) ---
REPLACE INTO `item_basic` VALUES (30283,0,"Maurice's_Mauled_Trophy","maurices_mauled_trophy",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30284,0,"Mauler_Maurice's_Mane","mauler_maurices_mane",1,59476,99,0,15000);
REPLACE INTO `item_basic` VALUES (30285,0,"Maurice's_Mauler_Belt","maurices_mauler_belt",1,59476,99,0,22000);

REPLACE INTO `item_equipment` VALUES (30284,"mauler_maurices_mane",  38,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (30285,"maurices_mauler_belt",  38,0,4194303,0,0,0, 512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (30284, 4,12),(30284, 6,10),(30284, 2,80),(30284,11,20),(30284,12,15);  -- STR+12 VIT+10 HP+80 ATT+20 ACC+15
REPLACE INTO `item_mods` VALUES (30285, 4,12),(30285, 6,12),(30285,11,22),(30285,47, 8),(30285, 2,60);  -- STR+12 VIT+12 ATT+22 Haste+8 HP+60

-- =============================================================================
-- MANDRAGORAS (Root Rita, Sprout Spencer, Mandrake Max)
-- =============================================================================

-- --- Root Rita (3h timer, lv6-10, Ronfaure/Sarutabaruta) ---
REPLACE INTO `item_basic` VALUES (30310,0,"Rita's_Root","ritas_root",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30311,0,"Rita's_Ribbon","ritas_ribbon",1,59476,99,0,600);
REPLACE INTO `item_basic` VALUES (30312,0,"Rita's_Ring","ritas_ring",1,59476,99,0,900);

REPLACE INTO `item_equipment` VALUES (30311,"ritas_ribbon",   6,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (30312,"ritas_ring",     6,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30311, 9, 4),(30311,10, 4),(30311, 3,20);  -- MND+4 CHR+4 MP+20
REPLACE INTO `item_mods` VALUES (30312, 8, 3),(30312, 9, 3),(30312, 3,15);  -- INT+3 MND+3 MP+15

-- --- Sprout Spencer (10h timer, lv22-28, midlands) ---
REPLACE INTO `item_basic` VALUES (30313,0,"Spencer's_Sprout","spencers_sprout",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30314,0,"Spencer's_Leaf_Cloak","spencers_leaf_cloak",1,59476,99,0,5000);
REPLACE INTO `item_basic` VALUES (30315,0,"Spencer's_Seedling_Crown","spencers_seedling_crown",1,59476,99,0,7500);

REPLACE INTO `item_equipment` VALUES (30314,"spencers_leaf_cloak",   22,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (30315,"spencers_seedling_crown",22,0,4194303,0,0,0,  1,0,0,0); -- HEAD

REPLACE INTO `item_mods` VALUES (30314, 8, 7),(30314, 9, 7),(30314, 3,40),(30314,14,12);  -- INT+7 MND+7 MP+40 MATK+12
REPLACE INTO `item_mods` VALUES (30315, 8, 8),(30315, 9, 8),(30315,10, 6),(30315, 3,50);  -- INT+8 MND+8 CHR+6 MP+50

-- --- Mandrake Max (18h timer, lv40-48, midlands/aradjiah) ---
REPLACE INTO `item_basic` VALUES (30316,0,"Max's_Master_Root","maxs_master_root",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30317,0,"Mandrake_Max's_Crown","mandrake_maxs_crown",1,59476,99,0,16000);
REPLACE INTO `item_basic` VALUES (30318,0,"Max's_Mystic_Mittens","maxs_mystic_mittens",1,59476,99,0,22000);

REPLACE INTO `item_equipment` VALUES (30317,"mandrake_maxs_crown",  40,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (30318,"maxs_mystic_mittens",  40,0,4194303,0,0,0,  32,0,0,0); -- HANDS

REPLACE INTO `item_mods` VALUES (30317, 8,12),(30317, 9,12),(30317, 3,70),(30317,14,22),(30317,15,18);  -- INT+12 MND+12 MP+70 MATK+22 MACC+18
REPLACE INTO `item_mods` VALUES (30318, 8,10),(30318, 9,10),(30318,14,18),(30318,15,15),(30318,47, 8);   -- INT+10 MND+10 MATK+18 MACC+15 Haste+8

-- =============================================================================
-- BEETLES (Click Clack Clayton, Dung Douglas, Scarab Sebastian)
-- =============================================================================

-- --- Click Clack Clayton (4h timer, lv10-15, gustaberg/midlands) ---
REPLACE INTO `item_basic` VALUES (30340,0,"Clayton's_Click_Clacker","claytons_click_clacker",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30341,0,"Click_Clack_Carapace","click_clack_carapace",1,59476,99,0,1800);
REPLACE INTO `item_basic` VALUES (30342,0,"Clayton's_Chitin_Ring","claytons_chitin_ring",1,59476,99,0,2500);

REPLACE INTO `item_equipment` VALUES (30341,"click_clack_carapace",10,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (30342,"claytons_chitin_ring",10,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30341, 1,10),(30341, 6, 5),(30341, 2,30);  -- DEF+10 VIT+5 HP+30
REPLACE INTO `item_mods` VALUES (30342, 1, 6),(30342, 6, 4),(30342, 2,25);  -- DEF+6 VIT+4 HP+25

-- --- Dung Douglas (12h timer, lv28-34, midlands) ---
REPLACE INTO `item_basic` VALUES (30343,0,"Douglas's_Dung_Ball","douglass_dung_ball",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30344,0,"Dung_Douglas's_Shield","dung_douglass_shield",1,59476,99,0,8000);
REPLACE INTO `item_basic` VALUES (30345,0,"Douglas's_Durable_Belt","douglass_durable_belt",1,59476,99,0,11000);

REPLACE INTO `item_equipment` VALUES (30344,"dung_douglass_shield",28,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (30345,"douglass_durable_belt",28,0,4194303,0,0,0,256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (30344, 1,16),(30344, 6,10),(30344, 2,60),(30344,47, 6);  -- DEF+16 VIT+10 HP+60 Haste+6
REPLACE INTO `item_mods` VALUES (30345, 1,14),(30345, 6, 8),(30345, 2,70),(30345, 4, 6);  -- DEF+14 VIT+8 HP+70 STR+6

-- --- Scarab Sebastian (20h timer, lv45-52, aradjiah) ---
REPLACE INTO `item_basic` VALUES (30346,0,"Sebastian's_Sacred_Scarab","sebastians_sacred_scarab",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30347,0,"Scarab_Sebastian's_Ring","scarab_sebastians_ring",1,59476,99,0,22000);
REPLACE INTO `item_basic` VALUES (30348,0,"Sebastian's_Shell_Crown","sebastians_shell_crown",1,59476,99,0,30000);

REPLACE INTO `item_equipment` VALUES (30347,"scarab_sebastians_ring",45,0,4194303,0,0,0,  64,0,0,0); -- RING
REPLACE INTO `item_equipment` VALUES (30348,"sebastians_shell_crown",45,0,4194303,0,0,0,   1,0,0,0); -- HEAD

REPLACE INTO `item_mods` VALUES (30347, 4,12),(30347, 6,12),(30347, 2,80),(30347,11,20),(30347,47,10);  -- STR+12 VIT+12 HP+80 ATT+20 Haste+10
REPLACE INTO `item_mods` VALUES (30348, 1,18),(30348, 6,14),(30348, 2,100),(30348,11,18),(30348,47,10); -- DEF+18 VIT+14 HP+100 ATT+18 Haste+10

-- =============================================================================
-- CRAWLERS (Silk Simon, Cocoon Carl)
-- =============================================================================

-- --- Silk Simon (6h timer, lv15-20, midlands) ---
REPLACE INTO `item_basic` VALUES (30370,0,"Simon's_Silk_Skein","simons_silk_skein",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30371,0,"Silk_Simon's_Sash","silk_simons_sash",1,59476,99,0,3000);
REPLACE INTO `item_basic` VALUES (30372,0,"Simon's_Spinneret_Ring","simons_spinneret_ring",1,59476,99,0,4500);

REPLACE INTO `item_equipment` VALUES (30371,"silk_simons_sash",     15,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (30372,"simons_spinneret_ring",15,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30371, 9, 5),(30371, 3,25),(30371,47, 5),(30371, 2,30);  -- MND+5 MP+25 Haste+5 HP+30
REPLACE INTO `item_mods` VALUES (30372, 8, 4),(30372, 9, 4),(30372, 3,20),(30372,14, 8);  -- INT+4 MND+4 MP+20 MATK+8

-- --- Cocoon Carl (20h timer, lv50-58, aradjiah/shadowreign) ---
REPLACE INTO `item_basic` VALUES (30373,0,"Carl's_Perfect_Cocoon","carls_perfect_cocoon",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30374,0,"Cocoon_Carl's_Crown","cocoon_carls_crown",1,59476,99,0,24000);
REPLACE INTO `item_basic` VALUES (30375,0,"Carl's_Chrysalis_Cape","carls_chrysalis_cape",1,59476,99,0,32000);

REPLACE INTO `item_equipment` VALUES (30374,"cocoon_carls_crown",   50,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (30375,"carls_chrysalis_cape", 50,0,4194303,0,0,0, 256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (30374, 8,12),(30374, 9,12),(30374, 3,80),(30374,14,22),(30374,15,18),(30374,47,10);  -- INT+12 MND+12 MP+80 MATK+22 MACC+18 Haste+10
REPLACE INTO `item_mods` VALUES (30375, 1,16),(30375, 6,12),(30375, 2,100),(30375,47,12),(30375,11,20);               -- DEF+16 VIT+12 HP+100 Haste+12 ATT+20

-- =============================================================================
-- BIRDS (Feather Fred, Beaky Beatrice, Plume Patricia)
-- =============================================================================

-- --- Feather Fred (4h timer, lv10-15, midlands) ---
REPLACE INTO `item_basic` VALUES (30400,0,"Fred's_Finest_Feather","freds_finest_feather",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30401,0,"Feather_Fred's_Cap","feather_freds_cap",1,59476,99,0,2000);
REPLACE INTO `item_basic` VALUES (30402,0,"Fred's_Flightless_Ring","freds_flightless_ring",1,59476,99,0,3000);

REPLACE INTO `item_equipment` VALUES (30401,"feather_freds_cap",      10,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (30402,"freds_flightless_ring",  10,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30401, 7, 5),(30401, 5, 5),(30401,13,10),(30401, 2,25);  -- AGI+5 DEX+5 EVA+10 HP+25
REPLACE INTO `item_mods` VALUES (30402, 7, 4),(30402,13, 8),(30402,12, 6);               -- AGI+4 EVA+8 ACC+6

-- --- Beaky Beatrice (12h timer, lv28-35, midlands/elshimo) ---
REPLACE INTO `item_basic` VALUES (30403,0,"Beatrice's_Beak","beatrices_beak",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30404,0,"Beaky_Beatrice's_Bonnet","beaky_beatrices_bonnet",1,59476,99,0,8000);
REPLACE INTO `item_basic` VALUES (30405,0,"Beatrice's_Talon_Ring","beatrices_talon_ring",1,59476,99,0,11000);

REPLACE INTO `item_equipment` VALUES (30404,"beaky_beatrices_bonnet",28,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (30405,"beatrices_talon_ring",  28,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30404, 7,10),(30404, 5,10),(30404,13,15),(30404,12,12);  -- AGI+10 DEX+10 EVA+15 ACC+12
REPLACE INTO `item_mods` VALUES (30405, 4, 8),(30405, 7, 8),(30405,11,16),(30405,12,12);  -- STR+8 AGI+8 ATT+16 ACC+12

-- --- Plume Patricia (20h timer, lv50-58, aradjiah) ---
REPLACE INTO `item_basic` VALUES (30406,0,"Patricia's_Prize_Plumage","patricias_prize_plumage",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30407,0,"Plume_Patricia's_Cape","plume_patricias_cape",1,59476,99,0,25000);
REPLACE INTO `item_basic` VALUES (30408,0,"Patricia's_Pinion_Earring","patricias_pinion_earring",1,59476,99,0,35000);

REPLACE INTO `item_equipment` VALUES (30407,"plume_patricias_cape",   50,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (30408,"patricias_pinion_earring",50,0,4194303,0,0,0,  8,0,0,0); -- EAR

REPLACE INTO `item_mods` VALUES (30407, 4,14),(30407, 7,14),(30407, 2,100),(30407,11,22),(30407,47,12);  -- STR+14 AGI+14 HP+100 ATT+22 Haste+12
REPLACE INTO `item_mods` VALUES (30408, 5,12),(30408, 7,12),(30408,13,20),(30408,12,18),(30408,47,10);   -- DEX+12 AGI+12 EVA+20 ACC+18 Haste+10

-- =============================================================================
-- BEES (Honey Harold, Buzzard Barry, Queen Quentin)
-- =============================================================================

-- --- Honey Harold (4h timer, lv10-15, ronfaure/sarutabaruta) ---
REPLACE INTO `item_basic` VALUES (30430,0,"Harold's_Honeycomb","harolds_honeycomb",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30431,0,"Honey_Harold's_Stinger","honey_harolds_stinger",1,59476,99,0,2000);
REPLACE INTO `item_basic` VALUES (30432,0,"Harold's_Hex_Ring","harolds_hex_ring",1,59476,99,0,3000);

REPLACE INTO `item_equipment` VALUES (30431,"honey_harolds_stinger",10,0,4194303,0,0,0,   4,0,0,0); -- NECK
REPLACE INTO `item_equipment` VALUES (30432,"harolds_hex_ring",     10,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30431, 4, 5),(30431,11,10),(30431, 5, 4),(30431, 2,25);  -- STR+5 ATT+10 DEX+4 HP+25
REPLACE INTO `item_mods` VALUES (30432, 8, 5),(30432, 9, 5),(30432,14,10),(30432, 3,20);  -- INT+5 MND+5 MATK+10 MP+20

-- --- Buzzard Barry (14h timer, lv30-38, midlands) ---
REPLACE INTO `item_basic` VALUES (30433,0,"Barry's_Big_Stinger","barrys_big_stinger",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30434,0,"Buzzard_Barry's_Belt","buzzard_barrys_belt",1,59476,99,0,10000);
REPLACE INTO `item_basic` VALUES (30435,0,"Barry's_Buzzing_Earring","barrys_buzzing_earring",1,59476,99,0,14000);

REPLACE INTO `item_equipment` VALUES (30434,"buzzard_barrys_belt",  30,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (30435,"barrys_buzzing_earring",30,0,4194303,0,0,0,  8,0,0,0); -- EAR

REPLACE INTO `item_mods` VALUES (30434, 4,10),(30434, 5, 8),(30434,11,18),(30434,12,14),(30434,47, 6);  -- STR+10 DEX+8 ATT+18 ACC+14 Haste+6
REPLACE INTO `item_mods` VALUES (30435, 4, 8),(30435,11,14),(30435,47, 8),(30435, 2,40);               -- STR+8 ATT+14 Haste+8 HP+40

-- --- Queen Quentin (24h timer, lv62-70, aradjiah/shadowreign) ---
REPLACE INTO `item_basic` VALUES (30436,0,"Quentin's_Royal_Jelly","quentins_royal_jelly",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30437,0,"Queen_Quentin's_Crown","queen_quentins_crown",1,59476,99,0,50000);
REPLACE INTO `item_basic` VALUES (30438,0,"Quentin's_Stinger_Ring","quentins_stinger_ring",1,59476,99,0,70000);

REPLACE INTO `item_equipment` VALUES (30437,"queen_quentins_crown",  62,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (30438,"quentins_stinger_ring", 62,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30437, 4,16),(30437, 5,16),(30437, 2,120),(30437,11,28),(30437,12,24),(30437,47,14);  -- STR+16 DEX+16 HP+120 ATT+28 ACC+24 Haste+14
REPLACE INTO `item_mods` VALUES (30438, 8,16),(30438, 9,16),(30438, 3,100),(30438,14,30),(30438,15,25),(30438,47,14);  -- INT+16 MND+16 MP+100 MATK+30 MACC+25 Haste+14

-- =============================================================================
-- WORMS (Wiggles Winston, Squirmy Sherman)
-- =============================================================================

-- --- Wiggles Winston (2h timer, lv1-5, ronfaure/sarutabaruta/gustaberg) ---
REPLACE INTO `item_basic` VALUES (30460,0,"Winston's_Worm","winstons_worm",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30461,0,"Wiggles_Winston's_Band","wiggles_winstons_band",1,59476,99,0,200);
REPLACE INTO `item_basic` VALUES (30462,0,"Winston's_Wriggly_Ring","winstons_wriggly_ring",1,59476,99,0,350);

REPLACE INTO `item_equipment` VALUES (30461,"wiggles_winstons_band",  1,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (30462,"winstons_wriggly_ring",  1,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30461, 2,15),(30461, 6, 2),(30461, 1, 3);  -- HP+15 VIT+2 DEF+3
REPLACE INTO `item_mods` VALUES (30462, 2,10),(30462, 3, 8),(30462, 9, 2);  -- HP+10 MP+8 MND+2

-- --- Squirmy Sherman (8h timer, lv18-24, midlands) ---
REPLACE INTO `item_basic` VALUES (30463,0,"Sherman's_Squirm","shermans_squirm",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30464,0,"Squirmy_Sherman's_Coil","squirmy_shermans_coil",1,59476,99,0,4000);
REPLACE INTO `item_basic` VALUES (30465,0,"Sherman's_Sinuous_Sash","shermans_sinuous_sash",1,59476,99,0,6000);

REPLACE INTO `item_equipment` VALUES (30464,"squirmy_shermans_coil",18,0,4194303,0,0,0,  64,0,0,0); -- RING
REPLACE INTO `item_equipment` VALUES (30465,"shermans_sinuous_sash",18,0,4194303,0,0,0, 512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (30464, 2,40),(30464, 6, 6),(30464, 1, 8),(30464,47, 5);  -- HP+40 VIT+6 DEF+8 Haste+5
REPLACE INTO `item_mods` VALUES (30465, 4, 6),(30465, 6, 6),(30465, 2,40),(30465,11,12);  -- STR+6 VIT+6 HP+40 ATT+12

-- =============================================================================
-- THE JIMS  (Little Jim = giant, Big Jim = tiny — find goblin groupRefs first)
-- =============================================================================

-- --- Little Jim (10h timer, lv25-32, midlands) — uses a LARGE goblin model ---
REPLACE INTO `item_basic` VALUES (30520,0,"Little_Jim's_Big_Trophy","little_jims_big_trophy",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30521,0,"Little_Jim's_Big_Boots","little_jims_big_boots",1,59476,99,0,6000);
REPLACE INTO `item_basic` VALUES (30522,0,"Little_Jim's_Big_Ring","little_jims_big_ring",1,59476,99,0,9000);

REPLACE INTO `item_equipment` VALUES (30521,"little_jims_big_boots",  25,0,4194303,0,0,0,2048,0,0,0); -- FEET
REPLACE INTO `item_equipment` VALUES (30522,"little_jims_big_ring",   25,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30521, 6,10),(30521, 1,14),(30521, 2,60),(30521,47, 8);   -- VIT+10 DEF+14 HP+60 Haste+8
REPLACE INTO `item_mods` VALUES (30522, 4,10),(30522, 6, 8),(30522,11,18),(30522, 2,50);   -- STR+10 VIT+8 ATT+18 HP+50

-- --- Big Jim (10h timer, lv25-32, midlands) — uses a SMALL goblin model ---
REPLACE INTO `item_basic` VALUES (30523,0,"Big_Jim's_Small_Trophy","big_jims_small_trophy",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (30524,0,"Big_Jim's_Small_Hat","big_jims_small_hat",1,59476,99,0,6000);
REPLACE INTO `item_basic` VALUES (30525,0,"Big_Jim's_Small_Ring","big_jims_small_ring",1,59476,99,0,9000);

REPLACE INTO `item_equipment` VALUES (30524,"big_jims_small_hat",     25,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (30525,"big_jims_small_ring",    25,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (30524, 5,10),(30524, 7,10),(30524,12,16),(30524,13,14),(30524,47, 8); -- DEX+10 AGI+10 ACC+16 EVA+14 Haste+8
REPLACE INTO `item_mods` VALUES (30525, 5, 8),(30525, 4, 8),(30525,11,16),(30525,12,14),(30525, 2,50); -- DEX+8 STR+8 ATT+16 ACC+14 HP+50

-- =============================================================================
-- VERIFY (run manually after applying)
-- =============================================================================
-- SELECT i.itemid, i.name, e.level, e.slot, e.jobs
--   FROM item_basic i
--   LEFT JOIN item_equipment e ON i.itemid = e.itemId
--  WHERE i.itemid BETWEEN 30100 AND 30519
--  ORDER BY i.itemid;
