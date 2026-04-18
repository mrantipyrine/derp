-- =============================================================================
-- CUSTOM ITEMS - Dynamic World Drops
-- =============================================================================
-- Safe ID range: 30000-30999 (vanilla tops out ~29695)
--
-- HOW TO ADD A NEW ITEM:
--   1. Pick the next unused ID in the 30000+ range
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

USE xidb;

-- =============================================================================
-- SECTION 1: NAMED MOB DROPS (rare, fun, personality items)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Mushroom Morris drops
-- A rare Fungar with a wide hat and suspicious grin.
-- -----------------------------------------------------------------------------

-- [30000] Morris's Wide Brim  (head, all jobs, lv1, silly flavor)
REPLACE INTO `item_basic` VALUES
    (30000, 0, "Morris's_Wide_Brim", "morriss_wide_brim", 1, 46660, 99, 0, 500);

REPLACE INTO `item_equipment` VALUES
    -- itemId  name                    lv  ilv  jobs       MId  shieldSz  scriptType  slot  rslot  rslotlook  su_lv
    (30000, "morriss_wide_brim",        1,   0,  4194303,    0,        0,         0,    1,     0,         0,     0);
    --                                                       ^all jobs              ^HEAD slot

REPLACE INTO `item_mods` VALUES
    (30000,  2,  50),   -- HP +50
    (30000,  13,   5),   -- MND +5   (he's wise in mushroom ways)
    (30000, 14,   5);   -- CHR +5   (very charming hat)


-- [30001] Morris's Sporeling  (rare key item / curiosity, no equip — just a trophy drop)
REPLACE INTO `item_basic` VALUES
    (30001, 0, "Morris's_Sporeling", "morriss_sporeling", 1, 46660, 99, 1, 0);
    -- NoSale=1, BaseSell=0 — unsellable trophy


-- [30002] Mycelium Medal  (neck, all jobs, lv10, rare reward)
REPLACE INTO `item_basic` VALUES
    (30002, 0, "Mycelium_Medal", "mycelium_medal", 1, 46660, 99, 0, 800);

REPLACE INTO `item_equipment` VALUES
    (30002, "mycelium_medal",           10,  0,  4194303,    0,        0,         0,    4,     0,         0,     0);
    --                                                                                   ^NECK slot

REPLACE INTO `item_mods` VALUES
    (30002,  2,  30),   -- HP +30
    (30002,  5,  15),   -- MP +15
    (30002, 384,   5);   -- Haste +5


-- =============================================================================
-- SECTION 2: DYNAMIC WORLD TIER REWARDS
-- Generic rare drops from Elite / Apex tiers
-- =============================================================================

-- [30010] Wanderer's Token  (ring, all jobs, lv1)
REPLACE INTO `item_basic` VALUES
    (30010, 0, "Wanderer's_Token", "wanderers_token", 1, 46660, 99, 0, 200);
REPLACE INTO `item_equipment` VALUES
    (30010, "wanderers_token",           1,  0,  4194303,    0,        0,         0,   64,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (30010,  8,   3),   -- STR +3
    (30010,  9,   3);   -- DEX +3

-- [30011] Nomad's Cord  (waist, all jobs, lv20)
REPLACE INTO `item_basic` VALUES
    (30011, 0, "Nomad's_Cord", "nomads_cord", 1, 46660, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (30011, "nomads_cord",              20,  0,  4194303,    0,        0,         0,  512,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (30011,  8,   5),   -- STR +5
    (30011,  10,   5),   -- VIT +5
    (30011, 23,  10);   -- ATT +10

-- [30012] Elite's Resolve  (back, all jobs, lv40)
REPLACE INTO `item_basic` VALUES
    (30012, 0, "Elite's_Resolve", "elites_resolve", 1, 46660, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (30012, "elites_resolve",           40,  0,  4194303,    0,        0,         0,  256,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (30012,  2,  50),   -- HP +50
    (30012,  8,   8),   -- STR +8
    (30012, 23,  15),   -- ATT +15
    (30012, 25,  10);   -- ACC +10

-- [30013] Apex Shard  (ring, all jobs, lv50)
REPLACE INTO `item_basic` VALUES
    (30013, 0, "Apex_Shard", "apex_shard", 1, 46660, 99, 0, 10000);
REPLACE INTO `item_equipment` VALUES
    (30013, "apex_shard",               50,  0,  4194303,    0,        0,         0,   64,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (30013,  2, 100),   -- HP +100
    (30013,  5,  50),   -- MP +50
    (30013,  8,  10),   -- STR +10
    (30013,  12,  10),   -- INT +10
    (30013, 384,  10);   -- Haste +10


-- =============================================================================
-- SECTION 3: NAMED RARE UNIQUE DROPS
-- Every named rare has 3 items: trophy (always), gear1 (40%), gear2 (15%)
-- =============================================================================

-- =========================================================
-- SHEEP
-- =========================================================

-- Wooly William (lv6-8) — 30100-30102
REPLACE INTO `item_basic` VALUES
    (30100, 0, "William's_Wool", "williams_wool", 1, 46660, 99, 0, 50);
-- trophy, no equip

REPLACE INTO `item_basic` VALUES
    (30101, 0, "William's_Woolcap", "williams_woolcap", 1, 46660, 99, 0, 300);
REPLACE INTO `item_equipment` VALUES
    (30101, "williams_woolcap",          5,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30101,  1,   3),   -- DEF +3
    (30101,  2,  15),   -- HP +15
    (30101, 14,   3);   -- CHR +3

REPLACE INTO `item_basic` VALUES
    (30102, 0, "William's_Woolmitt", "williams_woolmitt", 1, 46660, 99, 0, 500);
REPLACE INTO `item_equipment` VALUES
    (30102, "williams_woolmitt",         5,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30102,  1,   2),   -- DEF +2
    (30102,  10,   3),   -- VIT +3
    (30102,  13,   3);   -- MND +3


-- Baa-rbara (lv10-13) — 30103-30105
REPLACE INTO `item_basic` VALUES
    (30103, 0, "Baarbara's_Bell", "baarbaras_bell", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30104, 0, "Baarbara's_Collar", "baarbaras_collar", 1, 46660, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30104, "baarbaras_collar",         10,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30104,  2,  20),   -- HP +20
    (30104, 14,   5),   -- CHR +5
    (30104,  13,   3);   -- MND +3

REPLACE INTO `item_basic` VALUES
    (30105, 0, "Baarbara's_Ribbon", "baarbaras_ribbon", 1, 46660, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (30105, "baarbaras_ribbon",         10,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30105, 68,   5),   -- EVA +5
    (30105,  11,   4),   -- AGI +4
    (30105, 14,   4);   -- CHR +4


-- Lambchop Larry (lv20-24) — 30106-30108
REPLACE INTO `item_basic` VALUES
    (30106, 0, "Larry's_Lambchop", "larrys_lambchop", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30107, 0, "Larry's_Lucky_Fleece", "larrys_lucky_fleece", 1, 46660, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (30107, "larrys_lucky_fleece",      20,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30107,  1,   8),   -- DEF +8
    (30107,  2,  30),   -- HP +30
    (30107, 68,   5);   -- EVA +5

REPLACE INTO `item_basic` VALUES
    (30108, 0, "Larry's_Lanyard", "larrys_lanyard", 1, 46660, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (30108, "larrys_lanyard",           20,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30108,  8,   5),   -- STR +5
    (30108, 23,   8),   -- ATT +8
    (30108, 25,   5);   -- ACC +5


-- Shear Sharon (lv35-40) — 30109-30111
REPLACE INTO `item_basic` VALUES
    (30109, 0, "Sharon's_Golden_Fleece", "sharons_golden_fleece", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30110, 0, "Sharon's_Shears", "sharons_shears", 1, 46660, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (30110, "sharons_shears",           35,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30110,  1,  12),   -- DEF +12
    (30110,  9,   8),   -- DEX +8
    (30110, 25,  10),   -- ACC +10
    (30110, 23,   8);   -- ATT +8

REPLACE INTO `item_basic` VALUES
    (30111, 0, "Sharon's_Silken_Mantle", "sharons_silken_mantle", 1, 46660, 99, 0, 6000);
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
    (30130, 0, "Tom's_Cottontail", "toms_cottontail", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30131, 0, "Tom's_Lucky_Foot", "toms_lucky_foot", 1, 46660, 99, 0, 300);
REPLACE INTO `item_equipment` VALUES
    (30131, "toms_lucky_foot",           5,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30131,  11,   3),   -- AGI +3
    (30131, 68,   3);   -- EVA +3

REPLACE INTO `item_basic` VALUES
    (30132, 0, "Tom's_Hop_Boots", "toms_hop_boots", 1, 46660, 99, 0, 500);
REPLACE INTO `item_equipment` VALUES
    (30132, "toms_hop_boots",            5,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30132,  1,   2),   -- DEF +2
    (30132,  11,   4),   -- AGI +4
    (30132, 68,   3);   -- EVA +3


-- Hopscotch Harvey (lv10-13) — 30133-30135
REPLACE INTO `item_basic` VALUES
    (30133, 0, "Harvey's_Hopstone", "harveys_hopstone", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30134, 0, "Harvey's_Hop_Ring", "harveys_hop_ring", 1, 46660, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30134, "harveys_hop_ring",         10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30134,  11,   5),   -- AGI +5
    (30134,  9,   3),   -- DEX +3
    (30134, 68,   5);   -- EVA +5

REPLACE INTO `item_basic` VALUES
    (30135, 0, "Harvey's_Spring_Earring", "harveys_spring_earring", 1, 46660, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (30135, "harveys_spring_earring",   10,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30135,  11,   6),   -- AGI +6
    (30135, 384,   3);   -- Haste +3


-- Bunbun Benedict (lv22-28) — 30136-30138
REPLACE INTO `item_basic` VALUES
    (30136, 0, "Benedict's_Bonnet", "benedicts_bonnet_trophy", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30137, 0, "Benedict's_Fur_Cap", "benedicts_fur_cap", 1, 46660, 99, 0, 1400);
REPLACE INTO `item_equipment` VALUES
    (30137, "benedicts_fur_cap",        22,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30137,  1,   8),   -- DEF +8
    (30137,  11,   6),   -- AGI +6
    (30137, 68,   8),   -- EVA +8
    (30137,  2,  25);   -- HP +25

REPLACE INTO `item_basic` VALUES
    (30138, 0, "Benedict's_Burrow_Belt", "benedicts_burrow_belt", 1, 46660, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (30138, "benedicts_burrow_belt",    22,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30138,  9,   6),   -- DEX +6
    (30138,  11,   6),   -- AGI +6
    (30138, 25,   8);   -- ACC +8


-- Twitchy Theodore (lv38-45) — 30139-30141
REPLACE INTO `item_basic` VALUES
    (30139, 0, "Theodore's_Twitch", "theodores_twitch", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30140, 0, "Theodore's_Dash_Greaves", "theodores_dash_greaves", 1, 46660, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (30140, "theodores_dash_greaves",   38,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30140,  1,  14),   -- DEF +14
    (30140,  11,  10),   -- AGI +10
    (30140, 68,  12),   -- EVA +12
    (30140, 384,   5);   -- Haste +5

REPLACE INTO `item_basic` VALUES
    (30141, 0, "Theodore's_Panic_Earring", "theodores_panic_earring", 1, 46660, 99, 0, 7000);
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
    (30160, 0, "Cameron's_Claw", "camerons_claw", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30161, 0, "Cameron's_Shell_Shield", "camerons_shell_shield", 1, 46660, 99, 0, 700);
REPLACE INTO `item_equipment` VALUES
    (30161, "camerons_shell_shield",    12,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30161,  1,   5),   -- DEF +5
    (30161,  10,   4),   -- VIT +4
    (30161,  2,  20);   -- HP +20

REPLACE INTO `item_basic` VALUES
    (30162, 0, "Cameron's_Coral_Ring", "camerons_coral_ring", 1, 46660, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (30162, "camerons_coral_ring",      12,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30162,  10,   5),   -- VIT +5
    (30162,  1,   4),   -- DEF +4
    (30162, 29,   4);   -- MDEF +4


-- Old Bay Ollie (lv25-30) — 30163-30165
REPLACE INTO `item_basic` VALUES
    (30163, 0, "Ollie's_Old_Shell", "ollies_old_shell", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30164, 0, "Ollie's_Brine_Gauntlets", "ollies_brine_gauntlets", 1, 46660, 99, 0, 1600);
REPLACE INTO `item_equipment` VALUES
    (30164, "ollies_brine_gauntlets",   25,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30164,  1,  10),   -- DEF +10
    (30164,  10,   7),   -- VIT +7
    (30164,  2,  30),   -- HP +30
    (30164, 27,   3);   -- Enmity +3

REPLACE INTO `item_basic` VALUES
    (30165, 0, "Ollie's_Seasoned_Belt", "ollies_seasoned_belt", 1, 46660, 99, 0, 2500);
REPLACE INTO `item_equipment` VALUES
    (30165, "ollies_seasoned_belt",     25,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30165,  10,   8),   -- VIT +8
    (30165,  1,   8),   -- DEF +8
    (30165, 29,   6);   -- MDEF +6


-- Bisque Bernard (lv35-42) — 30166-30168
REPLACE INTO `item_basic` VALUES
    (30166, 0, "Bernard's_Bisque_Bowl", "bernards_bisque_bowl", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30167, 0, "Bernard's_Tidal_Mail", "bernards_tidal_mail", 1, 46660, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (30167, "bernards_tidal_mail",      35,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30167,  1,  18),   -- DEF +18
    (30167,  10,  10),   -- VIT +10
    (30167,  2,  50),   -- HP +50
    (30167, 27,   5);   -- Enmity +5

REPLACE INTO `item_basic` VALUES
    (30168, 0, "Bernard's_Brine_Earring", "bernards_brine_earring", 1, 46660, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (30168, "bernards_brine_earring",   35,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30168,  10,   8),   -- VIT +8
    (30168, 29,  10),   -- MDEF +10
    (30168,  5,  20);   -- MP +20


-- Dungeness Duncan (lv45-52) — 30169-30171
REPLACE INTO `item_basic` VALUES
    (30169, 0, "Duncan's_Pincer", "duncans_pincer", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30170, 0, "Duncan's_Abyssal_Helm", "duncans_abyssal_helm", 1, 46660, 99, 0, 8000);
REPLACE INTO `item_equipment` VALUES
    (30170, "duncans_abyssal_helm",     45,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30170,  1,  22),   -- DEF +22
    (30170,  10,  12),   -- VIT +12
    (30170,  2,  60),   -- HP +60
    (30170, 29,  10);   -- MDEF +10

REPLACE INTO `item_basic` VALUES
    (30171, 0, "Duncan's_Deepwater_Ring", "duncans_deepwater_ring", 1, 46660, 99, 0, 12000);
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
    (30190, 0, "Chanterelle's_Cap", "chanterelles_cap_trophy", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30191, 0, "Chanterelle's_Spore_Hat", "chanterelles_spore_hat", 1, 46660, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (30191, "chanterelles_spore_hat",   18,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30191,  1,   7),   -- DEF +7
    (30191,  12,   5),   -- INT +5
    (30191,  5,  20),   -- MP +20
    (30191, 28,   4);   -- MATK +4

REPLACE INTO `item_basic` VALUES
    (30192, 0, "Chanterelle's_Mycelia", "chanterelles_mycelia", 1, 46660, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (30192, "chanterelles_mycelia",     18,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30192,  12,   6),   -- INT +6
    (30192,  13,   4),   -- MND +4
    (30192, 28,   5);   -- MATK +5


-- Portobello Pete (lv35-40) — 30193-30195
REPLACE INTO `item_basic` VALUES
    (30193, 0, "Pete's_Portobello", "petes_portobello", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30194, 0, "Pete's_Fungal_Robe", "petes_fungal_robe", 1, 46660, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (30194, "petes_fungal_robe",        35,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30194,  1,  15),   -- DEF +15
    (30194,  12,  10),   -- INT +10
    (30194,  5,  40),   -- MP +40
    (30194, 28,   8);   -- MATK +8

REPLACE INTO `item_basic` VALUES
    (30195, 0, "Pete's_Spore_Necklace", "petes_spore_necklace", 1, 46660, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (30195, "petes_spore_necklace",     35,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30195,  12,   8),   -- INT +8
    (30195, 28,  10),   -- MATK +10
    (30195, 30,   8);   -- MACC +8


-- Truffle Trevor (lv55-62) — 30196-30198
REPLACE INTO `item_basic` VALUES
    (30196, 0, "Trevor's_Truffle", "trevors_truffle", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30197, 0, "Trevor's_Myconid_Crown", "trevors_myconid_crown", 1, 46660, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (30197, "trevors_myconid_crown",    55,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30197,  1,  20),   -- DEF +20
    (30197,  12,  15),   -- INT +15
    (30197,  5,  60),   -- MP +60
    (30197, 28,  15),   -- MATK +15
    (30197, 30,  10);   -- MACC +10

REPLACE INTO `item_basic` VALUES
    (30198, 0, "Trevor's_Decay_Ring", "trevors_decay_ring", 1, 46660, 99, 0, 15000);
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
    (30220, 0, "Bruno's_Bargain_Bin", "brunos_bargain_bin", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30221, 0, "Bruno's_Discount_Helm", "brunos_discount_helm", 1, 46660, 99, 0, 700);
REPLACE INTO `item_equipment` VALUES
    (30221, "brunos_discount_helm",     12,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30221,  1,   5),   -- DEF +5
    (30221,  8,   3),   -- STR +3
    (30221,  9,   3),   -- DEX +3
    (30221, 14,   3);   -- CHR +3

REPLACE INTO `item_basic` VALUES
    (30222, 0, "Bruno's_Lucky_Pouch", "brunos_lucky_pouch", 1, 46660, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (30222, "brunos_lucky_pouch",       12,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30222,  9,   5),   -- DEX +5
    (30222, 25,   5),   -- ACC +5
    (30222, 14,   4);   -- CHR +4


-- Swindler Sam (lv30-36) — 30223-30225
REPLACE INTO `item_basic` VALUES
    (30223, 0, "Sam's_Loaded_Dice", "sams_loaded_dice", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30224, 0, "Sam's_Swindler_Vest", "sams_swindler_vest", 1, 46660, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (30224, "sams_swindler_vest",       30,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30224,  1,  14),   -- DEF +14
    (30224,  9,   8),   -- DEX +8
    (30224,  11,   6),   -- AGI +6
    (30224, 68,   8);   -- EVA +8

REPLACE INTO `item_basic` VALUES
    (30225, 0, "Sam's_Grift_Earring", "sams_grift_earring", 1, 46660, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (30225, "sams_grift_earring",       30,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30225,  9,   8),   -- DEX +8
    (30225, 25,  10),   -- ACC +10
    (30225, 384,   4);   -- Haste +4


-- Shiny Steve (lv45-52) — 30226-30228
REPLACE INTO `item_basic` VALUES
    (30226, 0, "Steve's_Shiniest", "steves_shiniest", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30227, 0, "Steve's_Glittering_Mail", "steves_glittering_mail", 1, 46660, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (30227, "steves_glittering_mail",   45,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30227,  1,  22),   -- DEF +22
    (30227,  9,  12),   -- DEX +12
    (30227,  11,  10),   -- AGI +10
    (30227, 25,  15),   -- ACC +15
    (30227, 68,  10);   -- EVA +10

REPLACE INTO `item_basic` VALUES
    (30228, 0, "Steve's_Magpie_Ring", "steves_magpie_ring", 1, 46660, 99, 0, 14000);
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
    (30250, 0, "Wilhelmina's_Whisker", "wilhelminas_whisker", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30251, 0, "Wilhelmina's_Fang_Neck", "wilhelminas_fang_necklace", 1, 46660, 99, 0, 3500);
REPLACE INTO `item_equipment` VALUES
    (30251, "wilhelminas_fang_necklace",30,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30251, 23,  10),   -- ATT +10
    (30251,  8,   7),   -- STR +7
    (30251,  9,   5);   -- DEX +5

REPLACE INTO `item_basic` VALUES
    (30252, 0, "Wilhelmina's_Grace_Legs", "wilhelminas_grace_legs", 1, 46660, 99, 0, 5500);
REPLACE INTO `item_equipment` VALUES
    (30252, "wilhelminas_grace_legs",   30,  0,  4194303,    0,   0,  0, 1024,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30252,  1,  14),   -- DEF +14
    (30252,  11,   8),   -- AGI +8
    (30252, 68,  10),   -- EVA +10
    (30252,  8,   6);   -- STR +6


-- Purring Patricia (lv42-48) — 30253-30255
REPLACE INTO `item_basic` VALUES
    (30253, 0, "Patricia's_Purr_Stone", "patricias_purr_stone", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30254, 0, "Patricia's_Claw_Gauntlets", "patricias_claw_gauntlets", 1, 46660, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (30254, "patricias_claw_gauntlets", 42,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30254,  1,  16),   -- DEF +16
    (30254,  8,  10),   -- STR +10
    (30254, 23,  14),   -- ATT +14
    (30254,  9,   8);   -- DEX +8

REPLACE INTO `item_basic` VALUES
    (30255, 0, "Patricia's_Predator_Cape", "patricias_predator_cape", 1, 46660, 99, 0, 10000);
REPLACE INTO `item_equipment` VALUES
    (30255, "patricias_predator_cape",  42,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30255,  8,  10),   -- STR +10
    (30255,  11,  10),   -- AGI +10
    (30255, 23,  12),   -- ATT +12
    (30255, 25,  12);   -- ACC +12


-- Nine Lives Nigel (lv58-65) — 30256-30258
REPLACE INTO `item_basic` VALUES
    (30256, 0, "Nigel's_Ninth_Life", "nigels_ninth_life", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30257, 0, "Nigel's_Feral_Cuirass", "nigels_feral_cuirass", 1, 46660, 99, 0, 15000);
REPLACE INTO `item_equipment` VALUES
    (30257, "nigels_feral_cuirass",     58,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30257,  1,  28),   -- DEF +28
    (30257,  8,  14),   -- STR +14
    (30257,  9,  12),   -- DEX +12
    (30257, 23,  18),   -- ATT +18
    (30257, 25,  15);   -- ACC +15

REPLACE INTO `item_basic` VALUES
    (30258, 0, "Nigel's_Cateye_Ring", "nigels_cateye_ring", 1, 46660, 99, 0, 18000);
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
    (30280, 0, "Steve's_Stripe", "steves_stripe_trophy", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30281, 0, "Steve's_Tiger_Fangs", "steves_tiger_fangs", 1, 46660, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (30281, "steves_tiger_fangs",       22,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30281,  8,   6),   -- STR +6
    (30281, 23,   8),   -- ATT +8
    (30281, 25,   5);   -- ACC +5

REPLACE INTO `item_basic` VALUES
    (30282, 0, "Steve's_Pelt_Mantle", "steves_pelt_mantle", 1, 46660, 99, 0, 2200);
REPLACE INTO `item_equipment` VALUES
    (30282, "steves_pelt_mantle",       22,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30282,  1,  10),   -- DEF +10
    (30282,  8,   7),   -- STR +7
    (30282,  10,   5),   -- VIT +5
    (30282,  2,  30);   -- HP +30


-- Mauler Maurice (lv38-46) — 30283-30285
REPLACE INTO `item_basic` VALUES
    (30283, 0, "Maurice's_Mauled_Hide", "maurices_mauled_hide", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30284, 0, "Maurice's_Savage_Helm", "maurices_savage_helm", 1, 46660, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (30284, "maurices_savage_helm",     38,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30284,  1,  16),   -- DEF +16
    (30284,  8,  10),   -- STR +10
    (30284, 23,  14),   -- ATT +14
    (30284,  2,  40);   -- HP +40

REPLACE INTO `item_basic` VALUES
    (30285, 0, "Maurice's_Mauler_Belt", "maurices_mauler_belt", 1, 46660, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (30285, "maurices_mauler_belt",     38,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30285,  8,  10),   -- STR +10
    (30285, 23,  15),   -- ATT +15
    (30285,  9,   8),   -- DEX +8
    (30285, 384,   4);   -- Haste +4


-- Saber Sabrina (lv58-65) — 30286-30288
REPLACE INTO `item_basic` VALUES
    (30286, 0, "Sabrina's_Saber-Fang", "sabrinas_saber_fang", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30287, 0, "Sabrina's_Feral_Legs", "sabrinas_feral_legs", 1, 46660, 99, 0, 15000);
REPLACE INTO `item_equipment` VALUES
    (30287, "sabrinas_feral_legs",         58,  0,  4194303,    0,   0,  0, 1024,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30287,  1,  24),   -- DEF +24
    (30287,  8,  14),   -- STR +14
    (30287,  9,  12),   -- DEX +12
    (30287, 23,  18),   -- ATT +18
    (30287, 25,  15);   -- ACC +15

REPLACE INTO `item_basic` VALUES
    (30288, 0, "Sabrina's_Apex_Ring", "sabrinas_apex_ring", 1, 46660, 99, 0, 20000);
REPLACE INTO `item_equipment` VALUES
    (30288, "sabrinas_apex_ring",           58,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30288,  8,  14),   -- STR +14
    (30288, 23,  20),   -- ATT +20
    (30288, 25,  18),   -- ACC +18
    (30288, 384,   6);   -- Haste +6


-- =========================================================
-- MANDRAGORAS
-- =========================================================

-- Root Rita (lv6-10) — 30310-30312
REPLACE INTO `item_basic` VALUES
    (30310, 0, "Rita's_Root", "ritas_root", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30311, 0, "Rita's_Leaf_Earring", "ritas_leaf_earring", 1, 46660, 99, 0, 400);
REPLACE INTO `item_equipment` VALUES
    (30311, "ritas_leaf_earring",        6,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30311,  13,   3),   -- MND +3
    (30311, 14,   3),   -- CHR +3
    (30311,  5,  10);   -- MP +10

REPLACE INTO `item_basic` VALUES
    (30312, 0, "Rita's_Petal_Wrist", "ritas_petal_wrist", 1, 46660, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30312, "ritas_petal_wrist",         6,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30312,  1,   3),   -- DEF +3
    (30312,  13,   4),   -- MND +4
    (30312,  5,  15);   -- MP +15


-- Sprout Spencer (lv22-28) — 30313-30315
REPLACE INTO `item_basic` VALUES
    (30313, 0, "Spencer's_Sprout", "spencers_sprout", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30314, 0, "Spencer's_Verdant_Hat", "spencers_verdant_hat", 1, 46660, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (30314, "spencers_verdant_hat",     22,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30314,  1,   8),   -- DEF +8
    (30314,  13,   7),   -- MND +7
    (30314,  5,  30),   -- MP +30
    (30314, 14,   5);   -- CHR +5

REPLACE INTO `item_basic` VALUES
    (30315, 0, "Spencer's_Bloom_Ring", "spencers_bloom_ring", 1, 46660, 99, 0, 2200);
REPLACE INTO `item_equipment` VALUES
    (30315, "spencers_bloom_ring",      22,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30315,  13,   7),   -- MND +7
    (30315,  12,   5),   -- INT +5
    (30315, 28,   6);   -- MATK +6


-- Mandrake Max (lv40-48) — 30316-30318
REPLACE INTO `item_basic` VALUES
    (30316, 0, "Max's_Mandrake_Heart", "maxs_mandrake_heart", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30317, 0, "Max's_Shriek_Mask", "maxs_shriek_mask", 1, 46660, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (30317, "maxs_shriek_mask",         40,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30317,  1,  16),   -- DEF +16
    (30317,  13,  12),   -- MND +12
    (30317,  12,  10),   -- INT +10
    (30317,  5,  45),   -- MP +45
    (30317, 28,  10);   -- MATK +10

REPLACE INTO `item_basic` VALUES
    (30318, 0, "Max's_Earthscream_Belt", "maxs_earthscream_belt", 1, 46660, 99, 0, 10000);
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
    (30340, 0, "Clayton's_Clicking_Shell", "claytons_clicking_shell", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30341, 0, "Clayton's_Chitin_Legs", "claytons_chitin_legs", 1, 46660, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30341, "claytons_chitin_legs",     10,  0,  4194303,    0,   0,  0, 1024,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30341,  1,   4),   -- DEF +4
    (30341,  10,   4),   -- VIT +4
    (30341,  2,  15);   -- HP +15

REPLACE INTO `item_basic` VALUES
    (30342, 0, "Clayton's_Clack_Ring", "claytons_clack_ring", 1, 46660, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (30342, "claytons_clack_ring",      10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30342,  1,   3),   -- DEF +3
    (30342,  10,   4),   -- VIT +4
    (30342,  8,   3);   -- STR +3


-- Dung Douglas (lv28-34) — 30343-30345
REPLACE INTO `item_basic` VALUES
    (30343, 0, "Douglas's_Dung_Ball", "douglass_dung_ball", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30344, 0, "Douglas's_Roller_Boots", "douglass_roller_boots", 1, 46660, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (30344, "douglass_roller_boots",    28,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30344,  1,  12),   -- DEF +12
    (30344,  10,   8),   -- VIT +8
    (30344,  8,   6),   -- STR +6
    (30344,  2,  30);   -- HP +30

REPLACE INTO `item_basic` VALUES
    (30345, 0, "Douglas's_Carapace_Neck", "douglass_carapace_necklace", 1, 46660, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (30345, "douglass_carapace_necklace",28,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30345,  10,   8),   -- VIT +8
    (30345,  1,   8),   -- DEF +8
    (30345, 29,   6);   -- MDEF +6


-- Scarab Sebastian (lv45-52) — 30346-30348
REPLACE INTO `item_basic` VALUES
    (30346, 0, "Sebastian's_Scarab", "sebastians_scarab", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30347, 0, "Sebastian's_Sacred_Helm", "sebastians_sacred_helm", 1, 46660, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (30347, "sebastians_sacred_helm",   45,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30347,  1,  22),   -- DEF +22
    (30347,  10,  12),   -- VIT +12
    (30347,  8,  10),   -- STR +10
    (30347,  2,  60),   -- HP +60
    (30347, 29,   8);   -- MDEF +8

REPLACE INTO `item_basic` VALUES
    (30348, 0, "Sebastian's_Jeweled_Ring", "sebastians_jeweled_ring", 1, 46660, 99, 0, 13000);
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
    (30370, 0, "Simon's_Silk_Thread", "simons_silk_thread", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30371, 0, "Simon's_Silk_Gloves", "simons_silk_gloves", 1, 46660, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (30371, "simons_silk_gloves",       15,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30371,  1,   5),   -- DEF +5
    (30371,  9,   5),   -- DEX +5
    (30371, 25,   5);   -- ACC +5

REPLACE INTO `item_basic` VALUES
    (30372, 0, "Simon's_Webbed_Cape", "simons_webbed_cape", 1, 46660, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (30372, "simons_webbed_cape",       15,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30372,  1,   6),   -- DEF +6
    (30372,  11,   5),   -- AGI +5
    (30372, 68,   6);   -- EVA +6


-- Cocoon Carl (lv50-58) — 30373-30375
REPLACE INTO `item_basic` VALUES
    (30373, 0, "Carl's_Cocoon_Shard", "carls_cocoon_shard", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30374, 0, "Carl's_Chrysalis_Mail", "carls_chrysalis_mail", 1, 46660, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (30374, "carls_chrysalis_mail",     50,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30374,  1,  25),   -- DEF +25
    (30374,  10,  12),   -- VIT +12
    (30374,  2,  70),   -- HP +70
    (30374, 29,  12),   -- MDEF +12
    (30374, 68,  10);   -- EVA +10

REPLACE INTO `item_basic` VALUES
    (30375, 0, "Carl's_Metamorph_Ring", "carls_metamorph_ring", 1, 46660, 99, 0, 16000);
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
    (30400, 0, "Fred's_Finest_Feather", "freds_finest_feather", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30401, 0, "Fred's_Down_Vest", "freds_down_vest", 1, 46660, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30401, "freds_down_vest",          10,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30401,  1,   5),   -- DEF +5
    (30401,  11,   4),   -- AGI +4
    (30401, 68,   4);   -- EVA +4

REPLACE INTO `item_basic` VALUES
    (30402, 0, "Fred's_Talon_Ring", "freds_talon_ring", 1, 46660, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (30402, "freds_talon_ring",         10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30402,  11,   4),   -- AGI +4
    (30402,  9,   3),   -- DEX +3
    (30402, 25,   4);   -- ACC +4


-- Beaky Beatrice (lv28-35) — 30403-30405
REPLACE INTO `item_basic` VALUES
    (30403, 0, "Beatrice's_Beak_Tip", "beatrices_beak_tip", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30404, 0, "Beatrice's_Plume_Hat", "beatrices_plume_hat", 1, 46660, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (30404, "beatrices_plume_hat",      28,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30404,  1,  10),   -- DEF +10
    (30404,  11,   8),   -- AGI +8
    (30404, 68,  10),   -- EVA +10
    (30404, 14,   5);   -- CHR +5

REPLACE INTO `item_basic` VALUES
    (30405, 0, "Beatrice's_Wind_Earring", "beatrices_wind_earring", 1, 46660, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (30405, "beatrices_wind_earring",   28,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30405,  11,   8),   -- AGI +8
    (30405, 68,  12),   -- EVA +12
    (30405, 384,   3);   -- Haste +3


-- Plume Patricia (lv50-58) — 30406-30408
REPLACE INTO `item_basic` VALUES
    (30406, 0, "Patricia's_Tail_Plume", "patricias_tail_plume", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30407, 0, "Patricia's_Zephyr_Vest", "patricias_zephyr_vest", 1, 46660, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (30407, "patricias_zephyr_vest",    50,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30407,  1,  20),   -- DEF +20
    (30407,  11,  14),   -- AGI +14
    (30407, 68,  18),   -- EVA +18
    (30407, 384,   5),   -- Haste +5
    (30407, 25,  10);   -- ACC +10

REPLACE INTO `item_basic` VALUES
    (30408, 0, "Patricia's_Gale_Ring", "patricias_gale_ring", 1, 46660, 99, 0, 16000);
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
    (30430, 0, "Harold's_Honeycomb", "harolds_honeycomb", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30431, 0, "Harold's_Honey_Earring", "harolds_honey_earring", 1, 46660, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (30431, "harolds_honey_earring",    10,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30431, 14,   5),   -- CHR +5
    (30431,  13,   3),   -- MND +3
    (30431,  2,  15);   -- HP +15

REPLACE INTO `item_basic` VALUES
    (30432, 0, "Harold's_Stinger_Ring", "harolds_stinger_ring", 1, 46660, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (30432, "harolds_stinger_ring",     10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30432,  9,   4),   -- DEX +4
    (30432, 23,   4),   -- ATT +4
    (30432,  8,   3);   -- STR +3


-- Buzzard Barry (lv30-38) — 30433-30435
REPLACE INTO `item_basic` VALUES
    (30433, 0, "Barry's_Broken_Wing", "barrys_broken_wing", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30434, 0, "Barry's_Venom_Gauntlets", "barrys_venom_gauntlets", 1, 46660, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (30434, "barrys_venom_gauntlets",   30,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30434,  1,  12),   -- DEF +12
    (30434,  9,   8),   -- DEX +8
    (30434, 23,  10),   -- ATT +10
    (30434,  8,   6);   -- STR +6

REPLACE INTO `item_basic` VALUES
    (30435, 0, "Barry's_Swarm_Necklace", "barrys_swarm_necklace", 1, 46660, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (30435, "barrys_swarm_necklace",    30,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30435,  8,   8),   -- STR +8
    (30435, 23,  12),   -- ATT +12
    (30435, 25,   8);   -- ACC +8


-- Queen Quentin (lv62-70) — 30436-30438
REPLACE INTO `item_basic` VALUES
    (30436, 0, "Quentin's_Royal_Jelly", "quentins_royal_jelly", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30437, 0, "Quentin's_Royal_Crown", "quentins_royal_crown", 1, 46660, 99, 0, 18000);
REPLACE INTO `item_equipment` VALUES
    (30437, "quentins_royal_crown",     62,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30437,  1,  25),   -- DEF +25
    (30437,  2,  80),   -- HP +80
    (30437,  5,  40),   -- MP +40
    (30437, 14,  15),   -- CHR +15
    (30437,  13,  12);   -- MND +12

REPLACE INTO `item_basic` VALUES
    (30438, 0, "Quentin's_Hivemind_Ring", "quentins_hivemind_ring", 1, 46660, 99, 0, 22000);
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
    (30460, 0, "Winston's_Wiggle", "winstons_wiggle", 1, 46660, 99, 0, 20);

REPLACE INTO `item_basic` VALUES
    (30461, 0, "Winston's_Dirt_Ring", "winstons_dirt_ring", 1, 46660, 99, 0, 150);
REPLACE INTO `item_equipment` VALUES
    (30461, "winstons_dirt_ring",        1,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30461,  10,   2),   -- VIT +2
    (30461,  2,  10);   -- HP +10

REPLACE INTO `item_basic` VALUES
    (30462, 0, "Winston's_Earthen_Belt", "winstons_earthen_belt", 1, 46660, 99, 0, 250);
REPLACE INTO `item_equipment` VALUES
    (30462, "winstons_earthen_belt",     1,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30462,  10,   3),   -- VIT +3
    (30462,  8,   2);   -- STR +2


-- Squirmy Sherman (lv18-24) — 30463-30465
REPLACE INTO `item_basic` VALUES
    (30463, 0, "Sherman's_Squirm", "shermans_squirm", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30464, 0, "Sherman's_Subterran_Helm", "shermans_subterran_helm", 1, 46660, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (30464, "shermans_subterran_helm",  18,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30464,  1,   7),   -- DEF +7
    (30464,  10,   5),   -- VIT +5
    (30464,  2,  25),   -- HP +25
    (30464,  8,   4);   -- STR +4

REPLACE INTO `item_basic` VALUES
    (30465, 0, "Sherman's_Tunnel_Earring", "shermans_tunnel_earring", 1, 46660, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (30465, "shermans_tunnel_earring",  18,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30465,  10,   6),   -- VIT +6
    (30465,  8,   5),   -- STR +5
    (30465, 23,   6);   -- ATT +6


-- Earthcrawler Ernest (lv40-48) — 30466-30468
REPLACE INTO `item_basic` VALUES
    (30466, 0, "Ernest's_Earthen_Core", "ernests_earthen_core", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30467, 0, "Ernest's_Burrower_Vest", "ernests_burrower_vest", 1, 46660, 99, 0, 8000);
REPLACE INTO `item_equipment` VALUES
    (30467, "ernests_burrower_vest",     40,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30467,  1,  17),   -- DEF +17
    (30467,  10,  10),   -- VIT +10
    (30467,  8,   8),   -- STR +8
    (30467,  2,  55);   -- HP +55

REPLACE INTO `item_basic` VALUES
    (30468, 0, "Ernest's_Tremor_Boots", "ernests_tremor_boots", 1, 46660, 99, 0, 11000);
REPLACE INTO `item_equipment` VALUES
    (30468, "ernests_tremor_boots",      40,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30468,  1,  14),   -- DEF +14
    (30468,  10,   8),   -- VIT +8
    (30468,  2,  40),   -- HP +40
    (30468, 384,   4);   -- Haste +4


-- =========================================================
-- LIZARDS
-- =========================================================

-- Scaly Sally (lv8-12) — 30490-30492
REPLACE INTO `item_basic` VALUES
    (30490, 0, "Sally's_Scale_Chip", "sallys_scale_chip", 1, 46660, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (30491, 0, "Sally's_Scale_Ring", "sallys_scale_ring", 1, 46660, 99, 0, 350);
REPLACE INTO `item_equipment` VALUES
    (30491, "sallys_scale_ring",          8,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30491,  9,   4),   -- DEX +4
    (30491,  11,   3),   -- AGI +3
    (30491, 68,   4);   -- EVA +4

REPLACE INTO `item_basic` VALUES
    (30492, 0, "Sally's_Tail_Belt", "sallys_tail_belt", 1, 46660, 99, 0, 550);
REPLACE INTO `item_equipment` VALUES
    (30492, "sallys_tail_belt",           8,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30492,  8,   3),   -- STR +3
    (30492,  9,   3),   -- DEX +3
    (30492,  2,  10);   -- HP +10


-- Cold-blooded Carlos (lv30-36) — 30493-30495
REPLACE INTO `item_basic` VALUES
    (30493, 0, "Carlos's_Cold_Scale", "carloss_cold_scale", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30494, 0, "Carlos's_Reptile_Vest", "carloss_reptile_vest", 1, 46660, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (30494, "carloss_reptile_vest",       30,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30494,  1,  13),   -- DEF +13
    (30494,  8,   7),   -- STR +7
    (30494,  10,   7),   -- VIT +7
    (30494,  2,  35);   -- HP +35

REPLACE INTO `item_basic` VALUES
    (30495, 0, "Carlos's_Venom_Earring", "carloss_venom_earring", 1, 46660, 99, 0, 6500);
REPLACE INTO `item_equipment` VALUES
    (30495, "carloss_venom_earring",      30,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30495,  9,   7),   -- DEX +7
    (30495,  11,   6),   -- AGI +6
    (30495, 23,   8);   -- ATT +8


-- Basilisk Boris (lv52-60) — 30496-30498
REPLACE INTO `item_basic` VALUES
    (30496, 0, "Boris's_Basilisk_Eye", "boriss_basilisk_eye", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30497, 0, "Boris's_Granite_Carapace", "boriss_granite_carapace", 1, 46660, 99, 0, 13000);
REPLACE INTO `item_equipment` VALUES
    (30497, "boriss_granite_carapace",    52,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30497,  1,  25),   -- DEF +25
    (30497,  10,  14),   -- VIT +14
    (30497,  8,  12),   -- STR +12
    (30497,  2,  70),   -- HP +70
    (30497, 29,  10);   -- MDEF +10

REPLACE INTO `item_basic` VALUES
    (30498, 0, "Boris's_Stone_Gaze_Ring", "boriss_stone_gaze_ring", 1, 46660, 99, 0, 17000);
REPLACE INTO `item_equipment` VALUES
    (30498, "boriss_stone_gaze_ring",     52,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30498,  8,  12),   -- STR +12
    (30498,  10,  12),   -- VIT +12
    (30498,  1,  14),   -- DEF +14
    (30498, 384,   5);   -- Haste +5


-- =========================================================
-- THE JIMS (goblin comedy duo)
-- =========================================================

-- Little Jim (lv25-32, he's enormous) — 30520-30522
REPLACE INTO `item_basic` VALUES
    (30520, 0, "Little_Jim's_Big_Trophy", "little_jims_big_trophy", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30521, 0, "Little_Jim's_Big_Boots", "little_jims_big_boots", 1, 46660, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (30521, "little_jims_big_boots",    25,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30521,  1,  12),   -- DEF +12
    (30521,  8,   8),   -- STR +8
    (30521,  10,   8),   -- VIT +8
    (30521,  2,  35);   -- HP +35

REPLACE INTO `item_basic` VALUES
    (30522, 0, "Little_Jim's_Big_Ring", "little_jims_big_ring", 1, 46660, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (30522, "little_jims_big_ring",     25,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30522,  8,   8),   -- STR +8
    (30522,  10,   8),   -- VIT +8
    (30522, 23,  10);   -- ATT +10


-- Big Jim (lv25-32, he's tiny) — 30523-30525
REPLACE INTO `item_basic` VALUES
    (30523, 0, "Big_Jim's_Small_Trophy", "big_jims_small_trophy", 1, 46660, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (30524, 0, "Big_Jim's_Small_Hat", "big_jims_small_hat", 1, 46660, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (30524, "big_jims_small_hat",       25,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (30524,  1,   8),   -- DEF +8
    (30524,  11,   8),   -- AGI +8
    (30524,  9,   8),   -- DEX +8
    (30524, 68,  10);   -- EVA +10

REPLACE INTO `item_basic` VALUES
    (30525, 0, "Big_Jim's_Small_Ring", "big_jims_small_ring", 1, 46660, 99, 0, 3000);
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
--  WHERE i.itemid BETWEEN 30000 AND 30999
--  ORDER BY i.itemid;
--
-- SELECT * FROM item_mods WHERE itemId BETWEEN 30000 AND 30999 ORDER BY itemId, modId;
-- ============================================================
-- AUTO-GENERATED: 152 new named rares (IDs 30530-30985)
-- ============================================================

-- Wooly Winifred trophy + gear
REPLACE INTO `item_basic` VALUES (30530, 0, 'Winifred's Fleece', 'WnfrdFlce', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30531, 0, 'Winifred's Wool Cap', 'WnfrdWCap', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30531, 'WnfrdWCap', 28, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30531, 1, 14);
REPLACE INTO `item_mods` VALUES (30531, 14, 6);
REPLACE INTO `item_mods` VALUES (30531, 2, 30);
REPLACE INTO `item_basic` VALUES (30532, 0, 'Winifred's Wool Mittens', 'WnfrdWMit', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30532, 'WnfrdWMit', 28, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30532, 1, 10);
REPLACE INTO `item_mods` VALUES (30532, 12, 4);
REPLACE INTO `item_mods` VALUES (30532, 29, 10);

-- Bouncy Beatrice trophy + gear
REPLACE INTO `item_basic` VALUES (30533, 0, 'Beatrice's Lucky Foot', 'BtrcesFt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30534, 0, 'Beatrice's Sprinting Shoes', 'BtrceSShoe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30534, 'BtrceSShoe', 22, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30534, 1, 8);
REPLACE INTO `item_mods` VALUES (30534, 23, 6);
REPLACE INTO `item_mods` VALUES (30534, 68, 12);
REPLACE INTO `item_basic` VALUES (30535, 0, 'Beatrice's Hopping Hakama', 'BtrceHHkm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30535, 'BtrceHHkm', 22, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30535, 1, 11);
REPLACE INTO `item_mods` VALUES (30535, 13, 5);
REPLACE INTO `item_mods` VALUES (30535, 25, 8);

-- Crushing Clyde trophy + gear
REPLACE INTO `item_basic` VALUES (30536, 0, 'Clyde's Shell Shard', 'ClydeShrd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30537, 0, 'Clyde's Carapace Gauntlets', 'ClydeCGnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30537, 'ClydeCGnt', 32, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30537, 1, 15);
REPLACE INTO `item_mods` VALUES (30537, 14, 7);
REPLACE INTO `item_mods` VALUES (30537, 2, 40);
REPLACE INTO `item_basic` VALUES (30538, 0, 'Clyde's Pincer Belt', 'ClydePBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30538, 'ClydePBlt', 32, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30538, 1, 6);
REPLACE INTO `item_mods` VALUES (30538, 12, 5);
REPLACE INTO `item_mods` VALUES (30538, 29, 12);

-- Sneaky Seraphine trophy + gear
REPLACE INTO `item_basic` VALUES (30539, 0, 'Seraphine's Stolen Trinket', 'SrphnTrnk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30540, 0, 'Seraphine's Sneak Boots', 'SrphnSBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30540, 'SrphnSBts', 35, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30540, 1, 9);
REPLACE INTO `item_mods` VALUES (30540, 23, 7);
REPLACE INTO `item_mods` VALUES (30540, 68, 14);
REPLACE INTO `item_basic` VALUES (30541, 0, 'Seraphine's Rogue Ring', 'SrphnRRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30541, 'SrphnRRng', 35, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30541, 13, 5);
REPLACE INTO `item_mods` VALUES (30541, 25, 10);
REPLACE INTO `item_mods` VALUES (30541, 29, 8);

-- Crackling Cordelia trophy + gear
REPLACE INTO `item_basic` VALUES (30542, 0, 'Cordelia's Whisker', 'CrdelaWhsk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30543, 0, 'Cordelia's Static Earring', 'CrdelaEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30543, 'CrdelaEar', 45, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30543, 25, 6);
REPLACE INTO `item_mods` VALUES (30543, 28, 12);
REPLACE INTO `item_mods` VALUES (30543, 30, 8);
REPLACE INTO `item_basic` VALUES (30544, 0, 'Cordelia's Shock Mantle', 'CrdelasMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30544, 'CrdelasMnt', 45, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30544, 1, 10);
REPLACE INTO `item_mods` VALUES (30544, 12, 5);
REPLACE INTO `item_mods` VALUES (30544, 29, 14);

-- Ferocious Frederica trophy + gear
REPLACE INTO `item_basic` VALUES (30545, 0, 'Frederica's Fang', 'FrdrcaFng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30546, 0, 'Frederica's Predator Cloak', 'FrdrcaClk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30546, 'FrdrcaClk', 52, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30546, 1, 12);
REPLACE INTO `item_mods` VALUES (30546, 12, 7);
REPLACE INTO `item_mods` VALUES (30546, 29, 18);
REPLACE INTO `item_basic` VALUES (30547, 0, 'Frederica's Hunting Hose', 'FrdrcaHse', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30547, 'FrdrcaHse', 52, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30547, 1, 13);
REPLACE INTO `item_mods` VALUES (30547, 23, 6);
REPLACE INTO `item_mods` VALUES (30547, 68, 15);

-- Manic Millicent trophy + gear
REPLACE INTO `item_basic` VALUES (30548, 0, 'Millicent's Dried Petal', 'MllcntPtl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30549, 0, 'Millicent's Bloom Headband', 'MllcntHbd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30549, 'MllcntHbd', 28, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30549, 1, 9);
REPLACE INTO `item_mods` VALUES (30549, 68, 6);
REPLACE INTO `item_mods` VALUES (30549, 9, 35);
REPLACE INTO `item_basic` VALUES (30550, 0, 'Millicent's Garden Gloves', 'MllcntGGl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30550, 'MllcntGGl', 28, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30550, 1, 7);
REPLACE INTO `item_mods` VALUES (30550, 25, 5);
REPLACE INTO `item_mods` VALUES (30550, 28, 10);

-- Brutal Brendan trophy + gear
REPLACE INTO `item_basic` VALUES (30551, 0, 'Brendan's Carapace Chip', 'BrndnCrpC', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30552, 0, 'Brendan's Armored Breastplate', 'BrndnABpl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30552, 'BrndnABpl', 40, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30552, 1, 22);
REPLACE INTO `item_mods` VALUES (30552, 14, 7);
REPLACE INTO `item_mods` VALUES (30552, 2, 55);
REPLACE INTO `item_basic` VALUES (30553, 0, 'Brendan's Iron Greaves', 'BrndnIGrv', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30553, 'BrndnIGrv', 40, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30553, 1, 13);
REPLACE INTO `item_mods` VALUES (30553, 12, 5);
REPLACE INTO `item_mods` VALUES (30553, 29, 12);

-- Gale Gertrude trophy + gear
REPLACE INTO `item_basic` VALUES (30554, 0, 'Gertrude's Tailfeather', 'GrtrdTlft', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30555, 0, 'Gertrude's Galeforce Mantle', 'GrtrdGMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30555, 'GrtrdGMnt', 42, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30555, 1, 11);
REPLACE INTO `item_mods` VALUES (30555, 23, 7);
REPLACE INTO `item_mods` VALUES (30555, 68, 16);
REPLACE INTO `item_basic` VALUES (30556, 0, 'Gertrude's Windrunner Shoes', 'GrtrdWShs', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30556, 'GrtrdWShs', 42, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30556, 1, 10);
REPLACE INTO `item_mods` VALUES (30556, 13, 6);
REPLACE INTO `item_mods` VALUES (30556, 25, 12);

-- Venomous Valentina trophy + gear
REPLACE INTO `item_basic` VALUES (30557, 0, 'Valentina's Stinger', 'VlntnStng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30558, 0, 'Valentina's Hexed Hairpin', 'VlntnHHpn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30558, 'VlntnHHpn', 36, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30558, 1, 8);
REPLACE INTO `item_mods` VALUES (30558, 25, 6);
REPLACE INTO `item_mods` VALUES (30558, 30, 10);
REPLACE INTO `item_basic` VALUES (30559, 0, 'Valentina's Venom Ring', 'VlntnVRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30559, 'VlntnVRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30559, 25, 5);
REPLACE INTO `item_mods` VALUES (30559, 28, 12);
REPLACE INTO `item_mods` VALUES (30559, 9, 30);

-- Deep Dweller Deidre trophy + gear
REPLACE INTO `item_basic` VALUES (30560, 0, 'Deidre's Earthen Core', 'DdrErtCr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30561, 0, 'Deidre's Burrower's Boots', 'DdrBrwBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30561, 'DdrBrwBts', 44, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30561, 1, 12);
REPLACE INTO `item_mods` VALUES (30561, 14, 6);
REPLACE INTO `item_mods` VALUES (30561, 2, 40);
REPLACE INTO `item_basic` VALUES (30562, 0, 'Deidre's Mudskin Belt', 'DdrMdsBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30562, 'DdrMdsBlt', 44, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30562, 1, 7);
REPLACE INTO `item_mods` VALUES (30562, 12, 5);
REPLACE INTO `item_mods` VALUES (30562, 29, 14);

-- Venerable Vincenzo trophy + gear
REPLACE INTO `item_basic` VALUES (30563, 0, 'Vincenzo's Scale', 'VncznScle', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30564, 0, 'Vincenzo's Scaled Cuisses', 'VncznSCss', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30564, 'VncznSCss', 50, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30564, 1, 15);
REPLACE INTO `item_mods` VALUES (30564, 14, 7);
REPLACE INTO `item_mods` VALUES (30564, 2, 50);
REPLACE INTO `item_basic` VALUES (30565, 0, 'Vincenzo's Tough Tail Ring', 'VncznTRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30565, 'VncznTRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30565, 1, 4);
REPLACE INTO `item_mods` VALUES (30565, 12, 6);
REPLACE INTO `item_mods` VALUES (30565, 29, 14);

-- Grunt Gideon trophy + gear
REPLACE INTO `item_basic` VALUES (30566, 0, 'Gideon's Rusty Axe', 'GdnRAxe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30567, 0, 'Gideon's Studded Armband', 'GdnSArmb', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30567, 'GdnSArmb', 10, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30567, 1, 6);
REPLACE INTO `item_mods` VALUES (30567, 12, 3);
REPLACE INTO `item_mods` VALUES (30567, 29, 6);
REPLACE INTO `item_basic` VALUES (30568, 0, 'Gideon's Grunt Belt', 'GdnGBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30568, 'GdnGBlt', 10, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30568, 1, 3);
REPLACE INTO `item_mods` VALUES (30568, 14, 2);
REPLACE INTO `item_mods` VALUES (30568, 2, 15);

-- Sergeant Sven trophy + gear
REPLACE INTO `item_basic` VALUES (30569, 0, 'Sven's Campaign Medal', 'SvnCMdl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30570, 0, 'Sven's Warchief Helm', 'SvnWCHlm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30570, 'SvnWCHlm', 22, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30570, 1, 11);
REPLACE INTO `item_mods` VALUES (30570, 12, 5);
REPLACE INTO `item_mods` VALUES (30570, 14, 4);
REPLACE INTO `item_basic` VALUES (30571, 0, 'Sven's Battle Mantle', 'SvnBtlMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30571, 'SvnBtlMnt', 22, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30571, 1, 8);
REPLACE INTO `item_mods` VALUES (30571, 29, 10);
REPLACE INTO `item_mods` VALUES (30571, 12, 4);

-- Raging Reginald trophy + gear
REPLACE INTO `item_basic` VALUES (30572, 0, 'Reginald's Battle Standard', 'RgnldStnd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30573, 0, 'Reginald's Warbound Hauberk', 'RgnldWHbk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30573, 'RgnldWHbk', 35, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30573, 1, 20);
REPLACE INTO `item_mods` VALUES (30573, 12, 7);
REPLACE INTO `item_mods` VALUES (30573, 2, 60);
REPLACE INTO `item_basic` VALUES (30574, 0, 'Reginald's Crusher Greaves', 'RgnldCGrv', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30574, 'RgnldCGrv', 35, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30574, 1, 12);
REPLACE INTO `item_mods` VALUES (30574, 14, 6);
REPLACE INTO `item_mods` VALUES (30574, 29, 14);

-- Overlord Ophelia trophy + gear
REPLACE INTO `item_basic` VALUES (30575, 0, 'Ophelia's Warlord Crown', 'OphlCrwn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30576, 0, 'Ophelia's Dominion Plate', 'OphlDPlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30576, 'OphlDPlt', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30576, 1, 26);
REPLACE INTO `item_mods` VALUES (30576, 12, 9);
REPLACE INTO `item_mods` VALUES (30576, 14, 8);
REPLACE INTO `item_mods` VALUES (30576, 2, 80);
REPLACE INTO `item_basic` VALUES (30577, 0, 'Ophelia's Conquest Ring', 'OphlCRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30577, 'OphlCRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30577, 12, 6);
REPLACE INTO `item_mods` VALUES (30577, 29, 16);
REPLACE INTO `item_mods` VALUES (30577, 2, 25);

-- Fledgling Fenwick trophy + gear
REPLACE INTO `item_basic` VALUES (30578, 0, 'Fenwick's Broken Talon', 'FnwkTln', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30579, 0, 'Fenwick's Initiate Sandals', 'FnwkISndl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30579, 'FnwkISndl', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30579, 1, 5);
REPLACE INTO `item_mods` VALUES (30579, 23, 3);
REPLACE INTO `item_mods` VALUES (30579, 68, 6);
REPLACE INTO `item_basic` VALUES (30580, 0, 'Fenwick's Novice Sash', 'FnwkNSsh', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30580, 'FnwkNSsh', 10, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30580, 1, 3);
REPLACE INTO `item_mods` VALUES (30580, 13, 2);
REPLACE INTO `item_mods` VALUES (30580, 25, 4);

-- Devout Delilah trophy + gear
REPLACE INTO `item_basic` VALUES (30581, 0, 'Delilah's Prayer Beads', 'DllhPBds', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30582, 0, 'Delilah's Chanter's Collar', 'DllhCCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30582, 'DllhCCll', 22, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30582, 68, 5);
REPLACE INTO `item_mods` VALUES (30582, 9, 30);
REPLACE INTO `item_mods` VALUES (30582, 30, 6);
REPLACE INTO `item_basic` VALUES (30583, 0, 'Delilah's Sacred Earring', 'DllhSEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30583, 'DllhSEar', 22, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30583, 25, 4);
REPLACE INTO `item_mods` VALUES (30583, 28, 8);
REPLACE INTO `item_mods` VALUES (30583, 9, 20);

-- High Priest Horatio trophy + gear
REPLACE INTO `item_basic` VALUES (30584, 0, 'Horatio's Holy Relic', 'HrtHlyRlc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30585, 0, 'Horatio's Zealot's Mitre', 'HrtZMtre', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30585, 'HrtZMtre', 35, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30585, 1, 10);
REPLACE INTO `item_mods` VALUES (30585, 68, 7);
REPLACE INTO `item_mods` VALUES (30585, 9, 50);
REPLACE INTO `item_basic` VALUES (30586, 0, 'Horatio's Faith Ring', 'HrtFthRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30586, 'HrtFthRng', 35, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30586, 68, 5);
REPLACE INTO `item_mods` VALUES (30586, 30, 10);
REPLACE INTO `item_mods` VALUES (30586, 9, 25);

-- Divine Diomedea trophy + gear
REPLACE INTO `item_basic` VALUES (30587, 0, 'Diomedea's Golden Feather', 'DmdaGFthr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30588, 0, 'Diomedea's Ascension Robe', 'DmdaARbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30588, 'DmdaARbe', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30588, 1, 16);
REPLACE INTO `item_mods` VALUES (30588, 68, 9);
REPLACE INTO `item_mods` VALUES (30588, 9, 80);
REPLACE INTO `item_mods` VALUES (30588, 30, 10);
REPLACE INTO `item_basic` VALUES (30589, 0, 'Diomedea's Halo Headband', 'DmdaHHbd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30589, 'DmdaHHbd', 50, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30589, 1, 11);
REPLACE INTO `item_mods` VALUES (30589, 25, 7);
REPLACE INTO `item_mods` VALUES (30589, 28, 14);
REPLACE INTO `item_mods` VALUES (30589, 9, 40);

-- Copper Cornelius trophy + gear
REPLACE INTO `item_basic` VALUES (30590, 0, 'Cornelius's Copper Scale', 'CrnlsCpSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30591, 0, 'Cornelius's Shell Shield Shard', 'CrnlsSShr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30591, 'CrnlsSShr', 10, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30591, 1, 7);
REPLACE INTO `item_mods` VALUES (30591, 14, 3);
REPLACE INTO `item_mods` VALUES (30591, 2, 20);
REPLACE INTO `item_basic` VALUES (30592, 0, 'Cornelius's Miner's Anklet', 'CrnlsAnkl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30592, 'CrnlsAnkl', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30592, 1, 5);
REPLACE INTO `item_mods` VALUES (30592, 12, 2);
REPLACE INTO `item_mods` VALUES (30592, 14, 2);

-- Silver Sylvester trophy + gear
REPLACE INTO `item_basic` VALUES (30593, 0, 'Sylvester's Silver Ingot', 'SlvstIngot', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30594, 0, 'Sylvester's Polished Cuirass', 'SlvstPCrs', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30594, 'SlvstPCrs', 22, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30594, 1, 17);
REPLACE INTO `item_mods` VALUES (30594, 14, 5);
REPLACE INTO `item_mods` VALUES (30594, 2, 45);
REPLACE INTO `item_basic` VALUES (30595, 0, 'Sylvester's Guard Collar', 'SlvstGCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30595, 'SlvstGCll', 22, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30595, 1, 5);
REPLACE INTO `item_mods` VALUES (30595, 14, 4);
REPLACE INTO `item_mods` VALUES (30595, 29, 6);

-- Boulder Basil trophy + gear
REPLACE INTO `item_basic` VALUES (30596, 0, 'Basil's Boulder Chip', 'BaslBChip', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30597, 0, 'Basil's Fortress Greaves', 'BaslFGrv', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30597, 'BaslFGrv', 35, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30597, 1, 14);
REPLACE INTO `item_mods` VALUES (30597, 14, 7);
REPLACE INTO `item_mods` VALUES (30597, 2, 50);
REPLACE INTO `item_basic` VALUES (30598, 0, 'Basil's Rampart Ring', 'BaslRRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30598, 'BaslRRng', 35, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30598, 1, 5);
REPLACE INTO `item_mods` VALUES (30598, 14, 5);
REPLACE INTO `item_mods` VALUES (30598, 29, 8);

-- Diamond Desmond trophy + gear
REPLACE INTO `item_basic` VALUES (30599, 0, 'Desmond's Diamond Carapace', 'DsmndDCrp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30600, 0, 'Desmond's Ironclad Hauberk', 'DsmndIHbk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30600, 'DsmndIHbk', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30600, 1, 27);
REPLACE INTO `item_mods` VALUES (30600, 14, 9);
REPLACE INTO `item_mods` VALUES (30600, 2, 90);
REPLACE INTO `item_mods` VALUES (30600, 29, 10);
REPLACE INTO `item_basic` VALUES (30601, 0, 'Desmond's Warden's Visor', 'DsmndWVsr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30601, 'DsmndWVsr', 50, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30601, 1, 16);
REPLACE INTO `item_mods` VALUES (30601, 14, 7);
REPLACE INTO `item_mods` VALUES (30601, 2, 55);
REPLACE INTO `item_mods` VALUES (30601, 29, 8);

-- Flittering Fiona trophy + gear
REPLACE INTO `item_basic` VALUES (30602, 0, 'Fiona's Membrane Scrap', 'FnaMmbScp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30603, 0, 'Fiona's Wing Earring', 'FnaWngEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30603, 'FnaWngEar', 8, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30603, 23, 3);
REPLACE INTO `item_mods` VALUES (30603, 68, 5);
REPLACE INTO `item_mods` VALUES (30603, 13, 2);
REPLACE INTO `item_basic` VALUES (30604, 0, 'Fiona's Night Sandals', 'FnaNgtSnd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30604, 'FnaNgtSnd', 8, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30604, 1, 4);
REPLACE INTO `item_mods` VALUES (30604, 23, 3);
REPLACE INTO `item_mods` VALUES (30604, 68, 6);

-- Echo Edgar trophy + gear
REPLACE INTO `item_basic` VALUES (30605, 0, 'Edgar's Sonic Wing', 'EdgrSnWng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30606, 0, 'Edgar's Echolocation Earring', 'EdgrEEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30606, 'EdgrEEar', 18, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30606, 13, 4);
REPLACE INTO `item_mods` VALUES (30606, 25, 7);
REPLACE INTO `item_mods` VALUES (30606, 23, 4);
REPLACE INTO `item_basic` VALUES (30607, 0, 'Edgar's Shadow Mitts', 'EdgrShMtt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30607, 'EdgrShMtt', 18, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30607, 1, 8);
REPLACE INTO `item_mods` VALUES (30607, 23, 5);
REPLACE INTO `item_mods` VALUES (30607, 68, 10);

-- Vampiric Valerian trophy + gear
REPLACE INTO `item_basic` VALUES (30608, 0, 'Valerian's Blood Fang', 'VlrnBlFng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30609, 0, 'Valerian's Night Cowl', 'VlrnNtCwl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30609, 'VlrnNtCwl', 32, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30609, 1, 10);
REPLACE INTO `item_mods` VALUES (30609, 23, 6);
REPLACE INTO `item_mods` VALUES (30609, 68, 12);
REPLACE INTO `item_basic` VALUES (30610, 0, 'Valerian's Vampire Ring', 'VlrnVRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30610, 'VlrnVRng', 32, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30610, 23, 4);
REPLACE INTO `item_mods` VALUES (30610, 13, 5);
REPLACE INTO `item_mods` VALUES (30610, 25, 9);

-- Ancient Araminta trophy + gear
REPLACE INTO `item_basic` VALUES (30611, 0, 'Araminta's Ancient Fang', 'ArmntAFng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30612, 0, 'Araminta's Dusk Mantle', 'ArmntDMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30612, 'ArmntDMnt', 45, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30612, 1, 11);
REPLACE INTO `item_mods` VALUES (30612, 23, 8);
REPLACE INTO `item_mods` VALUES (30612, 68, 18);
REPLACE INTO `item_basic` VALUES (30613, 0, 'Araminta's Haste Anklet', 'ArmntHAnk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30613, 'ArmntHAnk', 45, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30613, 1, 10);
REPLACE INTO `item_mods` VALUES (30613, 23, 6);
REPLACE INTO `item_mods` VALUES (30613, 384, 4);

-- Slithering Silas trophy + gear
REPLACE INTO `item_basic` VALUES (30614, 0, 'Silas's Shed Scale', 'SlsShdScl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30615, 0, 'Silas's Snakeskin Sandals', 'SlsSnkSnd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30615, 'SlsSnkSnd', 8, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30615, 1, 4);
REPLACE INTO `item_mods` VALUES (30615, 23, 3);
REPLACE INTO `item_mods` VALUES (30615, 68, 5);
REPLACE INTO `item_basic` VALUES (30616, 0, 'Silas's Coil Sash', 'SlsColSsh', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30616, 'SlsColSsh', 8, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30616, 1, 3);
REPLACE INTO `item_mods` VALUES (30616, 12, 2);
REPLACE INTO `item_mods` VALUES (30616, 29, 4);

-- Hypnotic Heloise trophy + gear
REPLACE INTO `item_basic` VALUES (30617, 0, 'Heloise's Mesmer Scale', 'HlseMmSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30618, 0, 'Heloise's Charmer's Collar', 'HlseCCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30618, 'HlseCCll', 20, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30618, 28, 5);
REPLACE INTO `item_mods` VALUES (30618, 68, 4);
REPLACE INTO `item_mods` VALUES (30618, 9, 20);
REPLACE INTO `item_basic` VALUES (30619, 0, 'Heloise's Luring Earring', 'HlseLEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30619, 'HlseLEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30619, 28, 4);
REPLACE INTO `item_mods` VALUES (30619, 25, 3);
REPLACE INTO `item_mods` VALUES (30619, 30, 7);

-- Constrictor Cressida trophy + gear
REPLACE INTO `item_basic` VALUES (30620, 0, 'Cressida's Crushing Coil', 'CrsdCrCl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30621, 0, 'Cressida's Squeeze Gloves', 'CrsdSqGlv', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30621, 'CrsdSqGlv', 34, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30621, 1, 11);
REPLACE INTO `item_mods` VALUES (30621, 12, 6);
REPLACE INTO `item_mods` VALUES (30621, 29, 12);
REPLACE INTO `item_basic` VALUES (30622, 0, 'Cressida's Binding Belt', 'CrsdBBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30622, 'CrsdBBlt', 34, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30622, 1, 6);
REPLACE INTO `item_mods` VALUES (30622, 14, 5);
REPLACE INTO `item_mods` VALUES (30622, 2, 35);

-- Venom Duchess Viviane trophy + gear
REPLACE INTO `item_basic` VALUES (30623, 0, 'Viviane's Venom Sac', 'VvneVnSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30624, 0, 'Viviane's Toxic Tiara', 'VvneTxTar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30624, 'VvneTxTar', 48, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30624, 1, 12);
REPLACE INTO `item_mods` VALUES (30624, 25, 7);
REPLACE INTO `item_mods` VALUES (30624, 28, 14);
REPLACE INTO `item_mods` VALUES (30624, 30, 8);
REPLACE INTO `item_basic` VALUES (30625, 0, 'Viviane's Serpent Ring', 'VvneSrpRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30625, 'VvneSrpRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30625, 25, 5);
REPLACE INTO `item_mods` VALUES (30625, 30, 10);
REPLACE INTO `item_mods` VALUES (30625, 9, 30);

-- Buzzing Barnabas trophy + gear
REPLACE INTO `item_basic` VALUES (30626, 0, 'Barnabas's Compound Eye', 'BrnbsCmEy', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30627, 0, 'Barnabas's Wing Brooch', 'BrnbsWBrc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30627, 'BrnbsWBrc', 10, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30627, 13, 3);
REPLACE INTO `item_mods` VALUES (30627, 25, 5);
REPLACE INTO `item_mods` VALUES (30627, 23, 2);
REPLACE INTO `item_basic` VALUES (30628, 0, 'Barnabas's Buzzer Boots', 'BrnbsBBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30628, 'BrnbsBBts', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30628, 1, 5);
REPLACE INTO `item_mods` VALUES (30628, 23, 3);
REPLACE INTO `item_mods` VALUES (30628, 68, 7);

-- Droning Dorothea trophy + gear
REPLACE INTO `item_basic` VALUES (30629, 0, 'Dorothea's Drone Claw', 'DrthaDrnCl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30630, 0, 'Dorothea's Carapace Vest', 'DrthaCV', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30630, 'DrthaCV', 25, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30630, 1, 14);
REPLACE INTO `item_mods` VALUES (30630, 14, 4);
REPLACE INTO `item_mods` VALUES (30630, 2, 40);
REPLACE INTO `item_basic` VALUES (30631, 0, 'Dorothea's Hum Ring', 'DrthaHRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30631, 'DrthaHRng', 25, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30631, 13, 4);
REPLACE INTO `item_mods` VALUES (30631, 25, 8);
REPLACE INTO `item_mods` VALUES (30631, 29, 6);

-- Plague Bearer Percival trophy + gear
REPLACE INTO `item_basic` VALUES (30632, 0, 'Percival's Plague Gland', 'PrcvlPlGl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30633, 0, 'Percival's Pestilent Mask', 'PrcvlPMsk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30633, 'PrcvlPMsk', 38, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30633, 1, 11);
REPLACE INTO `item_mods` VALUES (30633, 25, 5);
REPLACE INTO `item_mods` VALUES (30633, 28, 10);
REPLACE INTO `item_basic` VALUES (30634, 0, 'Percival's Blight Mantle', 'PrcvlBMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30634, 'PrcvlBMnt', 38, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30634, 1, 9);
REPLACE INTO `item_mods` VALUES (30634, 12, 5);
REPLACE INTO `item_mods` VALUES (30634, 29, 12);

-- Swarm Queen Sophonias trophy + gear
REPLACE INTO `item_basic` VALUES (30635, 0, 'Sophonias's Royal Jelly', 'SphnsRJly', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30636, 0, 'Sophonias's Hivemind Helm', 'SphnHMHlm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30636, 'SphnHMHlm', 52, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30636, 1, 14);
REPLACE INTO `item_mods` VALUES (30636, 25, 8);
REPLACE INTO `item_mods` VALUES (30636, 28, 16);
REPLACE INTO `item_mods` VALUES (30636, 9, 50);
REPLACE INTO `item_basic` VALUES (30637, 0, 'Sophonias's Drone Tassets', 'SphnDTsst', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30637, 'SphnDTsst', 52, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30637, 1, 15);
REPLACE INTO `item_mods` VALUES (30637, 14, 7);
REPLACE INTO `item_mods` VALUES (30637, 2, 60);
REPLACE INTO `item_mods` VALUES (30637, 1, 3);

-- Gnawing Nathaniel trophy + gear
REPLACE INTO `item_basic` VALUES (30638, 0, 'Nathaniel's Gnawed Bone', 'NthnlBone', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30639, 0, 'Nathaniel's Rotting Armband', 'NthnlRArmb', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30639, 'NthnlRArmb', 14, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30639, 1, 5);
REPLACE INTO `item_mods` VALUES (30639, 12, 3);
REPLACE INTO `item_mods` VALUES (30639, 29, 6);
REPLACE INTO `item_basic` VALUES (30640, 0, 'Nathaniel's Grave Sandals', 'NthnlGSnd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30640, 'NthnlGSnd', 14, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30640, 1, 4);
REPLACE INTO `item_mods` VALUES (30640, 23, 2);
REPLACE INTO `item_mods` VALUES (30640, 68, 5);

-- Festering Francesca trophy + gear
REPLACE INTO `item_basic` VALUES (30641, 0, 'Francesca's Fetid Finger', 'FrncsFFng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30642, 0, 'Francesca's Blight Earring', 'FrncsBEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30642, 'FrncsBEar', 26, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30642, 25, 4);
REPLACE INTO `item_mods` VALUES (30642, 28, 8);
REPLACE INTO `item_mods` VALUES (30642, 30, 5);
REPLACE INTO `item_basic` VALUES (30643, 0, 'Francesca's Moaning Ring', 'FrncsRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30643, 'FrncsRng', 26, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30643, 25, 3);
REPLACE INTO `item_mods` VALUES (30643, 28, 7);
REPLACE INTO `item_mods` VALUES (30643, 9, 20);

-- Hunger Ravaged Hortensia trophy + gear
REPLACE INTO `item_basic` VALUES (30644, 0, 'Hortensia's Hunger Bile', 'HrtnHBle', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30645, 0, 'Hortensia's Maw Guard', 'HrtnMwGrd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30645, 'HrtnMwGrd', 38, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30645, 1, 18);
REPLACE INTO `item_mods` VALUES (30645, 14, 5);
REPLACE INTO `item_mods` VALUES (30645, 2, 55);
REPLACE INTO `item_basic` VALUES (30646, 0, 'Hortensia's Gnash Gauntlets', 'HrtnGGnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30646, 'HrtnGGnt', 38, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30646, 1, 12);
REPLACE INTO `item_mods` VALUES (30646, 12, 6);
REPLACE INTO `item_mods` VALUES (30646, 29, 13);

-- Carrion Cornelius trophy + gear
REPLACE INTO `item_basic` VALUES (30647, 0, 'Cornelius's Carrion Crown', 'CrnlsCCrn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30648, 0, 'Cornelius's Death Shroud', 'CrnlsDShr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30648, 'CrnlsDShr', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30648, 1, 22);
REPLACE INTO `item_mods` VALUES (30648, 25, 8);
REPLACE INTO `item_mods` VALUES (30648, 28, 16);
REPLACE INTO `item_mods` VALUES (30648, 9, 60);
REPLACE INTO `item_basic` VALUES (30649, 0, 'Cornelius's Grave Ring', 'CrnlsGRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30649, 'CrnlsGRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30649, 25, 6);
REPLACE INTO `item_mods` VALUES (30649, 30, 12);
REPLACE INTO `item_mods` VALUES (30649, 28, 10);

-- Rattling Roderick trophy + gear
REPLACE INTO `item_basic` VALUES (30650, 0, 'Roderick's Finger Bone', 'RdrckFBne', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30651, 0, 'Roderick's Bone Earring', 'RdrckBEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30651, 'RdrckBEar', 12, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30651, 25, 3);
REPLACE INTO `item_mods` VALUES (30651, 28, 5);
REPLACE INTO `item_mods` VALUES (30651, 9, 10);
REPLACE INTO `item_basic` VALUES (30652, 0, 'Roderick's Rattling Greaves', 'RdrckRGrv', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30652, 'RdrckRGrv', 12, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30652, 1, 5);
REPLACE INTO `item_mods` VALUES (30652, 14, 2);
REPLACE INTO `item_mods` VALUES (30652, 2, 15);

-- Cursed Cavendish trophy + gear
REPLACE INTO `item_basic` VALUES (30653, 0, 'Cavendish's Cursed Skull', 'CvndshSkl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30654, 0, 'Cavendish's Hex Collar', 'CvndshHCl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30654, 'CvndshHCl', 26, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30654, 25, 5);
REPLACE INTO `item_mods` VALUES (30654, 30, 8);
REPLACE INTO `item_mods` VALUES (30654, 9, 25);
REPLACE INTO `item_basic` VALUES (30655, 0, 'Cavendish's Marrow Earring', 'CvndshEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30655, 'CvndshEar', 26, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30655, 25, 4);
REPLACE INTO `item_mods` VALUES (30655, 28, 9);
REPLACE INTO `item_mods` VALUES (30655, 30, 6);

-- Bonewalker Benedict trophy + gear
REPLACE INTO `item_basic` VALUES (30656, 0, 'Benedict's Animated Femur', 'BndctFmur', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30657, 0, 'Benedict's Deathmarch Boots', 'BndctDBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30657, 'BndctDBts', 38, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30657, 1, 12);
REPLACE INTO `item_mods` VALUES (30657, 25, 5);
REPLACE INTO `item_mods` VALUES (30657, 28, 10);
REPLACE INTO `item_basic` VALUES (30658, 0, 'Benedict's Undying Belt', 'BndctUBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30658, 'BndctUBlt', 38, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30658, 1, 5);
REPLACE INTO `item_mods` VALUES (30658, 14, 4);
REPLACE INTO `item_mods` VALUES (30658, 2, 30);

-- Lich Lord Leontine trophy + gear
REPLACE INTO `item_basic` VALUES (30659, 0, 'Leontine's Lich Crystal', 'LntLchCry', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30660, 0, 'Leontine's Necromancer's Robe', 'LntNRobe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30660, 'LntNRobe', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30660, 1, 18);
REPLACE INTO `item_mods` VALUES (30660, 25, 10);
REPLACE INTO `item_mods` VALUES (30660, 28, 20);
REPLACE INTO `item_mods` VALUES (30660, 9, 80);
REPLACE INTO `item_basic` VALUES (30661, 0, 'Leontine's Soul Drinker Ring', 'LntSDRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30661, 'LntSDRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30661, 25, 7);
REPLACE INTO `item_mods` VALUES (30661, 28, 14);
REPLACE INTO `item_mods` VALUES (30661, 30, 12);

-- Snapping Simeon trophy + gear
REPLACE INTO `item_basic` VALUES (30662, 0, 'Simeon's Snapping Claw', 'SmeonClaw', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30663, 0, 'Simeon's Chitin Wristlets', 'SmeonWrst', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30663, 'SmeonWrst', 14, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30663, 1, 6);
REPLACE INTO `item_mods` VALUES (30663, 12, 3);
REPLACE INTO `item_mods` VALUES (30663, 29, 7);
REPLACE INTO `item_basic` VALUES (30664, 0, 'Simeon's Stinger Earring', 'SmeonSEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30664, 'SmeonSEar', 14, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30664, 13, 3);
REPLACE INTO `item_mods` VALUES (30664, 25, 5);
REPLACE INTO `item_mods` VALUES (30664, 29, 4);

-- Venomous Vespera trophy + gear
REPLACE INTO `item_basic` VALUES (30665, 0, 'Vespera's Venom Sac', 'VsprVnSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30666, 0, 'Vespera's Toxic Mantle', 'VsprTxMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30666, 'VsprTxMnt', 28, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30666, 1, 9);
REPLACE INTO `item_mods` VALUES (30666, 25, 5);
REPLACE INTO `item_mods` VALUES (30666, 28, 10);
REPLACE INTO `item_basic` VALUES (30667, 0, 'Vespera's Chitin Belt', 'VsprCBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30667, 'VsprCBlt', 28, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30667, 1, 6);
REPLACE INTO `item_mods` VALUES (30667, 14, 4);
REPLACE INTO `item_mods` VALUES (30667, 2, 30);

-- Pincer Patriarch Ptolemy trophy + gear
REPLACE INTO `item_basic` VALUES (30668, 0, 'Ptolemy's Giant Pincer', 'PtlmyPncr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30669, 0, 'Ptolemy's Armored Cuisses', 'PtlmyACss', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30669, 'PtlmyACss', 40, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30669, 1, 16);
REPLACE INTO `item_mods` VALUES (30669, 14, 6);
REPLACE INTO `item_mods` VALUES (30669, 2, 50);
REPLACE INTO `item_basic` VALUES (30670, 0, 'Ptolemy's Exoskeleton Ring', 'PtlmyERng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30670, 'PtlmyERng', 40, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30670, 1, 4);
REPLACE INTO `item_mods` VALUES (30670, 14, 5);
REPLACE INTO `item_mods` VALUES (30670, 29, 7);

-- Deathstalker Dagny trophy + gear
REPLACE INTO `item_basic` VALUES (30671, 0, 'Dagny's Deathstalker Barb', 'DgnyDSBrb', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30672, 0, 'Dagny's Reaper's Carapace', 'DgnyRCrp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30672, 'DgnyRCrp', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30672, 1, 24);
REPLACE INTO `item_mods` VALUES (30672, 12, 8);
REPLACE INTO `item_mods` VALUES (30672, 29, 18);
REPLACE INTO `item_mods` VALUES (30672, 2, 60);
REPLACE INTO `item_basic` VALUES (30673, 0, 'Dagny's Fatal Earring', 'DgnyFEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30673, 'DgnyFEar', 52, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30673, 12, 6);
REPLACE INTO `item_mods` VALUES (30673, 25, 14);
REPLACE INTO `item_mods` VALUES (30673, 29, 12);

-- Weaving Wendy trophy + gear
REPLACE INTO `item_basic` VALUES (30674, 0, 'Wendy's Silk Thread', 'WndySThrd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30675, 0, 'Wendy's Web Ring', 'WndyWRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30675, 'WndyWRng', 10, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30675, 13, 3);
REPLACE INTO `item_mods` VALUES (30675, 25, 4);
REPLACE INTO `item_mods` VALUES (30675, 23, 2);
REPLACE INTO `item_basic` VALUES (30676, 0, 'Wendy's Spinner Sandals', 'WndySpSnd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30676, 'WndySpSnd', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30676, 1, 4);
REPLACE INTO `item_mods` VALUES (30676, 23, 3);
REPLACE INTO `item_mods` VALUES (30676, 68, 6);

-- Sticky Stanislava trophy + gear
REPLACE INTO `item_basic` VALUES (30677, 0, 'Stanislava's Web Sac', 'StnslaWSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30678, 0, 'Stanislava's Gossamer Collar', 'StnslaGCl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30678, 'StnslaGCl', 24, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30678, 13, 4);
REPLACE INTO `item_mods` VALUES (30678, 25, 7);
REPLACE INTO `item_mods` VALUES (30678, 23, 4);
REPLACE INTO `item_basic` VALUES (30679, 0, 'Stanislava's Spinner's Mitts', 'StnslasMtt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30679, 'StnslasMtt', 24, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30679, 1, 8);
REPLACE INTO `item_mods` VALUES (30679, 13, 4);
REPLACE INTO `item_mods` VALUES (30679, 25, 8);

-- Ensnaring Eleanor trophy + gear
REPLACE INTO `item_basic` VALUES (30680, 0, 'Eleanor's Ensnaring Fang', 'ElnrEnFng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30681, 0, 'Eleanor's Arachnid Vest', 'ElnrArVst', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30681, 'ElnrArVst', 36, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30681, 1, 17);
REPLACE INTO `item_mods` VALUES (30681, 13, 6);
REPLACE INTO `item_mods` VALUES (30681, 25, 12);
REPLACE INTO `item_basic` VALUES (30682, 0, 'Eleanor's Silkweave Belt', 'ElnrSWBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30682, 'ElnrSWBlt', 36, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30682, 1, 5);
REPLACE INTO `item_mods` VALUES (30682, 23, 5);
REPLACE INTO `item_mods` VALUES (30682, 68, 10);

-- Great Weaver Gwendolyn trophy + gear
REPLACE INTO `item_basic` VALUES (30683, 0, 'Gwendolyn's Crown Web', 'GwndlnCWeb', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30684, 0, 'Gwendolyn's Silken Tiara', 'GwndlnSTar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30684, 'GwndlnSTar', 50, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30684, 1, 13);
REPLACE INTO `item_mods` VALUES (30684, 13, 8);
REPLACE INTO `item_mods` VALUES (30684, 25, 16);
REPLACE INTO `item_mods` VALUES (30684, 23, 6);
REPLACE INTO `item_basic` VALUES (30685, 0, 'Gwendolyn's Silk Mantle', 'GwndlnSMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30685, 'GwndlnSMnt', 50, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30685, 1, 11);
REPLACE INTO `item_mods` VALUES (30685, 13, 6);
REPLACE INTO `item_mods` VALUES (30685, 25, 12);
REPLACE INTO `item_mods` VALUES (30685, 384, 3);

-- Oozing Oswald trophy + gear
REPLACE INTO `item_basic` VALUES (30686, 0, 'Oswald's Ooze Sample', 'OswldOze', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30687, 0, 'Oswald's Slick Ring', 'OswldSRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30687, 'OswldSRng', 8, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30687, 25, 2);
REPLACE INTO `item_mods` VALUES (30687, 30, 4);
REPLACE INTO `item_mods` VALUES (30687, 9, 10);
REPLACE INTO `item_basic` VALUES (30688, 0, 'Oswald's Slime Sandals', 'OswldSlSnd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30688, 'OswldSlSnd', 8, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30688, 1, 3);
REPLACE INTO `item_mods` VALUES (30688, 23, 2);
REPLACE INTO `item_mods` VALUES (30688, 68, 4);

-- Bubbling Borghild trophy + gear
REPLACE INTO `item_basic` VALUES (30689, 0, 'Borghild's Bubbling Mass', 'BrghldBMs', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30690, 0, 'Borghild's Viscous Collar', 'BrghldVCl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30690, 'BrghldVCl', 20, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30690, 25, 4);
REPLACE INTO `item_mods` VALUES (30690, 28, 7);
REPLACE INTO `item_mods` VALUES (30690, 9, 20);
REPLACE INTO `item_basic` VALUES (30691, 0, 'Borghild's Acid Earring', 'BrghldAEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30691, 'BrghldAEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30691, 25, 3);
REPLACE INTO `item_mods` VALUES (30691, 28, 6);
REPLACE INTO `item_mods` VALUES (30691, 30, 5);

-- Corrosive Callista trophy + gear
REPLACE INTO `item_basic` VALUES (30692, 0, 'Callista's Acid Sac', 'CllstAcSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30693, 0, 'Callista's Dissolving Mitts', 'CllstDMtt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30693, 'CllstDMtt', 34, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30693, 1, 10);
REPLACE INTO `item_mods` VALUES (30693, 25, 5);
REPLACE INTO `item_mods` VALUES (30693, 28, 10);
REPLACE INTO `item_basic` VALUES (30694, 0, 'Callista's Caustic Ring', 'CllstCRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30694, 'CllstCRng', 34, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30694, 25, 4);
REPLACE INTO `item_mods` VALUES (30694, 30, 8);
REPLACE INTO `item_mods` VALUES (30694, 28, 7);

-- Primordial Proteus trophy + gear
REPLACE INTO `item_basic` VALUES (30695, 0, 'Proteus's Ancient Ooze', 'PrtsAncOz', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30696, 0, 'Proteus's Primal Robe', 'PrtsaPRbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30696, 'PrtsaPRbe', 48, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30696, 1, 16);
REPLACE INTO `item_mods` VALUES (30696, 25, 9);
REPLACE INTO `item_mods` VALUES (30696, 28, 18);
REPLACE INTO `item_mods` VALUES (30696, 9, 70);
REPLACE INTO `item_basic` VALUES (30697, 0, 'Proteus's Shifting Ring', 'PrtsaShRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30697, 'PrtsaShRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30697, 25, 6);
REPLACE INTO `item_mods` VALUES (30697, 28, 12);
REPLACE INTO `item_mods` VALUES (30697, 30, 10);

-- Splashing Salvatore trophy + gear
REPLACE INTO `item_basic` VALUES (30698, 0, 'Salvatore's Fin Spine', 'SlvtrFSp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30699, 0, 'Salvatore's Gill Earring', 'SlvtrGEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30699, 'SlvtrGEar', 12, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30699, 12, 3);
REPLACE INTO `item_mods` VALUES (30699, 29, 5);
REPLACE INTO `item_mods` VALUES (30699, 25, 3);
REPLACE INTO `item_basic` VALUES (30700, 0, 'Salvatore's Wader Boots', 'SlvtrWBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30700, 'SlvtrWBts', 12, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30700, 1, 5);
REPLACE INTO `item_mods` VALUES (30700, 23, 3);
REPLACE INTO `item_mods` VALUES (30700, 68, 6);

-- Snapping Sicily trophy + gear
REPLACE INTO `item_basic` VALUES (30701, 0, 'Sicily's Bite Mark', 'ScllyBtMk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30702, 0, 'Sicily's River Belt', 'SclllyRBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30702, 'SclllyRBlt', 24, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30702, 1, 5);
REPLACE INTO `item_mods` VALUES (30702, 12, 4);
REPLACE INTO `item_mods` VALUES (30702, 29, 8);
REPLACE INTO `item_basic` VALUES (30703, 0, 'Sicily's Scale Mail', 'ScllySMl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30703, 'ScllySMl', 24, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30703, 1, 15);
REPLACE INTO `item_mods` VALUES (30703, 14, 4);
REPLACE INTO `item_mods` VALUES (30703, 2, 35);

-- Torrent Tiberius trophy + gear
REPLACE INTO `item_basic` VALUES (30704, 0, 'Tiberius's Torrent Scale', 'TbrsaTSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30705, 0, 'Tiberius's Current Mantle', 'TbrsaCMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30705, 'TbrsaCMnt', 36, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30705, 1, 9);
REPLACE INTO `item_mods` VALUES (30705, 12, 5);
REPLACE INTO `item_mods` VALUES (30705, 29, 12);
REPLACE INTO `item_basic` VALUES (30706, 0, 'Tiberius's Rushing Ring', 'TbrsaRRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30706, 'TbrsaRRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30706, 12, 4);
REPLACE INTO `item_mods` VALUES (30706, 29, 10);
REPLACE INTO `item_mods` VALUES (30706, 25, 6);

-- Deep King Delacroix trophy + gear
REPLACE INTO `item_basic` VALUES (30707, 0, 'Delacroix's King Scale', 'DlcxKgSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30708, 0, 'Delacroix's Maelstrom Helm', 'DlcxMHlm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30708, 'DlcxMHlm', 48, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30708, 1, 14);
REPLACE INTO `item_mods` VALUES (30708, 12, 7);
REPLACE INTO `item_mods` VALUES (30708, 14, 5);
REPLACE INTO `item_mods` VALUES (30708, 2, 50);
REPLACE INTO `item_basic` VALUES (30709, 0, 'Delacroix's Abyssal Ring', 'DlcxAbRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30709, 'DlcxAbRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30709, 12, 6);
REPLACE INTO `item_mods` VALUES (30709, 29, 14);
REPLACE INTO `item_mods` VALUES (30709, 25, 10);

-- Lumbering Loretta trophy + gear
REPLACE INTO `item_basic` VALUES (30710, 0, 'Loretta's Long Neck Bone', 'LrttaNBn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30711, 0, 'Loretta's Padded Neckguard', 'LrttaPNGd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30711, 'LrttaPNGd', 14, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30711, 1, 4);
REPLACE INTO `item_mods` VALUES (30711, 14, 3);
REPLACE INTO `item_mods` VALUES (30711, 2, 20);
REPLACE INTO `item_basic` VALUES (30712, 0, 'Loretta's Stomper Boots', 'LrttaSBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30712, 'LrttaSBts', 14, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30712, 1, 6);
REPLACE INTO `item_mods` VALUES (30712, 12, 3);
REPLACE INTO `item_mods` VALUES (30712, 14, 2);

-- Thundering Thaddeus trophy + gear
REPLACE INTO `item_basic` VALUES (30713, 0, 'Thaddeus's Resonance Spine', 'ThdsRSp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30714, 0, 'Thaddeus's Stampede Mantle', 'ThadsMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30714, 'ThadsMnt', 28, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30714, 1, 8);
REPLACE INTO `item_mods` VALUES (30714, 12, 5);
REPLACE INTO `item_mods` VALUES (30714, 29, 10);
REPLACE INTO `item_basic` VALUES (30715, 0, 'Thaddeus's Trample Belt', 'ThdsaTBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30715, 'ThdsaTBlt', 28, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30715, 1, 6);
REPLACE INTO `item_mods` VALUES (30715, 14, 5);
REPLACE INTO `item_mods` VALUES (30715, 2, 35);

-- Crasher Crisanta trophy + gear
REPLACE INTO `item_basic` VALUES (30716, 0, 'Crisanta's Ivory Spine', 'CrsntaISp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30717, 0, 'Crisanta's Ivory Cuisses', 'CrsntaICss', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30717, 'CrsntaICss', 40, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30717, 1, 15);
REPLACE INTO `item_mods` VALUES (30717, 14, 7);
REPLACE INTO `item_mods` VALUES (30717, 2, 55);
REPLACE INTO `item_basic` VALUES (30718, 0, 'Crisanta's Charge Ring', 'CrsntaCRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30718, 'CrsntaCRng', 40, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30718, 12, 5);
REPLACE INTO `item_mods` VALUES (30718, 29, 12);
REPLACE INTO `item_mods` VALUES (30718, 14, 4);

-- Patriarch Percival trophy + gear
REPLACE INTO `item_basic` VALUES (30719, 0, 'Percival's Grand Spine', 'PrcvlGSp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30720, 0, 'Percival's Behemoth Plate', 'PrcvlBPlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30720, 'PrcvlBPlt', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30720, 1, 26);
REPLACE INTO `item_mods` VALUES (30720, 12, 8);
REPLACE INTO `item_mods` VALUES (30720, 14, 9);
REPLACE INTO `item_mods` VALUES (30720, 2, 80);
REPLACE INTO `item_basic` VALUES (30721, 0, 'Percival's Titan's Collar', 'PrcvlTCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30721, 'PrcvlTCll', 54, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30721, 14, 7);
REPLACE INTO `item_mods` VALUES (30721, 2, 60);
REPLACE INTO `item_mods` VALUES (30721, 29, 8);

-- Clumsy Clemens trophy + gear
REPLACE INTO `item_basic` VALUES (30722, 0, 'Clemens's Club Fragment', 'ClmnsCFrg', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30723, 0, 'Clemens's Brutish Armguard', 'ClmnsBAGd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30723, 'ClmnsBAGd', 18, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30723, 1, 8);
REPLACE INTO `item_mods` VALUES (30723, 12, 4);
REPLACE INTO `item_mods` VALUES (30723, 29, 8);
REPLACE INTO `item_basic` VALUES (30724, 0, 'Clemens's Stumbler Ring', 'ClmnsStRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30724, 'ClmnsStRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30724, 12, 3);
REPLACE INTO `item_mods` VALUES (30724, 14, 3);
REPLACE INTO `item_mods` VALUES (30724, 2, 20);

-- Booming Bartholomew trophy + gear
REPLACE INTO `item_basic` VALUES (30725, 0, 'Bartholomew's Thunder Stone', 'BrthlmTStn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30726, 0, 'Bartholomew's Boulderfist Helm', 'BrthlmBHlm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30726, 'BrthlmBHlm', 30, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30726, 1, 12);
REPLACE INTO `item_mods` VALUES (30726, 12, 6);
REPLACE INTO `item_mods` VALUES (30726, 14, 5);
REPLACE INTO `item_basic` VALUES (30727, 0, 'Bartholomew's Stone Belt', 'BrthlmSBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30727, 'BrthlmSBlt', 30, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30727, 1, 7);
REPLACE INTO `item_mods` VALUES (30727, 12, 5);
REPLACE INTO `item_mods` VALUES (30727, 29, 11);

-- Crusher Conrad trophy + gear
REPLACE INTO `item_basic` VALUES (30728, 0, 'Conrad's Crusher Knuckle', 'CnrdCKnk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30729, 0, 'Conrad's Mountain Hauberk', 'CnrdMHbk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30729, 'CnrdMHbk', 42, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30729, 1, 22);
REPLACE INTO `item_mods` VALUES (30729, 12, 8);
REPLACE INTO `item_mods` VALUES (30729, 14, 6);
REPLACE INTO `item_mods` VALUES (30729, 2, 65);
REPLACE INTO `item_basic` VALUES (30730, 0, 'Conrad's Earthshaker Boots', 'CnrdESBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30730, 'CnrdESBts', 42, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30730, 1, 13);
REPLACE INTO `item_mods` VALUES (30730, 12, 6);
REPLACE INTO `item_mods` VALUES (30730, 29, 14);

-- Titan Theobald trophy + gear
REPLACE INTO `item_basic` VALUES (30731, 0, 'Theobald's Titan Core', 'ThbldTCr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30732, 0, 'Theobald's Colossus Plate', 'ThbldCPlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30732, 'ThbldCPlt', 55, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30732, 1, 28);
REPLACE INTO `item_mods` VALUES (30732, 12, 10);
REPLACE INTO `item_mods` VALUES (30732, 14, 9);
REPLACE INTO `item_mods` VALUES (30732, 2, 90);
REPLACE INTO `item_basic` VALUES (30733, 0, 'Theobald's Worldbreaker Ring', 'ThbldWRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30733, 'ThbldWRng', 55, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30733, 12, 8);
REPLACE INTO `item_mods` VALUES (30733, 29, 20);
REPLACE INTO `item_mods` VALUES (30733, 14, 6);

-- Mossy Mortimer trophy + gear
REPLACE INTO `item_basic` VALUES (30734, 0, 'Mortimer's Mossy Bark', 'MrtmrMBrk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30735, 0, 'Mortimer's Bark Ring', 'MrtmrBkRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30735, 'MrtmrBkRng', 12, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30735, 68, 3);
REPLACE INTO `item_mods` VALUES (30735, 9, 15);
REPLACE INTO `item_mods` VALUES (30735, 30, 4);
REPLACE INTO `item_basic` VALUES (30736, 0, 'Mortimer's Root Sandals', 'MrtmrRSnd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30736, 'MrtmrRSnd', 12, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30736, 1, 5);
REPLACE INTO `item_mods` VALUES (30736, 68, 2);
REPLACE INTO `item_mods` VALUES (30736, 9, 10);

-- Ancient Aldric trophy + gear
REPLACE INTO `item_basic` VALUES (30737, 0, 'Aldric's Ancient Heartwood', 'AldrHrtwd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30738, 0, 'Aldric's Heartwood Earring', 'AldrHEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30738, 'AldrHEar', 26, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30738, 68, 5);
REPLACE INTO `item_mods` VALUES (30738, 9, 25);
REPLACE INTO `item_mods` VALUES (30738, 30, 7);
REPLACE INTO `item_basic` VALUES (30739, 0, 'Aldric's Gnarled Collar', 'AldrGCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30739, 'AldrGCll', 26, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30739, 68, 4);
REPLACE INTO `item_mods` VALUES (30739, 25, 3);
REPLACE INTO `item_mods` VALUES (30739, 9, 20);

-- Elder Grove Elspeth trophy + gear
REPLACE INTO `item_basic` VALUES (30740, 0, 'Elspeth's Elder Sap', 'ElsptESap', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30741, 0, 'Elspeth's Grove Mantle', 'ElsptGMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30741, 'ElsptGMnt', 38, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30741, 1, 10);
REPLACE INTO `item_mods` VALUES (30741, 68, 6);
REPLACE INTO `item_mods` VALUES (30741, 9, 40);
REPLACE INTO `item_basic` VALUES (30742, 0, 'Elspeth's Nature's Ring', 'ElsptNRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30742, 'ElsptNRng', 38, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30742, 68, 5);
REPLACE INTO `item_mods` VALUES (30742, 30, 9);
REPLACE INTO `item_mods` VALUES (30742, 9, 30);

-- World Tree Wilhelmina trophy + gear
REPLACE INTO `item_basic` VALUES (30743, 0, 'Wilhelmina's World Core', 'WhlmnaWCr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30744, 0, 'Wilhelmina's Ancient Robe', 'WhlmnaARbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30744, 'WhlmnaARbe', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30744, 1, 17);
REPLACE INTO `item_mods` VALUES (30744, 68, 10);
REPLACE INTO `item_mods` VALUES (30744, 9, 90);
REPLACE INTO `item_mods` VALUES (30744, 28, 16);
REPLACE INTO `item_basic` VALUES (30745, 0, 'Wilhelmina's Canopy Ring', 'WhlmnaCRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30745, 'WhlmnaCRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30745, 68, 7);
REPLACE INTO `item_mods` VALUES (30745, 30, 13);
REPLACE INTO `item_mods` VALUES (30745, 9, 40);

-- Mischief Marcelino trophy + gear
REPLACE INTO `item_basic` VALUES (30746, 0, 'Marcelino's Imp Horn', 'MrclnHrn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30747, 0, 'Marcelino's Prankster Earring', 'MrclnPEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30747, 'MrclnPEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30747, 23, 4);
REPLACE INTO `item_mods` VALUES (30747, 68, 7);
REPLACE INTO `item_mods` VALUES (30747, 13, 3);
REPLACE INTO `item_basic` VALUES (30748, 0, 'Marcelino's Trick Ring', 'MrclnTRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30748, 'MrclnTRng', 20, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30748, 23, 3);
REPLACE INTO `item_mods` VALUES (30748, 13, 3);
REPLACE INTO `item_mods` VALUES (30748, 25, 6);

-- Trickster Temperance trophy + gear
REPLACE INTO `item_basic` VALUES (30749, 0, 'Temperance's Trick Tail', 'TmprTTail', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30750, 0, 'Temperance's Jester Hat', 'TmprJHat', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30750, 'TmprJHat', 32, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30750, 1, 9);
REPLACE INTO `item_mods` VALUES (30750, 23, 6);
REPLACE INTO `item_mods` VALUES (30750, 68, 12);
REPLACE INTO `item_basic` VALUES (30751, 0, 'Temperance's Chaos Collar', 'TmprCCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30751, 'TmprCCll', 32, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30751, 25, 4);
REPLACE INTO `item_mods` VALUES (30751, 23, 4);
REPLACE INTO `item_mods` VALUES (30751, 30, 7);

-- Hexing Hieronymus trophy + gear
REPLACE INTO `item_basic` VALUES (30752, 0, 'Hieronymus's Hex Wand', 'HrnmsHWnd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30753, 0, 'Hieronymus's Spelltwist Robe', 'HrnmsSRbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30753, 'HrnmsSRbe', 44, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30753, 1, 15);
REPLACE INTO `item_mods` VALUES (30753, 25, 8);
REPLACE INTO `item_mods` VALUES (30753, 28, 16);
REPLACE INTO `item_mods` VALUES (30753, 9, 60);
REPLACE INTO `item_basic` VALUES (30754, 0, 'Hieronymus's Imp Ring', 'HrnmsIRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30754, 'HrnmsIRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30754, 25, 5);
REPLACE INTO `item_mods` VALUES (30754, 30, 11);
REPLACE INTO `item_mods` VALUES (30754, 28, 9);

-- Grand Trickster Gregoire trophy + gear
REPLACE INTO `item_basic` VALUES (30755, 0, 'Gregoire's Grand Staff', 'GrgrGStff', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30756, 0, 'Gregoire's Chaos Mantle', 'GrgrCMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30756, 'GrgrCMnt', 54, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30756, 1, 12);
REPLACE INTO `item_mods` VALUES (30756, 25, 9);
REPLACE INTO `item_mods` VALUES (30756, 28, 18);
REPLACE INTO `item_mods` VALUES (30756, 23, 6);
REPLACE INTO `item_basic` VALUES (30757, 0, 'Gregoire's Mayhem Ring', 'GrgrMRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30757, 'GrgrMRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30757, 25, 7);
REPLACE INTO `item_mods` VALUES (30757, 28, 14);
REPLACE INTO `item_mods` VALUES (30757, 30, 12);

-- Tiny Tortuga trophy + gear
REPLACE INTO `item_basic` VALUES (30758, 0, 'Tortuga's Candle Stub', 'TrtgaCndl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30759, 0, 'Tortuga's Lantern Ring', 'TrtgaLRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30759, 'TrtgaLRng', 30, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30759, 25, 3);
REPLACE INTO `item_mods` VALUES (30759, 30, 5);
REPLACE INTO `item_mods` VALUES (30759, 9, 15);
REPLACE INTO `item_basic` VALUES (30760, 0, 'Tortuga's Grudge Boots', 'TrtgaGBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30760, 'TrtgaGBts', 30, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30760, 1, 8);
REPLACE INTO `item_mods` VALUES (30760, 25, 4);
REPLACE INTO `item_mods` VALUES (30760, 28, 7);

-- Shuffling Sebastiano trophy + gear
REPLACE INTO `item_basic` VALUES (30761, 0, 'Sebastiano's Chef's Knife', 'SbstnCKnf', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30762, 0, 'Sebastiano's Culinary Collar', 'SbstnCCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30762, 'SbstnCCll', 40, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30762, 12, 5);
REPLACE INTO `item_mods` VALUES (30762, 29, 10);
REPLACE INTO `item_mods` VALUES (30762, 25, 7);
REPLACE INTO `item_basic` VALUES (30763, 0, 'Sebastiano's Green Apron', 'SbstnGApn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30763, 'SbstnGApn', 40, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30763, 1, 16);
REPLACE INTO `item_mods` VALUES (30763, 12, 6);
REPLACE INTO `item_mods` VALUES (30763, 29, 14);
REPLACE INTO `item_mods` VALUES (30763, 2, 40);

-- Grudge Bearer Giuliana trophy + gear
REPLACE INTO `item_basic` VALUES (30764, 0, 'Giuliana's Everyone's Grudge', 'GlnaGrdge', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30765, 0, 'Giuliana's Revenge Mantle', 'GlnaRMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30765, 'GlnaRMnt', 50, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30765, 1, 12);
REPLACE INTO `item_mods` VALUES (30765, 12, 7);
REPLACE INTO `item_mods` VALUES (30765, 25, 6);
REPLACE INTO `item_mods` VALUES (30765, 29, 14);
REPLACE INTO `item_basic` VALUES (30766, 0, 'Giuliana's Karma Ring', 'GlnaKRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30766, 'GlnaKRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30766, 12, 5);
REPLACE INTO `item_mods` VALUES (30766, 25, 5);
REPLACE INTO `item_mods` VALUES (30766, 29, 10);
REPLACE INTO `item_mods` VALUES (30766, 30, 8);

-- The Last Tonberry trophy + gear
REPLACE INTO `item_basic` VALUES (30767, 0, 'Last Tonberry's Lantern', 'LstTnLnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30768, 0, 'Last Tonberry's Final Robe', 'LstTnFRbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30768, 'LstTnFRbe', 60, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30768, 1, 20);
REPLACE INTO `item_mods` VALUES (30768, 25, 11);
REPLACE INTO `item_mods` VALUES (30768, 28, 22);
REPLACE INTO `item_mods` VALUES (30768, 9, 90);
REPLACE INTO `item_basic` VALUES (30769, 0, 'Last Tonberry's Legend Ring', 'LstTnLRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30769, 'LstTnLRng', 60, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30769, 25, 8);
REPLACE INTO `item_mods` VALUES (30769, 28, 16);
REPLACE INTO `item_mods` VALUES (30769, 30, 14);

-- Rippling Rocco trophy + gear
REPLACE INTO `item_basic` VALUES (30770, 0, 'Rocco's Tide Scale', 'RccTdSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30771, 0, 'Rocco's River Boots', 'RccoRBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30771, 'RccoRBts', 16, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30771, 1, 6);
REPLACE INTO `item_mods` VALUES (30771, 23, 4);
REPLACE INTO `item_mods` VALUES (30771, 68, 8);
REPLACE INTO `item_basic` VALUES (30772, 0, 'Rocco's Current Earring', 'RccoAEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30772, 'RccoAEar', 16, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30772, 13, 3);
REPLACE INTO `item_mods` VALUES (30772, 25, 5);
REPLACE INTO `item_mods` VALUES (30772, 23, 3);

-- Tidecaller Thessaly trophy + gear
REPLACE INTO `item_basic` VALUES (30773, 0, 'Thessaly's Tide Totem', 'ThslyTTtm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30774, 0, 'Thessaly's Wavecrest Collar', 'ThslyCCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30774, 'ThslyCCll', 30, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30774, 12, 4);
REPLACE INTO `item_mods` VALUES (30774, 14, 4);
REPLACE INTO `item_mods` VALUES (30774, 2, 30);
REPLACE INTO `item_basic` VALUES (30775, 0, 'Thessaly's Reef Mantle', 'ThslyRMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30775, 'ThslyRMnt', 30, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30775, 1, 8);
REPLACE INTO `item_mods` VALUES (30775, 12, 5);
REPLACE INTO `item_mods` VALUES (30775, 29, 10);

-- Brine Baron Baldassare trophy + gear
REPLACE INTO `item_basic` VALUES (30776, 0, 'Baldassare's Abyssal Scale', 'BldsrABSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30777, 0, 'Baldassare's Leviathan Helm', 'BldsrLHlm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30777, 'BldsrLHlm', 42, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30777, 1, 14);
REPLACE INTO `item_mods` VALUES (30777, 12, 7);
REPLACE INTO `item_mods` VALUES (30777, 14, 5);
REPLACE INTO `item_mods` VALUES (30777, 2, 45);
REPLACE INTO `item_basic` VALUES (30778, 0, 'Baldassare's Deep Ring', 'BldsrDRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30778, 'BldsrDRng', 42, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30778, 12, 5);
REPLACE INTO `item_mods` VALUES (30778, 29, 12);
REPLACE INTO `item_mods` VALUES (30778, 14, 4);

-- Deep Sovereign Desideria trophy + gear
REPLACE INTO `item_basic` VALUES (30779, 0, 'Desideria's Sovereign Fin', 'DsdraSFin', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30780, 0, 'Desideria's Abyssal Robe', 'DsdraARbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30780, 'DsdraARbe', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30780, 1, 20);
REPLACE INTO `item_mods` VALUES (30780, 25, 8);
REPLACE INTO `item_mods` VALUES (30780, 28, 16);
REPLACE INTO `item_mods` VALUES (30780, 9, 60);
REPLACE INTO `item_basic` VALUES (30781, 0, 'Desideria's Trident Ring', 'DsdraTRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30781, 'DsdraTRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30781, 12, 6);
REPLACE INTO `item_mods` VALUES (30781, 29, 14);
REPLACE INTO `item_mods` VALUES (30781, 25, 5);

-- Prancing Persephone trophy + gear
REPLACE INTO `item_basic` VALUES (30782, 0, 'Persephone's Plume', 'PrsphnPlme', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30783, 0, 'Persephone's Featherlight Earring', 'PrsphnEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30783, 'PrsphnEar', 24, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30783, 23, 5);
REPLACE INTO `item_mods` VALUES (30783, 68, 9);
REPLACE INTO `item_mods` VALUES (30783, 13, 3);
REPLACE INTO `item_basic` VALUES (30784, 0, 'Persephone's Gallop Shoes', 'PrsphnGShs', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30784, 'PrsphnGShs', 24, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30784, 1, 8);
REPLACE INTO `item_mods` VALUES (30784, 23, 5);
REPLACE INTO `item_mods` VALUES (30784, 68, 10);

-- Thunderwing Theron trophy + gear
REPLACE INTO `item_basic` VALUES (30785, 0, 'Theron's Thunder Plume', 'ThrnTPlme', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30786, 0, 'Theron's Storm Mantle', 'ThrnStMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30786, 'ThrnStMnt', 36, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30786, 1, 10);
REPLACE INTO `item_mods` VALUES (30786, 23, 6);
REPLACE INTO `item_mods` VALUES (30786, 12, 5);
REPLACE INTO `item_mods` VALUES (30786, 29, 10);
REPLACE INTO `item_basic` VALUES (30787, 0, 'Theron's Gale Ring', 'ThrnGRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30787, 'ThrnGRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30787, 23, 5);
REPLACE INTO `item_mods` VALUES (30787, 13, 4);
REPLACE INTO `item_mods` VALUES (30787, 25, 9);

-- Skydancer Sabastienne trophy + gear
REPLACE INTO `item_basic` VALUES (30788, 0, 'Sabastienne's Sky Scale', 'SbstSkyScl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30789, 0, 'Sabastienne's Aerial Helm', 'SbstAHlm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30789, 'SbstAHlm', 46, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30789, 1, 13);
REPLACE INTO `item_mods` VALUES (30789, 23, 7);
REPLACE INTO `item_mods` VALUES (30789, 68, 14);
REPLACE INTO `item_mods` VALUES (30789, 13, 5);
REPLACE INTO `item_basic` VALUES (30790, 0, 'Sabastienne's Wing Belt', 'SbstWBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30790, 'SbstWBlt', 46, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30790, 1, 6);
REPLACE INTO `item_mods` VALUES (30790, 23, 6);
REPLACE INTO `item_mods` VALUES (30790, 384, 4);

-- Heavenrider Hieronyma trophy + gear
REPLACE INTO `item_basic` VALUES (30791, 0, 'Hieronyma's Heaven Scale', 'HrnymHSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30792, 0, 'Hieronyma's Celestial Plate', 'HrnymCPlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30792, 'HrnymCPlt', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30792, 1, 23);
REPLACE INTO `item_mods` VALUES (30792, 12, 8);
REPLACE INTO `item_mods` VALUES (30792, 23, 8);
REPLACE INTO `item_mods` VALUES (30792, 2, 70);
REPLACE INTO `item_basic` VALUES (30793, 0, 'Hieronyma's Ascent Ring', 'HrnymARng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30793, 'HrnymARng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30793, 23, 7);
REPLACE INTO `item_mods` VALUES (30793, 13, 6);
REPLACE INTO `item_mods` VALUES (30793, 25, 14);

-- Fledgling Fiorentina trophy + gear
REPLACE INTO `item_basic` VALUES (30794, 0, 'Fiorentina's Pin Feather', 'FrntnPFth', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30795, 0, 'Fiorentina's Downy Earring', 'FrntnDEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30795, 'FrntnDEar', 18, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30795, 23, 4);
REPLACE INTO `item_mods` VALUES (30795, 68, 7);
REPLACE INTO `item_mods` VALUES (30795, 13, 3);
REPLACE INTO `item_basic` VALUES (30796, 0, 'Fiorentina's Talon Ring', 'FrntnTRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30796, 'FrntnTRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30796, 12, 3);
REPLACE INTO `item_mods` VALUES (30796, 29, 6);
REPLACE INTO `item_mods` VALUES (30796, 25, 4);

-- Stormrider Sigismund trophy + gear
REPLACE INTO `item_basic` VALUES (30797, 0, 'Sigismund's Storm Feather', 'SgsmndSFth', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30798, 0, 'Sigismund's Cloudpiercer Helm', 'SgsmndCHlm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30798, 'SgsmndCHlm', 32, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30798, 1, 12);
REPLACE INTO `item_mods` VALUES (30798, 12, 5);
REPLACE INTO `item_mods` VALUES (30798, 23, 5);
REPLACE INTO `item_mods` VALUES (30798, 68, 10);
REPLACE INTO `item_basic` VALUES (30799, 0, 'Sigismund's Gale Mantle', 'SgsmndGMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30799, 'SgsmndGMnt', 32, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30799, 1, 9);
REPLACE INTO `item_mods` VALUES (30799, 12, 5);
REPLACE INTO `item_mods` VALUES (30799, 29, 11);

-- Tempest Lord Tancred trophy + gear
REPLACE INTO `item_basic` VALUES (30800, 0, 'Tancred's Tempest Quill', 'TncrTmpstQ', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30801, 0, 'Tancred's Cyclone Plate', 'TncrCyPlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30801, 'TncrCyPlt', 46, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30801, 1, 22);
REPLACE INTO `item_mods` VALUES (30801, 12, 8);
REPLACE INTO `item_mods` VALUES (30801, 23, 6);
REPLACE INTO `item_mods` VALUES (30801, 2, 65);
REPLACE INTO `item_basic` VALUES (30802, 0, 'Tancred's Thunderstrike Ring', 'TncrTRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30802, 'TncrTRng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30802, 12, 6);
REPLACE INTO `item_mods` VALUES (30802, 29, 14);
REPLACE INTO `item_mods` VALUES (30802, 23, 5);

-- Ancient Roc Andromeda trophy + gear
REPLACE INTO `item_basic` VALUES (30803, 0, 'Andromeda's Ancient Quill', 'AndrAQll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30804, 0, 'Andromeda's Skyshatter Plate', 'AndrSSPlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30804, 'AndrSSPlt', 58, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30804, 1, 27);
REPLACE INTO `item_mods` VALUES (30804, 12, 10);
REPLACE INTO `item_mods` VALUES (30804, 23, 8);
REPLACE INTO `item_mods` VALUES (30804, 2, 85);
REPLACE INTO `item_basic` VALUES (30805, 0, 'Andromeda's Legend Ring', 'AndrLRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30805, 'AndrLRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30805, 12, 8);
REPLACE INTO `item_mods` VALUES (30805, 29, 20);
REPLACE INTO `item_mods` VALUES (30805, 23, 6);

-- Stumbling Sebastiano trophy + gear
REPLACE INTO `item_basic` VALUES (30806, 0, 'Sebastiano's Cactus Spine', 'SbstnCSpn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30807, 0, 'Sebastiano's Prickly Ring', 'SbstnPRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30807, 'SbstnPRng', 22, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30807, 12, 3);
REPLACE INTO `item_mods` VALUES (30807, 29, 6);
REPLACE INTO `item_mods` VALUES (30807, 13, 2);
REPLACE INTO `item_basic` VALUES (30808, 0, 'Sebastiano's Sand Boots', 'SbstnSBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30808, 'SbstnSBts', 22, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30808, 1, 6);
REPLACE INTO `item_mods` VALUES (30808, 23, 4);
REPLACE INTO `item_mods` VALUES (30808, 68, 8);

-- Pirouetting Pradinelda trophy + gear
REPLACE INTO `item_basic` VALUES (30809, 0, 'Pradinelda's Cactus Flower', 'PrdnldCFlr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30810, 0, 'Pradinelda's Desert Mantle', 'PrdnldDMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30810, 'PrdnldDMnt', 34, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30810, 1, 9);
REPLACE INTO `item_mods` VALUES (30810, 14, 5);
REPLACE INTO `item_mods` VALUES (30810, 2, 35);
REPLACE INTO `item_basic` VALUES (30811, 0, 'Pradinelda's Spine Belt', 'PrdnldSBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30811, 'PrdnldSBlt', 34, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30811, 1, 6);
REPLACE INTO `item_mods` VALUES (30811, 12, 4);
REPLACE INTO `item_mods` VALUES (30811, 29, 10);

-- Spiky Serafina trophy + gear
REPLACE INTO `item_basic` VALUES (30812, 0, 'Serafina's Great Spine', 'SrfnaGSp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30813, 0, 'Serafina's Desert Crown', 'SrfnaDCrn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30813, 'SrfnaDCrn', 46, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30813, 1, 13);
REPLACE INTO `item_mods` VALUES (30813, 12, 6);
REPLACE INTO `item_mods` VALUES (30813, 14, 5);
REPLACE INTO `item_mods` VALUES (30813, 2, 40);
REPLACE INTO `item_basic` VALUES (30814, 0, 'Serafina's Oasis Ring', 'SrfnaORng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30814, 'SrfnaORng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30814, 12, 5);
REPLACE INTO `item_mods` VALUES (30814, 14, 4);
REPLACE INTO `item_mods` VALUES (30814, 29, 12);

-- Lord of the Desert Lazaro trophy + gear
REPLACE INTO `item_basic` VALUES (30815, 0, 'Lazaro's Desert Heart', 'LzrDsrtHrt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30816, 0, 'Lazaro's Cacti King Plate', 'LzrCKPlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30816, 'LzrCKPlt', 58, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30816, 1, 25);
REPLACE INTO `item_mods` VALUES (30816, 12, 9);
REPLACE INTO `item_mods` VALUES (30816, 14, 8);
REPLACE INTO `item_mods` VALUES (30816, 2, 80);
REPLACE INTO `item_basic` VALUES (30817, 0, 'Lazaro's Mirage Ring', 'LzrMRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30817, 'LzrMRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30817, 12, 7);
REPLACE INTO `item_mods` VALUES (30817, 29, 18);
REPLACE INTO `item_mods` VALUES (30817, 14, 5);

-- Lowing Lorcan trophy + gear
REPLACE INTO `item_basic` VALUES (30818, 0, 'Lorcan's Horn Chip', 'LrcnHrnCp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30819, 0, 'Lorcan's Stampede Belt', 'LrcnStBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30819, 'LrcnStBlt', 20, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30819, 1, 5);
REPLACE INTO `item_mods` VALUES (30819, 14, 3);
REPLACE INTO `item_mods` VALUES (30819, 2, 20);
REPLACE INTO `item_basic` VALUES (30820, 0, 'Lorcan's Hide Boots', 'LrcnHdBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30820, 'LrcnHdBts', 20, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30820, 1, 6);
REPLACE INTO `item_mods` VALUES (30820, 12, 3);
REPLACE INTO `item_mods` VALUES (30820, 14, 2);

-- Thunderhoof Theokleia trophy + gear
REPLACE INTO `item_basic` VALUES (30821, 0, 'Theokleia's Hoof Fragment', 'ThklHFrg', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30822, 0, 'Theokleia's Charge Mantle', 'ThklCMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30822, 'ThklCMnt', 34, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30822, 1, 9);
REPLACE INTO `item_mods` VALUES (30822, 12, 5);
REPLACE INTO `item_mods` VALUES (30822, 29, 11);
REPLACE INTO `item_basic` VALUES (30823, 0, 'Theokleia's Bull Collar', 'ThklBCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30823, 'ThklBCll', 34, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30823, 14, 5);
REPLACE INTO `item_mods` VALUES (30823, 2, 35);
REPLACE INTO `item_mods` VALUES (30823, 29, 5);

-- Gore King Godfrey trophy + gear
REPLACE INTO `item_basic` VALUES (30824, 0, 'Godfrey's Gore Horn', 'GdfrGHrn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30825, 0, 'Godfrey's Warlord Helm', 'GdfrWHlm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30825, 'GdfrWHlm', 46, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30825, 1, 14);
REPLACE INTO `item_mods` VALUES (30825, 12, 7);
REPLACE INTO `item_mods` VALUES (30825, 14, 6);
REPLACE INTO `item_mods` VALUES (30825, 2, 50);
REPLACE INTO `item_basic` VALUES (30826, 0, 'Godfrey's Gorger Ring', 'GdfrGRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30826, 'GdfrGRng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30826, 12, 5);
REPLACE INTO `item_mods` VALUES (30826, 14, 5);
REPLACE INTO `item_mods` VALUES (30826, 29, 12);

-- Primal Patricia trophy + gear
REPLACE INTO `item_basic` VALUES (30827, 0, 'Patricia's Primal Horn', 'PatPHrn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30828, 0, 'Patricia's Titanplate Hauberk', 'PatTPHbk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30828, 'PatTPHbk', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30828, 1, 28);
REPLACE INTO `item_mods` VALUES (30828, 12, 9);
REPLACE INTO `item_mods` VALUES (30828, 14, 9);
REPLACE INTO `item_mods` VALUES (30828, 2, 90);
REPLACE INTO `item_basic` VALUES (30829, 0, 'Patricia's Ancient Ring', 'PatARng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30829, 'PatARng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30829, 12, 7);
REPLACE INTO `item_mods` VALUES (30829, 29, 18);
REPLACE INTO `item_mods` VALUES (30829, 14, 6);

-- Sand Trap Sigrid trophy + gear
REPLACE INTO `item_basic` VALUES (30830, 0, 'Sigrid's Sanded Jaw', 'SgrdSJaw', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30831, 0, 'Sigrid's Pit Sandals', 'SgrdPtSnd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30831, 'SgrdPtSnd', 18, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30831, 1, 5);
REPLACE INTO `item_mods` VALUES (30831, 23, 4);
REPLACE INTO `item_mods` VALUES (30831, 68, 8);
REPLACE INTO `item_basic` VALUES (30832, 0, 'Sigrid's Trap Ring', 'SgrdTRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30832, 'SgrdTRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30832, 13, 3);
REPLACE INTO `item_mods` VALUES (30832, 25, 5);
REPLACE INTO `item_mods` VALUES (30832, 23, 2);

-- Burrowing Bellancourt trophy + gear
REPLACE INTO `item_basic` VALUES (30833, 0, 'Bellancourt's Mandible', 'BlncrtMndb', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30834, 0, 'Bellancourt's Chitin Mitts', 'BlncrtCMtt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30834, 'BlncrtCMtt', 30, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30834, 1, 9);
REPLACE INTO `item_mods` VALUES (30834, 13, 5);
REPLACE INTO `item_mods` VALUES (30834, 25, 9);
REPLACE INTO `item_basic` VALUES (30835, 0, 'Bellancourt's Sand Belt', 'BlncrtSBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30835, 'BlncrtSBlt', 30, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30835, 1, 5);
REPLACE INTO `item_mods` VALUES (30835, 23, 4);
REPLACE INTO `item_mods` VALUES (30835, 68, 9);

-- Crusher Crescentia trophy + gear
REPLACE INTO `item_basic` VALUES (30836, 0, 'Crescentia's Crushing Jaw', 'CrscntCJaw', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30837, 0, 'Crescentia's Armored Hauberk', 'CrscntAHbk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30837, 'CrscntAHbk', 42, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30837, 1, 20);
REPLACE INTO `item_mods` VALUES (30837, 14, 6);
REPLACE INTO `item_mods` VALUES (30837, 2, 60);
REPLACE INTO `item_basic` VALUES (30838, 0, 'Crescentia's Exo Ring', 'CrscntERng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30838, 'CrscntERng', 42, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30838, 1, 4);
REPLACE INTO `item_mods` VALUES (30838, 14, 5);
REPLACE INTO `item_mods` VALUES (30838, 29, 7);

-- Antlion Emperor Adalbert trophy + gear
REPLACE INTO `item_basic` VALUES (30839, 0, 'Adalbert's Emperor Mandible', 'AdlbrtEMndb', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30840, 0, 'Adalbert's Titan Carapace', 'AdlbrtTCrp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30840, 'AdlbrtTCrp', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30840, 1, 26);
REPLACE INTO `item_mods` VALUES (30840, 12, 8);
REPLACE INTO `item_mods` VALUES (30840, 14, 8);
REPLACE INTO `item_mods` VALUES (30840, 2, 80);
REPLACE INTO `item_basic` VALUES (30841, 0, 'Adalbert's Sovereign Ring', 'AdlbrtSRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30841, 'AdlbrtSRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30841, 12, 6);
REPLACE INTO `item_mods` VALUES (30841, 13, 5);
REPLACE INTO `item_mods` VALUES (30841, 29, 16);

-- Winged Wilhelmus trophy + gear
REPLACE INTO `item_basic` VALUES (30842, 0, 'Wilhelmus's Scale', 'WhlmsScle', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30843, 0, 'Wilhelmus's Wing Ring', 'WhlmsWRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30843, 'WhlmsWRng', 26, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30843, 12, 3);
REPLACE INTO `item_mods` VALUES (30843, 29, 7);
REPLACE INTO `item_mods` VALUES (30843, 23, 3);
REPLACE INTO `item_basic` VALUES (30844, 0, 'Wilhelmus's Claw Boots', 'WhlmsCBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30844, 'WhlmsCBts', 26, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30844, 1, 7);
REPLACE INTO `item_mods` VALUES (30844, 23, 4);
REPLACE INTO `item_mods` VALUES (30844, 68, 9);

-- Frost Drake Frederik trophy + gear
REPLACE INTO `item_basic` VALUES (30845, 0, 'Frederik's Frost Scale', 'FrdrkFSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30846, 0, 'Frederik's Ice Drake Helm', 'FrdrkIDHlm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30846, 'FrdrkIDHlm', 38, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30846, 1, 12);
REPLACE INTO `item_mods` VALUES (30846, 25, 5);
REPLACE INTO `item_mods` VALUES (30846, 28, 10);
REPLACE INTO `item_mods` VALUES (30846, 30, 7);
REPLACE INTO `item_basic` VALUES (30847, 0, 'Frederik's Blizzard Mantle', 'FrdrkBMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30847, 'FrdrkBMnt', 38, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30847, 1, 9);
REPLACE INTO `item_mods` VALUES (30847, 25, 6);
REPLACE INTO `item_mods` VALUES (30847, 28, 12);

-- Venomfang Valentinus trophy + gear
REPLACE INTO `item_basic` VALUES (30848, 0, 'Valentinus's Venom Gland', 'VlntnVGld', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30849, 0, 'Valentinus's Wyvern Hauberk', 'VlntnWHbk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30849, 'VlntnWHbk', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30849, 1, 22);
REPLACE INTO `item_mods` VALUES (30849, 12, 8);
REPLACE INTO `item_mods` VALUES (30849, 29, 16);
REPLACE INTO `item_mods` VALUES (30849, 2, 60);
REPLACE INTO `item_basic` VALUES (30850, 0, 'Valentinus's Fang Ring', 'VlntnFRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30850, 'VlntnFRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30850, 12, 6);
REPLACE INTO `item_mods` VALUES (30850, 29, 14);
REPLACE INTO `item_mods` VALUES (30850, 25, 10);

-- Ancient Wyrm Agrippa trophy + gear
REPLACE INTO `item_basic` VALUES (30851, 0, 'Agrippa's Wyrm Heart', 'AgrppWHrt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30852, 0, 'Agrippa's Ancient Drake Plate', 'AgrppADPlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30852, 'AgrppADPlt', 60, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30852, 1, 28);
REPLACE INTO `item_mods` VALUES (30852, 12, 10);
REPLACE INTO `item_mods` VALUES (30852, 25, 8);
REPLACE INTO `item_mods` VALUES (30852, 2, 85);
REPLACE INTO `item_basic` VALUES (30853, 0, 'Agrippa's Dominion Ring', 'AgrppDRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30853, 'AgrppDRng', 60, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30853, 12, 8);
REPLACE INTO `item_mods` VALUES (30853, 29, 20);
REPLACE INTO `item_mods` VALUES (30853, 25, 6);

-- Wind Up Wilhelmina trophy + gear
REPLACE INTO `item_basic` VALUES (30854, 0, 'Wilhelmina's Clockwork Gear', 'WhlmCGear', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30855, 0, 'Wilhelmina's Gear Ring', 'WhlmGRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30855, 'WhlmGRng', 20, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30855, 25, 3);
REPLACE INTO `item_mods` VALUES (30855, 30, 5);
REPLACE INTO `item_mods` VALUES (30855, 9, 15);
REPLACE INTO `item_basic` VALUES (30856, 0, 'Wilhelmina's Mechanical Boots', 'WhlmMBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30856, 'WhlmMBts', 20, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30856, 1, 6);
REPLACE INTO `item_mods` VALUES (30856, 25, 3);
REPLACE INTO `item_mods` VALUES (30856, 28, 6);

-- Clockwork Calogero trophy + gear
REPLACE INTO `item_basic` VALUES (30857, 0, 'Calogero's Mainspring', 'ClgrMainSp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30858, 0, 'Calogero's Automaton Collar', 'ClgrACll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30858, 'ClgrACll', 32, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30858, 25, 5);
REPLACE INTO `item_mods` VALUES (30858, 30, 8);
REPLACE INTO `item_mods` VALUES (30858, 28, 8);
REPLACE INTO `item_basic` VALUES (30859, 0, 'Calogero's Gear Belt', 'ClgrGBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30859, 'ClgrGBlt', 32, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30859, 1, 5);
REPLACE INTO `item_mods` VALUES (30859, 25, 4);
REPLACE INTO `item_mods` VALUES (30859, 28, 7);

-- Arcane Armature Agatha trophy + gear
REPLACE INTO `item_basic` VALUES (30860, 0, 'Agatha's Arcane Core', 'AgtArcCr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30861, 0, 'Agatha's Arcane Hauberk', 'AgtArcHbk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30861, 'AgtArcHbk', 44, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30861, 1, 18);
REPLACE INTO `item_mods` VALUES (30861, 25, 8);
REPLACE INTO `item_mods` VALUES (30861, 28, 16);
REPLACE INTO `item_mods` VALUES (30861, 9, 55);
REPLACE INTO `item_basic` VALUES (30862, 0, 'Agatha's Mystic Ring', 'AgtMysRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30862, 'AgtMysRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30862, 25, 6);
REPLACE INTO `item_mods` VALUES (30862, 28, 11);
REPLACE INTO `item_mods` VALUES (30862, 30, 9);

-- Prime Puppet Ptolemais trophy + gear
REPLACE INTO `item_basic` VALUES (30863, 0, 'Ptolemais's Prime Core', 'PtlmPrmCr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30864, 0, 'Ptolemais's Perfect Body', 'PtlmPBdy', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30864, 'PtlmPBdy', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30864, 1, 24);
REPLACE INTO `item_mods` VALUES (30864, 25, 10);
REPLACE INTO `item_mods` VALUES (30864, 28, 20);
REPLACE INTO `item_mods` VALUES (30864, 9, 80);
REPLACE INTO `item_basic` VALUES (30865, 0, 'Ptolemais's Overseer Ring', 'PtlmOvRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30865, 'PtlmOvRng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30865, 25, 7);
REPLACE INTO `item_mods` VALUES (30865, 28, 16);
REPLACE INTO `item_mods` VALUES (30865, 30, 13);

-- Dancing Dervish trophy + gear
REPLACE INTO `item_basic` VALUES (30866, 0, 'Dervish's Spinning Blade', 'DrvshSpBld', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30867, 0, 'Dervish's Blade Ring', 'DrvshBRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30867, 'DrvshBRng', 24, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30867, 12, 3);
REPLACE INTO `item_mods` VALUES (30867, 29, 7);
REPLACE INTO `item_mods` VALUES (30867, 13, 3);
REPLACE INTO `item_basic` VALUES (30868, 0, 'Dervish's Dance Belt', 'DrvshDBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30868, 'DrvshDBlt', 24, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30868, 1, 5);
REPLACE INTO `item_mods` VALUES (30868, 12, 4);
REPLACE INTO `item_mods` VALUES (30868, 29, 8);

-- Whirling Wenceslas trophy + gear
REPLACE INTO `item_basic` VALUES (30869, 0, 'Wenceslas's Whirling Edge', 'WncslsWEdg', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30870, 0, 'Wenceslas's Vortex Earring', 'WncslsVEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30870, 'WncslsVEar', 36, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30870, 12, 5);
REPLACE INTO `item_mods` VALUES (30870, 29, 9);
REPLACE INTO `item_mods` VALUES (30870, 25, 7);
REPLACE INTO `item_basic` VALUES (30871, 0, 'Wenceslas's Animated Mantle', 'WncslsAMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30871, 'WncslsAMnt', 36, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30871, 1, 9);
REPLACE INTO `item_mods` VALUES (30871, 12, 5);
REPLACE INTO `item_mods` VALUES (30871, 29, 12);

-- Cursed Blade Corneline trophy + gear
REPLACE INTO `item_basic` VALUES (30872, 0, 'Corneline's Cursed Steel', 'CrnlnCStl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30873, 0, 'Corneline's Haunted Hauberk', 'CrnlnHHbk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30873, 'CrnlnHHbk', 48, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30873, 1, 20);
REPLACE INTO `item_mods` VALUES (30873, 12, 8);
REPLACE INTO `item_mods` VALUES (30873, 29, 16);
REPLACE INTO `item_mods` VALUES (30873, 2, 55);
REPLACE INTO `item_basic` VALUES (30874, 0, 'Corneline's Phantom Ring', 'CrnlnPhRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30874, 'CrnlnPhRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30874, 12, 6);
REPLACE INTO `item_mods` VALUES (30874, 29, 14);
REPLACE INTO `item_mods` VALUES (30874, 25, 4);

-- Eternal Executioner Emerick trophy + gear
REPLACE INTO `item_basic` VALUES (30875, 0, 'Emerick's Eternal Edge', 'EmrckEEdge', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30876, 0, 'Emerick's Executioner Plate', 'EmrckEPlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30876, 'EmrckEPlt', 58, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30876, 1, 26);
REPLACE INTO `item_mods` VALUES (30876, 12, 10);
REPLACE INTO `item_mods` VALUES (30876, 29, 20);
REPLACE INTO `item_mods` VALUES (30876, 2, 75);
REPLACE INTO `item_basic` VALUES (30877, 0, 'Emerick's Death Ring', 'EmrckDRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30877, 'EmrckDRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30877, 12, 8);
REPLACE INTO `item_mods` VALUES (30877, 29, 20);
REPLACE INTO `item_mods` VALUES (30877, 13, 6);

-- Wailing Wilhemina trophy + gear
REPLACE INTO `item_basic` VALUES (30878, 0, 'Wilhemina's Ghostly Wisp', 'WhlmnaGWsp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30879, 0, 'Wilhemina's Banshee Earring', 'WhlmnaEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30879, 'WhlmnaEar', 16, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30879, 25, 3);
REPLACE INTO `item_mods` VALUES (30879, 28, 6);
REPLACE INTO `item_mods` VALUES (30879, 30, 4);
REPLACE INTO `item_basic` VALUES (30880, 0, 'Wilhemina's Spirit Ring', 'WhlmnaSpRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30880, 'WhlmnaSpRng', 16, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30880, 25, 3);
REPLACE INTO `item_mods` VALUES (30880, 9, 15);
REPLACE INTO `item_mods` VALUES (30880, 30, 5);

-- Shrieking Sigismonda trophy + gear
REPLACE INTO `item_basic` VALUES (30881, 0, 'Sigismonda's Wail Remnant', 'SgsmndaWR', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30882, 0, 'Sigismonda's Banshee Collar', 'SgsmndBCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30882, 'SgsmndBCll', 28, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30882, 25, 5);
REPLACE INTO `item_mods` VALUES (30882, 30, 8);
REPLACE INTO `item_mods` VALUES (30882, 9, 25);
REPLACE INTO `item_basic` VALUES (30883, 0, 'Sigismonda's Haunting Mitts', 'SgsmndHMtt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30883, 'SgsmndHMtt', 28, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30883, 1, 8);
REPLACE INTO `item_mods` VALUES (30883, 25, 4);
REPLACE INTO `item_mods` VALUES (30883, 28, 8);

-- Phantom Phantasia trophy + gear
REPLACE INTO `item_basic` VALUES (30884, 0, 'Phantasia's Ectoplasm', 'PhntsaEctp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30885, 0, 'Phantasia's Specter Robe', 'PhntsaSRbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30885, 'PhntsaSRbe', 40, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30885, 1, 15);
REPLACE INTO `item_mods` VALUES (30885, 25, 7);
REPLACE INTO `item_mods` VALUES (30885, 28, 14);
REPLACE INTO `item_mods` VALUES (30885, 9, 55);
REPLACE INTO `item_basic` VALUES (30886, 0, 'Phantasia's Wraith Ring', 'PhntsaWRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30886, 'PhntsaWRng', 40, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30886, 25, 5);
REPLACE INTO `item_mods` VALUES (30886, 30, 9);
REPLACE INTO `item_mods` VALUES (30886, 28, 8);

-- Eternal Mourner Euphemia trophy + gear
REPLACE INTO `item_basic` VALUES (30887, 0, 'Euphemia's Eternal Tear', 'EphEtrTear', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30888, 0, 'Euphemia's Mourning Robe', 'EphMRobe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30888, 'EphMRobe', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30888, 1, 18);
REPLACE INTO `item_mods` VALUES (30888, 25, 9);
REPLACE INTO `item_mods` VALUES (30888, 28, 18);
REPLACE INTO `item_mods` VALUES (30888, 9, 75);
REPLACE INTO `item_basic` VALUES (30889, 0, 'Euphemia's Lament Ring', 'EphLmtRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30889, 'EphLmtRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30889, 25, 7);
REPLACE INTO `item_mods` VALUES (30889, 28, 14);
REPLACE INTO `item_mods` VALUES (30889, 30, 12);

-- Blinking Bartholomea trophy + gear
REPLACE INTO `item_basic` VALUES (30890, 0, 'Bartholomea's Petrified Eye', 'BrthlmaEye', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30891, 0, 'Bartholomea's Eye Earring', 'BrthlmaEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30891, 'BrthlmaEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30891, 25, 4);
REPLACE INTO `item_mods` VALUES (30891, 30, 7);
REPLACE INTO `item_mods` VALUES (30891, 9, 15);
REPLACE INTO `item_basic` VALUES (30892, 0, 'Bartholomea's Gaze Ring', 'BrthlmaRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30892, 'BrthlmaRng', 20, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30892, 25, 3);
REPLACE INTO `item_mods` VALUES (30892, 30, 5);
REPLACE INTO `item_mods` VALUES (30892, 28, 6);

-- Staring Stanislao trophy + gear
REPLACE INTO `item_basic` VALUES (30893, 0, 'Stanislao's Crystal Eye', 'StnsloEye', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30894, 0, 'Stanislao's Watcher's Collar', 'StnslaWCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30894, 'StnslaWCll', 32, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30894, 25, 5);
REPLACE INTO `item_mods` VALUES (30894, 30, 9);
REPLACE INTO `item_mods` VALUES (30894, 9, 25);
REPLACE INTO `item_basic` VALUES (30895, 0, 'Stanislao's All-Seeing Mitts', 'StnslaAMtt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30895, 'StnslaAMtt', 32, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30895, 1, 9);
REPLACE INTO `item_mods` VALUES (30895, 25, 5);
REPLACE INTO `item_mods` VALUES (30895, 28, 9);

-- Paralytic Paracelsina trophy + gear
REPLACE INTO `item_basic` VALUES (30896, 0, 'Paracelsina's Petrify Gaze', 'PrclsPGze', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30897, 0, 'Paracelsina's Stone Visor', 'PrclsSVsr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30897, 'PrclsSVsr', 44, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30897, 1, 12);
REPLACE INTO `item_mods` VALUES (30897, 25, 7);
REPLACE INTO `item_mods` VALUES (30897, 30, 12);
REPLACE INTO `item_mods` VALUES (30897, 28, 10);
REPLACE INTO `item_basic` VALUES (30898, 0, 'Paracelsina's Petri Ring', 'PrclsPRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30898, 'PrclsPRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30898, 25, 5);
REPLACE INTO `item_mods` VALUES (30898, 30, 10);
REPLACE INTO `item_mods` VALUES (30898, 9, 30);

-- All Seeing Arbogast trophy + gear
REPLACE INTO `item_basic` VALUES (30899, 0, 'Arbogast's Omniscient Eye', 'ArbgstOEye', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30900, 0, 'Arbogast's Seer's Robe', 'ArbgstSRbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30900, 'ArbgstSRbe', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30900, 1, 17);
REPLACE INTO `item_mods` VALUES (30900, 25, 10);
REPLACE INTO `item_mods` VALUES (30900, 28, 20);
REPLACE INTO `item_mods` VALUES (30900, 30, 14);
REPLACE INTO `item_basic` VALUES (30901, 0, 'Arbogast's Oracle Ring', 'ArbgstORng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30901, 'ArbgstORng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30901, 25, 8);
REPLACE INTO `item_mods` VALUES (30901, 28, 16);
REPLACE INTO `item_mods` VALUES (30901, 30, 14);

-- Scavenging Svetlana trophy + gear
REPLACE INTO `item_basic` VALUES (30902, 0, 'Svetlana's Talon', 'SvtlnTln', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30903, 0, 'Svetlana's Buzzard Earring', 'SvtlnBEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30903, 'SvtlnBEar', 16, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30903, 23, 3);
REPLACE INTO `item_mods` VALUES (30903, 68, 6);
REPLACE INTO `item_mods` VALUES (30903, 13, 2);
REPLACE INTO `item_basic` VALUES (30904, 0, 'Svetlana's Scavenger Boots', 'SvtlnSBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30904, 'SvtlnSBts', 16, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30904, 1, 5);
REPLACE INTO `item_mods` VALUES (30904, 23, 3);
REPLACE INTO `item_mods` VALUES (30904, 68, 7);

-- Carrion Circling Casimira trophy + gear
REPLACE INTO `item_basic` VALUES (30905, 0, 'Casimira's Charnel Feather', 'CsmraCFth', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30906, 0, 'Casimira's Death Glide Mantle', 'CsmraDGMnt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30906, 'CsmraDGMnt', 28, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30906, 1, 8);
REPLACE INTO `item_mods` VALUES (30906, 23, 5);
REPLACE INTO `item_mods` VALUES (30906, 68, 11);
REPLACE INTO `item_basic` VALUES (30907, 0, 'Casimira's Gyre Ring', 'CsmraGRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30907, 'CsmraGRng', 28, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30907, 23, 4);
REPLACE INTO `item_mods` VALUES (30907, 13, 3);
REPLACE INTO `item_mods` VALUES (30907, 25, 7);

-- Bone Picker Bonaventura trophy + gear
REPLACE INTO `item_basic` VALUES (30908, 0, 'Bonaventura's Picking Beak', 'BnvntPBeak', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30909, 0, 'Bonaventura's Gyre Helm', 'BnvntGHlm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30909, 'BnvntGHlm', 40, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30909, 1, 12);
REPLACE INTO `item_mods` VALUES (30909, 23, 6);
REPLACE INTO `item_mods` VALUES (30909, 13, 5);
REPLACE INTO `item_mods` VALUES (30909, 68, 12);
REPLACE INTO `item_basic` VALUES (30910, 0, 'Bonaventura's Carrion Belt', 'BnvntCBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30910, 'BnvntCBlt', 40, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30910, 1, 5);
REPLACE INTO `item_mods` VALUES (30910, 12, 4);
REPLACE INTO `item_mods` VALUES (30910, 29, 10);

-- Sky Sovereign Seraphinus trophy + gear
REPLACE INTO `item_basic` VALUES (30911, 0, 'Seraphinus's Sovereign Feather', 'SrphnusSFth', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30912, 0, 'Seraphinus's Skyking Plate', 'SrphnusSKPlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30912, 'SrphnusSKPlt', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30912, 1, 23);
REPLACE INTO `item_mods` VALUES (30912, 12, 8);
REPLACE INTO `item_mods` VALUES (30912, 23, 7);
REPLACE INTO `item_mods` VALUES (30912, 2, 65);
REPLACE INTO `item_basic` VALUES (30913, 0, 'Seraphinus's Dominion Ring', 'SrphnusDRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30913, 'SrphnusDRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30913, 12, 6);
REPLACE INTO `item_mods` VALUES (30913, 29, 14);
REPLACE INTO `item_mods` VALUES (30913, 23, 5);

-- Chittering Chichester trophy + gear
REPLACE INTO `item_basic` VALUES (30914, 0, 'Chichester's Shiny Pebble', 'ChchtrPbl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30915, 0, 'Chichester's Chatter Ring', 'ChchtrCRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30915, 'ChchtrCRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30915, 13, 3);
REPLACE INTO `item_mods` VALUES (30915, 25, 5);
REPLACE INTO `item_mods` VALUES (30915, 23, 3);
REPLACE INTO `item_basic` VALUES (30916, 0, 'Chichester's Nimble Boots', 'ChchtrNBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30916, 'ChchtrNBts', 18, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30916, 1, 6);
REPLACE INTO `item_mods` VALUES (30916, 23, 4);
REPLACE INTO `item_mods` VALUES (30916, 68, 8);

-- Thieving Theodolinda trophy + gear
REPLACE INTO `item_basic` VALUES (30917, 0, 'Theodolinda's Stolen Gem', 'ThdlndSGm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30918, 0, 'Theodolinda's Pickpocket Mitts', 'ThdlndPMtt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30918, 'ThdlndPMtt', 30, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30918, 1, 9);
REPLACE INTO `item_mods` VALUES (30918, 13, 5);
REPLACE INTO `item_mods` VALUES (30918, 25, 10);
REPLACE INTO `item_basic` VALUES (30919, 0, 'Theodolinda's Swift Earring', 'ThdlndSEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30919, 'ThdlndSEar', 30, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30919, 23, 4);
REPLACE INTO `item_mods` VALUES (30919, 13, 4);
REPLACE INTO `item_mods` VALUES (30919, 384, 3);

-- Banana Baron Balthazar trophy + gear
REPLACE INTO `item_basic` VALUES (30920, 0, 'Balthazar's Royal Banana', 'BlthzrRBnn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30921, 0, 'Balthazar's Jungle Crown', 'BlthzrJCrn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30921, 'BlthzrJCrn', 42, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30921, 1, 12);
REPLACE INTO `item_mods` VALUES (30921, 23, 6);
REPLACE INTO `item_mods` VALUES (30921, 13, 5);
REPLACE INTO `item_mods` VALUES (30921, 68, 11);
REPLACE INTO `item_basic` VALUES (30922, 0, 'Balthazar's Treetop Belt', 'BlthzrTBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30922, 'BlthzrTBlt', 42, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30922, 1, 5);
REPLACE INTO `item_mods` VALUES (30922, 23, 5);
REPLACE INTO `item_mods` VALUES (30922, 384, 4);

-- Primate Prince Pelagius trophy + gear
REPLACE INTO `item_basic` VALUES (30923, 0, 'Pelagius's Primate Insignia', 'PlgsPInsig', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30924, 0, 'Pelagius's Jungle King Robe', 'PlgsJKRbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30924, 'PlgsJKRbe', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30924, 1, 19);
REPLACE INTO `item_mods` VALUES (30924, 23, 8);
REPLACE INTO `item_mods` VALUES (30924, 13, 7);
REPLACE INTO `item_mods` VALUES (30924, 2, 60);
REPLACE INTO `item_basic` VALUES (30925, 0, 'Pelagius's Alpha Ring', 'PlgsAlpRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30925, 'PlgsAlpRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30925, 23, 6);
REPLACE INTO `item_mods` VALUES (30925, 13, 5);
REPLACE INTO `item_mods` VALUES (30925, 25, 13);
REPLACE INTO `item_mods` VALUES (30925, 384, 3);

-- Gnashing Guildenstern trophy + gear
REPLACE INTO `item_basic` VALUES (30926, 0, 'Guildenstern's Cracked Claw', 'GldnsternCC', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30927, 0, 'Guildenstern's Gnole Bracers', 'GldnstrnBrc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30927, 'GldnstrnBrc', 22, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30927, 1, 8);
REPLACE INTO `item_mods` VALUES (30927, 12, 4);
REPLACE INTO `item_mods` VALUES (30927, 29, 8);
REPLACE INTO `item_basic` VALUES (30928, 0, 'Guildenstern's Howl Belt', 'GldnstrnHBlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30928, 'GldnstrnHBlt', 22, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30928, 1, 5);
REPLACE INTO `item_mods` VALUES (30928, 14, 3);
REPLACE INTO `item_mods` VALUES (30928, 2, 20);

-- Pack Lord Petronio trophy + gear
REPLACE INTO `item_basic` VALUES (30929, 0, 'Petronio's Pack Mark', 'PtrnoPMrk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30930, 0, 'Petronio's Packmaster Helm', 'PtrnoPHlm', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30930, 'PtrnoPHlm', 34, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30930, 1, 12);
REPLACE INTO `item_mods` VALUES (30930, 12, 6);
REPLACE INTO `item_mods` VALUES (30930, 14, 4);
REPLACE INTO `item_mods` VALUES (30930, 2, 35);
REPLACE INTO `item_basic` VALUES (30931, 0, 'Petronio's Den Ring', 'PtrnoDRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30931, 'PtrnoDRng', 34, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30931, 12, 4);
REPLACE INTO `item_mods` VALUES (30931, 29, 10);
REPLACE INTO `item_mods` VALUES (30931, 14, 3);

-- Mauling Malaclypse trophy + gear
REPLACE INTO `item_basic` VALUES (30932, 0, 'Malaclypse's Maul Fang', 'MlclpsMFng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30933, 0, 'Malaclypse's Savager Hauberk', 'MlclpsSHbk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30933, 'MlclpsSHbk', 44, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30933, 1, 21);
REPLACE INTO `item_mods` VALUES (30933, 12, 7);
REPLACE INTO `item_mods` VALUES (30933, 14, 6);
REPLACE INTO `item_mods` VALUES (30933, 2, 60);
REPLACE INTO `item_basic` VALUES (30934, 0, 'Malaclypse's Pack Ring', 'MlclpsPRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30934, 'MlclpsPRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30934, 12, 5);
REPLACE INTO `item_mods` VALUES (30934, 29, 12);
REPLACE INTO `item_mods` VALUES (30934, 14, 4);

-- Alpha Apollinarius trophy + gear
REPLACE INTO `item_basic` VALUES (30935, 0, 'Apollinarius's Alpha Fang', 'ApllnrsAFng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30936, 0, 'Apollinarius's Alpha Plate', 'ApllnrsAPlt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30936, 'ApllnrsAPlt', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30936, 1, 26);
REPLACE INTO `item_mods` VALUES (30936, 12, 9);
REPLACE INTO `item_mods` VALUES (30936, 14, 8);
REPLACE INTO `item_mods` VALUES (30936, 2, 80);
REPLACE INTO `item_basic` VALUES (30937, 0, 'Apollinarius's Pack Crown', 'ApllnrsPCrn', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30937, 'ApllnrsPCrn', 54, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30937, 1, 15);
REPLACE INTO `item_mods` VALUES (30937, 12, 7);
REPLACE INTO `item_mods` VALUES (30937, 14, 6);
REPLACE INTO `item_mods` VALUES (30937, 2, 50);

-- Tiny Tortoise Tibalt trophy + gear
REPLACE INTO `item_basic` VALUES (30938, 0, 'Tibalt's Shell Chip', 'TbltShCp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30939, 0, 'Tibalt's Shell Ring', 'TbltShRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30939, 'TbltShRng', 26, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30939, 1, 4);
REPLACE INTO `item_mods` VALUES (30939, 14, 3);
REPLACE INTO `item_mods` VALUES (30939, 29, 5);
REPLACE INTO `item_basic` VALUES (30940, 0, 'Tibalt's Plated Sandals', 'TbltPSnd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30940, 'TbltPSnd', 26, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30940, 1, 8);
REPLACE INTO `item_mods` VALUES (30940, 14, 3);
REPLACE INTO `item_mods` VALUES (30940, 2, 25);

-- Armored Archibald trophy + gear
REPLACE INTO `item_basic` VALUES (30941, 0, 'Archibald's Spiked Shell', 'ArchbldSSh', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30942, 0, 'Archibald's Fortress Collar', 'ArchbldFCl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30942, 'ArchbldFCl', 40, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30942, 1, 6);
REPLACE INTO `item_mods` VALUES (30942, 14, 6);
REPLACE INTO `item_mods` VALUES (30942, 2, 40);
REPLACE INTO `item_mods` VALUES (30942, 29, 6);
REPLACE INTO `item_basic` VALUES (30943, 0, 'Archibald's Rampart Boots', 'ArchbldRBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30943, 'ArchbldRBts', 40, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30943, 1, 13);
REPLACE INTO `item_mods` VALUES (30943, 14, 5);
REPLACE INTO `item_mods` VALUES (30943, 2, 40);

-- Elder Shell Eleanor trophy + gear
REPLACE INTO `item_basic` VALUES (30944, 0, 'Eleanor's Elder Shell', 'ElnrEldSh', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30945, 0, 'Eleanor's Ancient Carapace', 'ElnrACrp', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30945, 'ElnrACrp', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30945, 1, 26);
REPLACE INTO `item_mods` VALUES (30945, 14, 9);
REPLACE INTO `item_mods` VALUES (30945, 2, 80);
REPLACE INTO `item_mods` VALUES (30945, 29, 10);
REPLACE INTO `item_basic` VALUES (30946, 0, 'Eleanor's Stone Ring', 'ElnrStnRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30946, 'ElnrStnRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30946, 14, 6);
REPLACE INTO `item_mods` VALUES (30946, 2, 50);
REPLACE INTO `item_mods` VALUES (30946, 29, 8);

-- Adamantoise Emperor Alexandros trophy + gear
REPLACE INTO `item_basic` VALUES (30947, 0, 'Alexandros's Imperial Shell', 'AlxndrsISh', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30948, 0, 'Alexandros's Titan Fortress', 'AlxndrsTF', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30948, 'AlxndrsTF', 60, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30948, 1, 32);
REPLACE INTO `item_mods` VALUES (30948, 14, 11);
REPLACE INTO `item_mods` VALUES (30948, 2, 110);
REPLACE INTO `item_mods` VALUES (30948, 29, 12);
REPLACE INTO `item_basic` VALUES (30949, 0, 'Alexandros's Bastion Ring', 'AlxndrsBRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30949, 'AlxndrsBRng', 60, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30949, 14, 8);
REPLACE INTO `item_mods` VALUES (30949, 2, 65);
REPLACE INTO `item_mods` VALUES (30949, 29, 10);

-- Coiling Callirhoe trophy + gear
REPLACE INTO `item_basic` VALUES (30950, 0, 'Callirhoe's Coil Ring', 'CllrhoeRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30951, 0, 'Callirhoe's Serpentine Earring', 'CllrhoeEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30951, 'CllrhoeEar', 22, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30951, 28, 4);
REPLACE INTO `item_mods` VALUES (30951, 25, 3);
REPLACE INTO `item_mods` VALUES (30951, 30, 6);
REPLACE INTO `item_basic` VALUES (30952, 0, 'Callirhoe's Scale Sash', 'CllrhoeSsh', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30952, 'CllrhoeSsh', 22, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30952, 1, 5);
REPLACE INTO `item_mods` VALUES (30952, 28, 3);
REPLACE INTO `item_mods` VALUES (30952, 9, 20);

-- Charming Chrysanthema trophy + gear
REPLACE INTO `item_basic` VALUES (30953, 0, 'Chrysanthema's Charm Bead', 'ChrsnthmCBd', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30954, 0, 'Chrysanthema's Enchanting Collar', 'ChrsnthmCCl', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30954, 'ChrsnthmCCl', 34, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30954, 28, 6);
REPLACE INTO `item_mods` VALUES (30954, 68, 5);
REPLACE INTO `item_mods` VALUES (30954, 9, 30);
REPLACE INTO `item_basic` VALUES (30955, 0, 'Chrysanthema's Lure Ring', 'ChrsnthmLRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30955, 'ChrsnthmLRng', 34, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30955, 28, 5);
REPLACE INTO `item_mods` VALUES (30955, 25, 4);
REPLACE INTO `item_mods` VALUES (30955, 30, 8);

-- Seductive Seraphimia trophy + gear
REPLACE INTO `item_basic` VALUES (30956, 0, 'Seraphimia's Seduction Scale', 'SrphmSdcSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30957, 0, 'Seraphimia's Siren Robe', 'SrphmSRbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30957, 'SrphmSRbe', 46, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30957, 1, 16);
REPLACE INTO `item_mods` VALUES (30957, 28, 8);
REPLACE INTO `item_mods` VALUES (30957, 25, 6);
REPLACE INTO `item_mods` VALUES (30957, 9, 65);
REPLACE INTO `item_basic` VALUES (30958, 0, 'Seraphimia's Temptress Ring', 'SrphmTmpRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30958, 'SrphmTmpRng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30958, 28, 6);
REPLACE INTO `item_mods` VALUES (30958, 25, 5);
REPLACE INTO `item_mods` VALUES (30958, 30, 10);

-- Serpent Queen Sophronia trophy + gear
REPLACE INTO `item_basic` VALUES (30959, 0, 'Sophronia's Royal Scale', 'SphrnaRSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30960, 0, 'Sophronia's Sea Queen Tiara', 'SphrnaSTar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30960, 'SphrnaSTar', 58, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30960, 1, 15);
REPLACE INTO `item_mods` VALUES (30960, 28, 9);
REPLACE INTO `item_mods` VALUES (30960, 25, 7);
REPLACE INTO `item_mods` VALUES (30960, 9, 55);
REPLACE INTO `item_basic` VALUES (30961, 0, 'Sophronia's Sovereign Ring', 'SphrnaSOvRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30961, 'SphrnaSOvRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30961, 28, 7);
REPLACE INTO `item_mods` VALUES (30961, 25, 6);
REPLACE INTO `item_mods` VALUES (30961, 30, 13);

-- Bloodsucking Barnard trophy + gear
REPLACE INTO `item_basic` VALUES (30962, 0, 'Barnard's Bloodsack', 'BrndBlSck', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30963, 0, 'Barnard's Crimson Earring', 'BrndCEar', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30963, 'BrndCEar', 12, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30963, 14, 3);
REPLACE INTO `item_mods` VALUES (30963, 2, 15);
REPLACE INTO `item_mods` VALUES (30963, 29, 3);
REPLACE INTO `item_basic` VALUES (30964, 0, 'Barnard's Drain Ring', 'BrndDrRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30964, 'BrndDrRng', 12, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30964, 25, 2);
REPLACE INTO `item_mods` VALUES (30964, 30, 4);
REPLACE INTO `item_mods` VALUES (30964, 9, 10);

-- Gorging Griselda trophy + gear
REPLACE INTO `item_basic` VALUES (30965, 0, 'Griselda's Bloated Sac', 'GrsldaBSc', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30966, 0, 'Griselda's Blood Collar', 'GrsldaBCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30966, 'GrsldaBCll', 24, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30966, 14, 4);
REPLACE INTO `item_mods` VALUES (30966, 2, 25);
REPLACE INTO `item_mods` VALUES (30966, 29, 5);
REPLACE INTO `item_basic` VALUES (30967, 0, 'Griselda's Gorge Mitts', 'GrsldaGMtt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30967, 'GrsldaGMtt', 24, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30967, 1, 8);
REPLACE INTO `item_mods` VALUES (30967, 14, 4);
REPLACE INTO `item_mods` VALUES (30967, 2, 30);

-- Plasma Draining Placida trophy + gear
REPLACE INTO `item_basic` VALUES (30968, 0, 'Placida's Ichor Flask', 'PlcdaIchrF', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30969, 0, 'Placida's Marrow Hauberk', 'PlcdaMHbk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30969, 'PlcdaMHbk', 36, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30969, 1, 17);
REPLACE INTO `item_mods` VALUES (30969, 14, 6);
REPLACE INTO `item_mods` VALUES (30969, 2, 55);
REPLACE INTO `item_mods` VALUES (30969, 29, 6);
REPLACE INTO `item_basic` VALUES (30970, 0, 'Placida's Siphon Ring', 'PlcdaSpRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30970, 'PlcdaSpRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30970, 14, 4);
REPLACE INTO `item_mods` VALUES (30970, 2, 30);
REPLACE INTO `item_mods` VALUES (30970, 29, 7);

-- Ancient Lamprey Augustine trophy + gear
REPLACE INTO `item_basic` VALUES (30971, 0, 'Augustine's Ancient Sucker', 'AgstnASckr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30972, 0, 'Augustine's Life Drain Robe', 'AgstnLDRbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30972, 'AgstnLDRbe', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30972, 1, 19);
REPLACE INTO `item_mods` VALUES (30972, 14, 8);
REPLACE INTO `item_mods` VALUES (30972, 2, 70);
REPLACE INTO `item_mods` VALUES (30972, 25, 6);
REPLACE INTO `item_basic` VALUES (30973, 0, 'Augustine's Vital Ring', 'AgstnVtRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30973, 'AgstnVtRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30973, 14, 6);
REPLACE INTO `item_mods` VALUES (30973, 2, 45);
REPLACE INTO `item_mods` VALUES (30973, 29, 8);

-- Larval Lavrentiy trophy + gear
REPLACE INTO `item_basic` VALUES (30974, 0, 'Lavrentiy's Larval Silk', 'LvrntLSilk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30975, 0, 'Lavrentiy's Chrysalis Ring', 'LvrnCRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30975, 'LvrnCRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30975, 25, 3);
REPLACE INTO `item_mods` VALUES (30975, 9, 15);
REPLACE INTO `item_mods` VALUES (30975, 30, 4);
REPLACE INTO `item_basic` VALUES (30976, 0, 'Lavrentiy's Wriggle Boots', 'LvrnWBts', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30976, 'LvrnWBts', 18, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30976, 1, 5);
REPLACE INTO `item_mods` VALUES (30976, 23, 3);
REPLACE INTO `item_mods` VALUES (30976, 68, 7);

-- Spinning Sebestyen trophy + gear
REPLACE INTO `item_basic` VALUES (30977, 0, 'Sebestyen's Cocoon Silk', 'SbstynCSilk', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30978, 0, 'Sebestyen's Web Collar', 'SbstynWCll', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30978, 'SbstynWCll', 30, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30978, 25, 4);
REPLACE INTO `item_mods` VALUES (30978, 9, 25);
REPLACE INTO `item_mods` VALUES (30978, 30, 6);
REPLACE INTO `item_basic` VALUES (30979, 0, 'Sebestyen's Spinner Mitts', 'SbstynSMtt', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30979, 'SbstynSMtt', 30, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30979, 1, 9);
REPLACE INTO `item_mods` VALUES (30979, 25, 4);
REPLACE INTO `item_mods` VALUES (30979, 28, 8);

-- Metamorphing Melchior trophy + gear
REPLACE INTO `item_basic` VALUES (30980, 0, 'Melchior's Morphing Core', 'MlchrMCr', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30981, 0, 'Melchior's Transform Robe', 'MlchrTRbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30981, 'MlchrTRbe', 42, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30981, 1, 17);
REPLACE INTO `item_mods` VALUES (30981, 25, 7);
REPLACE INTO `item_mods` VALUES (30981, 28, 14);
REPLACE INTO `item_mods` VALUES (30981, 9, 55);
REPLACE INTO `item_basic` VALUES (30982, 0, 'Melchior's Emergence Ring', 'MlchrERng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30982, 'MlchrERng', 42, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30982, 25, 5);
REPLACE INTO `item_mods` VALUES (30982, 30, 9);
REPLACE INTO `item_mods` VALUES (30982, 28, 8);

-- Melpomene trophy + gear
REPLACE INTO `item_basic` VALUES (30983, 0, 'Melpomene's Chrysalis', 'MlpmChrys', 1, 46660, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (30984, 0, 'Melpomene's Ascendant Robe', 'MlpmARbe', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30984, 'MlpmARbe', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30984, 1, 21);
REPLACE INTO `item_mods` VALUES (30984, 25, 10);
REPLACE INTO `item_mods` VALUES (30984, 28, 20);
REPLACE INTO `item_mods` VALUES (30984, 9, 85);
REPLACE INTO `item_basic` VALUES (30985, 0, 'Melpomene's Chrysalis Ring', 'MlpmCRng', 1, 46660, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (30985, 'MlpmCRng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (30985, 25, 7);
REPLACE INTO `item_mods` VALUES (30985, 28, 15);
REPLACE INTO `item_mods` VALUES (30985, 30, 13);
