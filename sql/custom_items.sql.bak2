-- =============================================================================
-- CUSTOM ITEMS - Dynamic World Drops
-- =============================================================================
-- Safe ID range: 792-30999 (vanilla tops out ~29695)
--
-- HOW TO ADD A NEW ITEM:
--   1. Pick the next unused ID in the 792+ range
--   2. Add a row to item_basic   (name, stack, flags, AH slot, sell price)
--   3. Add a row to item_equipment OR item_weapon (equip stats)
--   4. Add rows to item_mods     (stat bonuses: DEF, STR, INT, etc.)
--   5. Run this script:  mariadb -u root -p xidb < sql/custom_items.sql
--
-- HOW TO RE-RUN SAFELY:
--   Uses REPLACE INTO everywhere, so re-running this file is always safe.
--   It will update existing rows rather than error on duplicates.
--
-- USEFUL REFERENCES:
--   jobs bitmask  : 1=WAR 2=MNK 4=WHM 8=BLM 16=RDM 32=THF 64=PLD 128=DRK
--                   256=BST 512=BRD 1024=RNG 2048=SAM 4096=NIN 8192=DRG
--                   16384=SMN 32768=BLU 65536=COR 131072=PUP 262144=DNC
--                   524288=SCH 1048576=GEO 2097152=RUN  4194303=ALL JOBS
--   slot bitmask  : 1=HEAD 2=NECK 4=EAR1 8=EAR2 16=BODY 32=HANDS 64=RING1
--                   128=RING2 256=BACK 512=WAIST 1024=LEGS 2048=FEET
--                   (weapons use slot 0 with item_weapon)
--   flags common  : 0x0008=Rare 0x0020=Exclusive (no AH) 0x0040=NoDrop
--                   0x1000=Equippable 0x4000=Usable  0x8000=NPC only
--                   46660 = Rare+Exclusive+NoAH (typical rare drop)
--                   12352 = Equippable+Rare
--   mod IDs (item_mods) -- common ones:
--      1=DEF  2=HP  3=MP  4=STR  5=DEX  6=VIT  7=AGI  8=INT  9=MND
--     10=CHR 11=ATT 12=ACC 13=EVA 14=MATK 15=MACC 23=MDEF
--     47=HASTE 70=ENMITY_DOWN 71=ENMITY_UP
-- =============================================================================

USE aoniaxi;

-- =============================================================================
-- SECTION 1: NAMED MOB DROPS (rare, fun, personality items)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Mushroom Morris drops
-- A rare Fungar with a wide hat and suspicious grin.
-- -----------------------------------------------------------------------------

-- [792] Morris's Wide Brim  (head, all jobs, lv1, silly flavor)
REPLACE INTO `item_basic` VALUES
    (792, 0, "Morris's_Wide_Brim", "morriss_wide_brim", 1, 59476, 99, 0, 500);

REPLACE INTO `item_equipment` VALUES
    -- itemId  name                    lv  ilv  jobs       MId  shieldSz  scriptType  slot  rslot  rslotlook  su_lv
    (792, "morriss_wide_brim",        1,   0,  4194303,    0,        0,         0,    1,     0,         0,     0);
    --                                                       ^all jobs              ^HEAD slot

REPLACE INTO `item_mods` VALUES
    (792,  2,  50),   -- HP +50
    (792,  13,   5),   -- MND +5   (he's wise in mushroom ways)
    (792, 14,   5);   -- CHR +5   (very charming hat)


-- [793] Morris's Sporeling  (rare key item / curiosity, no equip — just a trophy drop)
REPLACE INTO `item_basic` VALUES
    (793, 0, "Morris's_Sporeling", "morriss_sporeling", 1, 59476, 99, 1, 0);
    -- NoSale=1, BaseSell=0 — unsellable trophy


-- [794] Mycelium Medal  (neck, all jobs, lv10, rare reward)
REPLACE INTO `item_basic` VALUES
    (794, 0, "Mycelium_Medal", "mycelium_medal", 1, 59476, 99, 0, 800);

REPLACE INTO `item_equipment` VALUES
    (794, "mycelium_medal",           10,  0,  4194303,    0,        0,         0,    4,     0,         0,     0);
    --                                                                                   ^NECK slot

REPLACE INTO `item_mods` VALUES
    (794,  2,  30),   -- HP +30
    (794,  5,  15),   -- MP +15
    (794, 384,   5);   -- Haste +5


-- =============================================================================
-- SECTION 2: DYNAMIC WORLD TIER REWARDS
-- Generic rare drops from Elite / Apex tiers
-- =============================================================================

-- [795] Wanderer's Token  (ring, all jobs, lv1)
REPLACE INTO `item_basic` VALUES
    (795, 0, "Wanderer's_Token", "wanderers_token", 1, 59476, 99, 0, 200);
REPLACE INTO `item_equipment` VALUES
    (795, "wanderers_token",           1,  0,  4194303,    0,        0,         0,   64,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (795,  8,   3),   -- STR +3
    (795,  9,   3);   -- DEX +3

-- [796] Nomad's Cord  (waist, all jobs, lv20)
REPLACE INTO `item_basic` VALUES
    (796, 0, "Nomad's_Cord", "nomads_cord", 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (796, "nomads_cord",              20,  0,  4194303,    0,        0,         0,  512,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (796,  8,   5),   -- STR +5
    (796,  10,   5),   -- VIT +5
    (796, 23,  10);   -- ATT +10

-- [797] Elite's Resolve  (back, all jobs, lv40)
REPLACE INTO `item_basic` VALUES
    (797, 0, "Elite's_Resolve", "elites_resolve", 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (797, "elites_resolve",           40,  0,  4194303,    0,        0,         0,  256,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (797,  2,  50),   -- HP +50
    (797,  8,   8),   -- STR +8
    (797, 23,  15),   -- ATT +15
    (797, 25,  10);   -- ACC +10

-- [798] Apex Shard  (ring, all jobs, lv50)
REPLACE INTO `item_basic` VALUES
    (798, 0, "Apex_Shard", "apex_shard", 1, 59476, 99, 0, 10000);
REPLACE INTO `item_equipment` VALUES
    (798, "apex_shard",               50,  0,  4194303,    0,        0,         0,   64,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (798,  2, 100),   -- HP +100
    (798,  5,  50),   -- MP +50
    (798,  8,  10),   -- STR +10
    (798,  12,  10),   -- INT +10
    (798, 384,  10);   -- Haste +10


-- =============================================================================
-- SECTION 3: NAMED RARE UNIQUE DROPS
-- Every named rare has 3 items: trophy (always), gear1 (40%), gear2 (15%)
-- =============================================================================

-- =========================================================
-- SHEEP
-- =========================================================

-- Wooly William (lv6-8) — 30100-30102
REPLACE INTO `item_basic` VALUES
    (30100, 0, "William's_Wool", "williams_wool", 1, 59476, 99, 0, 50);
-- trophy, no equip

REPLACE INTO `item_basic` VALUES
    (30101, 0, "William's_Woolcap", "williams_woolcap", 1, 59476, 99, 0, 300);
REPLACE INTO `item_equipment` VALUES
    (30101, "williams_woolcap",          5,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30101,  1,   3),   -- DEF +3
    (30101,  2,  15),   -- HP +15
    (30101, 14,   3);   -- CHR +3

REPLACE INTO `item_basic` VALUES
    (30102, 0, "William's_Woolmitt", "williams_woolmitt", 1, 59476, 99, 0, 500);
REPLACE INTO `item_equipment` VALUES
    (30102, "williams_woolmitt",         5,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30102,  1,   2),   -- DEF +2
    (30102,  10,   3),   -- VIT +3
    (30102,  13,   3);   -- MND +3


-- Baa-rbara (lv10-13) — 30103-30105
REPLACE INTO `item_basic` VALUES
    (30103, 0, "Baarbara's_Bell", "baarbaras_bell", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30104, 0, "Baarbara's_Collar", "baarbaras_collar", 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30104, "baarbaras_collar",         10,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30104,  2,  20),   -- HP +20
    (30104, 14,   5),   -- CHR +5
    (30104,  13,   3);   -- MND +3

REPLACE INTO `item_basic` VALUES
    (30105, 0, "Baarbara's_Ribbon", "baarbaras_ribbon", 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (30105, "baarbaras_ribbon",         10,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30105, 68,   5),   -- EVA +5
    (30105,  11,   4),   -- AGI +4
    (30105, 14,   4);   -- CHR +4


-- Lambchop Larry (lv20-24) — 30106-30108
REPLACE INTO `item_basic` VALUES
    (30106, 0, "Larry's_Lambchop", "larrys_lambchop", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30107, 0, "Larry's_Lucky_Fleece", "larrys_lucky_fleece", 1, 59476, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (30107, "larrys_lucky_fleece",      20,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30107,  1,   8),   -- DEF +8
    (30107,  2,  30),   -- HP +30
    (30107, 68,   5);   -- EVA +5

REPLACE INTO `item_basic` VALUES
    (30108, 0, "Larry's_Lanyard", "larrys_lanyard", 1, 59476, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (30108, "larrys_lanyard",           20,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30108,  8,   5),   -- STR +5
    (30108, 23,   8),   -- ATT +8
    (30108, 25,   5);   -- ACC +5


-- Shear Sharon (lv35-40) — 30109-30111
REPLACE INTO `item_basic` VALUES
    (30109, 0, "Sharon's_Golden_Fleece", "sharons_golden_fleece", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30110, 0, "Sharon's_Shears", "sharons_shears", 1, 59476, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (30110, "sharons_shears",           35,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30110,  1,  12),   -- DEF +12
    (30110,  9,   8),   -- DEX +8
    (30110, 25,  10),   -- ACC +10
    (30110, 23,   8);   -- ATT +8

REPLACE INTO `item_basic` VALUES
    (30111, 0, "Sharon's_Silken_Mantle", "sharons_silken_mantle", 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (30111, "sharons_silken_mantle",    35,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30111,  1,  10),   -- DEF +10
    (30111,  2,  40),   -- HP +40
    (30111,  5,  20),   -- MP +20
    (30111, 29,   8);   -- MDEF +8


-- =========================================================
-- RABBITS
-- =========================================================

-- Cottontail Tom (lv5-7) — 30130-30132
REPLACE INTO `item_basic` VALUES
    (30130, 0, "Tom's_Cottontail", "toms_cottontail", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30131, 0, "Tom's_Lucky_Foot", "toms_lucky_foot", 1, 59476, 99, 0, 300);
REPLACE INTO `item_equipment` VALUES
    (30131, "toms_lucky_foot",           5,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30131,  11,   3),   -- AGI +3
    (30131, 68,   3);   -- EVA +3

REPLACE INTO `item_basic` VALUES
    (30132, 0, "Tom's_Hop_Boots", "toms_hop_boots", 1, 59476, 99, 0, 500);
REPLACE INTO `item_equipment` VALUES
    (30132, "toms_hop_boots",            5,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30132,  1,   2),   -- DEF +2
    (30132,  11,   4),   -- AGI +4
    (30132, 68,   3);   -- EVA +3


-- Hopscotch Harvey (lv10-13) — 30133-30135
REPLACE INTO `item_basic` VALUES
    (30133, 0, "Harvey's_Hopstone", "harveys_hopstone", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30134, 0, "Harvey's_Hop_Ring", "harveys_hop_ring", 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30134, "harveys_hop_ring",         10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30134,  11,   5),   -- AGI +5
    (30134,  9,   3),   -- DEX +3
    (30134, 68,   5);   -- EVA +5

REPLACE INTO `item_basic` VALUES
    (30135, 0, "Harvey's_Spring_Earring", "harveys_spring_earring", 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (30135, "harveys_spring_earring",   10,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30135,  11,   6),   -- AGI +6
    (30135, 384,   3);   -- Haste +3


-- Bunbun Benedict (lv22-28) — 30136-30138
REPLACE INTO `item_basic` VALUES
    (30136, 0, "Benedict's_Bonnet", "benedicts_bonnet_trophy", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30137, 0, "Benedict's_Fur_Cap", "benedicts_fur_cap", 1, 59476, 99, 0, 1400);
REPLACE INTO `item_equipment` VALUES
    (30137, "benedicts_fur_cap",        22,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30137,  1,   8),   -- DEF +8
    (30137,  11,   6),   -- AGI +6
    (30137, 68,   8),   -- EVA +8
    (30137,  2,  25);   -- HP +25

REPLACE INTO `item_basic` VALUES
    (30138, 0, "Benedict's_Burrow_Belt", "benedicts_burrow_belt", 1, 59476, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (30138, "benedicts_burrow_belt",    22,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30138,  9,   6),   -- DEX +6
    (30138,  11,   6),   -- AGI +6
    (30138, 25,   8);   -- ACC +8


-- Twitchy Theodore (lv38-45) — 30139-30141
REPLACE INTO `item_basic` VALUES
    (30139, 0, "Theodore's_Twitch", "theodores_twitch", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30140, 0, "Theodore's_Dash_Greaves", "theodores_dash_greaves", 1, 59476, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (30140, "theodores_dash_greaves",   38,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30140,  1,  14),   -- DEF +14
    (30140,  11,  10),   -- AGI +10
    (30140, 68,  12),   -- EVA +12
    (30140, 384,   5);   -- Haste +5

REPLACE INTO `item_basic` VALUES
    (30141, 0, "Theodore's_Panic_Earring", "theodores_panic_earring", 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (30141, "theodores_panic_earring",  38,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30141,  11,  10),   -- AGI +10
    (30141, 68,  15),   -- EVA +15
    (30141, 384,   4);   -- Haste +4


-- =========================================================
-- CRABS
-- =========================================================

-- Crableg Cameron (lv12-16) — 30160-30162
REPLACE INTO `item_basic` VALUES
    (30160, 0, "Cameron's_Claw", "camerons_claw", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30161, 0, "Cameron's_Shell_Shield", "camerons_shell_shield", 1, 59476, 99, 0, 700);
REPLACE INTO `item_equipment` VALUES
    (30161, "camerons_shell_shield",    12,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30161,  1,   5),   -- DEF +5
    (30161,  10,   4),   -- VIT +4
    (30161,  2,  20);   -- HP +20

REPLACE INTO `item_basic` VALUES
    (30162, 0, "Cameron's_Coral_Ring", "camerons_coral_ring", 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (30162, "camerons_coral_ring",      12,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30162,  10,   5),   -- VIT +5
    (30162,  1,   4),   -- DEF +4
    (30162, 29,   4);   -- MDEF +4


-- Old Bay Ollie (lv25-30) — 30163-30165
REPLACE INTO `item_basic` VALUES
    (30163, 0, "Ollie's_Old_Shell", "ollies_old_shell", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30164, 0, "Ollie's_Brine_Gauntlets", "ollies_brine_gauntlets", 1, 59476, 99, 0, 1600);
REPLACE INTO `item_equipment` VALUES
    (30164, "ollies_brine_gauntlets",   25,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30164,  1,  10),   -- DEF +10
    (30164,  10,   7),   -- VIT +7
    (30164,  2,  30),   -- HP +30
    (30164, 27,   3);   -- Enmity +3

REPLACE INTO `item_basic` VALUES
    (30165, 0, "Ollie's_Seasoned_Belt", "ollies_seasoned_belt", 1, 59476, 99, 0, 2500);
REPLACE INTO `item_equipment` VALUES
    (30165, "ollies_seasoned_belt",     25,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30165,  10,   8),   -- VIT +8
    (30165,  1,   8),   -- DEF +8
    (30165, 29,   6);   -- MDEF +6


-- Bisque Bernard (lv35-42) — 30166-30168
REPLACE INTO `item_basic` VALUES
    (30166, 0, "Bernard's_Bisque_Bowl", "bernards_bisque_bowl", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30167, 0, "Bernard's_Tidal_Mail", "bernards_tidal_mail", 1, 59476, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (30167, "bernards_tidal_mail",      35,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30167,  1,  18),   -- DEF +18
    (30167,  10,  10),   -- VIT +10
    (30167,  2,  50),   -- HP +50
    (30167, 27,   5);   -- Enmity +5

REPLACE INTO `item_basic` VALUES
    (30168, 0, "Bernard's_Brine_Earring", "bernards_brine_earring", 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (30168, "bernards_brine_earring",   35,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30168,  10,   8),   -- VIT +8
    (30168, 29,  10),   -- MDEF +10
    (30168,  5,  20);   -- MP +20


-- Dungeness Duncan (lv45-52) — 30169-30171
REPLACE INTO `item_basic` VALUES
    (30169, 0, "Duncan's_Pincer", "duncans_pincer", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30170, 0, "Duncan's_Abyssal_Helm", "duncans_abyssal_helm", 1, 59476, 99, 0, 8000);
REPLACE INTO `item_equipment` VALUES
    (30170, "duncans_abyssal_helm",     45,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30170,  1,  22),   -- DEF +22
    (30170,  10,  12),   -- VIT +12
    (30170,  2,  60),   -- HP +60
    (30170, 29,  10);   -- MDEF +10

REPLACE INTO `item_basic` VALUES
    (30171, 0, "Duncan's_Deepwater_Ring", "duncans_deepwater_ring", 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (30171, "duncans_deepwater_ring",   45,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30171,  10,  12),   -- VIT +12
    (30171,  1,  15),   -- DEF +15
    (30171,  2,  80),   -- HP +80
    (30171, 384,   5);   -- Haste +5


-- =========================================================
-- FUNGARS
-- =========================================================

-- Cap'n Chanterelle (lv18-22) — 30190-30192
REPLACE INTO `item_basic` VALUES
    (30190, 0, "Chanterelle's_Cap", "chanterelles_cap_trophy", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30191, 0, "Chanterelle's_Spore_Hat", "chanterelles_spore_hat", 1, 59476, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (30191, "chanterelles_spore_hat",   18,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30191,  1,   7),   -- DEF +7
    (30191,  12,   5),   -- INT +5
    (30191,  5,  20),   -- MP +20
    (30191, 28,   4);   -- MATK +4

REPLACE INTO `item_basic` VALUES
    (30192, 0, "Chanterelle's_Mycelia", "chanterelles_mycelia", 1, 59476, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (30192, "chanterelles_mycelia",     18,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30192,  12,   6),   -- INT +6
    (30192,  13,   4),   -- MND +4
    (30192, 28,   5);   -- MATK +5


-- Portobello Pete (lv35-40) — 30193-30195
REPLACE INTO `item_basic` VALUES
    (30193, 0, "Pete's_Portobello", "petes_portobello", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30194, 0, "Pete's_Fungal_Robe", "petes_fungal_robe", 1, 59476, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (30194, "petes_fungal_robe",        35,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30194,  1,  15),   -- DEF +15
    (30194,  12,  10),   -- INT +10
    (30194,  5,  40),   -- MP +40
    (30194, 28,   8);   -- MATK +8

REPLACE INTO `item_basic` VALUES
    (30195, 0, "Pete's_Spore_Necklace", "petes_spore_necklace", 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (30195, "petes_spore_necklace",     35,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30195,  12,   8),   -- INT +8
    (30195, 28,  10),   -- MATK +10
    (30195, 30,   8);   -- MACC +8


-- Truffle Trevor (lv55-62) — 30196-30198
REPLACE INTO `item_basic` VALUES
    (30196, 0, "Trevor's_Truffle", "trevors_truffle", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30197, 0, "Trevor's_Myconid_Crown", "trevors_myconid_crown", 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (30197, "trevors_myconid_crown",    55,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30197,  1,  20),   -- DEF +20
    (30197,  12,  15),   -- INT +15
    (30197,  5,  60),   -- MP +60
    (30197, 28,  15),   -- MATK +15
    (30197, 30,  10);   -- MACC +10

REPLACE INTO `item_basic` VALUES
    (30198, 0, "Trevor's_Decay_Ring", "trevors_decay_ring", 1, 59476, 99, 0, 15000);
REPLACE INTO `item_equipment` VALUES
    (30198, "trevors_decay_ring",       55,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30198,  12,  14),   -- INT +14
    (30198, 28,  18),   -- MATK +18
    (30198,  5,  50),   -- MP +50
    (30198, 384,   5);   -- Haste +5


-- =========================================================
-- GOBLINS
-- =========================================================

-- Bargain Bruno (lv12-16) — 30220-30222
REPLACE INTO `item_basic` VALUES
    (30220, 0, "Bruno's_Bargain_Bin", "brunos_bargain_bin", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30221, 0, "Bruno's_Discount_Helm", "brunos_discount_helm", 1, 59476, 99, 0, 700);
REPLACE INTO `item_equipment` VALUES
    (30221, "brunos_discount_helm",     12,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30221,  1,   5),   -- DEF +5
    (30221,  8,   3),   -- STR +3
    (30221,  9,   3),   -- DEX +3
    (30221, 14,   3);   -- CHR +3

REPLACE INTO `item_basic` VALUES
    (30222, 0, "Bruno's_Lucky_Pouch", "brunos_lucky_pouch", 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (30222, "brunos_lucky_pouch",       12,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30222,  9,   5),   -- DEX +5
    (30222, 25,   5),   -- ACC +5
    (30222, 14,   4);   -- CHR +4


-- Swindler Sam (lv30-36) — 30223-30225
REPLACE INTO `item_basic` VALUES
    (30223, 0, "Sam's_Loaded_Dice", "sams_loaded_dice", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30224, 0, "Sam's_Swindler_Vest", "sams_swindler_vest", 1, 59476, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (30224, "sams_swindler_vest",       30,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30224,  1,  14),   -- DEF +14
    (30224,  9,   8),   -- DEX +8
    (30224,  11,   6),   -- AGI +6
    (30224, 68,   8);   -- EVA +8

REPLACE INTO `item_basic` VALUES
    (30225, 0, "Sam's_Grift_Earring", "sams_grift_earring", 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (30225, "sams_grift_earring",       30,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30225,  9,   8),   -- DEX +8
    (30225, 25,  10),   -- ACC +10
    (30225, 384,   4);   -- Haste +4


-- Shiny Steve (lv45-52) — 30226-30228
REPLACE INTO `item_basic` VALUES
    (30226, 0, "Steve's_Shiniest", "steves_shiniest", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30227, 0, "Steve's_Glittering_Mail", "steves_glittering_mail", 1, 59476, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (30227, "steves_glittering_mail",   45,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30227,  1,  22),   -- DEF +22
    (30227,  9,  12),   -- DEX +12
    (30227,  11,  10),   -- AGI +10
    (30227, 25,  15),   -- ACC +15
    (30227, 68,  10);   -- EVA +10

REPLACE INTO `item_basic` VALUES
    (30228, 0, "Steve's_Magpie_Ring", "steves_magpie_ring", 1, 59476, 99, 0, 14000);
REPLACE INTO `item_equipment` VALUES
    (30228, "steves_magpie_ring",       45,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30228,  9,  12),   -- DEX +12
    (30228, 25,  15),   -- ACC +15
    (30228, 23,  12),   -- ATT +12
    (30228, 384,   5);   -- Haste +5


-- =========================================================
-- COEURLS
-- =========================================================

-- Whiskers Wilhelmina (lv30-36) — 30250-30252
REPLACE INTO `item_basic` VALUES
    (30250, 0, "Wilhelmina's_Whisker", "wilhelminas_whisker", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30251, 0, "Wilhelmina's_Fang_Neck", "wilhelminas_fang_necklace", 1, 59476, 99, 0, 3500);
REPLACE INTO `item_equipment` VALUES
    (30251, "wilhelminas_fang_necklace",30,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30251, 23,  10),   -- ATT +10
    (30251,  8,   7),   -- STR +7
    (30251,  9,   5);   -- DEX +5

REPLACE INTO `item_basic` VALUES
    (30252, 0, "Wilhelmina's_Grace_Legs", "wilhelminas_grace_legs", 1, 59476, 99, 0, 5500);
REPLACE INTO `item_equipment` VALUES
    (30252, "wilhelminas_grace_legs",   30,  0,  4194303,    0,   0,  0, 1024,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30252,  1,  14),   -- DEF +14
    (30252,  11,   8),   -- AGI +8
    (30252, 68,  10),   -- EVA +10
    (30252,  8,   6);   -- STR +6


-- Purring Patricia (lv42-48) — 30253-30255
REPLACE INTO `item_basic` VALUES
    (30253, 0, "Patricia's_Purr_Stone", "patricias_purr_stone", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30254, 0, "Patricia's_Claw_Gauntlets", "patricias_claw_gauntlets", 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (30254, "patricias_claw_gauntlets", 42,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30254,  1,  16),   -- DEF +16
    (30254,  8,  10),   -- STR +10
    (30254, 23,  14),   -- ATT +14
    (30254,  9,   8);   -- DEX +8

REPLACE INTO `item_basic` VALUES
    (30255, 0, "Patricia's_Predator_Cape", "patricias_predator_cape", 1, 59476, 99, 0, 10000);
REPLACE INTO `item_equipment` VALUES
    (30255, "patricias_predator_cape",  42,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30255,  8,  10),   -- STR +10
    (30255,  11,  10),   -- AGI +10
    (30255, 23,  12),   -- ATT +12
    (30255, 25,  12);   -- ACC +12


-- Nine Lives Nigel (lv58-65) — 30256-30258
REPLACE INTO `item_basic` VALUES
    (30256, 0, "Nigel's_Ninth_Life", "nigels_ninth_life", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30257, 0, "Nigel's_Feral_Cuirass", "nigels_feral_cuirass", 1, 59476, 99, 0, 15000);
REPLACE INTO `item_equipment` VALUES
    (30257, "nigels_feral_cuirass",     58,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30257,  1,  28),   -- DEF +28
    (30257,  8,  14),   -- STR +14
    (30257,  9,  12),   -- DEX +12
    (30257, 23,  18),   -- ATT +18
    (30257, 25,  15);   -- ACC +15

REPLACE INTO `item_basic` VALUES
    (30258, 0, "Nigel's_Cateye_Ring", "nigels_cateye_ring", 1, 59476, 99, 0, 18000);
REPLACE INTO `item_equipment` VALUES
    (30258, "nigels_cateye_ring",       58,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30258,  8,  14),   -- STR +14
    (30258, 23,  20),   -- ATT +20
    (30258, 25,  18),   -- ACC +18
    (30258, 384,   6);   -- Haste +6


-- =========================================================
-- TIGERS
-- =========================================================

-- Stripey Steve (lv22-28) — 30280-30282
REPLACE INTO `item_basic` VALUES
    (30280, 0, "Steve's_Stripe", "steves_stripe_trophy", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30281, 0, "Steve's_Tiger_Fangs", "steves_tiger_fangs", 1, 59476, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (30281, "steves_tiger_fangs",       22,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30281,  8,   6),   -- STR +6
    (30281, 23,   8),   -- ATT +8
    (30281, 25,   5);   -- ACC +5

REPLACE INTO `item_basic` VALUES
    (30282, 0, "Steve's_Pelt_Mantle", "steves_pelt_mantle", 1, 59476, 99, 0, 2200);
REPLACE INTO `item_equipment` VALUES
    (30282, "steves_pelt_mantle",       22,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30282,  1,  10),   -- DEF +10
    (30282,  8,   7),   -- STR +7
    (30282,  10,   5),   -- VIT +5
    (30282,  2,  30);   -- HP +30


-- Mauler Maurice (lv38-46) — 30283-30285
REPLACE INTO `item_basic` VALUES
    (30283, 0, "Maurice's_Mauled_Hide", "maurices_mauled_hide", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30284, 0, "Maurice's_Savage_Helm", "maurices_savage_helm", 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (30284, "maurices_savage_helm",     38,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30284,  1,  16),   -- DEF +16
    (30284,  8,  10),   -- STR +10
    (30284, 23,  14),   -- ATT +14
    (30284,  2,  40);   -- HP +40

REPLACE INTO `item_basic` VALUES
    (30285, 0, "Maurice's_Mauler_Belt", "maurices_mauler_belt", 1, 59476, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (30285, "maurices_mauler_belt",     38,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30285,  8,  10),   -- STR +10
    (30285, 23,  15),   -- ATT +15
    (30285,  9,   8),   -- DEX +8
    (30285, 384,   4);   -- Haste +4


-- Saber Sabrina (lv58-65) — 799-801
REPLACE INTO `item_basic` VALUES
    (799, 0, "Sabrina's_Saber-Fang", "sabrinas_saber_fang", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (800, 0, "Sabrina's_Feral_Legs", "sabrinas_feral_legs", 1, 59476, 99, 0, 15000);
REPLACE INTO `item_equipment` VALUES
    (800, "sabrinas_feral_legs",         58,  0,  4194303,    0,   0,  0, 1024,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (800,  1,  24),   -- DEF +24
    (800,  8,  14),   -- STR +14
    (800,  9,  12),   -- DEX +12
    (800, 23,  18),   -- ATT +18
    (800, 25,  15);   -- ACC +15

REPLACE INTO `item_basic` VALUES
    (801, 0, "Sabrina's_Apex_Ring", "sabrinas_apex_ring", 1, 59476, 99, 0, 20000);
REPLACE INTO `item_equipment` VALUES
    (801, "sabrinas_apex_ring",           58,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (801,  8,  14),   -- STR +14
    (801, 23,  20),   -- ATT +20
    (801, 25,  18),   -- ACC +18
    (801, 384,   6);   -- Haste +6


-- =========================================================
-- MANDRAGORAS
-- =========================================================

-- Root Rita (lv6-10) — 30310-30312
REPLACE INTO `item_basic` VALUES
    (30310, 0, "Rita's_Root", "ritas_root", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30311, 0, "Rita's_Leaf_Earring", "ritas_leaf_earring", 1, 59476, 99, 0, 400);
REPLACE INTO `item_equipment` VALUES
    (30311, "ritas_leaf_earring",        6,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30311,  13,   3),   -- MND +3
    (30311, 14,   3),   -- CHR +3
    (30311,  5,  10);   -- MP +10

REPLACE INTO `item_basic` VALUES
    (30312, 0, "Rita's_Petal_Wrist", "ritas_petal_wrist", 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30312, "ritas_petal_wrist",         6,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30312,  1,   3),   -- DEF +3
    (30312,  13,   4),   -- MND +4
    (30312,  5,  15);   -- MP +15


-- Sprout Spencer (lv22-28) — 30313-30315
REPLACE INTO `item_basic` VALUES
    (30313, 0, "Spencer's_Sprout", "spencers_sprout", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30314, 0, "Spencer's_Verdant_Hat", "spencers_verdant_hat", 1, 59476, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (30314, "spencers_verdant_hat",     22,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30314,  1,   8),   -- DEF +8
    (30314,  13,   7),   -- MND +7
    (30314,  5,  30),   -- MP +30
    (30314, 14,   5);   -- CHR +5

REPLACE INTO `item_basic` VALUES
    (30315, 0, "Spencer's_Bloom_Ring", "spencers_bloom_ring", 1, 59476, 99, 0, 2200);
REPLACE INTO `item_equipment` VALUES
    (30315, "spencers_bloom_ring",      22,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30315,  13,   7),   -- MND +7
    (30315,  12,   5),   -- INT +5
    (30315, 28,   6);   -- MATK +6


-- Mandrake Max (lv40-48) — 30316-30318
REPLACE INTO `item_basic` VALUES
    (30316, 0, "Max's_Mandrake_Heart", "maxs_mandrake_heart", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30317, 0, "Max's_Shriek_Mask", "maxs_shriek_mask", 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (30317, "maxs_shriek_mask",         40,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30317,  1,  16),   -- DEF +16
    (30317,  13,  12),   -- MND +12
    (30317,  12,  10),   -- INT +10
    (30317,  5,  45),   -- MP +45
    (30317, 28,  10);   -- MATK +10

REPLACE INTO `item_basic` VALUES
    (30318, 0, "Max's_Earthscream_Belt", "maxs_earthscream_belt", 1, 59476, 99, 0, 10000);
REPLACE INTO `item_equipment` VALUES
    (30318, "maxs_earthscream_belt",    40,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30318,  13,  10),   -- MND +10
    (30318,  12,  10),   -- INT +10
    (30318, 28,  12),   -- MATK +12
    (30318, 30,  10);   -- MACC +10


-- =========================================================
-- BEETLES
-- =========================================================

-- Click Clack Clayton (lv10-15) — 30340-30342
REPLACE INTO `item_basic` VALUES
    (30340, 0, "Clayton's_Clicking_Shell", "claytons_clicking_shell", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30341, 0, "Clayton's_Chitin_Legs", "claytons_chitin_legs", 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30341, "claytons_chitin_legs",     10,  0,  4194303,    0,   0,  0, 1024,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30341,  1,   4),   -- DEF +4
    (30341,  10,   4),   -- VIT +4
    (30341,  2,  15);   -- HP +15

REPLACE INTO `item_basic` VALUES
    (30342, 0, "Clayton's_Clack_Ring", "claytons_clack_ring", 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (30342, "claytons_clack_ring",      10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30342,  1,   3),   -- DEF +3
    (30342,  10,   4),   -- VIT +4
    (30342,  8,   3);   -- STR +3


-- Dung Douglas (lv28-34) — 30343-30345
REPLACE INTO `item_basic` VALUES
    (30343, 0, "Douglas's_Dung_Ball", "douglass_dung_ball", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30344, 0, "Douglas's_Roller_Boots", "douglass_roller_boots", 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (30344, "douglass_roller_boots",    28,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30344,  1,  12),   -- DEF +12
    (30344,  10,   8),   -- VIT +8
    (30344,  8,   6),   -- STR +6
    (30344,  2,  30);   -- HP +30

REPLACE INTO `item_basic` VALUES
    (30345, 0, "Douglas's_Carapace_Neck", "douglass_carapace_necklace", 1, 59476, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (30345, "douglass_carapace_necklace",28,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30345,  10,   8),   -- VIT +8
    (30345,  1,   8),   -- DEF +8
    (30345, 29,   6);   -- MDEF +6


-- Scarab Sebastian (lv45-52) — 30346-30348
REPLACE INTO `item_basic` VALUES
    (30346, 0, "Sebastian's_Scarab", "sebastians_scarab", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30347, 0, "Sebastian's_Sacred_Helm", "sebastians_sacred_helm", 1, 59476, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (30347, "sebastians_sacred_helm",   45,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30347,  1,  22),   -- DEF +22
    (30347,  10,  12),   -- VIT +12
    (30347,  8,  10),   -- STR +10
    (30347,  2,  60),   -- HP +60
    (30347, 29,   8);   -- MDEF +8

REPLACE INTO `item_basic` VALUES
    (30348, 0, "Sebastian's_Jeweled_Ring", "sebastians_jeweled_ring", 1, 59476, 99, 0, 13000);
REPLACE INTO `item_equipment` VALUES
    (30348, "sebastians_jeweled_ring",  45,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30348,  10,  12),   -- VIT +12
    (30348,  1,  12),   -- DEF +12
    (30348,  2,  70),   -- HP +70
    (30348, 384,   5);   -- Haste +5


-- =========================================================
-- CRAWLERS
-- =========================================================

-- Silk Simon (lv15-20) — 30370-30372
REPLACE INTO `item_basic` VALUES
    (30370, 0, "Simon's_Silk_Thread", "simons_silk_thread", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30371, 0, "Simon's_Silk_Gloves", "simons_silk_gloves", 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (30371, "simons_silk_gloves",       15,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30371,  1,   5),   -- DEF +5
    (30371,  9,   5),   -- DEX +5
    (30371, 25,   5);   -- ACC +5

REPLACE INTO `item_basic` VALUES
    (30372, 0, "Simon's_Webbed_Cape", "simons_webbed_cape", 1, 59476, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (30372, "simons_webbed_cape",       15,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30372,  1,   6),   -- DEF +6
    (30372,  11,   5),   -- AGI +5
    (30372, 68,   6);   -- EVA +6


-- Cocoon Carl (lv50-58) — 30373-30375
REPLACE INTO `item_basic` VALUES
    (30373, 0, "Carl's_Cocoon_Shard", "carls_cocoon_shard", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30374, 0, "Carl's_Chrysalis_Mail", "carls_chrysalis_mail", 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (30374, "carls_chrysalis_mail",     50,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30374,  1,  25),   -- DEF +25
    (30374,  10,  12),   -- VIT +12
    (30374,  2,  70),   -- HP +70
    (30374, 29,  12),   -- MDEF +12
    (30374, 68,  10);   -- EVA +10

REPLACE INTO `item_basic` VALUES
    (30375, 0, "Carl's_Metamorph_Ring", "carls_metamorph_ring", 1, 59476, 99, 0, 16000);
REPLACE INTO `item_equipment` VALUES
    (30375, "carls_metamorph_ring",     50,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30375,  2,  80),   -- HP +80
    (30375,  5,  40),   -- MP +40
    (30375,  10,  12),   -- VIT +12
    (30375, 384,   5);   -- Haste +5


-- =========================================================
-- BIRDS
-- =========================================================

-- Feather Fred (lv10-15) — 30400-30402
REPLACE INTO `item_basic` VALUES
    (30400, 0, "Fred's_Finest_Feather", "freds_finest_feather", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30401, 0, "Fred's_Down_Vest", "freds_down_vest", 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30401, "freds_down_vest",          10,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30401,  1,   5),   -- DEF +5
    (30401,  11,   4),   -- AGI +4
    (30401, 68,   4);   -- EVA +4

REPLACE INTO `item_basic` VALUES
    (30402, 0, "Fred's_Talon_Ring", "freds_talon_ring", 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (30402, "freds_talon_ring",         10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30402,  11,   4),   -- AGI +4
    (30402,  9,   3),   -- DEX +3
    (30402, 25,   4);   -- ACC +4


-- Beaky Beatrice (lv28-35) — 30403-30405
REPLACE INTO `item_basic` VALUES
    (30403, 0, "Beatrice's_Beak_Tip", "beatrices_beak_tip", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30404, 0, "Beatrice's_Plume_Hat", "beatrices_plume_hat", 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (30404, "beatrices_plume_hat",      28,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30404,  1,  10),   -- DEF +10
    (30404,  11,   8),   -- AGI +8
    (30404, 68,  10),   -- EVA +10
    (30404, 14,   5);   -- CHR +5

REPLACE INTO `item_basic` VALUES
    (30405, 0, "Beatrice's_Wind_Earring", "beatrices_wind_earring", 1, 59476, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (30405, "beatrices_wind_earring",   28,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30405,  11,   8),   -- AGI +8
    (30405, 68,  12),   -- EVA +12
    (30405, 384,   3);   -- Haste +3


-- Plume Patricia (lv50-58) — 30406-30408
REPLACE INTO `item_basic` VALUES
    (30406, 0, "Patricia's_Tail_Plume", "patricias_tail_plume", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30407, 0, "Patricia's_Zephyr_Vest", "patricias_zephyr_vest", 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (30407, "patricias_zephyr_vest",    50,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30407,  1,  20),   -- DEF +20
    (30407,  11,  14),   -- AGI +14
    (30407, 68,  18),   -- EVA +18
    (30407, 384,   5),   -- Haste +5
    (30407, 25,  10);   -- ACC +10

REPLACE INTO `item_basic` VALUES
    (30408, 0, "Patricia's_Gale_Ring", "patricias_gale_ring", 1, 59476, 99, 0, 16000);
REPLACE INTO `item_equipment` VALUES
    (30408, "patricias_gale_ring",      50,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30408,  11,  14),   -- AGI +14
    (30408, 68,  20),   -- EVA +20
    (30408, 384,   6);   -- Haste +6


-- =========================================================
-- BEES
-- =========================================================

-- Honey Harold (lv10-15) — 30430-30432
REPLACE INTO `item_basic` VALUES
    (30430, 0, "Harold's_Honeycomb", "harolds_honeycomb", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30431, 0, "Harold's_Honey_Earring", "harolds_honey_earring", 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30431, "harolds_honey_earring",    10,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30431, 14,   5),   -- CHR +5
    (30431,  13,   3),   -- MND +3
    (30431,  2,  15);   -- HP +15

REPLACE INTO `item_basic` VALUES
    (30432, 0, "Harold's_Stinger_Ring", "harolds_stinger_ring", 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (30432, "harolds_stinger_ring",     10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30432,  9,   4),   -- DEX +4
    (30432, 23,   4),   -- ATT +4
    (30432,  8,   3);   -- STR +3


-- Buzzard Barry (lv30-38) — 30433-30435
REPLACE INTO `item_basic` VALUES
    (30433, 0, "Barry's_Broken_Wing", "barrys_broken_wing", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30434, 0, "Barry's_Venom_Gauntlets", "barrys_venom_gauntlets", 1, 59476, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (30434, "barrys_venom_gauntlets",   30,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30434,  1,  12),   -- DEF +12
    (30434,  9,   8),   -- DEX +8
    (30434, 23,  10),   -- ATT +10
    (30434,  8,   6);   -- STR +6

REPLACE INTO `item_basic` VALUES
    (30435, 0, "Barry's_Swarm_Necklace", "barrys_swarm_necklace", 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (30435, "barrys_swarm_necklace",    30,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30435,  8,   8),   -- STR +8
    (30435, 23,  12),   -- ATT +12
    (30435, 25,   8);   -- ACC +8


-- Queen Quentin (lv62-70) — 30436-30438
REPLACE INTO `item_basic` VALUES
    (30436, 0, "Quentin's_Royal_Jelly", "quentins_royal_jelly", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30437, 0, "Quentin's_Royal_Crown", "quentins_royal_crown", 1, 59476, 99, 0, 18000);
REPLACE INTO `item_equipment` VALUES
    (30437, "quentins_royal_crown",     62,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30437,  1,  25),   -- DEF +25
    (30437,  2,  80),   -- HP +80
    (30437,  5,  40),   -- MP +40
    (30437, 14,  15),   -- CHR +15
    (30437,  13,  12);   -- MND +12

REPLACE INTO `item_basic` VALUES
    (30438, 0, "Quentin's_Hivemind_Ring", "quentins_hivemind_ring", 1, 59476, 99, 0, 22000);
REPLACE INTO `item_equipment` VALUES
    (30438, "quentins_hivemind_ring",   62,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30438,  12,  14),   -- INT +14
    (30438,  13,  14),   -- MND +14
    (30438, 28,  18),   -- MATK +18
    (30438, 30,  15),   -- MACC +15
    (30438, 384,   6);   -- Haste +6


-- =========================================================
-- WORMS
-- =========================================================

-- Wiggles Winston (lv1-5) — 30460-30462
REPLACE INTO `item_basic` VALUES
    (30460, 0, "Winston's_Wiggle", "winstons_wiggle", 1, 59476, 99, 0, 20);

REPLACE INTO `item_basic` VALUES
    (30461, 0, "Winston's_Dirt_Ring", "winstons_dirt_ring", 1, 59476, 99, 0, 150);
REPLACE INTO `item_equipment` VALUES
    (30461, "winstons_dirt_ring",        1,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30461,  10,   2),   -- VIT +2
    (30461,  2,  10);   -- HP +10

REPLACE INTO `item_basic` VALUES
    (30462, 0, "Winston's_Earthen_Belt", "winstons_earthen_belt", 1, 59476, 99, 0, 250);
REPLACE INTO `item_equipment` VALUES
    (30462, "winstons_earthen_belt",     1,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30462,  10,   3),   -- VIT +3
    (30462,  8,   2);   -- STR +2


-- Squirmy Sherman (lv18-24) — 30463-30465
REPLACE INTO `item_basic` VALUES
    (30463, 0, "Sherman's_Squirm", "shermans_squirm", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30464, 0, "Sherman's_Subterran_Helm", "shermans_subterran_helm", 1, 59476, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (30464, "shermans_subterran_helm",  18,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30464,  1,   7),   -- DEF +7
    (30464,  10,   5),   -- VIT +5
    (30464,  2,  25),   -- HP +25
    (30464,  8,   4);   -- STR +4

REPLACE INTO `item_basic` VALUES
    (30465, 0, "Sherman's_Tunnel_Earring", "shermans_tunnel_earring", 1, 59476, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (30465, "shermans_tunnel_earring",  18,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30465,  10,   6),   -- VIT +6
    (30465,  8,   5),   -- STR +5
    (30465, 23,   6);   -- ATT +6


-- Earthcrawler Ernest (lv40-48) — 802-804
REPLACE INTO `item_basic` VALUES
    (802, 0, "Ernest's_Earthen_Core", "ernests_earthen_core", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (803, 0, "Ernest's_Burrower_Vest", "ernests_burrower_vest", 1, 59476, 99, 0, 8000);
REPLACE INTO `item_equipment` VALUES
    (803, "ernests_burrower_vest",     40,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (803,  1,  17),   -- DEF +17
    (803,  10,  10),   -- VIT +10
    (803,  8,   8),   -- STR +8
    (803,  2,  55);   -- HP +55

REPLACE INTO `item_basic` VALUES
    (804, 0, "Ernest's_Tremor_Boots", "ernests_tremor_boots", 1, 59476, 99, 0, 11000);
REPLACE INTO `item_equipment` VALUES
    (804, "ernests_tremor_boots",      40,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (804,  1,  14),   -- DEF +14
    (804,  10,   8),   -- VIT +8
    (804,  2,  40),   -- HP +40
    (804, 384,   4);   -- Haste +4


-- =========================================================
-- LIZARDS
-- =========================================================

-- Scaly Sally (lv8-12) — 805-807
REPLACE INTO `item_basic` VALUES
    (805, 0, "Sally's_Scale_Chip", "sallys_scale_chip", 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (806, 0, "Sally's_Scale_Ring", "sallys_scale_ring", 1, 59476, 99, 0, 350);
REPLACE INTO `item_equipment` VALUES
    (806, "sallys_scale_ring",          8,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (806,  9,   4),   -- DEX +4
    (806,  11,   3),   -- AGI +3
    (806, 68,   4);   -- EVA +4

REPLACE INTO `item_basic` VALUES
    (807, 0, "Sally's_Tail_Belt", "sallys_tail_belt", 1, 59476, 99, 0, 550);
REPLACE INTO `item_equipment` VALUES
    (807, "sallys_tail_belt",           8,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (807,  8,   3),   -- STR +3
    (807,  9,   3),   -- DEX +3
    (807,  2,  10);   -- HP +10


-- Cold-blooded Carlos (lv30-36) — 808-810
REPLACE INTO `item_basic` VALUES
    (808, 0, "Carlos's_Cold_Scale", "carloss_cold_scale", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (809, 0, "Carlos's_Reptile_Vest", "carloss_reptile_vest", 1, 59476, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (809, "carloss_reptile_vest",       30,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (809,  1,  13),   -- DEF +13
    (809,  8,   7),   -- STR +7
    (809,  10,   7),   -- VIT +7
    (809,  2,  35);   -- HP +35

REPLACE INTO `item_basic` VALUES
    (810, 0, "Carlos's_Venom_Earring", "carloss_venom_earring", 1, 59476, 99, 0, 6500);
REPLACE INTO `item_equipment` VALUES
    (810, "carloss_venom_earring",      30,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (810,  9,   7),   -- DEX +7
    (810,  11,   6),   -- AGI +6
    (810, 23,   8);   -- ATT +8


-- Basilisk Boris (lv52-60) — 811-813
REPLACE INTO `item_basic` VALUES
    (811, 0, "Boris's_Basilisk_Eye", "boriss_basilisk_eye", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (812, 0, "Boris's_Granite_Carapace", "boriss_granite_carapace", 1, 59476, 99, 0, 13000);
REPLACE INTO `item_equipment` VALUES
    (812, "boriss_granite_carapace",    52,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (812,  1,  25),   -- DEF +25
    (812,  10,  14),   -- VIT +14
    (812,  8,  12),   -- STR +12
    (812,  2,  70),   -- HP +70
    (812, 29,  10);   -- MDEF +10

REPLACE INTO `item_basic` VALUES
    (813, 0, "Boris's_Stone_Gaze_Ring", "boriss_stone_gaze_ring", 1, 59476, 99, 0, 17000);
REPLACE INTO `item_equipment` VALUES
    (813, "boriss_stone_gaze_ring",     52,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (813,  8,  12),   -- STR +12
    (813,  10,  12),   -- VIT +12
    (813,  1,  14),   -- DEF +14
    (813, 384,   5);   -- Haste +5


-- =========================================================
-- THE JIMS (goblin comedy duo)
-- =========================================================

-- Little Jim (lv25-32, he's enormous) — 30520-30522
REPLACE INTO `item_basic` VALUES
    (30520, 0, "Little_Jim's_Big_Trophy", "little_jims_big_trophy", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30521, 0, "Little_Jim's_Big_Boots", "little_jims_big_boots", 1, 59476, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (30521, "little_jims_big_boots",    25,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30521,  1,  12),   -- DEF +12
    (30521,  8,   8),   -- STR +8
    (30521,  10,   8),   -- VIT +8
    (30521,  2,  35);   -- HP +35

REPLACE INTO `item_basic` VALUES
    (30522, 0, "Little_Jim's_Big_Ring", "little_jims_big_ring", 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (30522, "little_jims_big_ring",     25,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30522,  8,   8),   -- STR +8
    (30522,  10,   8),   -- VIT +8
    (30522, 23,  10);   -- ATT +10


-- Big Jim (lv25-32, he's tiny) — 30523-30525
REPLACE INTO `item_basic` VALUES
    (30523, 0, "Big_Jim's_Small_Trophy", "big_jims_small_trophy", 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30524, 0, "Big_Jim's_Small_Hat", "big_jims_small_hat", 1, 59476, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (30524, "big_jims_small_hat",       25,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30524,  1,   8),   -- DEF +8
    (30524,  11,   8),   -- AGI +8
    (30524,  9,   8),   -- DEX +8
    (30524, 68,  10);   -- EVA +10

REPLACE INTO `item_basic` VALUES
    (30525, 0, "Big_Jim's_Small_Ring", "big_jims_small_ring", 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (30525, "big_jims_small_ring",      25,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30525,  11,   8),   -- AGI +8
    (30525,  9,   8),   -- DEX +8
    (30525, 25,  10);   -- ACC +10


-- =============================================================================
-- VERIFY  (run manually to confirm rows landed)
-- =============================================================================
-- SELECT i.itemid, i.name, e.level, e.slot, e.jobs
--   FROM item_basic i
--   LEFT JOIN item_equipment e ON i.itemid = e.itemId
--  WHERE i.itemid BETWEEN 792 AND 30999
--  ORDER BY i.itemid;
--
-- SELECT * FROM item_mods WHERE itemId BETWEEN 792 AND 30999 ORDER BY itemId, modId;
-- ============================================================
-- AUTO-GENERATED: 152 new named rares (IDs 336-791)
-- ============================================================

-- Wooly Winifred trophy + gear
REPLACE INTO `item_basic` VALUES (336, 0, 'Winifred\'s Fleece', 'WnfrdFlce', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (337, 0, 'Winifred\'s Wool Cap', 'WnfrdWCap', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (337, 'WnfrdWCap', 28, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (337, 1, 14);
REPLACE INTO `item_mods` VALUES (337, 14, 6);
REPLACE INTO `item_mods` VALUES (337, 2, 30);
REPLACE INTO `item_basic` VALUES (338, 0, 'Winifred\'s Wool Mittens', 'WnfrdWMit', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (338, 'WnfrdWMit', 28, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (338, 1, 10);
REPLACE INTO `item_mods` VALUES (338, 12, 4);
REPLACE INTO `item_mods` VALUES (338, 29, 10);

-- Bouncy Beatrice trophy + gear
REPLACE INTO `item_basic` VALUES (339, 0, 'Beatrice\'s Lucky Foot', 'BtrcesFt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (340, 0, 'Beatrice\'s Sprinting Shoes', 'BtrceSShoe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (340, 'BtrceSShoe', 22, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (340, 1, 8);
REPLACE INTO `item_mods` VALUES (340, 23, 6);
REPLACE INTO `item_mods` VALUES (340, 68, 12);
REPLACE INTO `item_basic` VALUES (341, 0, 'Beatrice\'s Hopping Hakama', 'BtrceHHkm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (341, 'BtrceHHkm', 22, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (341, 1, 11);
REPLACE INTO `item_mods` VALUES (341, 13, 5);
REPLACE INTO `item_mods` VALUES (341, 25, 8);

-- Crushing Clyde trophy + gear
REPLACE INTO `item_basic` VALUES (342, 0, 'Clyde\'s Shell Shard', 'ClydeShrd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (343, 0, 'Clyde\'s Carapace Gauntlets', 'ClydeCGnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (343, 'ClydeCGnt', 32, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (343, 1, 15);
REPLACE INTO `item_mods` VALUES (343, 14, 7);
REPLACE INTO `item_mods` VALUES (343, 2, 40);
REPLACE INTO `item_basic` VALUES (344, 0, 'Clyde\'s Pincer Belt', 'ClydePBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (344, 'ClydePBlt', 32, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (344, 1, 6);
REPLACE INTO `item_mods` VALUES (344, 12, 5);
REPLACE INTO `item_mods` VALUES (344, 29, 12);

-- Sneaky Seraphine trophy + gear
REPLACE INTO `item_basic` VALUES (345, 0, 'Seraphine\'s Stolen Trinket', 'SrphnTrnk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (346, 0, 'Seraphine\'s Sneak Boots', 'SrphnSBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (346, 'SrphnSBts', 35, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (346, 1, 9);
REPLACE INTO `item_mods` VALUES (346, 23, 7);
REPLACE INTO `item_mods` VALUES (346, 68, 14);
REPLACE INTO `item_basic` VALUES (347, 0, 'Seraphine\'s Rogue Ring', 'SrphnRRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (347, 'SrphnRRng', 35, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (347, 13, 5);
REPLACE INTO `item_mods` VALUES (347, 25, 10);
REPLACE INTO `item_mods` VALUES (347, 29, 8);

-- Crackling Cordelia trophy + gear
REPLACE INTO `item_basic` VALUES (348, 0, 'Cordelia\'s Whisker', 'CrdelaWhsk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (349, 0, 'Cordelia\'s Static Earring', 'CrdelaEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (349, 'CrdelaEar', 45, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (349, 25, 6);
REPLACE INTO `item_mods` VALUES (349, 28, 12);
REPLACE INTO `item_mods` VALUES (349, 30, 8);
REPLACE INTO `item_basic` VALUES (350, 0, 'Cordelia\'s Shock Mantle', 'CrdelasMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (350, 'CrdelasMnt', 45, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (350, 1, 10);
REPLACE INTO `item_mods` VALUES (350, 12, 5);
REPLACE INTO `item_mods` VALUES (350, 29, 14);

-- Ferocious Frederica trophy + gear
REPLACE INTO `item_basic` VALUES (351, 0, 'Frederica\'s Fang', 'FrdrcaFng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (352, 0, 'Frederica\'s Predator Cloak', 'FrdrcaClk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (352, 'FrdrcaClk', 52, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (352, 1, 12);
REPLACE INTO `item_mods` VALUES (352, 12, 7);
REPLACE INTO `item_mods` VALUES (352, 29, 18);
REPLACE INTO `item_basic` VALUES (353, 0, 'Frederica\'s Hunting Hose', 'FrdrcaHse', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (353, 'FrdrcaHse', 52, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (353, 1, 13);
REPLACE INTO `item_mods` VALUES (353, 23, 6);
REPLACE INTO `item_mods` VALUES (353, 68, 15);

-- Manic Millicent trophy + gear
REPLACE INTO `item_basic` VALUES (354, 0, 'Millicent\'s Dried Petal', 'MllcntPtl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (355, 0, 'Millicent\'s Bloom Headband', 'MllcntHbd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (355, 'MllcntHbd', 28, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (355, 1, 9);
REPLACE INTO `item_mods` VALUES (355, 68, 6);
REPLACE INTO `item_mods` VALUES (355, 9, 35);
REPLACE INTO `item_basic` VALUES (356, 0, 'Millicent\'s Garden Gloves', 'MllcntGGl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (356, 'MllcntGGl', 28, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (356, 1, 7);
REPLACE INTO `item_mods` VALUES (356, 25, 5);
REPLACE INTO `item_mods` VALUES (356, 28, 10);

-- Brutal Brendan trophy + gear
REPLACE INTO `item_basic` VALUES (357, 0, 'Brendan\'s Carapace Chip', 'BrndnCrpC', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (358, 0, 'Brendan\'s Armored Breastplate', 'BrndnABpl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (358, 'BrndnABpl', 40, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (358, 1, 22);
REPLACE INTO `item_mods` VALUES (358, 14, 7);
REPLACE INTO `item_mods` VALUES (358, 2, 55);
REPLACE INTO `item_basic` VALUES (359, 0, 'Brendan\'s Iron Greaves', 'BrndnIGrv', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (359, 'BrndnIGrv', 40, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (359, 1, 13);
REPLACE INTO `item_mods` VALUES (359, 12, 5);
REPLACE INTO `item_mods` VALUES (359, 29, 12);

-- Gale Gertrude trophy + gear
REPLACE INTO `item_basic` VALUES (360, 0, 'Gertrude\'s Tailfeather', 'GrtrdTlft', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (361, 0, 'Gertrude\'s Galeforce Mantle', 'GrtrdGMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (361, 'GrtrdGMnt', 42, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (361, 1, 11);
REPLACE INTO `item_mods` VALUES (361, 23, 7);
REPLACE INTO `item_mods` VALUES (361, 68, 16);
REPLACE INTO `item_basic` VALUES (362, 0, 'Gertrude\'s Windrunner Shoes', 'GrtrdWShs', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (362, 'GrtrdWShs', 42, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (362, 1, 10);
REPLACE INTO `item_mods` VALUES (362, 13, 6);
REPLACE INTO `item_mods` VALUES (362, 25, 12);

-- Venomous Valentina trophy + gear
REPLACE INTO `item_basic` VALUES (363, 0, 'Valentina\'s Stinger', 'VlntnStng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (364, 0, 'Valentina\'s Hexed Hairpin', 'VlntnHHpn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (364, 'VlntnHHpn', 36, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (364, 1, 8);
REPLACE INTO `item_mods` VALUES (364, 25, 6);
REPLACE INTO `item_mods` VALUES (364, 30, 10);
REPLACE INTO `item_basic` VALUES (365, 0, 'Valentina\'s Venom Ring', 'VlntnVRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (365, 'VlntnVRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (365, 25, 5);
REPLACE INTO `item_mods` VALUES (365, 28, 12);
REPLACE INTO `item_mods` VALUES (365, 9, 30);

-- Deep Dweller Deidre trophy + gear
REPLACE INTO `item_basic` VALUES (366, 0, 'Deidre\'s Earthen Core', 'DdrErtCr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (367, 0, 'Deidre\'s Burrower\'s Boots', 'DdrBrwBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (367, 'DdrBrwBts', 44, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (367, 1, 12);
REPLACE INTO `item_mods` VALUES (367, 14, 6);
REPLACE INTO `item_mods` VALUES (367, 2, 40);
REPLACE INTO `item_basic` VALUES (368, 0, 'Deidre\'s Mudskin Belt', 'DdrMdsBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (368, 'DdrMdsBlt', 44, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (368, 1, 7);
REPLACE INTO `item_mods` VALUES (368, 12, 5);
REPLACE INTO `item_mods` VALUES (368, 29, 14);

-- Venerable Vincenzo trophy + gear
REPLACE INTO `item_basic` VALUES (369, 0, 'Vincenzo\'s Scale', 'VncznScle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (370, 0, 'Vincenzo\'s Scaled Cuisses', 'VncznSCss', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (370, 'VncznSCss', 50, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (370, 1, 15);
REPLACE INTO `item_mods` VALUES (370, 14, 7);
REPLACE INTO `item_mods` VALUES (370, 2, 50);
REPLACE INTO `item_basic` VALUES (371, 0, 'Vincenzo\'s Tough Tail Ring', 'VncznTRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (371, 'VncznTRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (371, 1, 4);
REPLACE INTO `item_mods` VALUES (371, 12, 6);
REPLACE INTO `item_mods` VALUES (371, 29, 14);

-- Grunt Gideon trophy + gear
REPLACE INTO `item_basic` VALUES (372, 0, 'Gideon\'s Rusty Axe', 'GdnRAxe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (373, 0, 'Gideon\'s Studded Armband', 'GdnSArmb', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (373, 'GdnSArmb', 10, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (373, 1, 6);
REPLACE INTO `item_mods` VALUES (373, 12, 3);
REPLACE INTO `item_mods` VALUES (373, 29, 6);
REPLACE INTO `item_basic` VALUES (374, 0, 'Gideon\'s Grunt Belt', 'GdnGBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (374, 'GdnGBlt', 10, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (374, 1, 3);
REPLACE INTO `item_mods` VALUES (374, 14, 2);
REPLACE INTO `item_mods` VALUES (374, 2, 15);

-- Sergeant Sven trophy + gear
REPLACE INTO `item_basic` VALUES (375, 0, 'Sven\'s Campaign Medal', 'SvnCMdl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (376, 0, 'Sven\'s Warchief Helm', 'SvnWCHlm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (376, 'SvnWCHlm', 22, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (376, 1, 11);
REPLACE INTO `item_mods` VALUES (376, 12, 5);
REPLACE INTO `item_mods` VALUES (376, 14, 4);
REPLACE INTO `item_basic` VALUES (377, 0, 'Sven\'s Battle Mantle', 'SvnBtlMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (377, 'SvnBtlMnt', 22, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (377, 1, 8);
REPLACE INTO `item_mods` VALUES (377, 29, 10);
REPLACE INTO `item_mods` VALUES (377, 12, 4);

-- Raging Reginald trophy + gear
REPLACE INTO `item_basic` VALUES (378, 0, 'Reginald\'s Battle Standard', 'RgnldStnd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (379, 0, 'Reginald\'s Warbound Hauberk', 'RgnldWHbk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (379, 'RgnldWHbk', 35, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (379, 1, 20);
REPLACE INTO `item_mods` VALUES (379, 12, 7);
REPLACE INTO `item_mods` VALUES (379, 2, 60);
REPLACE INTO `item_basic` VALUES (380, 0, 'Reginald\'s Crusher Greaves', 'RgnldCGrv', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (380, 'RgnldCGrv', 35, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (380, 1, 12);
REPLACE INTO `item_mods` VALUES (380, 14, 6);
REPLACE INTO `item_mods` VALUES (380, 29, 14);

-- Overlord Ophelia trophy + gear
REPLACE INTO `item_basic` VALUES (381, 0, 'Ophelia\'s Warlord Crown', 'OphlCrwn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (382, 0, 'Ophelia\'s Dominion Plate', 'OphlDPlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (382, 'OphlDPlt', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (382, 1, 26);
REPLACE INTO `item_mods` VALUES (382, 12, 9);
REPLACE INTO `item_mods` VALUES (382, 14, 8);
REPLACE INTO `item_mods` VALUES (382, 2, 80);
REPLACE INTO `item_basic` VALUES (383, 0, 'Ophelia\'s Conquest Ring', 'OphlCRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (383, 'OphlCRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (383, 12, 6);
REPLACE INTO `item_mods` VALUES (383, 29, 16);
REPLACE INTO `item_mods` VALUES (383, 2, 25);

-- Fledgling Fenwick trophy + gear
REPLACE INTO `item_basic` VALUES (384, 0, 'Fenwick\'s Broken Talon', 'FnwkTln', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (385, 0, 'Fenwick\'s Initiate Sandals', 'FnwkISndl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (385, 'FnwkISndl', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (385, 1, 5);
REPLACE INTO `item_mods` VALUES (385, 23, 3);
REPLACE INTO `item_mods` VALUES (385, 68, 6);
REPLACE INTO `item_basic` VALUES (386, 0, 'Fenwick\'s Novice Sash', 'FnwkNSsh', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (386, 'FnwkNSsh', 10, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (386, 1, 3);
REPLACE INTO `item_mods` VALUES (386, 13, 2);
REPLACE INTO `item_mods` VALUES (386, 25, 4);

-- Devout Delilah trophy + gear
REPLACE INTO `item_basic` VALUES (387, 0, 'Delilah\'s Prayer Beads', 'DllhPBds', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (388, 0, 'Delilah\'s Chanter\'s Collar', 'DllhCCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (388, 'DllhCCll', 22, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (388, 68, 5);
REPLACE INTO `item_mods` VALUES (388, 9, 30);
REPLACE INTO `item_mods` VALUES (388, 30, 6);
REPLACE INTO `item_basic` VALUES (389, 0, 'Delilah\'s Sacred Earring', 'DllhSEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (389, 'DllhSEar', 22, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (389, 25, 4);
REPLACE INTO `item_mods` VALUES (389, 28, 8);
REPLACE INTO `item_mods` VALUES (389, 9, 20);

-- High Priest Horatio trophy + gear
REPLACE INTO `item_basic` VALUES (390, 0, 'Horatio\'s Holy Relic', 'HrtHlyRlc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (391, 0, 'Horatio\'s Zealot\'s Mitre', 'HrtZMtre', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (391, 'HrtZMtre', 35, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (391, 1, 10);
REPLACE INTO `item_mods` VALUES (391, 68, 7);
REPLACE INTO `item_mods` VALUES (391, 9, 50);
REPLACE INTO `item_basic` VALUES (392, 0, 'Horatio\'s Faith Ring', 'HrtFthRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (392, 'HrtFthRng', 35, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (392, 68, 5);
REPLACE INTO `item_mods` VALUES (392, 30, 10);
REPLACE INTO `item_mods` VALUES (392, 9, 25);

-- Divine Diomedea trophy + gear
REPLACE INTO `item_basic` VALUES (393, 0, 'Diomedea\'s Golden Feather', 'DmdaGFthr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (394, 0, 'Diomedea\'s Ascension Robe', 'DmdaARbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (394, 'DmdaARbe', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (394, 1, 16);
REPLACE INTO `item_mods` VALUES (394, 68, 9);
REPLACE INTO `item_mods` VALUES (394, 9, 80);
REPLACE INTO `item_mods` VALUES (394, 30, 10);
REPLACE INTO `item_basic` VALUES (395, 0, 'Diomedea\'s Halo Headband', 'DmdaHHbd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (395, 'DmdaHHbd', 50, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (395, 1, 11);
REPLACE INTO `item_mods` VALUES (395, 25, 7);
REPLACE INTO `item_mods` VALUES (395, 28, 14);
REPLACE INTO `item_mods` VALUES (395, 9, 40);

-- Copper Cornelius trophy + gear
REPLACE INTO `item_basic` VALUES (396, 0, 'Cornelius\'s Copper Scale', 'CrnlsCpSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (397, 0, 'Cornelius\'s Shell Shield Shard', 'CrnlsSShr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (397, 'CrnlsSShr', 10, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (397, 1, 7);
REPLACE INTO `item_mods` VALUES (397, 14, 3);
REPLACE INTO `item_mods` VALUES (397, 2, 20);
REPLACE INTO `item_basic` VALUES (398, 0, 'Cornelius\'s Miner\'s Anklet', 'CrnlsAnkl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (398, 'CrnlsAnkl', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (398, 1, 5);
REPLACE INTO `item_mods` VALUES (398, 12, 2);
REPLACE INTO `item_mods` VALUES (398, 14, 2);

-- Silver Sylvester trophy + gear
REPLACE INTO `item_basic` VALUES (399, 0, 'Sylvester\'s Silver Ingot', 'SlvstIngot', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (400, 0, 'Sylvester\'s Polished Cuirass', 'SlvstPCrs', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (400, 'SlvstPCrs', 22, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (400, 1, 17);
REPLACE INTO `item_mods` VALUES (400, 14, 5);
REPLACE INTO `item_mods` VALUES (400, 2, 45);
REPLACE INTO `item_basic` VALUES (401, 0, 'Sylvester\'s Guard Collar', 'SlvstGCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (401, 'SlvstGCll', 22, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (401, 1, 5);
REPLACE INTO `item_mods` VALUES (401, 14, 4);
REPLACE INTO `item_mods` VALUES (401, 29, 6);

-- Boulder Basil trophy + gear
REPLACE INTO `item_basic` VALUES (402, 0, 'Basil\'s Boulder Chip', 'BaslBChip', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (403, 0, 'Basil\'s Fortress Greaves', 'BaslFGrv', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (403, 'BaslFGrv', 35, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (403, 1, 14);
REPLACE INTO `item_mods` VALUES (403, 14, 7);
REPLACE INTO `item_mods` VALUES (403, 2, 50);
REPLACE INTO `item_basic` VALUES (404, 0, 'Basil\'s Rampart Ring', 'BaslRRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (404, 'BaslRRng', 35, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (404, 1, 5);
REPLACE INTO `item_mods` VALUES (404, 14, 5);
REPLACE INTO `item_mods` VALUES (404, 29, 8);

-- Diamond Desmond trophy + gear
REPLACE INTO `item_basic` VALUES (405, 0, 'Desmond\'s Diamond Carapace', 'DsmndDCrp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (406, 0, 'Desmond\'s Ironclad Hauberk', 'DsmndIHbk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (406, 'DsmndIHbk', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (406, 1, 27);
REPLACE INTO `item_mods` VALUES (406, 14, 9);
REPLACE INTO `item_mods` VALUES (406, 2, 90);
REPLACE INTO `item_mods` VALUES (406, 29, 10);
REPLACE INTO `item_basic` VALUES (407, 0, 'Desmond\'s Warden\'s Visor', 'DsmndWVsr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (407, 'DsmndWVsr', 50, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (407, 1, 16);
REPLACE INTO `item_mods` VALUES (407, 14, 7);
REPLACE INTO `item_mods` VALUES (407, 2, 55);
REPLACE INTO `item_mods` VALUES (407, 29, 8);

-- Flittering Fiona trophy + gear
REPLACE INTO `item_basic` VALUES (408, 0, 'Fiona\'s Membrane Scrap', 'FnaMmbScp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (409, 0, 'Fiona\'s Wing Earring', 'FnaWngEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (409, 'FnaWngEar', 8, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (409, 23, 3);
REPLACE INTO `item_mods` VALUES (409, 68, 5);
REPLACE INTO `item_mods` VALUES (409, 13, 2);
REPLACE INTO `item_basic` VALUES (410, 0, 'Fiona\'s Night Sandals', 'FnaNgtSnd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (410, 'FnaNgtSnd', 8, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (410, 1, 4);
REPLACE INTO `item_mods` VALUES (410, 23, 3);
REPLACE INTO `item_mods` VALUES (410, 68, 6);

-- Echo Edgar trophy + gear
REPLACE INTO `item_basic` VALUES (411, 0, 'Edgar\'s Sonic Wing', 'EdgrSnWng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (412, 0, 'Edgar\'s Echolocation Earring', 'EdgrEEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (412, 'EdgrEEar', 18, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (412, 13, 4);
REPLACE INTO `item_mods` VALUES (412, 25, 7);
REPLACE INTO `item_mods` VALUES (412, 23, 4);
REPLACE INTO `item_basic` VALUES (413, 0, 'Edgar\'s Shadow Mitts', 'EdgrShMtt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (413, 'EdgrShMtt', 18, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (413, 1, 8);
REPLACE INTO `item_mods` VALUES (413, 23, 5);
REPLACE INTO `item_mods` VALUES (413, 68, 10);

-- Vampiric Valerian trophy + gear
REPLACE INTO `item_basic` VALUES (414, 0, 'Valerian\'s Blood Fang', 'VlrnBlFng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (415, 0, 'Valerian\'s Night Cowl', 'VlrnNtCwl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (415, 'VlrnNtCwl', 32, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (415, 1, 10);
REPLACE INTO `item_mods` VALUES (415, 23, 6);
REPLACE INTO `item_mods` VALUES (415, 68, 12);
REPLACE INTO `item_basic` VALUES (416, 0, 'Valerian\'s Vampire Ring', 'VlrnVRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (416, 'VlrnVRng', 32, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (416, 23, 4);
REPLACE INTO `item_mods` VALUES (416, 13, 5);
REPLACE INTO `item_mods` VALUES (416, 25, 9);

-- Ancient Araminta trophy + gear
REPLACE INTO `item_basic` VALUES (417, 0, 'Araminta\'s Ancient Fang', 'ArmntAFng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (418, 0, 'Araminta\'s Dusk Mantle', 'ArmntDMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (418, 'ArmntDMnt', 45, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (418, 1, 11);
REPLACE INTO `item_mods` VALUES (418, 23, 8);
REPLACE INTO `item_mods` VALUES (418, 68, 18);
REPLACE INTO `item_basic` VALUES (419, 0, 'Araminta\'s Haste Anklet', 'ArmntHAnk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (419, 'ArmntHAnk', 45, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (419, 1, 10);
REPLACE INTO `item_mods` VALUES (419, 23, 6);
REPLACE INTO `item_mods` VALUES (419, 384, 4);

-- Slithering Silas trophy + gear
REPLACE INTO `item_basic` VALUES (420, 0, 'Silas\'s Shed Scale', 'SlsShdScl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (421, 0, 'Silas\'s Snakeskin Sandals', 'SlsSnkSnd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (421, 'SlsSnkSnd', 8, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (421, 1, 4);
REPLACE INTO `item_mods` VALUES (421, 23, 3);
REPLACE INTO `item_mods` VALUES (421, 68, 5);
REPLACE INTO `item_basic` VALUES (422, 0, 'Silas\'s Coil Sash', 'SlsColSsh', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (422, 'SlsColSsh', 8, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (422, 1, 3);
REPLACE INTO `item_mods` VALUES (422, 12, 2);
REPLACE INTO `item_mods` VALUES (422, 29, 4);

-- Hypnotic Heloise trophy + gear
REPLACE INTO `item_basic` VALUES (423, 0, 'Heloise\'s Mesmer Scale', 'HlseMmSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (424, 0, 'Heloise\'s Charmer\'s Collar', 'HlseCCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (424, 'HlseCCll', 20, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (424, 28, 5);
REPLACE INTO `item_mods` VALUES (424, 68, 4);
REPLACE INTO `item_mods` VALUES (424, 9, 20);
REPLACE INTO `item_basic` VALUES (425, 0, 'Heloise\'s Luring Earring', 'HlseLEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (425, 'HlseLEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (425, 28, 4);
REPLACE INTO `item_mods` VALUES (425, 25, 3);
REPLACE INTO `item_mods` VALUES (425, 30, 7);

-- Constrictor Cressida trophy + gear
REPLACE INTO `item_basic` VALUES (426, 0, 'Cressida\'s Crushing Coil', 'CrsdCrCl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (427, 0, 'Cressida\'s Squeeze Gloves', 'CrsdSqGlv', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (427, 'CrsdSqGlv', 34, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (427, 1, 11);
REPLACE INTO `item_mods` VALUES (427, 12, 6);
REPLACE INTO `item_mods` VALUES (427, 29, 12);
REPLACE INTO `item_basic` VALUES (428, 0, 'Cressida\'s Binding Belt', 'CrsdBBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (428, 'CrsdBBlt', 34, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (428, 1, 6);
REPLACE INTO `item_mods` VALUES (428, 14, 5);
REPLACE INTO `item_mods` VALUES (428, 2, 35);

-- Venom Duchess Viviane trophy + gear
REPLACE INTO `item_basic` VALUES (429, 0, 'Viviane\'s Venom Sac', 'VvneVnSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (430, 0, 'Viviane\'s Toxic Tiara', 'VvneTxTar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (430, 'VvneTxTar', 48, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (430, 1, 12);
REPLACE INTO `item_mods` VALUES (430, 25, 7);
REPLACE INTO `item_mods` VALUES (430, 28, 14);
REPLACE INTO `item_mods` VALUES (430, 30, 8);
REPLACE INTO `item_basic` VALUES (431, 0, 'Viviane\'s Serpent Ring', 'VvneSrpRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (431, 'VvneSrpRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (431, 25, 5);
REPLACE INTO `item_mods` VALUES (431, 30, 10);
REPLACE INTO `item_mods` VALUES (431, 9, 30);

-- Buzzing Barnabas trophy + gear
REPLACE INTO `item_basic` VALUES (432, 0, 'Barnabas\'s Compound Eye', 'BrnbsCmEy', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (433, 0, 'Barnabas\'s Wing Brooch', 'BrnbsWBrc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (433, 'BrnbsWBrc', 10, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (433, 13, 3);
REPLACE INTO `item_mods` VALUES (433, 25, 5);
REPLACE INTO `item_mods` VALUES (433, 23, 2);
REPLACE INTO `item_basic` VALUES (434, 0, 'Barnabas\'s Buzzer Boots', 'BrnbsBBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (434, 'BrnbsBBts', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (434, 1, 5);
REPLACE INTO `item_mods` VALUES (434, 23, 3);
REPLACE INTO `item_mods` VALUES (434, 68, 7);

-- Droning Dorothea trophy + gear
REPLACE INTO `item_basic` VALUES (435, 0, 'Dorothea\'s Drone Claw', 'DrthaDrnCl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (436, 0, 'Dorothea\'s Carapace Vest', 'DrthaCV', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (436, 'DrthaCV', 25, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (436, 1, 14);
REPLACE INTO `item_mods` VALUES (436, 14, 4);
REPLACE INTO `item_mods` VALUES (436, 2, 40);
REPLACE INTO `item_basic` VALUES (437, 0, 'Dorothea\'s Hum Ring', 'DrthaHRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (437, 'DrthaHRng', 25, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (437, 13, 4);
REPLACE INTO `item_mods` VALUES (437, 25, 8);
REPLACE INTO `item_mods` VALUES (437, 29, 6);

-- Plague Bearer Percival trophy + gear
REPLACE INTO `item_basic` VALUES (438, 0, 'Percival\'s Plague Gland', 'PrcvlPlGl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (439, 0, 'Percival\'s Pestilent Mask', 'PrcvlPMsk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (439, 'PrcvlPMsk', 38, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (439, 1, 11);
REPLACE INTO `item_mods` VALUES (439, 25, 5);
REPLACE INTO `item_mods` VALUES (439, 28, 10);
REPLACE INTO `item_basic` VALUES (440, 0, 'Percival\'s Blight Mantle', 'PrcvlBMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (440, 'PrcvlBMnt', 38, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (440, 1, 9);
REPLACE INTO `item_mods` VALUES (440, 12, 5);
REPLACE INTO `item_mods` VALUES (440, 29, 12);

-- Swarm Queen Sophonias trophy + gear
REPLACE INTO `item_basic` VALUES (441, 0, 'Sophonias\'s Royal Jelly', 'SphnsRJly', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (442, 0, 'Sophonias\'s Hivemind Helm', 'SphnHMHlm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (442, 'SphnHMHlm', 52, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (442, 1, 14);
REPLACE INTO `item_mods` VALUES (442, 25, 8);
REPLACE INTO `item_mods` VALUES (442, 28, 16);
REPLACE INTO `item_mods` VALUES (442, 9, 50);
REPLACE INTO `item_basic` VALUES (443, 0, 'Sophonias\'s Drone Tassets', 'SphnDTsst', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (443, 'SphnDTsst', 52, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (443, 1, 15);
REPLACE INTO `item_mods` VALUES (443, 14, 7);
REPLACE INTO `item_mods` VALUES (443, 2, 60);
REPLACE INTO `item_mods` VALUES (443, 1, 3);

-- Gnawing Nathaniel trophy + gear
REPLACE INTO `item_basic` VALUES (444, 0, 'Nathaniel\'s Gnawed Bone', 'NthnlBone', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (445, 0, 'Nathaniel\'s Rotting Armband', 'NthnlRArmb', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (445, 'NthnlRArmb', 14, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (445, 1, 5);
REPLACE INTO `item_mods` VALUES (445, 12, 3);
REPLACE INTO `item_mods` VALUES (445, 29, 6);
REPLACE INTO `item_basic` VALUES (446, 0, 'Nathaniel\'s Grave Sandals', 'NthnlGSnd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (446, 'NthnlGSnd', 14, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (446, 1, 4);
REPLACE INTO `item_mods` VALUES (446, 23, 2);
REPLACE INTO `item_mods` VALUES (446, 68, 5);

-- Festering Francesca trophy + gear
REPLACE INTO `item_basic` VALUES (447, 0, 'Francesca\'s Fetid Finger', 'FrncsFFng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (448, 0, 'Francesca\'s Blight Earring', 'FrncsBEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (448, 'FrncsBEar', 26, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (448, 25, 4);
REPLACE INTO `item_mods` VALUES (448, 28, 8);
REPLACE INTO `item_mods` VALUES (448, 30, 5);
REPLACE INTO `item_basic` VALUES (449, 0, 'Francesca\'s Moaning Ring', 'FrncsRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (449, 'FrncsRng', 26, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (449, 25, 3);
REPLACE INTO `item_mods` VALUES (449, 28, 7);
REPLACE INTO `item_mods` VALUES (449, 9, 20);

-- Hunger Ravaged Hortensia trophy + gear
REPLACE INTO `item_basic` VALUES (450, 0, 'Hortensia\'s Hunger Bile', 'HrtnHBle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (451, 0, 'Hortensia\'s Maw Guard', 'HrtnMwGrd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (451, 'HrtnMwGrd', 38, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (451, 1, 18);
REPLACE INTO `item_mods` VALUES (451, 14, 5);
REPLACE INTO `item_mods` VALUES (451, 2, 55);
REPLACE INTO `item_basic` VALUES (452, 0, 'Hortensia\'s Gnash Gauntlets', 'HrtnGGnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (452, 'HrtnGGnt', 38, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (452, 1, 12);
REPLACE INTO `item_mods` VALUES (452, 12, 6);
REPLACE INTO `item_mods` VALUES (452, 29, 13);

-- Carrion Cornelius trophy + gear
REPLACE INTO `item_basic` VALUES (453, 0, 'Cornelius\'s Carrion Crown', 'CrnlsCCrn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (454, 0, 'Cornelius\'s Death Shroud', 'CrnlsDShr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (454, 'CrnlsDShr', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (454, 1, 22);
REPLACE INTO `item_mods` VALUES (454, 25, 8);
REPLACE INTO `item_mods` VALUES (454, 28, 16);
REPLACE INTO `item_mods` VALUES (454, 9, 60);
REPLACE INTO `item_basic` VALUES (455, 0, 'Cornelius\'s Grave Ring', 'CrnlsGRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (455, 'CrnlsGRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (455, 25, 6);
REPLACE INTO `item_mods` VALUES (455, 30, 12);
REPLACE INTO `item_mods` VALUES (455, 28, 10);

-- Rattling Roderick trophy + gear
REPLACE INTO `item_basic` VALUES (456, 0, 'Roderick\'s Finger Bone', 'RdrckFBne', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (457, 0, 'Roderick\'s Bone Earring', 'RdrckBEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (457, 'RdrckBEar', 12, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (457, 25, 3);
REPLACE INTO `item_mods` VALUES (457, 28, 5);
REPLACE INTO `item_mods` VALUES (457, 9, 10);
REPLACE INTO `item_basic` VALUES (458, 0, 'Roderick\'s Rattling Greaves', 'RdrckRGrv', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (458, 'RdrckRGrv', 12, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (458, 1, 5);
REPLACE INTO `item_mods` VALUES (458, 14, 2);
REPLACE INTO `item_mods` VALUES (458, 2, 15);

-- Cursed Cavendish trophy + gear
REPLACE INTO `item_basic` VALUES (459, 0, 'Cavendish\'s Cursed Skull', 'CvndshSkl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (460, 0, 'Cavendish\'s Hex Collar', 'CvndshHCl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (460, 'CvndshHCl', 26, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (460, 25, 5);
REPLACE INTO `item_mods` VALUES (460, 30, 8);
REPLACE INTO `item_mods` VALUES (460, 9, 25);
REPLACE INTO `item_basic` VALUES (461, 0, 'Cavendish\'s Marrow Earring', 'CvndshEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (461, 'CvndshEar', 26, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (461, 25, 4);
REPLACE INTO `item_mods` VALUES (461, 28, 9);
REPLACE INTO `item_mods` VALUES (461, 30, 6);

-- Bonewalker Benedict trophy + gear
REPLACE INTO `item_basic` VALUES (462, 0, 'Benedict\'s Animated Femur', 'BndctFmur', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (463, 0, 'Benedict\'s Deathmarch Boots', 'BndctDBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (463, 'BndctDBts', 38, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (463, 1, 12);
REPLACE INTO `item_mods` VALUES (463, 25, 5);
REPLACE INTO `item_mods` VALUES (463, 28, 10);
REPLACE INTO `item_basic` VALUES (464, 0, 'Benedict\'s Undying Belt', 'BndctUBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (464, 'BndctUBlt', 38, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (464, 1, 5);
REPLACE INTO `item_mods` VALUES (464, 14, 4);
REPLACE INTO `item_mods` VALUES (464, 2, 30);

-- Lich Lord Leontine trophy + gear
REPLACE INTO `item_basic` VALUES (465, 0, 'Leontine\'s Lich Crystal', 'LntLchCry', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (466, 0, 'Leontine\'s Necromancer\'s Robe', 'LntNRobe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (466, 'LntNRobe', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (466, 1, 18);
REPLACE INTO `item_mods` VALUES (466, 25, 10);
REPLACE INTO `item_mods` VALUES (466, 28, 20);
REPLACE INTO `item_mods` VALUES (466, 9, 80);
REPLACE INTO `item_basic` VALUES (467, 0, 'Leontine\'s Soul Drinker Ring', 'LntSDRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (467, 'LntSDRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (467, 25, 7);
REPLACE INTO `item_mods` VALUES (467, 28, 14);
REPLACE INTO `item_mods` VALUES (467, 30, 12);

-- Snapping Simeon trophy + gear
REPLACE INTO `item_basic` VALUES (468, 0, 'Simeon\'s Snapping Claw', 'SmeonClaw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (469, 0, 'Simeon\'s Chitin Wristlets', 'SmeonWrst', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (469, 'SmeonWrst', 14, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (469, 1, 6);
REPLACE INTO `item_mods` VALUES (469, 12, 3);
REPLACE INTO `item_mods` VALUES (469, 29, 7);
REPLACE INTO `item_basic` VALUES (470, 0, 'Simeon\'s Stinger Earring', 'SmeonSEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (470, 'SmeonSEar', 14, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (470, 13, 3);
REPLACE INTO `item_mods` VALUES (470, 25, 5);
REPLACE INTO `item_mods` VALUES (470, 29, 4);

-- Venomous Vespera trophy + gear
REPLACE INTO `item_basic` VALUES (471, 0, 'Vespera\'s Venom Sac', 'VsprVnSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (472, 0, 'Vespera\'s Toxic Mantle', 'VsprTxMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (472, 'VsprTxMnt', 28, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (472, 1, 9);
REPLACE INTO `item_mods` VALUES (472, 25, 5);
REPLACE INTO `item_mods` VALUES (472, 28, 10);
REPLACE INTO `item_basic` VALUES (473, 0, 'Vespera\'s Chitin Belt', 'VsprCBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (473, 'VsprCBlt', 28, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (473, 1, 6);
REPLACE INTO `item_mods` VALUES (473, 14, 4);
REPLACE INTO `item_mods` VALUES (473, 2, 30);

-- Pincer Patriarch Ptolemy trophy + gear
REPLACE INTO `item_basic` VALUES (474, 0, 'Ptolemy\'s Giant Pincer', 'PtlmyPncr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (475, 0, 'Ptolemy\'s Armored Cuisses', 'PtlmyACss', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (475, 'PtlmyACss', 40, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (475, 1, 16);
REPLACE INTO `item_mods` VALUES (475, 14, 6);
REPLACE INTO `item_mods` VALUES (475, 2, 50);
REPLACE INTO `item_basic` VALUES (476, 0, 'Ptolemy\'s Exoskeleton Ring', 'PtlmyERng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (476, 'PtlmyERng', 40, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (476, 1, 4);
REPLACE INTO `item_mods` VALUES (476, 14, 5);
REPLACE INTO `item_mods` VALUES (476, 29, 7);

-- Deathstalker Dagny trophy + gear
REPLACE INTO `item_basic` VALUES (477, 0, 'Dagny\'s Deathstalker Barb', 'DgnyDSBrb', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (478, 0, 'Dagny\'s Reaper\'s Carapace', 'DgnyRCrp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (478, 'DgnyRCrp', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (478, 1, 24);
REPLACE INTO `item_mods` VALUES (478, 12, 8);
REPLACE INTO `item_mods` VALUES (478, 29, 18);
REPLACE INTO `item_mods` VALUES (478, 2, 60);
REPLACE INTO `item_basic` VALUES (479, 0, 'Dagny\'s Fatal Earring', 'DgnyFEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (479, 'DgnyFEar', 52, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (479, 12, 6);
REPLACE INTO `item_mods` VALUES (479, 25, 14);
REPLACE INTO `item_mods` VALUES (479, 29, 12);

-- Weaving Wendy trophy + gear
REPLACE INTO `item_basic` VALUES (480, 0, 'Wendy\'s Silk Thread', 'WndySThrd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (481, 0, 'Wendy\'s Web Ring', 'WndyWRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (481, 'WndyWRng', 10, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (481, 13, 3);
REPLACE INTO `item_mods` VALUES (481, 25, 4);
REPLACE INTO `item_mods` VALUES (481, 23, 2);
REPLACE INTO `item_basic` VALUES (482, 0, 'Wendy\'s Spinner Sandals', 'WndySpSnd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (482, 'WndySpSnd', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (482, 1, 4);
REPLACE INTO `item_mods` VALUES (482, 23, 3);
REPLACE INTO `item_mods` VALUES (482, 68, 6);

-- Sticky Stanislava trophy + gear
REPLACE INTO `item_basic` VALUES (483, 0, 'Stanislava\'s Web Sac', 'StnslaWSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (484, 0, 'Stanislava\'s Gossamer Collar', 'StnslaGCl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (484, 'StnslaGCl', 24, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (484, 13, 4);
REPLACE INTO `item_mods` VALUES (484, 25, 7);
REPLACE INTO `item_mods` VALUES (484, 23, 4);
REPLACE INTO `item_basic` VALUES (485, 0, 'Stanislava\'s Spinner\'s Mitts', 'StnslasMtt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (485, 'StnslasMtt', 24, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (485, 1, 8);
REPLACE INTO `item_mods` VALUES (485, 13, 4);
REPLACE INTO `item_mods` VALUES (485, 25, 8);

-- Ensnaring Eleanor trophy + gear
REPLACE INTO `item_basic` VALUES (486, 0, 'Eleanor\'s Ensnaring Fang', 'ElnrEnFng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (487, 0, 'Eleanor\'s Arachnid Vest', 'ElnrArVst', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (487, 'ElnrArVst', 36, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (487, 1, 17);
REPLACE INTO `item_mods` VALUES (487, 13, 6);
REPLACE INTO `item_mods` VALUES (487, 25, 12);
REPLACE INTO `item_basic` VALUES (488, 0, 'Eleanor\'s Silkweave Belt', 'ElnrSWBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (488, 'ElnrSWBlt', 36, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (488, 1, 5);
REPLACE INTO `item_mods` VALUES (488, 23, 5);
REPLACE INTO `item_mods` VALUES (488, 68, 10);

-- Great Weaver Gwendolyn trophy + gear
REPLACE INTO `item_basic` VALUES (489, 0, 'Gwendolyn\'s Crown Web', 'GwndlnCWeb', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (490, 0, 'Gwendolyn\'s Silken Tiara', 'GwndlnSTar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (490, 'GwndlnSTar', 50, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (490, 1, 13);
REPLACE INTO `item_mods` VALUES (490, 13, 8);
REPLACE INTO `item_mods` VALUES (490, 25, 16);
REPLACE INTO `item_mods` VALUES (490, 23, 6);
REPLACE INTO `item_basic` VALUES (491, 0, 'Gwendolyn\'s Silk Mantle', 'GwndlnSMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (491, 'GwndlnSMnt', 50, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (491, 1, 11);
REPLACE INTO `item_mods` VALUES (491, 13, 6);
REPLACE INTO `item_mods` VALUES (491, 25, 12);
REPLACE INTO `item_mods` VALUES (491, 384, 3);

-- Oozing Oswald trophy + gear
REPLACE INTO `item_basic` VALUES (492, 0, 'Oswald\'s Ooze Sample', 'OswldOze', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (493, 0, 'Oswald\'s Slick Ring', 'OswldSRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (493, 'OswldSRng', 8, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (493, 25, 2);
REPLACE INTO `item_mods` VALUES (493, 30, 4);
REPLACE INTO `item_mods` VALUES (493, 9, 10);
REPLACE INTO `item_basic` VALUES (494, 0, 'Oswald\'s Slime Sandals', 'OswldSlSnd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (494, 'OswldSlSnd', 8, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (494, 1, 3);
REPLACE INTO `item_mods` VALUES (494, 23, 2);
REPLACE INTO `item_mods` VALUES (494, 68, 4);

-- Bubbling Borghild trophy + gear
REPLACE INTO `item_basic` VALUES (495, 0, 'Borghild\'s Bubbling Mass', 'BrghldBMs', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (496, 0, 'Borghild\'s Viscous Collar', 'BrghldVCl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (496, 'BrghldVCl', 20, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (496, 25, 4);
REPLACE INTO `item_mods` VALUES (496, 28, 7);
REPLACE INTO `item_mods` VALUES (496, 9, 20);
REPLACE INTO `item_basic` VALUES (497, 0, 'Borghild\'s Acid Earring', 'BrghldAEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (497, 'BrghldAEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (497, 25, 3);
REPLACE INTO `item_mods` VALUES (497, 28, 6);
REPLACE INTO `item_mods` VALUES (497, 30, 5);

-- Corrosive Callista trophy + gear
REPLACE INTO `item_basic` VALUES (498, 0, 'Callista\'s Acid Sac', 'CllstAcSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (499, 0, 'Callista\'s Dissolving Mitts', 'CllstDMtt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (499, 'CllstDMtt', 34, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (499, 1, 10);
REPLACE INTO `item_mods` VALUES (499, 25, 5);
REPLACE INTO `item_mods` VALUES (499, 28, 10);
REPLACE INTO `item_basic` VALUES (500, 0, 'Callista\'s Caustic Ring', 'CllstCRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (500, 'CllstCRng', 34, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (500, 25, 4);
REPLACE INTO `item_mods` VALUES (500, 30, 8);
REPLACE INTO `item_mods` VALUES (500, 28, 7);

-- Primordial Proteus trophy + gear
REPLACE INTO `item_basic` VALUES (501, 0, 'Proteus\'s Ancient Ooze', 'PrtsAncOz', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (502, 0, 'Proteus\'s Primal Robe', 'PrtsaPRbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (502, 'PrtsaPRbe', 48, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (502, 1, 16);
REPLACE INTO `item_mods` VALUES (502, 25, 9);
REPLACE INTO `item_mods` VALUES (502, 28, 18);
REPLACE INTO `item_mods` VALUES (502, 9, 70);
REPLACE INTO `item_basic` VALUES (503, 0, 'Proteus\'s Shifting Ring', 'PrtsaShRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (503, 'PrtsaShRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (503, 25, 6);
REPLACE INTO `item_mods` VALUES (503, 28, 12);
REPLACE INTO `item_mods` VALUES (503, 30, 10);

-- Splashing Salvatore trophy + gear
REPLACE INTO `item_basic` VALUES (504, 0, 'Salvatore\'s Fin Spine', 'SlvtrFSp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (505, 0, 'Salvatore\'s Gill Earring', 'SlvtrGEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (505, 'SlvtrGEar', 12, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (505, 12, 3);
REPLACE INTO `item_mods` VALUES (505, 29, 5);
REPLACE INTO `item_mods` VALUES (505, 25, 3);
REPLACE INTO `item_basic` VALUES (506, 0, 'Salvatore\'s Wader Boots', 'SlvtrWBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (506, 'SlvtrWBts', 12, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (506, 1, 5);
REPLACE INTO `item_mods` VALUES (506, 23, 3);
REPLACE INTO `item_mods` VALUES (506, 68, 6);

-- Snapping Sicily trophy + gear
REPLACE INTO `item_basic` VALUES (507, 0, 'Sicily\'s Bite Mark', 'ScllyBtMk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (508, 0, 'Sicily\'s River Belt', 'SclllyRBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (508, 'SclllyRBlt', 24, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (508, 1, 5);
REPLACE INTO `item_mods` VALUES (508, 12, 4);
REPLACE INTO `item_mods` VALUES (508, 29, 8);
REPLACE INTO `item_basic` VALUES (509, 0, 'Sicily\'s Scale Mail', 'ScllySMl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (509, 'ScllySMl', 24, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (509, 1, 15);
REPLACE INTO `item_mods` VALUES (509, 14, 4);
REPLACE INTO `item_mods` VALUES (509, 2, 35);

-- Torrent Tiberius trophy + gear
REPLACE INTO `item_basic` VALUES (510, 0, 'Tiberius\'s Torrent Scale', 'TbrsaTSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (511, 0, 'Tiberius\'s Current Mantle', 'TbrsaCMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (511, 'TbrsaCMnt', 36, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (511, 1, 9);
REPLACE INTO `item_mods` VALUES (511, 12, 5);
REPLACE INTO `item_mods` VALUES (511, 29, 12);
REPLACE INTO `item_basic` VALUES (512, 0, 'Tiberius\'s Rushing Ring', 'TbrsaRRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (512, 'TbrsaRRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (512, 12, 4);
REPLACE INTO `item_mods` VALUES (512, 29, 10);
REPLACE INTO `item_mods` VALUES (512, 25, 6);

-- Deep King Delacroix trophy + gear
REPLACE INTO `item_basic` VALUES (513, 0, 'Delacroix\'s King Scale', 'DlcxKgSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (514, 0, 'Delacroix\'s Maelstrom Helm', 'DlcxMHlm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (514, 'DlcxMHlm', 48, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (514, 1, 14);
REPLACE INTO `item_mods` VALUES (514, 12, 7);
REPLACE INTO `item_mods` VALUES (514, 14, 5);
REPLACE INTO `item_mods` VALUES (514, 2, 50);
REPLACE INTO `item_basic` VALUES (515, 0, 'Delacroix\'s Abyssal Ring', 'DlcxAbRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (515, 'DlcxAbRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (515, 12, 6);
REPLACE INTO `item_mods` VALUES (515, 29, 14);
REPLACE INTO `item_mods` VALUES (515, 25, 10);

-- Lumbering Loretta trophy + gear
REPLACE INTO `item_basic` VALUES (516, 0, 'Loretta\'s Long Neck Bone', 'LrttaNBn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (517, 0, 'Loretta\'s Padded Neckguard', 'LrttaPNGd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (517, 'LrttaPNGd', 14, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (517, 1, 4);
REPLACE INTO `item_mods` VALUES (517, 14, 3);
REPLACE INTO `item_mods` VALUES (517, 2, 20);
REPLACE INTO `item_basic` VALUES (518, 0, 'Loretta\'s Stomper Boots', 'LrttaSBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (518, 'LrttaSBts', 14, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (518, 1, 6);
REPLACE INTO `item_mods` VALUES (518, 12, 3);
REPLACE INTO `item_mods` VALUES (518, 14, 2);

-- Thundering Thaddeus trophy + gear
REPLACE INTO `item_basic` VALUES (519, 0, 'Thaddeus\'s Resonance Spine', 'ThdsRSp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (520, 0, 'Thaddeus\'s Stampede Mantle', 'ThadsMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (520, 'ThadsMnt', 28, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (520, 1, 8);
REPLACE INTO `item_mods` VALUES (520, 12, 5);
REPLACE INTO `item_mods` VALUES (520, 29, 10);
REPLACE INTO `item_basic` VALUES (521, 0, 'Thaddeus\'s Trample Belt', 'ThdsaTBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (521, 'ThdsaTBlt', 28, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (521, 1, 6);
REPLACE INTO `item_mods` VALUES (521, 14, 5);
REPLACE INTO `item_mods` VALUES (521, 2, 35);

-- Crasher Crisanta trophy + gear
REPLACE INTO `item_basic` VALUES (522, 0, 'Crisanta\'s Ivory Spine', 'CrsntaISp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (523, 0, 'Crisanta\'s Ivory Cuisses', 'CrsntaICss', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (523, 'CrsntaICss', 40, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (523, 1, 15);
REPLACE INTO `item_mods` VALUES (523, 14, 7);
REPLACE INTO `item_mods` VALUES (523, 2, 55);
REPLACE INTO `item_basic` VALUES (524, 0, 'Crisanta\'s Charge Ring', 'CrsntaCRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (524, 'CrsntaCRng', 40, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (524, 12, 5);
REPLACE INTO `item_mods` VALUES (524, 29, 12);
REPLACE INTO `item_mods` VALUES (524, 14, 4);

-- Patriarch Percival trophy + gear
REPLACE INTO `item_basic` VALUES (525, 0, 'Percival\'s Grand Spine', 'PrcvlGSp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (526, 0, 'Percival\'s Behemoth Plate', 'PrcvlBPlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (526, 'PrcvlBPlt', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (526, 1, 26);
REPLACE INTO `item_mods` VALUES (526, 12, 8);
REPLACE INTO `item_mods` VALUES (526, 14, 9);
REPLACE INTO `item_mods` VALUES (526, 2, 80);
REPLACE INTO `item_basic` VALUES (527, 0, 'Percival\'s Titan\'s Collar', 'PrcvlTCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (527, 'PrcvlTCll', 54, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (527, 14, 7);
REPLACE INTO `item_mods` VALUES (527, 2, 60);
REPLACE INTO `item_mods` VALUES (527, 29, 8);

-- Clumsy Clemens trophy + gear
REPLACE INTO `item_basic` VALUES (528, 0, 'Clemens\'s Club Fragment', 'ClmnsCFrg', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (529, 0, 'Clemens\'s Brutish Armguard', 'ClmnsBAGd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (529, 'ClmnsBAGd', 18, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (529, 1, 8);
REPLACE INTO `item_mods` VALUES (529, 12, 4);
REPLACE INTO `item_mods` VALUES (529, 29, 8);
REPLACE INTO `item_basic` VALUES (530, 0, 'Clemens\'s Stumbler Ring', 'ClmnsStRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (530, 'ClmnsStRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (530, 12, 3);
REPLACE INTO `item_mods` VALUES (530, 14, 3);
REPLACE INTO `item_mods` VALUES (530, 2, 20);

-- Booming Bartholomew trophy + gear
REPLACE INTO `item_basic` VALUES (531, 0, 'Bartholomew\'s Thunder Stone', 'BrthlmTStn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (532, 0, 'Bartholomew\'s Boulderfist Helm', 'BrthlmBHlm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (532, 'BrthlmBHlm', 30, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (532, 1, 12);
REPLACE INTO `item_mods` VALUES (532, 12, 6);
REPLACE INTO `item_mods` VALUES (532, 14, 5);
REPLACE INTO `item_basic` VALUES (533, 0, 'Bartholomew\'s Stone Belt', 'BrthlmSBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (533, 'BrthlmSBlt', 30, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (533, 1, 7);
REPLACE INTO `item_mods` VALUES (533, 12, 5);
REPLACE INTO `item_mods` VALUES (533, 29, 11);

-- Crusher Conrad trophy + gear
REPLACE INTO `item_basic` VALUES (534, 0, 'Conrad\'s Crusher Knuckle', 'CnrdCKnk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (535, 0, 'Conrad\'s Mountain Hauberk', 'CnrdMHbk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (535, 'CnrdMHbk', 42, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (535, 1, 22);
REPLACE INTO `item_mods` VALUES (535, 12, 8);
REPLACE INTO `item_mods` VALUES (535, 14, 6);
REPLACE INTO `item_mods` VALUES (535, 2, 65);
REPLACE INTO `item_basic` VALUES (536, 0, 'Conrad\'s Earthshaker Boots', 'CnrdESBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (536, 'CnrdESBts', 42, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (536, 1, 13);
REPLACE INTO `item_mods` VALUES (536, 12, 6);
REPLACE INTO `item_mods` VALUES (536, 29, 14);

-- Titan Theobald trophy + gear
REPLACE INTO `item_basic` VALUES (537, 0, 'Theobald\'s Titan Core', 'ThbldTCr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (538, 0, 'Theobald\'s Colossus Plate', 'ThbldCPlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (538, 'ThbldCPlt', 55, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (538, 1, 28);
REPLACE INTO `item_mods` VALUES (538, 12, 10);
REPLACE INTO `item_mods` VALUES (538, 14, 9);
REPLACE INTO `item_mods` VALUES (538, 2, 90);
REPLACE INTO `item_basic` VALUES (539, 0, 'Theobald\'s Worldbreaker Ring', 'ThbldWRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (539, 'ThbldWRng', 55, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (539, 12, 8);
REPLACE INTO `item_mods` VALUES (539, 29, 20);
REPLACE INTO `item_mods` VALUES (539, 14, 6);

-- Mossy Mortimer trophy + gear
REPLACE INTO `item_basic` VALUES (540, 0, 'Mortimer\'s Mossy Bark', 'MrtmrMBrk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (541, 0, 'Mortimer\'s Bark Ring', 'MrtmrBkRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (541, 'MrtmrBkRng', 12, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (541, 68, 3);
REPLACE INTO `item_mods` VALUES (541, 9, 15);
REPLACE INTO `item_mods` VALUES (541, 30, 4);
REPLACE INTO `item_basic` VALUES (542, 0, 'Mortimer\'s Root Sandals', 'MrtmrRSnd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (542, 'MrtmrRSnd', 12, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (542, 1, 5);
REPLACE INTO `item_mods` VALUES (542, 68, 2);
REPLACE INTO `item_mods` VALUES (542, 9, 10);

-- Ancient Aldric trophy + gear
REPLACE INTO `item_basic` VALUES (543, 0, 'Aldric\'s Ancient Heartwood', 'AldrHrtwd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (544, 0, 'Aldric\'s Heartwood Earring', 'AldrHEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (544, 'AldrHEar', 26, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (544, 68, 5);
REPLACE INTO `item_mods` VALUES (544, 9, 25);
REPLACE INTO `item_mods` VALUES (544, 30, 7);
REPLACE INTO `item_basic` VALUES (545, 0, 'Aldric\'s Gnarled Collar', 'AldrGCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (545, 'AldrGCll', 26, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (545, 68, 4);
REPLACE INTO `item_mods` VALUES (545, 25, 3);
REPLACE INTO `item_mods` VALUES (545, 9, 20);

-- Elder Grove Elspeth trophy + gear
REPLACE INTO `item_basic` VALUES (546, 0, 'Elspeth\'s Elder Sap', 'ElsptESap', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (547, 0, 'Elspeth\'s Grove Mantle', 'ElsptGMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (547, 'ElsptGMnt', 38, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (547, 1, 10);
REPLACE INTO `item_mods` VALUES (547, 68, 6);
REPLACE INTO `item_mods` VALUES (547, 9, 40);
REPLACE INTO `item_basic` VALUES (548, 0, 'Elspeth\'s Nature\'s Ring', 'ElsptNRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (548, 'ElsptNRng', 38, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (548, 68, 5);
REPLACE INTO `item_mods` VALUES (548, 30, 9);
REPLACE INTO `item_mods` VALUES (548, 9, 30);

-- World Tree Wilhelmina trophy + gear
REPLACE INTO `item_basic` VALUES (549, 0, 'Wilhelmina\'s World Core', 'WhlmnaWCr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (550, 0, 'Wilhelmina\'s Ancient Robe', 'WhlmnaARbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (550, 'WhlmnaARbe', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (550, 1, 17);
REPLACE INTO `item_mods` VALUES (550, 68, 10);
REPLACE INTO `item_mods` VALUES (550, 9, 90);
REPLACE INTO `item_mods` VALUES (550, 28, 16);
REPLACE INTO `item_basic` VALUES (551, 0, 'Wilhelmina\'s Canopy Ring', 'WhlmnaCRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (551, 'WhlmnaCRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (551, 68, 7);
REPLACE INTO `item_mods` VALUES (551, 30, 13);
REPLACE INTO `item_mods` VALUES (551, 9, 40);

-- Mischief Marcelino trophy + gear
REPLACE INTO `item_basic` VALUES (552, 0, 'Marcelino\'s Imp Horn', 'MrclnHrn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (553, 0, 'Marcelino\'s Prankster Earring', 'MrclnPEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (553, 'MrclnPEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (553, 23, 4);
REPLACE INTO `item_mods` VALUES (553, 68, 7);
REPLACE INTO `item_mods` VALUES (553, 13, 3);
REPLACE INTO `item_basic` VALUES (554, 0, 'Marcelino\'s Trick Ring', 'MrclnTRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (554, 'MrclnTRng', 20, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (554, 23, 3);
REPLACE INTO `item_mods` VALUES (554, 13, 3);
REPLACE INTO `item_mods` VALUES (554, 25, 6);

-- Trickster Temperance trophy + gear
REPLACE INTO `item_basic` VALUES (555, 0, 'Temperance\'s Trick Tail', 'TmprTTail', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (556, 0, 'Temperance\'s Jester Hat', 'TmprJHat', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (556, 'TmprJHat', 32, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (556, 1, 9);
REPLACE INTO `item_mods` VALUES (556, 23, 6);
REPLACE INTO `item_mods` VALUES (556, 68, 12);
REPLACE INTO `item_basic` VALUES (557, 0, 'Temperance\'s Chaos Collar', 'TmprCCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (557, 'TmprCCll', 32, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (557, 25, 4);
REPLACE INTO `item_mods` VALUES (557, 23, 4);
REPLACE INTO `item_mods` VALUES (557, 30, 7);

-- Hexing Hieronymus trophy + gear
REPLACE INTO `item_basic` VALUES (558, 0, 'Hieronymus\'s Hex Wand', 'HrnmsHWnd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (559, 0, 'Hieronymus\'s Spelltwist Robe', 'HrnmsSRbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (559, 'HrnmsSRbe', 44, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (559, 1, 15);
REPLACE INTO `item_mods` VALUES (559, 25, 8);
REPLACE INTO `item_mods` VALUES (559, 28, 16);
REPLACE INTO `item_mods` VALUES (559, 9, 60);
REPLACE INTO `item_basic` VALUES (560, 0, 'Hieronymus\'s Imp Ring', 'HrnmsIRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (560, 'HrnmsIRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (560, 25, 5);
REPLACE INTO `item_mods` VALUES (560, 30, 11);
REPLACE INTO `item_mods` VALUES (560, 28, 9);

-- Grand Trickster Gregoire trophy + gear
REPLACE INTO `item_basic` VALUES (561, 0, 'Gregoire\'s Grand Staff', 'GrgrGStff', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (562, 0, 'Gregoire\'s Chaos Mantle', 'GrgrCMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (562, 'GrgrCMnt', 54, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (562, 1, 12);
REPLACE INTO `item_mods` VALUES (562, 25, 9);
REPLACE INTO `item_mods` VALUES (562, 28, 18);
REPLACE INTO `item_mods` VALUES (562, 23, 6);
REPLACE INTO `item_basic` VALUES (563, 0, 'Gregoire\'s Mayhem Ring', 'GrgrMRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (563, 'GrgrMRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (563, 25, 7);
REPLACE INTO `item_mods` VALUES (563, 28, 14);
REPLACE INTO `item_mods` VALUES (563, 30, 12);

-- Tiny Tortuga trophy + gear
REPLACE INTO `item_basic` VALUES (564, 0, 'Tortuga\'s Candle Stub', 'TrtgaCndl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (565, 0, 'Tortuga\'s Lantern Ring', 'TrtgaLRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (565, 'TrtgaLRng', 30, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (565, 25, 3);
REPLACE INTO `item_mods` VALUES (565, 30, 5);
REPLACE INTO `item_mods` VALUES (565, 9, 15);
REPLACE INTO `item_basic` VALUES (566, 0, 'Tortuga\'s Grudge Boots', 'TrtgaGBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (566, 'TrtgaGBts', 30, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (566, 1, 8);
REPLACE INTO `item_mods` VALUES (566, 25, 4);
REPLACE INTO `item_mods` VALUES (566, 28, 7);

-- Shuffling Sebastiano trophy + gear
REPLACE INTO `item_basic` VALUES (567, 0, 'Sebastiano\'s Chef\'s Knife', 'SbstnCKnf', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (568, 0, 'Sebastiano\'s Culinary Collar', 'SbstnCCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (568, 'SbstnCCll', 40, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (568, 12, 5);
REPLACE INTO `item_mods` VALUES (568, 29, 10);
REPLACE INTO `item_mods` VALUES (568, 25, 7);
REPLACE INTO `item_basic` VALUES (569, 0, 'Sebastiano\'s Green Apron', 'SbstnGApn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (569, 'SbstnGApn', 40, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (569, 1, 16);
REPLACE INTO `item_mods` VALUES (569, 12, 6);
REPLACE INTO `item_mods` VALUES (569, 29, 14);
REPLACE INTO `item_mods` VALUES (569, 2, 40);

-- Grudge Bearer Giuliana trophy + gear
REPLACE INTO `item_basic` VALUES (570, 0, 'Giuliana\'s Everyone\'s Grudge', 'GlnaGrdge', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (571, 0, 'Giuliana\'s Revenge Mantle', 'GlnaRMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (571, 'GlnaRMnt', 50, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (571, 1, 12);
REPLACE INTO `item_mods` VALUES (571, 12, 7);
REPLACE INTO `item_mods` VALUES (571, 25, 6);
REPLACE INTO `item_mods` VALUES (571, 29, 14);
REPLACE INTO `item_basic` VALUES (572, 0, 'Giuliana\'s Karma Ring', 'GlnaKRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (572, 'GlnaKRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (572, 12, 5);
REPLACE INTO `item_mods` VALUES (572, 25, 5);
REPLACE INTO `item_mods` VALUES (572, 29, 10);
REPLACE INTO `item_mods` VALUES (572, 30, 8);

-- The Last Tonberry trophy + gear
REPLACE INTO `item_basic` VALUES (573, 0, 'Last Tonberry\'s Lantern', 'LstTnLnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (574, 0, 'Last Tonberry\'s Final Robe', 'LstTnFRbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (574, 'LstTnFRbe', 60, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (574, 1, 20);
REPLACE INTO `item_mods` VALUES (574, 25, 11);
REPLACE INTO `item_mods` VALUES (574, 28, 22);
REPLACE INTO `item_mods` VALUES (574, 9, 90);
REPLACE INTO `item_basic` VALUES (575, 0, 'Last Tonberry\'s Legend Ring', 'LstTnLRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (575, 'LstTnLRng', 60, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (575, 25, 8);
REPLACE INTO `item_mods` VALUES (575, 28, 16);
REPLACE INTO `item_mods` VALUES (575, 30, 14);

-- Rippling Rocco trophy + gear
REPLACE INTO `item_basic` VALUES (576, 0, 'Rocco\'s Tide Scale', 'RccTdSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (577, 0, 'Rocco\'s River Boots', 'RccoRBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (577, 'RccoRBts', 16, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (577, 1, 6);
REPLACE INTO `item_mods` VALUES (577, 23, 4);
REPLACE INTO `item_mods` VALUES (577, 68, 8);
REPLACE INTO `item_basic` VALUES (578, 0, 'Rocco\'s Current Earring', 'RccoAEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (578, 'RccoAEar', 16, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (578, 13, 3);
REPLACE INTO `item_mods` VALUES (578, 25, 5);
REPLACE INTO `item_mods` VALUES (578, 23, 3);

-- Tidecaller Thessaly trophy + gear
REPLACE INTO `item_basic` VALUES (579, 0, 'Thessaly\'s Tide Totem', 'ThslyTTtm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (580, 0, 'Thessaly\'s Wavecrest Collar', 'ThslyCCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (580, 'ThslyCCll', 30, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (580, 12, 4);
REPLACE INTO `item_mods` VALUES (580, 14, 4);
REPLACE INTO `item_mods` VALUES (580, 2, 30);
REPLACE INTO `item_basic` VALUES (581, 0, 'Thessaly\'s Reef Mantle', 'ThslyRMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (581, 'ThslyRMnt', 30, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (581, 1, 8);
REPLACE INTO `item_mods` VALUES (581, 12, 5);
REPLACE INTO `item_mods` VALUES (581, 29, 10);

-- Brine Baron Baldassare trophy + gear
REPLACE INTO `item_basic` VALUES (582, 0, 'Baldassare\'s Abyssal Scale', 'BldsrABSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (583, 0, 'Baldassare\'s Leviathan Helm', 'BldsrLHlm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (583, 'BldsrLHlm', 42, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (583, 1, 14);
REPLACE INTO `item_mods` VALUES (583, 12, 7);
REPLACE INTO `item_mods` VALUES (583, 14, 5);
REPLACE INTO `item_mods` VALUES (583, 2, 45);
REPLACE INTO `item_basic` VALUES (584, 0, 'Baldassare\'s Deep Ring', 'BldsrDRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (584, 'BldsrDRng', 42, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (584, 12, 5);
REPLACE INTO `item_mods` VALUES (584, 29, 12);
REPLACE INTO `item_mods` VALUES (584, 14, 4);

-- Deep Sovereign Desideria trophy + gear
REPLACE INTO `item_basic` VALUES (585, 0, 'Desideria\'s Sovereign Fin', 'DsdraSFin', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (586, 0, 'Desideria\'s Abyssal Robe', 'DsdraARbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (586, 'DsdraARbe', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (586, 1, 20);
REPLACE INTO `item_mods` VALUES (586, 25, 8);
REPLACE INTO `item_mods` VALUES (586, 28, 16);
REPLACE INTO `item_mods` VALUES (586, 9, 60);
REPLACE INTO `item_basic` VALUES (587, 0, 'Desideria\'s Trident Ring', 'DsdraTRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (587, 'DsdraTRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (587, 12, 6);
REPLACE INTO `item_mods` VALUES (587, 29, 14);
REPLACE INTO `item_mods` VALUES (587, 25, 5);

-- Prancing Persephone trophy + gear
REPLACE INTO `item_basic` VALUES (588, 0, 'Persephone\'s Plume', 'PrsphnPlme', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (589, 0, 'Persephone\'s Featherlight Earring', 'PrsphnEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (589, 'PrsphnEar', 24, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (589, 23, 5);
REPLACE INTO `item_mods` VALUES (589, 68, 9);
REPLACE INTO `item_mods` VALUES (589, 13, 3);
REPLACE INTO `item_basic` VALUES (590, 0, 'Persephone\'s Gallop Shoes', 'PrsphnGShs', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (590, 'PrsphnGShs', 24, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (590, 1, 8);
REPLACE INTO `item_mods` VALUES (590, 23, 5);
REPLACE INTO `item_mods` VALUES (590, 68, 10);

-- Thunderwing Theron trophy + gear
REPLACE INTO `item_basic` VALUES (591, 0, 'Theron\'s Thunder Plume', 'ThrnTPlme', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (592, 0, 'Theron\'s Storm Mantle', 'ThrnStMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (592, 'ThrnStMnt', 36, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (592, 1, 10);
REPLACE INTO `item_mods` VALUES (592, 23, 6);
REPLACE INTO `item_mods` VALUES (592, 12, 5);
REPLACE INTO `item_mods` VALUES (592, 29, 10);
REPLACE INTO `item_basic` VALUES (593, 0, 'Theron\'s Gale Ring', 'ThrnGRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (593, 'ThrnGRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (593, 23, 5);
REPLACE INTO `item_mods` VALUES (593, 13, 4);
REPLACE INTO `item_mods` VALUES (593, 25, 9);

-- Skydancer Sabastienne trophy + gear
REPLACE INTO `item_basic` VALUES (594, 0, 'Sabastienne\'s Sky Scale', 'SbstSkyScl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (595, 0, 'Sabastienne\'s Aerial Helm', 'SbstAHlm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (595, 'SbstAHlm', 46, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (595, 1, 13);
REPLACE INTO `item_mods` VALUES (595, 23, 7);
REPLACE INTO `item_mods` VALUES (595, 68, 14);
REPLACE INTO `item_mods` VALUES (595, 13, 5);
REPLACE INTO `item_basic` VALUES (596, 0, 'Sabastienne\'s Wing Belt', 'SbstWBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (596, 'SbstWBlt', 46, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (596, 1, 6);
REPLACE INTO `item_mods` VALUES (596, 23, 6);
REPLACE INTO `item_mods` VALUES (596, 384, 4);

-- Heavenrider Hieronyma trophy + gear
REPLACE INTO `item_basic` VALUES (597, 0, 'Hieronyma\'s Heaven Scale', 'HrnymHSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (598, 0, 'Hieronyma\'s Celestial Plate', 'HrnymCPlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (598, 'HrnymCPlt', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (598, 1, 23);
REPLACE INTO `item_mods` VALUES (598, 12, 8);
REPLACE INTO `item_mods` VALUES (598, 23, 8);
REPLACE INTO `item_mods` VALUES (598, 2, 70);
REPLACE INTO `item_basic` VALUES (599, 0, 'Hieronyma\'s Ascent Ring', 'HrnymARng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (599, 'HrnymARng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (599, 23, 7);
REPLACE INTO `item_mods` VALUES (599, 13, 6);
REPLACE INTO `item_mods` VALUES (599, 25, 14);

-- Fledgling Fiorentina trophy + gear
REPLACE INTO `item_basic` VALUES (600, 0, 'Fiorentina\'s Pin Feather', 'FrntnPFth', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (601, 0, 'Fiorentina\'s Downy Earring', 'FrntnDEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (601, 'FrntnDEar', 18, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (601, 23, 4);
REPLACE INTO `item_mods` VALUES (601, 68, 7);
REPLACE INTO `item_mods` VALUES (601, 13, 3);
REPLACE INTO `item_basic` VALUES (602, 0, 'Fiorentina\'s Talon Ring', 'FrntnTRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (602, 'FrntnTRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (602, 12, 3);
REPLACE INTO `item_mods` VALUES (602, 29, 6);
REPLACE INTO `item_mods` VALUES (602, 25, 4);

-- Stormrider Sigismund trophy + gear
REPLACE INTO `item_basic` VALUES (603, 0, 'Sigismund\'s Storm Feather', 'SgsmndSFth', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (604, 0, 'Sigismund\'s Cloudpiercer Helm', 'SgsmndCHlm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (604, 'SgsmndCHlm', 32, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (604, 1, 12);
REPLACE INTO `item_mods` VALUES (604, 12, 5);
REPLACE INTO `item_mods` VALUES (604, 23, 5);
REPLACE INTO `item_mods` VALUES (604, 68, 10);
REPLACE INTO `item_basic` VALUES (605, 0, 'Sigismund\'s Gale Mantle', 'SgsmndGMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (605, 'SgsmndGMnt', 32, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (605, 1, 9);
REPLACE INTO `item_mods` VALUES (605, 12, 5);
REPLACE INTO `item_mods` VALUES (605, 29, 11);

-- Tempest Lord Tancred trophy + gear
REPLACE INTO `item_basic` VALUES (606, 0, 'Tancred\'s Tempest Quill', 'TncrTmpstQ', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (607, 0, 'Tancred\'s Cyclone Plate', 'TncrCyPlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (607, 'TncrCyPlt', 46, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (607, 1, 22);
REPLACE INTO `item_mods` VALUES (607, 12, 8);
REPLACE INTO `item_mods` VALUES (607, 23, 6);
REPLACE INTO `item_mods` VALUES (607, 2, 65);
REPLACE INTO `item_basic` VALUES (608, 0, 'Tancred\'s Thunderstrike Ring', 'TncrTRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (608, 'TncrTRng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (608, 12, 6);
REPLACE INTO `item_mods` VALUES (608, 29, 14);
REPLACE INTO `item_mods` VALUES (608, 23, 5);

-- Ancient Roc Andromeda trophy + gear
REPLACE INTO `item_basic` VALUES (609, 0, 'Andromeda\'s Ancient Quill', 'AndrAQll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (610, 0, 'Andromeda\'s Skyshatter Plate', 'AndrSSPlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (610, 'AndrSSPlt', 58, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (610, 1, 27);
REPLACE INTO `item_mods` VALUES (610, 12, 10);
REPLACE INTO `item_mods` VALUES (610, 23, 8);
REPLACE INTO `item_mods` VALUES (610, 2, 85);
REPLACE INTO `item_basic` VALUES (611, 0, 'Andromeda\'s Legend Ring', 'AndrLRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (611, 'AndrLRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (611, 12, 8);
REPLACE INTO `item_mods` VALUES (611, 29, 20);
REPLACE INTO `item_mods` VALUES (611, 23, 6);

-- Stumbling Sebastiano trophy + gear
REPLACE INTO `item_basic` VALUES (612, 0, 'Sebastiano\'s Cactus Spine', 'SbstnCSpn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (613, 0, 'Sebastiano\'s Prickly Ring', 'SbstnPRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (613, 'SbstnPRng', 22, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (613, 12, 3);
REPLACE INTO `item_mods` VALUES (613, 29, 6);
REPLACE INTO `item_mods` VALUES (613, 13, 2);
REPLACE INTO `item_basic` VALUES (614, 0, 'Sebastiano\'s Sand Boots', 'SbstnSBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (614, 'SbstnSBts', 22, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (614, 1, 6);
REPLACE INTO `item_mods` VALUES (614, 23, 4);
REPLACE INTO `item_mods` VALUES (614, 68, 8);

-- Pirouetting Pradinelda trophy + gear
REPLACE INTO `item_basic` VALUES (615, 0, 'Pradinelda\'s Cactus Flower', 'PrdnldCFlr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (616, 0, 'Pradinelda\'s Desert Mantle', 'PrdnldDMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (616, 'PrdnldDMnt', 34, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (616, 1, 9);
REPLACE INTO `item_mods` VALUES (616, 14, 5);
REPLACE INTO `item_mods` VALUES (616, 2, 35);
REPLACE INTO `item_basic` VALUES (617, 0, 'Pradinelda\'s Spine Belt', 'PrdnldSBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (617, 'PrdnldSBlt', 34, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (617, 1, 6);
REPLACE INTO `item_mods` VALUES (617, 12, 4);
REPLACE INTO `item_mods` VALUES (617, 29, 10);

-- Spiky Serafina trophy + gear
REPLACE INTO `item_basic` VALUES (618, 0, 'Serafina\'s Great Spine', 'SrfnaGSp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (619, 0, 'Serafina\'s Desert Crown', 'SrfnaDCrn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (619, 'SrfnaDCrn', 46, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (619, 1, 13);
REPLACE INTO `item_mods` VALUES (619, 12, 6);
REPLACE INTO `item_mods` VALUES (619, 14, 5);
REPLACE INTO `item_mods` VALUES (619, 2, 40);
REPLACE INTO `item_basic` VALUES (620, 0, 'Serafina\'s Oasis Ring', 'SrfnaORng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (620, 'SrfnaORng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (620, 12, 5);
REPLACE INTO `item_mods` VALUES (620, 14, 4);
REPLACE INTO `item_mods` VALUES (620, 29, 12);

-- Lord of the Desert Lazaro trophy + gear
REPLACE INTO `item_basic` VALUES (621, 0, 'Lazaro\'s Desert Heart', 'LzrDsrtHrt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (622, 0, 'Lazaro\'s Cacti King Plate', 'LzrCKPlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (622, 'LzrCKPlt', 58, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (622, 1, 25);
REPLACE INTO `item_mods` VALUES (622, 12, 9);
REPLACE INTO `item_mods` VALUES (622, 14, 8);
REPLACE INTO `item_mods` VALUES (622, 2, 80);
REPLACE INTO `item_basic` VALUES (623, 0, 'Lazaro\'s Mirage Ring', 'LzrMRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (623, 'LzrMRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (623, 12, 7);
REPLACE INTO `item_mods` VALUES (623, 29, 18);
REPLACE INTO `item_mods` VALUES (623, 14, 5);

-- Lowing Lorcan trophy + gear
REPLACE INTO `item_basic` VALUES (624, 0, 'Lorcan\'s Horn Chip', 'LrcnHrnCp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (625, 0, 'Lorcan\'s Stampede Belt', 'LrcnStBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (625, 'LrcnStBlt', 20, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (625, 1, 5);
REPLACE INTO `item_mods` VALUES (625, 14, 3);
REPLACE INTO `item_mods` VALUES (625, 2, 20);
REPLACE INTO `item_basic` VALUES (626, 0, 'Lorcan\'s Hide Boots', 'LrcnHdBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (626, 'LrcnHdBts', 20, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (626, 1, 6);
REPLACE INTO `item_mods` VALUES (626, 12, 3);
REPLACE INTO `item_mods` VALUES (626, 14, 2);

-- Thunderhoof Theokleia trophy + gear
REPLACE INTO `item_basic` VALUES (627, 0, 'Theokleia\'s Hoof Fragment', 'ThklHFrg', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (628, 0, 'Theokleia\'s Charge Mantle', 'ThklCMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (628, 'ThklCMnt', 34, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (628, 1, 9);
REPLACE INTO `item_mods` VALUES (628, 12, 5);
REPLACE INTO `item_mods` VALUES (628, 29, 11);
REPLACE INTO `item_basic` VALUES (629, 0, 'Theokleia\'s Bull Collar', 'ThklBCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (629, 'ThklBCll', 34, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (629, 14, 5);
REPLACE INTO `item_mods` VALUES (629, 2, 35);
REPLACE INTO `item_mods` VALUES (629, 29, 5);

-- Gore King Godfrey trophy + gear
REPLACE INTO `item_basic` VALUES (630, 0, 'Godfrey\'s Gore Horn', 'GdfrGHrn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (631, 0, 'Godfrey\'s Warlord Helm', 'GdfrWHlm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (631, 'GdfrWHlm', 46, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (631, 1, 14);
REPLACE INTO `item_mods` VALUES (631, 12, 7);
REPLACE INTO `item_mods` VALUES (631, 14, 6);
REPLACE INTO `item_mods` VALUES (631, 2, 50);
REPLACE INTO `item_basic` VALUES (632, 0, 'Godfrey\'s Gorger Ring', 'GdfrGRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (632, 'GdfrGRng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (632, 12, 5);
REPLACE INTO `item_mods` VALUES (632, 14, 5);
REPLACE INTO `item_mods` VALUES (632, 29, 12);

-- Primal Patricia trophy + gear
REPLACE INTO `item_basic` VALUES (633, 0, 'Patricia\'s Primal Horn', 'PatPHrn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (634, 0, 'Patricia\'s Titanplate Hauberk', 'PatTPHbk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (634, 'PatTPHbk', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (634, 1, 28);
REPLACE INTO `item_mods` VALUES (634, 12, 9);
REPLACE INTO `item_mods` VALUES (634, 14, 9);
REPLACE INTO `item_mods` VALUES (634, 2, 90);
REPLACE INTO `item_basic` VALUES (635, 0, 'Patricia\'s Ancient Ring', 'PatARng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (635, 'PatARng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (635, 12, 7);
REPLACE INTO `item_mods` VALUES (635, 29, 18);
REPLACE INTO `item_mods` VALUES (635, 14, 6);

-- Sand Trap Sigrid trophy + gear
REPLACE INTO `item_basic` VALUES (636, 0, 'Sigrid\'s Sanded Jaw', 'SgrdSJaw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (637, 0, 'Sigrid\'s Pit Sandals', 'SgrdPtSnd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (637, 'SgrdPtSnd', 18, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (637, 1, 5);
REPLACE INTO `item_mods` VALUES (637, 23, 4);
REPLACE INTO `item_mods` VALUES (637, 68, 8);
REPLACE INTO `item_basic` VALUES (638, 0, 'Sigrid\'s Trap Ring', 'SgrdTRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (638, 'SgrdTRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (638, 13, 3);
REPLACE INTO `item_mods` VALUES (638, 25, 5);
REPLACE INTO `item_mods` VALUES (638, 23, 2);

-- Burrowing Bellancourt trophy + gear
REPLACE INTO `item_basic` VALUES (639, 0, 'Bellancourt\'s Mandible', 'BlncrtMndb', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (640, 0, 'Bellancourt\'s Chitin Mitts', 'BlncrtCMtt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (640, 'BlncrtCMtt', 30, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (640, 1, 9);
REPLACE INTO `item_mods` VALUES (640, 13, 5);
REPLACE INTO `item_mods` VALUES (640, 25, 9);
REPLACE INTO `item_basic` VALUES (641, 0, 'Bellancourt\'s Sand Belt', 'BlncrtSBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (641, 'BlncrtSBlt', 30, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (641, 1, 5);
REPLACE INTO `item_mods` VALUES (641, 23, 4);
REPLACE INTO `item_mods` VALUES (641, 68, 9);

-- Crusher Crescentia trophy + gear
REPLACE INTO `item_basic` VALUES (642, 0, 'Crescentia\'s Crushing Jaw', 'CrscntCJaw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (643, 0, 'Crescentia\'s Armored Hauberk', 'CrscntAHbk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (643, 'CrscntAHbk', 42, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (643, 1, 20);
REPLACE INTO `item_mods` VALUES (643, 14, 6);
REPLACE INTO `item_mods` VALUES (643, 2, 60);
REPLACE INTO `item_basic` VALUES (644, 0, 'Crescentia\'s Exo Ring', 'CrscntERng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (644, 'CrscntERng', 42, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (644, 1, 4);
REPLACE INTO `item_mods` VALUES (644, 14, 5);
REPLACE INTO `item_mods` VALUES (644, 29, 7);

-- Antlion Emperor Adalbert trophy + gear
REPLACE INTO `item_basic` VALUES (645, 0, 'Adalbert\'s Emperor Mandible', 'AdlbrtEMndb', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (646, 0, 'Adalbert\'s Titan Carapace', 'AdlbrtTCrp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (646, 'AdlbrtTCrp', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (646, 1, 26);
REPLACE INTO `item_mods` VALUES (646, 12, 8);
REPLACE INTO `item_mods` VALUES (646, 14, 8);
REPLACE INTO `item_mods` VALUES (646, 2, 80);
REPLACE INTO `item_basic` VALUES (647, 0, 'Adalbert\'s Sovereign Ring', 'AdlbrtSRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (647, 'AdlbrtSRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (647, 12, 6);
REPLACE INTO `item_mods` VALUES (647, 13, 5);
REPLACE INTO `item_mods` VALUES (647, 29, 16);

-- Winged Wilhelmus trophy + gear
REPLACE INTO `item_basic` VALUES (648, 0, 'Wilhelmus\'s Scale', 'WhlmsScle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (649, 0, 'Wilhelmus\'s Wing Ring', 'WhlmsWRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (649, 'WhlmsWRng', 26, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (649, 12, 3);
REPLACE INTO `item_mods` VALUES (649, 29, 7);
REPLACE INTO `item_mods` VALUES (649, 23, 3);
REPLACE INTO `item_basic` VALUES (650, 0, 'Wilhelmus\'s Claw Boots', 'WhlmsCBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (650, 'WhlmsCBts', 26, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (650, 1, 7);
REPLACE INTO `item_mods` VALUES (650, 23, 4);
REPLACE INTO `item_mods` VALUES (650, 68, 9);

-- Frost Drake Frederik trophy + gear
REPLACE INTO `item_basic` VALUES (651, 0, 'Frederik\'s Frost Scale', 'FrdrkFSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (652, 0, 'Frederik\'s Ice Drake Helm', 'FrdrkIDHlm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (652, 'FrdrkIDHlm', 38, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (652, 1, 12);
REPLACE INTO `item_mods` VALUES (652, 25, 5);
REPLACE INTO `item_mods` VALUES (652, 28, 10);
REPLACE INTO `item_mods` VALUES (652, 30, 7);
REPLACE INTO `item_basic` VALUES (653, 0, 'Frederik\'s Blizzard Mantle', 'FrdrkBMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (653, 'FrdrkBMnt', 38, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (653, 1, 9);
REPLACE INTO `item_mods` VALUES (653, 25, 6);
REPLACE INTO `item_mods` VALUES (653, 28, 12);

-- Venomfang Valentinus trophy + gear
REPLACE INTO `item_basic` VALUES (654, 0, 'Valentinus\'s Venom Gland', 'VlntnVGld', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (655, 0, 'Valentinus\'s Wyvern Hauberk', 'VlntnWHbk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (655, 'VlntnWHbk', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (655, 1, 22);
REPLACE INTO `item_mods` VALUES (655, 12, 8);
REPLACE INTO `item_mods` VALUES (655, 29, 16);
REPLACE INTO `item_mods` VALUES (655, 2, 60);
REPLACE INTO `item_basic` VALUES (656, 0, 'Valentinus\'s Fang Ring', 'VlntnFRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (656, 'VlntnFRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (656, 12, 6);
REPLACE INTO `item_mods` VALUES (656, 29, 14);
REPLACE INTO `item_mods` VALUES (656, 25, 10);

-- Ancient Wyrm Agrippa trophy + gear
REPLACE INTO `item_basic` VALUES (657, 0, 'Agrippa\'s Wyrm Heart', 'AgrppWHrt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (658, 0, 'Agrippa\'s Ancient Drake Plate', 'AgrppADPlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (658, 'AgrppADPlt', 60, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (658, 1, 28);
REPLACE INTO `item_mods` VALUES (658, 12, 10);
REPLACE INTO `item_mods` VALUES (658, 25, 8);
REPLACE INTO `item_mods` VALUES (658, 2, 85);
REPLACE INTO `item_basic` VALUES (659, 0, 'Agrippa\'s Dominion Ring', 'AgrppDRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (659, 'AgrppDRng', 60, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (659, 12, 8);
REPLACE INTO `item_mods` VALUES (659, 29, 20);
REPLACE INTO `item_mods` VALUES (659, 25, 6);

-- Wind Up Wilhelmina trophy + gear
REPLACE INTO `item_basic` VALUES (660, 0, 'Wilhelmina\'s Clockwork Gear', 'WhlmCGear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (661, 0, 'Wilhelmina\'s Gear Ring', 'WhlmGRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (661, 'WhlmGRng', 20, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (661, 25, 3);
REPLACE INTO `item_mods` VALUES (661, 30, 5);
REPLACE INTO `item_mods` VALUES (661, 9, 15);
REPLACE INTO `item_basic` VALUES (662, 0, 'Wilhelmina\'s Mechanical Boots', 'WhlmMBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (662, 'WhlmMBts', 20, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (662, 1, 6);
REPLACE INTO `item_mods` VALUES (662, 25, 3);
REPLACE INTO `item_mods` VALUES (662, 28, 6);

-- Clockwork Calogero trophy + gear
REPLACE INTO `item_basic` VALUES (663, 0, 'Calogero\'s Mainspring', 'ClgrMainSp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (664, 0, 'Calogero\'s Automaton Collar', 'ClgrACll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (664, 'ClgrACll', 32, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (664, 25, 5);
REPLACE INTO `item_mods` VALUES (664, 30, 8);
REPLACE INTO `item_mods` VALUES (664, 28, 8);
REPLACE INTO `item_basic` VALUES (665, 0, 'Calogero\'s Gear Belt', 'ClgrGBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (665, 'ClgrGBlt', 32, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (665, 1, 5);
REPLACE INTO `item_mods` VALUES (665, 25, 4);
REPLACE INTO `item_mods` VALUES (665, 28, 7);

-- Arcane Armature Agatha trophy + gear
REPLACE INTO `item_basic` VALUES (666, 0, 'Agatha\'s Arcane Core', 'AgtArcCr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (667, 0, 'Agatha\'s Arcane Hauberk', 'AgtArcHbk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (667, 'AgtArcHbk', 44, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (667, 1, 18);
REPLACE INTO `item_mods` VALUES (667, 25, 8);
REPLACE INTO `item_mods` VALUES (667, 28, 16);
REPLACE INTO `item_mods` VALUES (667, 9, 55);
REPLACE INTO `item_basic` VALUES (668, 0, 'Agatha\'s Mystic Ring', 'AgtMysRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (668, 'AgtMysRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (668, 25, 6);
REPLACE INTO `item_mods` VALUES (668, 28, 11);
REPLACE INTO `item_mods` VALUES (668, 30, 9);

-- Prime Puppet Ptolemais trophy + gear
REPLACE INTO `item_basic` VALUES (669, 0, 'Ptolemais\'s Prime Core', 'PtlmPrmCr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (670, 0, 'Ptolemais\'s Perfect Body', 'PtlmPBdy', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (670, 'PtlmPBdy', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (670, 1, 24);
REPLACE INTO `item_mods` VALUES (670, 25, 10);
REPLACE INTO `item_mods` VALUES (670, 28, 20);
REPLACE INTO `item_mods` VALUES (670, 9, 80);
REPLACE INTO `item_basic` VALUES (671, 0, 'Ptolemais\'s Overseer Ring', 'PtlmOvRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (671, 'PtlmOvRng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (671, 25, 7);
REPLACE INTO `item_mods` VALUES (671, 28, 16);
REPLACE INTO `item_mods` VALUES (671, 30, 13);

-- Dancing Dervish trophy + gear
REPLACE INTO `item_basic` VALUES (672, 0, 'Dervish\'s Spinning Blade', 'DrvshSpBld', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (673, 0, 'Dervish\'s Blade Ring', 'DrvshBRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (673, 'DrvshBRng', 24, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (673, 12, 3);
REPLACE INTO `item_mods` VALUES (673, 29, 7);
REPLACE INTO `item_mods` VALUES (673, 13, 3);
REPLACE INTO `item_basic` VALUES (674, 0, 'Dervish\'s Dance Belt', 'DrvshDBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (674, 'DrvshDBlt', 24, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (674, 1, 5);
REPLACE INTO `item_mods` VALUES (674, 12, 4);
REPLACE INTO `item_mods` VALUES (674, 29, 8);

-- Whirling Wenceslas trophy + gear
REPLACE INTO `item_basic` VALUES (675, 0, 'Wenceslas\'s Whirling Edge', 'WncslsWEdg', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (676, 0, 'Wenceslas\'s Vortex Earring', 'WncslsVEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (676, 'WncslsVEar', 36, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (676, 12, 5);
REPLACE INTO `item_mods` VALUES (676, 29, 9);
REPLACE INTO `item_mods` VALUES (676, 25, 7);
REPLACE INTO `item_basic` VALUES (677, 0, 'Wenceslas\'s Animated Mantle', 'WncslsAMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (677, 'WncslsAMnt', 36, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (677, 1, 9);
REPLACE INTO `item_mods` VALUES (677, 12, 5);
REPLACE INTO `item_mods` VALUES (677, 29, 12);

-- Cursed Blade Corneline trophy + gear
REPLACE INTO `item_basic` VALUES (678, 0, 'Corneline\'s Cursed Steel', 'CrnlnCStl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (679, 0, 'Corneline\'s Haunted Hauberk', 'CrnlnHHbk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (679, 'CrnlnHHbk', 48, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (679, 1, 20);
REPLACE INTO `item_mods` VALUES (679, 12, 8);
REPLACE INTO `item_mods` VALUES (679, 29, 16);
REPLACE INTO `item_mods` VALUES (679, 2, 55);
REPLACE INTO `item_basic` VALUES (680, 0, 'Corneline\'s Phantom Ring', 'CrnlnPhRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (680, 'CrnlnPhRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (680, 12, 6);
REPLACE INTO `item_mods` VALUES (680, 29, 14);
REPLACE INTO `item_mods` VALUES (680, 25, 4);

-- Eternal Executioner Emerick trophy + gear
REPLACE INTO `item_basic` VALUES (681, 0, 'Emerick\'s Eternal Edge', 'EmrckEEdge', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (682, 0, 'Emerick\'s Executioner Plate', 'EmrckEPlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (682, 'EmrckEPlt', 58, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (682, 1, 26);
REPLACE INTO `item_mods` VALUES (682, 12, 10);
REPLACE INTO `item_mods` VALUES (682, 29, 20);
REPLACE INTO `item_mods` VALUES (682, 2, 75);
REPLACE INTO `item_basic` VALUES (683, 0, 'Emerick\'s Death Ring', 'EmrckDRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (683, 'EmrckDRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (683, 12, 8);
REPLACE INTO `item_mods` VALUES (683, 29, 20);
REPLACE INTO `item_mods` VALUES (683, 13, 6);

-- Wailing Wilhemina trophy + gear
REPLACE INTO `item_basic` VALUES (684, 0, 'Wilhemina\'s Ghostly Wisp', 'WhlmnaGWsp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (685, 0, 'Wilhemina\'s Banshee Earring', 'WhlmnaEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (685, 'WhlmnaEar', 16, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (685, 25, 3);
REPLACE INTO `item_mods` VALUES (685, 28, 6);
REPLACE INTO `item_mods` VALUES (685, 30, 4);
REPLACE INTO `item_basic` VALUES (686, 0, 'Wilhemina\'s Spirit Ring', 'WhlmnaSpRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (686, 'WhlmnaSpRng', 16, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (686, 25, 3);
REPLACE INTO `item_mods` VALUES (686, 9, 15);
REPLACE INTO `item_mods` VALUES (686, 30, 5);

-- Shrieking Sigismonda trophy + gear
REPLACE INTO `item_basic` VALUES (687, 0, 'Sigismonda\'s Wail Remnant', 'SgsmndaWR', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (688, 0, 'Sigismonda\'s Banshee Collar', 'SgsmndBCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (688, 'SgsmndBCll', 28, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (688, 25, 5);
REPLACE INTO `item_mods` VALUES (688, 30, 8);
REPLACE INTO `item_mods` VALUES (688, 9, 25);
REPLACE INTO `item_basic` VALUES (689, 0, 'Sigismonda\'s Haunting Mitts', 'SgsmndHMtt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (689, 'SgsmndHMtt', 28, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (689, 1, 8);
REPLACE INTO `item_mods` VALUES (689, 25, 4);
REPLACE INTO `item_mods` VALUES (689, 28, 8);

-- Phantom Phantasia trophy + gear
REPLACE INTO `item_basic` VALUES (690, 0, 'Phantasia\'s Ectoplasm', 'PhntsaEctp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (691, 0, 'Phantasia\'s Specter Robe', 'PhntsaSRbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (691, 'PhntsaSRbe', 40, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (691, 1, 15);
REPLACE INTO `item_mods` VALUES (691, 25, 7);
REPLACE INTO `item_mods` VALUES (691, 28, 14);
REPLACE INTO `item_mods` VALUES (691, 9, 55);
REPLACE INTO `item_basic` VALUES (692, 0, 'Phantasia\'s Wraith Ring', 'PhntsaWRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (692, 'PhntsaWRng', 40, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (692, 25, 5);
REPLACE INTO `item_mods` VALUES (692, 30, 9);
REPLACE INTO `item_mods` VALUES (692, 28, 8);

-- Eternal Mourner Euphemia trophy + gear
REPLACE INTO `item_basic` VALUES (693, 0, 'Euphemia\'s Eternal Tear', 'EphEtrTear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (694, 0, 'Euphemia\'s Mourning Robe', 'EphMRobe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (694, 'EphMRobe', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (694, 1, 18);
REPLACE INTO `item_mods` VALUES (694, 25, 9);
REPLACE INTO `item_mods` VALUES (694, 28, 18);
REPLACE INTO `item_mods` VALUES (694, 9, 75);
REPLACE INTO `item_basic` VALUES (695, 0, 'Euphemia\'s Lament Ring', 'EphLmtRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (695, 'EphLmtRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (695, 25, 7);
REPLACE INTO `item_mods` VALUES (695, 28, 14);
REPLACE INTO `item_mods` VALUES (695, 30, 12);

-- Blinking Bartholomea trophy + gear
REPLACE INTO `item_basic` VALUES (696, 0, 'Bartholomea\'s Petrified Eye', 'BrthlmaEye', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (697, 0, 'Bartholomea\'s Eye Earring', 'BrthlmaEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (697, 'BrthlmaEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (697, 25, 4);
REPLACE INTO `item_mods` VALUES (697, 30, 7);
REPLACE INTO `item_mods` VALUES (697, 9, 15);
REPLACE INTO `item_basic` VALUES (698, 0, 'Bartholomea\'s Gaze Ring', 'BrthlmaRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (698, 'BrthlmaRng', 20, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (698, 25, 3);
REPLACE INTO `item_mods` VALUES (698, 30, 5);
REPLACE INTO `item_mods` VALUES (698, 28, 6);

-- Staring Stanislao trophy + gear
REPLACE INTO `item_basic` VALUES (699, 0, 'Stanislao\'s Crystal Eye', 'StnsloEye', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (700, 0, 'Stanislao\'s Watcher\'s Collar', 'StnslaWCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (700, 'StnslaWCll', 32, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (700, 25, 5);
REPLACE INTO `item_mods` VALUES (700, 30, 9);
REPLACE INTO `item_mods` VALUES (700, 9, 25);
REPLACE INTO `item_basic` VALUES (701, 0, 'Stanislao\'s All-Seeing Mitts', 'StnslaAMtt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (701, 'StnslaAMtt', 32, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (701, 1, 9);
REPLACE INTO `item_mods` VALUES (701, 25, 5);
REPLACE INTO `item_mods` VALUES (701, 28, 9);

-- Paralytic Paracelsina trophy + gear
REPLACE INTO `item_basic` VALUES (702, 0, 'Paracelsina\'s Petrify Gaze', 'PrclsPGze', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (703, 0, 'Paracelsina\'s Stone Visor', 'PrclsSVsr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (703, 'PrclsSVsr', 44, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (703, 1, 12);
REPLACE INTO `item_mods` VALUES (703, 25, 7);
REPLACE INTO `item_mods` VALUES (703, 30, 12);
REPLACE INTO `item_mods` VALUES (703, 28, 10);
REPLACE INTO `item_basic` VALUES (704, 0, 'Paracelsina\'s Petri Ring', 'PrclsPRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (704, 'PrclsPRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (704, 25, 5);
REPLACE INTO `item_mods` VALUES (704, 30, 10);
REPLACE INTO `item_mods` VALUES (704, 9, 30);

-- All Seeing Arbogast trophy + gear
REPLACE INTO `item_basic` VALUES (705, 0, 'Arbogast\'s Omniscient Eye', 'ArbgstOEye', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (706, 0, 'Arbogast\'s Seer\'s Robe', 'ArbgstSRbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (706, 'ArbgstSRbe', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (706, 1, 17);
REPLACE INTO `item_mods` VALUES (706, 25, 10);
REPLACE INTO `item_mods` VALUES (706, 28, 20);
REPLACE INTO `item_mods` VALUES (706, 30, 14);
REPLACE INTO `item_basic` VALUES (707, 0, 'Arbogast\'s Oracle Ring', 'ArbgstORng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (707, 'ArbgstORng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (707, 25, 8);
REPLACE INTO `item_mods` VALUES (707, 28, 16);
REPLACE INTO `item_mods` VALUES (707, 30, 14);

-- Scavenging Svetlana trophy + gear
REPLACE INTO `item_basic` VALUES (708, 0, 'Svetlana\'s Talon', 'SvtlnTln', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (709, 0, 'Svetlana\'s Buzzard Earring', 'SvtlnBEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (709, 'SvtlnBEar', 16, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (709, 23, 3);
REPLACE INTO `item_mods` VALUES (709, 68, 6);
REPLACE INTO `item_mods` VALUES (709, 13, 2);
REPLACE INTO `item_basic` VALUES (710, 0, 'Svetlana\'s Scavenger Boots', 'SvtlnSBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (710, 'SvtlnSBts', 16, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (710, 1, 5);
REPLACE INTO `item_mods` VALUES (710, 23, 3);
REPLACE INTO `item_mods` VALUES (710, 68, 7);

-- Carrion Circling Casimira trophy + gear
REPLACE INTO `item_basic` VALUES (711, 0, 'Casimira\'s Charnel Feather', 'CsmraCFth', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (712, 0, 'Casimira\'s Death Glide Mantle', 'CsmraDGMnt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (712, 'CsmraDGMnt', 28, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (712, 1, 8);
REPLACE INTO `item_mods` VALUES (712, 23, 5);
REPLACE INTO `item_mods` VALUES (712, 68, 11);
REPLACE INTO `item_basic` VALUES (713, 0, 'Casimira\'s Gyre Ring', 'CsmraGRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (713, 'CsmraGRng', 28, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (713, 23, 4);
REPLACE INTO `item_mods` VALUES (713, 13, 3);
REPLACE INTO `item_mods` VALUES (713, 25, 7);

-- Bone Picker Bonaventura trophy + gear
REPLACE INTO `item_basic` VALUES (714, 0, 'Bonaventura\'s Picking Beak', 'BnvntPBeak', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (715, 0, 'Bonaventura\'s Gyre Helm', 'BnvntGHlm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (715, 'BnvntGHlm', 40, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (715, 1, 12);
REPLACE INTO `item_mods` VALUES (715, 23, 6);
REPLACE INTO `item_mods` VALUES (715, 13, 5);
REPLACE INTO `item_mods` VALUES (715, 68, 12);
REPLACE INTO `item_basic` VALUES (716, 0, 'Bonaventura\'s Carrion Belt', 'BnvntCBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (716, 'BnvntCBlt', 40, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (716, 1, 5);
REPLACE INTO `item_mods` VALUES (716, 12, 4);
REPLACE INTO `item_mods` VALUES (716, 29, 10);

-- Sky Sovereign Seraphinus trophy + gear
REPLACE INTO `item_basic` VALUES (717, 0, 'Seraphinus\'s Sovereign Feather', 'SrphnusSFth', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (718, 0, 'Seraphinus\'s Skyking Plate', 'SrphnusSKPlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (718, 'SrphnusSKPlt', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (718, 1, 23);
REPLACE INTO `item_mods` VALUES (718, 12, 8);
REPLACE INTO `item_mods` VALUES (718, 23, 7);
REPLACE INTO `item_mods` VALUES (718, 2, 65);
REPLACE INTO `item_basic` VALUES (719, 0, 'Seraphinus\'s Dominion Ring', 'SrphnusDRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (719, 'SrphnusDRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (719, 12, 6);
REPLACE INTO `item_mods` VALUES (719, 29, 14);
REPLACE INTO `item_mods` VALUES (719, 23, 5);

-- Chittering Chichester trophy + gear
REPLACE INTO `item_basic` VALUES (720, 0, 'Chichester\'s Shiny Pebble', 'ChchtrPbl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (721, 0, 'Chichester\'s Chatter Ring', 'ChchtrCRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (721, 'ChchtrCRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (721, 13, 3);
REPLACE INTO `item_mods` VALUES (721, 25, 5);
REPLACE INTO `item_mods` VALUES (721, 23, 3);
REPLACE INTO `item_basic` VALUES (722, 0, 'Chichester\'s Nimble Boots', 'ChchtrNBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (722, 'ChchtrNBts', 18, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (722, 1, 6);
REPLACE INTO `item_mods` VALUES (722, 23, 4);
REPLACE INTO `item_mods` VALUES (722, 68, 8);

-- Thieving Theodolinda trophy + gear
REPLACE INTO `item_basic` VALUES (723, 0, 'Theodolinda\'s Stolen Gem', 'ThdlndSGm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (724, 0, 'Theodolinda\'s Pickpocket Mitts', 'ThdlndPMtt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (724, 'ThdlndPMtt', 30, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (724, 1, 9);
REPLACE INTO `item_mods` VALUES (724, 13, 5);
REPLACE INTO `item_mods` VALUES (724, 25, 10);
REPLACE INTO `item_basic` VALUES (725, 0, 'Theodolinda\'s Swift Earring', 'ThdlndSEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (725, 'ThdlndSEar', 30, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (725, 23, 4);
REPLACE INTO `item_mods` VALUES (725, 13, 4);
REPLACE INTO `item_mods` VALUES (725, 384, 3);

-- Banana Baron Balthazar trophy + gear
REPLACE INTO `item_basic` VALUES (726, 0, 'Balthazar\'s Royal Banana', 'BlthzrRBnn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (727, 0, 'Balthazar\'s Jungle Crown', 'BlthzrJCrn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (727, 'BlthzrJCrn', 42, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (727, 1, 12);
REPLACE INTO `item_mods` VALUES (727, 23, 6);
REPLACE INTO `item_mods` VALUES (727, 13, 5);
REPLACE INTO `item_mods` VALUES (727, 68, 11);
REPLACE INTO `item_basic` VALUES (728, 0, 'Balthazar\'s Treetop Belt', 'BlthzrTBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (728, 'BlthzrTBlt', 42, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (728, 1, 5);
REPLACE INTO `item_mods` VALUES (728, 23, 5);
REPLACE INTO `item_mods` VALUES (728, 384, 4);

-- Primate Prince Pelagius trophy + gear
REPLACE INTO `item_basic` VALUES (729, 0, 'Pelagius\'s Primate Insignia', 'PlgsPInsig', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (730, 0, 'Pelagius\'s Jungle King Robe', 'PlgsJKRbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (730, 'PlgsJKRbe', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (730, 1, 19);
REPLACE INTO `item_mods` VALUES (730, 23, 8);
REPLACE INTO `item_mods` VALUES (730, 13, 7);
REPLACE INTO `item_mods` VALUES (730, 2, 60);
REPLACE INTO `item_basic` VALUES (731, 0, 'Pelagius\'s Alpha Ring', 'PlgsAlpRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (731, 'PlgsAlpRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (731, 23, 6);
REPLACE INTO `item_mods` VALUES (731, 13, 5);
REPLACE INTO `item_mods` VALUES (731, 25, 13);
REPLACE INTO `item_mods` VALUES (731, 384, 3);

-- Gnashing Guildenstern trophy + gear
REPLACE INTO `item_basic` VALUES (732, 0, 'Guildenstern\'s Cracked Claw', 'GldnsternCC', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (733, 0, 'Guildenstern\'s Gnole Bracers', 'GldnstrnBrc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (733, 'GldnstrnBrc', 22, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (733, 1, 8);
REPLACE INTO `item_mods` VALUES (733, 12, 4);
REPLACE INTO `item_mods` VALUES (733, 29, 8);
REPLACE INTO `item_basic` VALUES (734, 0, 'Guildenstern\'s Howl Belt', 'GldnstrnHBlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (734, 'GldnstrnHBlt', 22, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (734, 1, 5);
REPLACE INTO `item_mods` VALUES (734, 14, 3);
REPLACE INTO `item_mods` VALUES (734, 2, 20);

-- Pack Lord Petronio trophy + gear
REPLACE INTO `item_basic` VALUES (735, 0, 'Petronio\'s Pack Mark', 'PtrnoPMrk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (736, 0, 'Petronio\'s Packmaster Helm', 'PtrnoPHlm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (736, 'PtrnoPHlm', 34, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (736, 1, 12);
REPLACE INTO `item_mods` VALUES (736, 12, 6);
REPLACE INTO `item_mods` VALUES (736, 14, 4);
REPLACE INTO `item_mods` VALUES (736, 2, 35);
REPLACE INTO `item_basic` VALUES (737, 0, 'Petronio\'s Den Ring', 'PtrnoDRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (737, 'PtrnoDRng', 34, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (737, 12, 4);
REPLACE INTO `item_mods` VALUES (737, 29, 10);
REPLACE INTO `item_mods` VALUES (737, 14, 3);

-- Mauling Malaclypse trophy + gear
REPLACE INTO `item_basic` VALUES (738, 0, 'Malaclypse\'s Maul Fang', 'MlclpsMFng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (739, 0, 'Malaclypse\'s Savager Hauberk', 'MlclpsSHbk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (739, 'MlclpsSHbk', 44, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (739, 1, 21);
REPLACE INTO `item_mods` VALUES (739, 12, 7);
REPLACE INTO `item_mods` VALUES (739, 14, 6);
REPLACE INTO `item_mods` VALUES (739, 2, 60);
REPLACE INTO `item_basic` VALUES (740, 0, 'Malaclypse\'s Pack Ring', 'MlclpsPRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (740, 'MlclpsPRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (740, 12, 5);
REPLACE INTO `item_mods` VALUES (740, 29, 12);
REPLACE INTO `item_mods` VALUES (740, 14, 4);

-- Alpha Apollinarius trophy + gear
REPLACE INTO `item_basic` VALUES (741, 0, 'Apollinarius\'s Alpha Fang', 'ApllnrsAFng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (742, 0, 'Apollinarius\'s Alpha Plate', 'ApllnrsAPlt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (742, 'ApllnrsAPlt', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (742, 1, 26);
REPLACE INTO `item_mods` VALUES (742, 12, 9);
REPLACE INTO `item_mods` VALUES (742, 14, 8);
REPLACE INTO `item_mods` VALUES (742, 2, 80);
REPLACE INTO `item_basic` VALUES (743, 0, 'Apollinarius\'s Pack Crown', 'ApllnrsPCrn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (743, 'ApllnrsPCrn', 54, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (743, 1, 15);
REPLACE INTO `item_mods` VALUES (743, 12, 7);
REPLACE INTO `item_mods` VALUES (743, 14, 6);
REPLACE INTO `item_mods` VALUES (743, 2, 50);

-- Tiny Tortoise Tibalt trophy + gear
REPLACE INTO `item_basic` VALUES (744, 0, 'Tibalt\'s Shell Chip', 'TbltShCp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (745, 0, 'Tibalt\'s Shell Ring', 'TbltShRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (745, 'TbltShRng', 26, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (745, 1, 4);
REPLACE INTO `item_mods` VALUES (745, 14, 3);
REPLACE INTO `item_mods` VALUES (745, 29, 5);
REPLACE INTO `item_basic` VALUES (746, 0, 'Tibalt\'s Plated Sandals', 'TbltPSnd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (746, 'TbltPSnd', 26, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (746, 1, 8);
REPLACE INTO `item_mods` VALUES (746, 14, 3);
REPLACE INTO `item_mods` VALUES (746, 2, 25);

-- Armored Archibald trophy + gear
REPLACE INTO `item_basic` VALUES (747, 0, 'Archibald\'s Spiked Shell', 'ArchbldSSh', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (748, 0, 'Archibald\'s Fortress Collar', 'ArchbldFCl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (748, 'ArchbldFCl', 40, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (748, 1, 6);
REPLACE INTO `item_mods` VALUES (748, 14, 6);
REPLACE INTO `item_mods` VALUES (748, 2, 40);
REPLACE INTO `item_mods` VALUES (748, 29, 6);
REPLACE INTO `item_basic` VALUES (749, 0, 'Archibald\'s Rampart Boots', 'ArchbldRBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (749, 'ArchbldRBts', 40, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (749, 1, 13);
REPLACE INTO `item_mods` VALUES (749, 14, 5);
REPLACE INTO `item_mods` VALUES (749, 2, 40);

-- Elder Shell Eleanor trophy + gear
REPLACE INTO `item_basic` VALUES (750, 0, 'Eleanor\'s Elder Shell', 'ElnrEldSh', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (751, 0, 'Eleanor\'s Ancient Carapace', 'ElnrACrp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (751, 'ElnrACrp', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (751, 1, 26);
REPLACE INTO `item_mods` VALUES (751, 14, 9);
REPLACE INTO `item_mods` VALUES (751, 2, 80);
REPLACE INTO `item_mods` VALUES (751, 29, 10);
REPLACE INTO `item_basic` VALUES (752, 0, 'Eleanor\'s Stone Ring', 'ElnrStnRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (752, 'ElnrStnRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (752, 14, 6);
REPLACE INTO `item_mods` VALUES (752, 2, 50);
REPLACE INTO `item_mods` VALUES (752, 29, 8);

-- Adamantoise Emperor Alexandros trophy + gear
REPLACE INTO `item_basic` VALUES (753, 0, 'Alexandros\'s Imperial Shell', 'AlxndrsISh', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (754, 0, 'Alexandros\'s Titan Fortress', 'AlxndrsTF', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (754, 'AlxndrsTF', 60, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (754, 1, 32);
REPLACE INTO `item_mods` VALUES (754, 14, 11);
REPLACE INTO `item_mods` VALUES (754, 2, 110);
REPLACE INTO `item_mods` VALUES (754, 29, 12);
REPLACE INTO `item_basic` VALUES (755, 0, 'Alexandros\'s Bastion Ring', 'AlxndrsBRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (755, 'AlxndrsBRng', 60, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (755, 14, 8);
REPLACE INTO `item_mods` VALUES (755, 2, 65);
REPLACE INTO `item_mods` VALUES (755, 29, 10);

-- Coiling Callirhoe trophy + gear
REPLACE INTO `item_basic` VALUES (756, 0, 'Callirhoe\'s Coil Ring', 'CllrhoeRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (757, 0, 'Callirhoe\'s Serpentine Earring', 'CllrhoeEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (757, 'CllrhoeEar', 22, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (757, 28, 4);
REPLACE INTO `item_mods` VALUES (757, 25, 3);
REPLACE INTO `item_mods` VALUES (757, 30, 6);
REPLACE INTO `item_basic` VALUES (758, 0, 'Callirhoe\'s Scale Sash', 'CllrhoeSsh', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (758, 'CllrhoeSsh', 22, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (758, 1, 5);
REPLACE INTO `item_mods` VALUES (758, 28, 3);
REPLACE INTO `item_mods` VALUES (758, 9, 20);

-- Charming Chrysanthema trophy + gear
REPLACE INTO `item_basic` VALUES (759, 0, 'Chrysanthema\'s Charm Bead', 'ChrsnthmCBd', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (760, 0, 'Chrysanthema\'s Enchanting Collar', 'ChrsnthmCCl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (760, 'ChrsnthmCCl', 34, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (760, 28, 6);
REPLACE INTO `item_mods` VALUES (760, 68, 5);
REPLACE INTO `item_mods` VALUES (760, 9, 30);
REPLACE INTO `item_basic` VALUES (761, 0, 'Chrysanthema\'s Lure Ring', 'ChrsnthmLRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (761, 'ChrsnthmLRng', 34, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (761, 28, 5);
REPLACE INTO `item_mods` VALUES (761, 25, 4);
REPLACE INTO `item_mods` VALUES (761, 30, 8);

-- Seductive Seraphimia trophy + gear
REPLACE INTO `item_basic` VALUES (762, 0, 'Seraphimia\'s Seduction Scale', 'SrphmSdcSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (763, 0, 'Seraphimia\'s Siren Robe', 'SrphmSRbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (763, 'SrphmSRbe', 46, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (763, 1, 16);
REPLACE INTO `item_mods` VALUES (763, 28, 8);
REPLACE INTO `item_mods` VALUES (763, 25, 6);
REPLACE INTO `item_mods` VALUES (763, 9, 65);
REPLACE INTO `item_basic` VALUES (764, 0, 'Seraphimia\'s Temptress Ring', 'SrphmTmpRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (764, 'SrphmTmpRng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (764, 28, 6);
REPLACE INTO `item_mods` VALUES (764, 25, 5);
REPLACE INTO `item_mods` VALUES (764, 30, 10);

-- Serpent Queen Sophronia trophy + gear
REPLACE INTO `item_basic` VALUES (765, 0, 'Sophronia\'s Royal Scale', 'SphrnaRSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (766, 0, 'Sophronia\'s Sea Queen Tiara', 'SphrnaSTar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (766, 'SphrnaSTar', 58, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (766, 1, 15);
REPLACE INTO `item_mods` VALUES (766, 28, 9);
REPLACE INTO `item_mods` VALUES (766, 25, 7);
REPLACE INTO `item_mods` VALUES (766, 9, 55);
REPLACE INTO `item_basic` VALUES (767, 0, 'Sophronia\'s Sovereign Ring', 'SphrnaSOvRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (767, 'SphrnaSOvRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (767, 28, 7);
REPLACE INTO `item_mods` VALUES (767, 25, 6);
REPLACE INTO `item_mods` VALUES (767, 30, 13);

-- Bloodsucking Barnard trophy + gear
REPLACE INTO `item_basic` VALUES (768, 0, 'Barnard\'s Bloodsack', 'BrndBlSck', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (769, 0, 'Barnard\'s Crimson Earring', 'BrndCEar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (769, 'BrndCEar', 12, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (769, 14, 3);
REPLACE INTO `item_mods` VALUES (769, 2, 15);
REPLACE INTO `item_mods` VALUES (769, 29, 3);
REPLACE INTO `item_basic` VALUES (770, 0, 'Barnard\'s Drain Ring', 'BrndDrRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (770, 'BrndDrRng', 12, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (770, 25, 2);
REPLACE INTO `item_mods` VALUES (770, 30, 4);
REPLACE INTO `item_mods` VALUES (770, 9, 10);

-- Gorging Griselda trophy + gear
REPLACE INTO `item_basic` VALUES (771, 0, 'Griselda\'s Bloated Sac', 'GrsldaBSc', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (772, 0, 'Griselda\'s Blood Collar', 'GrsldaBCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (772, 'GrsldaBCll', 24, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (772, 14, 4);
REPLACE INTO `item_mods` VALUES (772, 2, 25);
REPLACE INTO `item_mods` VALUES (772, 29, 5);
REPLACE INTO `item_basic` VALUES (773, 0, 'Griselda\'s Gorge Mitts', 'GrsldaGMtt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (773, 'GrsldaGMtt', 24, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (773, 1, 8);
REPLACE INTO `item_mods` VALUES (773, 14, 4);
REPLACE INTO `item_mods` VALUES (773, 2, 30);

-- Plasma Draining Placida trophy + gear
REPLACE INTO `item_basic` VALUES (774, 0, 'Placida\'s Ichor Flask', 'PlcdaIchrF', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (775, 0, 'Placida\'s Marrow Hauberk', 'PlcdaMHbk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (775, 'PlcdaMHbk', 36, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (775, 1, 17);
REPLACE INTO `item_mods` VALUES (775, 14, 6);
REPLACE INTO `item_mods` VALUES (775, 2, 55);
REPLACE INTO `item_mods` VALUES (775, 29, 6);
REPLACE INTO `item_basic` VALUES (776, 0, 'Placida\'s Siphon Ring', 'PlcdaSpRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (776, 'PlcdaSpRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (776, 14, 4);
REPLACE INTO `item_mods` VALUES (776, 2, 30);
REPLACE INTO `item_mods` VALUES (776, 29, 7);

-- Ancient Lamprey Augustine trophy + gear
REPLACE INTO `item_basic` VALUES (777, 0, 'Augustine\'s Ancient Sucker', 'AgstnASckr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (778, 0, 'Augustine\'s Life Drain Robe', 'AgstnLDRbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (778, 'AgstnLDRbe', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (778, 1, 19);
REPLACE INTO `item_mods` VALUES (778, 14, 8);
REPLACE INTO `item_mods` VALUES (778, 2, 70);
REPLACE INTO `item_mods` VALUES (778, 25, 6);
REPLACE INTO `item_basic` VALUES (779, 0, 'Augustine\'s Vital Ring', 'AgstnVtRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (779, 'AgstnVtRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (779, 14, 6);
REPLACE INTO `item_mods` VALUES (779, 2, 45);
REPLACE INTO `item_mods` VALUES (779, 29, 8);

-- Larval Lavrentiy trophy + gear
REPLACE INTO `item_basic` VALUES (780, 0, 'Lavrentiy\'s Larval Silk', 'LvrntLSilk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (781, 0, 'Lavrentiy\'s Chrysalis Ring', 'LvrnCRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (781, 'LvrnCRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (781, 25, 3);
REPLACE INTO `item_mods` VALUES (781, 9, 15);
REPLACE INTO `item_mods` VALUES (781, 30, 4);
REPLACE INTO `item_basic` VALUES (782, 0, 'Lavrentiy\'s Wriggle Boots', 'LvrnWBts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (782, 'LvrnWBts', 18, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (782, 1, 5);
REPLACE INTO `item_mods` VALUES (782, 23, 3);
REPLACE INTO `item_mods` VALUES (782, 68, 7);

-- Spinning Sebestyen trophy + gear
REPLACE INTO `item_basic` VALUES (783, 0, 'Sebestyen\'s Cocoon Silk', 'SbstynCSilk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (784, 0, 'Sebestyen\'s Web Collar', 'SbstynWCll', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (784, 'SbstynWCll', 30, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (784, 25, 4);
REPLACE INTO `item_mods` VALUES (784, 9, 25);
REPLACE INTO `item_mods` VALUES (784, 30, 6);
REPLACE INTO `item_basic` VALUES (785, 0, 'Sebestyen\'s Spinner Mitts', 'SbstynSMtt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (785, 'SbstynSMtt', 30, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (785, 1, 9);
REPLACE INTO `item_mods` VALUES (785, 25, 4);
REPLACE INTO `item_mods` VALUES (785, 28, 8);

-- Metamorphing Melchior trophy + gear
REPLACE INTO `item_basic` VALUES (786, 0, 'Melchior\'s Morphing Core', 'MlchrMCr', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (787, 0, 'Melchior\'s Transform Robe', 'MlchrTRbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (787, 'MlchrTRbe', 42, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (787, 1, 17);
REPLACE INTO `item_mods` VALUES (787, 25, 7);
REPLACE INTO `item_mods` VALUES (787, 28, 14);
REPLACE INTO `item_mods` VALUES (787, 9, 55);
REPLACE INTO `item_basic` VALUES (788, 0, 'Melchior\'s Emergence Ring', 'MlchrERng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (788, 'MlchrERng', 42, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (788, 25, 5);
REPLACE INTO `item_mods` VALUES (788, 30, 9);
REPLACE INTO `item_mods` VALUES (788, 28, 8);

-- Melpomene trophy + gear
REPLACE INTO `item_basic` VALUES (789, 0, 'Melpomene\'s Chrysalis', 'MlpmChrys', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (790, 0, 'Melpomene\'s Ascendant Robe', 'MlpmARbe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (790, 'MlpmARbe', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (790, 1, 21);
REPLACE INTO `item_mods` VALUES (790, 25, 10);
REPLACE INTO `item_mods` VALUES (790, 28, 20);
REPLACE INTO `item_mods` VALUES (790, 9, 85);
REPLACE INTO `item_basic` VALUES (791, 0, 'Melpomene\'s Chrysalis Ring', 'MlpmCRng', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (791, 'MlpmCRng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (791, 25, 7);
REPLACE INTO `item_mods` VALUES (791, 28, 15);
REPLACE INTO `item_mods` VALUES (791, 30, 13);

-- =============================================================================
-- =============================================================================
-- SECTION 4: DYNAMIC WORLD UNIQUE MONSTER DROPS (IDs 228-249)
-- DAT-resident IDs (exist in client ROM/184/6.DAT) so icons display correctly.
-- flags=59476 (0xE854) = RARE+EX+NODELIVERY+CANEQUIP+NOAUCTION (matches Empress Hairpin)
-- All jobs (jobs=4194303), correct slot bitmasks.
-- ID mapping: 228-231 Wanderer, 232-236 Nomad, 237-240 Elite, 241-249 Apex
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 228: Crawler's Silk Mantle  (BACK, lv8)  — Empowered Crawler
-- Woven from the luminous silk of a magically-charged crawler.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (228,0,'crawlers_silk_mantle','crawl_silk_mnt',1,59476,0,0,1500);
REPLACE INTO `item_equipment` VALUES (228,'crawl_silk_mnt',8,0,4194303,0,0,0,256,0,0,0);
REPLACE INTO `item_mods` VALUES (228,1,5),(228,11,8),(228,68,10),(228,384,5);

-- ---------------------------------------------------------------------------
-- 229: Bat Sonar Earring  (EAR, lv5)  — Frenzied Bat
-- A crystallized membrane granting uncanny spatial awareness.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (229,0,'bat_sonar_earring','bat_sonar_erng',1,59476,0,0,800);
REPLACE INTO `item_equipment` VALUES (229,'bat_sonar_erng',5,0,4194303,0,0,0,4,0,0,0);
REPLACE INTO `item_mods` VALUES (229,25,10),(229,30,8),(229,11,5);

-- ---------------------------------------------------------------------------
-- 230: Bomb Core Fragment  (RING, lv10)  — Enraged Bomb
-- A shard of a bomb's explosive core. Still warm. Wearing it is inadvisable.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (230,0,'bomb_core_fragment','bomb_core_frag',1,59476,0,0,1200);
REPLACE INTO `item_equipment` VALUES (230,'bomb_core_frag',10,0,4194303,0,0,0,64,0,0,0);
REPLACE INTO `item_mods` VALUES (230,23,15),(230,28,12),(230,8,5),(230,2,-30);

-- ---------------------------------------------------------------------------
-- 231: Rogue Scout's Beret  (HEAD, lv12)  — Rogue Quadav
-- Standard-issue headgear of a Quadav infiltrator. Smells of brine and regret.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (231,0,'rogue_scouts_beret','rogue_sct_brt',1,59476,0,0,2000);
REPLACE INTO `item_equipment` VALUES (231,'rogue_sct_brt',12,0,4194303,0,0,0,1,0,0,0);
REPLACE INTO `item_mods` VALUES (231,1,8),(231,9,7),(231,25,10),(231,68,8),(231,2,30);

-- ---------------------------------------------------------------------------
-- 232: Tiger's Bloodmane Cloak  (BACK, lv25)  — Frenzied Tiger
-- The vivid mane of a tiger driven mad by ley-line energy. Still radiates heat.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (232,0,'tigers_bloodmane_cloak','tigr_blood_mnt',1,59476,0,0,5000);
REPLACE INTO `item_equipment` VALUES (232,'tigr_blood_mnt',25,0,4194303,0,0,0,256,0,0,0);
REPLACE INTO `item_mods` VALUES (232,23,22),(232,8,10),(232,384,7),(232,2,40);

-- ---------------------------------------------------------------------------
-- 233: Shade Wraith Tabard  (BODY, lv30)  — Wandering Shade
-- Woven from ectoplasmic essence. Cold to the touch; warm to the soul. Probably.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (233,0,'shade_wraith_tabard','shade_wrth_tab',1,59476,0,0,8000);
REPLACE INTO `item_equipment` VALUES (233,'shade_wrth_tab',30,0,4194303,0,0,0,16,0,0,0);
REPLACE INTO `item_mods` VALUES (233,5,100),(233,12,12),(233,13,10),(233,28,18),(233,29,10);

-- ---------------------------------------------------------------------------
-- 234: Goblin's Overstuffed Satchel  (WAIST, lv20)  — Treasure Goblin
-- Contains everything. No one knows how it holds so much.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (234,0,'goblins_overstuffed_satchel','gob_ovst_sach',1,59476,0,0,3000);
REPLACE INTO `item_equipment` VALUES (234,'gob_ovst_sach',20,0,4194303,0,0,0,512,0,0,0);
REPLACE INTO `item_mods` VALUES (234,8,6),(234,9,6),(234,10,6),(234,11,6),(234,12,6),(234,13,6),(234,14,6),(234,2,50),(234,5,30);

-- ---------------------------------------------------------------------------
-- 235: Goblin's Jackpot Bell  (EAR, lv40)  — Treasure Goblin (rare variant)
-- The bell the goblin rings when it strikes it rich. Now it rings for you.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (235,0,'goblins_jackpot_bell','gob_jkpt_bell',1,59476,0,0,6000);
REPLACE INTO `item_equipment` VALUES (235,'gob_jkpt_bell',40,0,4194303,0,0,0,4,0,0,0);
REPLACE INTO `item_mods` VALUES (235,25,20),(235,23,20),(235,384,10),(235,2,50);

-- ---------------------------------------------------------------------------
-- 236: Goobbue Rootbelt  (WAIST, lv35)  — Rampaging Goobbue
-- Twisted from the living roots off a Goobbue's shoulders. Still trying to grow.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (236,0,'goobbue_rootbelt','goob_rootbelt',1,59476,0,0,7000);
REPLACE INTO `item_equipment` VALUES (236,'goob_rootbelt',35,0,4194303,0,0,0,512,0,0,0);
REPLACE INTO `item_mods` VALUES (236,2,120),(236,10,14),(236,8,10),(236,1,20),(236,23,15);

-- ---------------------------------------------------------------------------
-- 237: Dread Hunter's Choker  (NECK, lv50)  — Dread Hunter (Coeurl)
-- Crystallized mane-fur from a coeurl that fed on too many crystals.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (237,0,'dread_hunters_choker','drd_hnt_chokr',1,59476,0,0,12000);
REPLACE INTO `item_equipment` VALUES (237,'drd_hnt_chokr',50,0,4194303,0,0,0,2,0,0,0);
REPLACE INTO `item_mods` VALUES (237,23,28),(237,25,20),(237,9,12),(237,384,8),(237,2,60);

-- ---------------------------------------------------------------------------
-- 238: Fell Commander's Vambrace  (HANDS, lv55)  — Fell Commander
-- Bronze vambrace of a Quadav war-leader. The engravings still pulse.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (238,0,'fell_commanders_vambrace','fell_cmd_vamb',1,59476,0,0,15000);
REPLACE INTO `item_equipment` VALUES (238,'fell_cmd_vamb',55,0,4194303,0,0,0,32,0,0,0);
REPLACE INTO `item_mods` VALUES (238,1,20),(238,8,12),(238,23,20),(238,25,15),(238,2,80),(238,27,10);

-- ---------------------------------------------------------------------------
-- 239: Nexus Core Helm  (HEAD, lv50)  — Storm Nexus
-- Elemental forces solidified into a helmet. The wearer sees reality differently.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (239,0,'nexus_core_helm','nexus_core_hlm',1,59476,0,0,13000);
REPLACE INTO `item_equipment` VALUES (239,'nexus_core_hlm',50,0,4194303,0,0,0,1,0,0,0);
REPLACE INTO `item_mods` VALUES (239,28,25),(239,30,18),(239,12,15),(239,5,80),(239,384,8);

-- ---------------------------------------------------------------------------
-- 240: Crystal Golem's Heart  (EAR, lv55)  — Crystal Golem
-- The gemstone core that animated the golem. Still pulses like a heartbeat.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (240,0,'crystal_golems_heart','cryst_golm_hrt',1,59476,0,0,11000);
REPLACE INTO `item_equipment` VALUES (240,'cryst_golm_hrt',55,0,4194303,0,0,0,4,0,0,0);
REPLACE INTO `item_mods` VALUES (240,1,12),(240,2,100),(240,10,15),(240,29,20);

-- ---------------------------------------------------------------------------
-- 241: Void Wyrm's Fang  (NECK, lv75)  — Void Wyrm
-- A tooth from the void dragon, still leaking destructive essence.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (241,0,'void_wyrms_fang','void_wyrm_fang',1,59476,0,0,40000);
REPLACE INTO `item_equipment` VALUES (241,'void_wyrm_fang',75,0,4194303,0,0,0,2,0,0,0);
REPLACE INTO `item_mods` VALUES (241,23,40),(241,28,35),(241,8,15),(241,12,12),(241,384,12),(241,2,80);

-- ---------------------------------------------------------------------------
-- 242: Abyssal Tyrant's Diadem  (HEAD, lv75)  — Abyssal Tyrant
-- The horned crown of a demon lord. It fits. This is alarming.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (242,0,'abyssal_tyrants_diadem','abys_typ_diad',1,59476,0,0,50000);
REPLACE INTO `item_equipment` VALUES (242,'abys_typ_diad',75,0,4194303,0,0,0,1,0,0,0);
REPLACE INTO `item_mods` VALUES (242,8,15),(242,12,15),(242,13,12),(242,23,30),(242,28,28),(242,25,20),(242,30,18),(242,2,120);

-- ---------------------------------------------------------------------------
-- 243: Ancient King's Carapace  (BODY, lv75)  — Ancient King
-- Armor shaped from the shell of the Ancient King. A village sheltered here once.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (243,0,'ancient_kings_carapace','anc_kng_carap',1,59476,0,0,60000);
REPLACE INTO `item_equipment` VALUES (243,'anc_kng_carap',75,0,4194303,0,0,0,16,0,0,0);
REPLACE INTO `item_mods` VALUES (243,1,50),(243,2,300),(243,10,20),(243,29,35),(243,27,15);

-- ---------------------------------------------------------------------------
-- 244: Apex Soulstone  (RING, lv60)  — Apex-tier (generic)
-- A gemstone formed from crystallized dynamic energy.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (244,0,'apex_soulstone','apex_soulstone',1,59476,0,0,20000);
REPLACE INTO `item_equipment` VALUES (244,'apex_soulstone',60,0,4194303,0,0,0,64,0,0,0);
REPLACE INTO `item_mods` VALUES (244,2,120),(244,5,80),(244,8,12),(244,12,12),(244,23,20),(244,28,20),(244,384,10);

-- ---------------------------------------------------------------------------
-- 245: Wanderer's Legacy  (RING, lv75)  — Apex-tier (prestige)
-- A ring worn by adventurers who have hunted the Dynamic World thoroughly.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (245,0,'wanderers_legacy','wandrers_lgcy',1,59476,0,0,75000);
REPLACE INTO `item_equipment` VALUES (245,'wandrers_lgcy',75,0,4194303,0,0,0,64,0,0,0);
REPLACE INTO `item_mods` VALUES (245,2,150),(245,5,100),(245,8,10),(245,9,10),(245,10,10),(245,11,10),(245,12,10),(245,13,10),(245,384,15);

-- ---------------------------------------------------------------------------
-- 249: Void Wyrm Scale  (BACK, lv75)  — Void Wyrm (alternate drop)
-- A scale the size of a shield. Absorbs blows and helps you hit harder.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (249,0,'void_wyrm_scale','void_wyrm_scl',1,59476,0,0,45000);
REPLACE INTO `item_equipment` VALUES (249,'void_wyrm_scl',75,0,4194303,0,0,0,256,0,0,0);
REPLACE INTO `item_mods` VALUES (249,1,30),(249,23,35),(249,8,15),(249,10,15),(249,2,150),(249,384,10);
