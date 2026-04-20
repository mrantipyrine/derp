-- =============================================================================
-- CUSTOM ITEMS - Dynamic World Drops
-- =============================================================================
-- Safe ID range: 16384-30999 (vanilla tops out ~29695)
--
-- HOW TO ADD A NEW ITEM:
--   1. Pick the next unused ID in the 16384+ range
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

-- [16384] Morris's Wide Brim  (head, all jobs, lv1, silly flavor)
REPLACE INTO `item_basic` VALUES
    (23437, 0, 'Morris_Brim', 'morris_brim', 1, 59476, 99, 0, 500);

REPLACE INTO `item_equipment` VALUES
    -- itemId  name                    lv  ilv  jobs       MId  shieldSz  scriptType  slot  rslot  rslotlook  su_lv
    (23437, "morriss_wide_brim",        1,   0,  4194303,    0,        0,         0,    1,     0,         0,     0);
    --                                                       ^all jobs              ^HEAD slot

REPLACE INTO `item_mods` VALUES
    (23437,  2,  50),   -- HP +50
    (23437,  13,   5),   -- MND +5   (he's wise in mushroom ways)
    (23437, 14,   5);   -- CHR +5   (very charming hat)


-- [16402] Morris's Sporeling  (rare key item / curiosity, no equip — just a trophy drop)
REPLACE INTO `item_basic` VALUES
    (16402, 0, 'Mrrs_Sporeling', 'mrrs_sporeling', 1, 59476, 99, 1, 0);
    -- NoSale=1, BaseSell=0 — unsellable trophy


-- [16415] Mycelium Medal  (neck, all jobs, lv10, rare reward)
REPLACE INTO `item_basic` VALUES
    (26117, 0, 'Mycelium_Medal', 'mycelium_medal', 1, 59476, 99, 0, 28197);

REPLACE INTO `item_equipment` VALUES
    (26117, "mycelium_medal",           10,  0,  4194303,    0,        0,         0,    4,     0,         0,     0);
    --                                                                                   ^NECK slot

REPLACE INTO `item_mods` VALUES
    (26117,  2,  30),   -- HP +30
    (26117,  5,  15),   -- MP +15
    (26117, 384,   5);   -- Haste +5


-- =============================================================================
-- SECTION 2: DYNAMIC WORLD TIER REWARDS
-- Generic rare drops from Elite / Apex tiers
-- =============================================================================

-- [16424] Wanderer's Token  (ring, all jobs, lv1)
REPLACE INTO `item_basic` VALUES
    (11638, 0, 'Wanderer_Token', 'wanderer_token', 1, 59476, 99, 0, 200);
REPLACE INTO `item_equipment` VALUES
    (11638, "wanderers_token",           1,  0,  4194303,    0,        0,         0,   64,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (11638,  8,   3),   -- STR +3
    (11638,  9,   3);   -- DEX +3

-- [16435] Nomad's Cord  (waist, all jobs, lv20)
REPLACE INTO `item_basic` VALUES
    (28439, 0, 'Nomad_Cord', 'nomad_cord', 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (28439, "nomads_cord",              20,  0,  4194303,    0,        0,         0,  512,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (28439,  8,   5),   -- STR +5
    (28439,  10,   5),   -- VIT +5
    (28439, 23,  10);   -- ATT +10

-- [16436] Elite's Resolve  (back, all jobs, lv40)
REPLACE INTO `item_basic` VALUES
    (28610, 0, 'Elite_Resolve', 'elite_resolve', 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (28610, "elites_resolve",           40,  0,  4194303,    0,        0,         0,  256,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (28610,  2,  50),   -- HP +50
    (28610,  8,   8),   -- STR +8
    (28610, 23,  15),   -- ATT +15
    (28610, 25,  10);   -- ACC +10

-- [16462] Apex Shard  (ring, all jobs, lv50)
REPLACE INTO `item_basic` VALUES
    (11677, 0, 'Apex_Shard', 'apex_shard', 1, 59476, 99, 0, 10000);
REPLACE INTO `item_equipment` VALUES
    (11677, "apex_shard",               50,  0,  4194303,    0,        0,         0,   64,     0,         0,     0);
REPLACE INTO `item_mods` VALUES
    (11677,  2, 100),   -- HP +100
    (11677,  5,  50),   -- MP +50
    (11677,  8,  10),   -- STR +10
    (11677,  12,  10),   -- INT +10
    (11677, 384,  10);   -- Haste +10


-- =============================================================================
-- SECTION 3: NAMED RARE UNIQUE DROPS
-- Every named rare has 3 items: trophy (always), gear1 (40%), gear2 (15%)
-- =============================================================================

-- =========================================================
-- SHEEP
-- =========================================================

-- Wooly William (lv6-8) — 18467-27938
REPLACE INTO `item_basic` VALUES
    (18467, 0, 'William_Wool', 'william_wool', 1, 59476, 99, 0, 50);
-- trophy, no equip

REPLACE INTO `item_basic` VALUES
    (23438, 0, 'William_Woolcap', 'william_woolcap', 1, 59476, 99, 0, 300);
REPLACE INTO `item_equipment` VALUES
    (23438, "williams_woolcap",          5,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23438,  1,   3),   -- DEF +3
    (23438,  2,  15),   -- HP +15
    (23438, 14,   3);   -- CHR +3

REPLACE INTO `item_basic` VALUES
    (23539, 0, 'Wllm_Woolmitt', 'wllm_woolmitt', 1, 59476, 99, 0, 500);
REPLACE INTO `item_equipment` VALUES
    (23539, "williams_woolmitt",         5,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23539,  1,   2),   -- DEF +2
    (23539,  10,   3),   -- VIT +3
    (23539,  13,   3);   -- MND +3


-- Baa-rbara (lv10-13) — 18528-18530
REPLACE INTO `item_basic` VALUES
    (18528, 0, 'Baarbara_Bell', 'baarbara_bell', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (26007, 0, 'Baarbara_Collar', 'baarbara_collar', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (26007, "baarbaras_collar",         10,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (26007,  2,  20),   -- HP +20
    (26007, 14,   5),   -- CHR +5
    (26007,  13,   3);   -- MND +3

REPLACE INTO `item_basic` VALUES
    (28441, 0, 'Baarbara_Ribbon', 'baarbara_ribbon', 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (28441, "baarbaras_ribbon",         10,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28441, 68,   5),   -- EVA +5
    (28441,  11,   4),   -- AGI +4
    (28441, 14,   4);   -- CHR +4


-- Lambchop Larry (lv20-24) — 18548-18550
REPLACE INTO `item_basic` VALUES
    (18548, 0, 'Larry_Lambchop', 'larry_lambchop', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (28611, 0, 'Larry_Fleece', 'larry_fleece', 1, 59476, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (28611, "larrys_lucky_fleece",      20,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28611,  1,   8),   -- DEF +8
    (28611,  2,  30),   -- HP +30
    (28611, 68,   5);   -- EVA +5

REPLACE INTO `item_basic` VALUES
    (26008, 0, 'Larry_Lanyard', 'larry_lanyard', 1, 59476, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (26008, "larrys_lanyard",           20,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (26008,  8,   5),   -- STR +5
    (26008, 23,   8),   -- ATT +8
    (26008, 25,   5);   -- ACC +5


-- Shear Sharon (lv35-40) — 18567-18569
REPLACE INTO `item_basic` VALUES
    (18567, 0, 'Sharon_Fleece', 'sharon_fleece', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23529, 0, 'Sharon_Shears', 'sharon_shears', 1, 59476, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (23529, "sharons_shears",           35,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23529,  1,  12),   -- DEF +12
    (23529,  9,   8),   -- DEX +8
    (23529, 25,  10),   -- ACC +10
    (23529, 23,   8);   -- ATT +8

REPLACE INTO `item_basic` VALUES
    (28612, 0, 'Sharon_Mantle', 'sharon_mantle', 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (28612, "sharons_silken_mantle",    35,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28612,  1,  10),   -- DEF +10
    (28612,  2,  40),   -- HP +40
    (28612,  5,  20),   -- MP +20
    (28612, 29,   8);   -- MDEF +8


-- =========================================================
-- RABBITS
-- =========================================================

-- Cottontail Tom (lv5-7) — 18570-18795
REPLACE INTO `item_basic` VALUES
    (18570, 0, 'Tom_Cottontail', 'tom_cottontail', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (14645, 0, 'Tom_Foot', 'tom_foot', 1, 59476, 99, 0, 300);
REPLACE INTO `item_equipment` VALUES
    (14645, "toms_lucky_foot",           5,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (14645,  11,   3),   -- AGI +3
    (14645, 68,   3);   -- EVA +3

REPLACE INTO `item_basic` VALUES
    (23751, 0, 'Tom_Hop_Boots', 'tom_hop_boots', 1, 59476, 99, 0, 500);
REPLACE INTO `item_equipment` VALUES
    (23751, "toms_hop_boots",            5,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23751,  1,   2),   -- DEF +2
    (23751,  11,   4),   -- AGI +4
    (23751, 68,   3);   -- EVA +3


-- Hopscotch Harvey (lv10-13) — 18796-18798
REPLACE INTO `item_basic` VALUES
    (18796, 0, 'Harvey_Hopstone', 'harvey_hopstone', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (11640, 0, 'Harvey_Hop_Ring', 'harvey_hop_ring', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (11640, "harveys_hop_ring",         10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (11640,  11,   5),   -- AGI +5
    (11640,  9,   3),   -- DEX +3
    (11640, 68,   5);   -- EVA +5

REPLACE INTO `item_basic` VALUES
    (27526, 0, 'Harvey_Earring', 'harvey_earring', 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (27526, "harveys_spring_earring",   10,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (27526,  11,   6),   -- AGI +6
    (27526, 384,   3);   -- Haste +3


-- Bunbun Benedict (lv22-28) — 18799-18835
REPLACE INTO `item_basic` VALUES
    (18799, 0, 'Benedict_Bonnet', 'benedict_bonnet', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23439, 0, 'Benedict_Cap', 'benedict_cap', 1, 59476, 99, 0, 1400);
REPLACE INTO `item_equipment` VALUES
    (23439, "benedicts_fur_cap",        22,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23439,  1,   8),   -- DEF +8
    (23439,  11,   6),   -- AGI +6
    (23439, 68,   8),   -- EVA +8
    (23439,  2,  25);   -- HP +25

REPLACE INTO `item_basic` VALUES
    (28442, 0, 'Benedict_Belt', 'benedict_belt', 1, 59476, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (28442, "benedicts_burrow_belt",    22,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28442,  9,   6),   -- DEX +6
    (28442,  11,   6),   -- AGI +6
    (28442, 25,   8);   -- ACC +8


-- Twitchy Theodore (lv38-45) — 18836-18838
REPLACE INTO `item_basic` VALUES
    (18836, 0, 'Theodore_Twitch', 'theodore_twitch', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23752, 0, 'Thdr_Greaves', 'thdr_greaves', 1, 59476, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (23752, "theodores_dash_greaves",   38,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23752,  1,  14),   -- DEF +14
    (23752,  11,  10),   -- AGI +10
    (23752, 68,  12),   -- EVA +12
    (23752, 384,   5);   -- Haste +5

REPLACE INTO `item_basic` VALUES
    (27527, 0, 'Thdr_Earring', 'thdr_earring', 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (27527, "theodores_panic_earring",  38,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (27527,  11,  10),   -- AGI +10
    (27527, 68,  15),   -- EVA +15
    (27527, 384,   4);   -- Haste +4


-- =========================================================
-- CRABS
-- =========================================================

-- Crableg Cameron (lv12-16) — 18889-18917
REPLACE INTO `item_basic` VALUES
    (18889, 0, 'Cameron_Claw', 'cameron_claw', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23530, 0, 'Cameron_Shield', 'cameron_shield', 1, 59476, 99, 0, 700);
REPLACE INTO `item_equipment` VALUES
    (23530, "camerons_shell_shield",    12,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23530,  1,   5),   -- DEF +5
    (23530,  10,   4),   -- VIT +4
    (23530,  2,  20);   -- HP +20

REPLACE INTO `item_basic` VALUES
    (28529, 0, 'Cameron_Ring', 'cameron_ring', 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (28529, "camerons_coral_ring",      12,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28529,  10,   5),   -- VIT +5
    (28529,  1,   4),   -- DEF +4
    (28529, 29,   4);   -- MDEF +4


-- Old Bay Ollie (lv25-30) — 18918-18920
REPLACE INTO `item_basic` VALUES
    (18918, 0, 'Ollie_Shell', 'ollie_shell', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23531, 0, 'Ollie_Gauntlets', 'ollie_gauntlets', 1, 59476, 99, 0, 1600);
REPLACE INTO `item_equipment` VALUES
    (23531, "ollies_brine_gauntlets",   25,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23531,  1,  10),   -- DEF +10
    (23531,  10,   7),   -- VIT +7
    (23531,  2,  30),   -- HP +30
    (23531, 27,   3);   -- Enmity +3

REPLACE INTO `item_basic` VALUES
    (28443, 0, 'Ollie_Belt', 'ollie_belt', 1, 59476, 99, 0, 2500);
REPLACE INTO `item_equipment` VALUES
    (28443, "ollies_seasoned_belt",     25,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28443,  10,   8),   -- VIT +8
    (28443,  1,   8),   -- DEF +8
    (28443, 29,   6);   -- MDEF +6


-- Bisque Bernard (lv35-42) — 19322-19745
REPLACE INTO `item_basic` VALUES
    (19322, 0, 'Bernard_Bowl', 'bernard_bowl', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25692, 0, 'Bernard_Mail', 'bernard_mail', 1, 59476, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (25692, "bernards_tidal_mail",      35,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (25692,  1,  18),   -- DEF +18
    (25692,  10,  10),   -- VIT +10
    (25692,  2,  50),   -- HP +50
    (25692, 27,   5);   -- Enmity +5

REPLACE INTO `item_basic` VALUES
    (27528, 0, 'Bernard_Earring', 'bernard_earring', 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (27528, "bernards_brine_earring",   35,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (27528,  10,   8),   -- VIT +8
    (27528, 29,  10),   -- MDEF +10
    (27528,  5,  20);   -- MP +20


-- Dungeness Duncan (lv45-52) — 19804-19969
REPLACE INTO `item_basic` VALUES
    (19804, 0, 'Duncan_Pincer', 'duncan_pincer', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23440, 0, 'Duncan_Helm', 'duncan_helm', 1, 59476, 99, 0, 8000);
REPLACE INTO `item_equipment` VALUES
    (23440, "duncans_abyssal_helm",     45,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23440,  1,  22),   -- DEF +22
    (23440,  10,  12),   -- VIT +12
    (23440,  2,  60),   -- HP +60
    (23440, 29,  10);   -- MDEF +10

REPLACE INTO `item_basic` VALUES
    (28567, 0, 'Duncan_Ring', 'duncan_ring', 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (28567, "duncans_deepwater_ring",   45,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28567,  10,  12),   -- VIT +12
    (28567,  1,  15),   -- DEF +15
    (28567,  2,  80),   -- HP +80
    (28567, 384,   5);   -- Haste +5


-- =========================================================
-- FUNGARS
-- =========================================================

-- Cap'n Chanterelle (lv18-22) — 19970-19972
REPLACE INTO `item_basic` VALUES
    (19970, 0, 'Chanterelle_Cap', 'chanterelle_cap', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23441, 0, 'Chanterelle_Hat', 'chanterelle_hat', 1, 59476, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (23441, "chanterelles_spore_hat",   18,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23441,  1,   7),   -- DEF +7
    (23441,  12,   5),   -- INT +5
    (23441,  5,  20),   -- MP +20
    (23441, 28,   4);   -- MATK +4

REPLACE INTO `item_basic` VALUES
    (28445, 0, 'Chntrll_Mycelia', 'chntrll_mycelia', 1, 59476, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (28445, "chanterelles_mycelia",     18,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28445,  12,   6),   -- INT +6
    (28445,  13,   4),   -- MND +4
    (28445, 28,   5);   -- MATK +5


-- Portobello Pete (lv35-40) — 19973-19975
REPLACE INTO `item_basic` VALUES
    (19973, 0, 'Pete_Portobello', 'pete_portobello', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25693, 0, 'Pete_Robe', 'pete_robe', 1, 59476, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (25693, "petes_fungal_robe",        35,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (25693,  1,  15),   -- DEF +15
    (25693,  12,  10),   -- INT +10
    (25693,  5,  40),   -- MP +40
    (25693, 28,   8);   -- MATK +8

REPLACE INTO `item_basic` VALUES
    (26009, 0, 'Pete_Necklace', 'pete_necklace', 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (26009, "petes_spore_necklace",     35,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (26009,  12,   8),   -- INT +8
    (26009, 28,  10),   -- MATK +10
    (26009, 30,   8);   -- MACC +8


-- Truffle Trevor (lv55-62) — 19976-19978
REPLACE INTO `item_basic` VALUES
    (19976, 0, 'Trevor_Truffle', 'trevor_truffle', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23710, 0, 'Trevor_Crown', 'trevor_crown', 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (23710, "trevors_myconid_crown",    55,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23710,  1,  20),   -- DEF +20
    (23710,  12,  15),   -- INT +15
    (23710,  5,  60),   -- MP +60
    (23710, 28,  15),   -- MATK +15
    (23710, 30,  10);   -- MACC +10

REPLACE INTO `item_basic` VALUES
    (11628, 0, 'Trevor_Ring', 'trevor_ring', 1, 59476, 99, 0, 15000);
REPLACE INTO `item_equipment` VALUES
    (11628, "trevors_decay_ring",       55,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (11628,  12,  14),   -- INT +14
    (11628, 28,  18),   -- MATK +18
    (11628,  5,  50),   -- MP +50
    (11628, 384,   5);   -- Haste +5


-- =========================================================
-- GOBLINS
-- =========================================================

-- Bargain Bruno (lv12-16) — 19979-19981
REPLACE INTO `item_basic` VALUES
    (19979, 0, 'Bruno_Bin', 'bruno_bin', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23711, 0, 'Bruno_Helm', 'bruno_helm', 1, 59476, 99, 0, 700);
REPLACE INTO `item_equipment` VALUES
    (23711, "brunos_discount_helm",     12,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23711,  1,   5),   -- DEF +5
    (23711,  8,   3),   -- STR +3
    (23711,  9,   3),   -- DEX +3
    (23711, 14,   3);   -- CHR +3

REPLACE INTO `item_basic` VALUES
    (28446, 0, 'Bruno_Pouch', 'bruno_pouch', 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (28446, "brunos_lucky_pouch",       12,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28446,  9,   5),   -- DEX +5
    (28446, 25,   5),   -- ACC +5
    (28446, 14,   4);   -- CHR +4


-- Swindler Sam (lv30-36) — 19982-19984
REPLACE INTO `item_basic` VALUES
    (19982, 0, 'Sam_Loaded_Dice', 'sam_loaded_dice', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25694, 0, 'Sam_Vest', 'sam_vest', 1, 59476, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (25694, "sams_swindler_vest",       30,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (25694,  1,  14),   -- DEF +14
    (25694,  9,   8),   -- DEX +8
    (25694,  11,   6),   -- AGI +6
    (25694, 68,   8);   -- EVA +8

REPLACE INTO `item_basic` VALUES
    (27529, 0, 'Sam_Earring', 'sam_earring', 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (27529, "sams_grift_earring",       30,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (27529,  9,   8),   -- DEX +8
    (27529, 25,  10),   -- ACC +10
    (27529, 384,   4);   -- Haste +4


-- Shiny Steve (lv45-52) — 19985-19987
REPLACE INTO `item_basic` VALUES
    (19985, 0, 'Steve_Shiniest', 'steve_shiniest', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25695, 0, 'Steve_Mail', 'steve_mail', 1, 59476, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (25695, "steves_glittering_mail",   45,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (25695,  1,  22),   -- DEF +22
    (25695,  9,  12),   -- DEX +12
    (25695,  11,  10),   -- AGI +10
    (25695, 25,  15),   -- ACC +15
    (25695, 68,  10);   -- EVA +10

REPLACE INTO `item_basic` VALUES
    (11630, 0, 'Steve_Ring', 'steve_ring', 1, 59476, 99, 0, 14000);
REPLACE INTO `item_equipment` VALUES
    (11630, "steves_magpie_ring",       45,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (11630,  9,  12),   -- DEX +12
    (11630, 25,  15),   -- ACC +15
    (11630, 23,  12),   -- ATT +12
    (11630, 384,   5);   -- Haste +5


-- =========================================================
-- COEURLS
-- =========================================================

-- Whiskers Wilhelmina (lv30-36) — 19988-10581
REPLACE INTO `item_basic` VALUES
    (19988, 0, 'Wlhlmn_Whisker', 'wlhlmn_whisker', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (26010, 0, 'Wilhelmina_Neck', 'wilhelmina_neck', 1, 59476, 99, 0, 3500);
REPLACE INTO `item_equipment` VALUES
    (26010, "wilhelminas_fang_necklace",30,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (26010, 23,  10),   -- ATT +10
    (26010,  8,   7),   -- STR +7
    (26010,  9,   5);   -- DEX +5

REPLACE INTO `item_basic` VALUES
    (23253, 0, 'Wilhelmina_Legs', 'wilhelmina_legs', 1, 59476, 99, 0, 5500);
REPLACE INTO `item_equipment` VALUES
    (23253, "wilhelminas_grace_legs",   30,  0,  4194303,    0,   0,  0, 1024,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23253,  1,  14),   -- DEF +14
    (23253,  11,   8),   -- AGI +8
    (23253, 68,  10),   -- EVA +10
    (23253,  8,   6);   -- STR +6


-- Purring Patricia (lv42-48) — 19991-19993
REPLACE INTO `item_basic` VALUES
    (19991, 0, 'Patricia_Purr', 'patricia_purr', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23532, 0, 'Ptrc_Gauntlets', 'ptrc_gauntlets', 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (23532, "patricias_claw_gauntlets", 42,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23532,  1,  16),   -- DEF +16
    (23532,  8,  10),   -- STR +10
    (23532, 23,  14),   -- ATT +14
    (23532,  9,   8);   -- DEX +8

REPLACE INTO `item_basic` VALUES
    (28614, 0, 'Patricia_Cape', 'patricia_cape', 1, 59476, 99, 0, 10000);
REPLACE INTO `item_equipment` VALUES
    (28614, "patricias_predator_cape",  42,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28614,  8,  10),   -- STR +10
    (28614,  11,  10),   -- AGI +10
    (28614, 23,  12),   -- ATT +12
    (28614, 25,  12);   -- ACC +12


-- Nine Lives Nigel (lv58-65) — 19994-19996
REPLACE INTO `item_basic` VALUES
    (19994, 0, 'Nigel_Life', 'nigel_life', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25696, 0, 'Nigel_Cuirass', 'nigel_cuirass', 1, 59476, 99, 0, 15000);
REPLACE INTO `item_equipment` VALUES
    (25696, "nigels_feral_cuirass",     58,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (25696,  1,  28),   -- DEF +28
    (25696,  8,  14),   -- STR +14
    (25696,  9,  12),   -- DEX +12
    (25696, 23,  18),   -- ATT +18
    (25696, 25,  15);   -- ACC +15

REPLACE INTO `item_basic` VALUES
    (11631, 0, 'Nigel_Ring', 'nigel_ring', 1, 59476, 99, 0, 18000);
REPLACE INTO `item_equipment` VALUES
    (11631, "nigels_cateye_ring",       58,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (11631,  8,  14),   -- STR +14
    (11631, 23,  20),   -- ATT +20
    (11631, 25,  18),   -- ACC +18
    (11631, 384,   6);   -- Haste +6


-- =========================================================
-- TIGERS
-- =========================================================

-- Stripey Steve (lv22-28) — 19997-19999
REPLACE INTO `item_basic` VALUES
    (19997, 0, 'Steve_Stripe', 'steve_stripe', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (26011, 0, 'Steve_Fangs', 'steve_fangs', 1, 59476, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (26011, "steves_tiger_fangs",       22,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (26011,  8,   6),   -- STR +6
    (26011, 23,   8),   -- ATT +8
    (26011, 25,   5);   -- ACC +5

REPLACE INTO `item_basic` VALUES
    (28615, 0, 'Steve_Mantle', 'steve_mantle', 1, 59476, 99, 0, 2200);
REPLACE INTO `item_equipment` VALUES
    (28615, "steves_pelt_mantle",       22,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28615,  1,  10),   -- DEF +10
    (28615,  8,   7),   -- STR +7
    (28615,  10,   5),   -- VIT +5
    (28615,  2,  30);   -- HP +30


-- Mauler Maurice (lv38-46) — 20000-20002
REPLACE INTO `item_basic` VALUES
    (20000, 0, 'Maurice_Hide', 'maurice_hide', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23712, 0, 'Maurice_Helm', 'maurice_helm', 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (23712, "maurices_savage_helm",     38,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23712,  1,  16),   -- DEF +16
    (23712,  8,  10),   -- STR +10
    (23712, 23,  14),   -- ATT +14
    (23712,  2,  40);   -- HP +40

REPLACE INTO `item_basic` VALUES
    (28447, 0, 'Maurice_Belt', 'maurice_belt', 1, 59476, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (28447, "maurices_mauler_belt",     38,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28447,  8,  10),   -- STR +10
    (28447, 23,  15),   -- ATT +15
    (28447,  9,   8),   -- DEX +8
    (28447, 384,   4);   -- Haste +4


-- Saber Sabrina (lv58-65) — 16464-16561
REPLACE INTO `item_basic` VALUES
    (16464, 0, 'Sbrn_Saber-Fang', 'sbrn_saberfang', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23265, 0, 'Sabrina_Legs', 'sabrina_legs', 1, 59476, 99, 0, 15000);
REPLACE INTO `item_equipment` VALUES
    (23265, "sabrinas_feral_legs",         58,  0,  4194303,    0,   0,  0, 1024,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23265,  1,  24),   -- DEF +24
    (23265,  8,  14),   -- STR +14
    (23265,  9,  12),   -- DEX +12
    (23265, 23,  18),   -- ATT +18
    (23265, 25,  15);   -- ACC +15

REPLACE INTO `item_basic` VALUES
    (11641, 0, 'Sabrina_Ring', 'sabrina_ring', 1, 59476, 99, 0, 20000);
REPLACE INTO `item_equipment` VALUES
    (11641, "sabrinas_apex_ring",           58,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (11641,  8,  14),   -- STR +14
    (11641, 23,  20),   -- ATT +20
    (11641, 25,  18),   -- ACC +18
    (11641, 384,   6);   -- Haste +6


-- =========================================================
-- MANDRAGORAS
-- =========================================================

-- Root Rita (lv6-10) — 20003-20005
REPLACE INTO `item_basic` VALUES
    (20003, 0, 'Rita_Root', 'rita_root', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (27530, 0, 'Rita_Earring', 'rita_earring', 1, 59476, 99, 0, 10479);
REPLACE INTO `item_equipment` VALUES
    (27530, "ritas_leaf_earring",        6,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (27530,  13,   3),   -- MND +3
    (27530, 14,   3),   -- CHR +3
    (27530,  5,  10);   -- MP +10

REPLACE INTO `item_basic` VALUES
    (23533, 0, 'Rita_Wrist', 'rita_wrist', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (23533, "ritas_petal_wrist",         6,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23533,  1,   3),   -- DEF +3
    (23533,  13,   4),   -- MND +4
    (23533,  5,  15);   -- MP +15


-- Sprout Spencer (lv22-28) — 20006-20008
REPLACE INTO `item_basic` VALUES
    (20006, 0, 'Spencer_Sprout', 'spencer_sprout', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23713, 0, 'Spencer_Hat', 'spencer_hat', 1, 59476, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (23713, "spencers_verdant_hat",     22,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23713,  1,   8),   -- DEF +8
    (23713,  13,   7),   -- MND +7
    (23713,  5,  30),   -- MP +30
    (23713, 14,   5);   -- CHR +5

REPLACE INTO `item_basic` VALUES
    (11632, 0, 'Spencer_Ring', 'spencer_ring', 1, 59476, 99, 0, 2200);
REPLACE INTO `item_equipment` VALUES
    (11632, "spencers_bloom_ring",      22,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (11632,  13,   7),   -- MND +7
    (11632,  12,   5),   -- INT +5
    (11632, 28,   6);   -- MATK +6


-- Mandrake Max (lv40-48) — 20009-20011
REPLACE INTO `item_basic` VALUES
    (20009, 0, 'Max_Mandrake', 'max_mandrake', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23732, 0, 'Max_Shriek_Mask', 'max_shriek_mask', 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (23732, "maxs_shriek_mask",         40,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23732,  1,  16),   -- DEF +16
    (23732,  13,  12),   -- MND +12
    (23732,  12,  10),   -- INT +10
    (23732,  5,  45),   -- MP +45
    (23732, 28,  10);   -- MATK +10

REPLACE INTO `item_basic` VALUES
    (28448, 0, 'Max_Belt', 'max_belt', 1, 59476, 99, 0, 10000);
REPLACE INTO `item_equipment` VALUES
    (28448, "maxs_earthscream_belt",    40,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28448,  13,  10),   -- MND +10
    (28448,  12,  10),   -- INT +10
    (28448, 28,  12),   -- MATK +12
    (28448, 30,  10);   -- MACC +10


-- =========================================================
-- BEETLES
-- =========================================================

-- Click Clack Clayton (lv10-15) — 20012-20014
REPLACE INTO `item_basic` VALUES
    (20012, 0, 'Clytn_Clicking', 'clytn_clicking', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23259, 0, 'Clayton_Legs', 'clayton_legs', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (23259, "claytons_chitin_legs",     10,  0,  4194303,    0,   0,  0, 1024,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23259,  1,   4),   -- DEF +4
    (23259,  10,   4),   -- VIT +4
    (23259,  2,  15);   -- HP +15

REPLACE INTO `item_basic` VALUES
    (11634, 0, 'Clayton_Ring', 'clayton_ring', 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (11634, "claytons_clack_ring",      10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (11634,  1,   3),   -- DEF +3
    (11634,  10,   4),   -- VIT +4
    (11634,  8,   3);   -- STR +3


-- Dung Douglas (lv28-34) — 20015-20017
REPLACE INTO `item_basic` VALUES
    (20015, 0, 'Douglas_Ball', 'douglas_ball', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23783, 0, 'Douglas_Boots', 'douglas_boots', 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (23783, "douglass_roller_boots",    28,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23783,  1,  12),   -- DEF +12
    (23783,  10,   8),   -- VIT +8
    (23783,  8,   6),   -- STR +6
    (23783,  2,  30);   -- HP +30

REPLACE INTO `item_basic` VALUES
    (26012, 0, 'Douglas_Neck', 'douglas_neck', 1, 59476, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (26012, "douglass_carapace_necklace",28,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (26012,  10,   8),   -- VIT +8
    (26012,  1,   8),   -- DEF +8
    (26012, 29,   6);   -- MDEF +6


-- Scarab Sebastian (lv45-52) — 20018-20020
REPLACE INTO `item_basic` VALUES
    (20018, 0, 'Sbstn_Scarab', 'sbstn_scarab', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23738, 0, 'Sebastian_Helm', 'sebastian_helm', 1, 59476, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (23738, "sebastians_sacred_helm",   45,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23738,  1,  22),   -- DEF +22
    (23738,  10,  12),   -- VIT +12
    (23738,  8,  10),   -- STR +10
    (23738,  2,  60),   -- HP +60
    (23738, 29,   8);   -- MDEF +8

REPLACE INTO `item_basic` VALUES
    (11635, 0, 'Sebastian_Ring', 'sebastian_ring', 1, 59476, 99, 0, 13000);
REPLACE INTO `item_equipment` VALUES
    (11635, "sebastians_jeweled_ring",  45,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (11635,  10,  12),   -- VIT +12
    (11635,  1,  12),   -- DEF +12
    (11635,  2,  70),   -- HP +70
    (11635, 384,   5);   -- Haste +5


-- =========================================================
-- CRAWLERS
-- =========================================================

-- Silk Simon (lv15-20) — 20021-20023
REPLACE INTO `item_basic` VALUES
    (20021, 0, 'Simon_Thread', 'simon_thread', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23534, 0, 'Simon_Gloves', 'simon_gloves', 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (23534, "simons_silk_gloves",       15,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23534,  1,   5),   -- DEF +5
    (23534,  9,   5),   -- DEX +5
    (23534, 25,   5);   -- ACC +5

REPLACE INTO `item_basic` VALUES
    (28616, 0, 'Simon_Cape', 'simon_cape', 1, 59476, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (28616, "simons_webbed_cape",       15,  0,  4194303,    0,   0,  0, 256,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28616,  1,   6),   -- DEF +6
    (28616,  11,   5),   -- AGI +5
    (28616, 68,   6);   -- EVA +6


-- Cocoon Carl (lv50-58) — 20024-20026
REPLACE INTO `item_basic` VALUES
    (20024, 0, 'Carl_Shard', 'carl_shard', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25697, 0, 'Carl_Mail', 'carl_mail', 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (25697, "carls_chrysalis_mail",     50,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (25697,  1,  25),   -- DEF +25
    (25697,  10,  12),   -- VIT +12
    (25697,  2,  70),   -- HP +70
    (25697, 29,  12),   -- MDEF +12
    (25697, 68,  10);   -- EVA +10

REPLACE INTO `item_basic` VALUES
    (14646, 0, 'Carl_Ring', 'carl_ring', 1, 59476, 99, 0, 16000);
REPLACE INTO `item_equipment` VALUES
    (14646, "carls_metamorph_ring",     50,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (14646,  2,  80),   -- HP +80
    (14646,  5,  40),   -- MP +40
    (14646,  10,  12),   -- VIT +12
    (14646, 384,   5);   -- Haste +5


-- =========================================================
-- BIRDS
-- =========================================================

-- Feather Fred (lv10-15) — 20027-20029
REPLACE INTO `item_basic` VALUES
    (20027, 0, 'Fred_Feather', 'fred_feather', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (25698, 0, 'Fred_Down_Vest', 'fred_down_vest', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (25698, "freds_down_vest",          10,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (25698,  1,   5),   -- DEF +5
    (25698,  11,   4),   -- AGI +4
    (25698, 68,   4);   -- EVA +4

REPLACE INTO `item_basic` VALUES
    (15549, 0, 'Fred_Talon_Ring', 'fred_talon_ring', 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (15549, "freds_talon_ring",         10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (15549,  11,   4),   -- AGI +4
    (15549,  9,   3),   -- DEX +3
    (15549, 25,   4);   -- ACC +4


-- Beaky Beatrice (lv28-35) — 20030-20032
REPLACE INTO `item_basic` VALUES
    (20030, 0, 'Beatrice_Tip', 'beatrice_tip', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23739, 0, 'Beatrice_Hat', 'beatrice_hat', 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (23739, "beatrices_plume_hat",      28,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23739,  1,  10),   -- DEF +10
    (23739,  11,   8),   -- AGI +8
    (23739, 68,  10),   -- EVA +10
    (23739, 14,   5);   -- CHR +5

REPLACE INTO `item_basic` VALUES
    (27531, 0, 'Btrc_Earring', 'btrc_earring', 1, 59476, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (27531, "beatrices_wind_earring",   28,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (27531,  11,   8),   -- AGI +8
    (27531, 68,  12),   -- EVA +12
    (27531, 384,   3);   -- Haste +3


-- Plume Patricia (lv50-58) — 20033-20035
REPLACE INTO `item_basic` VALUES
    (20033, 0, 'Patricia_Plume', 'patricia_plume', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25699, 0, 'Patricia_Vest', 'patricia_vest', 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (25699, "patricias_zephyr_vest",    50,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (25699,  1,  20),   -- DEF +20
    (25699,  11,  14),   -- AGI +14
    (25699, 68,  18),   -- EVA +18
    (25699, 384,   5),   -- Haste +5
    (25699, 25,  10);   -- ACC +10

REPLACE INTO `item_basic` VALUES
    (15550, 0, 'Patricia_Ring', 'patricia_ring', 1, 59476, 99, 0, 16000);
REPLACE INTO `item_equipment` VALUES
    (15550, "patricias_gale_ring",      50,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (15550,  11,  14),   -- AGI +14
    (15550, 68,  20),   -- EVA +20
    (15550, 384,   6);   -- Haste +6


-- =========================================================
-- BEES
-- =========================================================

-- Honey Harold (lv10-15) — 20036-20038
REPLACE INTO `item_basic` VALUES
    (20036, 0, 'Hrld_Honeycomb', 'hrld_honeycomb', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (27532, 0, 'Harold_Earring', 'harold_earring', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (27532, "harolds_honey_earring",    10,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (27532, 14,   5),   -- CHR +5
    (27532,  13,   3),   -- MND +3
    (27532,  2,  15);   -- HP +15

REPLACE INTO `item_basic` VALUES
    (15780, 0, 'Harold_Ring', 'harold_ring', 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (15780, "harolds_stinger_ring",     10,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (15780,  9,   4),   -- DEX +4
    (15780, 23,   4),   -- ATT +4
    (15780,  8,   3);   -- STR +3


-- Buzzard Barry (lv30-38) — 20039-20041
REPLACE INTO `item_basic` VALUES
    (20039, 0, 'Barry_Wing', 'barry_wing', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23535, 0, 'Barry_Gauntlets', 'barry_gauntlets', 1, 59476, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (23535, "barrys_venom_gauntlets",   30,  0,  4194303,    0,   0,  0,  32,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23535,  1,  12),   -- DEF +12
    (23535,  9,   8),   -- DEX +8
    (23535, 23,  10),   -- ATT +10
    (23535,  8,   6);   -- STR +6

REPLACE INTO `item_basic` VALUES
    (26013, 0, 'Barry_Necklace', 'barry_necklace', 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (26013, "barrys_swarm_necklace",    30,  0,  4194303,    0,   0,  0,   2,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (26013,  8,   8),   -- STR +8
    (26013, 23,  12),   -- ATT +12
    (26013, 25,   8);   -- ACC +8


-- Queen Quentin (lv62-70) — 20042-20044
REPLACE INTO `item_basic` VALUES
    (20042, 0, 'Quentin_Jelly', 'quentin_jelly', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23740, 0, 'Quentin_Crown', 'quentin_crown', 1, 59476, 99, 0, 18000);
REPLACE INTO `item_equipment` VALUES
    (23740, "quentins_royal_crown",     62,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23740,  1,  25),   -- DEF +25
    (23740,  2,  80),   -- HP +80
    (23740,  5,  40),   -- MP +40
    (23740, 14,  15),   -- CHR +15
    (23740,  13,  12);   -- MND +12

REPLACE INTO `item_basic` VALUES
    (15781, 0, 'Quentin_Ring', 'quentin_ring', 1, 59476, 99, 0, 22000);
REPLACE INTO `item_equipment` VALUES
    (15781, "quentins_hivemind_ring",   62,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (15781,  12,  14),   -- INT +14
    (15781,  13,  14),   -- MND +14
    (15781, 28,  18),   -- MATK +18
    (15781, 30,  15),   -- MACC +15
    (15781, 384,   6);   -- Haste +6


-- =========================================================
-- WORMS
-- =========================================================

-- Wiggles Winston (lv1-5) — 20045-20047
REPLACE INTO `item_basic` VALUES
    (20045, 0, 'Winston_Wiggle', 'winston_wiggle', 1, 59476, 99, 0, 20);

REPLACE INTO `item_basic` VALUES
    (15794, 0, 'Winston_Ring', 'winston_ring', 1, 59476, 99, 0, 150);
REPLACE INTO `item_equipment` VALUES
    (15794, "winstons_dirt_ring",        1,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (15794,  10,   2),   -- VIT +2
    (15794,  2,  10);   -- HP +10

REPLACE INTO `item_basic` VALUES
    (28449, 0, 'Winston_Belt', 'winston_belt', 1, 59476, 99, 0, 250);
REPLACE INTO `item_equipment` VALUES
    (28449, "winstons_earthen_belt",     1,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28449,  10,   3),   -- VIT +3
    (28449,  8,   2);   -- STR +2


-- Squirmy Sherman (lv18-24) — 20048-20050
REPLACE INTO `item_basic` VALUES
    (20048, 0, 'Sherman_Squirm', 'sherman_squirm', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23755, 0, 'Sherman_Helm', 'sherman_helm', 1, 59476, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (23755, "shermans_subterran_helm",  18,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23755,  1,   7),   -- DEF +7
    (23755,  10,   5),   -- VIT +5
    (23755,  2,  25),   -- HP +25
    (23755,  8,   4);   -- STR +4

REPLACE INTO `item_basic` VALUES
    (27533, 0, 'Sherman_Earring', 'sherman_earring', 1, 59476, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (27533, "shermans_tunnel_earring",  18,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (27533,  10,   6),   -- VIT +6
    (27533,  8,   5),   -- STR +5
    (27533, 23,   6);   -- ATT +6


-- Earthcrawler Ernest (lv40-48) — 16570-16574
REPLACE INTO `item_basic` VALUES
    (16570, 0, 'Ernest_Earthen', 'ernest_earthen', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25689, 0, 'Ernest_Vest', 'ernest_vest', 1, 59476, 99, 0, 8000);
REPLACE INTO `item_equipment` VALUES
    (25689, "ernests_burrower_vest",     40,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (25689,  1,  17),   -- DEF +17
    (25689,  10,  10),   -- VIT +10
    (25689,  8,   8),   -- STR +8
    (25689,  2,  55);   -- HP +55

REPLACE INTO `item_basic` VALUES
    (23750, 0, 'Ernest_Boots', 'ernest_boots', 1, 59476, 99, 0, 11000);
REPLACE INTO `item_equipment` VALUES
    (23750, "ernests_tremor_boots",      40,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23750,  1,  14),   -- DEF +14
    (23750,  10,   8),   -- VIT +8
    (23750,  2,  40),   -- HP +40
    (23750, 384,   4);   -- Haste +4


-- =========================================================
-- LIZARDS
-- =========================================================

-- Scaly Sally (lv8-12) — 16715-17084
REPLACE INTO `item_basic` VALUES
    (16715, 0, 'Sally_Chip', 'sally_chip', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (11642, 0, 'Sally_Ring', 'sally_ring', 1, 59476, 99, 0, 28624);
REPLACE INTO `item_equipment` VALUES
    (11642, "sallys_scale_ring",          8,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (11642,  9,   4),   -- DEX +4
    (11642,  11,   3),   -- AGI +3
    (11642, 68,   4);   -- EVA +4

REPLACE INTO `item_basic` VALUES
    (28440, 0, 'Sally_Belt', 'sally_belt', 1, 59476, 99, 0, 14337);
REPLACE INTO `item_equipment` VALUES
    (28440, "sallys_tail_belt",           8,  0,  4194303,    0,   0,  0, 512,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (28440,  8,   3),   -- STR +3
    (28440,  9,   3),   -- DEX +3
    (28440,  2,  10);   -- HP +10


-- Cold-blooded Carlos (lv30-36) — 17107-17168
REPLACE INTO `item_basic` VALUES
    (17107, 0, 'Carlos_Cold', 'carlos_cold', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25690, 0, 'Carlos_Vest', 'carlos_vest', 1, 59476, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (25690, "carloss_reptile_vest",       30,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (25690,  1,  13),   -- DEF +13
    (25690,  8,   7),   -- STR +7
    (25690,  10,   7),   -- VIT +7
    (25690,  2,  35);   -- HP +35

REPLACE INTO `item_basic` VALUES
    (26118, 0, 'Carlos_Earring', 'carlos_earring', 1, 59476, 99, 0, 6500);
REPLACE INTO `item_equipment` VALUES
    (26118, "carloss_venom_earring",      30,  0,  4194303,    0,   0,  0,   4,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (26118,  9,   7),   -- DEX +7
    (26118,  11,   6),   -- AGI +6
    (26118, 23,   8);   -- ATT +8


-- Basilisk Boris (lv52-60) — 17169-17752
REPLACE INTO `item_basic` VALUES
    (17169, 0, 'Boris_Basilisk', 'boris_basilisk', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25691, 0, 'Boris_Carapace', 'boris_carapace', 1, 59476, 99, 0, 13000);
REPLACE INTO `item_equipment` VALUES
    (25691, "boriss_granite_carapace",    52,  0,  4194303,    0,   0,  0,  16,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (25691,  1,  25),   -- DEF +25
    (25691,  10,  14),   -- VIT +14
    (25691,  8,  12),   -- STR +12
    (25691,  2,  70),   -- HP +70
    (25691, 29,  10);   -- MDEF +10

REPLACE INTO `item_basic` VALUES
    (11643, 0, 'Boris_Gaze_Ring', 'boris_gaze_ring', 1, 59476, 99, 0, 17000);
REPLACE INTO `item_equipment` VALUES
    (11643, "boriss_stone_gaze_ring",     52,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (11643,  8,  12),   -- STR +12
    (11643,  10,  12),   -- VIT +12
    (11643,  1,  14),   -- DEF +14
    (11643, 384,   5);   -- Haste +5


-- =========================================================
-- THE JIMS (goblin comedy duo)
-- =========================================================

-- Little Jim (lv25-32, he's enormous) — 20051-20053
REPLACE INTO `item_basic` VALUES
    (20051, 0, 'LttlJm_Trophy', 'lttljm_trophy', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23784, 0, 'LittleJim_Boots', 'littlejim_boots', 1, 59476, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (23784, "little_jims_big_boots",    25,  0,  4194303,    0,   0,  0, 2048,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23784,  1,  12),   -- DEF +12
    (23784,  8,   8),   -- STR +8
    (23784,  10,   8),   -- VIT +8
    (23784,  2,  35);   -- HP +35

REPLACE INTO `item_basic` VALUES
    (15795, 0, 'Little_Jim_Ring', 'little_jim_ring', 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (15795, "little_jims_big_ring",     25,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (15795,  8,   8),   -- STR +8
    (15795,  10,   8),   -- VIT +8
    (15795, 23,  10);   -- ATT +10


-- Big Jim (lv25-32, he's tiny) — 20054-20056
REPLACE INTO `item_basic` VALUES
    (20054, 0, 'Big_Jim_Trophy', 'big_jim_trophy', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23756, 0, 'Big_Jim_Hat', 'big_jim_hat', 1, 59476, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (23756, "big_jims_small_hat",       25,  0,  4194303,    0,   0,  0,   1,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (23756,  1,   8),   -- DEF +8
    (23756,  11,   8),   -- AGI +8
    (23756,  9,   8),   -- DEX +8
    (23756, 68,  10);   -- EVA +10

REPLACE INTO `item_basic` VALUES
    (15796, 0, 'Big_Jim_Ring', 'big_jim_ring', 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (15796, "big_jims_small_ring",      25,  0,  4194303,    0,   0,  0,  64,  0,  0,  0);
REPLACE INTO `item_mods` VALUES
    (15796,  11,   8),   -- AGI +8
    (15796,  9,   8),   -- DEX +8
    (15796, 25,  10);   -- ACC +10


-- =============================================================================
-- VERIFY  (run manually to confirm rows landed)
-- =============================================================================
-- SELECT i.itemid, i.name, e.level, e.slot, e.jobs
--   FROM item_basic i
--   LEFT JOIN item_equipment e ON i.itemid = e.itemId
--  WHERE i.itemid BETWEEN 16384 AND 30999
--  ORDER BY i.itemid;
--
-- SELECT * FROM item_mods WHERE itemId BETWEEN 16384 AND 30999 ORDER BY itemId, modId;
-- ============================================================
-- AUTO-GENERATED: 152 new named rares (IDs 336-791)
-- ============================================================

-- Wooly Winifred trophy + gear
REPLACE INTO `item_basic` VALUES (336, 0, 'Winifred_Fleece', 'winifred_fleece', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23757, 0, 'Winifred_Cap', 'winifred_cap', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23757, 'WnfrdWCap', 28, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23757, 1, 14);
REPLACE INTO `item_mods` VALUES (23757, 14, 6);
REPLACE INTO `item_mods` VALUES (23757, 2, 30);
REPLACE INTO `item_basic` VALUES (23536, 0, 'Wnfrd_Mittens', 'wnfrd_mittens', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23536, 'WnfrdWMit', 28, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23536, 1, 10);
REPLACE INTO `item_mods` VALUES (23536, 12, 4);
REPLACE INTO `item_mods` VALUES (23536, 29, 10);

-- Bouncy Beatrice trophy + gear
REPLACE INTO `item_basic` VALUES (339, 0, 'Beatrice_Foot', 'beatrice_foot', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23786, 0, 'Beatrice_Shoes', 'beatrice_shoes', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23786, 'BtrceSShoe', 22, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23786, 1, 8);
REPLACE INTO `item_mods` VALUES (23786, 23, 6);
REPLACE INTO `item_mods` VALUES (23786, 68, 12);
REPLACE INTO `item_basic` VALUES (23260, 0, 'Beatrice_Hakama', 'beatrice_hakama', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23260, 'BtrceHHkm', 22, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23260, 1, 11);
REPLACE INTO `item_mods` VALUES (23260, 13, 5);
REPLACE INTO `item_mods` VALUES (23260, 25, 8);

-- Crushing Clyde trophy + gear
REPLACE INTO `item_basic` VALUES (342, 0, 'Clyde_Shard', 'clyde_shard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23537, 0, 'Clyde_Gauntlets', 'clyde_gauntlets', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23537, 'ClydeCGnt', 32, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23537, 1, 15);
REPLACE INTO `item_mods` VALUES (23537, 14, 7);
REPLACE INTO `item_mods` VALUES (23537, 2, 40);
REPLACE INTO `item_basic` VALUES (28450, 0, 'Clyde_Belt', 'clyde_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28450, 'ClydePBlt', 32, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28450, 1, 6);
REPLACE INTO `item_mods` VALUES (28450, 12, 5);
REPLACE INTO `item_mods` VALUES (28450, 29, 12);

-- Sneaky Seraphine trophy + gear
REPLACE INTO `item_basic` VALUES (345, 0, 'Srphn_Trinket', 'srphn_trinket', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23787, 0, 'Seraphine_Boots', 'seraphine_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23787, 'SrphnSBts', 35, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23787, 1, 9);
REPLACE INTO `item_mods` VALUES (23787, 23, 7);
REPLACE INTO `item_mods` VALUES (23787, 68, 14);
REPLACE INTO `item_basic` VALUES (15798, 0, 'Seraphine_Ring', 'seraphine_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (15798, 'SrphnRRng', 35, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (15798, 13, 5);
REPLACE INTO `item_mods` VALUES (15798, 25, 10);
REPLACE INTO `item_mods` VALUES (15798, 29, 8);

-- Crackling Cordelia trophy + gear
REPLACE INTO `item_basic` VALUES (348, 0, 'Crdl_Whisker', 'crdl_whisker', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27536, 0, 'Crdl_Earring', 'crdl_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27536, 'CrdelaEar', 45, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27536, 25, 6);
REPLACE INTO `item_mods` VALUES (27536, 28, 12);
REPLACE INTO `item_mods` VALUES (27536, 30, 8);
REPLACE INTO `item_basic` VALUES (28619, 0, 'Cordelia_Mantle', 'cordelia_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28619, 'CrdelasMnt', 45, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28619, 1, 10);
REPLACE INTO `item_mods` VALUES (28619, 12, 5);
REPLACE INTO `item_mods` VALUES (28619, 29, 14);

-- Ferocious Frederica trophy + gear
REPLACE INTO `item_basic` VALUES (351, 0, 'Frederica_Fang', 'frederica_fang', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28618, 0, 'Frederica_Cloak', 'frederica_cloak', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28618, 'FrdrcaClk', 52, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28618, 1, 12);
REPLACE INTO `item_mods` VALUES (28618, 12, 7);
REPLACE INTO `item_mods` VALUES (28618, 29, 18);
REPLACE INTO `item_basic` VALUES (23261, 0, 'Frederica_Hose', 'frederica_hose', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23261, 'FrdrcaHse', 52, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23261, 1, 13);
REPLACE INTO `item_mods` VALUES (23261, 23, 6);
REPLACE INTO `item_mods` VALUES (23261, 68, 15);

-- Manic Millicent trophy + gear
REPLACE INTO `item_basic` VALUES (354, 0, 'Millicent_Petal', 'millicent_petal', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23758, 0, 'Mllcnt_Headband', 'mllcnt_headband', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23758, 'MllcntHbd', 28, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23758, 1, 9);
REPLACE INTO `item_mods` VALUES (23758, 68, 6);
REPLACE INTO `item_mods` VALUES (23758, 9, 35);
REPLACE INTO `item_basic` VALUES (23538, 0, 'Mllcnt_Gloves', 'mllcnt_gloves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23538, 'MllcntGGl', 28, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23538, 1, 7);
REPLACE INTO `item_mods` VALUES (23538, 25, 5);
REPLACE INTO `item_mods` VALUES (23538, 28, 10);

-- Brutal Brendan trophy + gear
REPLACE INTO `item_basic` VALUES (357, 0, 'Brndn_Carapace', 'brndn_carapace', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25700, 0, 'Brn_Breastplate', 'brn_breastplate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25700, 'BrndnABpl', 40, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25700, 1, 22);
REPLACE INTO `item_mods` VALUES (25700, 14, 7);
REPLACE INTO `item_mods` VALUES (25700, 2, 55);
REPLACE INTO `item_basic` VALUES (23788, 0, 'Brendan_Greaves', 'brendan_greaves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23788, 'BrndnIGrv', 40, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23788, 1, 13);
REPLACE INTO `item_mods` VALUES (23788, 12, 5);
REPLACE INTO `item_mods` VALUES (23788, 29, 12);

-- Gale Gertrude trophy + gear
REPLACE INTO `item_basic` VALUES (360, 0, 'Grt_Tailfeather', 'grt_tailfeather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28599, 0, 'Gertrude_Mantle', 'gertrude_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28599, 'GrtrdGMnt', 42, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28599, 1, 11);
REPLACE INTO `item_mods` VALUES (28599, 23, 7);
REPLACE INTO `item_mods` VALUES (28599, 68, 16);
REPLACE INTO `item_basic` VALUES (23706, 0, 'Gertrude_Shoes', 'gertrude_shoes', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23706, 'GrtrdWShs', 42, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23706, 1, 10);
REPLACE INTO `item_mods` VALUES (23706, 13, 6);
REPLACE INTO `item_mods` VALUES (23706, 25, 12);

-- Venomous Valentina trophy + gear
REPLACE INTO `item_basic` VALUES (363, 0, 'Vlntn_Stinger', 'vlntn_stinger', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23759, 0, 'Vlntn_Hairpin', 'vlntn_hairpin', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23759, 'VlntnHHpn', 36, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23759, 1, 8);
REPLACE INTO `item_mods` VALUES (23759, 25, 6);
REPLACE INTO `item_mods` VALUES (23759, 30, 10);
REPLACE INTO `item_basic` VALUES (15797, 0, 'Valentina_Ring', 'valentina_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (15797, 'VlntnVRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (15797, 25, 5);
REPLACE INTO `item_mods` VALUES (15797, 28, 12);
REPLACE INTO `item_mods` VALUES (15797, 9, 30);

-- Deep Dweller Deidre trophy + gear
REPLACE INTO `item_basic` VALUES (366, 0, 'Deidre_Earthen', 'deidre_earthen', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (24076, 0, 'Deidre_Boots', 'deidre_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (24076, 'DdrBrwBts', 44, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (24076, 1, 12);
REPLACE INTO `item_mods` VALUES (24076, 14, 6);
REPLACE INTO `item_mods` VALUES (24076, 2, 40);
REPLACE INTO `item_basic` VALUES (28451, 0, 'Deidre_Belt', 'deidre_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28451, 'DdrMdsBlt', 44, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28451, 1, 7);
REPLACE INTO `item_mods` VALUES (28451, 12, 5);
REPLACE INTO `item_mods` VALUES (28451, 29, 14);

-- Venerable Vincenzo trophy + gear
REPLACE INTO `item_basic` VALUES (369, 0, 'Vincenzo_Scale', 'vincenzo_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23252, 0, 'Vncnz_Cuisses', 'vncnz_cuisses', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23252, 'VncznSCss', 50, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23252, 1, 15);
REPLACE INTO `item_mods` VALUES (23252, 14, 7);
REPLACE INTO `item_mods` VALUES (23252, 2, 50);
REPLACE INTO `item_basic` VALUES (11665, 0, 'Vincenzo_Ring', 'vincenzo_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11665, 'VncznTRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11665, 1, 4);
REPLACE INTO `item_mods` VALUES (11665, 12, 6);
REPLACE INTO `item_mods` VALUES (11665, 29, 14);

-- Grunt Gideon trophy + gear
REPLACE INTO `item_basic` VALUES (372, 0, 'Gideon_Axe', 'gideon_axe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23511, 0, 'Gideon_Armband', 'gideon_armband', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23511, 'GdnSArmb', 10, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23511, 1, 6);
REPLACE INTO `item_mods` VALUES (23511, 12, 3);
REPLACE INTO `item_mods` VALUES (23511, 29, 6);
REPLACE INTO `item_basic` VALUES (28430, 0, 'Gideon_Belt', 'gideon_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28430, 'GdnGBlt', 10, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28430, 1, 3);
REPLACE INTO `item_mods` VALUES (28430, 14, 2);
REPLACE INTO `item_mods` VALUES (28430, 2, 15);

-- Sergeant Sven trophy + gear
REPLACE INTO `item_basic` VALUES (375, 0, 'Sven_Medal', 'sven_medal', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23418, 0, 'Sven_Helm', 'sven_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23418, 'SvnWCHlm', 22, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23418, 1, 11);
REPLACE INTO `item_mods` VALUES (23418, 12, 5);
REPLACE INTO `item_mods` VALUES (23418, 14, 4);
REPLACE INTO `item_basic` VALUES (28604, 0, 'Sven_Mantle', 'sven_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28604, 'SvnBtlMnt', 22, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28604, 1, 8);
REPLACE INTO `item_mods` VALUES (28604, 29, 10);
REPLACE INTO `item_mods` VALUES (28604, 12, 4);

-- Raging Reginald trophy + gear
REPLACE INTO `item_basic` VALUES (378, 0, 'Rgnld_Standard', 'rgnld_standard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25701, 0, 'Rgnld_Hauberk', 'rgnld_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25701, 'RgnldWHbk', 35, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25701, 1, 20);
REPLACE INTO `item_mods` VALUES (25701, 12, 7);
REPLACE INTO `item_mods` VALUES (25701, 2, 60);
REPLACE INTO `item_basic` VALUES (24077, 0, 'Rgnld_Greaves', 'rgnld_greaves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (24077, 'RgnldCGrv', 35, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (24077, 1, 12);
REPLACE INTO `item_mods` VALUES (24077, 14, 6);
REPLACE INTO `item_mods` VALUES (24077, 29, 14);

-- Overlord Ophelia trophy + gear
REPLACE INTO `item_basic` VALUES (381, 0, 'Ophelia_Crown', 'ophelia_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25702, 0, 'Ophelia_Plate', 'ophelia_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25702, 'OphlDPlt', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25702, 1, 26);
REPLACE INTO `item_mods` VALUES (25702, 12, 9);
REPLACE INTO `item_mods` VALUES (25702, 14, 8);
REPLACE INTO `item_mods` VALUES (25702, 2, 80);
REPLACE INTO `item_basic` VALUES (14631, 0, 'Ophelia_Ring', 'ophelia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14631, 'OphlCRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (14631, 12, 6);
REPLACE INTO `item_mods` VALUES (14631, 29, 16);
REPLACE INTO `item_mods` VALUES (14631, 2, 25);

-- Fledgling Fenwick trophy + gear
REPLACE INTO `item_basic` VALUES (384, 0, 'Fenwick_Talon', 'fenwick_talon', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (24075, 0, 'Fenwick_Sandals', 'fenwick_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (24075, 'FnwkISndl', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (24075, 1, 5);
REPLACE INTO `item_mods` VALUES (24075, 23, 3);
REPLACE INTO `item_mods` VALUES (24075, 68, 6);
REPLACE INTO `item_basic` VALUES (28429, 0, 'Fenwick_Sash', 'fenwick_sash', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28429, 'FnwkNSsh', 10, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28429, 1, 3);
REPLACE INTO `item_mods` VALUES (28429, 13, 2);
REPLACE INTO `item_mods` VALUES (28429, 25, 4);

-- Devout Delilah trophy + gear
REPLACE INTO `item_basic` VALUES (387, 0, 'Delilah_Beads', 'delilah_beads', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26014, 0, 'Delilah_Collar', 'delilah_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26014, 'DllhCCll', 22, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26014, 68, 5);
REPLACE INTO `item_mods` VALUES (26014, 9, 30);
REPLACE INTO `item_mods` VALUES (26014, 30, 6);
REPLACE INTO `item_basic` VALUES (27537, 0, 'Delilah_Earring', 'delilah_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27537, 'DllhSEar', 22, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27537, 25, 4);
REPLACE INTO `item_mods` VALUES (27537, 28, 8);
REPLACE INTO `item_mods` VALUES (27537, 9, 20);

-- High Priest Horatio trophy + gear
REPLACE INTO `item_basic` VALUES (390, 0, 'Horatio_Relic', 'horatio_relic', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23895, 0, 'Horatio_Mitre', 'horatio_mitre', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23895, 'HrtZMtre', 35, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23895, 1, 10);
REPLACE INTO `item_mods` VALUES (23895, 68, 7);
REPLACE INTO `item_mods` VALUES (23895, 9, 50);
REPLACE INTO `item_basic` VALUES (14641, 0, 'Horatio_Ring', 'horatio_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14641, 'HrtFthRng', 35, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (14641, 68, 5);
REPLACE INTO `item_mods` VALUES (14641, 30, 10);
REPLACE INTO `item_mods` VALUES (14641, 9, 25);

-- Divine Diomedea trophy + gear
REPLACE INTO `item_basic` VALUES (393, 0, 'Dmd_Feather', 'dmd_feather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25703, 0, 'Diomedea_Robe', 'diomedea_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25703, 'DmdaARbe', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25703, 1, 16);
REPLACE INTO `item_mods` VALUES (25703, 68, 9);
REPLACE INTO `item_mods` VALUES (25703, 9, 80);
REPLACE INTO `item_mods` VALUES (25703, 30, 10);
REPLACE INTO `item_basic` VALUES (23797, 0, 'Dmd_Headband', 'dmd_headband', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23797, 'DmdaHHbd', 50, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23797, 1, 11);
REPLACE INTO `item_mods` VALUES (23797, 25, 7);
REPLACE INTO `item_mods` VALUES (23797, 28, 14);
REPLACE INTO `item_mods` VALUES (23797, 9, 40);

-- Copper Cornelius trophy + gear
REPLACE INTO `item_basic` VALUES (396, 0, 'Cornelius_Scale', 'cornelius_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23544, 0, 'Cornelius_Shard', 'cornelius_shard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23544, 'CrnlsSShr', 10, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23544, 1, 7);
REPLACE INTO `item_mods` VALUES (23544, 14, 3);
REPLACE INTO `item_mods` VALUES (23544, 2, 20);
REPLACE INTO `item_basic` VALUES (23785, 0, 'Crnls_Anklet', 'crnls_anklet', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23785, 'CrnlsAnkl', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23785, 1, 5);
REPLACE INTO `item_mods` VALUES (23785, 12, 2);
REPLACE INTO `item_mods` VALUES (23785, 14, 2);

-- Silver Sylvester trophy + gear
REPLACE INTO `item_basic` VALUES (399, 0, 'Sylvester_Ingot', 'sylvester_ingot', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23978, 0, 'Sylvstr_Cuirass', 'sylvstr_cuirass', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23978, 'SlvstPCrs', 22, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23978, 1, 17);
REPLACE INTO `item_mods` VALUES (23978, 14, 5);
REPLACE INTO `item_mods` VALUES (23978, 2, 45);
REPLACE INTO `item_basic` VALUES (26015, 0, 'Sylvstr_Collar', 'sylvstr_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26015, 'SlvstGCll', 22, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26015, 1, 5);
REPLACE INTO `item_mods` VALUES (26015, 14, 4);
REPLACE INTO `item_mods` VALUES (26015, 29, 6);

-- Boulder Basil trophy + gear
REPLACE INTO `item_basic` VALUES (402, 0, 'Basil_Chip', 'basil_chip', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23728, 0, 'Basil_Greaves', 'basil_greaves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23728, 'BaslFGrv', 35, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23728, 1, 14);
REPLACE INTO `item_mods` VALUES (23728, 14, 7);
REPLACE INTO `item_mods` VALUES (23728, 2, 50);
REPLACE INTO `item_basic` VALUES (14639, 0, 'Basil_Ring', 'basil_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14639, 'BaslRRng', 35, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (14639, 1, 5);
REPLACE INTO `item_mods` VALUES (14639, 14, 5);
REPLACE INTO `item_mods` VALUES (14639, 29, 8);

-- Diamond Desmond trophy + gear
REPLACE INTO `item_basic` VALUES (405, 0, 'Dsmnd_Carapace', 'dsmnd_carapace', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25705, 0, 'Desmond_Hauberk', 'desmond_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25705, 'DsmndIHbk', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25705, 1, 27);
REPLACE INTO `item_mods` VALUES (25705, 14, 9);
REPLACE INTO `item_mods` VALUES (25705, 2, 90);
REPLACE INTO `item_mods` VALUES (25705, 29, 10);
REPLACE INTO `item_basic` VALUES (23896, 0, 'Desmond_Visor', 'desmond_visor', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23896, 'DsmndWVsr', 50, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23896, 1, 16);
REPLACE INTO `item_mods` VALUES (23896, 14, 7);
REPLACE INTO `item_mods` VALUES (23896, 2, 55);
REPLACE INTO `item_mods` VALUES (23896, 29, 8);

-- Flittering Fiona trophy + gear
REPLACE INTO `item_basic` VALUES (408, 0, 'Fiona_Scrap', 'fiona_scrap', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27538, 0, 'Fiona_Earring', 'fiona_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27538, 'FnaWngEar', 8, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27538, 23, 3);
REPLACE INTO `item_mods` VALUES (27538, 68, 5);
REPLACE INTO `item_mods` VALUES (27538, 13, 2);
REPLACE INTO `item_basic` VALUES (23707, 0, 'Fiona_Sandals', 'fiona_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23707, 'FnaNgtSnd', 8, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23707, 1, 4);
REPLACE INTO `item_mods` VALUES (23707, 23, 3);
REPLACE INTO `item_mods` VALUES (23707, 68, 6);

-- Echo Edgar trophy + gear
REPLACE INTO `item_basic` VALUES (411, 0, 'Edgar_Wing', 'edgar_wing', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27539, 0, 'Edgar_Earring', 'edgar_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27539, 'EdgrEEar', 18, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27539, 13, 4);
REPLACE INTO `item_mods` VALUES (27539, 25, 7);
REPLACE INTO `item_mods` VALUES (27539, 23, 4);
REPLACE INTO `item_basic` VALUES (23543, 0, 'Edgar_Mitts', 'edgar_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23543, 'EdgrShMtt', 18, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23543, 1, 8);
REPLACE INTO `item_mods` VALUES (23543, 23, 5);
REPLACE INTO `item_mods` VALUES (23543, 68, 10);

-- Vampiric Valerian trophy + gear
REPLACE INTO `item_basic` VALUES (414, 0, 'Valerian_Fang', 'valerian_fang', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23761, 0, 'Valerian_Cowl', 'valerian_cowl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23761, 'VlrnNtCwl', 32, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23761, 1, 10);
REPLACE INTO `item_mods` VALUES (23761, 23, 6);
REPLACE INTO `item_mods` VALUES (23761, 68, 12);
REPLACE INTO `item_basic` VALUES (14637, 0, 'Valerian_Ring', 'valerian_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14637, 'VlrnVRng', 32, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (14637, 23, 4);
REPLACE INTO `item_mods` VALUES (14637, 13, 5);
REPLACE INTO `item_mods` VALUES (14637, 25, 9);

-- Ancient Araminta trophy + gear
REPLACE INTO `item_basic` VALUES (417, 0, 'Araminta_Fang', 'araminta_fang', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28620, 0, 'Araminta_Mantle', 'araminta_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28620, 'ArmntDMnt', 45, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28620, 1, 11);
REPLACE INTO `item_mods` VALUES (28620, 23, 8);
REPLACE INTO `item_mods` VALUES (28620, 68, 18);
REPLACE INTO `item_basic` VALUES (23708, 0, 'Araminta_Anklet', 'araminta_anklet', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23708, 'ArmntHAnk', 45, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23708, 1, 10);
REPLACE INTO `item_mods` VALUES (23708, 23, 6);
REPLACE INTO `item_mods` VALUES (23708, 384, 4);

-- Slithering Silas trophy + gear
REPLACE INTO `item_basic` VALUES (420, 0, 'Silas_Shed', 'silas_shed', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23729, 0, 'Silas_Sandals', 'silas_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23729, 'SlsSnkSnd', 8, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23729, 1, 4);
REPLACE INTO `item_mods` VALUES (23729, 23, 3);
REPLACE INTO `item_mods` VALUES (23729, 68, 5);
REPLACE INTO `item_basic` VALUES (28438, 0, 'Silas_Coil_Sash', 'silas_coil_sash', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28438, 'SlsColSsh', 8, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28438, 1, 3);
REPLACE INTO `item_mods` VALUES (28438, 12, 2);
REPLACE INTO `item_mods` VALUES (28438, 29, 4);

-- Hypnotic Heloise trophy + gear
REPLACE INTO `item_basic` VALUES (423, 0, 'Heloise_Scale', 'heloise_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25538, 0, 'Heloise_Collar', 'heloise_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25538, 'HlseCCll', 20, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25538, 28, 5);
REPLACE INTO `item_mods` VALUES (25538, 68, 4);
REPLACE INTO `item_mods` VALUES (25538, 9, 20);
REPLACE INTO `item_basic` VALUES (27535, 0, 'Heloise_Earring', 'heloise_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27535, 'HlseLEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27535, 28, 4);
REPLACE INTO `item_mods` VALUES (27535, 25, 3);
REPLACE INTO `item_mods` VALUES (27535, 30, 7);

-- Constrictor Cressida trophy + gear
REPLACE INTO `item_basic` VALUES (426, 0, 'Cressida_Coil', 'cressida_coil', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23541, 0, 'Cressida_Gloves', 'cressida_gloves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23541, 'CrsdSqGlv', 34, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23541, 1, 11);
REPLACE INTO `item_mods` VALUES (23541, 12, 6);
REPLACE INTO `item_mods` VALUES (23541, 29, 12);
REPLACE INTO `item_basic` VALUES (28435, 0, 'Cressida_Belt', 'cressida_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28435, 'CrsdBBlt', 34, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28435, 1, 6);
REPLACE INTO `item_mods` VALUES (28435, 14, 5);
REPLACE INTO `item_mods` VALUES (28435, 2, 35);

-- Venom Duchess Viviane trophy + gear
REPLACE INTO `item_basic` VALUES (429, 0, 'Viviane_Sac', 'viviane_sac', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23415, 0, 'Viviane_Tiara', 'viviane_tiara', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23415, 'VvneTxTar', 48, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23415, 1, 12);
REPLACE INTO `item_mods` VALUES (23415, 25, 7);
REPLACE INTO `item_mods` VALUES (23415, 28, 14);
REPLACE INTO `item_mods` VALUES (23415, 30, 8);
REPLACE INTO `item_basic` VALUES (14645, 0, 'Viviane_Ring', 'viviane_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14645, 'VvneSrpRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (14645, 25, 5);
REPLACE INTO `item_mods` VALUES (14645, 30, 10);
REPLACE INTO `item_mods` VALUES (14645, 9, 30);

-- Buzzing Barnabas trophy + gear
REPLACE INTO `item_basic` VALUES (432, 0, 'Barnabas_Eye', 'barnabas_eye', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26003, 0, 'Barnabas_Brooch', 'barnabas_brooch', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26003, 'BrnbsWBrc', 10, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26003, 13, 3);
REPLACE INTO `item_mods` VALUES (26003, 25, 5);
REPLACE INTO `item_mods` VALUES (26003, 23, 2);
REPLACE INTO `item_basic` VALUES (23709, 0, 'Barnabas_Boots', 'barnabas_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23709, 'BrnbsBBts', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23709, 1, 5);
REPLACE INTO `item_mods` VALUES (23709, 23, 3);
REPLACE INTO `item_mods` VALUES (23709, 68, 7);

-- Droning Dorothea trophy + gear
REPLACE INTO `item_basic` VALUES (435, 0, 'Dorothea_Claw', 'dorothea_claw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25706, 0, 'Dorothea_Vest', 'dorothea_vest', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25706, 'DrthaCV', 25, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25706, 1, 14);
REPLACE INTO `item_mods` VALUES (25706, 14, 4);
REPLACE INTO `item_mods` VALUES (25706, 2, 40);
REPLACE INTO `item_basic` VALUES (14633, 0, 'Dorothea_Ring', 'dorothea_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14633, 'DrthaHRng', 25, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (14633, 13, 4);
REPLACE INTO `item_mods` VALUES (14633, 25, 8);
REPLACE INTO `item_mods` VALUES (14633, 29, 6);

-- Plague Bearer Percival trophy + gear
REPLACE INTO `item_basic` VALUES (438, 0, 'Percival_Gland', 'percival_gland', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23417, 0, 'Percival_Mask', 'percival_mask', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23417, 'PrcvlPMsk', 38, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23417, 1, 11);
REPLACE INTO `item_mods` VALUES (23417, 25, 5);
REPLACE INTO `item_mods` VALUES (23417, 28, 10);
REPLACE INTO `item_basic` VALUES (28617, 0, 'Percival_Mantle', 'percival_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28617, 'PrcvlBMnt', 38, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28617, 1, 9);
REPLACE INTO `item_mods` VALUES (28617, 12, 5);
REPLACE INTO `item_mods` VALUES (28617, 29, 12);

-- Swarm Queen Sophonias trophy + gear
REPLACE INTO `item_basic` VALUES (441, 0, 'Sophonias_Jelly', 'sophonias_jelly', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23416, 0, 'Sophonias_Helm', 'sophonias_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23416, 'SphnHMHlm', 52, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23416, 1, 14);
REPLACE INTO `item_mods` VALUES (23416, 25, 8);
REPLACE INTO `item_mods` VALUES (23416, 28, 16);
REPLACE INTO `item_mods` VALUES (23416, 9, 50);
REPLACE INTO `item_basic` VALUES (23264, 0, 'Sphns_Tassets', 'sphns_tassets', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23264, 'SphnDTsst', 52, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23264, 1, 15);
REPLACE INTO `item_mods` VALUES (23264, 14, 7);
REPLACE INTO `item_mods` VALUES (23264, 2, 60);
REPLACE INTO `item_mods` VALUES (23264, 1, 3);

-- Gnawing Nathaniel trophy + gear
REPLACE INTO `item_basic` VALUES (444, 0, 'Nathaniel_Bone', 'nathaniel_bone', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23542, 0, 'Nthnl_Armband', 'nthnl_armband', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23542, 'NthnlRArmb', 14, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23542, 1, 5);
REPLACE INTO `item_mods` VALUES (23542, 12, 3);
REPLACE INTO `item_mods` VALUES (23542, 29, 6);
REPLACE INTO `item_basic` VALUES (23726, 0, 'Nthnl_Sandals', 'nthnl_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23726, 'NthnlGSnd', 14, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23726, 1, 4);
REPLACE INTO `item_mods` VALUES (23726, 23, 2);
REPLACE INTO `item_mods` VALUES (23726, 68, 5);

-- Festering Francesca trophy + gear
REPLACE INTO `item_basic` VALUES (447, 0, 'Frncsc_Finger', 'frncsc_finger', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27534, 0, 'Frncsc_Earring', 'frncsc_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27534, 'FrncsBEar', 26, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27534, 25, 4);
REPLACE INTO `item_mods` VALUES (27534, 28, 8);
REPLACE INTO `item_mods` VALUES (27534, 30, 5);
REPLACE INTO `item_basic` VALUES (14635, 0, 'Francesca_Ring', 'francesca_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14635, 'FrncsRng', 26, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (14635, 25, 3);
REPLACE INTO `item_mods` VALUES (14635, 28, 7);
REPLACE INTO `item_mods` VALUES (14635, 9, 20);

-- Hunger Ravaged Hortensia trophy + gear
REPLACE INTO `item_basic` VALUES (450, 0, 'Hortensia_Bile', 'hortensia_bile', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23979, 0, 'Hortensia_Guard', 'hortensia_guard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23979, 'HrtnMwGrd', 38, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23979, 1, 18);
REPLACE INTO `item_mods` VALUES (23979, 14, 5);
REPLACE INTO `item_mods` VALUES (23979, 2, 55);
REPLACE INTO `item_basic` VALUES (23540, 0, 'Hrtns_Gauntlets', 'hrtns_gauntlets', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23540, 'HrtnGGnt', 38, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23540, 1, 12);
REPLACE INTO `item_mods` VALUES (23540, 12, 6);
REPLACE INTO `item_mods` VALUES (23540, 29, 13);

-- Carrion Cornelius trophy + gear
REPLACE INTO `item_basic` VALUES (453, 0, 'Cornelius_Crown', 'cornelius_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23980, 0, 'Crnls_Shroud', 'crnls_shroud', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23980, 'CrnlsDShr', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23980, 1, 22);
REPLACE INTO `item_mods` VALUES (23980, 25, 8);
REPLACE INTO `item_mods` VALUES (23980, 28, 16);
REPLACE INTO `item_mods` VALUES (23980, 9, 60);
REPLACE INTO `item_basic` VALUES (11640, 0, 'Cornelius_Ring', 'cornelius_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11640, 'CrnlsGRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11640, 25, 6);
REPLACE INTO `item_mods` VALUES (11640, 30, 12);
REPLACE INTO `item_mods` VALUES (11640, 28, 10);

-- Rattling Roderick trophy + gear
REPLACE INTO `item_basic` VALUES (456, 0, 'Roderick_Finger', 'roderick_finger', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26107, 0, 'Rdrck_Earring', 'rdrck_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26107, 'RdrckBEar', 12, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26107, 25, 3);
REPLACE INTO `item_mods` VALUES (26107, 28, 5);
REPLACE INTO `item_mods` VALUES (26107, 9, 10);
REPLACE INTO `item_basic` VALUES (23727, 0, 'Rdrck_Greaves', 'rdrck_greaves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23727, 'RdrckRGrv', 12, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23727, 1, 5);
REPLACE INTO `item_mods` VALUES (23727, 14, 2);
REPLACE INTO `item_mods` VALUES (23727, 2, 15);

-- Cursed Cavendish trophy + gear
REPLACE INTO `item_basic` VALUES (459, 0, 'Cavendish_Skull', 'cavendish_skull', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25537, 0, 'Cvndsh_Collar', 'cvndsh_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25537, 'CvndshHCl', 26, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25537, 25, 5);
REPLACE INTO `item_mods` VALUES (25537, 30, 8);
REPLACE INTO `item_mods` VALUES (25537, 9, 25);
REPLACE INTO `item_basic` VALUES (26105, 0, 'Cvndsh_Earring', 'cvndsh_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26105, 'CvndshEar', 26, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26105, 25, 4);
REPLACE INTO `item_mods` VALUES (26105, 28, 9);
REPLACE INTO `item_mods` VALUES (26105, 30, 6);

-- Bonewalker Benedict trophy + gear
REPLACE INTO `item_basic` VALUES (462, 0, 'Benedict_Femur', 'benedict_femur', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23736, 0, 'Benedict_Boots', 'benedict_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23736, 'BndctDBts', 38, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23736, 1, 12);
REPLACE INTO `item_mods` VALUES (23736, 25, 5);
REPLACE INTO `item_mods` VALUES (23736, 28, 10);
REPLACE INTO `item_basic` VALUES (28434, 0, 'Benedict_Belt', 'benedict_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28434, 'BndctUBlt', 38, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28434, 1, 5);
REPLACE INTO `item_mods` VALUES (28434, 14, 4);
REPLACE INTO `item_mods` VALUES (28434, 2, 30);

-- Lich Lord Leontine trophy + gear
REPLACE INTO `item_basic` VALUES (465, 0, 'Lntn_Crystal', 'lntn_crystal', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23977, 0, 'Leontine_Robe', 'leontine_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23977, 'LntNRobe', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23977, 1, 18);
REPLACE INTO `item_mods` VALUES (23977, 25, 10);
REPLACE INTO `item_mods` VALUES (23977, 28, 20);
REPLACE INTO `item_mods` VALUES (23977, 9, 80);
REPLACE INTO `item_basic` VALUES (14643, 0, 'Leontine_Ring', 'leontine_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14643, 'LntSDRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (14643, 25, 7);
REPLACE INTO `item_mods` VALUES (14643, 28, 14);
REPLACE INTO `item_mods` VALUES (14643, 30, 12);

-- Snapping Simeon trophy + gear
REPLACE INTO `item_basic` VALUES (468, 0, 'Simeon_Claw', 'simeon_claw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23510, 0, 'Smn_Wristlets', 'smn_wristlets', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23510, 'SmeonWrst', 14, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23510, 1, 6);
REPLACE INTO `item_mods` VALUES (23510, 12, 3);
REPLACE INTO `item_mods` VALUES (23510, 29, 7);
REPLACE INTO `item_basic` VALUES (26106, 0, 'Simeon_Earring', 'simeon_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26106, 'SmeonSEar', 14, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26106, 13, 3);
REPLACE INTO `item_mods` VALUES (26106, 25, 5);
REPLACE INTO `item_mods` VALUES (26106, 29, 4);

-- Venomous Vespera trophy + gear
REPLACE INTO `item_basic` VALUES (471, 0, 'Vespera_Sac', 'vespera_sac', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28598, 0, 'Vespera_Mantle', 'vespera_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28598, 'VsprTxMnt', 28, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28598, 1, 9);
REPLACE INTO `item_mods` VALUES (28598, 25, 5);
REPLACE INTO `item_mods` VALUES (28598, 28, 10);
REPLACE INTO `item_basic` VALUES (28433, 0, 'Vespera_Belt', 'vespera_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28433, 'VsprCBlt', 28, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28433, 1, 6);
REPLACE INTO `item_mods` VALUES (28433, 14, 4);
REPLACE INTO `item_mods` VALUES (28433, 2, 30);

-- Pincer Patriarch Ptolemy trophy + gear
REPLACE INTO `item_basic` VALUES (474, 0, 'Ptolemy_Pincer', 'ptolemy_pincer', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23263, 0, 'Ptolemy_Cuisses', 'ptolemy_cuisses', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23263, 'PtlmyACss', 40, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23263, 1, 16);
REPLACE INTO `item_mods` VALUES (23263, 14, 6);
REPLACE INTO `item_mods` VALUES (23263, 2, 50);
REPLACE INTO `item_basic` VALUES (15857, 0, 'Ptolemy_Ring', 'ptolemy_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (15857, 'PtlmyERng', 40, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (15857, 1, 4);
REPLACE INTO `item_mods` VALUES (15857, 14, 5);
REPLACE INTO `item_mods` VALUES (15857, 29, 7);

-- Deathstalker Dagny trophy + gear
REPLACE INTO `item_basic` VALUES (477, 0, 'Dagny_Barb', 'dagny_barb', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25682, 0, 'Dagny_Carapace', 'dagny_carapace', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25682, 'DgnyRCrp', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25682, 1, 24);
REPLACE INTO `item_mods` VALUES (25682, 12, 8);
REPLACE INTO `item_mods` VALUES (25682, 29, 18);
REPLACE INTO `item_mods` VALUES (25682, 2, 60);
REPLACE INTO `item_basic` VALUES (26116, 0, 'Dagny_Earring', 'dagny_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26116, 'DgnyFEar', 52, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26116, 12, 6);
REPLACE INTO `item_mods` VALUES (26116, 25, 14);
REPLACE INTO `item_mods` VALUES (26116, 29, 12);

-- Weaving Wendy trophy + gear
REPLACE INTO `item_basic` VALUES (480, 0, 'Wendy_Thread', 'wendy_thread', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (15856, 0, 'Wendy_Ring', 'wendy_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (15856, 'WndyWRng', 10, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (15856, 13, 3);
REPLACE INTO `item_mods` VALUES (15856, 25, 4);
REPLACE INTO `item_mods` VALUES (15856, 23, 2);
REPLACE INTO `item_basic` VALUES (23789, 0, 'Wendy_Sandals', 'wendy_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23789, 'WndySpSnd', 10, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23789, 1, 4);
REPLACE INTO `item_mods` VALUES (23789, 23, 3);
REPLACE INTO `item_mods` VALUES (23789, 68, 6);

-- Sticky Stanislava trophy + gear
REPLACE INTO `item_basic` VALUES (483, 0, 'Stanislava_Sac', 'stanislava_sac', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26002, 0, 'Stnslv_Collar', 'stnslv_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26002, 'StnslaGCl', 24, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26002, 13, 4);
REPLACE INTO `item_mods` VALUES (26002, 25, 7);
REPLACE INTO `item_mods` VALUES (26002, 23, 4);
REPLACE INTO `item_basic` VALUES (27928, 0, 'Stnslv_Mitts', 'stnslv_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27928, 'StnslasMtt', 24, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27928, 1, 8);
REPLACE INTO `item_mods` VALUES (27928, 13, 4);
REPLACE INTO `item_mods` VALUES (27928, 25, 8);

-- Ensnaring Eleanor trophy + gear
REPLACE INTO `item_basic` VALUES (486, 0, 'Elnr_Ensnaring', 'elnr_ensnaring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25683, 0, 'Eleanor_Vest', 'eleanor_vest', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25683, 'ElnrArVst', 36, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25683, 1, 17);
REPLACE INTO `item_mods` VALUES (25683, 13, 6);
REPLACE INTO `item_mods` VALUES (25683, 25, 12);
REPLACE INTO `item_basic` VALUES (28432, 0, 'Eleanor_Belt', 'eleanor_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28432, 'ElnrSWBlt', 36, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28432, 1, 5);
REPLACE INTO `item_mods` VALUES (28432, 23, 5);
REPLACE INTO `item_mods` VALUES (28432, 68, 10);

-- Great Weaver Gwendolyn trophy + gear
REPLACE INTO `item_basic` VALUES (489, 0, 'Gwendolyn_Crown', 'gwendolyn_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23435, 0, 'Gwendolyn_Tiara', 'gwendolyn_tiara', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23435, 'GwndlnSTar', 50, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23435, 1, 13);
REPLACE INTO `item_mods` VALUES (23435, 13, 8);
REPLACE INTO `item_mods` VALUES (23435, 25, 16);
REPLACE INTO `item_mods` VALUES (23435, 23, 6);
REPLACE INTO `item_basic` VALUES (28597, 0, 'Gwndlyn_Mantle', 'gwndlyn_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28597, 'GwndlnSMnt', 50, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28597, 1, 11);
REPLACE INTO `item_mods` VALUES (28597, 13, 6);
REPLACE INTO `item_mods` VALUES (28597, 25, 12);
REPLACE INTO `item_mods` VALUES (28597, 384, 3);

-- Oozing Oswald trophy + gear
REPLACE INTO `item_basic` VALUES (492, 0, 'Oswald_Sample', 'oswald_sample', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11062, 0, 'Oswald_Ring', 'oswald_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11062, 'OswldSRng', 8, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11062, 25, 2);
REPLACE INTO `item_mods` VALUES (11062, 30, 4);
REPLACE INTO `item_mods` VALUES (11062, 9, 10);
REPLACE INTO `item_basic` VALUES (28208, 0, 'Oswald_Sandals', 'oswald_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28208, 'OswldSlSnd', 8, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28208, 1, 3);
REPLACE INTO `item_mods` VALUES (28208, 23, 2);
REPLACE INTO `item_mods` VALUES (28208, 68, 4);

-- Bubbling Borghild trophy + gear
REPLACE INTO `item_basic` VALUES (495, 0, 'Borghild_Mass', 'borghild_mass', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26001, 0, 'Borghild_Collar', 'borghild_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26001, 'BrghldVCl', 20, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26001, 25, 4);
REPLACE INTO `item_mods` VALUES (26001, 28, 7);
REPLACE INTO `item_mods` VALUES (26001, 9, 20);
REPLACE INTO `item_basic` VALUES (26108, 0, 'Brghld_Earring', 'brghld_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26108, 'BrghldAEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26108, 25, 3);
REPLACE INTO `item_mods` VALUES (26108, 28, 6);
REPLACE INTO `item_mods` VALUES (26108, 30, 5);

-- Corrosive Callista trophy + gear
REPLACE INTO `item_basic` VALUES (498, 0, 'Callista_Sac', 'callista_sac', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27937, 0, 'Callista_Mitts', 'callista_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27937, 'CllstDMtt', 34, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27937, 1, 10);
REPLACE INTO `item_mods` VALUES (27937, 25, 5);
REPLACE INTO `item_mods` VALUES (27937, 28, 10);
REPLACE INTO `item_basic` VALUES (27564, 0, 'Callista_Ring', 'callista_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27564, 'CllstCRng', 34, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27564, 25, 4);
REPLACE INTO `item_mods` VALUES (27564, 30, 8);
REPLACE INTO `item_mods` VALUES (27564, 28, 7);

-- Primordial Proteus trophy + gear
REPLACE INTO `item_basic` VALUES (501, 0, 'Proteus_Ooze', 'proteus_ooze', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25680, 0, 'Proteus_Robe', 'proteus_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25680, 'PrtsaPRbe', 48, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25680, 1, 16);
REPLACE INTO `item_mods` VALUES (25680, 25, 9);
REPLACE INTO `item_mods` VALUES (25680, 28, 18);
REPLACE INTO `item_mods` VALUES (25680, 9, 70);
REPLACE INTO `item_basic` VALUES (27574, 0, 'Proteus_Ring', 'proteus_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27574, 'PrtsaShRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27574, 25, 6);
REPLACE INTO `item_mods` VALUES (27574, 28, 12);
REPLACE INTO `item_mods` VALUES (27574, 30, 10);

-- Splashing Salvatore trophy + gear
REPLACE INTO `item_basic` VALUES (504, 0, 'Salvatore_Fin', 'salvatore_fin', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26115, 0, 'Slvtr_Earring', 'slvtr_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26115, 'SlvtrGEar', 12, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26115, 12, 3);
REPLACE INTO `item_mods` VALUES (26115, 29, 5);
REPLACE INTO `item_mods` VALUES (26115, 25, 3);
REPLACE INTO `item_basic` VALUES (23661, 0, 'Salvatore_Boots', 'salvatore_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23661, 'SlvtrWBts', 12, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23661, 1, 5);
REPLACE INTO `item_mods` VALUES (23661, 23, 3);
REPLACE INTO `item_mods` VALUES (23661, 68, 6);

-- Snapping Sicily trophy + gear
REPLACE INTO `item_basic` VALUES (507, 0, 'Sicily_Mark', 'sicily_mark', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28431, 0, 'Sicily_Belt', 'sicily_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28431, 'SclllyRBlt', 24, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28431, 1, 5);
REPLACE INTO `item_mods` VALUES (28431, 12, 4);
REPLACE INTO `item_mods` VALUES (28431, 29, 8);
REPLACE INTO `item_basic` VALUES (25681, 0, 'Sicily_Mail', 'sicily_mail', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25681, 'ScllySMl', 24, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25681, 1, 15);
REPLACE INTO `item_mods` VALUES (25681, 14, 4);
REPLACE INTO `item_mods` VALUES (25681, 2, 35);

-- Torrent Tiberius trophy + gear
REPLACE INTO `item_basic` VALUES (510, 0, 'Tiberius_Scale', 'tiberius_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28609, 0, 'Tiberius_Mantle', 'tiberius_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28609, 'TbrsaCMnt', 36, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28609, 1, 9);
REPLACE INTO `item_mods` VALUES (28609, 12, 5);
REPLACE INTO `item_mods` VALUES (28609, 29, 12);
REPLACE INTO `item_basic` VALUES (28575, 0, 'Tiberius_Ring', 'tiberius_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28575, 'TbrsaRRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28575, 12, 4);
REPLACE INTO `item_mods` VALUES (28575, 29, 10);
REPLACE INTO `item_mods` VALUES (28575, 25, 6);

-- Deep King Delacroix trophy + gear
REPLACE INTO `item_basic` VALUES (513, 0, 'Delacroix_Scale', 'delacroix_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23434, 0, 'Delacroix_Helm', 'delacroix_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23434, 'DlcxMHlm', 48, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23434, 1, 14);
REPLACE INTO `item_mods` VALUES (23434, 12, 7);
REPLACE INTO `item_mods` VALUES (23434, 14, 5);
REPLACE INTO `item_mods` VALUES (23434, 2, 50);
REPLACE INTO `item_basic` VALUES (27568, 0, 'Delacroix_Ring', 'delacroix_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27568, 'DlcxAbRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27568, 12, 6);
REPLACE INTO `item_mods` VALUES (27568, 29, 14);
REPLACE INTO `item_mods` VALUES (27568, 25, 10);

-- Lumbering Loretta trophy + gear
REPLACE INTO `item_basic` VALUES (516, 0, 'Loretta_Neck', 'loretta_neck', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25545, 0, 'Lrtt_Neckguard', 'lrtt_neckguard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25545, 'LrttaPNGd', 14, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25545, 1, 4);
REPLACE INTO `item_mods` VALUES (25545, 14, 3);
REPLACE INTO `item_mods` VALUES (25545, 2, 20);
REPLACE INTO `item_basic` VALUES (23684, 0, 'Loretta_Boots', 'loretta_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23684, 'LrttaSBts', 14, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23684, 1, 6);
REPLACE INTO `item_mods` VALUES (23684, 12, 3);
REPLACE INTO `item_mods` VALUES (23684, 14, 2);

-- Thundering Thaddeus trophy + gear
REPLACE INTO `item_basic` VALUES (519, 0, 'Thaddeus_Spine', 'thaddeus_spine', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28606, 0, 'Thaddeus_Mantle', 'thaddeus_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28606, 'ThadsMnt', 28, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28606, 1, 8);
REPLACE INTO `item_mods` VALUES (28606, 12, 5);
REPLACE INTO `item_mods` VALUES (28606, 29, 10);
REPLACE INTO `item_basic` VALUES (26349, 0, 'Thaddeus_Belt', 'thaddeus_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26349, 'ThdsaTBlt', 28, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26349, 1, 6);
REPLACE INTO `item_mods` VALUES (26349, 14, 5);
REPLACE INTO `item_mods` VALUES (26349, 2, 35);

-- Crasher Crisanta trophy + gear
REPLACE INTO `item_basic` VALUES (522, 0, 'Crisanta_Spine', 'crisanta_spine', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23262, 0, 'Crsnt_Cuisses', 'crsnt_cuisses', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23262, 'CrsntaICss', 40, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23262, 1, 15);
REPLACE INTO `item_mods` VALUES (23262, 14, 7);
REPLACE INTO `item_mods` VALUES (23262, 2, 55);
REPLACE INTO `item_basic` VALUES (28550, 0, 'Crisanta_Ring', 'crisanta_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28550, 'CrsntaCRng', 40, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28550, 12, 5);
REPLACE INTO `item_mods` VALUES (28550, 29, 12);
REPLACE INTO `item_mods` VALUES (28550, 14, 4);

-- Patriarch Percival trophy + gear
REPLACE INTO `item_basic` VALUES (525, 0, 'Percival_Spine', 'percival_spine', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23983, 0, 'Percival_Plate', 'percival_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23983, 'PrcvlBPlt', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23983, 1, 26);
REPLACE INTO `item_mods` VALUES (23983, 12, 8);
REPLACE INTO `item_mods` VALUES (23983, 14, 9);
REPLACE INTO `item_mods` VALUES (23983, 2, 80);
REPLACE INTO `item_basic` VALUES (25544, 0, 'Percival_Collar', 'percival_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25544, 'PrcvlTCll', 54, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25544, 14, 7);
REPLACE INTO `item_mods` VALUES (25544, 2, 60);
REPLACE INTO `item_mods` VALUES (25544, 29, 8);

-- Clumsy Clemens trophy + gear
REPLACE INTO `item_basic` VALUES (528, 0, 'Clmns_Fragment', 'clmns_fragment', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23512, 0, 'Clmns_Armguard', 'clmns_armguard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23512, 'ClmnsBAGd', 18, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23512, 1, 8);
REPLACE INTO `item_mods` VALUES (23512, 12, 4);
REPLACE INTO `item_mods` VALUES (23512, 29, 8);
REPLACE INTO `item_basic` VALUES (10789, 0, 'Clemens_Ring', 'clemens_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10789, 'ClmnsStRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10789, 12, 3);
REPLACE INTO `item_mods` VALUES (10789, 14, 3);
REPLACE INTO `item_mods` VALUES (10789, 2, 20);

-- Booming Bartholomew trophy + gear
REPLACE INTO `item_basic` VALUES (531, 0, 'Brthlmw_Stone', 'brthlmw_stone', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23419, 0, 'Brthlmw_Helm', 'brthlmw_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23419, 'BrthlmBHlm', 30, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23419, 1, 12);
REPLACE INTO `item_mods` VALUES (23419, 12, 6);
REPLACE INTO `item_mods` VALUES (23419, 14, 5);
REPLACE INTO `item_basic` VALUES (26345, 0, 'Brthlmw_Belt', 'brthlmw_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26345, 'BrthlmSBlt', 30, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26345, 1, 7);
REPLACE INTO `item_mods` VALUES (26345, 12, 5);
REPLACE INTO `item_mods` VALUES (26345, 29, 11);

-- Crusher Conrad trophy + gear
REPLACE INTO `item_basic` VALUES (534, 0, 'Conrad_Knuckle', 'conrad_knuckle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23981, 0, 'Conrad_Hauberk', 'conrad_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23981, 'CnrdMHbk', 42, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23981, 1, 22);
REPLACE INTO `item_mods` VALUES (23981, 12, 8);
REPLACE INTO `item_mods` VALUES (23981, 14, 6);
REPLACE INTO `item_mods` VALUES (23981, 2, 65);
REPLACE INTO `item_basic` VALUES (23685, 0, 'Conrad_Boots', 'conrad_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23685, 'CnrdESBts', 42, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23685, 1, 13);
REPLACE INTO `item_mods` VALUES (23685, 12, 6);
REPLACE INTO `item_mods` VALUES (23685, 29, 14);

-- Titan Theobald trophy + gear
REPLACE INTO `item_basic` VALUES (537, 0, 'Theobald_Core', 'theobald_core', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23982, 0, 'Theobald_Plate', 'theobald_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23982, 'ThbldCPlt', 55, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23982, 1, 28);
REPLACE INTO `item_mods` VALUES (23982, 12, 10);
REPLACE INTO `item_mods` VALUES (23982, 14, 9);
REPLACE INTO `item_mods` VALUES (23982, 2, 90);
REPLACE INTO `item_basic` VALUES (28547, 0, 'Theobald_Ring', 'theobald_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28547, 'ThbldWRng', 55, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28547, 12, 8);
REPLACE INTO `item_mods` VALUES (28547, 29, 20);
REPLACE INTO `item_mods` VALUES (28547, 14, 6);

-- Mossy Mortimer trophy + gear
REPLACE INTO `item_basic` VALUES (540, 0, 'Mortimer_Bark', 'mortimer_bark', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28534, 0, 'Mortimer_Ring', 'mortimer_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28534, 'MrtmrBkRng', 12, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28534, 68, 3);
REPLACE INTO `item_mods` VALUES (28534, 9, 15);
REPLACE INTO `item_mods` VALUES (28534, 30, 4);
REPLACE INTO `item_basic` VALUES (23686, 0, 'Mrtmr_Sandals', 'mrtmr_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23686, 'MrtmrRSnd', 12, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23686, 1, 5);
REPLACE INTO `item_mods` VALUES (23686, 68, 2);
REPLACE INTO `item_mods` VALUES (23686, 9, 10);

-- Ancient Aldric trophy + gear
REPLACE INTO `item_basic` VALUES (543, 0, 'Aldrc_Heartwood', 'aldrc_heartwood', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28523, 0, 'Aldric_Earring', 'aldric_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28523, 'AldrHEar', 26, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28523, 68, 5);
REPLACE INTO `item_mods` VALUES (28523, 9, 25);
REPLACE INTO `item_mods` VALUES (28523, 30, 7);
REPLACE INTO `item_basic` VALUES (26000, 0, 'Aldric_Collar', 'aldric_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26000, 'AldrGCll', 26, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26000, 68, 4);
REPLACE INTO `item_mods` VALUES (26000, 25, 3);
REPLACE INTO `item_mods` VALUES (26000, 9, 20);

-- Elder Grove Elspeth trophy + gear
REPLACE INTO `item_basic` VALUES (546, 0, 'Elspeth_Sap', 'elspeth_sap', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28608, 0, 'Elspeth_Mantle', 'elspeth_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28608, 'ElsptGMnt', 38, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28608, 1, 10);
REPLACE INTO `item_mods` VALUES (28608, 68, 6);
REPLACE INTO `item_mods` VALUES (28608, 9, 40);
REPLACE INTO `item_basic` VALUES (28542, 0, 'Elspeth_Ring', 'elspeth_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28542, 'ElsptNRng', 38, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28542, 68, 5);
REPLACE INTO `item_mods` VALUES (28542, 30, 9);
REPLACE INTO `item_mods` VALUES (28542, 9, 30);

-- World Tree Wilhelmina trophy + gear
REPLACE INTO `item_basic` VALUES (549, 0, 'Wilhelmina_Core', 'wilhelmina_core', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25687, 0, 'Wilhelmina_Robe', 'wilhelmina_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25687, 'WhlmnaARbe', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25687, 1, 17);
REPLACE INTO `item_mods` VALUES (25687, 68, 10);
REPLACE INTO `item_mods` VALUES (25687, 9, 90);
REPLACE INTO `item_mods` VALUES (25687, 28, 16);
REPLACE INTO `item_basic` VALUES (28564, 0, 'Wilhelmina_Ring', 'wilhelmina_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28564, 'WhlmnaCRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28564, 68, 7);
REPLACE INTO `item_mods` VALUES (28564, 30, 13);
REPLACE INTO `item_mods` VALUES (28564, 9, 40);

-- Mischief Marcelino trophy + gear
REPLACE INTO `item_basic` VALUES (552, 0, 'Marcelino_Imp', 'marcelino_imp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26082, 0, 'Mrcln_Earring', 'mrcln_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26082, 'MrclnPEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26082, 23, 4);
REPLACE INTO `item_mods` VALUES (26082, 68, 7);
REPLACE INTO `item_mods` VALUES (26082, 13, 3);
REPLACE INTO `item_basic` VALUES (10786, 0, 'Marcelino_Ring', 'marcelino_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10786, 'MrclnTRng', 20, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10786, 23, 3);
REPLACE INTO `item_mods` VALUES (10786, 13, 3);
REPLACE INTO `item_mods` VALUES (10786, 25, 6);

-- Trickster Temperance trophy + gear
REPLACE INTO `item_basic` VALUES (555, 0, 'Temperance_Tail', 'temperance_tail', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23420, 0, 'Temperance_Hat', 'temperance_hat', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23420, 'TmprJHat', 32, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23420, 1, 9);
REPLACE INTO `item_mods` VALUES (23420, 23, 6);
REPLACE INTO `item_mods` VALUES (23420, 68, 12);
REPLACE INTO `item_basic` VALUES (26000, 0, 'Tmprnc_Collar', 'tmprnc_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26000, 'TmprCCll', 32, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26000, 25, 4);
REPLACE INTO `item_mods` VALUES (26000, 23, 4);
REPLACE INTO `item_mods` VALUES (26000, 30, 7);

-- Hexing Hieronymus trophy + gear
REPLACE INTO `item_basic` VALUES (558, 0, 'Hieronymus_Wand', 'hieronymus_wand', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25684, 0, 'Hieronymus_Robe', 'hieronymus_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25684, 'HrnmsSRbe', 44, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25684, 1, 15);
REPLACE INTO `item_mods` VALUES (25684, 25, 8);
REPLACE INTO `item_mods` VALUES (25684, 28, 16);
REPLACE INTO `item_mods` VALUES (25684, 9, 60);
REPLACE INTO `item_basic` VALUES (28553, 0, 'Hieronymus_Ring', 'hieronymus_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28553, 'HrnmsIRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28553, 25, 5);
REPLACE INTO `item_mods` VALUES (28553, 30, 11);
REPLACE INTO `item_mods` VALUES (28553, 28, 9);

-- Grand Trickster Gregoire trophy + gear
REPLACE INTO `item_basic` VALUES (561, 0, 'Gregoire_Staff', 'gregoire_staff', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28607, 0, 'Gregoire_Mantle', 'gregoire_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28607, 'GrgrCMnt', 54, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28607, 1, 12);
REPLACE INTO `item_mods` VALUES (28607, 25, 9);
REPLACE INTO `item_mods` VALUES (28607, 28, 18);
REPLACE INTO `item_mods` VALUES (28607, 23, 6);
REPLACE INTO `item_basic` VALUES (28579, 0, 'Gregoire_Ring', 'gregoire_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28579, 'GrgrMRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28579, 25, 7);
REPLACE INTO `item_mods` VALUES (28579, 28, 14);
REPLACE INTO `item_mods` VALUES (28579, 30, 12);

-- Tiny Tortuga trophy + gear
REPLACE INTO `item_basic` VALUES (564, 0, 'Tortuga_Stub', 'tortuga_stub', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28549, 0, 'Tortuga_Ring', 'tortuga_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28549, 'TrtgaLRng', 30, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28549, 25, 3);
REPLACE INTO `item_mods` VALUES (28549, 30, 5);
REPLACE INTO `item_mods` VALUES (28549, 9, 15);
REPLACE INTO `item_basic` VALUES (23687, 0, 'Tortuga_Boots', 'tortuga_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23687, 'TrtgaGBts', 30, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23687, 1, 8);
REPLACE INTO `item_mods` VALUES (23687, 25, 4);
REPLACE INTO `item_mods` VALUES (23687, 28, 7);

-- Shuffling Sebastiano trophy + gear
REPLACE INTO `item_basic` VALUES (567, 0, 'Sbstn_Knife', 'sbstn_knife', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26006, 0, 'Sbstn_Collar', 'sbstn_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26006, 'SbstnCCll', 40, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26006, 12, 5);
REPLACE INTO `item_mods` VALUES (26006, 29, 10);
REPLACE INTO `item_mods` VALUES (26006, 25, 7);
REPLACE INTO `item_basic` VALUES (25685, 0, 'Sbstn_Apron', 'sbstn_apron', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25685, 'SbstnGApn', 40, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25685, 1, 16);
REPLACE INTO `item_mods` VALUES (25685, 12, 6);
REPLACE INTO `item_mods` VALUES (25685, 29, 14);
REPLACE INTO `item_mods` VALUES (25685, 2, 40);

-- Grudge Bearer Giuliana trophy + gear
REPLACE INTO `item_basic` VALUES (570, 0, 'Giuliana_Grudge', 'giuliana_grudge', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28605, 0, 'Giuliana_Mantle', 'giuliana_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28605, 'GlnaRMnt', 50, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28605, 1, 12);
REPLACE INTO `item_mods` VALUES (28605, 12, 7);
REPLACE INTO `item_mods` VALUES (28605, 25, 6);
REPLACE INTO `item_mods` VALUES (28605, 29, 14);
REPLACE INTO `item_basic` VALUES (11059, 0, 'Giuliana_Ring', 'giuliana_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11059, 'GlnaKRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11059, 12, 5);
REPLACE INTO `item_mods` VALUES (11059, 25, 5);
REPLACE INTO `item_mods` VALUES (11059, 29, 10);
REPLACE INTO `item_mods` VALUES (11059, 30, 8);

-- The Last Tonberry trophy + gear
REPLACE INTO `item_basic` VALUES (573, 0, 'LstTnbr_Lantern', 'lsttnbr_lantern', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25686, 0, 'LstTnbrry_Robe', 'lsttnbrry_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25686, 'LstTnFRbe', 60, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25686, 1, 20);
REPLACE INTO `item_mods` VALUES (25686, 25, 11);
REPLACE INTO `item_mods` VALUES (25686, 28, 22);
REPLACE INTO `item_mods` VALUES (25686, 9, 90);
REPLACE INTO `item_basic` VALUES (10785, 0, 'LstTnbrry_Ring', 'lsttnbrry_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10785, 'LstTnLRng', 60, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10785, 25, 8);
REPLACE INTO `item_mods` VALUES (10785, 28, 16);
REPLACE INTO `item_mods` VALUES (10785, 30, 14);

-- Rippling Rocco trophy + gear
REPLACE INTO `item_basic` VALUES (576, 0, 'Rocco_Scale', 'rocco_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23688, 0, 'Rocco_Boots', 'rocco_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23688, 'RccoRBts', 16, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23688, 1, 6);
REPLACE INTO `item_mods` VALUES (23688, 23, 4);
REPLACE INTO `item_mods` VALUES (23688, 68, 8);
REPLACE INTO `item_basic` VALUES (26083, 0, 'Rocco_Earring', 'rocco_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26083, 'RccoAEar', 16, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26083, 13, 3);
REPLACE INTO `item_mods` VALUES (26083, 25, 5);
REPLACE INTO `item_mods` VALUES (26083, 23, 3);

-- Tidecaller Thessaly trophy + gear
REPLACE INTO `item_basic` VALUES (579, 0, 'Thessaly_Totem', 'thessaly_totem', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26005, 0, 'Thessaly_Collar', 'thessaly_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26005, 'ThslyCCll', 30, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26005, 12, 4);
REPLACE INTO `item_mods` VALUES (26005, 14, 4);
REPLACE INTO `item_mods` VALUES (26005, 2, 30);
REPLACE INTO `item_basic` VALUES (28601, 0, 'Thessaly_Mantle', 'thessaly_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28601, 'ThslyRMnt', 30, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28601, 1, 8);
REPLACE INTO `item_mods` VALUES (28601, 12, 5);
REPLACE INTO `item_mods` VALUES (28601, 29, 10);

-- Brine Baron Baldassare trophy + gear
REPLACE INTO `item_basic` VALUES (582, 0, 'Bldssr_Scale', 'bldssr_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23421, 0, 'Baldassare_Helm', 'baldassare_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23421, 'BldsrLHlm', 42, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23421, 1, 14);
REPLACE INTO `item_mods` VALUES (23421, 12, 7);
REPLACE INTO `item_mods` VALUES (23421, 14, 5);
REPLACE INTO `item_mods` VALUES (23421, 2, 45);
REPLACE INTO `item_basic` VALUES (10783, 0, 'Baldassare_Ring', 'baldassare_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10783, 'BldsrDRng', 42, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10783, 12, 5);
REPLACE INTO `item_mods` VALUES (10783, 29, 12);
REPLACE INTO `item_mods` VALUES (10783, 14, 4);

-- Deep Sovereign Desideria trophy + gear
REPLACE INTO `item_basic` VALUES (585, 0, 'Desideria_Fin', 'desideria_fin', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25688, 0, 'Desideria_Robe', 'desideria_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25688, 'DsdraARbe', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25688, 1, 20);
REPLACE INTO `item_mods` VALUES (25688, 25, 8);
REPLACE INTO `item_mods` VALUES (25688, 28, 16);
REPLACE INTO `item_mods` VALUES (25688, 9, 60);
REPLACE INTO `item_basic` VALUES (10787, 0, 'Desideria_Ring', 'desideria_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10787, 'DsdraTRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10787, 12, 6);
REPLACE INTO `item_mods` VALUES (10787, 29, 14);
REPLACE INTO `item_mods` VALUES (10787, 25, 5);

-- Prancing Persephone trophy + gear
REPLACE INTO `item_basic` VALUES (588, 0, 'Prsphn_Plume', 'prsphn_plume', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26089, 0, 'Prsphn_Earring', 'prsphn_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26089, 'PrsphnEar', 24, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26089, 23, 5);
REPLACE INTO `item_mods` VALUES (26089, 68, 9);
REPLACE INTO `item_mods` VALUES (26089, 13, 3);
REPLACE INTO `item_basic` VALUES (28217, 0, 'Prsphn_Shoes', 'prsphn_shoes', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28217, 'PrsphnGShs', 24, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28217, 1, 8);
REPLACE INTO `item_mods` VALUES (28217, 23, 5);
REPLACE INTO `item_mods` VALUES (28217, 68, 10);

-- Thunderwing Theron trophy + gear
REPLACE INTO `item_basic` VALUES (591, 0, 'Theron_Plume', 'theron_plume', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11007, 0, 'Theron_Mantle', 'theron_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11007, 'ThrnStMnt', 36, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11007, 1, 10);
REPLACE INTO `item_mods` VALUES (11007, 23, 6);
REPLACE INTO `item_mods` VALUES (11007, 12, 5);
REPLACE INTO `item_mods` VALUES (11007, 29, 10);
REPLACE INTO `item_basic` VALUES (10791, 0, 'Theron_Ring', 'theron_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10791, 'ThrnGRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10791, 23, 5);
REPLACE INTO `item_mods` VALUES (10791, 13, 4);
REPLACE INTO `item_mods` VALUES (10791, 25, 9);

-- Skydancer Sabastienne trophy + gear
REPLACE INTO `item_basic` VALUES (594, 0, 'Sbstnn_Scale', 'sbstnn_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23423, 0, 'Sbstnn_Helm', 'sbstnn_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23423, 'SbstAHlm', 46, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23423, 1, 13);
REPLACE INTO `item_mods` VALUES (23423, 23, 7);
REPLACE INTO `item_mods` VALUES (23423, 68, 14);
REPLACE INTO `item_mods` VALUES (23423, 13, 5);
REPLACE INTO `item_basic` VALUES (28436, 0, 'Sbstnn_Belt', 'sbstnn_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28436, 'SbstWBlt', 46, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28436, 1, 6);
REPLACE INTO `item_mods` VALUES (28436, 23, 6);
REPLACE INTO `item_mods` VALUES (28436, 384, 4);

-- Heavenrider Hieronyma trophy + gear
REPLACE INTO `item_basic` VALUES (597, 0, 'Hieronyma_Scale', 'hieronyma_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23984, 0, 'Hieronyma_Plate', 'hieronyma_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23984, 'HrnymCPlt', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23984, 1, 23);
REPLACE INTO `item_mods` VALUES (23984, 12, 8);
REPLACE INTO `item_mods` VALUES (23984, 23, 8);
REPLACE INTO `item_mods` VALUES (23984, 2, 70);
REPLACE INTO `item_basic` VALUES (10792, 0, 'Hieronyma_Ring', 'hieronyma_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10792, 'HrnymARng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10792, 23, 7);
REPLACE INTO `item_mods` VALUES (10792, 13, 6);
REPLACE INTO `item_mods` VALUES (10792, 25, 14);

-- Fledgling Fiorentina trophy + gear
REPLACE INTO `item_basic` VALUES (600, 0, 'Frntn_Feather', 'frntn_feather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26099, 0, 'Frntn_Earring', 'frntn_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26099, 'FrntnDEar', 18, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26099, 23, 4);
REPLACE INTO `item_mods` VALUES (26099, 68, 7);
REPLACE INTO `item_mods` VALUES (26099, 13, 3);
REPLACE INTO `item_basic` VALUES (10794, 0, 'Fiorentina_Ring', 'fiorentina_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10794, 'FrntnTRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10794, 12, 3);
REPLACE INTO `item_mods` VALUES (10794, 29, 6);
REPLACE INTO `item_mods` VALUES (10794, 25, 4);

-- Stormrider Sigismund trophy + gear
REPLACE INTO `item_basic` VALUES (603, 0, 'Sgsmnd_Feather', 'sgsmnd_feather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23424, 0, 'Sigismund_Helm', 'sigismund_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23424, 'SgsmndCHlm', 32, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23424, 1, 12);
REPLACE INTO `item_mods` VALUES (23424, 12, 5);
REPLACE INTO `item_mods` VALUES (23424, 23, 5);
REPLACE INTO `item_mods` VALUES (23424, 68, 10);
REPLACE INTO `item_basic` VALUES (11000, 0, 'Sgsmnd_Mantle', 'sgsmnd_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11000, 'SgsmndGMnt', 32, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11000, 1, 9);
REPLACE INTO `item_mods` VALUES (11000, 12, 5);
REPLACE INTO `item_mods` VALUES (11000, 29, 11);

-- Tempest Lord Tancred trophy + gear
REPLACE INTO `item_basic` VALUES (606, 0, 'Tancred_Quill', 'tancred_quill', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25704, 0, 'Tancred_Plate', 'tancred_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25704, 'TncrCyPlt', 46, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25704, 1, 22);
REPLACE INTO `item_mods` VALUES (25704, 12, 8);
REPLACE INTO `item_mods` VALUES (25704, 23, 6);
REPLACE INTO `item_mods` VALUES (25704, 2, 65);
REPLACE INTO `item_basic` VALUES (10795, 0, 'Tancred_Ring', 'tancred_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10795, 'TncrTRng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10795, 12, 6);
REPLACE INTO `item_mods` VALUES (10795, 29, 14);
REPLACE INTO `item_mods` VALUES (10795, 23, 5);

-- Ancient Roc Andromeda trophy + gear
REPLACE INTO `item_basic` VALUES (609, 0, 'Andromeda_Quill', 'andromeda_quill', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23717, 0, 'Andromeda_Plate', 'andromeda_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23717, 'AndrSSPlt', 58, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23717, 1, 27);
REPLACE INTO `item_mods` VALUES (23717, 12, 10);
REPLACE INTO `item_mods` VALUES (23717, 23, 8);
REPLACE INTO `item_mods` VALUES (23717, 2, 85);
REPLACE INTO `item_basic` VALUES (10793, 0, 'Andromeda_Ring', 'andromeda_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10793, 'AndrLRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10793, 12, 8);
REPLACE INTO `item_mods` VALUES (10793, 29, 20);
REPLACE INTO `item_mods` VALUES (10793, 23, 6);

-- Stumbling Sebastiano trophy + gear
REPLACE INTO `item_basic` VALUES (612, 0, 'Sbstn_Spine', 'sbstn_spine', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (10790, 0, 'Sebastiano_Ring', 'sebastiano_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10790, 'SbstnPRng', 22, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10790, 12, 3);
REPLACE INTO `item_mods` VALUES (10790, 29, 6);
REPLACE INTO `item_mods` VALUES (10790, 13, 2);
REPLACE INTO `item_basic` VALUES (28339, 0, 'Sbstn_Boots', 'sbstn_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28339, 'SbstnSBts', 22, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28339, 1, 6);
REPLACE INTO `item_mods` VALUES (28339, 23, 4);
REPLACE INTO `item_mods` VALUES (28339, 68, 8);

-- Pirouetting Pradinelda trophy + gear
REPLACE INTO `item_basic` VALUES (615, 0, 'Prdnld_Flower', 'prdnld_flower', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27620, 0, 'Prdnld_Mantle', 'prdnld_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27620, 'PrdnldDMnt', 34, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27620, 1, 9);
REPLACE INTO `item_mods` VALUES (27620, 14, 5);
REPLACE INTO `item_mods` VALUES (27620, 2, 35);
REPLACE INTO `item_basic` VALUES (28410, 0, 'Pradinelda_Belt', 'pradinelda_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28410, 'PrdnldSBlt', 34, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28410, 1, 6);
REPLACE INTO `item_mods` VALUES (28410, 12, 4);
REPLACE INTO `item_mods` VALUES (28410, 29, 10);

-- Spiky Serafina trophy + gear
REPLACE INTO `item_basic` VALUES (618, 0, 'Serafina_Spine', 'serafina_spine', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23425, 0, 'Serafina_Crown', 'serafina_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23425, 'SrfnaDCrn', 46, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23425, 1, 13);
REPLACE INTO `item_mods` VALUES (23425, 12, 6);
REPLACE INTO `item_mods` VALUES (23425, 14, 5);
REPLACE INTO `item_mods` VALUES (23425, 2, 40);
REPLACE INTO `item_basic` VALUES (10761, 0, 'Serafina_Ring', 'serafina_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10761, 'SrfnaORng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10761, 12, 5);
REPLACE INTO `item_mods` VALUES (10761, 14, 4);
REPLACE INTO `item_mods` VALUES (10761, 29, 12);

-- Lord of the Desert Lazaro trophy + gear
REPLACE INTO `item_basic` VALUES (621, 0, 'Lazaro_Heart', 'lazaro_heart', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27797, 0, 'Lazaro_Plate', 'lazaro_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27797, 'LzrCKPlt', 58, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27797, 1, 25);
REPLACE INTO `item_mods` VALUES (27797, 12, 9);
REPLACE INTO `item_mods` VALUES (27797, 14, 8);
REPLACE INTO `item_mods` VALUES (27797, 2, 80);
REPLACE INTO `item_basic` VALUES (10755, 0, 'Lazaro_Ring', 'lazaro_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10755, 'LzrMRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10755, 12, 7);
REPLACE INTO `item_mods` VALUES (10755, 29, 18);
REPLACE INTO `item_mods` VALUES (10755, 14, 5);

-- Lowing Lorcan trophy + gear
REPLACE INTO `item_basic` VALUES (624, 0, 'Lorcan_Chip', 'lorcan_chip', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28437, 0, 'Lorcan_Belt', 'lorcan_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28437, 'LrcnStBlt', 20, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28437, 1, 5);
REPLACE INTO `item_mods` VALUES (28437, 14, 3);
REPLACE INTO `item_mods` VALUES (28437, 2, 20);
REPLACE INTO `item_basic` VALUES (23697, 0, 'Lorcan_Boots', 'lorcan_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23697, 'LrcnHdBts', 20, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23697, 1, 6);
REPLACE INTO `item_mods` VALUES (23697, 12, 3);
REPLACE INTO `item_mods` VALUES (23697, 14, 2);

-- Thunderhoof Theokleia trophy + gear
REPLACE INTO `item_basic` VALUES (627, 0, 'Thkl_Fragment', 'thkl_fragment', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28602, 0, 'Thkl_Mantle', 'thkl_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28602, 'ThklCMnt', 34, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28602, 1, 9);
REPLACE INTO `item_mods` VALUES (28602, 12, 5);
REPLACE INTO `item_mods` VALUES (28602, 29, 11);
REPLACE INTO `item_basic` VALUES (26004, 0, 'Thkl_Collar', 'thkl_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26004, 'ThklBCll', 34, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26004, 14, 5);
REPLACE INTO `item_mods` VALUES (26004, 2, 35);
REPLACE INTO `item_mods` VALUES (26004, 29, 5);

-- Gore King Godfrey trophy + gear
REPLACE INTO `item_basic` VALUES (630, 0, 'Godfrey_Horn', 'godfrey_horn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23422, 0, 'Godfrey_Helm', 'godfrey_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23422, 'GdfrWHlm', 46, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23422, 1, 14);
REPLACE INTO `item_mods` VALUES (23422, 12, 7);
REPLACE INTO `item_mods` VALUES (23422, 14, 6);
REPLACE INTO `item_mods` VALUES (23422, 2, 50);
REPLACE INTO `item_basic` VALUES (10756, 0, 'Godfrey_Ring', 'godfrey_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10756, 'GdfrGRng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10756, 12, 5);
REPLACE INTO `item_mods` VALUES (10756, 14, 5);
REPLACE INTO `item_mods` VALUES (10756, 29, 12);

-- Primal Patricia trophy + gear
REPLACE INTO `item_basic` VALUES (633, 0, 'Patricia_Horn', 'patricia_horn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27916, 0, 'Ptrc_Hauberk', 'ptrc_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27916, 'PatTPHbk', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (27916, 1, 28);
REPLACE INTO `item_mods` VALUES (27916, 12, 9);
REPLACE INTO `item_mods` VALUES (27916, 14, 9);
REPLACE INTO `item_mods` VALUES (27916, 2, 90);
REPLACE INTO `item_basic` VALUES (10759, 0, 'Patricia_Ring', 'patricia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10759, 'PatARng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10759, 12, 7);
REPLACE INTO `item_mods` VALUES (10759, 29, 18);
REPLACE INTO `item_mods` VALUES (10759, 14, 6);

-- Sand Trap Sigrid trophy + gear
REPLACE INTO `item_basic` VALUES (636, 0, 'Sigrid_Jaw', 'sigrid_jaw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23698, 0, 'Sigrid_Sandals', 'sigrid_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23698, 'SgrdPtSnd', 18, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23698, 1, 5);
REPLACE INTO `item_mods` VALUES (23698, 23, 4);
REPLACE INTO `item_mods` VALUES (23698, 68, 8);
REPLACE INTO `item_basic` VALUES (10763, 0, 'Sigrid_Ring', 'sigrid_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10763, 'SgrdTRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10763, 13, 3);
REPLACE INTO `item_mods` VALUES (10763, 25, 5);
REPLACE INTO `item_mods` VALUES (10763, 23, 2);

-- Burrowing Bellancourt trophy + gear
REPLACE INTO `item_basic` VALUES (639, 0, 'Bllncr_Mandible', 'bllncr_mandible', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23513, 0, 'Bllncrt_Mitts', 'bllncrt_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23513, 'BlncrtCMtt', 30, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23513, 1, 9);
REPLACE INTO `item_mods` VALUES (23513, 13, 5);
REPLACE INTO `item_mods` VALUES (23513, 25, 9);
REPLACE INTO `item_basic` VALUES (26325, 0, 'Bllncrt_Belt', 'bllncrt_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26325, 'BlncrtSBlt', 30, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26325, 1, 5);
REPLACE INTO `item_mods` VALUES (26325, 23, 4);
REPLACE INTO `item_mods` VALUES (26325, 68, 9);

-- Crusher Crescentia trophy + gear
REPLACE INTO `item_basic` VALUES (642, 0, 'Crescentia_Jaw', 'crescentia_jaw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (10487, 0, 'Crscnt_Hauberk', 'crscnt_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10487, 'CrscntAHbk', 42, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10487, 1, 20);
REPLACE INTO `item_mods` VALUES (10487, 14, 6);
REPLACE INTO `item_mods` VALUES (10487, 2, 60);
REPLACE INTO `item_basic` VALUES (10758, 0, 'Crescentia_Ring', 'crescentia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10758, 'CrscntERng', 42, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10758, 1, 4);
REPLACE INTO `item_mods` VALUES (10758, 14, 5);
REPLACE INTO `item_mods` VALUES (10758, 29, 7);

-- Antlion Emperor Adalbert trophy + gear
REPLACE INTO `item_basic` VALUES (645, 0, 'Adlbrt_Mandible', 'adlbrt_mandible', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (10479, 0, 'Adlbrt_Carapace', 'adlbrt_carapace', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10479, 'AdlbrtTCrp', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10479, 1, 26);
REPLACE INTO `item_mods` VALUES (10479, 12, 8);
REPLACE INTO `item_mods` VALUES (10479, 14, 8);
REPLACE INTO `item_mods` VALUES (10479, 2, 80);
REPLACE INTO `item_basic` VALUES (10760, 0, 'Adalbert_Ring', 'adalbert_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10760, 'AdlbrtSRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10760, 12, 6);
REPLACE INTO `item_mods` VALUES (10760, 13, 5);
REPLACE INTO `item_mods` VALUES (10760, 29, 16);

-- Winged Wilhelmus trophy + gear
REPLACE INTO `item_basic` VALUES (648, 0, 'Wilhelmus_Scale', 'wilhelmus_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (10762, 0, 'Wilhelmus_Ring', 'wilhelmus_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10762, 'WhlmsWRng', 26, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10762, 12, 3);
REPLACE INTO `item_mods` VALUES (10762, 29, 7);
REPLACE INTO `item_mods` VALUES (10762, 23, 3);
REPLACE INTO `item_basic` VALUES (23699, 0, 'Wilhelmus_Boots', 'wilhelmus_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23699, 'WhlmsCBts', 26, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23699, 1, 7);
REPLACE INTO `item_mods` VALUES (23699, 23, 4);
REPLACE INTO `item_mods` VALUES (23699, 68, 9);

-- Frost Drake Frederik trophy + gear
REPLACE INTO `item_basic` VALUES (651, 0, 'Frederik_Scale', 'frederik_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23436, 0, 'Frederik_Helm', 'frederik_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23436, 'FrdrkIDHlm', 38, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23436, 1, 12);
REPLACE INTO `item_mods` VALUES (23436, 25, 5);
REPLACE INTO `item_mods` VALUES (23436, 28, 10);
REPLACE INTO `item_mods` VALUES (23436, 30, 7);
REPLACE INTO `item_basic` VALUES (28594, 0, 'Frederik_Mantle', 'frederik_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28594, 'FrdrkBMnt', 38, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28594, 1, 9);
REPLACE INTO `item_mods` VALUES (28594, 25, 6);
REPLACE INTO `item_mods` VALUES (28594, 28, 12);

-- Venomfang Valentinus trophy + gear
REPLACE INTO `item_basic` VALUES (654, 0, 'Vlntns_Gland', 'vlntns_gland', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23950, 0, 'Vlntns_Hauberk', 'vlntns_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23950, 'VlntnWHbk', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23950, 1, 22);
REPLACE INTO `item_mods` VALUES (23950, 12, 8);
REPLACE INTO `item_mods` VALUES (23950, 29, 16);
REPLACE INTO `item_mods` VALUES (23950, 2, 60);
REPLACE INTO `item_basic` VALUES (10754, 0, 'Valentinus_Ring', 'valentinus_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10754, 'VlntnFRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10754, 12, 6);
REPLACE INTO `item_mods` VALUES (10754, 29, 14);
REPLACE INTO `item_mods` VALUES (10754, 25, 10);

-- Ancient Wyrm Agrippa trophy + gear
REPLACE INTO `item_basic` VALUES (657, 0, 'Agrippa_Heart', 'agrippa_heart', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23951, 0, 'Agrippa_Plate', 'agrippa_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23951, 'AgrppADPlt', 60, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23951, 1, 28);
REPLACE INTO `item_mods` VALUES (23951, 12, 10);
REPLACE INTO `item_mods` VALUES (23951, 25, 8);
REPLACE INTO `item_mods` VALUES (23951, 2, 85);
REPLACE INTO `item_basic` VALUES (10757, 0, 'Agrippa_Ring', 'agrippa_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10757, 'AgrppDRng', 60, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10757, 12, 8);
REPLACE INTO `item_mods` VALUES (10757, 29, 20);
REPLACE INTO `item_mods` VALUES (10757, 25, 6);

-- Wind Up Wilhelmina trophy + gear
REPLACE INTO `item_basic` VALUES (660, 0, 'Wilhelmina_Gear', 'wilhelmina_gear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (10750, 0, 'Wilhelmina_Ring', 'wilhelmina_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10750, 'WhlmGRng', 20, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10750, 25, 3);
REPLACE INTO `item_mods` VALUES (10750, 30, 5);
REPLACE INTO `item_mods` VALUES (10750, 9, 15);
REPLACE INTO `item_basic` VALUES (23700, 0, 'Wlhlmn_Boots', 'wlhlmn_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23700, 'WhlmMBts', 20, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23700, 1, 6);
REPLACE INTO `item_mods` VALUES (23700, 25, 3);
REPLACE INTO `item_mods` VALUES (23700, 28, 6);

-- Clockwork Calogero trophy + gear
REPLACE INTO `item_basic` VALUES (663, 0, 'Clgr_Mainspring', 'clgr_mainspring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25419, 0, 'Calogero_Collar', 'calogero_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25419, 'ClgrACll', 32, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25419, 25, 5);
REPLACE INTO `item_mods` VALUES (25419, 30, 8);
REPLACE INTO `item_mods` VALUES (25419, 28, 8);
REPLACE INTO `item_basic` VALUES (28414, 0, 'Calogero_Belt', 'calogero_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28414, 'ClgrGBlt', 32, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28414, 1, 5);
REPLACE INTO `item_mods` VALUES (28414, 25, 4);
REPLACE INTO `item_mods` VALUES (28414, 28, 7);

-- Arcane Armature Agatha trophy + gear
REPLACE INTO `item_basic` VALUES (666, 0, 'Agatha_Core', 'agatha_core', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23952, 0, 'Agatha_Hauberk', 'agatha_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23952, 'AgtArcHbk', 44, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23952, 1, 18);
REPLACE INTO `item_mods` VALUES (23952, 25, 8);
REPLACE INTO `item_mods` VALUES (23952, 28, 16);
REPLACE INTO `item_mods` VALUES (23952, 9, 55);
REPLACE INTO `item_basic` VALUES (10753, 0, 'Agatha_Ring', 'agatha_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10753, 'AgtMysRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10753, 25, 6);
REPLACE INTO `item_mods` VALUES (10753, 28, 11);
REPLACE INTO `item_mods` VALUES (10753, 30, 9);

-- Prime Puppet Ptolemais trophy + gear
REPLACE INTO `item_basic` VALUES (669, 0, 'Ptolemais_Core', 'ptolemais_core', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23953, 0, 'Ptolemais_Body', 'ptolemais_body', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23953, 'PtlmPBdy', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23953, 1, 24);
REPLACE INTO `item_mods` VALUES (23953, 25, 10);
REPLACE INTO `item_mods` VALUES (23953, 28, 20);
REPLACE INTO `item_mods` VALUES (23953, 9, 80);
REPLACE INTO `item_basic` VALUES (10751, 0, 'Ptolemais_Ring', 'ptolemais_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10751, 'PtlmOvRng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (10751, 25, 7);
REPLACE INTO `item_mods` VALUES (10751, 28, 16);
REPLACE INTO `item_mods` VALUES (10751, 30, 13);

-- Dancing Dervish trophy + gear
REPLACE INTO `item_basic` VALUES (672, 0, 'Dervish_Blade', 'dervish_blade', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11660, 0, 'Dervish_Ring', 'dervish_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11660, 'DrvshBRng', 24, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11660, 12, 3);
REPLACE INTO `item_mods` VALUES (11660, 29, 7);
REPLACE INTO `item_mods` VALUES (11660, 13, 3);
REPLACE INTO `item_basic` VALUES (26339, 0, 'Dervish_Belt', 'dervish_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26339, 'DrvshDBlt', 24, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26339, 1, 5);
REPLACE INTO `item_mods` VALUES (26339, 12, 4);
REPLACE INTO `item_mods` VALUES (26339, 29, 8);

-- Whirling Wenceslas trophy + gear
REPLACE INTO `item_basic` VALUES (675, 0, 'Wenceslas_Edge', 'wenceslas_edge', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28521, 0, 'Wncsls_Earring', 'wncsls_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28521, 'WncslsVEar', 36, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28521, 12, 5);
REPLACE INTO `item_mods` VALUES (28521, 29, 9);
REPLACE INTO `item_mods` VALUES (28521, 25, 7);
REPLACE INTO `item_basic` VALUES (28595, 0, 'Wncsls_Mantle', 'wncsls_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28595, 'WncslsAMnt', 36, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28595, 1, 9);
REPLACE INTO `item_mods` VALUES (28595, 12, 5);
REPLACE INTO `item_mods` VALUES (28595, 29, 12);

-- Cursed Blade Corneline trophy + gear
REPLACE INTO `item_basic` VALUES (678, 0, 'Corneline_Steel', 'corneline_steel', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23954, 0, 'Crnln_Hauberk', 'crnln_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23954, 'CrnlnHHbk', 48, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23954, 1, 20);
REPLACE INTO `item_mods` VALUES (23954, 12, 8);
REPLACE INTO `item_mods` VALUES (23954, 29, 16);
REPLACE INTO `item_mods` VALUES (23954, 2, 55);
REPLACE INTO `item_basic` VALUES (11659, 0, 'Corneline_Ring', 'corneline_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11659, 'CrnlnPhRng', 48, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11659, 12, 6);
REPLACE INTO `item_mods` VALUES (11659, 29, 14);
REPLACE INTO `item_mods` VALUES (11659, 25, 4);

-- Eternal Executioner Emerick trophy + gear
REPLACE INTO `item_basic` VALUES (681, 0, 'Emerick_Edge', 'emerick_edge', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23955, 0, 'Emerick_Plate', 'emerick_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23955, 'EmrckEPlt', 58, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23955, 1, 26);
REPLACE INTO `item_mods` VALUES (23955, 12, 10);
REPLACE INTO `item_mods` VALUES (23955, 29, 20);
REPLACE INTO `item_mods` VALUES (23955, 2, 75);
REPLACE INTO `item_basic` VALUES (11657, 0, 'Emerick_Ring', 'emerick_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11657, 'EmrckDRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11657, 12, 8);
REPLACE INTO `item_mods` VALUES (11657, 29, 20);
REPLACE INTO `item_mods` VALUES (11657, 13, 6);

-- Wailing Wilhemina trophy + gear
REPLACE INTO `item_basic` VALUES (684, 0, 'Wilhemina_Wisp', 'wilhemina_wisp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26080, 0, 'Wlhmn_Earring', 'wlhmn_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26080, 'WhlmnaEar', 16, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26080, 25, 3);
REPLACE INTO `item_mods` VALUES (26080, 28, 6);
REPLACE INTO `item_mods` VALUES (26080, 30, 4);
REPLACE INTO `item_basic` VALUES (11658, 0, 'Wilhemina_Ring', 'wilhemina_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11658, 'WhlmnaSpRng', 16, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11658, 25, 3);
REPLACE INTO `item_mods` VALUES (11658, 9, 15);
REPLACE INTO `item_mods` VALUES (11658, 30, 5);

-- Shrieking Sigismonda trophy + gear
REPLACE INTO `item_basic` VALUES (687, 0, 'Sgsmnd_Remnant', 'sgsmnd_remnant', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25431, 0, 'Sgsmnd_Collar', 'sgsmnd_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25431, 'SgsmndBCll', 28, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25431, 25, 5);
REPLACE INTO `item_mods` VALUES (25431, 30, 8);
REPLACE INTO `item_mods` VALUES (25431, 9, 25);
REPLACE INTO `item_basic` VALUES (23514, 0, 'Sgsmnd_Mitts', 'sgsmnd_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23514, 'SgsmndHMtt', 28, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23514, 1, 8);
REPLACE INTO `item_mods` VALUES (23514, 25, 4);
REPLACE INTO `item_mods` VALUES (23514, 28, 8);

-- Phantom Phantasia trophy + gear
REPLACE INTO `item_basic` VALUES (690, 0, 'Phnts_Ectoplasm', 'phnts_ectoplasm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23956, 0, 'Phantasia_Robe', 'phantasia_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23956, 'PhntsaSRbe', 40, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23956, 1, 15);
REPLACE INTO `item_mods` VALUES (23956, 25, 7);
REPLACE INTO `item_mods` VALUES (23956, 28, 14);
REPLACE INTO `item_mods` VALUES (23956, 9, 55);
REPLACE INTO `item_basic` VALUES (11661, 0, 'Phantasia_Ring', 'phantasia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11661, 'PhntsaWRng', 40, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11661, 25, 5);
REPLACE INTO `item_mods` VALUES (11661, 30, 9);
REPLACE INTO `item_mods` VALUES (11661, 28, 8);

-- Eternal Mourner Euphemia trophy + gear
REPLACE INTO `item_basic` VALUES (693, 0, 'Euphemia_Tear', 'euphemia_tear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23957, 0, 'Euphemia_Robe', 'euphemia_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23957, 'EphMRobe', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23957, 1, 18);
REPLACE INTO `item_mods` VALUES (23957, 25, 9);
REPLACE INTO `item_mods` VALUES (23957, 28, 18);
REPLACE INTO `item_mods` VALUES (23957, 9, 75);
REPLACE INTO `item_basic` VALUES (11662, 0, 'Euphemia_Ring', 'euphemia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11662, 'EphLmtRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11662, 25, 7);
REPLACE INTO `item_mods` VALUES (11662, 28, 14);
REPLACE INTO `item_mods` VALUES (11662, 30, 12);

-- Blinking Bartholomea trophy + gear
REPLACE INTO `item_basic` VALUES (696, 0, 'Bartholomea_Eye', 'bartholomea_eye', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26100, 0, 'Brthlm_Earring', 'brthlm_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26100, 'BrthlmaEar', 20, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26100, 25, 4);
REPLACE INTO `item_mods` VALUES (26100, 30, 7);
REPLACE INTO `item_mods` VALUES (26100, 9, 15);
REPLACE INTO `item_basic` VALUES (11669, 0, 'Brthlm_Ring', 'brthlm_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11669, 'BrthlmaRng', 20, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11669, 25, 3);
REPLACE INTO `item_mods` VALUES (11669, 30, 5);
REPLACE INTO `item_mods` VALUES (11669, 28, 6);

-- Staring Stanislao trophy + gear
REPLACE INTO `item_basic` VALUES (699, 0, 'Stanislao_Eye', 'stanislao_eye', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25526, 0, 'Stnsl_Collar', 'stnsl_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25526, 'StnslaWCll', 32, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25526, 25, 5);
REPLACE INTO `item_mods` VALUES (25526, 30, 9);
REPLACE INTO `item_mods` VALUES (25526, 9, 25);
REPLACE INTO `item_basic` VALUES (23526, 0, 'Stanislao_Mitts', 'stanislao_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23526, 'StnslaAMtt', 32, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23526, 1, 9);
REPLACE INTO `item_mods` VALUES (23526, 25, 5);
REPLACE INTO `item_mods` VALUES (23526, 28, 9);

-- Paralytic Paracelsina trophy + gear
REPLACE INTO `item_basic` VALUES (702, 0, 'Prclsn_Gaze', 'prclsn_gaze', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23760, 0, 'Prclsn_Visor', 'prclsn_visor', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23760, 'PrclsSVsr', 44, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23760, 1, 12);
REPLACE INTO `item_mods` VALUES (23760, 25, 7);
REPLACE INTO `item_mods` VALUES (23760, 30, 12);
REPLACE INTO `item_mods` VALUES (23760, 28, 10);
REPLACE INTO `item_basic` VALUES (11674, 0, 'Prclsn_Ring', 'prclsn_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11674, 'PrclsPRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11674, 25, 5);
REPLACE INTO `item_mods` VALUES (11674, 30, 10);
REPLACE INTO `item_mods` VALUES (11674, 9, 30);

-- All Seeing Arbogast trophy + gear
REPLACE INTO `item_basic` VALUES (705, 0, 'Arbogast_Eye', 'arbogast_eye', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23958, 0, 'Arbogast_Robe', 'arbogast_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23958, 'ArbgstSRbe', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23958, 1, 17);
REPLACE INTO `item_mods` VALUES (23958, 25, 10);
REPLACE INTO `item_mods` VALUES (23958, 28, 20);
REPLACE INTO `item_mods` VALUES (23958, 30, 14);
REPLACE INTO `item_basic` VALUES (11656, 0, 'Arbogast_Ring', 'arbogast_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11656, 'ArbgstORng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11656, 25, 8);
REPLACE INTO `item_mods` VALUES (11656, 28, 16);
REPLACE INTO `item_mods` VALUES (11656, 30, 14);

-- Scavenging Svetlana trophy + gear
REPLACE INTO `item_basic` VALUES (708, 0, 'Svetlana_Talon', 'svetlana_talon', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26101, 0, 'Svtln_Earring', 'svtln_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26101, 'SvtlnBEar', 16, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26101, 23, 3);
REPLACE INTO `item_mods` VALUES (26101, 68, 6);
REPLACE INTO `item_mods` VALUES (26101, 13, 2);
REPLACE INTO `item_basic` VALUES (23701, 0, 'Svetlana_Boots', 'svetlana_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23701, 'SvtlnSBts', 16, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23701, 1, 5);
REPLACE INTO `item_mods` VALUES (23701, 23, 3);
REPLACE INTO `item_mods` VALUES (23701, 68, 7);

-- Carrion Circling Casimira trophy + gear
REPLACE INTO `item_basic` VALUES (711, 0, 'Csmr_Feather', 'csmr_feather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28596, 0, 'Casimira_Mantle', 'casimira_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28596, 'CsmraDGMnt', 28, 0, 4194303, 0, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28596, 1, 8);
REPLACE INTO `item_mods` VALUES (28596, 23, 5);
REPLACE INTO `item_mods` VALUES (28596, 68, 11);
REPLACE INTO `item_basic` VALUES (11663, 0, 'Casimira_Ring', 'casimira_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11663, 'CsmraGRng', 28, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11663, 23, 4);
REPLACE INTO `item_mods` VALUES (11663, 13, 3);
REPLACE INTO `item_mods` VALUES (11663, 25, 7);

-- Bone Picker Bonaventura trophy + gear
REPLACE INTO `item_basic` VALUES (714, 0, 'Bnvntr_Beak', 'bnvntr_beak', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23393, 0, 'Bnvntr_Helm', 'bnvntr_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23393, 'BnvntGHlm', 40, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23393, 1, 12);
REPLACE INTO `item_mods` VALUES (23393, 23, 6);
REPLACE INTO `item_mods` VALUES (23393, 13, 5);
REPLACE INTO `item_mods` VALUES (23393, 68, 12);
REPLACE INTO `item_basic` VALUES (28467, 0, 'Bnvntr_Belt', 'bnvntr_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28467, 'BnvntCBlt', 40, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28467, 1, 5);
REPLACE INTO `item_mods` VALUES (28467, 12, 4);
REPLACE INTO `item_mods` VALUES (28467, 29, 10);

-- Sky Sovereign Seraphinus trophy + gear
REPLACE INTO `item_basic` VALUES (717, 0, 'Srphns_Feather', 'srphns_feather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23959, 0, 'Srphns_Plate', 'srphns_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23959, 'SrphnusSKPlt', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23959, 1, 23);
REPLACE INTO `item_mods` VALUES (23959, 12, 8);
REPLACE INTO `item_mods` VALUES (23959, 23, 7);
REPLACE INTO `item_mods` VALUES (23959, 2, 65);
REPLACE INTO `item_basic` VALUES (11651, 0, 'Seraphinus_Ring', 'seraphinus_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11651, 'SrphnusDRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11651, 12, 6);
REPLACE INTO `item_mods` VALUES (11651, 29, 14);
REPLACE INTO `item_mods` VALUES (11651, 23, 5);

-- Chittering Chichester trophy + gear
REPLACE INTO `item_basic` VALUES (720, 0, 'Chchstr_Pebble', 'chchstr_pebble', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11670, 0, 'Chichester_Ring', 'chichester_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11670, 'ChchtrCRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11670, 13, 3);
REPLACE INTO `item_mods` VALUES (11670, 25, 5);
REPLACE INTO `item_mods` VALUES (11670, 23, 3);
REPLACE INTO `item_basic` VALUES (23702, 0, 'Chchstr_Boots', 'chchstr_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23702, 'ChchtrNBts', 18, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23702, 1, 6);
REPLACE INTO `item_mods` VALUES (23702, 23, 4);
REPLACE INTO `item_mods` VALUES (23702, 68, 8);

-- Thieving Theodolinda trophy + gear
REPLACE INTO `item_basic` VALUES (723, 0, 'Theodolinda_Gem', 'theodolinda_gem', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23515, 0, 'Thdlnd_Mitts', 'thdlnd_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23515, 'ThdlndPMtt', 30, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23515, 1, 9);
REPLACE INTO `item_mods` VALUES (23515, 13, 5);
REPLACE INTO `item_mods` VALUES (23515, 25, 10);
REPLACE INTO `item_basic` VALUES (26102, 0, 'Thdlnd_Earring', 'thdlnd_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26102, 'ThdlndSEar', 30, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26102, 23, 4);
REPLACE INTO `item_mods` VALUES (26102, 13, 4);
REPLACE INTO `item_mods` VALUES (26102, 384, 3);

-- Banana Baron Balthazar trophy + gear
REPLACE INTO `item_basic` VALUES (726, 0, 'Blthzr_Banana', 'blthzr_banana', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23411, 0, 'Balthazar_Crown', 'balthazar_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23411, 'BlthzrJCrn', 42, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23411, 1, 12);
REPLACE INTO `item_mods` VALUES (23411, 23, 6);
REPLACE INTO `item_mods` VALUES (23411, 13, 5);
REPLACE INTO `item_mods` VALUES (23411, 68, 11);
REPLACE INTO `item_basic` VALUES (28426, 0, 'Balthazar_Belt', 'balthazar_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28426, 'BlthzrTBlt', 42, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28426, 1, 5);
REPLACE INTO `item_mods` VALUES (28426, 23, 5);
REPLACE INTO `item_mods` VALUES (28426, 384, 4);

-- Primate Prince Pelagius trophy + gear
REPLACE INTO `item_basic` VALUES (729, 0, 'Plgs_Insignia', 'plgs_insignia', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23960, 0, 'Pelagius_Robe', 'pelagius_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23960, 'PlgsJKRbe', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23960, 1, 19);
REPLACE INTO `item_mods` VALUES (23960, 23, 8);
REPLACE INTO `item_mods` VALUES (23960, 13, 7);
REPLACE INTO `item_mods` VALUES (23960, 2, 60);
REPLACE INTO `item_basic` VALUES (11672, 0, 'Pelagius_Ring', 'pelagius_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11672, 'PlgsAlpRng', 54, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11672, 23, 6);
REPLACE INTO `item_mods` VALUES (11672, 13, 5);
REPLACE INTO `item_mods` VALUES (11672, 25, 13);
REPLACE INTO `item_mods` VALUES (11672, 384, 3);

-- Gnashing Guildenstern trophy + gear
REPLACE INTO `item_basic` VALUES (732, 0, 'Gldnstrn_Claw', 'gldnstrn_claw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23516, 0, 'Gldnstr_Bracers', 'gldnstr_bracers', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23516, 'GldnstrnBrc', 22, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23516, 1, 8);
REPLACE INTO `item_mods` VALUES (23516, 12, 4);
REPLACE INTO `item_mods` VALUES (23516, 29, 8);
REPLACE INTO `item_basic` VALUES (28427, 0, 'Gldnstrn_Belt', 'gldnstrn_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28427, 'GldnstrnHBlt', 22, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28427, 1, 5);
REPLACE INTO `item_mods` VALUES (28427, 14, 3);
REPLACE INTO `item_mods` VALUES (28427, 2, 20);

-- Pack Lord Petronio trophy + gear
REPLACE INTO `item_basic` VALUES (735, 0, 'Petronio_Mark', 'petronio_mark', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23412, 0, 'Petronio_Helm', 'petronio_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23412, 'PtrnoPHlm', 34, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23412, 1, 12);
REPLACE INTO `item_mods` VALUES (23412, 12, 6);
REPLACE INTO `item_mods` VALUES (23412, 14, 4);
REPLACE INTO `item_mods` VALUES (23412, 2, 35);
REPLACE INTO `item_basic` VALUES (11671, 0, 'Petronio_Ring', 'petronio_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11671, 'PtrnoDRng', 34, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11671, 12, 4);
REPLACE INTO `item_mods` VALUES (11671, 29, 10);
REPLACE INTO `item_mods` VALUES (11671, 14, 3);

-- Mauling Malaclypse trophy + gear
REPLACE INTO `item_basic` VALUES (738, 0, 'Malaclypse_Fang', 'malaclypse_fang', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23961, 0, 'Mlclyps_Hauberk', 'mlclyps_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23961, 'MlclpsSHbk', 44, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23961, 1, 21);
REPLACE INTO `item_mods` VALUES (23961, 12, 7);
REPLACE INTO `item_mods` VALUES (23961, 14, 6);
REPLACE INTO `item_mods` VALUES (23961, 2, 60);
REPLACE INTO `item_basic` VALUES (11668, 0, 'Malaclypse_Ring', 'malaclypse_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11668, 'MlclpsPRng', 44, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11668, 12, 5);
REPLACE INTO `item_mods` VALUES (11668, 29, 12);
REPLACE INTO `item_mods` VALUES (11668, 14, 4);

-- Alpha Apollinarius trophy + gear
REPLACE INTO `item_basic` VALUES (741, 0, 'Apllnrs_Fang', 'apllnrs_fang', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23969, 0, 'Apllnrs_Plate', 'apllnrs_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23969, 'ApllnrsAPlt', 54, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23969, 1, 26);
REPLACE INTO `item_mods` VALUES (23969, 12, 9);
REPLACE INTO `item_mods` VALUES (23969, 14, 8);
REPLACE INTO `item_mods` VALUES (23969, 2, 80);
REPLACE INTO `item_basic` VALUES (23413, 0, 'Apllnrs_Crown', 'apllnrs_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23413, 'ApllnrsPCrn', 54, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23413, 1, 15);
REPLACE INTO `item_mods` VALUES (23413, 12, 7);
REPLACE INTO `item_mods` VALUES (23413, 14, 6);
REPLACE INTO `item_mods` VALUES (23413, 2, 50);

-- Tiny Tortoise Tibalt trophy + gear
REPLACE INTO `item_basic` VALUES (744, 0, 'Tibalt_Chip', 'tibalt_chip', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11667, 0, 'Tibalt_Ring', 'tibalt_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11667, 'TbltShRng', 26, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11667, 1, 4);
REPLACE INTO `item_mods` VALUES (11667, 14, 3);
REPLACE INTO `item_mods` VALUES (11667, 29, 5);
REPLACE INTO `item_basic` VALUES (23703, 0, 'Tibalt_Sandals', 'tibalt_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23703, 'TbltPSnd', 26, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23703, 1, 8);
REPLACE INTO `item_mods` VALUES (23703, 14, 3);
REPLACE INTO `item_mods` VALUES (23703, 2, 25);

-- Armored Archibald trophy + gear
REPLACE INTO `item_basic` VALUES (747, 0, 'Archibald_Shell', 'archibald_shell', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25527, 0, 'Archbld_Collar', 'archbld_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25527, 'ArchbldFCl', 40, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25527, 1, 6);
REPLACE INTO `item_mods` VALUES (25527, 14, 6);
REPLACE INTO `item_mods` VALUES (25527, 2, 40);
REPLACE INTO `item_mods` VALUES (25527, 29, 6);
REPLACE INTO `item_basic` VALUES (23704, 0, 'Archibald_Boots', 'archibald_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23704, 'ArchbldRBts', 40, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23704, 1, 13);
REPLACE INTO `item_mods` VALUES (23704, 14, 5);
REPLACE INTO `item_mods` VALUES (23704, 2, 40);

-- Elder Shell Eleanor trophy + gear
REPLACE INTO `item_basic` VALUES (750, 0, 'Eleanor_Shell', 'eleanor_shell', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23970, 0, 'Elnr_Carapace', 'elnr_carapace', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23970, 'ElnrACrp', 52, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23970, 1, 26);
REPLACE INTO `item_mods` VALUES (23970, 14, 9);
REPLACE INTO `item_mods` VALUES (23970, 2, 80);
REPLACE INTO `item_mods` VALUES (23970, 29, 10);
REPLACE INTO `item_basic` VALUES (11647, 0, 'Eleanor_Ring', 'eleanor_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11647, 'ElnrStnRng', 52, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11647, 14, 6);
REPLACE INTO `item_mods` VALUES (11647, 2, 50);
REPLACE INTO `item_mods` VALUES (11647, 29, 8);

-- Adamantoise Emperor Alexandros trophy + gear
REPLACE INTO `item_basic` VALUES (753, 0, 'Alxndrs_Shell', 'alxndrs_shell', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23971, 0, 'Alxndr_Fortress', 'alxndr_fortress', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23971, 'AlxndrsTF', 60, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23971, 1, 32);
REPLACE INTO `item_mods` VALUES (23971, 14, 11);
REPLACE INTO `item_mods` VALUES (23971, 2, 110);
REPLACE INTO `item_mods` VALUES (23971, 29, 12);
REPLACE INTO `item_basic` VALUES (11648, 0, 'Alexandros_Ring', 'alexandros_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11648, 'AlxndrsBRng', 60, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11648, 14, 8);
REPLACE INTO `item_mods` VALUES (11648, 2, 65);
REPLACE INTO `item_mods` VALUES (11648, 29, 10);

-- Coiling Callirhoe trophy + gear
REPLACE INTO `item_basic` VALUES (756, 0, 'Callirhoe_Ring', 'callirhoe_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26103, 0, 'Cllrh_Earring', 'cllrh_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26103, 'CllrhoeEar', 22, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26103, 28, 4);
REPLACE INTO `item_mods` VALUES (26103, 25, 3);
REPLACE INTO `item_mods` VALUES (26103, 30, 6);
REPLACE INTO `item_basic` VALUES (28428, 0, 'Callirhoe_Sash', 'callirhoe_sash', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28428, 'CllrhoeSsh', 22, 0, 4194303, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (28428, 1, 5);
REPLACE INTO `item_mods` VALUES (28428, 28, 3);
REPLACE INTO `item_mods` VALUES (28428, 9, 20);

-- Charming Chrysanthema trophy + gear
REPLACE INTO `item_basic` VALUES (759, 0, 'Chrysnthm_Bead', 'chrysnthm_bead', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25531, 0, 'Chrysnth_Collar', 'chrysnth_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25531, 'ChrsnthmCCl', 34, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25531, 28, 6);
REPLACE INTO `item_mods` VALUES (25531, 68, 5);
REPLACE INTO `item_mods` VALUES (25531, 9, 30);
REPLACE INTO `item_basic` VALUES (11649, 0, 'Chrysnthm_Ring', 'chrysnthm_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11649, 'ChrsnthmLRng', 34, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11649, 28, 5);
REPLACE INTO `item_mods` VALUES (11649, 25, 4);
REPLACE INTO `item_mods` VALUES (11649, 30, 8);

-- Seductive Seraphimia trophy + gear
REPLACE INTO `item_basic` VALUES (762, 0, 'Srphm_Scale', 'srphm_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23972, 0, 'Seraphimia_Robe', 'seraphimia_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23972, 'SrphmSRbe', 46, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23972, 1, 16);
REPLACE INTO `item_mods` VALUES (23972, 28, 8);
REPLACE INTO `item_mods` VALUES (23972, 25, 6);
REPLACE INTO `item_mods` VALUES (23972, 9, 65);
REPLACE INTO `item_basic` VALUES (11650, 0, 'Seraphimia_Ring', 'seraphimia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11650, 'SrphmTmpRng', 46, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11650, 28, 6);
REPLACE INTO `item_mods` VALUES (11650, 25, 5);
REPLACE INTO `item_mods` VALUES (11650, 30, 10);

-- Serpent Queen Sophronia trophy + gear
REPLACE INTO `item_basic` VALUES (765, 0, 'Sophronia_Scale', 'sophronia_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23414, 0, 'Sophronia_Tiara', 'sophronia_tiara', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23414, 'SphrnaSTar', 58, 0, 4194303, 0, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23414, 1, 15);
REPLACE INTO `item_mods` VALUES (23414, 28, 9);
REPLACE INTO `item_mods` VALUES (23414, 25, 7);
REPLACE INTO `item_mods` VALUES (23414, 9, 55);
REPLACE INTO `item_basic` VALUES (11646, 0, 'Sophronia_Ring', 'sophronia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11646, 'SphrnaSOvRng', 58, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11646, 28, 7);
REPLACE INTO `item_mods` VALUES (11646, 25, 6);
REPLACE INTO `item_mods` VALUES (11646, 30, 13);

-- Bloodsucking Barnard trophy + gear
REPLACE INTO `item_basic` VALUES (768, 0, 'Brnrd_Bloodsack', 'brnrd_bloodsack', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26104, 0, 'Barnard_Earring', 'barnard_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26104, 'BrndCEar', 12, 0, 4194303, 0, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (26104, 14, 3);
REPLACE INTO `item_mods` VALUES (26104, 2, 15);
REPLACE INTO `item_mods` VALUES (26104, 29, 3);
REPLACE INTO `item_basic` VALUES (15858, 0, 'Barnard_Ring', 'barnard_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (15858, 'BrndDrRng', 12, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (15858, 25, 2);
REPLACE INTO `item_mods` VALUES (15858, 30, 4);
REPLACE INTO `item_mods` VALUES (15858, 9, 10);

-- Gorging Griselda trophy + gear
REPLACE INTO `item_basic` VALUES (771, 0, 'Griselda_Sac', 'griselda_sac', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25532, 0, 'Griselda_Collar', 'griselda_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25532, 'GrsldaBCll', 24, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25532, 14, 4);
REPLACE INTO `item_mods` VALUES (25532, 2, 25);
REPLACE INTO `item_mods` VALUES (25532, 29, 5);
REPLACE INTO `item_basic` VALUES (23520, 0, 'Griselda_Mitts', 'griselda_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23520, 'GrsldaGMtt', 24, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23520, 1, 8);
REPLACE INTO `item_mods` VALUES (23520, 14, 4);
REPLACE INTO `item_mods` VALUES (23520, 2, 30);

-- Plasma Draining Placida trophy + gear
REPLACE INTO `item_basic` VALUES (774, 0, 'Placida_Flask', 'placida_flask', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23973, 0, 'Placida_Hauberk', 'placida_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23973, 'PlcdaMHbk', 36, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23973, 1, 17);
REPLACE INTO `item_mods` VALUES (23973, 14, 6);
REPLACE INTO `item_mods` VALUES (23973, 2, 55);
REPLACE INTO `item_mods` VALUES (23973, 29, 6);
REPLACE INTO `item_basic` VALUES (11637, 0, 'Placida_Ring', 'placida_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11637, 'PlcdaSpRng', 36, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11637, 14, 4);
REPLACE INTO `item_mods` VALUES (11637, 2, 30);
REPLACE INTO `item_mods` VALUES (11637, 29, 7);

-- Ancient Lamprey Augustine trophy + gear
REPLACE INTO `item_basic` VALUES (777, 0, 'Agstn_Sucker', 'agstn_sucker', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23974, 0, 'Augustine_Robe', 'augustine_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23974, 'AgstnLDRbe', 50, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23974, 1, 19);
REPLACE INTO `item_mods` VALUES (23974, 14, 8);
REPLACE INTO `item_mods` VALUES (23974, 2, 70);
REPLACE INTO `item_mods` VALUES (23974, 25, 6);
REPLACE INTO `item_basic` VALUES (11639, 0, 'Augustine_Ring', 'augustine_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11639, 'AgstnVtRng', 50, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11639, 14, 6);
REPLACE INTO `item_mods` VALUES (11639, 2, 45);
REPLACE INTO `item_mods` VALUES (11639, 29, 8);

-- Larval Lavrentiy trophy + gear
REPLACE INTO `item_basic` VALUES (780, 0, 'Lavrentiy_Silk', 'lavrentiy_silk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11644, 0, 'Lavrentiy_Ring', 'lavrentiy_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11644, 'LvrnCRng', 18, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11644, 25, 3);
REPLACE INTO `item_mods` VALUES (11644, 9, 15);
REPLACE INTO `item_mods` VALUES (11644, 30, 4);
REPLACE INTO `item_basic` VALUES (23705, 0, 'Lavrentiy_Boots', 'lavrentiy_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23705, 'LvrnWBts', 18, 0, 4194303, 0, 0, 0, 2048, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23705, 1, 5);
REPLACE INTO `item_mods` VALUES (23705, 23, 3);
REPLACE INTO `item_mods` VALUES (23705, 68, 7);

-- Spinning Sebestyen trophy + gear
REPLACE INTO `item_basic` VALUES (783, 0, 'Sebestyen_Silk', 'sebestyen_silk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25533, 0, 'Sbstyn_Collar', 'sbstyn_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25533, 'SbstynWCll', 30, 0, 4194303, 0, 0, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (25533, 25, 4);
REPLACE INTO `item_mods` VALUES (25533, 9, 25);
REPLACE INTO `item_mods` VALUES (25533, 30, 6);
REPLACE INTO `item_basic` VALUES (23528, 0, 'Sebestyen_Mitts', 'sebestyen_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23528, 'SbstynSMtt', 30, 0, 4194303, 0, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23528, 1, 9);
REPLACE INTO `item_mods` VALUES (23528, 25, 4);
REPLACE INTO `item_mods` VALUES (23528, 28, 8);

-- Metamorphing Melchior trophy + gear
REPLACE INTO `item_basic` VALUES (786, 0, 'Melchior_Core', 'melchior_core', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23975, 0, 'Melchior_Robe', 'melchior_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23975, 'MlchrTRbe', 42, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23975, 1, 17);
REPLACE INTO `item_mods` VALUES (23975, 25, 7);
REPLACE INTO `item_mods` VALUES (23975, 28, 14);
REPLACE INTO `item_mods` VALUES (23975, 9, 55);
REPLACE INTO `item_basic` VALUES (11645, 0, 'Melchior_Ring', 'melchior_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11645, 'MlchrERng', 42, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11645, 25, 5);
REPLACE INTO `item_mods` VALUES (11645, 30, 9);
REPLACE INTO `item_mods` VALUES (11645, 28, 8);

-- Melpomene trophy + gear
REPLACE INTO `item_basic` VALUES (789, 0, 'Mlpmn_Chrysalis', 'mlpmn_chrysalis', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23976, 0, 'Melpomene_Robe', 'melpomene_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23976, 'MlpmARbe', 56, 0, 4194303, 0, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (23976, 1, 21);
REPLACE INTO `item_mods` VALUES (23976, 25, 10);
REPLACE INTO `item_mods` VALUES (23976, 28, 20);
REPLACE INTO `item_mods` VALUES (23976, 9, 85);
REPLACE INTO `item_basic` VALUES (11664, 0, 'Melpomene_Ring', 'melpomene_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11664, 'MlpmCRng', 56, 0, 4194303, 0, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES (11664, 25, 7);
REPLACE INTO `item_mods` VALUES (11664, 28, 15);
REPLACE INTO `item_mods` VALUES (11664, 30, 13);

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
REPLACE INTO `item_basic` VALUES (228, 0, 'crawlers_mantle', 'crawlers_mantle', 1, 59476, 0, 0, 1500);
REPLACE INTO `item_equipment` VALUES (228,'crawl_silk_mnt',8,0,4194303,0,0,0,256,0,0,0);
REPLACE INTO `item_mods` VALUES (228,1,5),(228,11,8),(228,68,10),(228,384,5);

-- ---------------------------------------------------------------------------
-- 229: Bat Sonar Earring  (EAR, lv5)  — Frenzied Bat
-- A crystallized membrane granting uncanny spatial awareness.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (229, 0, 'bat_earring', 'bat_earring', 1, 59476, 0, 0, 28197);
REPLACE INTO `item_equipment` VALUES (229,'bat_sonar_erng',5,0,4194303,0,0,0,4,0,0,0);
REPLACE INTO `item_mods` VALUES (229,25,10),(229,30,8),(229,11,5);

-- ---------------------------------------------------------------------------
-- 230: Bomb Core Fragment  (RING, lv10)  — Enraged Bomb
-- A shard of a bomb's explosive core. Still warm. Wearing it is inadvisable.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (230, 0, 'bomb_fragment', 'bomb_fragment', 1, 59476, 0, 0, 1200);
REPLACE INTO `item_equipment` VALUES (230,'bomb_core_frag',10,0,4194303,0,0,0,64,0,0,0);
REPLACE INTO `item_mods` VALUES (230,23,15),(230,28,12),(230,8,5),(230,2,-30);

-- ---------------------------------------------------------------------------
-- 231: Rogue Scout's Beret  (HEAD, lv12)  — Rogue Quadav
-- Standard-issue headgear of a Quadav infiltrator. Smells of brine and regret.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (231, 0, 'rogue_beret', 'rogue_beret', 1, 59476, 0, 0, 2000);
REPLACE INTO `item_equipment` VALUES (231,'rogue_sct_brt',12,0,4194303,0,0,0,1,0,0,0);
REPLACE INTO `item_mods` VALUES (231,1,8),(231,9,7),(231,25,10),(231,68,8),(231,2,30);

-- ---------------------------------------------------------------------------
-- 232: Tiger's Bloodmane Cloak  (BACK, lv25)  — Frenzied Tiger
-- The vivid mane of a tiger driven mad by ley-line energy. Still radiates heat.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (232, 0, 'tigers_cloak', 'tigers_cloak', 1, 59476, 0, 0, 5000);
REPLACE INTO `item_equipment` VALUES (232,'tigr_blood_mnt',25,0,4194303,0,0,0,256,0,0,0);
REPLACE INTO `item_mods` VALUES (232,23,22),(232,8,10),(232,384,7),(232,2,40);

-- ---------------------------------------------------------------------------
-- 233: Shade Wraith Tabard  (BODY, lv30)  — Wandering Shade
-- Woven from ectoplasmic essence. Cold to the touch; warm to the soul. Probably.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (233, 0, 'shade_tabard', 'shade_tabard', 1, 59476, 0, 0, 8000);
REPLACE INTO `item_equipment` VALUES (233,'shade_wrth_tab',30,0,4194303,0,0,0,16,0,0,0);
REPLACE INTO `item_mods` VALUES (233,5,100),(233,12,12),(233,13,10),(233,28,18),(233,29,10);

-- ---------------------------------------------------------------------------
-- 234: Goblin's Overstuffed Satchel  (WAIST, lv20)  — Treasure Goblin
-- Contains everything. No one knows how it holds so much.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (234, 0, 'goblins_satchel', 'goblins_satchel', 1, 59476, 0, 0, 3000);
REPLACE INTO `item_equipment` VALUES (234,'gob_ovst_sach',20,0,4194303,0,0,0,512,0,0,0);
REPLACE INTO `item_mods` VALUES (234,8,6),(234,9,6),(234,10,6),(234,11,6),(234,12,6),(234,13,6),(234,14,6),(234,2,50),(234,5,30);

-- ---------------------------------------------------------------------------
-- 235: Goblin's Jackpot Bell  (EAR, lv40)  — Treasure Goblin (rare variant)
-- The bell the goblin rings when it strikes it rich. Now it rings for you.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (235, 0, 'goblins_bell', 'goblins_bell', 1, 59476, 0, 0, 6000);
REPLACE INTO `item_equipment` VALUES (235,'gob_jkpt_bell',40,0,4194303,0,0,0,4,0,0,0);
REPLACE INTO `item_mods` VALUES (235,25,20),(235,23,20),(235,384,10),(235,2,50);

-- ---------------------------------------------------------------------------
-- 236: Goobbue Rootbelt  (WAIST, lv35)  — Rampaging Goobbue
-- Twisted from the living roots off a Goobbue's shoulders. Still trying to grow.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (236, 0, 'gbb_rootbelt', 'gbb_rootbelt', 1, 59476, 0, 0, 7000);
REPLACE INTO `item_equipment` VALUES (236,'goob_rootbelt',35,0,4194303,0,0,0,512,0,0,0);
REPLACE INTO `item_mods` VALUES (236,2,120),(236,10,14),(236,8,10),(236,1,20),(236,23,15);

-- ---------------------------------------------------------------------------
-- 237: Dread Hunter's Choker  (NECK, lv50)  — Dread Hunter (Coeurl)
-- Crystallized mane-fur from a coeurl that fed on too many crystals.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (237, 0, 'dread_choker', 'dread_choker', 1, 59476, 0, 0, 12000);
REPLACE INTO `item_equipment` VALUES (237,'drd_hnt_chokr',50,0,4194303,0,0,0,2,0,0,0);
REPLACE INTO `item_mods` VALUES (237,23,28),(237,25,20),(237,9,12),(237,384,8),(237,2,60);

-- ---------------------------------------------------------------------------
-- 238: Fell Commander's Vambrace  (HANDS, lv55)  — Fell Commander
-- Bronze vambrace of a Quadav war-leader. The engravings still pulse.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (238, 0, 'fell_vambrace', 'fell_vambrace', 1, 59476, 0, 0, 15000);
REPLACE INTO `item_equipment` VALUES (238,'fell_cmd_vamb',55,0,4194303,0,0,0,32,0,0,0);
REPLACE INTO `item_mods` VALUES (238,1,20),(238,8,12),(238,23,20),(238,25,15),(238,2,80),(238,27,10);

-- ---------------------------------------------------------------------------
-- 239: Nexus Core Helm  (HEAD, lv50)  — Storm Nexus
-- Elemental forces solidified into a helmet. The wearer sees reality differently.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (239, 0, 'nexus_core_helm', 'nexus_core_helm', 1, 59476, 0, 0, 13000);
REPLACE INTO `item_equipment` VALUES (239,'nexus_core_hlm',50,0,4194303,0,0,0,1,0,0,0);
REPLACE INTO `item_mods` VALUES (239,28,25),(239,30,18),(239,12,15),(239,5,80),(239,384,8);

-- ---------------------------------------------------------------------------
-- 240: Crystal Golem's Heart  (EAR, lv55)  — Crystal Golem
-- The gemstone core that animated the golem. Still pulses like a heartbeat.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (240, 0, 'crystal_heart', 'crystal_heart', 1, 59476, 0, 0, 11000);
REPLACE INTO `item_equipment` VALUES (240,'cryst_golm_hrt',55,0,4194303,0,0,0,4,0,0,0);
REPLACE INTO `item_mods` VALUES (240,1,12),(240,2,100),(240,10,15),(240,29,20);

-- ---------------------------------------------------------------------------
-- 241: Void Wyrm's Fang  (NECK, lv75)  — Void Wyrm
-- A tooth from the void dragon, still leaking destructive essence.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (241, 0, 'void_wyrms_fang', 'void_wyrms_fang', 1, 59476, 0, 0, 40000);
REPLACE INTO `item_equipment` VALUES (241,'void_wyrm_fang',75,0,4194303,0,0,0,2,0,0,0);
REPLACE INTO `item_mods` VALUES (241,23,40),(241,28,35),(241,8,15),(241,12,12),(241,384,12),(241,2,80);

-- ---------------------------------------------------------------------------
-- 242: Abyssal Tyrant's Diadem  (HEAD, lv75)  — Abyssal Tyrant
-- The horned crown of a demon lord. It fits. This is alarming.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (242, 0, 'abyssal_diadem', 'abyssal_diadem', 1, 59476, 0, 0, 50000);
REPLACE INTO `item_equipment` VALUES (242,'abys_typ_diad',75,0,4194303,0,0,0,1,0,0,0);
REPLACE INTO `item_mods` VALUES (242,8,15),(242,12,15),(242,13,12),(242,23,30),(242,28,28),(242,25,20),(242,30,18),(242,2,120);

-- ---------------------------------------------------------------------------
-- 243: Ancient King's Carapace  (BODY, lv75)  — Ancient King
-- Armor shaped from the shell of the Ancient King. A village sheltered here once.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (243, 0, 'kings_carapace', 'kings_carapace', 1, 59476, 0, 0, 60000);
REPLACE INTO `item_equipment` VALUES (243,'anc_kng_carap',75,0,4194303,0,0,0,16,0,0,0);
REPLACE INTO `item_mods` VALUES (243,1,50),(243,2,300),(243,10,20),(243,29,35),(243,27,15);

-- ---------------------------------------------------------------------------
-- 244: Apex Soulstone  (RING, lv60)  — Apex-tier (generic)
-- A gemstone formed from crystallized dynamic energy.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (244, 0, 'apex_soulstone', 'apex_soulstone', 1, 59476, 0, 0, 20000);
REPLACE INTO `item_equipment` VALUES (244,'apex_soulstone',60,0,4194303,0,0,0,64,0,0,0);
REPLACE INTO `item_mods` VALUES (244,2,120),(244,5,80),(244,8,12),(244,12,12),(244,23,20),(244,28,20),(244,384,10);

-- ---------------------------------------------------------------------------
-- 245: Wanderer's Legacy  (RING, lv75)  — Apex-tier (prestige)
-- A ring worn by adventurers who have hunted the Dynamic World thoroughly.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (245, 0, 'wndrrs_legacy', 'wndrrs_legacy', 1, 59476, 0, 0, 75000);
REPLACE INTO `item_equipment` VALUES (245,'wandrers_lgcy',75,0,4194303,0,0,0,64,0,0,0);
REPLACE INTO `item_mods` VALUES (245,2,150),(245,5,100),(245,8,10),(245,9,10),(245,10,10),(245,11,10),(245,12,10),(245,13,10),(245,384,15);

-- ---------------------------------------------------------------------------
-- 249: Void Wyrm Scale  (BACK, lv75)  — Void Wyrm (alternate drop)
-- A scale the size of a shield. Absorbs blows and helps you hit harder.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (249, 0, 'void_wyrm_scale', 'void_wyrm_scale', 1, 59476, 0, 0, 45000);
REPLACE INTO `item_equipment` VALUES (249,'void_wyrm_scl',75,0,4194303,0,0,0,256,0,0,0);
REPLACE INTO `item_mods` VALUES (249,1,30),(249,23,35),(249,8,15),(249,10,15),(249,2,150),(249,384,10);
