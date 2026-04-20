-- =============================================================================
-- NAMED RARE MOB ITEMS
-- =============================================================================
-- ID ranges by mob type:
--   6-30129  Sheep
--   97-30159  Rabbits
--   165-30189  Crabs
--   177-30219  Fungars
--   186-30249  Goblins
--   202-30279  Coeurls
--   253-30309  Tigers
--   259-30339  Mandragoras
--   268-30369  Beetles
--   287-30399  Crawlers
--   318-30429  Birds
--   327-30459  Bees
--   4133-30489  Worms
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

USE aoniaxi;

-- =============================================================================
-- SHEEP  (Wooly William, Baa-rbara, Lambchop Larry, Shear Sharon)
-- =============================================================================

-- --- Wooly William (2h timer, lv6-8, Ronfaure) ---
REPLACE INTO `item_basic` VALUES (6,0,"William's_Wool","williams_wool",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (20,0,"William's_Woolcap","williams_woolcap",1,59476,99,0,400);
REPLACE INTO `item_basic` VALUES (79,0,"William's_Woolmitt","williams_woolmitt",1,59476,99,0,600);

REPLACE INTO `item_equipment` VALUES (20,"williams_woolcap",    5,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (79,"williams_woolmitt",   5,0,4194303,0,0,0,  32,0,0,0); -- HANDS

REPLACE INTO `item_mods` VALUES (20, 2, 20),(20, 9, 3),(20,10, 3);  -- HP+20 MND+3 CHR+3
REPLACE INTO `item_mods` VALUES (79, 1,  6),(79, 6, 3),(79, 2,15);  -- DEF+6 VIT+3 HP+15

-- --- Baa-rbara (4h timer, lv10-13, Ronfaure) ---
REPLACE INTO `item_basic` VALUES (80,0,"Baa-rbara's_Bell","baarbara_bell",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (81,0,"Baa-rbara's_Collar","baarbara_collar",1,59476,99,0,800);
REPLACE INTO `item_basic` VALUES (83,0,"Baa-rbara's_Ribbon","baarbara_ribbon",1,59476,99,0,1200);

REPLACE INTO `item_equipment` VALUES (81,"baarbara_collar",    10,0,4194303,0,0,0,   4,0,0,0); -- NECK
REPLACE INTO `item_equipment` VALUES (83,"baarbara_ribbon",    10,0,4194303,0,0,0, 512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (81, 9, 4),(81,10, 4),(81, 2,20);  -- MND+4 CHR+4 HP+20
REPLACE INTO `item_mods` VALUES (83, 9, 3),(83, 3,10),(83,47, 3);  -- MND+3 MP+10 Haste+3

-- --- Lambchop Larry (8h timer, lv20-24, Ronfaure/Midlands) ---
REPLACE INTO `item_basic` VALUES (84,0,"Larry's_Lambchop","larrys_lambchop",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (85,0,"Larry's_Lucky_Fleece","larrys_lucky_fleece",1,59476,99,0,3000);
REPLACE INTO `item_basic` VALUES (86,0,"Larry's_Lanyard","larrys_lanyard",1,59476,99,0,4500);

REPLACE INTO `item_equipment` VALUES (85,"larrys_lucky_fleece", 20,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (86,"larrys_lanyard",      20,0,4194303,0,0,0,   4,0,0,0); -- NECK

REPLACE INTO `item_mods` VALUES (85, 1, 8),(85, 6, 5),(85, 2,40),(85,11,10);  -- DEF+8 VIT+5 HP+40 ATT+10
REPLACE INTO `item_mods` VALUES (86, 2,30),(86, 9, 6),(86,10, 6),(86,47, 5);  -- HP+30 MND+6 CHR+6 Haste+5

-- --- Shear Sharon (16h timer, lv35-40, Midlands) ---
REPLACE INTO `item_basic` VALUES (89,0,"Sharon's_Golden_Fleece","sharons_golden_fleece",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (90,0,"Sharon's_Shearing_Shears","sharons_shearing_shears",1,59476,99,0,8000);
REPLACE INTO `item_basic` VALUES (94,0,"Sharon's_Silken_Mantle","sharons_silken_mantle",1,59476,99,0,12000);

REPLACE INTO `item_equipment` VALUES (90,"sharons_shearing_shears",35,0,4194303,0,0,0,  32,0,0,0); -- HANDS
REPLACE INTO `item_equipment` VALUES (94,"sharons_silken_mantle",  35,0,4194303,0,0,0, 256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (90, 4, 8),(90, 5, 8),(90,12,12),(90,11,12);  -- STR+8 DEX+8 ACC+12 ATT+12
REPLACE INTO `item_mods` VALUES (94, 1,12),(94, 6,10),(94, 2,60),(94,47, 8);  -- DEF+12 VIT+10 HP+60 Haste+8

-- =============================================================================
-- RABBITS (Cottontail Tommy, Hopscotch Harvey, Bun-bun Benedict, Twitchy Theodore)
-- =============================================================================

-- --- Cottontail Tommy (2h timer, lv5-7, Ronfaure/Sarutabaruta) ---
REPLACE INTO `item_basic` VALUES (97,0,"Tommy's_Cotton_Tail","tommys_cotton_tail",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (145,0,"Tommy's_Thumper_Ring","tommys_thumper_ring",1,59476,99,0,500);
REPLACE INTO `item_basic` VALUES (150,0,"Cottontail_Cloak","cottontail_cloak",1,59476,99,0,700);

REPLACE INTO `item_equipment` VALUES (145,"tommys_thumper_ring",  5,0,4194303,0,0,0,  64,0,0,0); -- RING1
REPLACE INTO `item_equipment` VALUES (150,"cottontail_cloak",     5,0,4194303,0,0,0, 256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (145, 5, 3),(145, 7, 3),(145,13, 5);  -- DEX+3 AGI+3 EVA+5
REPLACE INTO `item_mods` VALUES (150, 7, 4),(150,13, 6),(150, 2,20);  -- AGI+4 EVA+6 HP+20

-- --- Hopscotch Harvey (5h timer, lv10-13, Ronfaure/Sarutabaruta) ---
REPLACE INTO `item_basic` VALUES (153,0,"Harvey's_Lucky_Foot","harveys_lucky_foot",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (155,0,"Harvey's_Hoppers","harveys_hoppers",1,59476,99,0,1500);
REPLACE INTO `item_basic` VALUES (156,0,"Harvey's_Headband","harveys_headband",1,59476,99,0,2000);

REPLACE INTO `item_equipment` VALUES (155,"harveys_hoppers",     10,0,4194303,0,0,0,2048,0,0,0); -- FEET
REPLACE INTO `item_equipment` VALUES (156,"harveys_headband",    10,0,4194303,0,0,0,   1,0,0,0); -- HEAD

REPLACE INTO `item_mods` VALUES (155, 7, 5),(155,13, 8),(155, 5, 3);  -- AGI+5 EVA+8 DEX+3
REPLACE INTO `item_mods` VALUES (156, 5, 5),(156, 7, 5),(156, 2,25);  -- DEX+5 AGI+5 HP+25

-- --- Bun-bun Benedict (10h timer, lv22-28, Midlands) ---
REPLACE INTO `item_basic` VALUES (158,0,"Benedict's_Bonnet","benedicts_bonnet",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (159,0,"Bun-bun_Bangle","bunbun_bangle",1,59476,99,0,4000);
REPLACE INTO `item_basic` VALUES (160,0,"Benedict's_Battle_Wrap","benedicts_battle_wrap",1,59476,99,0,6000);

REPLACE INTO `item_equipment` VALUES (159,"bunbun_bangle",       22,0,4194303,0,0,0,  32,0,0,0); -- HANDS
REPLACE INTO `item_equipment` VALUES (160,"benedicts_battle_wrap",22,0,4194303,0,0,0, 512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (159, 5, 7),(159,13,10),(159,12, 8);  -- DEX+7 EVA+10 ACC+8
REPLACE INTO `item_mods` VALUES (160, 7, 8),(160, 4, 6),(160,11,12);  -- AGI+8 STR+6 ATT+12

-- --- Twitchy Theodore (18h timer, lv38-45, Midlands/Elshimo) ---
REPLACE INTO `item_basic` VALUES (161,0,"Theodore's_Twitching_Ear","theodores_twitching_ear",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (162,0,"Theodore's_Earring","theodores_earring",1,59476,99,0,9000);
REPLACE INTO `item_basic` VALUES (163,0,"Twitchy_Talisman","twitchy_talisman",1,59476,99,0,14000);

REPLACE INTO `item_equipment` VALUES (162,"theodores_earring",   38,0,4194303,0,0,0,   8,0,0,0); -- EAR
REPLACE INTO `item_equipment` VALUES (163,"twitchy_talisman",    38,0,4194303,0,0,0,   4,0,0,0); -- NECK

REPLACE INTO `item_mods` VALUES (162, 7,10),(162,13,15),(162, 5, 8),(162,47, 5);  -- AGI+10 EVA+15 DEX+8 Haste+5
REPLACE INTO `item_mods` VALUES (163, 7,10),(163, 5,10),(163,12,15),(163,11,15);  -- AGI+10 DEX+10 ACC+15 ATT+15

-- =============================================================================
-- CRABS (Crab Leg Cameron, Old Bay Ollie, Bisque Bernard, Dungeness Duncan)
-- =============================================================================

-- --- Crab Leg Cameron (4h timer, lv12-16, coastal) ---
REPLACE INTO `item_basic` VALUES (165,0,"Cameron's_Claw","camerons_claw",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (166,0,"Crab_Leg_Ring","crab_leg_ring",1,59476,99,0,1500);
REPLACE INTO `item_basic` VALUES (167,0,"Cameron's_Carapace_Belt","camerons_carapace_belt",1,59476,99,0,2500);

REPLACE INTO `item_equipment` VALUES (166,"crab_leg_ring",       12,0,4194303,0,0,0,  64,0,0,0); -- RING
REPLACE INTO `item_equipment` VALUES (167,"camerons_carapace_belt",12,0,4194303,0,0,0,512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (166, 4, 5),(166,11,10),(166, 1, 4);  -- STR+5 ATT+10 DEF+4
REPLACE INTO `item_mods` VALUES (167, 1,10),(167, 6, 6),(167, 2,30);  -- DEF+10 VIT+6 HP+30

-- --- Old Bay Ollie (8h timer, lv25-30, coastal/midlands) ---
REPLACE INTO `item_basic` VALUES (168,0,"Ollie's_Old_Bay_Shell","ollies_old_bay_shell",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (169,0,"Old_Bay_Buckler","old_bay_buckler",1,59476,99,0,5000);
REPLACE INTO `item_basic` VALUES (170,0,"Ollie's_Oven_Mitts","ollies_oven_mitts",1,59476,99,0,7000);

REPLACE INTO `item_equipment` VALUES (169,"old_bay_buckler",     25,0,4194303,0,0,0,   2,0,0,0); -- NECK
REPLACE INTO `item_equipment` VALUES (170,"ollies_oven_mitts",   25,0,4194303,0,0,0,  32,0,0,0); -- HANDS

REPLACE INTO `item_mods` VALUES (169, 1,12),(169, 2,50),(169, 6, 8);  -- DEF+12 HP+50 VIT+8
REPLACE INTO `item_mods` VALUES (170, 1,10),(170, 4, 8),(170,11,14);  -- DEF+10 STR+8 ATT+14

-- --- Bisque Bernard (14h timer, lv35-42, midlands) ---
REPLACE INTO `item_basic` VALUES (171,0,"Bernard's_Bisque_Bowl","bernards_bisque_bowl",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (172,0,"Bisque_Bernard's_Shell","bisque_bernards_shell",1,59476,99,0,8000);
REPLACE INTO `item_basic` VALUES (173,0,"Bernard's_Briny_Ring","bernards_briny_ring",1,59476,99,0,11000);

REPLACE INTO `item_equipment` VALUES (172,"bisque_bernards_shell",35,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (173,"bernards_briny_ring",  35,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (172, 1,16),(172, 6,10),(172, 2,70),(172,47, 6);  -- DEF+16 VIT+10 HP+70 Haste+6
REPLACE INTO `item_mods` VALUES (173, 4, 8),(173, 6, 8),(173,11,18),(173,12,12);  -- STR+8 VIT+8 ATT+18 ACC+12

-- --- Dungeness Duncan (20h timer, lv45-52, Elshimo/Aradjiah) ---
REPLACE INTO `item_basic` VALUES (174,0,"Duncan's_Dreadnought_Claw","duncans_dreadnought_claw",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (175,0,"Dungeness_Duncan's_Ring","dungeness_duncans_ring",1,59476,99,0,18000);
REPLACE INTO `item_basic` VALUES (176,0,"Duncan's_Domain_Belt","duncans_domain_belt",1,59476,99,0,25000);

REPLACE INTO `item_equipment` VALUES (175,"dungeness_duncans_ring",45,0,4194303,0,0,0, 64,0,0,0); -- RING
REPLACE INTO `item_equipment` VALUES (176,"duncans_domain_belt",   45,0,4194303,0,0,0,512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (175, 4,12),(175, 6,10),(175,11,20),(175,12,18),(175,47, 8);  -- STR+12 VIT+10 ATT+20 ACC+18 Haste+8
REPLACE INTO `item_mods` VALUES (176, 1,20),(176, 6,14),(176, 2,100),(176,47,10);               -- DEF+20 VIT+14 HP+100 Haste+10

-- =============================================================================
-- FUNGARS (Cap'n Chanterelle, Portobello Pete, Truffle Trevor)
-- (Mushroom Morris is in custom_items.sql at 30000)
-- =============================================================================

-- --- Cap'n Chanterelle (6h timer, lv18-22, Midlands) ---
REPLACE INTO `item_basic` VALUES (177,0,"Chanterelle's_Cap","chanterelles_cap",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (178,0,"Cap'n_Chanterelle's_Hat","capn_chanterelles_hat",1,59476,99,0,3500);
REPLACE INTO `item_basic` VALUES (179,0,"Chanterelle_Choker","chanterelle_choker",1,59476,99,0,5000);

REPLACE INTO `item_equipment` VALUES (178,"capn_chanterelles_hat",18,0,4194303,0,0,0,  1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (179,"chanterelle_choker",   18,0,4194303,0,0,0,  4,0,0,0); -- NECK

REPLACE INTO `item_mods` VALUES (178, 8, 6),(178, 9, 6),(178, 3,30),(178,14,10);  -- INT+6 MND+6 MP+30 MATK+10
REPLACE INTO `item_mods` VALUES (179, 8, 5),(179, 9, 5),(179, 2,30),(179,15, 8);  -- INT+5 MND+5 HP+30 MACC+8

-- --- Portobello Pete (14h timer, lv35-40, Midlands/Aradjiah) ---
REPLACE INTO `item_basic` VALUES (180,0,"Pete's_Portobello","petes_portobello",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (181,0,"Portobello_Pete's_Parasol","portobello_petes_parasol",1,59476,99,0,10000);
REPLACE INTO `item_basic` VALUES (182,0,"Pete's_Spore_Ring","petes_spore_ring",1,59476,99,0,14000);

REPLACE INTO `item_equipment` VALUES (181,"portobello_petes_parasol",35,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (182,"petes_spore_ring",        35,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (181, 1,12),(181, 8, 8),(181, 9, 8),(181,14,15),(181,15,12);  -- DEF+12 INT+8 MND+8 MATK+15 MACC+12
REPLACE INTO `item_mods` VALUES (182, 8,10),(182, 9,10),(182,14,20),(182,23,10);                 -- INT+10 MND+10 MATK+20 MDEF+10

-- --- Truffle Trevor (22h timer, lv55-62, Aradjiah/Shadowreign) ---
REPLACE INTO `item_basic` VALUES (183,0,"Trevor's_Black_Truffle","trevors_black_truffle",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (184,0,"Truffle_Trevor's_Crown","truffle_trevors_crown",1,59476,99,0,25000);
REPLACE INTO `item_basic` VALUES (185,0,"Trevor's_Tricorne","trevors_tricorne",1,59476,99,0,35000);

REPLACE INTO `item_equipment` VALUES (184,"truffle_trevors_crown",55,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (185,"trevors_tricorne",     55,0,4194303,0,0,0,   1,0,0,0); -- HEAD (alt)

REPLACE INTO `item_mods` VALUES (184, 8,14),(184, 9,14),(184, 3,60),(184,14,25),(184,15,20),(184,47,10);  -- INT+14 MND+14 MP+60 MATK+25 MACC+20 Haste+10
REPLACE INTO `item_mods` VALUES (185, 8,12),(185, 9,12),(185,10,10),(185, 2,80),(185,14,20),(185,23,15);  -- INT+12 MND+12 CHR+10 HP+80 MATK+20 MDEF+15

-- =============================================================================
-- GOBLINS (Bargain Bruno, Swindler Sam, Shiny Steve)
-- =============================================================================

-- --- Bargain Bruno (4h timer, lv12-16, midlands) ---
REPLACE INTO `item_basic` VALUES (186,0,"Bruno's_Empty_Wallet","brunos_empty_wallet",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (187,0,"Bargain_Bruno's_Blade","bargain_brunos_blade",1,59476,99,0,2000);
REPLACE INTO `item_basic` VALUES (188,0,"Bruno's_Bargain_Bag","brunos_bargain_bag",1,59476,99,0,3000);

REPLACE INTO `item_equipment` VALUES (187,"bargain_brunos_blade", 12,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (188,"brunos_bargain_bag",   12,0,4194303,0,0,0, 256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (187, 4, 5),(187, 5, 5),(187,11,12),(187,12, 8);  -- STR+5 DEX+5 ATT+12 ACC+8
REPLACE INTO `item_mods` VALUES (188, 2,35),(188, 4, 5),(188,11,10),(188,47, 5);  -- HP+35 STR+5 ATT+10 Haste+5

-- --- Swindler Sam (12h timer, lv30-36, midlands) ---
REPLACE INTO `item_basic` VALUES (189,0,"Sam's_Stolen_Goods","sams_stolen_goods",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (190,0,"Swindler_Sam's_Shiv","swindler_sams_shiv",1,59476,99,0,7000);
REPLACE INTO `item_basic` VALUES (191,0,"Sam's_Slippery_Ring","sams_slippery_ring",1,59476,99,0,10000);

REPLACE INTO `item_equipment` VALUES (190,"swindler_sams_shiv",  30,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (191,"sams_slippery_ring",  30,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (190, 5,10),(190,13,15),(190,12,15),(190,47, 8);   -- DEX+10 EVA+15 ACC+15 Haste+8
REPLACE INTO `item_mods` VALUES (191, 5, 8),(191, 7, 8),(191,13,12),(191,12,12);   -- DEX+8 AGI+8 EVA+12 ACC+12

-- --- Shiny Steve (20h timer, lv45-52, midlands/aradjiah) ---
REPLACE INTO `item_basic` VALUES (195,0,"Steve's_Shiniest_Shiny","steves_shiniest_shiny",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (196,0,"Shiny_Steve's_Spectacles","shiny_steves_spectacles",1,59476,99,0,20000);
REPLACE INTO `item_basic` VALUES (201,0,"Steve's_Sparkle_Earring","steves_sparkle_earring",1,59476,99,0,28000);

REPLACE INTO `item_equipment` VALUES (196,"shiny_steves_spectacles",45,0,4194303,0,0,0,  1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (201,"steves_sparkle_earring", 45,0,4194303,0,0,0,  8,0,0,0); -- EAR

REPLACE INTO `item_mods` VALUES (196, 5,12),(196, 7,12),(196,12,20),(196,13,20),(196,47,10);  -- DEX+12 AGI+12 ACC+20 EVA+20 Haste+10
REPLACE INTO `item_mods` VALUES (201, 5,10),(201,12,15),(201,47, 8),(201, 4, 8);               -- DEX+10 ACC+15 Haste+8 STR+8

-- =============================================================================
-- COEURLS (Whiskers Wilhelmina, Purring Patricia, Nine Lives Nigel)
-- =============================================================================

-- --- Whiskers Wilhelmina (8h timer, lv30-36, midlands) ---
REPLACE INTO `item_basic` VALUES (202,0,"Wilhelmina's_Whisker","wilhelminas_whisker",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (207,0,"Mina's_Collar","minas_collar",1,59476,99,0,6000);
REPLACE INTO `item_basic` VALUES (212,0,"Wilhelmina's_Wristlet","wilhelminas_wristlet",1,59476,99,0,9000);

REPLACE INTO `item_equipment` VALUES (207,"minas_collar",          30,0,4194303,0,0,0,   4,0,0,0); -- NECK
REPLACE INTO `item_equipment` VALUES (212,"wilhelminas_wristlet",  30,0,4194303,0,0,0,  32,0,0,0); -- HANDS

REPLACE INTO `item_mods` VALUES (207, 8, 8),(207, 9, 8),(207,10, 8),(207, 2,40);   -- INT+8 MND+8 CHR+8 HP+40
REPLACE INTO `item_mods` VALUES (212, 4, 8),(212, 5, 8),(212,11,16),(212,12,12);   -- STR+8 DEX+8 ATT+16 ACC+12

-- --- Purring Patricia (14h timer, lv42-48, midlands/elshimo) ---
REPLACE INTO `item_basic` VALUES (217,0,"Patricia's_Paw","patricias_paw",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (218,0,"Purring_Patricia's_Ring","purring_patricias_ring",1,59476,99,0,14000);
REPLACE INTO `item_basic` VALUES (223,0,"Patricia's_Pounce_Boots","patricias_pounce_boots",1,59476,99,0,20000);

REPLACE INTO `item_equipment` VALUES (218,"purring_patricias_ring",42,0,4194303,0,0,0,  64,0,0,0); -- RING
REPLACE INTO `item_equipment` VALUES (223,"patricias_pounce_boots",42,0,4194303,0,0,0,2048,0,0,0); -- FEET

REPLACE INTO `item_mods` VALUES (218, 4,10),(218, 5,10),(218,11,18),(218,47, 8),(218, 2,50);  -- STR+10 DEX+10 ATT+18 Haste+8 HP+50
REPLACE INTO `item_mods` VALUES (223, 5,12),(223, 7,12),(223,13,18),(223,47,10);                -- DEX+12 AGI+12 EVA+18 Haste+10

-- --- Nine Lives Nigel (22h timer, lv58-65, Aradjiah/Shadowreign) ---
REPLACE INTO `item_basic` VALUES (250,0,"Nigel's_Ninth_Life","nigels_ninth_life",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (251,0,"Nine_Lives_Nigel's_Necklace","nine_lives_nigels_necklace",1,59476,99,0,30000);
REPLACE INTO `item_basic` VALUES (252,0,"Nigel's_Nine-Tail_Cape","nigels_nine_tail_cape",1,59476,99,0,42000);

REPLACE INTO `item_equipment` VALUES (251,"nine_lives_nigels_necklace",58,0,4194303,0,0,0,  4,0,0,0); -- NECK
REPLACE INTO `item_equipment` VALUES (252,"nigels_nine_tail_cape",     58,0,4194303,0,0,0,256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (251, 4,14),(251, 5,14),(251,11,25),(251,12,22),(251,47,12),(251, 2,80);   -- STR+14 DEX+14 ATT+25 ACC+22 Haste+12 HP+80
REPLACE INTO `item_mods` VALUES (252, 8,14),(252, 9,14),(252, 2,100),(252,14,25),(252,47,12),(252,23,15);  -- INT+14 MND+14 HP+100 MATK+25 Haste+12 MDEF+15

-- =============================================================================
-- TIGERS (Stripey Steve, Mauler Maurice)
-- =============================================================================

-- --- Stripey Steve (6h timer, lv22-28, midlands) ---
REPLACE INTO `item_basic` VALUES (253,0,"Steve's_Stripe","steves_stripe",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (254,0,"Stripey_Steve's_Cape","stripey_steves_cape",1,59476,99,0,4500);
REPLACE INTO `item_basic` VALUES (255,0,"Steve's_Fang_Earring","steves_fang_earring",1,59476,99,0,6500);

REPLACE INTO `item_equipment` VALUES (254,"stripey_steves_cape",  22,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (255,"steves_fang_earring",  22,0,4194303,0,0,0,   8,0,0,0); -- EAR

REPLACE INTO `item_mods` VALUES (254, 4, 8),(254, 6, 6),(254, 2,50),(254,11,14);  -- STR+8 VIT+6 HP+50 ATT+14
REPLACE INTO `item_mods` VALUES (255, 4, 7),(255,11,14),(255,12,10),(255, 2,30);  -- STR+7 ATT+14 ACC+10 HP+30

-- --- Mauler Maurice (16h timer, lv38-46, midlands/aradjiah) ---
REPLACE INTO `item_basic` VALUES (256,0,"Maurice's_Mauled_Trophy","maurices_mauled_trophy",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (257,0,"Mauler_Maurice's_Mane","mauler_maurices_mane",1,59476,99,0,15000);
REPLACE INTO `item_basic` VALUES (258,0,"Maurice's_Mauler_Belt","maurices_mauler_belt",1,59476,99,0,22000);

REPLACE INTO `item_equipment` VALUES (257,"mauler_maurices_mane",  38,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (258,"maurices_mauler_belt",  38,0,4194303,0,0,0, 512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (257, 4,12),(257, 6,10),(257, 2,80),(257,11,20),(257,12,15);  -- STR+12 VIT+10 HP+80 ATT+20 ACC+15
REPLACE INTO `item_mods` VALUES (258, 4,12),(258, 6,12),(258,11,22),(258,47, 8),(258, 2,60);  -- STR+12 VIT+12 ATT+22 Haste+8 HP+60

-- =============================================================================
-- MANDRAGORAS (Root Rita, Sprout Spencer, Mandrake Max)
-- =============================================================================

-- --- Root Rita (3h timer, lv6-10, Ronfaure/Sarutabaruta) ---
REPLACE INTO `item_basic` VALUES (259,0,"Rita's_Root","ritas_root",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (260,0,"Rita's_Ribbon","ritas_ribbon",1,59476,99,0,600);
REPLACE INTO `item_basic` VALUES (261,0,"Rita's_Ring","ritas_ring",1,59476,99,0,900);

REPLACE INTO `item_equipment` VALUES (260,"ritas_ribbon",   6,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (261,"ritas_ring",     6,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (260, 9, 4),(260,10, 4),(260, 3,20);  -- MND+4 CHR+4 MP+20
REPLACE INTO `item_mods` VALUES (261, 8, 3),(261, 9, 3),(261, 3,15);  -- INT+3 MND+3 MP+15

-- --- Sprout Spencer (10h timer, lv22-28, midlands) ---
REPLACE INTO `item_basic` VALUES (262,0,"Spencer's_Sprout","spencers_sprout",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (263,0,"Spencer's_Leaf_Cloak","spencers_leaf_cloak",1,59476,99,0,5000);
REPLACE INTO `item_basic` VALUES (264,0,"Spencer's_Seedling_Crown","spencers_seedling_crown",1,59476,99,0,7500);

REPLACE INTO `item_equipment` VALUES (263,"spencers_leaf_cloak",   22,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (264,"spencers_seedling_crown",22,0,4194303,0,0,0,  1,0,0,0); -- HEAD

REPLACE INTO `item_mods` VALUES (263, 8, 7),(263, 9, 7),(263, 3,40),(263,14,12);  -- INT+7 MND+7 MP+40 MATK+12
REPLACE INTO `item_mods` VALUES (264, 8, 8),(264, 9, 8),(264,10, 6),(264, 3,50);  -- INT+8 MND+8 CHR+6 MP+50

-- --- Mandrake Max (18h timer, lv40-48, midlands/aradjiah) ---
REPLACE INTO `item_basic` VALUES (265,0,"Max's_Master_Root","maxs_master_root",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (266,0,"Mandrake_Max's_Crown","mandrake_maxs_crown",1,59476,99,0,16000);
REPLACE INTO `item_basic` VALUES (267,0,"Max's_Mystic_Mittens","maxs_mystic_mittens",1,59476,99,0,22000);

REPLACE INTO `item_equipment` VALUES (266,"mandrake_maxs_crown",  40,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (267,"maxs_mystic_mittens",  40,0,4194303,0,0,0,  32,0,0,0); -- HANDS

REPLACE INTO `item_mods` VALUES (266, 8,12),(266, 9,12),(266, 3,70),(266,14,22),(266,15,18);  -- INT+12 MND+12 MP+70 MATK+22 MACC+18
REPLACE INTO `item_mods` VALUES (267, 8,10),(267, 9,10),(267,14,18),(267,15,15),(267,47, 8);   -- INT+10 MND+10 MATK+18 MACC+15 Haste+8

-- =============================================================================
-- BEETLES (Click Clack Clayton, Dung Douglas, Scarab Sebastian)
-- =============================================================================

-- --- Click Clack Clayton (4h timer, lv10-15, gustaberg/midlands) ---
REPLACE INTO `item_basic` VALUES (268,0,"Clayton's_Click_Clacker","claytons_click_clacker",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (269,0,"Click_Clack_Carapace","click_clack_carapace",1,59476,99,0,1800);
REPLACE INTO `item_basic` VALUES (270,0,"Clayton's_Chitin_Ring","claytons_chitin_ring",1,59476,99,0,2500);

REPLACE INTO `item_equipment` VALUES (269,"click_clack_carapace",10,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (270,"claytons_chitin_ring",10,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (269, 1,10),(269, 6, 5),(269, 2,30);  -- DEF+10 VIT+5 HP+30
REPLACE INTO `item_mods` VALUES (270, 1, 6),(270, 6, 4),(270, 2,25);  -- DEF+6 VIT+4 HP+25

-- --- Dung Douglas (12h timer, lv28-34, midlands) ---
REPLACE INTO `item_basic` VALUES (271,0,"Douglas's_Dung_Ball","douglass_dung_ball",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (273,0,"Dung_Douglas's_Shield","dung_douglass_shield",1,59476,99,0,8000);
REPLACE INTO `item_basic` VALUES (274,0,"Douglas's_Durable_Belt","douglass_durable_belt",1,59476,99,0,11000);

REPLACE INTO `item_equipment` VALUES (273,"dung_douglass_shield",28,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (274,"douglass_durable_belt",28,0,4194303,0,0,0,256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (273, 1,16),(273, 6,10),(273, 2,60),(273,47, 6);  -- DEF+16 VIT+10 HP+60 Haste+6
REPLACE INTO `item_mods` VALUES (274, 1,14),(274, 6, 8),(274, 2,70),(274, 4, 6);  -- DEF+14 VIT+8 HP+70 STR+6

-- --- Scarab Sebastian (20h timer, lv45-52, aradjiah) ---
REPLACE INTO `item_basic` VALUES (275,0,"Sebastian's_Sacred_Scarab","sebastians_sacred_scarab",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (276,0,"Scarab_Sebastian's_Ring","scarab_sebastians_ring",1,59476,99,0,22000);
REPLACE INTO `item_basic` VALUES (282,0,"Sebastian's_Shell_Crown","sebastians_shell_crown",1,59476,99,0,30000);

REPLACE INTO `item_equipment` VALUES (276,"scarab_sebastians_ring",45,0,4194303,0,0,0,  64,0,0,0); -- RING
REPLACE INTO `item_equipment` VALUES (282,"sebastians_shell_crown",45,0,4194303,0,0,0,   1,0,0,0); -- HEAD

REPLACE INTO `item_mods` VALUES (276, 4,12),(276, 6,12),(276, 2,80),(276,11,20),(276,47,10);  -- STR+12 VIT+12 HP+80 ATT+20 Haste+10
REPLACE INTO `item_mods` VALUES (282, 1,18),(282, 6,14),(282, 2,100),(282,11,18),(282,47,10); -- DEF+18 VIT+14 HP+100 ATT+18 Haste+10

-- =============================================================================
-- CRAWLERS (Silk Simon, Cocoon Carl)
-- =============================================================================

-- --- Silk Simon (6h timer, lv15-20, midlands) ---
REPLACE INTO `item_basic` VALUES (287,0,"Simon's_Silk_Skein","simons_silk_skein",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (298,0,"Silk_Simon's_Sash","silk_simons_sash",1,59476,99,0,3000);
REPLACE INTO `item_basic` VALUES (303,0,"Simon's_Spinneret_Ring","simons_spinneret_ring",1,59476,99,0,4500);

REPLACE INTO `item_equipment` VALUES (298,"silk_simons_sash",     15,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (303,"simons_spinneret_ring",15,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (298, 9, 5),(298, 3,25),(298,47, 5),(298, 2,30);  -- MND+5 MP+25 Haste+5 HP+30
REPLACE INTO `item_mods` VALUES (303, 8, 4),(303, 9, 4),(303, 3,20),(303,14, 8);  -- INT+4 MND+4 MP+20 MATK+8

-- --- Cocoon Carl (20h timer, lv50-58, aradjiah/shadowreign) ---
REPLACE INTO `item_basic` VALUES (314,0,"Carl's_Perfect_Cocoon","carls_perfect_cocoon",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (315,0,"Cocoon_Carl's_Crown","cocoon_carls_crown",1,59476,99,0,24000);
REPLACE INTO `item_basic` VALUES (316,0,"Carl's_Chrysalis_Cape","carls_chrysalis_cape",1,59476,99,0,32000);

REPLACE INTO `item_equipment` VALUES (315,"cocoon_carls_crown",   50,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (316,"carls_chrysalis_cape", 50,0,4194303,0,0,0, 256,0,0,0); -- BACK

REPLACE INTO `item_mods` VALUES (315, 8,12),(315, 9,12),(315, 3,80),(315,14,22),(315,15,18),(315,47,10);  -- INT+12 MND+12 MP+80 MATK+22 MACC+18 Haste+10
REPLACE INTO `item_mods` VALUES (316, 1,16),(316, 6,12),(316, 2,100),(316,47,12),(316,11,20);               -- DEF+16 VIT+12 HP+100 Haste+12 ATT+20

-- =============================================================================
-- BIRDS (Feather Fred, Beaky Beatrice, Plume Patricia)
-- =============================================================================

-- --- Feather Fred (4h timer, lv10-15, midlands) ---
REPLACE INTO `item_basic` VALUES (318,0,"Fred's_Finest_Feather","freds_finest_feather",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (319,0,"Feather_Fred's_Cap","feather_freds_cap",1,59476,99,0,2000);
REPLACE INTO `item_basic` VALUES (320,0,"Fred's_Flightless_Ring","freds_flightless_ring",1,59476,99,0,3000);

REPLACE INTO `item_equipment` VALUES (319,"feather_freds_cap",      10,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (320,"freds_flightless_ring",  10,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (319, 7, 5),(319, 5, 5),(319,13,10),(319, 2,25);  -- AGI+5 DEX+5 EVA+10 HP+25
REPLACE INTO `item_mods` VALUES (320, 7, 4),(320,13, 8),(320,12, 6);               -- AGI+4 EVA+8 ACC+6

-- --- Beaky Beatrice (12h timer, lv28-35, midlands/elshimo) ---
REPLACE INTO `item_basic` VALUES (321,0,"Beatrice's_Beak","beatrices_beak",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (322,0,"Beaky_Beatrice's_Bonnet","beaky_beatrices_bonnet",1,59476,99,0,8000);
REPLACE INTO `item_basic` VALUES (323,0,"Beatrice's_Talon_Ring","beatrices_talon_ring",1,59476,99,0,11000);

REPLACE INTO `item_equipment` VALUES (322,"beaky_beatrices_bonnet",28,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (323,"beatrices_talon_ring",  28,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (322, 7,10),(322, 5,10),(322,13,15),(322,12,12);  -- AGI+10 DEX+10 EVA+15 ACC+12
REPLACE INTO `item_mods` VALUES (323, 4, 8),(323, 7, 8),(323,11,16),(323,12,12);  -- STR+8 AGI+8 ATT+16 ACC+12

-- --- Plume Patricia (20h timer, lv50-58, aradjiah) ---
REPLACE INTO `item_basic` VALUES (324,0,"Patricia's_Prize_Plumage","patricias_prize_plumage",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (325,0,"Plume_Patricia's_Cape","plume_patricias_cape",1,59476,99,0,25000);
REPLACE INTO `item_basic` VALUES (326,0,"Patricia's_Pinion_Earring","patricias_pinion_earring",1,59476,99,0,35000);

REPLACE INTO `item_equipment` VALUES (325,"plume_patricias_cape",   50,0,4194303,0,0,0, 256,0,0,0); -- BACK
REPLACE INTO `item_equipment` VALUES (326,"patricias_pinion_earring",50,0,4194303,0,0,0,  8,0,0,0); -- EAR

REPLACE INTO `item_mods` VALUES (325, 4,14),(325, 7,14),(325, 2,100),(325,11,22),(325,47,12);  -- STR+14 AGI+14 HP+100 ATT+22 Haste+12
REPLACE INTO `item_mods` VALUES (326, 5,12),(326, 7,12),(326,13,20),(326,12,18),(326,47,10);   -- DEX+12 AGI+12 EVA+20 ACC+18 Haste+10

-- =============================================================================
-- BEES (Honey Harold, Buzzard Barry, Queen Quentin)
-- =============================================================================

-- --- Honey Harold (4h timer, lv10-15, ronfaure/sarutabaruta) ---
REPLACE INTO `item_basic` VALUES (327,0,"Harold's_Honeycomb","harolds_honeycomb",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (328,0,"Honey_Harold's_Stinger","honey_harolds_stinger",1,59476,99,0,2000);
REPLACE INTO `item_basic` VALUES (329,0,"Harold's_Hex_Ring","harolds_hex_ring",1,59476,99,0,3000);

REPLACE INTO `item_equipment` VALUES (328,"honey_harolds_stinger",10,0,4194303,0,0,0,   4,0,0,0); -- NECK
REPLACE INTO `item_equipment` VALUES (329,"harolds_hex_ring",     10,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (328, 4, 5),(328,11,10),(328, 5, 4),(328, 2,25);  -- STR+5 ATT+10 DEX+4 HP+25
REPLACE INTO `item_mods` VALUES (329, 8, 5),(329, 9, 5),(329,14,10),(329, 3,20);  -- INT+5 MND+5 MATK+10 MP+20

-- --- Buzzard Barry (14h timer, lv30-38, midlands) ---
REPLACE INTO `item_basic` VALUES (330,0,"Barry's_Big_Stinger","barrys_big_stinger",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (331,0,"Buzzard_Barry's_Belt","buzzard_barrys_belt",1,59476,99,0,10000);
REPLACE INTO `item_basic` VALUES (332,0,"Barry's_Buzzing_Earring","barrys_buzzing_earring",1,59476,99,0,14000);

REPLACE INTO `item_equipment` VALUES (331,"buzzard_barrys_belt",  30,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (332,"barrys_buzzing_earring",30,0,4194303,0,0,0,  8,0,0,0); -- EAR

REPLACE INTO `item_mods` VALUES (331, 4,10),(331, 5, 8),(331,11,18),(331,12,14),(331,47, 6);  -- STR+10 DEX+8 ATT+18 ACC+14 Haste+6
REPLACE INTO `item_mods` VALUES (332, 4, 8),(332,11,14),(332,47, 8),(332, 2,40);               -- STR+8 ATT+14 Haste+8 HP+40

-- --- Queen Quentin (24h timer, lv62-70, aradjiah/shadowreign) ---
REPLACE INTO `item_basic` VALUES (333,0,"Quentin's_Royal_Jelly","quentins_royal_jelly",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (334,0,"Queen_Quentin's_Crown","queen_quentins_crown",1,59476,99,0,50000);
REPLACE INTO `item_basic` VALUES (335,0,"Quentin's_Stinger_Ring","quentins_stinger_ring",1,59476,99,0,70000);

REPLACE INTO `item_equipment` VALUES (334,"queen_quentins_crown",  62,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (335,"quentins_stinger_ring", 62,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (334, 4,16),(334, 5,16),(334, 2,120),(334,11,28),(334,12,24),(334,47,14);  -- STR+16 DEX+16 HP+120 ATT+28 ACC+24 Haste+14
REPLACE INTO `item_mods` VALUES (335, 8,16),(335, 9,16),(335, 3,100),(335,14,30),(335,15,25),(335,47,14);  -- INT+16 MND+16 MP+100 MATK+30 MACC+25 Haste+14

-- =============================================================================
-- WORMS (Wiggles Winston, Squirmy Sherman)
-- =============================================================================

-- --- Wiggles Winston (2h timer, lv1-5, ronfaure/sarutabaruta/gustaberg) ---
REPLACE INTO `item_basic` VALUES (4133,0,"Winston's_Worm","winstons_worm",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (4149,0,"Wiggles_Winston's_Band","wiggles_winstons_band",1,59476,99,0,200);
REPLACE INTO `item_basic` VALUES (4164,0,"Winston's_Wriggly_Ring","winstons_wriggly_ring",1,59476,99,0,350);

REPLACE INTO `item_equipment` VALUES (4149,"wiggles_winstons_band",  1,0,4194303,0,0,0, 512,0,0,0); -- WAIST
REPLACE INTO `item_equipment` VALUES (4164,"winstons_wriggly_ring",  1,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (4149, 2,15),(4149, 6, 2),(4149, 1, 3);  -- HP+15 VIT+2 DEF+3
REPLACE INTO `item_mods` VALUES (4164, 2,10),(4164, 3, 8),(4164, 9, 2);  -- HP+10 MP+8 MND+2

-- --- Squirmy Sherman (8h timer, lv18-24, midlands) ---
REPLACE INTO `item_basic` VALUES (4170,0,"Sherman's_Squirm","shermans_squirm",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (4207,0,"Squirmy_Sherman's_Coil","squirmy_shermans_coil",1,59476,99,0,4000);
REPLACE INTO `item_basic` VALUES (4232,0,"Sherman's_Sinuous_Sash","shermans_sinuous_sash",1,59476,99,0,6000);

REPLACE INTO `item_equipment` VALUES (4207,"squirmy_shermans_coil",18,0,4194303,0,0,0,  64,0,0,0); -- RING
REPLACE INTO `item_equipment` VALUES (4232,"shermans_sinuous_sash",18,0,4194303,0,0,0, 512,0,0,0); -- WAIST

REPLACE INTO `item_mods` VALUES (4207, 2,40),(4207, 6, 6),(4207, 1, 8),(4207,47, 5);  -- HP+40 VIT+6 DEF+8 Haste+5
REPLACE INTO `item_mods` VALUES (4232, 4, 6),(4232, 6, 6),(4232, 2,40),(4232,11,12);  -- STR+6 VIT+6 HP+40 ATT+12

-- =============================================================================
-- THE JIMS  (Little Jim = giant, Big Jim = tiny — find goblin groupRefs first)
-- =============================================================================

-- --- Little Jim (10h timer, lv25-32, midlands) — uses a LARGE goblin model ---
REPLACE INTO `item_basic` VALUES (4262,0,"Little_Jim's_Big_Trophy","little_jims_big_trophy",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (4266,0,"Little_Jim's_Big_Boots","little_jims_big_boots",1,59476,99,0,6000);
REPLACE INTO `item_basic` VALUES (4274,0,"Little_Jim's_Big_Ring","little_jims_big_ring",1,59476,99,0,9000);

REPLACE INTO `item_equipment` VALUES (4266,"little_jims_big_boots",  25,0,4194303,0,0,0,2048,0,0,0); -- FEET
REPLACE INTO `item_equipment` VALUES (4274,"little_jims_big_ring",   25,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (4266, 6,10),(4266, 1,14),(4266, 2,60),(4266,47, 8);   -- VIT+10 DEF+14 HP+60 Haste+8
REPLACE INTO `item_mods` VALUES (4274, 4,10),(4274, 6, 8),(4274,11,18),(4274, 2,50);   -- STR+10 VIT+8 ATT+18 HP+50

-- --- Big Jim (10h timer, lv25-32, midlands) — uses a SMALL goblin model ---
REPLACE INTO `item_basic` VALUES (4319,0,"Big_Jim's_Small_Trophy","big_jims_small_trophy",1,59476,99,1,0);
REPLACE INTO `item_basic` VALUES (4341,0,"Big_Jim's_Small_Hat","big_jims_small_hat",1,59476,99,0,6000);
REPLACE INTO `item_basic` VALUES (4348,0,"Big_Jim's_Small_Ring","big_jims_small_ring",1,59476,99,0,9000);

REPLACE INTO `item_equipment` VALUES (4341,"big_jims_small_hat",     25,0,4194303,0,0,0,   1,0,0,0); -- HEAD
REPLACE INTO `item_equipment` VALUES (4348,"big_jims_small_ring",    25,0,4194303,0,0,0,  64,0,0,0); -- RING

REPLACE INTO `item_mods` VALUES (4341, 5,10),(4341, 7,10),(4341,12,16),(4341,13,14),(4341,47, 8); -- DEX+10 AGI+10 ACC+16 EVA+14 Haste+8
REPLACE INTO `item_mods` VALUES (4348, 5, 8),(4348, 4, 8),(4348,11,16),(4348,12,14),(4348, 2,50); -- DEX+8 STR+8 ATT+16 ACC+14 HP+50

-- =============================================================================
-- VERIFY (run manually after applying)
-- =============================================================================
-- SELECT i.itemid, i.name, e.level, e.slot, e.jobs
--   FROM item_basic i
--   LEFT JOIN item_equipment e ON i.itemid = e.itemId
--  WHERE i.itemid BETWEEN 6 AND 30519
--  ORDER BY i.itemid;
