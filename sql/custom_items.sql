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
--   slot bitmask  : 1=MAIN 2=SUB 4=RANGED 8=AMMO 16=HEAD 32=BODY 64=HANDS
--                   128=LEGS 256=FEET 512=NECK 1024=WAIST 6144=EARS
--                   24576=RINGS 32768=BACK
--   flags common  : 0x0008=Rare 0x0020=Exclusive (no AH) 0x0040=NoDrop
--                   0x1000=Equippable 0x4000=Usable  0x8000=NPC only
--                   46660 = Rare+Exclusive+NoAH (typical rare drop)
--                   12352 = Equippable+Rare
--   mod IDs (item_mods) -- common ones:
--      1=DEF  2=HP  5=MP  8=STR  9=DEX  10=VIT  11=AGI
--     12=INT 13=MND 14=CHR 23=ATT 24=RATT 25=ACC 26=RACC
--     28=MATT 29=MDEF 30=MACC 68=EVA 73=STORETP
--     165=CRIT 369=REFRESH 370=REGEN 384=HASTE_GEAR
--     421=CRIT_DMG 562=MAGIC_CRIT 563=MAGIC_CRIT_DMG
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
    (23437, "morriss_wide_brim", 38, 0, 16924, 0, 0, 0, 16, 0, 0, 0);
    --                                                       ^all jobs              ^HEAD slot

REPLACE INTO `item_mods` VALUES
    (23437, 1, 8), -- DEF +8
    (23437, 5, 30), -- MP +30
    (23437, 12, 6), -- INT +6
    (23437, 13, 4), -- MND +4
    (23437, 14, 4), -- CHR +4
    (23437, 28, 6), -- MAB +6
    (23437, 30, 6), -- MACC +6
    (23437, 562, 3), -- M.Crit +3
    (23437, 563, 5), -- M.Crit Dmg. +5
    (23437, 369, 1); -- Refresh +1

-- [16402] Morris's Sporeling  (rare key item / curiosity, no equip — just a trophy drop)
REPLACE INTO `item_basic` VALUES
    (16402, 0, 'Mrrs_Sporeling', 'mrrs_sporeling', 1, 59476, 99, 1, 0);
    -- NoSale=1, BaseSell=0 — unsellable trophy

-- [16415] Mycelium Medal  (neck, all jobs, lv10, rare reward)
REPLACE INTO `item_basic` VALUES
    (26117, 0, 'Fungal_Medal', 'fungal_medal', 1, 59476, 99, 0, 28197);

REPLACE INTO `item_equipment` VALUES
    (26117, "fungal_medal", 45, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
    --                                                                                   ^EARS slot

REPLACE INTO `item_mods` VALUES
    (26117, 5, 45), -- MP +45
    (26117, 12, 9), -- INT +9
    (26117, 13, 6), -- MND +6
    (26117, 14, 6), -- CHR +6
    (26117, 28, 9), -- MAB +9
    (26117, 30, 9), -- MACC +9
    (26117, 562, 4), -- M.Crit +4
    (26117, 563, 7), -- M.Crit Dmg. +7
    (26117, 369, 2); -- Refresh +2

-- =============================================================================
-- SECTION 2: DYNAMIC WORLD TIER REWARDS
-- Generic rare drops from Elite / Apex tiers
-- =============================================================================

-- [16424] Wanderer's Token  (ring, all jobs, lv1)
REPLACE INTO `item_basic` VALUES
    (11638, 0, 'Wanderer_Token', 'wanderer_token', 1, 59476, 99, 0, 200);
REPLACE INTO `item_equipment` VALUES
    (11638, "wanderers_token", 13, 0, 10240, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11638, 8, 3), -- STR +3
    (11638, 9, 3), -- DEX +3
    (11638, 23, 6), -- Attack +6
    (11638, 25, 6), -- Accuracy +6
    (11638, 73, 3), -- Store TP +3
    (11638, 384, 100); -- Haste +1%

-- [16435] Nomad's Cord  (waist, all jobs, lv20)
REPLACE INTO `item_basic` VALUES
    (28439, 0, 'Nomad_Cord', 'nomad_cord', 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (28439, "nomads_cord", 36, 0, 131, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28439, 1, 3), -- DEF +3
    (28439, 2, 40), -- HP +40
    (28439, 8, 6), -- STR +6
    (28439, 10, 6), -- VIT +6
    (28439, 23, 12), -- Attack +12
    (28439, 25, 10), -- Accuracy +10
    (28439, 421, 4); -- Crit Dmg. +4

-- [16436] Elite's Resolve  (back, all jobs, lv40)
REPLACE INTO `item_basic` VALUES
    (28610, 0, 'Elite_Resolve', 'elite_resolve', 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (28610, "elites_resolve", 51, 0, 10240, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28610, 1, 6), -- DEF +6
    (28610, 8, 9), -- STR +9
    (28610, 9, 9), -- DEX +9
    (28610, 23, 18), -- Attack +18
    (28610, 25, 18), -- Accuracy +18
    (28610, 73, 7), -- Store TP +7
    (28610, 384, 300); -- Haste +3%

-- [16462] Apex Shard  (ring, all jobs, lv50)
REPLACE INTO `item_basic` VALUES
    (11677, 0, 'Apex_Charm', 'apex_charm', 1, 59476, 99, 0, 10000);
REPLACE INTO `item_equipment` VALUES
    (11677, "apex_charm", 73, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11677, 5, 60), -- MP +60
    (11677, 12, 12), -- INT +12
    (11677, 13, 8), -- MND +8
    (11677, 14, 8), -- CHR +8
    (11677, 28, 12), -- MAB +12
    (11677, 30, 12), -- MACC +12
    (11677, 562, 5), -- M.Crit +5
    (11677, 563, 10), -- M.Crit Dmg. +10
    (11677, 369, 3); -- Refresh +3

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
    (23438, "williams_woolcap", 14, 0, 16924, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23438, 1, 4), -- DEF +4
    (23438, 5, 15), -- MP +15
    (23438, 12, 3), -- INT +3
    (23438, 13, 2), -- MND +2
    (23438, 14, 2), -- CHR +2
    (23438, 28, 3), -- MAB +3
    (23438, 30, 3), -- MACC +3
    (23438, 562, 2), -- M.Crit +2
    (23438, 563, 3), -- M.Crit Dmg. +3
    (23438, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES
    (23539, 0, 'Wllm_Woolmitt', 'wllm_woolmitt', 1, 59476, 99, 0, 500);
REPLACE INTO `item_equipment` VALUES
    (23539, "williams_woolmitt", 11, 0, 131, 79, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23539, 1, 3), -- DEF +3
    (23539, 2, 20), -- HP +20
    (23539, 8, 3), -- STR +3
    (23539, 10, 3), -- VIT +3
    (23539, 23, 6), -- Attack +6
    (23539, 25, 5), -- Accuracy +5
    (23539, 421, 2); -- Crit Dmg. +2

-- Baa-rbara (lv10-13)
-- Baarbara Bell is defined in SECTION 4 with the current weapon DAT mapping.

REPLACE INTO `item_basic` VALUES
    (26007, 0, 'Baarbara_Collar', 'baarbara_collar', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (26007, "baarbaras_collar", 24, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26007, 5, 30), -- MP +30
    (26007, 12, 6), -- INT +6
    (26007, 13, 4), -- MND +4
    (26007, 14, 4), -- CHR +4
    (26007, 28, 6), -- MAB +6
    (26007, 30, 6), -- MACC +6
    (26007, 562, 3), -- M.Crit +3
    (26007, 563, 5), -- M.Crit Dmg. +5
    (26007, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES
    (28441, 0, 'Baarbara_Ribbon', 'baarbara_ribbon', 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (28441, "baarbaras_ribbon", 21, 0, 263200, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28441, 1, 3), -- DEF +3
    (28441, 9, 6), -- DEX +6
    (28441, 11, 6), -- AGI +6
    (28441, 25, 10), -- Accuracy +10
    (28441, 26, 10), -- Rng. Acc. +10
    (28441, 23, 12), -- Attack +12
    (28441, 24, 12), -- Rng. Atk. +12
    (28441, 68, 10), -- Evasion +10
    (28441, 165, 3); -- Crit Rate +3

-- Lambchop Larry (lv20-24) — 18548-18550
REPLACE INTO `item_basic` VALUES
    (18548, 0, 'Larry_Lambchop', 'larry_lambchop', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (28611, 0, 'Larry_Fleece', 'larry_fleece', 1, 59476, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (28611, "larrys_lucky_fleece", 13, 0, 131, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28611, 1, 2), -- DEF +2
    (28611, 2, 20), -- HP +20
    (28611, 8, 3), -- STR +3
    (28611, 10, 3), -- VIT +3
    (28611, 23, 6), -- Attack +6
    (28611, 25, 5), -- Accuracy +5
    (28611, 421, 2); -- Crit Dmg. +2

REPLACE INTO `item_basic` VALUES
    (26008, 0, 'Larry_Lanyard', 'larry_lanyard', 1, 59476, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (26008, "larrys_lanyard", 26, 0, 131, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26008, 2, 40), -- HP +40
    (26008, 8, 6), -- STR +6
    (26008, 10, 6), -- VIT +6
    (26008, 23, 12), -- Attack +12
    (26008, 25, 10), -- Accuracy +10
    (26008, 421, 4); -- Crit Dmg. +4

-- Shear Sharon (lv35-40) — 18567-18569
REPLACE INTO `item_basic` VALUES
    (18567, 0, 'Sharon_Fleece', 'sharon_fleece', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23529, 0, 'Sharon_Shears', 'sharon_shears', 1, 59476, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (23529, "sharons_shears", 50, 0, 6146, 214, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23529, 1, 9), -- DEF +9
    (23529, 8, 6), -- STR +6
    (23529, 9, 9), -- DEX +9
    (23529, 23, 18), -- Attack +18
    (23529, 25, 20), -- Accuracy +20
    (23529, 73, 8), -- Store TP +8
    (23529, 384, 300), -- Haste +3%
    (23529, 165, 4); -- Crit Rate +4

REPLACE INTO `item_basic` VALUES
    (28612, 0, 'Sharon_Mantle', 'sharon_mantle', 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (28612, "sharons_silken_mantle", 16, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28612, 1, 2), -- DEF +2
    (28612, 5, 15), -- MP +15
    (28612, 12, 3), -- INT +3
    (28612, 13, 2), -- MND +2
    (28612, 14, 2), -- CHR +2
    (28612, 28, 3), -- MAB +3
    (28612, 30, 3), -- MACC +3
    (28612, 562, 2), -- M.Crit +2
    (28612, 563, 3), -- M.Crit Dmg. +3
    (28612, 369, 1); -- Refresh +1

-- =========================================================
-- RABBITS
-- =========================================================

-- Cottontail Tom (lv5-7) — 18570-18795
REPLACE INTO `item_basic` VALUES
    (18570, 0, 'Tom_Cottontail', 'tom_cottontail', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (10294, 0, 'Tom_Foot_Sash', 'tom_foot_sash', 1, 59476, 99, 0, 300);
REPLACE INTO `item_equipment` VALUES
    (10294, "tom_foot_sash", 66, 0, 263200, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10294, 9, 12), -- DEX +12
    (10294, 11, 12), -- AGI +12
    (10294, 25, 20), -- Accuracy +20
    (10294, 26, 20), -- Rng. Acc. +20
    (10294, 23, 24), -- Attack +24
    (10294, 24, 24), -- Rng. Atk. +24
    (10294, 68, 20), -- Evasion +20
    (10294, 165, 5); -- Crit Rate +5

REPLACE INTO `item_basic` VALUES
    (23751, 0, 'Tom_Hop_Boots', 'tom_hop_boots', 1, 59476, 99, 0, 500);
REPLACE INTO `item_equipment` VALUES
    (23751, "toms_hop_boots", 6, 0, 263200, 252, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23751, 1, 3), -- DEF +3
    (23751, 9, 3), -- DEX +3
    (23751, 11, 3), -- AGI +3
    (23751, 25, 5), -- Accuracy +5
    (23751, 26, 5), -- Rng. Acc. +5
    (23751, 23, 6), -- Attack +6
    (23751, 24, 6), -- Rng. Atk. +6
    (23751, 68, 5), -- Evasion +5
    (23751, 165, 2); -- Crit Rate +2

-- Hopscotch Harvey (lv10-13) — 18796-18798
REPLACE INTO `item_basic` VALUES
    (18796, 0, 'Harvey_Hopstone', 'harvey_hopstone', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (10374, 0, 'Harvey_Ear', 'harvey_ear', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (10374, "harvey_ear", 57, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10374, 5, 45), -- MP +45
    (10374, 12, 9), -- INT +9
    (10374, 13, 6), -- MND +6
    (10374, 14, 6), -- CHR +6
    (10374, 28, 9), -- MAB +9
    (10374, 30, 9), -- MACC +9
    (10374, 562, 4), -- M.Crit +4
    (10374, 563, 7), -- M.Crit Dmg. +7
    (10374, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES
    (27526, 0, 'Harvey_Earring', 'harvey_earring', 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (27526, "harveys_spring_earring", 27, 0, 263200, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27526, 9, 6), -- DEX +6
    (27526, 11, 6), -- AGI +6
    (27526, 25, 10), -- Accuracy +10
    (27526, 26, 10), -- Rng. Acc. +10
    (27526, 23, 12), -- Attack +12
    (27526, 24, 12), -- Rng. Atk. +12
    (27526, 68, 10), -- Evasion +10
    (27526, 165, 3); -- Crit Rate +3

-- Bunbun Benedict (lv22-28) — 18799-18835
REPLACE INTO `item_basic` VALUES
    (18799, 0, 'Benedict_Bonnet', 'benedict_bonnet', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23439, 0, 'Benedict_Cap', 'benedict_cap', 1, 59476, 99, 0, 1400);
REPLACE INTO `item_equipment` VALUES
    (23439, "benedicts_fur_cap", 39, 0, 263200, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23439, 1, 8), -- DEF +8
    (23439, 9, 6), -- DEX +6
    (23439, 11, 6), -- AGI +6
    (23439, 25, 10), -- Accuracy +10
    (23439, 26, 10), -- Rng. Acc. +10
    (23439, 23, 12), -- Attack +12
    (23439, 24, 12), -- Rng. Atk. +12
    (23439, 68, 10), -- Evasion +10
    (23439, 165, 3); -- Crit Rate +3

REPLACE INTO `item_basic` VALUES
    (28442, 0, 'Benedict_Belt', 'benedict_belt', 1, 59476, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (28442, "benedicts_burrow_belt", 38, 0, 263200, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28442, 1, 3), -- DEF +3
    (28442, 9, 6), -- DEX +6
    (28442, 11, 6), -- AGI +6
    (28442, 25, 10), -- Accuracy +10
    (28442, 26, 10), -- Rng. Acc. +10
    (28442, 23, 12), -- Attack +12
    (28442, 24, 12), -- Rng. Atk. +12
    (28442, 68, 10), -- Evasion +10
    (28442, 165, 3); -- Crit Rate +3

-- Twitchy Theodore (lv38-45) — 18836-18838
REPLACE INTO `item_basic` VALUES
    (18836, 0, 'Theodore_Twitch', 'theodore_twitch', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23752, 0, 'Thdr_Greaves', 'thdr_greaves', 1, 59476, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (23752, "theodores_dash_greaves", 55, 0, 263200, 267, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23752, 1, 9), -- DEF +9
    (23752, 9, 9), -- DEX +9
    (23752, 11, 9), -- AGI +9
    (23752, 25, 15), -- Accuracy +15
    (23752, 26, 15), -- Rng. Acc. +15
    (23752, 23, 18), -- Attack +18
    (23752, 24, 18), -- Rng. Atk. +18
    (23752, 68, 15), -- Evasion +15
    (23752, 165, 4); -- Crit Rate +4

REPLACE INTO `item_basic` VALUES
    (27527, 0, 'Thdr_Earring', 'thdr_earring', 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (27527, "theodores_panic_earring", 51, 0, 263200, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27527, 9, 9), -- DEX +9
    (27527, 11, 9), -- AGI +9
    (27527, 25, 15), -- Accuracy +15
    (27527, 26, 15), -- Rng. Acc. +15
    (27527, 23, 18), -- Attack +18
    (27527, 24, 18), -- Rng. Atk. +18
    (27527, 68, 15), -- Evasion +15
    (27527, 165, 4); -- Crit Rate +4

-- =========================================================
-- CRABS
-- =========================================================

-- Crableg Cameron (lv12-16) — 18889-18917
REPLACE INTO `item_basic` VALUES
    (18889, 0, 'Cameron_Claw', 'cameron_claw', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23530, 0, 'Cameron_Shield', 'cameron_shield', 1, 59476, 99, 0, 700);
REPLACE INTO `item_equipment` VALUES
    (23530, "camerons_shell_shield", 7, 0, 131, 308, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23530, 1, 3), -- DEF +3
    (23530, 2, 20), -- HP +20
    (23530, 8, 3), -- STR +3
    (23530, 10, 3), -- VIT +3
    (23530, 23, 6), -- Attack +6
    (23530, 25, 5), -- Accuracy +5
    (23530, 421, 2); -- Crit Dmg. +2

REPLACE INTO `item_basic` VALUES
    (28529, 0, 'Cameron_Ring', 'cameron_ring', 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (28529, "camerons_coral_ring", 9, 0, 131, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28529, 2, 20), -- HP +20
    (28529, 8, 3), -- STR +3
    (28529, 10, 3), -- VIT +3
    (28529, 23, 6), -- Attack +6
    (28529, 25, 5), -- Accuracy +5
    (28529, 421, 2); -- Crit Dmg. +2

-- Old Bay Ollie (lv25-30) — 18918-18920
REPLACE INTO `item_basic` VALUES
    (18918, 0, 'Ollie_Shell', 'ollie_shell', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23531, 0, 'Ollie_Gauntlets', 'ollie_gauntlets', 1, 59476, 99, 0, 1600);
REPLACE INTO `item_equipment` VALUES
    (23531, "ollies_brine_gauntlets", 30, 0, 131, 338, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23531, 1, 6), -- DEF +6
    (23531, 2, 40), -- HP +40
    (23531, 8, 6), -- STR +6
    (23531, 10, 6), -- VIT +6
    (23531, 23, 12), -- Attack +12
    (23531, 25, 10), -- Accuracy +10
    (23531, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES
    (28443, 0, 'Ollie_Belt', 'ollie_belt', 1, 59476, 99, 0, 2500);
REPLACE INTO `item_equipment` VALUES
    (28443, "ollies_seasoned_belt", 22, 0, 131, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28443, 1, 3), -- DEF +3
    (28443, 2, 40), -- HP +40
    (28443, 8, 6), -- STR +6
    (28443, 10, 6), -- VIT +6
    (28443, 23, 12), -- Attack +12
    (28443, 25, 10), -- Accuracy +10
    (28443, 421, 4); -- Crit Dmg. +4

-- Bisque Bernard (lv35-42) — 19322-19745
REPLACE INTO `item_basic` VALUES
    (19322, 0, 'Bernard_Bowl', 'bernard_bowl', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25692, 0, 'Bernard_Mail', 'bernard_mail', 1, 59476, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (25692, "bernards_tidal_mail", 57, 0, 131, 323, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25692, 1, 18), -- DEF +18
    (25692, 2, 70), -- HP +70
    (25692, 8, 9), -- STR +9
    (25692, 10, 9), -- VIT +9
    (25692, 23, 18), -- Attack +18
    (25692, 25, 15), -- Accuracy +15
    (25692, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES
    (27528, 0, 'Bernard_Earring', 'bernard_earring', 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (27528, "bernards_brine_earring", 38, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27528, 5, 30), -- MP +30
    (27528, 12, 6), -- INT +6
    (27528, 13, 4), -- MND +4
    (27528, 14, 4), -- CHR +4
    (27528, 28, 6), -- MAB +6
    (27528, 30, 6), -- MACC +6
    (27528, 562, 3), -- M.Crit +3
    (27528, 563, 5), -- M.Crit Dmg. +5
    (27528, 369, 1); -- Refresh +1

-- Dungeness Duncan (lv45-52) — 19804-19969
REPLACE INTO `item_basic` VALUES
    (19804, 0, 'Duncan_Pincer', 'duncan_pincer', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23440, 0, 'Duncan_Helm', 'duncan_helm', 1, 59476, 99, 0, 8000);
REPLACE INTO `item_equipment` VALUES
    (23440, "duncans_abyssal_helm", 59, 0, 131, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23440, 1, 12), -- DEF +12
    (23440, 2, 70), -- HP +70
    (23440, 8, 9), -- STR +9
    (23440, 10, 9), -- VIT +9
    (23440, 23, 18), -- Attack +18
    (23440, 25, 15), -- Accuracy +15
    (23440, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES
    (28567, 0, 'Duncan_Ring', 'duncan_ring', 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (28567, "duncans_deepwater_ring", 74, 0, 131, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28567, 2, 100), -- HP +100
    (28567, 8, 12), -- STR +12
    (28567, 10, 12), -- VIT +12
    (28567, 23, 24), -- Attack +24
    (28567, 25, 20), -- Accuracy +20
    (28567, 421, 8); -- Crit Dmg. +8

-- =========================================================
-- FUNGARS
-- =========================================================

-- Cap'n Chanterelle (lv18-22) — 19970-19972
REPLACE INTO `item_basic` VALUES
    (19970, 0, 'Chanterelle_Cap', 'chanterelle_cap', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23441, 0, 'Chanterelle_Hat', 'chanterelle_hat', 1, 59476, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (23441, "chanterelles_spore_hat", 16, 0, 16924, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23441, 1, 4), -- DEF +4
    (23441, 5, 15), -- MP +15
    (23441, 12, 3), -- INT +3
    (23441, 13, 2), -- MND +2
    (23441, 14, 2), -- CHR +2
    (23441, 28, 3), -- MAB +3
    (23441, 30, 3), -- MACC +3
    (23441, 562, 2), -- M.Crit +2
    (23441, 563, 3), -- M.Crit Dmg. +3
    (23441, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES
    (28445, 0, 'Chntrll_Mycelia', 'chntrll_mycelia', 1, 59476, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (28445, "chanterelles_mycelia", 21, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28445, 1, 3), -- DEF +3
    (28445, 5, 30), -- MP +30
    (28445, 12, 6), -- INT +6
    (28445, 13, 4), -- MND +4
    (28445, 14, 4), -- CHR +4
    (28445, 28, 6), -- MAB +6
    (28445, 30, 6), -- MACC +6
    (28445, 562, 3), -- M.Crit +3
    (28445, 563, 5), -- M.Crit Dmg. +5
    (28445, 369, 1); -- Refresh +1

-- Portobello Pete (lv35-40) — 19973-19975
REPLACE INTO `item_basic` VALUES
    (19973, 0, 'Pete_Portobello', 'pete_portobello', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25693, 0, 'Pete_Robe', 'pete_robe', 1, 59476, 99, 0, 5000);
REPLACE INTO `item_equipment` VALUES
    (25693, "petes_fungal_robe", 46, 0, 16924, 323, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25693, 1, 18), -- DEF +18
    (25693, 5, 45), -- MP +45
    (25693, 12, 9), -- INT +9
    (25693, 13, 6), -- MND +6
    (25693, 14, 6), -- CHR +6
    (25693, 28, 9), -- MAB +9
    (25693, 30, 9), -- MACC +9
    (25693, 562, 4), -- M.Crit +4
    (25693, 563, 7), -- M.Crit Dmg. +7
    (25693, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES
    (26009, 0, 'Pete_Necklace', 'pete_necklace', 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (26009, "petes_spore_necklace", 31, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26009, 5, 30), -- MP +30
    (26009, 12, 6), -- INT +6
    (26009, 13, 4), -- MND +4
    (26009, 14, 4), -- CHR +4
    (26009, 28, 6), -- MAB +6
    (26009, 30, 6), -- MACC +6
    (26009, 562, 3), -- M.Crit +3
    (26009, 563, 5), -- M.Crit Dmg. +5
    (26009, 369, 1); -- Refresh +1

-- Truffle Trevor (lv55-62) — 19976-19978
REPLACE INTO `item_basic` VALUES
    (19976, 0, 'Trevor_Truffle', 'trevor_truffle', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23710, 0, 'Trevor_Crown', 'trevor_crown', 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (23710, "trevors_myconid_crown", 71, 0, 16924, 132, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23710, 1, 16), -- DEF +16
    (23710, 5, 60), -- MP +60
    (23710, 12, 12), -- INT +12
    (23710, 13, 8), -- MND +8
    (23710, 14, 8), -- CHR +8
    (23710, 28, 12), -- MAB +12
    (23710, 30, 12), -- MACC +12
    (23710, 562, 5), -- M.Crit +5
    (23710, 563, 10), -- M.Crit Dmg. +10
    (23710, 369, 3); -- Refresh +3

REPLACE INTO `item_basic` VALUES
    (11628, 0, 'Trevor_Cape', 'trevor_cape', 1, 59476, 99, 0, 15000);
REPLACE INTO `item_equipment` VALUES
    (11628, "trevor_cape", 74, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11628, 5, 60), -- MP +60
    (11628, 12, 12), -- INT +12
    (11628, 13, 8), -- MND +8
    (11628, 14, 8), -- CHR +8
    (11628, 28, 12), -- MAB +12
    (11628, 30, 12), -- MACC +12
    (11628, 562, 5), -- M.Crit +5
    (11628, 563, 10), -- M.Crit Dmg. +10
    (11628, 369, 3); -- Refresh +3

-- =========================================================
-- GOBLINS
-- =========================================================

-- Bargain Bruno (lv12-16) — 19979-19981
REPLACE INTO `item_basic` VALUES
    (19979, 0, 'Bruno_Bin', 'bruno_bin', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23711, 0, 'Bruno_Helm', 'bruno_helm', 1, 59476, 99, 0, 700);
REPLACE INTO `item_equipment` VALUES
    (23711, "brunos_discount_helm", 8, 0, 10240, 128, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23711, 1, 4), -- DEF +4
    (23711, 8, 3), -- STR +3
    (23711, 9, 3), -- DEX +3
    (23711, 23, 6), -- Attack +6
    (23711, 25, 6), -- Accuracy +6
    (23711, 73, 3), -- Store TP +3
    (23711, 384, 100); -- Haste +1%

REPLACE INTO `item_basic` VALUES
    (28446, 0, 'Bruno_Pouch', 'bruno_pouch', 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (28446, "brunos_lucky_pouch", 26, 0, 10240, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28446, 1, 3), -- DEF +3
    (28446, 8, 6), -- STR +6
    (28446, 9, 6), -- DEX +6
    (28446, 23, 12), -- Attack +12
    (28446, 25, 12), -- Accuracy +12
    (28446, 73, 5), -- Store TP +5
    (28446, 384, 200); -- Haste +2%

-- Swindler Sam (lv30-36) — 19982-19984
REPLACE INTO `item_basic` VALUES
    (19982, 0, 'Sam_Loaded_Dice', 'sam_loaded_dice', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25694, 0, 'Sam_Vest', 'sam_vest', 1, 59476, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (25694, "sams_swindler_vest", 46, 0, 263200, 324, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25694, 1, 18), -- DEF +18
    (25694, 9, 9), -- DEX +9
    (25694, 11, 9), -- AGI +9
    (25694, 25, 15), -- Accuracy +15
    (25694, 26, 15), -- Rng. Acc. +15
    (25694, 23, 18), -- Attack +18
    (25694, 24, 18), -- Rng. Atk. +18
    (25694, 68, 15), -- Evasion +15
    (25694, 165, 4); -- Crit Rate +4

REPLACE INTO `item_basic` VALUES
    (27529, 0, 'Sam_Earring', 'sam_earring', 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (27529, "sams_grift_earring", 55, 0, 10240, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27529, 8, 9), -- STR +9
    (27529, 9, 9), -- DEX +9
    (27529, 23, 18), -- Attack +18
    (27529, 25, 18), -- Accuracy +18
    (27529, 73, 7), -- Store TP +7
    (27529, 384, 300); -- Haste +3%

-- Shiny Steve (lv45-52) — 19985-19987
REPLACE INTO `item_basic` VALUES
    (19985, 0, 'Steve_Shiniest', 'steve_shiniest', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25695, 0, 'Steve_Mail', 'steve_mail', 1, 59476, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (25695, "steves_glittering_mail", 64, 0, 263200, 324, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25695, 1, 25), -- DEF +25
    (25695, 9, 12), -- DEX +12
    (25695, 11, 12), -- AGI +12
    (25695, 25, 20), -- Accuracy +20
    (25695, 26, 20), -- Rng. Acc. +20
    (25695, 23, 24), -- Attack +24
    (25695, 24, 24), -- Rng. Atk. +24
    (25695, 68, 20), -- Evasion +20
    (25695, 165, 5); -- Crit Rate +5

REPLACE INTO `item_basic` VALUES
    (11630, 0, 'Steve_Ring', 'steve_ring', 1, 59476, 99, 0, 14000);
REPLACE INTO `item_equipment` VALUES
    (11630, "steves_magpie_ring", 73, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11630, 8, 8), -- STR +8
    (11630, 9, 12), -- DEX +12
    (11630, 23, 24), -- Attack +24
    (11630, 25, 26), -- Accuracy +26
    (11630, 73, 12), -- Store TP +12
    (11630, 384, 400), -- Haste +4%
    (11630, 165, 5); -- Crit Rate +5

-- =========================================================
-- COEURLS
-- =========================================================

-- Whiskers Wilhelmina (lv30-36) — 19988-10581
REPLACE INTO `item_basic` VALUES
    (19988, 0, 'Wlhlmn_Whisker', 'wlhlmn_whisker', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (26010, 0, 'Wilhelmina_Neck', 'wilhelmina_neck', 1, 59476, 99, 0, 3500);
REPLACE INTO `item_equipment` VALUES
    (26010, "wilhelminas_fang_necklace", 34, 0, 10240, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26010, 8, 6), -- STR +6
    (26010, 9, 6), -- DEX +6
    (26010, 23, 12), -- Attack +12
    (26010, 25, 12), -- Accuracy +12
    (26010, 73, 5), -- Store TP +5
    (26010, 384, 200); -- Haste +2%

REPLACE INTO `item_basic` VALUES
    (23253, 0, 'Wilhelmina_Legs', 'wilhelmina_legs', 1, 59476, 99, 0, 5500);
REPLACE INTO `item_equipment` VALUES
    (23253, "wilhelminas_grace_legs", 58, 0, 263200, 88, 0, 0, 128, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23253, 1, 16), -- DEF +16
    (23253, 9, 9), -- DEX +9
    (23253, 11, 9), -- AGI +9
    (23253, 25, 15), -- Accuracy +15
    (23253, 26, 15), -- Rng. Acc. +15
    (23253, 23, 18), -- Attack +18
    (23253, 24, 18), -- Rng. Atk. +18
    (23253, 68, 15), -- Evasion +15
    (23253, 165, 4); -- Crit Rate +4

-- Purring Patricia (lv42-48) — 19991-19993
REPLACE INTO `item_basic` VALUES
    (19991, 0, 'Patricia_Purr', 'patricia_purr', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23532, 0, 'Ptrc_Gauntlets', 'ptrc_gauntlets', 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (23532, "patricias_claw_gauntlets", 60, 0, 131, 65, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23532, 1, 12), -- DEF +12
    (23532, 2, 100), -- HP +100
    (23532, 8, 12), -- STR +12
    (23532, 10, 12), -- VIT +12
    (23532, 23, 24), -- Attack +24
    (23532, 25, 20), -- Accuracy +20
    (23532, 421, 8); -- Crit Dmg. +8

REPLACE INTO `item_basic` VALUES
    (28614, 0, 'Patricia_Cape', 'patricia_cape', 1, 59476, 99, 0, 10000);
REPLACE INTO `item_equipment` VALUES
    (28614, "patricias_predator_cape", 72, 0, 10240, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28614, 1, 8), -- DEF +8
    (28614, 8, 12), -- STR +12
    (28614, 9, 12), -- DEX +12
    (28614, 23, 24), -- Attack +24
    (28614, 25, 24), -- Accuracy +24
    (28614, 73, 10), -- Store TP +10
    (28614, 384, 400); -- Haste +4%

-- Nine Lives Nigel (lv58-65) — 19994-19996
REPLACE INTO `item_basic` VALUES
    (19994, 0, 'Nigel_Life', 'nigel_life', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25696, 0, 'Nigel_Cuirass', 'nigel_cuirass', 1, 59476, 99, 0, 15000);
REPLACE INTO `item_equipment` VALUES
    (25696, "nigels_feral_cuirass", 64, 0, 10240, 320, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25696, 1, 25), -- DEF +25
    (25696, 8, 12), -- STR +12
    (25696, 9, 12), -- DEX +12
    (25696, 23, 24), -- Attack +24
    (25696, 25, 24), -- Accuracy +24
    (25696, 73, 10), -- Store TP +10
    (25696, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES
    (11631, 0, 'Nigel_Ring', 'nigel_ring', 1, 59476, 99, 0, 18000);
REPLACE INTO `item_equipment` VALUES
    (11631, "nigels_cateye_ring", 72, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11631, 8, 8), -- STR +8
    (11631, 9, 12), -- DEX +12
    (11631, 23, 24), -- Attack +24
    (11631, 25, 26), -- Accuracy +26
    (11631, 73, 12), -- Store TP +12
    (11631, 384, 400), -- Haste +4%
    (11631, 165, 5); -- Crit Rate +5

-- =========================================================
-- TIGERS
-- =========================================================

-- Stripey Steve (lv22-28) — 19997-19999
REPLACE INTO `item_basic` VALUES
    (19997, 0, 'Steve_Stripe', 'steve_stripe', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (26011, 0, 'Steve_Fangs', 'steve_fangs', 1, 59476, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (26011, "steves_tiger_fangs", 16, 0, 131, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26011, 2, 20), -- HP +20
    (26011, 8, 3), -- STR +3
    (26011, 10, 3), -- VIT +3
    (26011, 23, 6), -- Attack +6
    (26011, 25, 5), -- Accuracy +5
    (26011, 421, 2); -- Crit Dmg. +2

REPLACE INTO `item_basic` VALUES
    (28615, 0, 'Steve_Mantle', 'steve_mantle', 1, 59476, 99, 0, 2200);
REPLACE INTO `item_equipment` VALUES
    (28615, "steves_pelt_mantle", 40, 0, 131, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28615, 1, 6), -- DEF +6
    (28615, 2, 70), -- HP +70
    (28615, 8, 9), -- STR +9
    (28615, 10, 9), -- VIT +9
    (28615, 23, 18), -- Attack +18
    (28615, 25, 15), -- Accuracy +15
    (28615, 421, 6); -- Crit Dmg. +6

-- Mauler Maurice (lv38-46) — 20000-20002
REPLACE INTO `item_basic` VALUES
    (20000, 0, 'Maurice_Hide', 'maurice_hide', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23712, 0, 'Maurice_Helm', 'maurice_helm', 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (23712, "maurices_savage_helm", 52, 0, 131, 164, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23712, 1, 12), -- DEF +12
    (23712, 2, 70), -- HP +70
    (23712, 8, 9), -- STR +9
    (23712, 10, 9), -- VIT +9
    (23712, 23, 18), -- Attack +18
    (23712, 25, 15), -- Accuracy +15
    (23712, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES
    (28447, 0, 'Maurice_Belt', 'maurice_belt', 1, 59476, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (28447, "maurices_mauler_belt", 63, 0, 10240, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28447, 1, 7), -- DEF +7
    (28447, 8, 12), -- STR +12
    (28447, 9, 12), -- DEX +12
    (28447, 23, 24), -- Attack +24
    (28447, 25, 24), -- Accuracy +24
    (28447, 73, 10), -- Store TP +10
    (28447, 384, 400); -- Haste +4%

-- Saber Sabrina (lv58-65) — 16464-16561
REPLACE INTO `item_basic` VALUES
    (16464, 0, 'Sbrn_Saber-Fang', 'sbrn_saberfang', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23265, 0, 'Sabrina_Legs', 'sabrina_legs', 1, 59476, 99, 0, 15000);
REPLACE INTO `item_equipment` VALUES
    (23265, "sabrinas_feral_legs", 67, 0, 10240, 67, 0, 0, 128, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23265, 1, 22), -- DEF +22
    (23265, 8, 12), -- STR +12
    (23265, 9, 12), -- DEX +12
    (23265, 23, 24), -- Attack +24
    (23265, 25, 24), -- Accuracy +24
    (23265, 73, 10), -- Store TP +10
    (23265, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES
    (11641, 0, 'Sabrina_Ring', 'sabrina_ring', 1, 59476, 99, 0, 20000);
REPLACE INTO `item_equipment` VALUES
    (11641, "sabrinas_apex_ring", 64, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11641, 8, 8), -- STR +8
    (11641, 9, 12), -- DEX +12
    (11641, 23, 24), -- Attack +24
    (11641, 25, 26), -- Accuracy +26
    (11641, 73, 12), -- Store TP +12
    (11641, 384, 400), -- Haste +4%
    (11641, 165, 5); -- Crit Rate +5

-- =========================================================
-- MANDRAGORAS
-- =========================================================

-- Root Rita (lv6-10) — 20003-20005
REPLACE INTO `item_basic` VALUES
    (20003, 0, 'Rita_Root', 'rita_root', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (27530, 0, 'Rita_Earring', 'rita_earring', 1, 59476, 99, 0, 10479);
REPLACE INTO `item_equipment` VALUES
    (27530, "ritas_leaf_earring", 11, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27530, 5, 15), -- MP +15
    (27530, 12, 3), -- INT +3
    (27530, 13, 2), -- MND +2
    (27530, 14, 2), -- CHR +2
    (27530, 28, 3), -- MAB +3
    (27530, 30, 3), -- MACC +3
    (27530, 562, 2), -- M.Crit +2
    (27530, 563, 3), -- M.Crit Dmg. +3
    (27530, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES
    (23533, 0, 'Rita_Wrist', 'rita_wrist', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (23533, "ritas_petal_wrist", 10, 0, 16924, 67, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23533, 1, 3), -- DEF +3
    (23533, 5, 15), -- MP +15
    (23533, 12, 3), -- INT +3
    (23533, 13, 2), -- MND +2
    (23533, 14, 2), -- CHR +2
    (23533, 28, 3), -- MAB +3
    (23533, 30, 3), -- MACC +3
    (23533, 562, 2), -- M.Crit +2
    (23533, 563, 3), -- M.Crit Dmg. +3
    (23533, 369, 1); -- Refresh +1

-- Sprout Spencer (lv22-28) — 20006-20008
REPLACE INTO `item_basic` VALUES
    (20006, 0, 'Spencer_Sprout', 'spencer_sprout', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23713, 0, 'Spencer_Hat', 'spencer_hat', 1, 59476, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (23713, "spencers_verdant_hat", 36, 0, 16924, 163, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23713, 1, 8), -- DEF +8
    (23713, 5, 30), -- MP +30
    (23713, 12, 6), -- INT +6
    (23713, 13, 4), -- MND +4
    (23713, 14, 4), -- CHR +4
    (23713, 28, 6), -- MAB +6
    (23713, 30, 6), -- MACC +6
    (23713, 562, 3), -- M.Crit +3
    (23713, 563, 5), -- M.Crit Dmg. +5
    (23713, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES
    (11632, 0, 'Spencer_Sash', 'spencer_sash', 1, 59476, 99, 0, 2200);
REPLACE INTO `item_equipment` VALUES
    (11632, "spencer_sash", 42, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11632, 5, 45), -- MP +45
    (11632, 12, 9), -- INT +9
    (11632, 13, 6), -- MND +6
    (11632, 14, 6), -- CHR +6
    (11632, 28, 9), -- MAB +9
    (11632, 30, 9), -- MACC +9
    (11632, 562, 4), -- M.Crit +4
    (11632, 563, 7), -- M.Crit Dmg. +7
    (11632, 369, 2); -- Refresh +2

-- Mandrake Max (lv40-48) — 20009-20011
REPLACE INTO `item_basic` VALUES
    (20009, 0, 'Max_Mandrake', 'max_mandrake', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23732, 0, 'Max_Shriek_Mask', 'max_shriek_mask', 1, 59476, 99, 0, 7000);
REPLACE INTO `item_equipment` VALUES
    (23732, "maxs_shriek_mask", 64, 0, 16924, 458, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23732, 1, 16), -- DEF +16
    (23732, 5, 60), -- MP +60
    (23732, 12, 12), -- INT +12
    (23732, 13, 8), -- MND +8
    (23732, 14, 8), -- CHR +8
    (23732, 28, 12), -- MAB +12
    (23732, 30, 12), -- MACC +12
    (23732, 562, 5), -- M.Crit +5
    (23732, 563, 10), -- M.Crit Dmg. +10
    (23732, 369, 3); -- Refresh +3

REPLACE INTO `item_basic` VALUES
    (28448, 0, 'Max_Belt', 'max_belt', 1, 59476, 99, 0, 10000);
REPLACE INTO `item_equipment` VALUES
    (28448, "maxs_earthscream_belt", 59, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28448, 1, 5), -- DEF +5
    (28448, 5, 45), -- MP +45
    (28448, 12, 9), -- INT +9
    (28448, 13, 6), -- MND +6
    (28448, 14, 6), -- CHR +6
    (28448, 28, 9), -- MAB +9
    (28448, 30, 9), -- MACC +9
    (28448, 562, 4), -- M.Crit +4
    (28448, 563, 7), -- M.Crit Dmg. +7
    (28448, 369, 2); -- Refresh +2

-- =========================================================
-- BEETLES
-- =========================================================

-- Click Clack Clayton (lv10-15) — 20012-20014
REPLACE INTO `item_basic` VALUES
    (20012, 0, 'Clytn_Clicking', 'clytn_clicking', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23259, 0, 'Clayton_Legs', 'clayton_legs', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (23259, "claytons_chitin_legs", 13, 0, 131, 211, 0, 0, 128, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23259, 1, 5), -- DEF +5
    (23259, 2, 20), -- HP +20
    (23259, 8, 3), -- STR +3
    (23259, 10, 3), -- VIT +3
    (23259, 23, 6), -- Attack +6
    (23259, 25, 5), -- Accuracy +5
    (23259, 421, 2); -- Crit Dmg. +2

REPLACE INTO `item_basic` VALUES
    (11634, 0, 'Clayton_Ring', 'clayton_ring', 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (11634, "claytons_clack_ring", 14, 0, 131, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11634, 2, 20), -- HP +20
    (11634, 8, 3), -- STR +3
    (11634, 10, 3), -- VIT +3
    (11634, 23, 6), -- Attack +6
    (11634, 25, 5), -- Accuracy +5
    (11634, 421, 2); -- Crit Dmg. +2

-- Dung Douglas (lv28-34) — 20015-20017
REPLACE INTO `item_basic` VALUES
    (20015, 0, 'Douglas_Ball', 'douglas_ball', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23783, 0, 'Douglas_Boots', 'douglas_boots', 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (23783, "douglass_roller_boots", 31, 0, 131, 467, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23783, 1, 6), -- DEF +6
    (23783, 2, 40), -- HP +40
    (23783, 8, 6), -- STR +6
    (23783, 10, 6), -- VIT +6
    (23783, 23, 12), -- Attack +12
    (23783, 25, 10), -- Accuracy +10
    (23783, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES
    (26012, 0, 'Douglas_Neck', 'douglas_neck', 1, 59476, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (26012, "douglass_carapace_necklace", 19, 0, 131, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26012, 2, 20), -- HP +20
    (26012, 8, 3), -- STR +3
    (26012, 10, 3), -- VIT +3
    (26012, 23, 6), -- Attack +6
    (26012, 25, 5), -- Accuracy +5
    (26012, 421, 2); -- Crit Dmg. +2

-- Scarab Sebastian (lv45-52) — 20018-20020
REPLACE INTO `item_basic` VALUES
    (20018, 0, 'Sbstn_Scarab', 'sbstn_scarab', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23738, 0, 'Sebastian_Helm', 'sebastian_helm', 1, 59476, 99, 0, 9000);
REPLACE INTO `item_equipment` VALUES
    (23738, "sebastians_sacred_helm", 65, 0, 131, 276, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23738, 1, 16), -- DEF +16
    (23738, 2, 100), -- HP +100
    (23738, 8, 12), -- STR +12
    (23738, 10, 12), -- VIT +12
    (23738, 23, 24), -- Attack +24
    (23738, 25, 20), -- Accuracy +20
    (23738, 421, 8); -- Crit Dmg. +8

REPLACE INTO `item_basic` VALUES
    (11635, 0, 'Sebastian_Ring', 'sebastian_ring', 1, 59476, 99, 0, 13000);
REPLACE INTO `item_equipment` VALUES
    (11635, "sebastians_jeweled_ring", 64, 0, 131, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11635, 2, 100), -- HP +100
    (11635, 8, 12), -- STR +12
    (11635, 10, 12), -- VIT +12
    (11635, 23, 24), -- Attack +24
    (11635, 25, 20), -- Accuracy +20
    (11635, 421, 8); -- Crit Dmg. +8

-- =========================================================
-- CRAWLERS
-- =========================================================

-- Silk Simon (lv15-20) — 20021-20023
REPLACE INTO `item_basic` VALUES
    (20021, 0, 'Simon_Thread', 'simon_thread', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23534, 0, 'Simon_Gloves', 'simon_gloves', 1, 59476, 99, 0, 1000);
REPLACE INTO `item_equipment` VALUES
    (23534, "simons_silk_gloves", 14, 0, 10240, 69, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23534, 1, 3), -- DEF +3
    (23534, 8, 3), -- STR +3
    (23534, 9, 3), -- DEX +3
    (23534, 23, 6), -- Attack +6
    (23534, 25, 6), -- Accuracy +6
    (23534, 73, 3), -- Store TP +3
    (23534, 384, 100); -- Haste +1%

REPLACE INTO `item_basic` VALUES
    (28616, 0, 'Simon_Cape', 'simon_cape', 1, 59476, 99, 0, 1500);
REPLACE INTO `item_equipment` VALUES
    (28616, "simons_webbed_cape", 11, 0, 263200, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28616, 1, 2), -- DEF +2
    (28616, 9, 3), -- DEX +3
    (28616, 11, 3), -- AGI +3
    (28616, 25, 5), -- Accuracy +5
    (28616, 26, 5), -- Rng. Acc. +5
    (28616, 23, 6), -- Attack +6
    (28616, 24, 6), -- Rng. Atk. +6
    (28616, 68, 5), -- Evasion +5
    (28616, 165, 2); -- Crit Rate +2

-- Cocoon Carl (lv50-58) — 20024-20026
REPLACE INTO `item_basic` VALUES
    (20024, 0, 'Carl_Shard', 'carl_shard', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25697, 0, 'Carl_Mail', 'carl_mail', 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (25697, "carls_chrysalis_mail", 65, 0, 131, 320, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25697, 1, 25), -- DEF +25
    (25697, 2, 100), -- HP +100
    (25697, 8, 12), -- STR +12
    (25697, 10, 12), -- VIT +12
    (25697, 23, 24), -- Attack +24
    (25697, 25, 20), -- Accuracy +20
    (25697, 421, 8); -- Crit Dmg. +8

REPLACE INTO `item_basic` VALUES
    (14646, 0, 'Carl_Ring', 'carl_ring', 1, 59476, 99, 0, 16000);
REPLACE INTO `item_equipment` VALUES
    (14646, "carls_metamorph_ring", 64, 0, 131, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (14646, 2, 100), -- HP +100
    (14646, 8, 12), -- STR +12
    (14646, 10, 12), -- VIT +12
    (14646, 23, 24), -- Attack +24
    (14646, 25, 20), -- Accuracy +20
    (14646, 421, 8); -- Crit Dmg. +8

-- =========================================================
-- BIRDS
-- =========================================================

-- Feather Fred (lv10-15) — 20027-20029
REPLACE INTO `item_basic` VALUES
    (20027, 0, 'Fred_Feather', 'fred_feather', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (25698, 0, 'Fred_Down_Vest', 'fred_down_vest', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (25698, "freds_down_vest", 11, 0, 263200, 322, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25698, 1, 6), -- DEF +6
    (25698, 9, 3), -- DEX +3
    (25698, 11, 3), -- AGI +3
    (25698, 25, 5), -- Accuracy +5
    (25698, 26, 5), -- Rng. Acc. +5
    (25698, 23, 6), -- Attack +6
    (25698, 24, 6), -- Rng. Atk. +6
    (25698, 68, 5), -- Evasion +5
    (25698, 165, 2); -- Crit Rate +2

REPLACE INTO `item_basic` VALUES
    (15549, 0, 'Fred_Ear', 'fred_ear', 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (15549, "fred_ear", 11, 0, 263200, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15549, 9, 3), -- DEX +3
    (15549, 11, 3), -- AGI +3
    (15549, 25, 5), -- Accuracy +5
    (15549, 26, 5), -- Rng. Acc. +5
    (15549, 23, 6), -- Attack +6
    (15549, 24, 6), -- Rng. Atk. +6
    (15549, 68, 5), -- Evasion +5
    (15549, 165, 2); -- Crit Rate +2

-- Beaky Beatrice (lv28-35) — 20030-20032
REPLACE INTO `item_basic` VALUES
    (20030, 0, 'Beatrice_Tip', 'beatrice_tip', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23739, 0, 'Beatrice_Hat', 'beatrice_hat', 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (23739, "beatrices_plume_hat", 40, 0, 263200, 252, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23739, 1, 12), -- DEF +12
    (23739, 9, 9), -- DEX +9
    (23739, 11, 9), -- AGI +9
    (23739, 25, 15), -- Accuracy +15
    (23739, 26, 15), -- Rng. Acc. +15
    (23739, 23, 18), -- Attack +18
    (23739, 24, 18), -- Rng. Atk. +18
    (23739, 68, 15), -- Evasion +15
    (23739, 165, 4); -- Crit Rate +4

REPLACE INTO `item_basic` VALUES
    (27531, 0, 'Btrc_Earring', 'btrc_earring', 1, 59476, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (27531, "beatrices_wind_earring", 48, 0, 263200, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27531, 9, 9), -- DEX +9
    (27531, 11, 9), -- AGI +9
    (27531, 25, 15), -- Accuracy +15
    (27531, 26, 15), -- Rng. Acc. +15
    (27531, 23, 18), -- Attack +18
    (27531, 24, 18), -- Rng. Atk. +18
    (27531, 68, 15), -- Evasion +15
    (27531, 165, 4); -- Crit Rate +4

-- Plume Patricia (lv50-58) — 20033-20035
REPLACE INTO `item_basic` VALUES
    (20033, 0, 'Patricia_Plume', 'patricia_plume', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25699, 0, 'Patricia_Vest', 'patricia_vest', 1, 59476, 99, 0, 12000);
REPLACE INTO `item_equipment` VALUES
    (25699, "patricias_zephyr_vest", 71, 0, 263200, 322, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25699, 1, 25), -- DEF +25
    (25699, 9, 12), -- DEX +12
    (25699, 11, 12), -- AGI +12
    (25699, 25, 20), -- Accuracy +20
    (25699, 26, 20), -- Rng. Acc. +20
    (25699, 23, 24), -- Attack +24
    (25699, 24, 24), -- Rng. Atk. +24
    (25699, 68, 20), -- Evasion +20
    (25699, 165, 5); -- Crit Rate +5

REPLACE INTO `item_basic` VALUES
    (15550, 0, 'Plume_Cape', 'plume_cape', 1, 59476, 99, 0, 16000);
REPLACE INTO `item_equipment` VALUES
    (15550, "plume_cape", 70, 0, 263200, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15550, 9, 12), -- DEX +12
    (15550, 11, 12), -- AGI +12
    (15550, 25, 20), -- Accuracy +20
    (15550, 26, 20), -- Rng. Acc. +20
    (15550, 23, 24), -- Attack +24
    (15550, 24, 24), -- Rng. Atk. +24
    (15550, 68, 20), -- Evasion +20
    (15550, 165, 5); -- Crit Rate +5

-- =========================================================
-- BEES
-- =========================================================

-- Honey Harold (lv10-15) — 20036-20038
REPLACE INTO `item_basic` VALUES
    (20036, 0, 'Hrld_Honeycomb', 'hrld_honeycomb', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (27532, 0, 'Harold_Earring', 'harold_earring', 1, 59476, 99, 0, 600);
REPLACE INTO `item_equipment` VALUES
    (27532, "harolds_honey_earring", 7, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27532, 5, 15), -- MP +15
    (27532, 12, 3), -- INT +3
    (27532, 13, 2), -- MND +2
    (27532, 14, 2), -- CHR +2
    (27532, 28, 3), -- MAB +3
    (27532, 30, 3), -- MACC +3
    (27532, 562, 2), -- M.Crit +2
    (27532, 563, 3), -- M.Crit Dmg. +3
    (27532, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES
    (15780, 0, 'Harold_Ring', 'harold_ring', 1, 59476, 99, 0, 900);
REPLACE INTO `item_equipment` VALUES
    (15780, "harolds_stinger_ring", 11, 0, 10240, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15780, 8, 3), -- STR +3
    (15780, 9, 3), -- DEX +3
    (15780, 23, 6), -- Attack +6
    (15780, 25, 6), -- Accuracy +6
    (15780, 73, 3), -- Store TP +3
    (15780, 384, 100); -- Haste +1%

-- Buzzard Barry (lv30-38) — 20039-20041
REPLACE INTO `item_basic` VALUES
    (20039, 0, 'Barry_Wing', 'barry_wing', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23535, 0, 'Barry_Gauntlets', 'barry_gauntlets', 1, 59476, 99, 0, 4000);
REPLACE INTO `item_equipment` VALUES
    (23535, "barrys_venom_gauntlets", 56, 0, 131, 71, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23535, 1, 9), -- DEF +9
    (23535, 2, 70), -- HP +70
    (23535, 8, 9), -- STR +9
    (23535, 10, 9), -- VIT +9
    (23535, 23, 18), -- Attack +18
    (23535, 25, 15), -- Accuracy +15
    (23535, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES
    (26013, 0, 'Barry_Necklace', 'barry_necklace', 1, 59476, 99, 0, 6000);
REPLACE INTO `item_equipment` VALUES
    (26013, "barrys_swarm_necklace", 37, 0, 10240, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26013, 8, 6), -- STR +6
    (26013, 9, 6), -- DEX +6
    (26013, 23, 12), -- Attack +12
    (26013, 25, 12), -- Accuracy +12
    (26013, 73, 5), -- Store TP +5
    (26013, 384, 200); -- Haste +2%

-- Queen Quentin (lv62-70) — 20042-20044
REPLACE INTO `item_basic` VALUES
    (20042, 0, 'Quentin_Jelly', 'quentin_jelly', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23740, 0, 'Quentin_Crown', 'quentin_crown', 1, 59476, 99, 0, 18000);
REPLACE INTO `item_equipment` VALUES
    (23740, "quentins_royal_crown", 69, 0, 16924, 267, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23740, 1, 16), -- DEF +16
    (23740, 5, 60), -- MP +60
    (23740, 12, 12), -- INT +12
    (23740, 13, 8), -- MND +8
    (23740, 14, 8), -- CHR +8
    (23740, 28, 12), -- MAB +12
    (23740, 30, 12), -- MACC +12
    (23740, 562, 5), -- M.Crit +5
    (23740, 563, 10), -- M.Crit Dmg. +10
    (23740, 369, 3); -- Refresh +3

REPLACE INTO `item_basic` VALUES
    (15781, 0, 'Quentin_Ring', 'quentin_ring', 1, 59476, 99, 0, 22000);
REPLACE INTO `item_equipment` VALUES
    (15781, "quentins_hivemind_ring", 68, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15781, 5, 60), -- MP +60
    (15781, 12, 12), -- INT +12
    (15781, 13, 8), -- MND +8
    (15781, 14, 8), -- CHR +8
    (15781, 28, 12), -- MAB +12
    (15781, 30, 12), -- MACC +12
    (15781, 562, 5), -- M.Crit +5
    (15781, 563, 10), -- M.Crit Dmg. +10
    (15781, 369, 3); -- Refresh +3

-- =========================================================
-- WORMS
-- =========================================================

-- Wiggles Winston (lv1-5) — 20045-20047
REPLACE INTO `item_basic` VALUES
    (20045, 0, 'Winston_Wiggle', 'winston_wiggle', 1, 59476, 99, 0, 20);

REPLACE INTO `item_basic` VALUES
    (15794, 0, 'Winston_Ring', 'winston_ring', 1, 59476, 99, 0, 150);
REPLACE INTO `item_equipment` VALUES
    (15794, "winstons_dirt_ring", 6, 0, 131, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15794, 2, 20), -- HP +20
    (15794, 8, 3), -- STR +3
    (15794, 10, 3), -- VIT +3
    (15794, 23, 6), -- Attack +6
    (15794, 25, 5), -- Accuracy +5
    (15794, 421, 2); -- Crit Dmg. +2

REPLACE INTO `item_basic` VALUES
    (28449, 0, 'Winston_Belt', 'winston_belt', 1, 59476, 99, 0, 250);
REPLACE INTO `item_equipment` VALUES
    (28449, "winstons_earthen_belt", 5, 0, 131, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28449, 1, 1), -- DEF +1
    (28449, 2, 20), -- HP +20
    (28449, 8, 3), -- STR +3
    (28449, 10, 3), -- VIT +3
    (28449, 23, 6), -- Attack +6
    (28449, 25, 5), -- Accuracy +5
    (28449, 421, 2); -- Crit Dmg. +2

-- Squirmy Sherman (lv18-24) — 20048-20050
REPLACE INTO `item_basic` VALUES
    (20048, 0, 'Sherman_Squirm', 'sherman_squirm', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (23755, 0, 'Sherman_Helm', 'sherman_helm', 1, 59476, 99, 0, 1200);
REPLACE INTO `item_equipment` VALUES
    (23755, "shermans_subterran_helm", 23, 0, 131, 464, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23755, 1, 8), -- DEF +8
    (23755, 2, 40), -- HP +40
    (23755, 8, 6), -- STR +6
    (23755, 10, 6), -- VIT +6
    (23755, 23, 12), -- Attack +12
    (23755, 25, 10), -- Accuracy +10
    (23755, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES
    (27533, 0, 'Sherman_Earring', 'sherman_earring', 1, 59476, 99, 0, 1800);
REPLACE INTO `item_equipment` VALUES
    (27533, "shermans_tunnel_earring", 23, 0, 131, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27533, 2, 40), -- HP +40
    (27533, 8, 6), -- STR +6
    (27533, 10, 6), -- VIT +6
    (27533, 23, 12), -- Attack +12
    (27533, 25, 10), -- Accuracy +10
    (27533, 421, 4); -- Crit Dmg. +4

-- Earthcrawler Ernest (lv40-48) — 16570-16574
REPLACE INTO `item_basic` VALUES
    (16570, 0, 'Ernest_Earthen', 'ernest_earthen', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25689, 0, 'Ernest_Vest', 'ernest_vest', 1, 59476, 99, 0, 8000);
REPLACE INTO `item_equipment` VALUES
    (25689, "ernests_burrower_vest", 53, 0, 131, 322, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25689, 1, 18), -- DEF +18
    (25689, 2, 70), -- HP +70
    (25689, 8, 9), -- STR +9
    (25689, 10, 9), -- VIT +9
    (25689, 23, 18), -- Attack +18
    (25689, 25, 15), -- Accuracy +15
    (25689, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES
    (23750, 0, 'Ernest_Boots', 'ernest_boots', 1, 59476, 99, 0, 11000);
REPLACE INTO `item_equipment` VALUES
    (23750, "ernests_tremor_boots", 53, 0, 131, 276, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23750, 1, 9), -- DEF +9
    (23750, 2, 70), -- HP +70
    (23750, 8, 9), -- STR +9
    (23750, 10, 9), -- VIT +9
    (23750, 23, 18), -- Attack +18
    (23750, 25, 15), -- Accuracy +15
    (23750, 421, 6); -- Crit Dmg. +6

-- =========================================================
-- LIZARDS
-- =========================================================

-- Scaly Sally (lv8-12) — 16715-17084
REPLACE INTO `item_basic` VALUES
    (16715, 0, 'Sally_Chip', 'sally_chip', 1, 59476, 99, 0, 50);

REPLACE INTO `item_basic` VALUES
    (11642, 0, 'Sally_Scale', 'sally_scale', 1, 59476, 99, 0, 28624);
REPLACE INTO `item_equipment` VALUES
    (11642, "sally_scale", 12, 0, 263200, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11642, 9, 3), -- DEX +3
    (11642, 11, 3), -- AGI +3
    (11642, 25, 5), -- Accuracy +5
    (11642, 26, 5), -- Rng. Acc. +5
    (11642, 23, 6), -- Attack +6
    (11642, 24, 6), -- Rng. Atk. +6
    (11642, 68, 5), -- Evasion +5
    (11642, 165, 2); -- Crit Rate +2

REPLACE INTO `item_basic` VALUES
    (28440, 0, 'Sally_Belt', 'sally_belt', 1, 59476, 99, 0, 14337);
REPLACE INTO `item_equipment` VALUES
    (28440, "sallys_tail_belt", 14, 0, 10240, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28440, 1, 1), -- DEF +1
    (28440, 8, 3), -- STR +3
    (28440, 9, 3), -- DEX +3
    (28440, 23, 6), -- Attack +6
    (28440, 25, 6), -- Accuracy +6
    (28440, 73, 3), -- Store TP +3
    (28440, 384, 100); -- Haste +1%

-- Cold-blooded Carlos (lv30-36) — 17107-17168
REPLACE INTO `item_basic` VALUES
    (17107, 0, 'Carlos_Cold', 'carlos_cold', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25690, 0, 'Carlos_Vest', 'carlos_vest', 1, 59476, 99, 0, 4500);
REPLACE INTO `item_equipment` VALUES
    (25690, "carloss_reptile_vest", 41, 0, 131, 321, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25690, 1, 18), -- DEF +18
    (25690, 2, 70), -- HP +70
    (25690, 8, 9), -- STR +9
    (25690, 10, 9), -- VIT +9
    (25690, 23, 18), -- Attack +18
    (25690, 25, 15), -- Accuracy +15
    (25690, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES
    (26118, 0, 'Carlos_Earring', 'carlos_earring', 1, 59476, 99, 0, 6500);
REPLACE INTO `item_equipment` VALUES
    (26118, "carloss_venom_earring", 44, 0, 263200, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26118, 9, 9), -- DEX +9
    (26118, 11, 9), -- AGI +9
    (26118, 25, 15), -- Accuracy +15
    (26118, 26, 15), -- Rng. Acc. +15
    (26118, 23, 18), -- Attack +18
    (26118, 24, 18), -- Rng. Atk. +18
    (26118, 68, 15), -- Evasion +15
    (26118, 165, 4); -- Crit Rate +4

-- Basilisk Boris (lv52-60) — 17169-17752
REPLACE INTO `item_basic` VALUES
    (17169, 0, 'Boris_Basilisk', 'boris_basilisk', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (25691, 0, 'Boris_Carapace', 'boris_carapace', 1, 59476, 99, 0, 13000);
REPLACE INTO `item_equipment` VALUES
    (25691, "boriss_granite_carapace", 62, 0, 131, 321, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25691, 1, 25), -- DEF +25
    (25691, 2, 100), -- HP +100
    (25691, 8, 12), -- STR +12
    (25691, 10, 12), -- VIT +12
    (25691, 23, 24), -- Attack +24
    (25691, 25, 20), -- Accuracy +20
    (25691, 421, 8); -- Crit Dmg. +8

REPLACE INTO `item_basic` VALUES
    (11643, 0, 'Boris_Gaze_Ring', 'boris_gaze_ring', 1, 59476, 99, 0, 17000);
REPLACE INTO `item_equipment` VALUES
    (11643, "boriss_stone_gaze_ring", 62, 0, 131, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11643, 2, 100), -- HP +100
    (11643, 8, 12), -- STR +12
    (11643, 10, 12), -- VIT +12
    (11643, 23, 24), -- Attack +24
    (11643, 25, 20), -- Accuracy +20
    (11643, 421, 8); -- Crit Dmg. +8

-- =========================================================
-- THE JIMS (goblin comedy duo)
-- =========================================================

-- Little Jim (lv25-32, he's enormous) — 20051-20053
REPLACE INTO `item_basic` VALUES
    (20051, 0, 'LttlJm_Trophy', 'lttljm_trophy', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23784, 0, 'LittleJim_Boots', 'littlejim_boots', 1, 59476, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (23784, "little_jim_boots", 52, 0, 131, 465, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23784, 1, 9), -- DEF +9
    (23784, 2, 70), -- HP +70
    (23784, 8, 9), -- STR +9
    (23784, 10, 9), -- VIT +9
    (23784, 23, 18), -- Attack +18
    (23784, 25, 15), -- Accuracy +15
    (23784, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES
    (15795, 0, 'Little_Jim_Ring', 'little_jim_ring', 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (15795, "little_jim_ring", 53, 0, 131, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15795, 2, 70), -- HP +70
    (15795, 8, 9), -- STR +9
    (15795, 10, 9), -- VIT +9
    (15795, 23, 18), -- Attack +18
    (15795, 25, 15), -- Accuracy +15
    (15795, 421, 6); -- Crit Dmg. +6

-- Big Jim (lv25-32, he's tiny) — 20054-20056
REPLACE INTO `item_basic` VALUES
    (20054, 0, 'Big_Jim_Trophy', 'big_jim_trophy', 1, 59476, 99, 0, 100);

REPLACE INTO `item_basic` VALUES
    (23756, 0, 'Big_Jim_Hat', 'big_jim_hat', 1, 59476, 99, 0, 2000);
REPLACE INTO `item_equipment` VALUES
    (23756, "big_jim_hat", 52, 0, 263200, 465, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23756, 1, 12), -- DEF +12
    (23756, 9, 9), -- DEX +9
    (23756, 11, 9), -- AGI +9
    (23756, 25, 15), -- Accuracy +15
    (23756, 26, 15), -- Rng. Acc. +15
    (23756, 23, 18), -- Attack +18
    (23756, 24, 18), -- Rng. Atk. +18
    (23756, 68, 15), -- Evasion +15
    (23756, 165, 4); -- Crit Rate +4

REPLACE INTO `item_basic` VALUES
    (15796, 0, 'Big_Jim_Cape', 'big_jim_cape', 1, 59476, 99, 0, 3000);
REPLACE INTO `item_equipment` VALUES
    (15796, "big_jim_cape", 59, 0, 263200, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15796, 9, 9), -- DEX +9
    (15796, 11, 9), -- AGI +9
    (15796, 25, 15), -- Accuracy +15
    (15796, 26, 15), -- Rng. Acc. +15
    (15796, 23, 18), -- Attack +18
    (15796, 24, 18), -- Rng. Atk. +18
    (15796, 68, 15), -- Evasion +15
    (15796, 165, 4); -- Crit Rate +4

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
REPLACE INTO `item_equipment` VALUES (23757, "WnfrdWCap", 26, 0, 131, 466, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23757, 1, 8), -- DEF +8
    (23757, 2, 40), -- HP +40
    (23757, 8, 6), -- STR +6
    (23757, 10, 6), -- VIT +6
    (23757, 23, 12), -- Attack +12
    (23757, 25, 10), -- Accuracy +10
    (23757, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (23536, 0, 'Wnfrd_Mittens', 'wnfrd_mittens', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23536, "WnfrdWMit", 27, 0, 16924, 73, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23536, 1, 6), -- DEF +6
    (23536, 5, 30), -- MP +30
    (23536, 12, 6), -- INT +6
    (23536, 13, 4), -- MND +4
    (23536, 14, 4), -- CHR +4
    (23536, 28, 6), -- MAB +6
    (23536, 30, 6), -- MACC +6
    (23536, 562, 3), -- M.Crit +3
    (23536, 563, 5), -- M.Crit Dmg. +5
    (23536, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (339, 0, 'Beatrice_Foot', 'beatrice_foot', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23786, 0, 'Beatrice_Shoes', 'beatrice_shoes', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23786, "BtrceSShoe", 27, 0, 131, 467, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23786, 1, 6), -- DEF +6
    (23786, 2, 40), -- HP +40
    (23786, 8, 6), -- STR +6
    (23786, 10, 6), -- VIT +6
    (23786, 23, 12), -- Attack +12
    (23786, 25, 10), -- Accuracy +10
    (23786, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (23260, 0, 'Beatrice_Hakama', 'beatrice_hakama', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23260, "BtrceHHkm", 28, 0, 16924, 211, 0, 0, 128, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23260, 1, 10), -- DEF +10
    (23260, 5, 30), -- MP +30
    (23260, 12, 6), -- INT +6
    (23260, 13, 4), -- MND +4
    (23260, 14, 4), -- CHR +4
    (23260, 28, 6), -- MAB +6
    (23260, 30, 6), -- MACC +6
    (23260, 562, 3), -- M.Crit +3
    (23260, 563, 5), -- M.Crit Dmg. +5
    (23260, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (342, 0, 'Clyde_Shard', 'clyde_shard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23537, 0, 'Clyde_Gauntlets', 'clyde_gauntlets', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23537, "ClydeCGnt", 27, 0, 131, 75, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23537, 1, 6), -- DEF +6
    (23537, 2, 40), -- HP +40
    (23537, 8, 6), -- STR +6
    (23537, 10, 6), -- VIT +6
    (23537, 23, 12), -- Attack +12
    (23537, 25, 10), -- Accuracy +10
    (23537, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (28450, 0, 'Clyde_Belt', 'clyde_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28450, "ClydePBlt", 21, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28450, 1, 3), -- DEF +3
    (28450, 5, 30), -- MP +30
    (28450, 12, 6), -- INT +6
    (28450, 13, 4), -- MND +4
    (28450, 14, 4), -- CHR +4
    (28450, 28, 6), -- MAB +6
    (28450, 30, 6), -- MACC +6
    (28450, 562, 3), -- M.Crit +3
    (28450, 563, 5), -- M.Crit Dmg. +5
    (28450, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (345, 0, 'Srphn_Trinket', 'srphn_trinket', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23787, 0, 'Seraphine_Boots', 'seraphine_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23787, "SrphnSBts", 17, 0, 263200, 468, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23787, 1, 3), -- DEF +3
    (23787, 9, 3), -- DEX +3
    (23787, 11, 3), -- AGI +3
    (23787, 25, 5), -- Accuracy +5
    (23787, 26, 5), -- Rng. Acc. +5
    (23787, 23, 6), -- Attack +6
    (23787, 24, 6), -- Rng. Atk. +6
    (23787, 68, 5), -- Evasion +5
    (23787, 165, 2); -- Crit Rate +2

REPLACE INTO `item_basic` VALUES (15798, 0, 'Seraphine_Ring', 'seraphine_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (15798, "SrphnRRng", 39, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15798, 5, 30), -- MP +30
    (15798, 12, 6), -- INT +6
    (15798, 13, 4), -- MND +4
    (15798, 14, 4), -- CHR +4
    (15798, 28, 6), -- MAB +6
    (15798, 30, 6), -- MACC +6
    (15798, 562, 3), -- M.Crit +3
    (15798, 563, 5), -- M.Crit Dmg. +5
    (15798, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (348, 0, 'Crdl_Whisker', 'crdl_whisker', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27536, 0, 'Crdl_Earring', 'crdl_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27536, "CrdelaEar", 39, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27536, 5, 30), -- MP +30
    (27536, 12, 6), -- INT +6
    (27536, 13, 4), -- MND +4
    (27536, 14, 4), -- CHR +4
    (27536, 28, 6), -- MAB +6
    (27536, 30, 6), -- MACC +6
    (27536, 562, 3), -- M.Crit +3
    (27536, 563, 5), -- M.Crit Dmg. +5
    (27536, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28619, 0, 'Cordelia_Mantle', 'cordelia_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28619, "CrdelasMnt", 40, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28619, 1, 6), -- DEF +6
    (28619, 5, 45), -- MP +45
    (28619, 12, 9), -- INT +9
    (28619, 13, 6), -- MND +6
    (28619, 14, 6), -- CHR +6
    (28619, 28, 9), -- MAB +9
    (28619, 30, 9), -- MACC +9
    (28619, 562, 4), -- M.Crit +4
    (28619, 563, 7), -- M.Crit Dmg. +7
    (28619, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (351, 0, 'Frederica_Fang', 'frederica_fang', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28618, 0, 'Frederica_Cloak', 'frederica_cloak', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28618, "FrdrcaClk", 40, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28618, 1, 6), -- DEF +6
    (28618, 5, 45), -- MP +45
    (28618, 12, 9), -- INT +9
    (28618, 13, 6), -- MND +6
    (28618, 14, 6), -- CHR +6
    (28618, 28, 9), -- MAB +9
    (28618, 30, 9), -- MACC +9
    (28618, 562, 4), -- M.Crit +4
    (28618, 563, 7), -- M.Crit Dmg. +7
    (28618, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (23261, 0, 'Frederica_Hose', 'frederica_hose', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23261, "FrdrcaHse", 34, 0, 131, 214, 0, 0, 128, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23261, 1, 10), -- DEF +10
    (23261, 2, 40), -- HP +40
    (23261, 8, 6), -- STR +6
    (23261, 10, 6), -- VIT +6
    (23261, 23, 12), -- Attack +12
    (23261, 25, 10), -- Accuracy +10
    (23261, 421, 4); -- Crit Dmg. +4
REPLACE INTO `item_basic` VALUES (354, 0, 'Millicent_Petal', 'millicent_petal', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23758, 0, 'Mllcnt_Headband', 'mllcnt_headband', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23758, "MllcntHbd", 63, 0, 263200, 467, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23758, 1, 16), -- DEF +16
    (23758, 9, 12), -- DEX +12
    (23758, 11, 12), -- AGI +12
    (23758, 25, 20), -- Accuracy +20
    (23758, 26, 20), -- Rng. Acc. +20
    (23758, 23, 24), -- Attack +24
    (23758, 24, 24), -- Rng. Atk. +24
    (23758, 68, 20), -- Evasion +20
    (23758, 165, 5); -- Crit Rate +5

REPLACE INTO `item_basic` VALUES (23538, 0, 'Mllcnt_Gloves', 'mllcnt_gloves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23538, "MllcntGGl", 21, 0, 16924, 77, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23538, 1, 6), -- DEF +6
    (23538, 5, 30), -- MP +30
    (23538, 12, 6), -- INT +6
    (23538, 13, 4), -- MND +4
    (23538, 14, 4), -- CHR +4
    (23538, 28, 6), -- MAB +6
    (23538, 30, 6), -- MACC +6
    (23538, 562, 3), -- M.Crit +3
    (23538, 563, 5), -- M.Crit Dmg. +5
    (23538, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (357, 0, 'Brndn_Carapace', 'brndn_carapace', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25700, 0, 'Brn_Breastplate', 'brn_breastplate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25700, "BrndnABpl", 38, 0, 131, 321, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25700, 1, 12), -- DEF +12
    (25700, 2, 40), -- HP +40
    (25700, 8, 6), -- STR +6
    (25700, 10, 6), -- VIT +6
    (25700, 23, 12), -- Attack +12
    (25700, 25, 10), -- Accuracy +10
    (25700, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (23788, 0, 'Brendan_Greaves', 'brendan_greaves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23788, "BrndnIGrv", 36, 0, 16924, 469, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23788, 1, 6), -- DEF +6
    (23788, 5, 30), -- MP +30
    (23788, 12, 6), -- INT +6
    (23788, 13, 4), -- MND +4
    (23788, 14, 4), -- CHR +4
    (23788, 28, 6), -- MAB +6
    (23788, 30, 6), -- MACC +6
    (23788, 562, 3), -- M.Crit +3
    (23788, 563, 5), -- M.Crit Dmg. +5
    (23788, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (360, 0, 'Grt_Tailfeather', 'grt_tailfeather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28599, 0, 'Gertrude_Mantle', 'gertrude_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28599, "GrtrdGMnt", 41, 0, 263200, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28599, 1, 6), -- DEF +6
    (28599, 9, 9), -- DEX +9
    (28599, 11, 9), -- AGI +9
    (28599, 25, 15), -- Accuracy +15
    (28599, 26, 15), -- Rng. Acc. +15
    (28599, 23, 18), -- Attack +18
    (28599, 24, 18), -- Rng. Atk. +18
    (28599, 68, 15), -- Evasion +15
    (28599, 165, 4); -- Crit Rate +4

REPLACE INTO `item_basic` VALUES (23706, 0, 'Gertrude_Shoes', 'gertrude_shoes', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23706, "GrtrdWShs", 44, 0, 16924, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23706, 1, 9), -- DEF +9
    (23706, 5, 45), -- MP +45
    (23706, 12, 9), -- INT +9
    (23706, 13, 6), -- MND +6
    (23706, 14, 6), -- CHR +6
    (23706, 28, 9), -- MAB +9
    (23706, 30, 9), -- MACC +9
    (23706, 562, 4), -- M.Crit +4
    (23706, 563, 7), -- M.Crit Dmg. +7
    (23706, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (363, 0, 'Vlntn_Stinger', 'vlntn_stinger', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23759, 0, 'Vlntn_Hairpin', 'vlntn_hairpin', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23759, "VlntnHHpn", 25, 0, 16924, 468, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23759, 1, 8), -- DEF +8
    (23759, 5, 30), -- MP +30
    (23759, 12, 6), -- INT +6
    (23759, 13, 4), -- MND +4
    (23759, 14, 4), -- CHR +4
    (23759, 28, 6), -- MAB +6
    (23759, 30, 6), -- MACC +6
    (23759, 562, 3), -- M.Crit +3
    (23759, 563, 5), -- M.Crit Dmg. +5
    (23759, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (15797, 0, 'Valentina_Ring', 'valentina_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (15797, "VlntnVRng", 61, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15797, 5, 60), -- MP +60
    (15797, 12, 12), -- INT +12
    (15797, 13, 8), -- MND +8
    (15797, 14, 8), -- CHR +8
    (15797, 28, 12), -- MAB +12
    (15797, 30, 12), -- MACC +12
    (15797, 562, 5), -- M.Crit +5
    (15797, 563, 10), -- M.Crit Dmg. +10
    (15797, 369, 3); -- Refresh +3
REPLACE INTO `item_basic` VALUES (366, 0, 'Deidre_Earthen', 'deidre_earthen', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (24076, 0, 'Deidre_Boots', 'deidre_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (24076, "DdrBrwBts", 28, 0, 131, 172, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (24076, 1, 6), -- DEF +6
    (24076, 2, 40), -- HP +40
    (24076, 8, 6), -- STR +6
    (24076, 10, 6), -- VIT +6
    (24076, 23, 12), -- Attack +12
    (24076, 25, 10), -- Accuracy +10
    (24076, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (28451, 0, 'Deidre_Belt', 'deidre_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28451, "DdrMdsBlt", 22, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28451, 1, 3), -- DEF +3
    (28451, 5, 30), -- MP +30
    (28451, 12, 6), -- INT +6
    (28451, 13, 4), -- MND +4
    (28451, 14, 4), -- CHR +4
    (28451, 28, 6), -- MAB +6
    (28451, 30, 6), -- MACC +6
    (28451, 562, 3), -- M.Crit +3
    (28451, 563, 5), -- M.Crit Dmg. +5
    (28451, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (369, 0, 'Vincenzo_Scale', 'vincenzo_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23252, 0, 'Vncnz_Cuisses', 'vncnz_cuisses', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23252, "VncznSCss", 40, 0, 131, 86, 0, 0, 128, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23252, 1, 16), -- DEF +16
    (23252, 2, 70), -- HP +70
    (23252, 8, 9), -- STR +9
    (23252, 10, 9), -- VIT +9
    (23252, 23, 18), -- Attack +18
    (23252, 25, 15), -- Accuracy +15
    (23252, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES (11665, 0, 'Vincenzo_Ring', 'vincenzo_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11665, "VncznTRng", 38, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11665, 5, 30), -- MP +30
    (11665, 12, 6), -- INT +6
    (11665, 13, 4), -- MND +4
    (11665, 14, 4), -- CHR +4
    (11665, 28, 6), -- MAB +6
    (11665, 30, 6), -- MACC +6
    (11665, 562, 3), -- M.Crit +3
    (11665, 563, 5), -- M.Crit Dmg. +5
    (11665, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (372, 0, 'Gideon_Axe', 'gideon_axe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23511, 0, 'Gideon_Armband', 'gideon_armband', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23511, "GdnSArmb", 8, 0, 16924, 68, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23511, 1, 3), -- DEF +3
    (23511, 5, 15), -- MP +15
    (23511, 12, 3), -- INT +3
    (23511, 13, 2), -- MND +2
    (23511, 14, 2), -- CHR +2
    (23511, 28, 3), -- MAB +3
    (23511, 30, 3), -- MACC +3
    (23511, 562, 2), -- M.Crit +2
    (23511, 563, 3), -- M.Crit Dmg. +3
    (23511, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28430, 0, 'Gideon_Belt', 'gideon_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28430, "GdnGBlt", 12, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28430, 1, 1), -- DEF +1
    (28430, 5, 15), -- MP +15
    (28430, 12, 3), -- INT +3
    (28430, 13, 2), -- MND +2
    (28430, 14, 2), -- CHR +2
    (28430, 28, 3), -- MAB +3
    (28430, 30, 3), -- MACC +3
    (28430, 562, 2), -- M.Crit +2
    (28430, 563, 3), -- M.Crit Dmg. +3
    (28430, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (375, 0, 'Sven_Medal', 'sven_medal', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23418, 0, 'Sven_Helm', 'sven_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23418, "SvnWCHlm", 29, 0, 16924, 310, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23418, 1, 8), -- DEF +8
    (23418, 5, 30), -- MP +30
    (23418, 12, 6), -- INT +6
    (23418, 13, 4), -- MND +4
    (23418, 14, 4), -- CHR +4
    (23418, 28, 6), -- MAB +6
    (23418, 30, 6), -- MACC +6
    (23418, 562, 3), -- M.Crit +3
    (23418, 563, 5), -- M.Crit Dmg. +5
    (23418, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28604, 0, 'Sven_Mantle', 'sven_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28604, "SvnBtlMnt", 25, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28604, 1, 4), -- DEF +4
    (28604, 5, 30), -- MP +30
    (28604, 12, 6), -- INT +6
    (28604, 13, 4), -- MND +4
    (28604, 14, 4), -- CHR +4
    (28604, 28, 6), -- MAB +6
    (28604, 30, 6), -- MACC +6
    (28604, 562, 3), -- M.Crit +3
    (28604, 563, 5), -- M.Crit Dmg. +5
    (28604, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (378, 0, 'Rgnld_Standard', 'rgnld_standard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25701, 0, 'Rgnld_Hauberk', 'rgnld_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25701, "RgnldWHbk", 37, 0, 131, 321, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25701, 1, 12), -- DEF +12
    (25701, 2, 40), -- HP +40
    (25701, 8, 6), -- STR +6
    (25701, 10, 6), -- VIT +6
    (25701, 23, 12), -- Attack +12
    (25701, 25, 10), -- Accuracy +10
    (25701, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (24077, 0, 'Rgnld_Greaves', 'rgnld_greaves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (24077, "RgnldCGrv", 39, 0, 16924, 172, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (24077, 1, 6), -- DEF +6
    (24077, 5, 30), -- MP +30
    (24077, 12, 6), -- INT +6
    (24077, 13, 4), -- MND +4
    (24077, 14, 4), -- CHR +4
    (24077, 28, 6), -- MAB +6
    (24077, 30, 6), -- MACC +6
    (24077, 562, 3), -- M.Crit +3
    (24077, 563, 5), -- M.Crit Dmg. +5
    (24077, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (381, 0, 'Ophelia_Crown', 'ophelia_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25702, 0, 'Ophelia_Plate', 'ophelia_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25702, "OphlDPlt", 60, 0, 16924, 99, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25702, 1, 25), -- DEF +25
    (25702, 5, 60), -- MP +60
    (25702, 12, 12), -- INT +12
    (25702, 13, 8), -- MND +8
    (25702, 14, 8), -- CHR +8
    (25702, 28, 12), -- MAB +12
    (25702, 30, 12), -- MACC +12
    (25702, 562, 5), -- M.Crit +5
    (25702, 563, 10), -- M.Crit Dmg. +10
    (25702, 369, 3); -- Refresh +3

REPLACE INTO `item_basic` VALUES (14631, 0, 'Ophelia_Ring', 'ophelia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14631, "OphlCRng", 37, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (14631, 5, 30), -- MP +30
    (14631, 12, 6), -- INT +6
    (14631, 13, 4), -- MND +4
    (14631, 14, 4), -- CHR +4
    (14631, 28, 6), -- MAB +6
    (14631, 30, 6), -- MACC +6
    (14631, 562, 3), -- M.Crit +3
    (14631, 563, 5), -- M.Crit Dmg. +5
    (14631, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (384, 0, 'Fenwick_Talon', 'fenwick_talon', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (24075, 0, 'Fenwick_Sandals', 'fenwick_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (24075, "FnwkISndl", 13, 0, 263200, 172, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (24075, 1, 3), -- DEF +3
    (24075, 9, 3), -- DEX +3
    (24075, 11, 3), -- AGI +3
    (24075, 25, 5), -- Accuracy +5
    (24075, 26, 5), -- Rng. Acc. +5
    (24075, 23, 6), -- Attack +6
    (24075, 24, 6), -- Rng. Atk. +6
    (24075, 68, 5), -- Evasion +5
    (24075, 165, 2); -- Crit Rate +2

REPLACE INTO `item_basic` VALUES (28429, 0, 'Fenwick_Sash', 'fenwick_sash', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28429, "FnwkNSsh", 12, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28429, 1, 1), -- DEF +1
    (28429, 5, 15), -- MP +15
    (28429, 12, 3), -- INT +3
    (28429, 13, 2), -- MND +2
    (28429, 14, 2), -- CHR +2
    (28429, 28, 3), -- MAB +3
    (28429, 30, 3), -- MACC +3
    (28429, 562, 2), -- M.Crit +2
    (28429, 563, 3), -- M.Crit Dmg. +3
    (28429, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (387, 0, 'Delilah_Beads', 'delilah_beads', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26014, 0, 'Delilah_Collar', 'delilah_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26014, "DllhCCll", 64, 0, 263200, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26014, 9, 12), -- DEX +12
    (26014, 11, 12), -- AGI +12
    (26014, 25, 20), -- Accuracy +20
    (26014, 26, 20), -- Rng. Acc. +20
    (26014, 23, 24), -- Attack +24
    (26014, 24, 24), -- Rng. Atk. +24
    (26014, 68, 20), -- Evasion +20
    (26014, 165, 5); -- Crit Rate +5

REPLACE INTO `item_basic` VALUES (27537, 0, 'Delilah_Earring', 'delilah_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27537, "DllhSEar", 56, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27537, 5, 45), -- MP +45
    (27537, 12, 9), -- INT +9
    (27537, 13, 6), -- MND +6
    (27537, 14, 6), -- CHR +6
    (27537, 28, 9), -- MAB +9
    (27537, 30, 9), -- MACC +9
    (27537, 562, 4), -- M.Crit +4
    (27537, 563, 7), -- M.Crit Dmg. +7
    (27537, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (390, 0, 'Horatio_Relic', 'horatio_relic', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23895, 0, 'Horatio_Mitre', 'horatio_mitre', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23895, "HrtZMtre", 62, 0, 263200, 480, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23895, 1, 16), -- DEF +16
    (23895, 9, 12), -- DEX +12
    (23895, 11, 12), -- AGI +12
    (23895, 25, 20), -- Accuracy +20
    (23895, 26, 20), -- Rng. Acc. +20
    (23895, 23, 24), -- Attack +24
    (23895, 24, 24), -- Rng. Atk. +24
    (23895, 68, 20), -- Evasion +20
    (23895, 165, 5); -- Crit Rate +5

REPLACE INTO `item_basic` VALUES (14641, 0, 'Horatio_Ring', 'horatio_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14641, "HrtFthRng", 58, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (14641, 5, 45), -- MP +45
    (14641, 12, 9), -- INT +9
    (14641, 13, 6), -- MND +6
    (14641, 14, 6), -- CHR +6
    (14641, 28, 9), -- MAB +9
    (14641, 30, 9), -- MACC +9
    (14641, 562, 4), -- M.Crit +4
    (14641, 563, 7), -- M.Crit Dmg. +7
    (14641, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (393, 0, 'Dmd_Feather', 'dmd_feather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25703, 0, 'Diomedea_Robe', 'diomedea_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25703, "DmdaARbe", 70, 0, 263200, 328, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25703, 1, 25), -- DEF +25
    (25703, 9, 12), -- DEX +12
    (25703, 11, 12), -- AGI +12
    (25703, 25, 20), -- Accuracy +20
    (25703, 26, 20), -- Rng. Acc. +20
    (25703, 23, 24), -- Attack +24
    (25703, 24, 24), -- Rng. Atk. +24
    (25703, 68, 20), -- Evasion +20
    (25703, 165, 5); -- Crit Rate +5

REPLACE INTO `item_basic` VALUES (23797, 0, 'Dmd_Headband', 'dmd_headband', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23797, "DmdaHHbd", 70, 0, 10240, 172, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23797, 1, 16), -- DEF +16
    (23797, 8, 12), -- STR +12
    (23797, 9, 12), -- DEX +12
    (23797, 23, 24), -- Attack +24
    (23797, 25, 24), -- Accuracy +24
    (23797, 73, 10), -- Store TP +10
    (23797, 384, 400); -- Haste +4%
REPLACE INTO `item_basic` VALUES (396, 0, 'Cornelius_Scale', 'cornelius_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23544, 0, 'Cornelius_Shard', 'cornelius_shard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23544, "CrnlsSShr", 9, 0, 131, 89, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23544, 1, 3), -- DEF +3
    (23544, 2, 20), -- HP +20
    (23544, 8, 3), -- STR +3
    (23544, 10, 3), -- VIT +3
    (23544, 23, 6), -- Attack +6
    (23544, 25, 5), -- Accuracy +5
    (23544, 421, 2); -- Crit Dmg. +2

REPLACE INTO `item_basic` VALUES (23785, 0, 'Crnls_Anklet', 'crnls_anklet', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23785, "CrnlsAnkl", 11, 0, 16924, 466, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23785, 1, 3), -- DEF +3
    (23785, 5, 15), -- MP +15
    (23785, 12, 3), -- INT +3
    (23785, 13, 2), -- MND +2
    (23785, 14, 2), -- CHR +2
    (23785, 28, 3), -- MAB +3
    (23785, 30, 3), -- MACC +3
    (23785, 562, 2), -- M.Crit +2
    (23785, 563, 3), -- M.Crit Dmg. +3
    (23785, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (399, 0, 'Sylvester_Ingot', 'sylvester_ingot', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23978, 0, 'Sylvstr_Cuirass', 'sylvstr_cuirass', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23978, "SlvstPCrs", 22, 0, 131, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23978, 1, 12), -- DEF +12
    (23978, 2, 40), -- HP +40
    (23978, 8, 6), -- STR +6
    (23978, 10, 6), -- VIT +6
    (23978, 23, 12), -- Attack +12
    (23978, 25, 10), -- Accuracy +10
    (23978, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (26015, 0, 'Sylvstr_Collar', 'sylvstr_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26015, "SlvstGCll", 12, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26015, 5, 15), -- MP +15
    (26015, 12, 3), -- INT +3
    (26015, 13, 2), -- MND +2
    (26015, 14, 2), -- CHR +2
    (26015, 28, 3), -- MAB +3
    (26015, 30, 3), -- MACC +3
    (26015, 562, 2), -- M.Crit +2
    (26015, 563, 3), -- M.Crit Dmg. +3
    (26015, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (402, 0, 'Basil_Chip', 'basil_chip', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23728, 0, 'Basil_Greaves', 'basil_greaves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23728, "BaslFGrv", 37, 0, 131, 164, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23728, 1, 6), -- DEF +6
    (23728, 2, 40), -- HP +40
    (23728, 8, 6), -- STR +6
    (23728, 10, 6), -- VIT +6
    (23728, 23, 12), -- Attack +12
    (23728, 25, 10), -- Accuracy +10
    (23728, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (14639, 0, 'Basil_Ring', 'basil_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14639, "BaslRRng", 28, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (14639, 5, 30), -- MP +30
    (14639, 12, 6), -- INT +6
    (14639, 13, 4), -- MND +4
    (14639, 14, 4), -- CHR +4
    (14639, 28, 6), -- MAB +6
    (14639, 30, 6), -- MACC +6
    (14639, 562, 3), -- M.Crit +3
    (14639, 563, 5), -- M.Crit Dmg. +5
    (14639, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (405, 0, 'Dsmnd_Carapace', 'dsmnd_carapace', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25705, 0, 'Desmond_Hauberk', 'desmond_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25705, "DsmndIHbk", 55, 0, 16924, 329, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25705, 1, 18), -- DEF +18
    (25705, 5, 45), -- MP +45
    (25705, 12, 9), -- INT +9
    (25705, 13, 6), -- MND +6
    (25705, 14, 6), -- CHR +6
    (25705, 28, 9), -- MAB +9
    (25705, 30, 9), -- MACC +9
    (25705, 562, 4), -- M.Crit +4
    (25705, 563, 7), -- M.Crit Dmg. +7
    (25705, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (23896, 0, 'Desmond_Visor', 'desmond_visor', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23896, "DsmndWVsr", 46, 0, 16924, 480, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23896, 1, 12), -- DEF +12
    (23896, 5, 45), -- MP +45
    (23896, 12, 9), -- INT +9
    (23896, 13, 6), -- MND +6
    (23896, 14, 6), -- CHR +6
    (23896, 28, 9), -- MAB +9
    (23896, 30, 9), -- MACC +9
    (23896, 562, 4), -- M.Crit +4
    (23896, 563, 7), -- M.Crit Dmg. +7
    (23896, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (408, 0, 'Fiona_Scrap', 'fiona_scrap', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27538, 0, 'Fiona_Earring', 'fiona_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27538, "FnaWngEar", 15, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27538, 5, 15), -- MP +15
    (27538, 12, 3), -- INT +3
    (27538, 13, 2), -- MND +2
    (27538, 14, 2), -- CHR +2
    (27538, 28, 3), -- MAB +3
    (27538, 30, 3), -- MACC +3
    (27538, 562, 2), -- M.Crit +2
    (27538, 563, 3), -- M.Crit Dmg. +3
    (27538, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (23707, 0, 'Fiona_Sandals', 'fiona_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23707, "FnaNgtSnd", 10, 0, 263200, 132, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23707, 1, 3), -- DEF +3
    (23707, 9, 3), -- DEX +3
    (23707, 11, 3), -- AGI +3
    (23707, 25, 5), -- Accuracy +5
    (23707, 26, 5), -- Rng. Acc. +5
    (23707, 23, 6), -- Attack +6
    (23707, 24, 6), -- Rng. Atk. +6
    (23707, 68, 5), -- Evasion +5
    (23707, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (411, 0, 'Edgar_Wing', 'edgar_wing', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27539, 0, 'Edgar_Earring', 'edgar_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27539, "EdgrEEar", 27, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27539, 5, 30), -- MP +30
    (27539, 12, 6), -- INT +6
    (27539, 13, 4), -- MND +4
    (27539, 14, 4), -- CHR +4
    (27539, 28, 6), -- MAB +6
    (27539, 30, 6), -- MACC +6
    (27539, 562, 3), -- M.Crit +3
    (27539, 563, 5), -- M.Crit Dmg. +5
    (27539, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (23543, 0, 'Edgar_Mitts', 'edgar_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23543, "EdgrShMtt", 24, 0, 131, 87, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23543, 1, 6), -- DEF +6
    (23543, 2, 40), -- HP +40
    (23543, 8, 6), -- STR +6
    (23543, 10, 6), -- VIT +6
    (23543, 23, 12), -- Attack +12
    (23543, 25, 10), -- Accuracy +10
    (23543, 421, 4); -- Crit Dmg. +4
REPLACE INTO `item_basic` VALUES (414, 0, 'Valerian_Fang', 'valerian_fang', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23761, 0, 'Valerian_Cowl', 'valerian_cowl', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23761, "VlrnNtCwl", 28, 0, 131, 470, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23761, 1, 8), -- DEF +8
    (23761, 2, 40), -- HP +40
    (23761, 8, 6), -- STR +6
    (23761, 10, 6), -- VIT +6
    (23761, 23, 12), -- Attack +12
    (23761, 25, 10), -- Accuracy +10
    (23761, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (14637, 0, 'Valerian_Ring', 'valerian_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14637, "VlrnVRng", 24, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (14637, 8, 4), -- STR +4
    (14637, 9, 6), -- DEX +6
    (14637, 23, 12), -- Attack +12
    (14637, 25, 14), -- Accuracy +14
    (14637, 73, 5), -- Store TP +5
    (14637, 384, 200), -- Haste +2%
    (14637, 165, 3); -- Crit Rate +3
REPLACE INTO `item_basic` VALUES (417, 0, 'Araminta_Fang', 'araminta_fang', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28620, 0, 'Araminta_Mantle', 'araminta_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28620, "ArmntDMnt", 31, 0, 263200, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28620, 1, 4), -- DEF +4
    (28620, 9, 6), -- DEX +6
    (28620, 11, 6), -- AGI +6
    (28620, 25, 10), -- Accuracy +10
    (28620, 26, 10), -- Rng. Acc. +10
    (28620, 23, 12), -- Attack +12
    (28620, 24, 12), -- Rng. Atk. +12
    (28620, 68, 10), -- Evasion +10
    (28620, 165, 3); -- Crit Rate +3

REPLACE INTO `item_basic` VALUES (23708, 0, 'Araminta_Anklet', 'araminta_anklet', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23708, "ArmntHAnk", 36, 0, 131, 132, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23708, 1, 6), -- DEF +6
    (23708, 2, 40), -- HP +40
    (23708, 8, 6), -- STR +6
    (23708, 10, 6), -- VIT +6
    (23708, 23, 12), -- Attack +12
    (23708, 25, 10), -- Accuracy +10
    (23708, 421, 4); -- Crit Dmg. +4
REPLACE INTO `item_basic` VALUES (420, 0, 'Silas_Shed', 'silas_shed', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23729, 0, 'Silas_Sandals', 'silas_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23729, "SlsSnkSnd", 13, 0, 131, 163, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23729, 1, 3), -- DEF +3
    (23729, 2, 20), -- HP +20
    (23729, 8, 3), -- STR +3
    (23729, 10, 3), -- VIT +3
    (23729, 23, 6), -- Attack +6
    (23729, 25, 5), -- Accuracy +5
    (23729, 421, 2); -- Crit Dmg. +2

REPLACE INTO `item_basic` VALUES (28438, 0, 'Silas_Coil_Sash', 'silas_coil_sash', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28438, "SlsColSsh", 5, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28438, 1, 1), -- DEF +1
    (28438, 5, 15), -- MP +15
    (28438, 12, 3), -- INT +3
    (28438, 13, 2), -- MND +2
    (28438, 14, 2), -- CHR +2
    (28438, 28, 3), -- MAB +3
    (28438, 30, 3), -- MACC +3
    (28438, 562, 2), -- M.Crit +2
    (28438, 563, 3), -- M.Crit Dmg. +3
    (28438, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (423, 0, 'Heloise_Scale', 'heloise_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25538, 0, 'Heloise_Collar', 'heloise_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25538, "HlseCCll", 59, 0, 263200, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25538, 9, 9), -- DEX +9
    (25538, 11, 9), -- AGI +9
    (25538, 25, 15), -- Accuracy +15
    (25538, 26, 15), -- Rng. Acc. +15
    (25538, 23, 18), -- Attack +18
    (25538, 24, 18), -- Rng. Atk. +18
    (25538, 68, 15), -- Evasion +15
    (25538, 165, 4); -- Crit Rate +4

REPLACE INTO `item_basic` VALUES (27535, 0, 'Heloise_Earring', 'heloise_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27535, "HlseLEar", 12, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27535, 5, 15), -- MP +15
    (27535, 12, 3), -- INT +3
    (27535, 13, 2), -- MND +2
    (27535, 14, 2), -- CHR +2
    (27535, 28, 3), -- MAB +3
    (27535, 30, 3), -- MACC +3
    (27535, 562, 2), -- M.Crit +2
    (27535, 563, 3), -- M.Crit Dmg. +3
    (27535, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (426, 0, 'Cressida_Coil', 'cressida_coil', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23541, 0, 'Cressida_Gloves', 'cressida_gloves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23541, "CrsdSqGlv", 32, 0, 16924, 83, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23541, 1, 6), -- DEF +6
    (23541, 5, 30), -- MP +30
    (23541, 12, 6), -- INT +6
    (23541, 13, 4), -- MND +4
    (23541, 14, 4), -- CHR +4
    (23541, 28, 6), -- MAB +6
    (23541, 30, 6), -- MACC +6
    (23541, 562, 3), -- M.Crit +3
    (23541, 563, 5), -- M.Crit Dmg. +5
    (23541, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28435, 0, 'Cressida_Belt', 'cressida_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28435, "CrsdBBlt", 24, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28435, 1, 3), -- DEF +3
    (28435, 5, 30), -- MP +30
    (28435, 12, 6), -- INT +6
    (28435, 13, 4), -- MND +4
    (28435, 14, 4), -- CHR +4
    (28435, 28, 6), -- MAB +6
    (28435, 30, 6), -- MACC +6
    (28435, 562, 3), -- M.Crit +3
    (28435, 563, 5), -- M.Crit Dmg. +5
    (28435, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (429, 0, 'Viviane_Sac', 'viviane_sac', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23415, 0, 'Viviane_Tiara', 'viviane_tiara', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23415, "VvneTxTar", 51, 0, 16924, 170, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23415, 1, 12), -- DEF +12
    (23415, 5, 45), -- MP +45
    (23415, 12, 9), -- INT +9
    (23415, 13, 6), -- MND +6
    (23415, 14, 6), -- CHR +6
    (23415, 28, 9), -- MAB +9
    (23415, 30, 9), -- MACC +9
    (23415, 562, 4), -- M.Crit +4
    (23415, 563, 7), -- M.Crit Dmg. +7
    (23415, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (14645, 0, 'Viviane_Ring', 'viviane_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14645, "VvneSrpRng", 66, 0, 263200, 0, 0, 0, 24576, 0, 0, 0);

-- Buzzing Barnabas trophy + gear
REPLACE INTO `item_basic` VALUES (432, 0, 'Barnabas_Eye', 'barnabas_eye', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26003, 0, 'Barnabas_Brooch', 'barnabas_brooch', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26003, "BrnbsWBrc", 13, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26003, 5, 15), -- MP +15
    (26003, 12, 3), -- INT +3
    (26003, 13, 2), -- MND +2
    (26003, 14, 2), -- CHR +2
    (26003, 28, 3), -- MAB +3
    (26003, 30, 3), -- MACC +3
    (26003, 562, 2), -- M.Crit +2
    (26003, 563, 3), -- M.Crit Dmg. +3
    (26003, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (23709, 0, 'Barnabas_Boots', 'barnabas_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23709, "BrnbsBBts", 13, 0, 263200, 132, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23709, 1, 3), -- DEF +3
    (23709, 9, 3), -- DEX +3
    (23709, 11, 3), -- AGI +3
    (23709, 25, 5), -- Accuracy +5
    (23709, 26, 5), -- Rng. Acc. +5
    (23709, 23, 6), -- Attack +6
    (23709, 24, 6), -- Rng. Atk. +6
    (23709, 68, 5), -- Evasion +5
    (23709, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (435, 0, 'Dorothea_Claw', 'dorothea_claw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25706, 0, 'Dorothea_Vest', 'dorothea_vest', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25706, "DrthaCV", 29, 0, 131, 348, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25706, 1, 12), -- DEF +12
    (25706, 2, 40), -- HP +40
    (25706, 8, 6), -- STR +6
    (25706, 10, 6), -- VIT +6
    (25706, 23, 12), -- Attack +12
    (25706, 25, 10), -- Accuracy +10
    (25706, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (14633, 0, 'Dorothea_Ring', 'dorothea_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14633, "DrthaHRng", 26, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (14633, 5, 30), -- MP +30
    (14633, 12, 6), -- INT +6
    (14633, 13, 4), -- MND +4
    (14633, 14, 4), -- CHR +4
    (14633, 28, 6), -- MAB +6
    (14633, 30, 6), -- MACC +6
    (14633, 562, 3), -- M.Crit +3
    (14633, 563, 5), -- M.Crit Dmg. +5
    (14633, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (438, 0, 'Percival_Gland', 'percival_gland', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23417, 0, 'Percival_Mask', 'percival_mask', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23417, "PrcvlPMsk", 28, 0, 16924, 215, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23417, 1, 8), -- DEF +8
    (23417, 5, 30), -- MP +30
    (23417, 12, 6), -- INT +6
    (23417, 13, 4), -- MND +4
    (23417, 14, 4), -- CHR +4
    (23417, 28, 6), -- MAB +6
    (23417, 30, 6), -- MACC +6
    (23417, 562, 3), -- M.Crit +3
    (23417, 563, 5), -- M.Crit Dmg. +5
    (23417, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28617, 0, 'Percival_Mantle', 'percival_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28617, "PrcvlBMnt", 24, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28617, 1, 4), -- DEF +4
    (28617, 5, 30), -- MP +30
    (28617, 12, 6), -- INT +6
    (28617, 13, 4), -- MND +4
    (28617, 14, 4), -- CHR +4
    (28617, 28, 6), -- MAB +6
    (28617, 30, 6), -- MACC +6
    (28617, 562, 3), -- M.Crit +3
    (28617, 563, 5), -- M.Crit Dmg. +5
    (28617, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (441, 0, 'Sophonias_Jelly', 'sophonias_jelly', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23416, 0, 'Sophonias_Helm', 'sophonias_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23416, "SphnHMHlm", 70, 0, 10240, 304, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23416, 1, 16), -- DEF +16
    (23416, 8, 12), -- STR +12
    (23416, 9, 12), -- DEX +12
    (23416, 23, 24), -- Attack +24
    (23416, 25, 24), -- Accuracy +24
    (23416, 73, 10), -- Store TP +10
    (23416, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (23264, 0, 'Sphns_Tassets', 'sphns_tassets', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23264, "SphnDTsst", 44, 0, 131, 65, 0, 0, 128, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23264, 1, 16), -- DEF +16
    (23264, 2, 70), -- HP +70
    (23264, 8, 9), -- STR +9
    (23264, 10, 9), -- VIT +9
    (23264, 23, 18), -- Attack +18
    (23264, 25, 15), -- Accuracy +15
    (23264, 421, 6); -- Crit Dmg. +6
REPLACE INTO `item_basic` VALUES (444, 0, 'Nathaniel_Bone', 'nathaniel_bone', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23542, 0, 'Nthnl_Armband', 'nthnl_armband', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23542, "NthnlRArmb", 7, 0, 16924, 85, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23542, 1, 3), -- DEF +3
    (23542, 5, 15), -- MP +15
    (23542, 12, 3), -- INT +3
    (23542, 13, 2), -- MND +2
    (23542, 14, 2), -- CHR +2
    (23542, 28, 3), -- MAB +3
    (23542, 30, 3), -- MACC +3
    (23542, 562, 2), -- M.Crit +2
    (23542, 563, 3), -- M.Crit Dmg. +3
    (23542, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (23726, 0, 'Nthnl_Sandals', 'nthnl_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23726, "NthnlGSnd", 5, 0, 131, 132, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23726, 1, 3), -- DEF +3
    (23726, 2, 20), -- HP +20
    (23726, 8, 3), -- STR +3
    (23726, 10, 3), -- VIT +3
    (23726, 23, 6), -- Attack +6
    (23726, 25, 5), -- Accuracy +5
    (23726, 421, 2); -- Crit Dmg. +2
REPLACE INTO `item_basic` VALUES (447, 0, 'Frncsc_Finger', 'frncsc_finger', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27534, 0, 'Frncsc_Earring', 'frncsc_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27534, "FrncsBEar", 26, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27534, 5, 30), -- MP +30
    (27534, 12, 6), -- INT +6
    (27534, 13, 4), -- MND +4
    (27534, 14, 4), -- CHR +4
    (27534, 28, 6), -- MAB +6
    (27534, 30, 6), -- MACC +6
    (27534, 562, 3), -- M.Crit +3
    (27534, 563, 5), -- M.Crit Dmg. +5
    (27534, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (14635, 0, 'Francesca_Ring', 'francesca_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14635, "FrncsRng", 48, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (14635, 5, 45), -- MP +45
    (14635, 12, 9), -- INT +9
    (14635, 13, 6), -- MND +6
    (14635, 14, 6), -- CHR +6
    (14635, 28, 9), -- MAB +9
    (14635, 30, 9), -- MACC +9
    (14635, 562, 4), -- M.Crit +4
    (14635, 563, 7), -- M.Crit Dmg. +7
    (14635, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (450, 0, 'Hortensia_Bile', 'hortensia_bile', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23979, 0, 'Hortensia_Guard', 'hortensia_guard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23979, "HrtnMwGrd", 44, 0, 131, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23979, 1, 18), -- DEF +18
    (23979, 2, 70), -- HP +70
    (23979, 8, 9), -- STR +9
    (23979, 10, 9), -- VIT +9
    (23979, 23, 18), -- Attack +18
    (23979, 25, 15), -- Accuracy +15
    (23979, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES (23540, 0, 'Hrtns_Gauntlets', 'hrtns_gauntlets', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23540, "HrtnGGnt", 37, 0, 16924, 81, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23540, 1, 6), -- DEF +6
    (23540, 5, 30), -- MP +30
    (23540, 12, 6), -- INT +6
    (23540, 13, 4), -- MND +4
    (23540, 14, 4), -- CHR +4
    (23540, 28, 6), -- MAB +6
    (23540, 30, 6), -- MACC +6
    (23540, 562, 3), -- M.Crit +3
    (23540, 563, 5), -- M.Crit Dmg. +5
    (23540, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (453, 0, 'Cornelius_Crown', 'cornelius_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23980, 0, 'Crnls_Shroud', 'crnls_shroud', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23980, "CrnlsDShr", 71, 0, 10240, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23980, 1, 25), -- DEF +25
    (23980, 8, 12), -- STR +12
    (23980, 9, 12), -- DEX +12
    (23980, 23, 24), -- Attack +24
    (23980, 25, 24), -- Accuracy +24
    (23980, 73, 10), -- Store TP +10
    (23980, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (11640, 0, 'Cornelius_Ring', 'cornelius_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11640, "CrnlsGRng", 57, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);

-- Rattling Roderick trophy + gear
REPLACE INTO `item_basic` VALUES (456, 0, 'Roderick_Finger', 'roderick_finger', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26107, 0, 'Rdrck_Earring', 'rdrck_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26107, "RdrckBEar", 16, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26107, 5, 15), -- MP +15
    (26107, 12, 3), -- INT +3
    (26107, 13, 2), -- MND +2
    (26107, 14, 2), -- CHR +2
    (26107, 28, 3), -- MAB +3
    (26107, 30, 3), -- MACC +3
    (26107, 562, 2), -- M.Crit +2
    (26107, 563, 3), -- M.Crit Dmg. +3
    (26107, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (23727, 0, 'Rdrck_Greaves', 'rdrck_greaves', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23727, "RdrckRGrv", 14, 0, 16924, 128, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23727, 1, 3), -- DEF +3
    (23727, 5, 15), -- MP +15
    (23727, 12, 3), -- INT +3
    (23727, 13, 2), -- MND +2
    (23727, 14, 2), -- CHR +2
    (23727, 28, 3), -- MAB +3
    (23727, 30, 3), -- MACC +3
    (23727, 562, 2), -- M.Crit +2
    (23727, 563, 3), -- M.Crit Dmg. +3
    (23727, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (459, 0, 'Cavendish_Skull', 'cavendish_skull', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25537, 0, 'Cvndsh_Collar', 'cvndsh_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25537, "CvndshHCl", 60, 0, 10240, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25537, 8, 12), -- STR +12
    (25537, 9, 12), -- DEX +12
    (25537, 23, 24), -- Attack +24
    (25537, 25, 24), -- Accuracy +24
    (25537, 73, 10), -- Store TP +10
    (25537, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (26105, 0, 'Cvndsh_Earring', 'cvndsh_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26105, "CvndshEar", 17, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26105, 5, 15), -- MP +15
    (26105, 12, 3), -- INT +3
    (26105, 13, 2), -- MND +2
    (26105, 14, 2), -- CHR +2
    (26105, 28, 3), -- MAB +3
    (26105, 30, 3), -- MACC +3
    (26105, 562, 2), -- M.Crit +2
    (26105, 563, 3), -- M.Crit Dmg. +3
    (26105, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (462, 0, 'Benedict_Femur', 'benedict_femur', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23736, 0, 'Benedict_Boots', 'benedict_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23736, "BndctDBts", 26, 0, 16924, 458, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23736, 1, 6), -- DEF +6
    (23736, 5, 30), -- MP +30
    (23736, 12, 6), -- INT +6
    (23736, 13, 4), -- MND +4
    (23736, 14, 4), -- CHR +4
    (23736, 28, 6), -- MAB +6
    (23736, 30, 6), -- MACC +6
    (23736, 562, 3), -- M.Crit +3
    (23736, 563, 5), -- M.Crit Dmg. +5
    (23736, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28434, 0, 'Benedict_Belt', 'benedict_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28434, "BndctUBlt", 5, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28434, 1, 1), -- DEF +1
    (28434, 5, 15), -- MP +15
    (28434, 12, 3), -- INT +3
    (28434, 13, 2), -- MND +2
    (28434, 14, 2), -- CHR +2
    (28434, 28, 3), -- MAB +3
    (28434, 30, 3), -- MACC +3
    (28434, 562, 2), -- M.Crit +2
    (28434, 563, 3), -- M.Crit Dmg. +3
    (28434, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (465, 0, 'Lntn_Crystal', 'lntn_crystal', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23977, 0, 'Leontine_Robe', 'leontine_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23977, "LntNRobe", 67, 0, 10240, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23977, 1, 25), -- DEF +25
    (23977, 8, 12), -- STR +12
    (23977, 9, 12), -- DEX +12
    (23977, 23, 24), -- Attack +24
    (23977, 25, 24), -- Accuracy +24
    (23977, 73, 10), -- Store TP +10
    (23977, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (14643, 0, 'Leontine_Ring', 'leontine_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (14643, "LntSDRng", 42, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (14643, 5, 45), -- MP +45
    (14643, 12, 9), -- INT +9
    (14643, 13, 6), -- MND +6
    (14643, 14, 6), -- CHR +6
    (14643, 28, 9), -- MAB +9
    (14643, 30, 9), -- MACC +9
    (14643, 562, 4), -- M.Crit +4
    (14643, 563, 7), -- M.Crit Dmg. +7
    (14643, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (468, 0, 'Simeon_Claw', 'simeon_claw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23510, 0, 'Smn_Wristlets', 'smn_wristlets', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23510, "SmeonWrst", 11, 0, 16924, 66, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23510, 1, 3), -- DEF +3
    (23510, 5, 15), -- MP +15
    (23510, 12, 3), -- INT +3
    (23510, 13, 2), -- MND +2
    (23510, 14, 2), -- CHR +2
    (23510, 28, 3), -- MAB +3
    (23510, 30, 3), -- MACC +3
    (23510, 562, 2), -- M.Crit +2
    (23510, 563, 3), -- M.Crit Dmg. +3
    (23510, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (26106, 0, 'Simeon_Earring', 'simeon_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26106, "SmeonSEar", 5, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26106, 5, 15), -- MP +15
    (26106, 12, 3), -- INT +3
    (26106, 13, 2), -- MND +2
    (26106, 14, 2), -- CHR +2
    (26106, 28, 3), -- MAB +3
    (26106, 30, 3), -- MACC +3
    (26106, 562, 2), -- M.Crit +2
    (26106, 563, 3), -- M.Crit Dmg. +3
    (26106, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (471, 0, 'Vespera_Sac', 'vespera_sac', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28598, 0, 'Vespera_Mantle', 'vespera_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28598, "VsprTxMnt", 25, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28598, 1, 4), -- DEF +4
    (28598, 5, 30), -- MP +30
    (28598, 12, 6), -- INT +6
    (28598, 13, 4), -- MND +4
    (28598, 14, 4), -- CHR +4
    (28598, 28, 6), -- MAB +6
    (28598, 30, 6), -- MACC +6
    (28598, 562, 3), -- M.Crit +3
    (28598, 563, 5), -- M.Crit Dmg. +5
    (28598, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28433, 0, 'Vespera_Belt', 'vespera_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28433, "VsprCBlt", 5, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28433, 1, 1), -- DEF +1
    (28433, 5, 15), -- MP +15
    (28433, 12, 3), -- INT +3
    (28433, 13, 2), -- MND +2
    (28433, 14, 2), -- CHR +2
    (28433, 28, 3), -- MAB +3
    (28433, 30, 3), -- MACC +3
    (28433, 562, 2), -- M.Crit +2
    (28433, 563, 3), -- M.Crit Dmg. +3
    (28433, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (474, 0, 'Ptolemy_Pincer', 'ptolemy_pincer', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23263, 0, 'Ptolemy_Cuisses', 'ptolemy_cuisses', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23263, "PtlmyACss", 33, 0, 131, 338, 0, 0, 128, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23263, 1, 10), -- DEF +10
    (23263, 2, 40), -- HP +40
    (23263, 8, 6), -- STR +6
    (23263, 10, 6), -- VIT +6
    (23263, 23, 12), -- Attack +12
    (23263, 25, 10), -- Accuracy +10
    (23263, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (15857, 0, 'Ptolemy_Ring', 'ptolemy_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (15857, "PtlmyERng", 30, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15857, 5, 30), -- MP +30
    (15857, 12, 6), -- INT +6
    (15857, 13, 4), -- MND +4
    (15857, 14, 4), -- CHR +4
    (15857, 28, 6), -- MAB +6
    (15857, 30, 6), -- MACC +6
    (15857, 562, 3), -- M.Crit +3
    (15857, 563, 5), -- M.Crit Dmg. +5
    (15857, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (477, 0, 'Dagny_Barb', 'dagny_barb', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25682, 0, 'Dagny_Carapace', 'dagny_carapace', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25682, "DgnyRCrp", 50, 0, 16924, 323, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25682, 1, 18), -- DEF +18
    (25682, 5, 45), -- MP +45
    (25682, 12, 9), -- INT +9
    (25682, 13, 6), -- MND +6
    (25682, 14, 6), -- CHR +6
    (25682, 28, 9), -- MAB +9
    (25682, 30, 9), -- MACC +9
    (25682, 562, 4), -- M.Crit +4
    (25682, 563, 7), -- M.Crit Dmg. +7
    (25682, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (26116, 0, 'Dagny_Earring', 'dagny_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26116, "DgnyFEar", 53, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26116, 5, 45), -- MP +45
    (26116, 12, 9), -- INT +9
    (26116, 13, 6), -- MND +6
    (26116, 14, 6), -- CHR +6
    (26116, 28, 9), -- MAB +9
    (26116, 30, 9), -- MACC +9
    (26116, 562, 4), -- M.Crit +4
    (26116, 563, 7), -- M.Crit Dmg. +7
    (26116, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (480, 0, 'Wendy_Thread', 'wendy_thread', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (15856, 0, 'Wendy_Ring', 'wendy_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (15856, "WndyWRng", 14, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15856, 8, 2), -- STR +2
    (15856, 9, 3), -- DEX +3
    (15856, 23, 6), -- Attack +6
    (15856, 25, 8), -- Accuracy +8
    (15856, 73, 3), -- Store TP +3
    (15856, 384, 100), -- Haste +1%
    (15856, 165, 2); -- Crit Rate +2

REPLACE INTO `item_basic` VALUES (23789, 0, 'Wendy_Sandals', 'wendy_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23789, "WndySpSnd", 10, 0, 263200, 470, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23789, 1, 3), -- DEF +3
    (23789, 9, 3), -- DEX +3
    (23789, 11, 3), -- AGI +3
    (23789, 25, 5), -- Accuracy +5
    (23789, 26, 5), -- Rng. Acc. +5
    (23789, 23, 6), -- Attack +6
    (23789, 24, 6), -- Rng. Atk. +6
    (23789, 68, 5), -- Evasion +5
    (23789, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (483, 0, 'Stanislava_Sac', 'stanislava_sac', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26002, 0, 'Stnslv_Collar', 'stnslv_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26002, "StnslaGCl", 24, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26002, 5, 30), -- MP +30
    (26002, 12, 6), -- INT +6
    (26002, 13, 4), -- MND +4
    (26002, 14, 4), -- CHR +4
    (26002, 28, 6), -- MAB +6
    (26002, 30, 6), -- MACC +6
    (26002, 562, 3), -- M.Crit +3
    (26002, 563, 5), -- M.Crit Dmg. +5
    (26002, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (27928, 0, 'Stnslv_Mitts', 'stnslv_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27928, "StnslasMtt", 21, 0, 16924, 182, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27928, 1, 6), -- DEF +6
    (27928, 5, 30), -- MP +30
    (27928, 12, 6), -- INT +6
    (27928, 13, 4), -- MND +4
    (27928, 14, 4), -- CHR +4
    (27928, 28, 6), -- MAB +6
    (27928, 30, 6), -- MACC +6
    (27928, 562, 3), -- M.Crit +3
    (27928, 563, 5), -- M.Crit Dmg. +5
    (27928, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (486, 0, 'Elnr_Ensnaring', 'elnr_ensnaring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25683, 0, 'Eleanor_Vest', 'eleanor_vest', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25683, "ElnrArVst", 31, 0, 131, 323, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25683, 1, 12), -- DEF +12
    (25683, 2, 40), -- HP +40
    (25683, 8, 6), -- STR +6
    (25683, 10, 6), -- VIT +6
    (25683, 23, 12), -- Attack +12
    (25683, 25, 10), -- Accuracy +10
    (25683, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (28432, 0, 'Eleanor_Belt', 'eleanor_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28432, "ElnrSWBlt", 11, 0, 263200, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28432, 1, 1), -- DEF +1
    (28432, 9, 3), -- DEX +3
    (28432, 11, 3), -- AGI +3
    (28432, 25, 5), -- Accuracy +5
    (28432, 26, 5), -- Rng. Acc. +5
    (28432, 23, 6), -- Attack +6
    (28432, 24, 6), -- Rng. Atk. +6
    (28432, 68, 5), -- Evasion +5
    (28432, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (489, 0, 'Gwendolyn_Crown', 'gwendolyn_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23435, 0, 'Gwendolyn_Tiara', 'gwendolyn_tiara', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23435, "GwndlnSTar", 46, 0, 10240, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23435, 1, 12), -- DEF +12
    (23435, 8, 9), -- STR +9
    (23435, 9, 9), -- DEX +9
    (23435, 23, 18), -- Attack +18
    (23435, 25, 18), -- Accuracy +18
    (23435, 73, 7), -- Store TP +7
    (23435, 384, 300); -- Haste +3%

REPLACE INTO `item_basic` VALUES (28597, 0, 'Gwndlyn_Mantle', 'gwndlyn_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28597, "GwndlnSMnt", 49, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28597, 1, 6), -- DEF +6
    (28597, 5, 45), -- MP +45
    (28597, 12, 9), -- INT +9
    (28597, 13, 6), -- MND +6
    (28597, 14, 6), -- CHR +6
    (28597, 28, 9), -- MAB +9
    (28597, 30, 9), -- MACC +9
    (28597, 562, 4), -- M.Crit +4
    (28597, 563, 7), -- M.Crit Dmg. +7
    (28597, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (492, 0, 'Oswald_Sample', 'oswald_sample', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11062, 0, 'Oswald_Ring', 'oswald_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11062, "OswldSRng", 21, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11062, 5, 30), -- MP +30
    (11062, 12, 6), -- INT +6
    (11062, 13, 4), -- MND +4
    (11062, 14, 4), -- CHR +4
    (11062, 28, 6), -- MAB +6
    (11062, 30, 6), -- MACC +6
    (11062, 562, 3), -- M.Crit +3
    (11062, 563, 5), -- M.Crit Dmg. +5
    (11062, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28208, 0, 'Oswald_Sandals', 'oswald_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28208, "OswldSlSnd", 15, 0, 263200, 182, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28208, 1, 3), -- DEF +3
    (28208, 9, 3), -- DEX +3
    (28208, 11, 3), -- AGI +3
    (28208, 25, 5), -- Accuracy +5
    (28208, 26, 5), -- Rng. Acc. +5
    (28208, 23, 6), -- Attack +6
    (28208, 24, 6), -- Rng. Atk. +6
    (28208, 68, 5), -- Evasion +5
    (28208, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (495, 0, 'Borghild_Mass', 'borghild_mass', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26001, 0, 'Borghild_Collar', 'borghild_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26001, "BrghldVCl", 52, 0, 10240, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26001, 8, 9), -- STR +9
    (26001, 9, 9), -- DEX +9
    (26001, 23, 18), -- Attack +18
    (26001, 25, 18), -- Accuracy +18
    (26001, 73, 7), -- Store TP +7
    (26001, 384, 300); -- Haste +3%

REPLACE INTO `item_basic` VALUES (26108, 0, 'Brghld_Earring', 'brghld_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26108, "BrghldAEar", 14, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26108, 5, 15), -- MP +15
    (26108, 12, 3), -- INT +3
    (26108, 13, 2), -- MND +2
    (26108, 14, 2), -- CHR +2
    (26108, 28, 3), -- MAB +3
    (26108, 30, 3), -- MACC +3
    (26108, 562, 2), -- M.Crit +2
    (26108, 563, 3), -- M.Crit Dmg. +3
    (26108, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (498, 0, 'Callista_Sac', 'callista_sac', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27937, 0, 'Callista_Mitts', 'callista_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27937, "CllstDMtt", 29, 0, 16924, 186, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27937, 1, 6), -- DEF +6
    (27937, 5, 30), -- MP +30
    (27937, 12, 6), -- INT +6
    (27937, 13, 4), -- MND +4
    (27937, 14, 4), -- CHR +4
    (27937, 28, 6), -- MAB +6
    (27937, 30, 6), -- MACC +6
    (27937, 562, 3), -- M.Crit +3
    (27937, 563, 5), -- M.Crit Dmg. +5
    (27937, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (27564, 0, 'Callista_Ring', 'callista_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27564, "CllstCRng", 18, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27564, 5, 15), -- MP +15
    (27564, 12, 3), -- INT +3
    (27564, 13, 2), -- MND +2
    (27564, 14, 2), -- CHR +2
    (27564, 28, 3), -- MAB +3
    (27564, 30, 3), -- MACC +3
    (27564, 562, 2), -- M.Crit +2
    (27564, 563, 3), -- M.Crit Dmg. +3
    (27564, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (501, 0, 'Proteus_Ooze', 'proteus_ooze', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25680, 0, 'Proteus_Robe', 'proteus_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25680, "PrtsaPRbe", 68, 0, 10240, 11, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25680, 1, 25), -- DEF +25
    (25680, 8, 12), -- STR +12
    (25680, 9, 12), -- DEX +12
    (25680, 23, 24), -- Attack +24
    (25680, 25, 24), -- Accuracy +24
    (25680, 73, 10), -- Store TP +10
    (25680, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (27574, 0, 'Proteus_Ring', 'proteus_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27574, "PrtsaShRng", 36, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27574, 5, 30), -- MP +30
    (27574, 12, 6), -- INT +6
    (27574, 13, 4), -- MND +4
    (27574, 14, 4), -- CHR +4
    (27574, 28, 6), -- MAB +6
    (27574, 30, 6), -- MACC +6
    (27574, 562, 3), -- M.Crit +3
    (27574, 563, 5), -- M.Crit Dmg. +5
    (27574, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (504, 0, 'Salvatore_Fin', 'salvatore_fin', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26115, 0, 'Slvtr_Earring', 'slvtr_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26115, "SlvtrGEar", 14, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26115, 5, 15), -- MP +15
    (26115, 12, 3), -- INT +3
    (26115, 13, 2), -- MND +2
    (26115, 14, 2), -- CHR +2
    (26115, 28, 3), -- MAB +3
    (26115, 30, 3), -- MACC +3
    (26115, 562, 2), -- M.Crit +2
    (26115, 563, 3), -- M.Crit Dmg. +3
    (26115, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (23661, 0, 'Salvatore_Boots', 'salvatore_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23661, "SlvtrWBts", 9, 0, 263200, 211, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23661, 1, 3), -- DEF +3
    (23661, 9, 3), -- DEX +3
    (23661, 11, 3), -- AGI +3
    (23661, 25, 5), -- Accuracy +5
    (23661, 26, 5), -- Rng. Acc. +5
    (23661, 23, 6), -- Attack +6
    (23661, 24, 6), -- Rng. Atk. +6
    (23661, 68, 5), -- Evasion +5
    (23661, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (507, 0, 'Sicily_Mark', 'sicily_mark', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28431, 0, 'Sicily_Belt', 'sicily_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28431, "SclllyRBlt", 6, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28431, 1, 1), -- DEF +1
    (28431, 5, 15), -- MP +15
    (28431, 12, 3), -- INT +3
    (28431, 13, 2), -- MND +2
    (28431, 14, 2), -- CHR +2
    (28431, 28, 3), -- MAB +3
    (28431, 30, 3), -- MACC +3
    (28431, 562, 2), -- M.Crit +2
    (28431, 563, 3), -- M.Crit Dmg. +3
    (28431, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (25681, 0, 'Sicily_Mail', 'sicily_mail', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25681, "ScllySMl", 30, 0, 131, 11, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25681, 1, 12), -- DEF +12
    (25681, 2, 40), -- HP +40
    (25681, 8, 6), -- STR +6
    (25681, 10, 6), -- VIT +6
    (25681, 23, 12), -- Attack +12
    (25681, 25, 10), -- Accuracy +10
    (25681, 421, 4); -- Crit Dmg. +4
REPLACE INTO `item_basic` VALUES (510, 0, 'Tiberius_Scale', 'tiberius_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28609, 0, 'Tiberius_Mantle', 'tiberius_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28609, "TbrsaCMnt", 21, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28609, 1, 4), -- DEF +4
    (28609, 5, 30), -- MP +30
    (28609, 12, 6), -- INT +6
    (28609, 13, 4), -- MND +4
    (28609, 14, 4), -- CHR +4
    (28609, 28, 6), -- MAB +6
    (28609, 30, 6), -- MACC +6
    (28609, 562, 3), -- M.Crit +3
    (28609, 563, 5), -- M.Crit Dmg. +5
    (28609, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28575, 0, 'Tiberius_Ring', 'tiberius_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28575, "TbrsaRRng", 29, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28575, 5, 30), -- MP +30
    (28575, 12, 6), -- INT +6
    (28575, 13, 4), -- MND +4
    (28575, 14, 4), -- CHR +4
    (28575, 28, 6), -- MAB +6
    (28575, 30, 6), -- MACC +6
    (28575, 562, 3), -- M.Crit +3
    (28575, 563, 5), -- M.Crit Dmg. +5
    (28575, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (513, 0, 'Delacroix_Scale', 'delacroix_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23434, 0, 'Delacroix_Helm', 'delacroix_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23434, "DlcxMHlm", 35, 0, 16924, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23434, 1, 8), -- DEF +8
    (23434, 5, 30), -- MP +30
    (23434, 12, 6), -- INT +6
    (23434, 13, 4), -- MND +4
    (23434, 14, 4), -- CHR +4
    (23434, 28, 6), -- MAB +6
    (23434, 30, 6), -- MACC +6
    (23434, 562, 3), -- M.Crit +3
    (23434, 563, 5), -- M.Crit Dmg. +5
    (23434, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (27568, 0, 'Delacroix_Ring', 'delacroix_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27568, "DlcxAbRng", 36, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27568, 5, 30), -- MP +30
    (27568, 12, 6), -- INT +6
    (27568, 13, 4), -- MND +4
    (27568, 14, 4), -- CHR +4
    (27568, 28, 6), -- MAB +6
    (27568, 30, 6), -- MACC +6
    (27568, 562, 3), -- M.Crit +3
    (27568, 563, 5), -- M.Crit Dmg. +5
    (27568, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (516, 0, 'Loretta_Neck', 'loretta_neck', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25545, 0, 'Lrtt_Neckguard', 'lrtt_neckguard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25545, "LrttaPNGd", 10, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25545, 5, 15), -- MP +15
    (25545, 12, 3), -- INT +3
    (25545, 13, 2), -- MND +2
    (25545, 14, 2), -- CHR +2
    (25545, 28, 3), -- MAB +3
    (25545, 30, 3), -- MACC +3
    (25545, 562, 2), -- M.Crit +2
    (25545, 563, 3), -- M.Crit Dmg. +3
    (25545, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (23684, 0, 'Loretta_Boots', 'loretta_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23684, "LrttaSBts", 13, 0, 16924, 304, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23684, 1, 3), -- DEF +3
    (23684, 5, 15), -- MP +15
    (23684, 12, 3), -- INT +3
    (23684, 13, 2), -- MND +2
    (23684, 14, 2), -- CHR +2
    (23684, 28, 3), -- MAB +3
    (23684, 30, 3), -- MACC +3
    (23684, 562, 2), -- M.Crit +2
    (23684, 563, 3), -- M.Crit Dmg. +3
    (23684, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (519, 0, 'Thaddeus_Spine', 'thaddeus_spine', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28606, 0, 'Thaddeus_Mantle', 'thaddeus_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28606, "ThadsMnt", 18, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28606, 1, 2), -- DEF +2
    (28606, 5, 15), -- MP +15
    (28606, 12, 3), -- INT +3
    (28606, 13, 2), -- MND +2
    (28606, 14, 2), -- CHR +2
    (28606, 28, 3), -- MAB +3
    (28606, 30, 3), -- MACC +3
    (28606, 562, 2), -- M.Crit +2
    (28606, 563, 3), -- M.Crit Dmg. +3
    (28606, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (26349, 0, 'Thaddeus_Belt', 'thaddeus_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26349, "ThdsaTBlt", 20, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26349, 1, 3), -- DEF +3
    (26349, 5, 30), -- MP +30
    (26349, 12, 6), -- INT +6
    (26349, 13, 4), -- MND +4
    (26349, 14, 4), -- CHR +4
    (26349, 28, 6), -- MAB +6
    (26349, 30, 6), -- MACC +6
    (26349, 562, 3), -- M.Crit +3
    (26349, 563, 5), -- M.Crit Dmg. +5
    (26349, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (522, 0, 'Crisanta_Spine', 'crisanta_spine', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23262, 0, 'Crsnt_Cuisses', 'crsnt_cuisses', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23262, "CrsntaICss", 33, 0, 131, 308, 0, 0, 128, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23262, 1, 10), -- DEF +10
    (23262, 2, 40), -- HP +40
    (23262, 8, 6), -- STR +6
    (23262, 10, 6), -- VIT +6
    (23262, 23, 12), -- Attack +12
    (23262, 25, 10), -- Accuracy +10
    (23262, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (28550, 0, 'Crisanta_Ring', 'crisanta_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28550, "CrsntaCRng", 33, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28550, 5, 30), -- MP +30
    (28550, 12, 6), -- INT +6
    (28550, 13, 4), -- MND +4
    (28550, 14, 4), -- CHR +4
    (28550, 28, 6), -- MAB +6
    (28550, 30, 6), -- MACC +6
    (28550, 562, 3), -- M.Crit +3
    (28550, 563, 5), -- M.Crit Dmg. +5
    (28550, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (525, 0, 'Percival_Spine', 'percival_spine', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23983, 0, 'Percival_Plate', 'percival_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23983, "PrcvlBPlt", 55, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23983, 1, 18), -- DEF +18
    (23983, 5, 45), -- MP +45
    (23983, 12, 9), -- INT +9
    (23983, 13, 6), -- MND +6
    (23983, 14, 6), -- CHR +6
    (23983, 28, 9), -- MAB +9
    (23983, 30, 9), -- MACC +9
    (23983, 562, 4), -- M.Crit +4
    (23983, 563, 7), -- M.Crit Dmg. +7
    (23983, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (25544, 0, 'Percival_Collar', 'percival_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25544, "PrcvlTCll", 44, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25544, 5, 45), -- MP +45
    (25544, 12, 9), -- INT +9
    (25544, 13, 6), -- MND +6
    (25544, 14, 6), -- CHR +6
    (25544, 28, 9), -- MAB +9
    (25544, 30, 9), -- MACC +9
    (25544, 562, 4), -- M.Crit +4
    (25544, 563, 7), -- M.Crit Dmg. +7
    (25544, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (528, 0, 'Clmns_Fragment', 'clmns_fragment', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23512, 0, 'Clmns_Armguard', 'clmns_armguard', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23512, "ClmnsBAGd", 21, 0, 16924, 70, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23512, 1, 6), -- DEF +6
    (23512, 5, 30), -- MP +30
    (23512, 12, 6), -- INT +6
    (23512, 13, 4), -- MND +4
    (23512, 14, 4), -- CHR +4
    (23512, 28, 6), -- MAB +6
    (23512, 30, 6), -- MACC +6
    (23512, 562, 3), -- M.Crit +3
    (23512, 563, 5), -- M.Crit Dmg. +5
    (23512, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (10789, 0, 'Clemens_Sash', 'clemens_sash', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10789, "clemens_sash", 9, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10789, 5, 15), -- MP +15
    (10789, 12, 3), -- INT +3
    (10789, 13, 2), -- MND +2
    (10789, 14, 2), -- CHR +2
    (10789, 28, 3), -- MAB +3
    (10789, 30, 3), -- MACC +3
    (10789, 562, 2), -- M.Crit +2
    (10789, 563, 3), -- M.Crit Dmg. +3
    (10789, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (531, 0, 'Brthlmw_Stone', 'brthlmw_stone', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23419, 0, 'Brthlmw_Helm', 'brthlmw_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23419, "BrthlmBHlm", 25, 0, 16924, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23419, 1, 8), -- DEF +8
    (23419, 5, 30), -- MP +30
    (23419, 12, 6), -- INT +6
    (23419, 13, 4), -- MND +4
    (23419, 14, 4), -- CHR +4
    (23419, 28, 6), -- MAB +6
    (23419, 30, 6), -- MACC +6
    (23419, 562, 3), -- M.Crit +3
    (23419, 563, 5), -- M.Crit Dmg. +5
    (23419, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (26345, 0, 'Brthlmw_Belt', 'brthlmw_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26345, "BrthlmSBlt", 26, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26345, 1, 3), -- DEF +3
    (26345, 5, 30), -- MP +30
    (26345, 12, 6), -- INT +6
    (26345, 13, 4), -- MND +4
    (26345, 14, 4), -- CHR +4
    (26345, 28, 6), -- MAB +6
    (26345, 30, 6), -- MACC +6
    (26345, 562, 3), -- M.Crit +3
    (26345, 563, 5), -- M.Crit Dmg. +5
    (26345, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (534, 0, 'Conrad_Knuckle', 'conrad_knuckle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23981, 0, 'Conrad_Hauberk', 'conrad_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23981, "CnrdMHbk", 55, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23981, 1, 18), -- DEF +18
    (23981, 5, 45), -- MP +45
    (23981, 12, 9), -- INT +9
    (23981, 13, 6), -- MND +6
    (23981, 14, 6), -- CHR +6
    (23981, 28, 9), -- MAB +9
    (23981, 30, 9), -- MACC +9
    (23981, 562, 4), -- M.Crit +4
    (23981, 563, 7), -- M.Crit Dmg. +7
    (23981, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (23685, 0, 'Conrad_Boots', 'conrad_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23685, "CnrdESBts", 33, 0, 16924, 215, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23685, 1, 6), -- DEF +6
    (23685, 5, 30), -- MP +30
    (23685, 12, 6), -- INT +6
    (23685, 13, 4), -- MND +4
    (23685, 14, 4), -- CHR +4
    (23685, 28, 6), -- MAB +6
    (23685, 30, 6), -- MACC +6
    (23685, 562, 3), -- M.Crit +3
    (23685, 563, 5), -- M.Crit Dmg. +5
    (23685, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (537, 0, 'Theobald_Core', 'theobald_core', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23982, 0, 'Theobald_Plate', 'theobald_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23982, "ThbldCPlt", 67, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23982, 1, 25), -- DEF +25
    (23982, 5, 60), -- MP +60
    (23982, 12, 12), -- INT +12
    (23982, 13, 8), -- MND +8
    (23982, 14, 8), -- CHR +8
    (23982, 28, 12), -- MAB +12
    (23982, 30, 12), -- MACC +12
    (23982, 562, 5), -- M.Crit +5
    (23982, 563, 10), -- M.Crit Dmg. +10
    (23982, 369, 3); -- Refresh +3

REPLACE INTO `item_basic` VALUES (28547, 0, 'Theobald_Ring', 'theobald_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28547, "ThbldWRng", 47, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28547, 5, 45), -- MP +45
    (28547, 12, 9), -- INT +9
    (28547, 13, 6), -- MND +6
    (28547, 14, 6), -- CHR +6
    (28547, 28, 9), -- MAB +9
    (28547, 30, 9), -- MACC +9
    (28547, 562, 4), -- M.Crit +4
    (28547, 563, 7), -- M.Crit Dmg. +7
    (28547, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (540, 0, 'Mortimer_Bark', 'mortimer_bark', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28534, 0, 'Mortimer_Belt', 'mortimer_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28534, "mortimer_belt", 41, 0, 263200, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28534, 9, 9), -- DEX +9
    (28534, 11, 9), -- AGI +9
    (28534, 25, 15), -- Accuracy +15
    (28534, 26, 15), -- Rng. Acc. +15
    (28534, 23, 18), -- Attack +18
    (28534, 24, 18), -- Rng. Atk. +18
    (28534, 68, 15), -- Evasion +15
    (28534, 165, 4); -- Crit Rate +4

REPLACE INTO `item_basic` VALUES (23686, 0, 'Mrtmr_Sandals', 'mrtmr_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23686, "MrtmrRSnd", 25, 0, 263200, 310, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23686, 1, 6), -- DEF +6
    (23686, 9, 6), -- DEX +6
    (23686, 11, 6), -- AGI +6
    (23686, 25, 10), -- Accuracy +10
    (23686, 26, 10), -- Rng. Acc. +10
    (23686, 23, 12), -- Attack +12
    (23686, 24, 12), -- Rng. Atk. +12
    (23686, 68, 10), -- Evasion +10
    (23686, 165, 3); -- Crit Rate +3
REPLACE INTO `item_basic` VALUES (543, 0, 'Aldrc_Heartwood', 'aldrc_heartwood', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28523, 0, 'Aldric_Earring', 'aldric_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28523, "AldrHEar", 46, 0, 263200, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28523, 9, 9), -- DEX +9
    (28523, 11, 9), -- AGI +9
    (28523, 25, 15), -- Accuracy +15
    (28523, 26, 15), -- Rng. Acc. +15
    (28523, 23, 18), -- Attack +18
    (28523, 24, 18), -- Rng. Atk. +18
    (28523, 68, 15), -- Evasion +15
    (28523, 165, 4); -- Crit Rate +4

REPLACE INTO `item_basic` VALUES (26042, 0, 'Aldric_Collar', 'aldric_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26042, "AldrGCll", 58, 0, 10240, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26042, 8, 9), -- STR +9
    (26042, 9, 9), -- DEX +9
    (26042, 23, 18), -- Attack +18
    (26042, 25, 18), -- Accuracy +18
    (26042, 73, 7), -- Store TP +7
    (26042, 384, 300); -- Haste +3%
REPLACE INTO `item_basic` VALUES (546, 0, 'Elspeth_Sap', 'elspeth_sap', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28608, 0, 'Elspeth_Mantle', 'elspeth_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28608, "ElsptGMnt", 74, 0, 263200, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28608, 1, 8), -- DEF +8
    (28608, 9, 12), -- DEX +12
    (28608, 11, 12), -- AGI +12
    (28608, 25, 20), -- Accuracy +20
    (28608, 26, 20), -- Rng. Acc. +20
    (28608, 23, 24), -- Attack +24
    (28608, 24, 24), -- Rng. Atk. +24
    (28608, 68, 20), -- Evasion +20
    (28608, 165, 5); -- Crit Rate +5

REPLACE INTO `item_basic` VALUES (28542, 0, 'Elspeth_Cape', 'elspeth_cape', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28542, "elspeth_cape", 63, 0, 263200, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28542, 9, 12), -- DEX +12
    (28542, 11, 12), -- AGI +12
    (28542, 25, 20), -- Accuracy +20
    (28542, 26, 20), -- Rng. Acc. +20
    (28542, 23, 24), -- Attack +24
    (28542, 24, 24), -- Rng. Atk. +24
    (28542, 68, 20), -- Evasion +20
    (28542, 165, 5); -- Crit Rate +5
REPLACE INTO `item_basic` VALUES (549, 0, 'Wilhelmina_Core', 'wilhelmina_core', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25687, 0, 'Wilhelmina_Robe', 'wilhelmina_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25687, "WhlmnaARbe", 70, 0, 263200, 320, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25687, 1, 25), -- DEF +25
    (25687, 9, 12), -- DEX +12
    (25687, 11, 12), -- AGI +12
    (25687, 25, 20), -- Accuracy +20
    (25687, 26, 20), -- Rng. Acc. +20
    (25687, 23, 24), -- Attack +24
    (25687, 24, 24), -- Rng. Atk. +24
    (25687, 68, 20), -- Evasion +20
    (25687, 165, 5); -- Crit Rate +5

REPLACE INTO `item_basic` VALUES (28564, 0, 'Wilhelmina_Ear', 'wilhelmina_ear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28564, "wilhelmina_ear", 65, 0, 263200, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28564, 9, 12), -- DEX +12
    (28564, 11, 12), -- AGI +12
    (28564, 25, 20), -- Accuracy +20
    (28564, 26, 20), -- Rng. Acc. +20
    (28564, 23, 24), -- Attack +24
    (28564, 24, 24), -- Rng. Atk. +24
    (28564, 68, 20), -- Evasion +20
    (28564, 165, 5); -- Crit Rate +5
REPLACE INTO `item_basic` VALUES (552, 0, 'Marcelino_Imp', 'marcelino_imp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26082, 0, 'Mrcln_Earring', 'mrcln_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26082, "MrclnPEar", 14, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26082, 5, 15), -- MP +15
    (26082, 12, 3), -- INT +3
    (26082, 13, 2), -- MND +2
    (26082, 14, 2), -- CHR +2
    (26082, 28, 3), -- MAB +3
    (26082, 30, 3), -- MACC +3
    (26082, 562, 2), -- M.Crit +2
    (26082, 563, 3), -- M.Crit Dmg. +3
    (26082, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (10786, 0, 'Marcelino_Ring', 'marcelino_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10786, "MrclnTRng", 10, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10786, 8, 2), -- STR +2
    (10786, 9, 3), -- DEX +3
    (10786, 23, 6), -- Attack +6
    (10786, 25, 8), -- Accuracy +8
    (10786, 73, 3), -- Store TP +3
    (10786, 384, 100), -- Haste +1%
    (10786, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (555, 0, 'Temperance_Tail', 'temperance_tail', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23420, 0, 'Temperance_Hat', 'temperance_hat', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23420, "TmprJHat", 28, 0, 131, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23420, 1, 8), -- DEF +8
    (23420, 2, 40), -- HP +40
    (23420, 8, 6), -- STR +6
    (23420, 10, 6), -- VIT +6
    (23420, 23, 12), -- Attack +12
    (23420, 25, 10), -- Accuracy +10
    (23420, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (26000, 0, 'Tmprnc_Collar', 'tmprnc_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26000, "TmprCCll", 58, 0, 10240, 0, 0, 0, 512, 0, 0, 0);

-- Hexing Hieronymus trophy + gear
REPLACE INTO `item_basic` VALUES (558, 0, 'Hieronymus_Wand', 'hieronymus_wand', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25684, 0, 'Hieronymus_Robe', 'hieronymus_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25684, "HrnmsSRbe", 74, 0, 10240, 324, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25684, 1, 25), -- DEF +25
    (25684, 8, 12), -- STR +12
    (25684, 9, 12), -- DEX +12
    (25684, 23, 24), -- Attack +24
    (25684, 25, 24), -- Accuracy +24
    (25684, 73, 10), -- Store TP +10
    (25684, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (28553, 0, 'Hieronymus_Ring', 'hieronymus_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28553, "HrnmsIRng", 33, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28553, 5, 30), -- MP +30
    (28553, 12, 6), -- INT +6
    (28553, 13, 4), -- MND +4
    (28553, 14, 4), -- CHR +4
    (28553, 28, 6), -- MAB +6
    (28553, 30, 6), -- MACC +6
    (28553, 562, 3), -- M.Crit +3
    (28553, 563, 5), -- M.Crit Dmg. +5
    (28553, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (561, 0, 'Gregoire_Staff', 'gregoire_staff', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28607, 0, 'Gregoire_Mantle', 'gregoire_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28607, "GrgrCMnt", 48, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28607, 1, 6), -- DEF +6
    (28607, 5, 45), -- MP +45
    (28607, 12, 9), -- INT +9
    (28607, 13, 6), -- MND +6
    (28607, 14, 6), -- CHR +6
    (28607, 28, 9), -- MAB +9
    (28607, 30, 9), -- MACC +9
    (28607, 562, 4), -- M.Crit +4
    (28607, 563, 7), -- M.Crit Dmg. +7
    (28607, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (28579, 0, 'Gregoire_Ring', 'gregoire_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28579, "GrgrMRng", 33, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28579, 5, 30), -- MP +30
    (28579, 12, 6), -- INT +6
    (28579, 13, 4), -- MND +4
    (28579, 14, 4), -- CHR +4
    (28579, 28, 6), -- MAB +6
    (28579, 30, 6), -- MACC +6
    (28579, 562, 3), -- M.Crit +3
    (28579, 563, 5), -- M.Crit Dmg. +5
    (28579, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (564, 0, 'Tortuga_Stub', 'tortuga_stub', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28549, 0, 'Tortuga_Ring', 'tortuga_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28549, "TrtgaLRng", 43, 0, 10240, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28549, 8, 9), -- STR +9
    (28549, 9, 9), -- DEX +9
    (28549, 23, 18), -- Attack +18
    (28549, 25, 18), -- Accuracy +18
    (28549, 73, 7), -- Store TP +7
    (28549, 384, 300); -- Haste +3%

REPLACE INTO `item_basic` VALUES (23687, 0, 'Tortuga_Boots', 'tortuga_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23687, "TrtgaGBts", 12, 0, 16924, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23687, 1, 3), -- DEF +3
    (23687, 5, 15), -- MP +15
    (23687, 12, 3), -- INT +3
    (23687, 13, 2), -- MND +2
    (23687, 14, 2), -- CHR +2
    (23687, 28, 3), -- MAB +3
    (23687, 30, 3), -- MACC +3
    (23687, 562, 2), -- M.Crit +2
    (23687, 563, 3), -- M.Crit Dmg. +3
    (23687, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (567, 0, 'Sbstn_Knife', 'sbstn_knife', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26006, 0, 'Sbstn_Collar', 'sbstn_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26006, "SbstnCCll", 34, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26006, 5, 30), -- MP +30
    (26006, 12, 6), -- INT +6
    (26006, 13, 4), -- MND +4
    (26006, 14, 4), -- CHR +4
    (26006, 28, 6), -- MAB +6
    (26006, 30, 6), -- MACC +6
    (26006, 562, 3), -- M.Crit +3
    (26006, 563, 5), -- M.Crit Dmg. +5
    (26006, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (25685, 0, 'Sbstn_Apron', 'sbstn_apron', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25685, "SbstnGApn", 52, 0, 16924, 324, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25685, 1, 18), -- DEF +18
    (25685, 5, 45), -- MP +45
    (25685, 12, 9), -- INT +9
    (25685, 13, 6), -- MND +6
    (25685, 14, 6), -- CHR +6
    (25685, 28, 9), -- MAB +9
    (25685, 30, 9), -- MACC +9
    (25685, 562, 4), -- M.Crit +4
    (25685, 563, 7), -- M.Crit Dmg. +7
    (25685, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (570, 0, 'Giuliana_Grudge', 'giuliana_grudge', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28605, 0, 'Giuliana_Mantle', 'giuliana_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28605, "GlnaRMnt", 50, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28605, 1, 6), -- DEF +6
    (28605, 5, 45), -- MP +45
    (28605, 12, 9), -- INT +9
    (28605, 13, 6), -- MND +6
    (28605, 14, 6), -- CHR +6
    (28605, 28, 9), -- MAB +9
    (28605, 30, 9), -- MACC +9
    (28605, 562, 4), -- M.Crit +4
    (28605, 563, 7), -- M.Crit Dmg. +7
    (28605, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (11059, 0, 'Giuliana_Ring', 'giuliana_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11059, "GlnaKRng", 42, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11059, 5, 45), -- MP +45
    (11059, 12, 9), -- INT +9
    (11059, 13, 6), -- MND +6
    (11059, 14, 6), -- CHR +6
    (11059, 28, 9), -- MAB +9
    (11059, 30, 9), -- MACC +9
    (11059, 562, 4), -- M.Crit +4
    (11059, 563, 7), -- M.Crit Dmg. +7
    (11059, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (573, 0, 'LstTnbr_Lantern', 'lsttnbr_lantern', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25686, 0, 'LstTnbrry_Robe', 'lsttnbrry_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25686, "LstTnFRbe", 75, 0, 10240, 320, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25686, 1, 25), -- DEF +25
    (25686, 8, 12), -- STR +12
    (25686, 9, 12), -- DEX +12
    (25686, 23, 24), -- Attack +24
    (25686, 25, 24), -- Accuracy +24
    (25686, 73, 10), -- Store TP +10
    (25686, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (10785, 0, 'LastTnby_Belt', 'lasttnby_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10785, "lasttnby_belt", 55, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10785, 5, 45), -- MP +45
    (10785, 12, 9), -- INT +9
    (10785, 13, 6), -- MND +6
    (10785, 14, 6), -- CHR +6
    (10785, 28, 9), -- MAB +9
    (10785, 30, 9), -- MACC +9
    (10785, 562, 4), -- M.Crit +4
    (10785, 563, 7), -- M.Crit Dmg. +7
    (10785, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (576, 0, 'Rocco_Scale', 'rocco_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23688, 0, 'Rocco_Boots', 'rocco_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23688, "RccoRBts", 12, 0, 131, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23688, 1, 3), -- DEF +3
    (23688, 2, 20), -- HP +20
    (23688, 8, 3), -- STR +3
    (23688, 10, 3), -- VIT +3
    (23688, 23, 6), -- Attack +6
    (23688, 25, 5), -- Accuracy +5
    (23688, 421, 2); -- Crit Dmg. +2

REPLACE INTO `item_basic` VALUES (26083, 0, 'Rocco_Earring', 'rocco_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26083, "RccoAEar", 8, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26083, 5, 15), -- MP +15
    (26083, 12, 3), -- INT +3
    (26083, 13, 2), -- MND +2
    (26083, 14, 2), -- CHR +2
    (26083, 28, 3), -- MAB +3
    (26083, 30, 3), -- MACC +3
    (26083, 562, 2), -- M.Crit +2
    (26083, 563, 3), -- M.Crit Dmg. +3
    (26083, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (579, 0, 'Thessaly_Totem', 'thessaly_totem', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26005, 0, 'Thessaly_Collar', 'thessaly_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26005, "ThslyCCll", 28, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26005, 5, 30), -- MP +30
    (26005, 12, 6), -- INT +6
    (26005, 13, 4), -- MND +4
    (26005, 14, 4), -- CHR +4
    (26005, 28, 6), -- MAB +6
    (26005, 30, 6), -- MACC +6
    (26005, 562, 3), -- M.Crit +3
    (26005, 563, 5), -- M.Crit Dmg. +5
    (26005, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28601, 0, 'Thessaly_Mantle', 'thessaly_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28601, "ThslyRMnt", 26, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28601, 1, 4), -- DEF +4
    (28601, 5, 30), -- MP +30
    (28601, 12, 6), -- INT +6
    (28601, 13, 4), -- MND +4
    (28601, 14, 4), -- CHR +4
    (28601, 28, 6), -- MAB +6
    (28601, 30, 6), -- MACC +6
    (28601, 562, 3), -- M.Crit +3
    (28601, 563, 5), -- M.Crit Dmg. +5
    (28601, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (582, 0, 'Bldssr_Scale', 'bldssr_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23421, 0, 'Baldassare_Helm', 'baldassare_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23421, "BldsrLHlm", 41, 0, 16924, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23421, 1, 12), -- DEF +12
    (23421, 5, 45), -- MP +45
    (23421, 12, 9), -- INT +9
    (23421, 13, 6), -- MND +6
    (23421, 14, 6), -- CHR +6
    (23421, 28, 9), -- MAB +9
    (23421, 30, 9), -- MACC +9
    (23421, 562, 4), -- M.Crit +4
    (23421, 563, 7), -- M.Crit Dmg. +7
    (23421, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (10783, 0, 'Baldassare_Cape', 'baldassare_cape', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10783, "baldassare_cape", 38, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10783, 5, 30), -- MP +30
    (10783, 12, 6), -- INT +6
    (10783, 13, 4), -- MND +4
    (10783, 14, 4), -- CHR +4
    (10783, 28, 6), -- MAB +6
    (10783, 30, 6), -- MACC +6
    (10783, 562, 3), -- M.Crit +3
    (10783, 563, 5), -- M.Crit Dmg. +5
    (10783, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (585, 0, 'Desideria_Fin', 'desideria_fin', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25688, 0, 'Desideria_Robe', 'desideria_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25688, "DsdraARbe", 61, 0, 10240, 322, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25688, 1, 25), -- DEF +25
    (25688, 8, 12), -- STR +12
    (25688, 9, 12), -- DEX +12
    (25688, 23, 24), -- Attack +24
    (25688, 25, 24), -- Accuracy +24
    (25688, 73, 10), -- Store TP +10
    (25688, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (10787, 0, 'Desideria_Ear', 'desideria_ear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10787, "desideria_ear", 43, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10787, 5, 45), -- MP +45
    (10787, 12, 9), -- INT +9
    (10787, 13, 6), -- MND +6
    (10787, 14, 6), -- CHR +6
    (10787, 28, 9), -- MAB +9
    (10787, 30, 9), -- MACC +9
    (10787, 562, 4), -- M.Crit +4
    (10787, 563, 7), -- M.Crit Dmg. +7
    (10787, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (588, 0, 'Prsphn_Plume', 'prsphn_plume', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26089, 0, 'Prsphn_Earring', 'prsphn_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26089, "PrsphnEar", 23, 0, 263200, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26089, 9, 6), -- DEX +6
    (26089, 11, 6), -- AGI +6
    (26089, 25, 10), -- Accuracy +10
    (26089, 26, 10), -- Rng. Acc. +10
    (26089, 23, 12), -- Attack +12
    (26089, 24, 12), -- Rng. Atk. +12
    (26089, 68, 10), -- Evasion +10
    (26089, 165, 3); -- Crit Rate +3

REPLACE INTO `item_basic` VALUES (28217, 0, 'Prsphn_Shoes', 'prsphn_shoes', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28217, "PrsphnGShs", 17, 0, 131, 186, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28217, 1, 3), -- DEF +3
    (28217, 2, 20), -- HP +20
    (28217, 8, 3), -- STR +3
    (28217, 10, 3), -- VIT +3
    (28217, 23, 6), -- Attack +6
    (28217, 25, 5), -- Accuracy +5
    (28217, 421, 2); -- Crit Dmg. +2
REPLACE INTO `item_basic` VALUES (591, 0, 'Theron_Plume', 'theron_plume', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11007, 0, 'Theron_Mantle', 'theron_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11007, "ThrnStMnt", 44, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11007, 1, 6), -- DEF +6
    (11007, 5, 45), -- MP +45
    (11007, 12, 9), -- INT +9
    (11007, 13, 6), -- MND +6
    (11007, 14, 6), -- CHR +6
    (11007, 28, 9), -- MAB +9
    (11007, 30, 9), -- MACC +9
    (11007, 562, 4), -- M.Crit +4
    (11007, 563, 7), -- M.Crit Dmg. +7
    (11007, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (10791, 0, 'Theron_Ring', 'theron_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10791, "ThrnGRng", 26, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10791, 8, 4), -- STR +4
    (10791, 9, 6), -- DEX +6
    (10791, 23, 12), -- Attack +12
    (10791, 25, 14), -- Accuracy +14
    (10791, 73, 5), -- Store TP +5
    (10791, 384, 200), -- Haste +2%
    (10791, 165, 3); -- Crit Rate +3
REPLACE INTO `item_basic` VALUES (594, 0, 'Sbstnn_Scale', 'sbstnn_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23423, 0, 'Sbstnn_Helm', 'sbstnn_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23423, "SbstAHlm", 38, 0, 131, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23423, 1, 8), -- DEF +8
    (23423, 2, 40), -- HP +40
    (23423, 8, 6), -- STR +6
    (23423, 10, 6), -- VIT +6
    (23423, 23, 12), -- Attack +12
    (23423, 25, 10), -- Accuracy +10
    (23423, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (28436, 0, 'Sbstnn_Belt', 'sbstnn_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28436, "SbstWBlt", 39, 0, 131, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28436, 1, 3), -- DEF +3
    (28436, 2, 40), -- HP +40
    (28436, 8, 6), -- STR +6
    (28436, 10, 6), -- VIT +6
    (28436, 23, 12), -- Attack +12
    (28436, 25, 10), -- Accuracy +10
    (28436, 421, 4); -- Crit Dmg. +4
REPLACE INTO `item_basic` VALUES (597, 0, 'Hieronyma_Scale', 'hieronyma_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23984, 0, 'Hieronyma_Plate', 'hieronyma_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23984, "HrnymCPlt", 48, 0, 131, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23984, 1, 18), -- DEF +18
    (23984, 2, 70), -- HP +70
    (23984, 8, 9), -- STR +9
    (23984, 10, 9), -- VIT +9
    (23984, 23, 18), -- Attack +18
    (23984, 25, 15), -- Accuracy +15
    (23984, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES (10792, 0, 'Hieronyma_Ring', 'hieronyma_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10792, "HrnymARng", 32, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10792, 8, 4), -- STR +4
    (10792, 9, 6), -- DEX +6
    (10792, 23, 12), -- Attack +12
    (10792, 25, 14), -- Accuracy +14
    (10792, 73, 5), -- Store TP +5
    (10792, 384, 200), -- Haste +2%
    (10792, 165, 3); -- Crit Rate +3
REPLACE INTO `item_basic` VALUES (600, 0, 'Frntn_Feather', 'frntn_feather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26099, 0, 'Frntn_Earring', 'frntn_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26099, "FrntnDEar", 8, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26099, 5, 15), -- MP +15
    (26099, 12, 3), -- INT +3
    (26099, 13, 2), -- MND +2
    (26099, 14, 2), -- CHR +2
    (26099, 28, 3), -- MAB +3
    (26099, 30, 3), -- MACC +3
    (26099, 562, 2), -- M.Crit +2
    (26099, 563, 3), -- M.Crit Dmg. +3
    (26099, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (10794, 0, 'Fiorentina_Ring', 'fiorentina_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10794, "FrntnTRng", 13, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10794, 5, 15), -- MP +15
    (10794, 12, 3), -- INT +3
    (10794, 13, 2), -- MND +2
    (10794, 14, 2), -- CHR +2
    (10794, 28, 3), -- MAB +3
    (10794, 30, 3), -- MACC +3
    (10794, 562, 2), -- M.Crit +2
    (10794, 563, 3), -- M.Crit Dmg. +3
    (10794, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (603, 0, 'Sgsmnd_Feather', 'sgsmnd_feather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23424, 0, 'Sigismund_Helm', 'sigismund_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23424, "SgsmndCHlm", 37, 0, 131, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23424, 1, 8), -- DEF +8
    (23424, 2, 40), -- HP +40
    (23424, 8, 6), -- STR +6
    (23424, 10, 6), -- VIT +6
    (23424, 23, 12), -- Attack +12
    (23424, 25, 10), -- Accuracy +10
    (23424, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (11000, 0, 'Sgsmnd_Mantle', 'sgsmnd_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11000, "SgsmndGMnt", 26, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11000, 1, 4), -- DEF +4
    (11000, 5, 30), -- MP +30
    (11000, 12, 6), -- INT +6
    (11000, 13, 4), -- MND +4
    (11000, 14, 4), -- CHR +4
    (11000, 28, 6), -- MAB +6
    (11000, 30, 6), -- MACC +6
    (11000, 562, 3), -- M.Crit +3
    (11000, 563, 5), -- M.Crit Dmg. +5
    (11000, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (606, 0, 'Tancred_Quill', 'tancred_quill', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25704, 0, 'Tancred_Plate', 'tancred_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25704, "TncrCyPlt", 49, 0, 131, 234, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25704, 1, 18), -- DEF +18
    (25704, 2, 70), -- HP +70
    (25704, 8, 9), -- STR +9
    (25704, 10, 9), -- VIT +9
    (25704, 23, 18), -- Attack +18
    (25704, 25, 15), -- Accuracy +15
    (25704, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES (10795, 0, 'Tancred_Ring', 'tancred_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10795, "TncrTRng", 35, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10795, 5, 30), -- MP +30
    (10795, 12, 6), -- INT +6
    (10795, 13, 4), -- MND +4
    (10795, 14, 4), -- CHR +4
    (10795, 28, 6), -- MAB +6
    (10795, 30, 6), -- MACC +6
    (10795, 562, 3), -- M.Crit +3
    (10795, 563, 5), -- M.Crit Dmg. +5
    (10795, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (609, 0, 'Andromeda_Quill', 'andromeda_quill', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23717, 0, 'Andromeda_Plate', 'andromeda_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23717, "AndrSSPlt", 60, 0, 131, 163, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23717, 1, 25), -- DEF +25
    (23717, 2, 100), -- HP +100
    (23717, 8, 12), -- STR +12
    (23717, 10, 12), -- VIT +12
    (23717, 23, 24), -- Attack +24
    (23717, 25, 20), -- Accuracy +20
    (23717, 421, 8); -- Crit Dmg. +8

REPLACE INTO `item_basic` VALUES (10793, 0, 'Andromeda_Ring', 'andromeda_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10793, "AndrLRng", 46, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10793, 5, 45), -- MP +45
    (10793, 12, 9), -- INT +9
    (10793, 13, 6), -- MND +6
    (10793, 14, 6), -- CHR +6
    (10793, 28, 9), -- MAB +9
    (10793, 30, 9), -- MACC +9
    (10793, 562, 4), -- M.Crit +4
    (10793, 563, 7), -- M.Crit Dmg. +7
    (10793, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (612, 0, 'Sbstn_Spine', 'sbstn_spine', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (10790, 0, 'Sebastiano_Ring', 'sebastiano_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10790, "SbstnPRng", 10, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10790, 5, 15), -- MP +15
    (10790, 12, 3), -- INT +3
    (10790, 13, 2), -- MND +2
    (10790, 14, 2), -- CHR +2
    (10790, 28, 3), -- MAB +3
    (10790, 30, 3), -- MACC +3
    (10790, 562, 2), -- M.Crit +2
    (10790, 563, 3), -- M.Crit Dmg. +3
    (10790, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28339, 0, 'Sbstn_Boots', 'sbstn_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28339, "SbstnSBts", 14, 0, 131, 350, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28339, 1, 3), -- DEF +3
    (28339, 2, 20), -- HP +20
    (28339, 8, 3), -- STR +3
    (28339, 10, 3), -- VIT +3
    (28339, 23, 6), -- Attack +6
    (28339, 25, 5), -- Accuracy +5
    (28339, 421, 2); -- Crit Dmg. +2
REPLACE INTO `item_basic` VALUES (615, 0, 'Prdnld_Flower', 'prdnld_flower', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27620, 0, 'Prdnld_Mantle', 'prdnld_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27620, "PrdnldDMnt", 28, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27620, 1, 4), -- DEF +4
    (27620, 5, 30), -- MP +30
    (27620, 12, 6), -- INT +6
    (27620, 13, 4), -- MND +4
    (27620, 14, 4), -- CHR +4
    (27620, 28, 6), -- MAB +6
    (27620, 30, 6), -- MACC +6
    (27620, 562, 3), -- M.Crit +3
    (27620, 563, 5), -- M.Crit Dmg. +5
    (27620, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28410, 0, 'Pradinelda_Belt', 'pradinelda_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28410, "PrdnldSBlt", 27, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28410, 1, 3), -- DEF +3
    (28410, 5, 30), -- MP +30
    (28410, 12, 6), -- INT +6
    (28410, 13, 4), -- MND +4
    (28410, 14, 4), -- CHR +4
    (28410, 28, 6), -- MAB +6
    (28410, 30, 6), -- MACC +6
    (28410, 562, 3), -- M.Crit +3
    (28410, 563, 5), -- M.Crit Dmg. +5
    (28410, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (618, 0, 'Serafina_Spine', 'serafina_spine', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23425, 0, 'Serafina_Crown', 'serafina_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23425, "SrfnaDCrn", 34, 0, 16924, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23425, 1, 8), -- DEF +8
    (23425, 5, 30), -- MP +30
    (23425, 12, 6), -- INT +6
    (23425, 13, 4), -- MND +4
    (23425, 14, 4), -- CHR +4
    (23425, 28, 6), -- MAB +6
    (23425, 30, 6), -- MACC +6
    (23425, 562, 3), -- M.Crit +3
    (23425, 563, 5), -- M.Crit Dmg. +5
    (23425, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (10761, 0, 'Serafina_Ear', 'serafina_ear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10761, "serafina_ear", 33, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10761, 5, 30), -- MP +30
    (10761, 12, 6), -- INT +6
    (10761, 13, 4), -- MND +4
    (10761, 14, 4), -- CHR +4
    (10761, 28, 6), -- MAB +6
    (10761, 30, 6), -- MACC +6
    (10761, 562, 3), -- M.Crit +3
    (10761, 563, 5), -- M.Crit Dmg. +5
    (10761, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (621, 0, 'Lazaro_Heart', 'lazaro_heart', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27797, 0, 'Lazaro_Plate', 'lazaro_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27797, "LzrCKPlt", 58, 0, 16924, 186, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27797, 1, 18), -- DEF +18
    (27797, 5, 45), -- MP +45
    (27797, 12, 9), -- INT +9
    (27797, 13, 6), -- MND +6
    (27797, 14, 6), -- CHR +6
    (27797, 28, 9), -- MAB +9
    (27797, 30, 9), -- MACC +9
    (27797, 562, 4), -- M.Crit +4
    (27797, 563, 7), -- M.Crit Dmg. +7
    (27797, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (10755, 0, 'Lazaro_Ear', 'lazaro_ear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10755, "lazaro_ear", 51, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10755, 5, 45), -- MP +45
    (10755, 12, 9), -- INT +9
    (10755, 13, 6), -- MND +6
    (10755, 14, 6), -- CHR +6
    (10755, 28, 9), -- MAB +9
    (10755, 30, 9), -- MACC +9
    (10755, 562, 4), -- M.Crit +4
    (10755, 563, 7), -- M.Crit Dmg. +7
    (10755, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (624, 0, 'Lorcan_Chip', 'lorcan_chip', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28437, 0, 'Lorcan_Belt', 'lorcan_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28437, "LrcnStBlt", 10, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28437, 1, 1), -- DEF +1
    (28437, 5, 15), -- MP +15
    (28437, 12, 3), -- INT +3
    (28437, 13, 2), -- MND +2
    (28437, 14, 2), -- CHR +2
    (28437, 28, 3), -- MAB +3
    (28437, 30, 3), -- MACC +3
    (28437, 562, 2), -- M.Crit +2
    (28437, 563, 3), -- M.Crit Dmg. +3
    (28437, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (23697, 0, 'Lorcan_Boots', 'lorcan_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23697, "LrcnHdBts", 14, 0, 16924, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23697, 1, 3), -- DEF +3
    (23697, 5, 15), -- MP +15
    (23697, 12, 3), -- INT +3
    (23697, 13, 2), -- MND +2
    (23697, 14, 2), -- CHR +2
    (23697, 28, 3), -- MAB +3
    (23697, 30, 3), -- MACC +3
    (23697, 562, 2), -- M.Crit +2
    (23697, 563, 3), -- M.Crit Dmg. +3
    (23697, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (627, 0, 'Thkl_Fragment', 'thkl_fragment', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28602, 0, 'Thkl_Mantle', 'thkl_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28602, "ThklCMnt", 16, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28602, 1, 2), -- DEF +2
    (28602, 5, 15), -- MP +15
    (28602, 12, 3), -- INT +3
    (28602, 13, 2), -- MND +2
    (28602, 14, 2), -- CHR +2
    (28602, 28, 3), -- MAB +3
    (28602, 30, 3), -- MACC +3
    (28602, 562, 2), -- M.Crit +2
    (28602, 563, 3), -- M.Crit Dmg. +3
    (28602, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (26004, 0, 'Thkl_Collar', 'thkl_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26004, "ThklBCll", 18, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26004, 5, 15), -- MP +15
    (26004, 12, 3), -- INT +3
    (26004, 13, 2), -- MND +2
    (26004, 14, 2), -- CHR +2
    (26004, 28, 3), -- MAB +3
    (26004, 30, 3), -- MACC +3
    (26004, 562, 2), -- M.Crit +2
    (26004, 563, 3), -- M.Crit Dmg. +3
    (26004, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (630, 0, 'Godfrey_Horn', 'godfrey_horn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23422, 0, 'Godfrey_Helm', 'godfrey_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23422, "GdfrWHlm", 50, 0, 16924, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23422, 1, 12), -- DEF +12
    (23422, 5, 45), -- MP +45
    (23422, 12, 9), -- INT +9
    (23422, 13, 6), -- MND +6
    (23422, 14, 6), -- CHR +6
    (23422, 28, 9), -- MAB +9
    (23422, 30, 9), -- MACC +9
    (23422, 562, 4), -- M.Crit +4
    (23422, 563, 7), -- M.Crit Dmg. +7
    (23422, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (10756, 0, 'Godfrey_Belt', 'godfrey_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10756, "godfrey_belt", 37, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10756, 5, 30), -- MP +30
    (10756, 12, 6), -- INT +6
    (10756, 13, 4), -- MND +4
    (10756, 14, 4), -- CHR +4
    (10756, 28, 6), -- MAB +6
    (10756, 30, 6), -- MACC +6
    (10756, 562, 3), -- M.Crit +3
    (10756, 563, 5), -- M.Crit Dmg. +5
    (10756, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (633, 0, 'Patricia_Horn', 'patricia_horn', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (27916, 0, 'Ptrc_Hauberk', 'ptrc_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (27916, "PatTPHbk", 65, 0, 16924, 262, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (27916, 1, 25), -- DEF +25
    (27916, 5, 60), -- MP +60
    (27916, 12, 12), -- INT +12
    (27916, 13, 8), -- MND +8
    (27916, 14, 8), -- CHR +8
    (27916, 28, 12), -- MAB +12
    (27916, 30, 12), -- MACC +12
    (27916, 562, 5), -- M.Crit +5
    (27916, 563, 10), -- M.Crit Dmg. +10
    (27916, 369, 3); -- Refresh +3

REPLACE INTO `item_basic` VALUES (10759, 0, 'Patricia_Sash', 'patricia_sash', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10759, "patricia_sash", 55, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10759, 5, 45), -- MP +45
    (10759, 12, 9), -- INT +9
    (10759, 13, 6), -- MND +6
    (10759, 14, 6), -- CHR +6
    (10759, 28, 9), -- MAB +9
    (10759, 30, 9), -- MACC +9
    (10759, 562, 4), -- M.Crit +4
    (10759, 563, 7), -- M.Crit Dmg. +7
    (10759, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (636, 0, 'Sigrid_Jaw', 'sigrid_jaw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23698, 0, 'Sigrid_Sandals', 'sigrid_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23698, "SgrdPtSnd", 11, 0, 263200, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23698, 1, 3), -- DEF +3
    (23698, 9, 3), -- DEX +3
    (23698, 11, 3), -- AGI +3
    (23698, 25, 5), -- Accuracy +5
    (23698, 26, 5), -- Rng. Acc. +5
    (23698, 23, 6), -- Attack +6
    (23698, 24, 6), -- Rng. Atk. +6
    (23698, 68, 5), -- Evasion +5
    (23698, 165, 2); -- Crit Rate +2

REPLACE INTO `item_basic` VALUES (10763, 0, 'Sigrid_Ring', 'sigrid_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10763, "SgrdTRng", 14, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10763, 8, 2), -- STR +2
    (10763, 9, 3), -- DEX +3
    (10763, 23, 6), -- Attack +6
    (10763, 25, 8), -- Accuracy +8
    (10763, 73, 3), -- Store TP +3
    (10763, 384, 100), -- Haste +1%
    (10763, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (639, 0, 'Bllncr_Mandible', 'bllncr_mandible', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23513, 0, 'Bllncrt_Mitts', 'bllncrt_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23513, "BlncrtCMtt", 30, 0, 16924, 72, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23513, 1, 6), -- DEF +6
    (23513, 5, 30), -- MP +30
    (23513, 12, 6), -- INT +6
    (23513, 13, 4), -- MND +4
    (23513, 14, 4), -- CHR +4
    (23513, 28, 6), -- MAB +6
    (23513, 30, 6), -- MACC +6
    (23513, 562, 3), -- M.Crit +3
    (23513, 563, 5), -- M.Crit Dmg. +5
    (23513, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (26325, 0, 'Bllncrt_Belt', 'bllncrt_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26325, "BlncrtSBlt", 6, 0, 263200, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26325, 1, 1), -- DEF +1
    (26325, 9, 3), -- DEX +3
    (26325, 11, 3), -- AGI +3
    (26325, 25, 5), -- Accuracy +5
    (26325, 26, 5), -- Rng. Acc. +5
    (26325, 23, 6), -- Attack +6
    (26325, 24, 6), -- Rng. Atk. +6
    (26325, 68, 5), -- Evasion +5
    (26325, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (642, 0, 'Crescentia_Jaw', 'crescentia_jaw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (10487, 0, 'Crscnt_Hauberk', 'crscnt_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10487, "CrscntAHbk", 36, 0, 131, 48, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10487, 1, 12), -- DEF +12
    (10487, 2, 40), -- HP +40
    (10487, 8, 6), -- STR +6
    (10487, 10, 6), -- VIT +6
    (10487, 23, 12), -- Attack +12
    (10487, 25, 10), -- Accuracy +10
    (10487, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (10758, 0, 'Crescntia_Ear', 'crescntia_ear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10758, "crescntia_ear", 23, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10758, 5, 30), -- MP +30
    (10758, 12, 6), -- INT +6
    (10758, 13, 4), -- MND +4
    (10758, 14, 4), -- CHR +4
    (10758, 28, 6), -- MAB +6
    (10758, 30, 6), -- MACC +6
    (10758, 562, 3), -- M.Crit +3
    (10758, 563, 5), -- M.Crit Dmg. +5
    (10758, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (645, 0, 'Adlbrt_Mandible', 'adlbrt_mandible', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (10479, 0, 'Adlbrt_Carapace', 'adlbrt_carapace', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10479, "AdlbrtTCrp", 46, 0, 131, 196, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10479, 1, 18), -- DEF +18
    (10479, 2, 70), -- HP +70
    (10479, 8, 9), -- STR +9
    (10479, 10, 9), -- VIT +9
    (10479, 23, 18), -- Attack +18
    (10479, 25, 15), -- Accuracy +15
    (10479, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES (10760, 0, 'Adalbert_Cape', 'adalbert_cape', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10760, "adalbert_cape", 34, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10760, 5, 30), -- MP +30
    (10760, 12, 6), -- INT +6
    (10760, 13, 4), -- MND +4
    (10760, 14, 4), -- CHR +4
    (10760, 28, 6), -- MAB +6
    (10760, 30, 6), -- MACC +6
    (10760, 562, 3), -- M.Crit +3
    (10760, 563, 5), -- M.Crit Dmg. +5
    (10760, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (648, 0, 'Wilhelmus_Scale', 'wilhelmus_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (10762, 0, 'Wilhelmus_Belt', 'wilhelmus_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10762, "wilhelmus_belt", 8, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10762, 5, 15), -- MP +15
    (10762, 12, 3), -- INT +3
    (10762, 13, 2), -- MND +2
    (10762, 14, 2), -- CHR +2
    (10762, 28, 3), -- MAB +3
    (10762, 30, 3), -- MACC +3
    (10762, 562, 2), -- M.Crit +2
    (10762, 563, 3), -- M.Crit Dmg. +3
    (10762, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (23699, 0, 'Wilhelmus_Boots', 'wilhelmus_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23699, "WhlmsCBts", 11, 0, 131, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23699, 1, 3), -- DEF +3
    (23699, 2, 20), -- HP +20
    (23699, 8, 3), -- STR +3
    (23699, 10, 3), -- VIT +3
    (23699, 23, 6), -- Attack +6
    (23699, 25, 5), -- Accuracy +5
    (23699, 421, 2); -- Crit Dmg. +2
REPLACE INTO `item_basic` VALUES (651, 0, 'Frederik_Scale', 'frederik_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23436, 0, 'Frederik_Helm', 'frederik_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23436, "FrdrkIDHlm", 39, 0, 16924, 339, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23436, 1, 8), -- DEF +8
    (23436, 5, 30), -- MP +30
    (23436, 12, 6), -- INT +6
    (23436, 13, 4), -- MND +4
    (23436, 14, 4), -- CHR +4
    (23436, 28, 6), -- MAB +6
    (23436, 30, 6), -- MACC +6
    (23436, 562, 3), -- M.Crit +3
    (23436, 563, 5), -- M.Crit Dmg. +5
    (23436, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28594, 0, 'Frederik_Mantle', 'frederik_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28594, "FrdrkBMnt", 22, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28594, 1, 4), -- DEF +4
    (28594, 5, 30), -- MP +30
    (28594, 12, 6), -- INT +6
    (28594, 13, 4), -- MND +4
    (28594, 14, 4), -- CHR +4
    (28594, 28, 6), -- MAB +6
    (28594, 30, 6), -- MACC +6
    (28594, 562, 3), -- M.Crit +3
    (28594, 563, 5), -- M.Crit Dmg. +5
    (28594, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (654, 0, 'Vlntns_Gland', 'vlntns_gland', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23950, 0, 'Vlntns_Hauberk', 'vlntns_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23950, "VlntnWHbk", 55, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23950, 1, 18), -- DEF +18
    (23950, 5, 45), -- MP +45
    (23950, 12, 9), -- INT +9
    (23950, 13, 6), -- MND +6
    (23950, 14, 6), -- CHR +6
    (23950, 28, 9), -- MAB +9
    (23950, 30, 9), -- MACC +9
    (23950, 562, 4), -- M.Crit +4
    (23950, 563, 7), -- M.Crit Dmg. +7
    (23950, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (10754, 0, 'Valentin_Cape', 'valentin_cape', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10754, "valentin_cape", 34, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10754, 5, 30), -- MP +30
    (10754, 12, 6), -- INT +6
    (10754, 13, 4), -- MND +4
    (10754, 14, 4), -- CHR +4
    (10754, 28, 6), -- MAB +6
    (10754, 30, 6), -- MACC +6
    (10754, 562, 3), -- M.Crit +3
    (10754, 563, 5), -- M.Crit Dmg. +5
    (10754, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (657, 0, 'Agrippa_Heart', 'agrippa_heart', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23951, 0, 'Agrippa_Plate', 'agrippa_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23951, "AgrppADPlt", 46, 0, 131, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23951, 1, 18), -- DEF +18
    (23951, 2, 70), -- HP +70
    (23951, 8, 9), -- STR +9
    (23951, 10, 9), -- VIT +9
    (23951, 23, 18), -- Attack +18
    (23951, 25, 15), -- Accuracy +15
    (23951, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES (10757, 0, 'Agrippa_Cape', 'agrippa_cape', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10757, "agrippa_cape", 47, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10757, 5, 45), -- MP +45
    (10757, 12, 9), -- INT +9
    (10757, 13, 6), -- MND +6
    (10757, 14, 6), -- CHR +6
    (10757, 28, 9), -- MAB +9
    (10757, 30, 9), -- MACC +9
    (10757, 562, 4), -- M.Crit +4
    (10757, 563, 7), -- M.Crit Dmg. +7
    (10757, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (660, 0, 'Wilhelmina_Gear', 'wilhelmina_gear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (10750, 0, 'Wilhelmina_Ring', 'wilhelmina_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10750, "WhlmGRng", 44, 0, 10240, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10750, 8, 9), -- STR +9
    (10750, 9, 9), -- DEX +9
    (10750, 23, 18), -- Attack +18
    (10750, 25, 18), -- Accuracy +18
    (10750, 73, 7), -- Store TP +7
    (10750, 384, 300); -- Haste +3%

REPLACE INTO `item_basic` VALUES (23700, 0, 'Wlhlmn_Boots', 'wlhlmn_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23700, "WhlmMBts", 14, 0, 16924, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23700, 1, 3), -- DEF +3
    (23700, 5, 15), -- MP +15
    (23700, 12, 3), -- INT +3
    (23700, 13, 2), -- MND +2
    (23700, 14, 2), -- CHR +2
    (23700, 28, 3), -- MAB +3
    (23700, 30, 3), -- MACC +3
    (23700, 562, 2), -- M.Crit +2
    (23700, 563, 3), -- M.Crit Dmg. +3
    (23700, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (663, 0, 'Clgr_Mainspring', 'clgr_mainspring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25419, 0, 'Calogero_Collar', 'calogero_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25419, "ClgrACll", 22, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25419, 5, 30), -- MP +30
    (25419, 12, 6), -- INT +6
    (25419, 13, 4), -- MND +4
    (25419, 14, 4), -- CHR +4
    (25419, 28, 6), -- MAB +6
    (25419, 30, 6), -- MACC +6
    (25419, 562, 3), -- M.Crit +3
    (25419, 563, 5), -- M.Crit Dmg. +5
    (25419, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28414, 0, 'Calogero_Belt', 'calogero_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28414, "ClgrGBlt", 12, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28414, 1, 1), -- DEF +1
    (28414, 5, 15), -- MP +15
    (28414, 12, 3), -- INT +3
    (28414, 13, 2), -- MND +2
    (28414, 14, 2), -- CHR +2
    (28414, 28, 3), -- MAB +3
    (28414, 30, 3), -- MACC +3
    (28414, 562, 2), -- M.Crit +2
    (28414, 563, 3), -- M.Crit Dmg. +3
    (28414, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (666, 0, 'Agatha_Core', 'agatha_core', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23952, 0, 'Agatha_Hauberk', 'agatha_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23952, "AgtArcHbk", 63, 0, 10240, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23952, 1, 25), -- DEF +25
    (23952, 8, 12), -- STR +12
    (23952, 9, 12), -- DEX +12
    (23952, 23, 24), -- Attack +24
    (23952, 25, 24), -- Accuracy +24
    (23952, 73, 10), -- Store TP +10
    (23952, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (10753, 0, 'Agatha_Sash', 'agatha_sash', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10753, "agatha_sash", 39, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10753, 5, 30), -- MP +30
    (10753, 12, 6), -- INT +6
    (10753, 13, 4), -- MND +4
    (10753, 14, 4), -- CHR +4
    (10753, 28, 6), -- MAB +6
    (10753, 30, 6), -- MACC +6
    (10753, 562, 3), -- M.Crit +3
    (10753, 563, 5), -- M.Crit Dmg. +5
    (10753, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (669, 0, 'Ptolemais_Core', 'ptolemais_core', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23953, 0, 'Ptolemais_Body', 'ptolemais_body', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23953, "PtlmPBdy", 65, 0, 10240, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23953, 1, 25), -- DEF +25
    (23953, 8, 12), -- STR +12
    (23953, 9, 12), -- DEX +12
    (23953, 23, 24), -- Attack +24
    (23953, 25, 24), -- Accuracy +24
    (23953, 73, 10), -- Store TP +10
    (23953, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (10751, 0, 'Ptolemais_Ear', 'ptolemais_ear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (10751, "ptolemais_ear", 56, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (10751, 5, 45), -- MP +45
    (10751, 12, 9), -- INT +9
    (10751, 13, 6), -- MND +6
    (10751, 14, 6), -- CHR +6
    (10751, 28, 9), -- MAB +9
    (10751, 30, 9), -- MACC +9
    (10751, 562, 4), -- M.Crit +4
    (10751, 563, 7), -- M.Crit Dmg. +7
    (10751, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (672, 0, 'Dervish_Blade', 'dervish_blade', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11660, 0, 'Dervish_Ring', 'dervish_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11660, "DrvshBRng", 20, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11660, 5, 30), -- MP +30
    (11660, 12, 6), -- INT +6
    (11660, 13, 4), -- MND +4
    (11660, 14, 4), -- CHR +4
    (11660, 28, 6), -- MAB +6
    (11660, 30, 6), -- MACC +6
    (11660, 562, 3), -- M.Crit +3
    (11660, 563, 5), -- M.Crit Dmg. +5
    (11660, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (26339, 0, 'Dervish_Belt', 'dervish_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26339, "DrvshDBlt", 9, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26339, 1, 1), -- DEF +1
    (26339, 5, 15), -- MP +15
    (26339, 12, 3), -- INT +3
    (26339, 13, 2), -- MND +2
    (26339, 14, 2), -- CHR +2
    (26339, 28, 3), -- MAB +3
    (26339, 30, 3), -- MACC +3
    (26339, 562, 2), -- M.Crit +2
    (26339, 563, 3), -- M.Crit Dmg. +3
    (26339, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (675, 0, 'Wenceslas_Edge', 'wenceslas_edge', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28521, 0, 'Wncsls_Earring', 'wncsls_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28521, "WncslsVEar", 26, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28521, 5, 30), -- MP +30
    (28521, 12, 6), -- INT +6
    (28521, 13, 4), -- MND +4
    (28521, 14, 4), -- CHR +4
    (28521, 28, 6), -- MAB +6
    (28521, 30, 6), -- MACC +6
    (28521, 562, 3), -- M.Crit +3
    (28521, 563, 5), -- M.Crit Dmg. +5
    (28521, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28595, 0, 'Wncsls_Mantle', 'wncsls_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28595, "WncslsAMnt", 21, 0, 16924, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28595, 1, 4), -- DEF +4
    (28595, 5, 30), -- MP +30
    (28595, 12, 6), -- INT +6
    (28595, 13, 4), -- MND +4
    (28595, 14, 4), -- CHR +4
    (28595, 28, 6), -- MAB +6
    (28595, 30, 6), -- MACC +6
    (28595, 562, 3), -- M.Crit +3
    (28595, 563, 5), -- M.Crit Dmg. +5
    (28595, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (678, 0, 'Corneline_Steel', 'corneline_steel', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23954, 0, 'Crnln_Hauberk', 'crnln_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23954, "CrnlnHHbk", 58, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23954, 1, 18), -- DEF +18
    (23954, 5, 45), -- MP +45
    (23954, 12, 9), -- INT +9
    (23954, 13, 6), -- MND +6
    (23954, 14, 6), -- CHR +6
    (23954, 28, 9), -- MAB +9
    (23954, 30, 9), -- MACC +9
    (23954, 562, 4), -- M.Crit +4
    (23954, 563, 7), -- M.Crit Dmg. +7
    (23954, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (11659, 0, 'Corneline_Ring', 'corneline_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11659, "CrnlnPhRng", 36, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11659, 5, 30), -- MP +30
    (11659, 12, 6), -- INT +6
    (11659, 13, 4), -- MND +4
    (11659, 14, 4), -- CHR +4
    (11659, 28, 6), -- MAB +6
    (11659, 30, 6), -- MACC +6
    (11659, 562, 3), -- M.Crit +3
    (11659, 563, 5), -- M.Crit Dmg. +5
    (11659, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (681, 0, 'Emerick_Edge', 'emerick_edge', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23955, 0, 'Emerick_Plate', 'emerick_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23955, "EmrckEPlt", 66, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23955, 1, 25), -- DEF +25
    (23955, 5, 60), -- MP +60
    (23955, 12, 12), -- INT +12
    (23955, 13, 8), -- MND +8
    (23955, 14, 8), -- CHR +8
    (23955, 28, 12), -- MAB +12
    (23955, 30, 12), -- MACC +12
    (23955, 562, 5), -- M.Crit +5
    (23955, 563, 10), -- M.Crit Dmg. +10
    (23955, 369, 3); -- Refresh +3

REPLACE INTO `item_basic` VALUES (11657, 0, 'Emerick_Ring', 'emerick_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11657, "EmrckDRng", 60, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11657, 5, 60), -- MP +60
    (11657, 12, 12), -- INT +12
    (11657, 13, 8), -- MND +8
    (11657, 14, 8), -- CHR +8
    (11657, 28, 12), -- MAB +12
    (11657, 30, 12), -- MACC +12
    (11657, 562, 5), -- M.Crit +5
    (11657, 563, 10), -- M.Crit Dmg. +10
    (11657, 369, 3); -- Refresh +3
REPLACE INTO `item_basic` VALUES (684, 0, 'Wilhemina_Wisp', 'wilhemina_wisp', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26080, 0, 'Wlhmn_Earring', 'wlhmn_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26080, "WhlmnaEar", 15, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26080, 5, 15), -- MP +15
    (26080, 12, 3), -- INT +3
    (26080, 13, 2), -- MND +2
    (26080, 14, 2), -- CHR +2
    (26080, 28, 3), -- MAB +3
    (26080, 30, 3), -- MACC +3
    (26080, 562, 2), -- M.Crit +2
    (26080, 563, 3), -- M.Crit Dmg. +3
    (26080, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (11658, 0, 'Wilhemina_Ring', 'wilhemina_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11658, "WhlmnaSpRng", 39, 0, 10240, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11658, 8, 6), -- STR +6
    (11658, 9, 6), -- DEX +6
    (11658, 23, 12), -- Attack +12
    (11658, 25, 12), -- Accuracy +12
    (11658, 73, 5), -- Store TP +5
    (11658, 384, 200); -- Haste +2%
REPLACE INTO `item_basic` VALUES (687, 0, 'Sgsmnd_Remnant', 'sgsmnd_remnant', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25431, 0, 'Sgsmnd_Collar', 'sgsmnd_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25431, "SgsmndBCll", 51, 0, 10240, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25431, 8, 9), -- STR +9
    (25431, 9, 9), -- DEX +9
    (25431, 23, 18), -- Attack +18
    (25431, 25, 18), -- Accuracy +18
    (25431, 73, 7), -- Store TP +7
    (25431, 384, 300); -- Haste +3%

REPLACE INTO `item_basic` VALUES (23514, 0, 'Sgsmnd_Mitts', 'sgsmnd_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23514, "SgsmndHMtt", 11, 0, 16924, 74, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23514, 1, 3), -- DEF +3
    (23514, 5, 15), -- MP +15
    (23514, 12, 3), -- INT +3
    (23514, 13, 2), -- MND +2
    (23514, 14, 2), -- CHR +2
    (23514, 28, 3), -- MAB +3
    (23514, 30, 3), -- MACC +3
    (23514, 562, 2), -- M.Crit +2
    (23514, 563, 3), -- M.Crit Dmg. +3
    (23514, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (690, 0, 'Phnts_Ectoplasm', 'phnts_ectoplasm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23956, 0, 'Phantasia_Robe', 'phantasia_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23956, "PhntsaSRbe", 73, 0, 10240, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23956, 1, 25), -- DEF +25
    (23956, 8, 12), -- STR +12
    (23956, 9, 12), -- DEX +12
    (23956, 23, 24), -- Attack +24
    (23956, 25, 24), -- Accuracy +24
    (23956, 73, 10), -- Store TP +10
    (23956, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (11661, 0, 'Phantasia_Ring', 'phantasia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11661, "PhntsaWRng", 29, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11661, 5, 30), -- MP +30
    (11661, 12, 6), -- INT +6
    (11661, 13, 4), -- MND +4
    (11661, 14, 4), -- CHR +4
    (11661, 28, 6), -- MAB +6
    (11661, 30, 6), -- MACC +6
    (11661, 562, 3), -- M.Crit +3
    (11661, 563, 5), -- M.Crit Dmg. +5
    (11661, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (693, 0, 'Euphemia_Tear', 'euphemia_tear', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23957, 0, 'Euphemia_Robe', 'euphemia_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23957, "EphMRobe", 72, 0, 10240, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23957, 1, 25), -- DEF +25
    (23957, 8, 12), -- STR +12
    (23957, 9, 12), -- DEX +12
    (23957, 23, 24), -- Attack +24
    (23957, 25, 24), -- Accuracy +24
    (23957, 73, 10), -- Store TP +10
    (23957, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (11662, 0, 'Euphemia_Ring', 'euphemia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11662, "EphLmtRng", 33, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11662, 5, 30), -- MP +30
    (11662, 12, 6), -- INT +6
    (11662, 13, 4), -- MND +4
    (11662, 14, 4), -- CHR +4
    (11662, 28, 6), -- MAB +6
    (11662, 30, 6), -- MACC +6
    (11662, 562, 3), -- M.Crit +3
    (11662, 563, 5), -- M.Crit Dmg. +5
    (11662, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (696, 0, 'Bartholomea_Eye', 'bartholomea_eye', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26100, 0, 'Brthlm_Earring', 'brthlm_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26100, "BrthlmaEar", 50, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26100, 5, 45), -- MP +45
    (26100, 12, 9), -- INT +9
    (26100, 13, 6), -- MND +6
    (26100, 14, 6), -- CHR +6
    (26100, 28, 9), -- MAB +9
    (26100, 30, 9), -- MACC +9
    (26100, 562, 4), -- M.Crit +4
    (26100, 563, 7), -- M.Crit Dmg. +7
    (26100, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (11669, 0, 'Brthlm_Ring', 'brthlm_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11669, "BrthlmaRng", 10, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11669, 5, 15), -- MP +15
    (11669, 12, 3), -- INT +3
    (11669, 13, 2), -- MND +2
    (11669, 14, 2), -- CHR +2
    (11669, 28, 3), -- MAB +3
    (11669, 30, 3), -- MACC +3
    (11669, 562, 2), -- M.Crit +2
    (11669, 563, 3), -- M.Crit Dmg. +3
    (11669, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (699, 0, 'Stanislao_Eye', 'stanislao_eye', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25526, 0, 'Stnsl_Collar', 'stnsl_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25526, "StnslaWCll", 52, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25526, 5, 45), -- MP +45
    (25526, 12, 9), -- INT +9
    (25526, 13, 6), -- MND +6
    (25526, 14, 6), -- CHR +6
    (25526, 28, 9), -- MAB +9
    (25526, 30, 9), -- MACC +9
    (25526, 562, 4), -- M.Crit +4
    (25526, 563, 7), -- M.Crit Dmg. +7
    (25526, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (23526, 0, 'Stanislao_Mitts', 'stanislao_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23526, "StnslaAMtt", 21, 0, 16924, 169, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23526, 1, 6), -- DEF +6
    (23526, 5, 30), -- MP +30
    (23526, 12, 6), -- INT +6
    (23526, 13, 4), -- MND +4
    (23526, 14, 4), -- CHR +4
    (23526, 28, 6), -- MAB +6
    (23526, 30, 6), -- MACC +6
    (23526, 562, 3), -- M.Crit +3
    (23526, 563, 5), -- M.Crit Dmg. +5
    (23526, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (702, 0, 'Prclsn_Gaze', 'prclsn_gaze', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23760, 0, 'Prclsn_Visor', 'prclsn_visor', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23760, "PrclsSVsr", 53, 0, 16924, 469, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23760, 1, 12), -- DEF +12
    (23760, 5, 45), -- MP +45
    (23760, 12, 9), -- INT +9
    (23760, 13, 6), -- MND +6
    (23760, 14, 6), -- CHR +6
    (23760, 28, 9), -- MAB +9
    (23760, 30, 9), -- MACC +9
    (23760, 562, 4), -- M.Crit +4
    (23760, 563, 7), -- M.Crit Dmg. +7
    (23760, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (11674, 0, 'Prclsn_Ring', 'prclsn_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11674, "PrclsPRng", 63, 0, 10240, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11674, 8, 12), -- STR +12
    (11674, 9, 12), -- DEX +12
    (11674, 23, 24), -- Attack +24
    (11674, 25, 24), -- Accuracy +24
    (11674, 73, 10), -- Store TP +10
    (11674, 384, 400); -- Haste +4%
REPLACE INTO `item_basic` VALUES (705, 0, 'Arbogast_Eye', 'arbogast_eye', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23958, 0, 'Arbogast_Robe', 'arbogast_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23958, "ArbgstSRbe", 52, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23958, 1, 18), -- DEF +18
    (23958, 5, 45), -- MP +45
    (23958, 12, 9), -- INT +9
    (23958, 13, 6), -- MND +6
    (23958, 14, 6), -- CHR +6
    (23958, 28, 9), -- MAB +9
    (23958, 30, 9), -- MACC +9
    (23958, 562, 4), -- M.Crit +4
    (23958, 563, 7), -- M.Crit Dmg. +7
    (23958, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (11656, 0, 'Arbogast_Ring', 'arbogast_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11656, "ArbgstORng", 57, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11656, 5, 45), -- MP +45
    (11656, 12, 9), -- INT +9
    (11656, 13, 6), -- MND +6
    (11656, 14, 6), -- CHR +6
    (11656, 28, 9), -- MAB +9
    (11656, 30, 9), -- MACC +9
    (11656, 562, 4), -- M.Crit +4
    (11656, 563, 7), -- M.Crit Dmg. +7
    (11656, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (708, 0, 'Svetlana_Talon', 'svetlana_talon', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26101, 0, 'Svtln_Earring', 'svtln_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26101, "SvtlnBEar", 6, 0, 263200, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26101, 9, 3), -- DEX +3
    (26101, 11, 3), -- AGI +3
    (26101, 25, 5), -- Accuracy +5
    (26101, 26, 5), -- Rng. Acc. +5
    (26101, 23, 6), -- Attack +6
    (26101, 24, 6), -- Rng. Atk. +6
    (26101, 68, 5), -- Evasion +5
    (26101, 165, 2); -- Crit Rate +2

REPLACE INTO `item_basic` VALUES (23701, 0, 'Svetlana_Boots', 'svetlana_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23701, "SvtlnSBts", 5, 0, 263200, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23701, 1, 3), -- DEF +3
    (23701, 9, 3), -- DEX +3
    (23701, 11, 3), -- AGI +3
    (23701, 25, 5), -- Accuracy +5
    (23701, 26, 5), -- Rng. Acc. +5
    (23701, 23, 6), -- Attack +6
    (23701, 24, 6), -- Rng. Atk. +6
    (23701, 68, 5), -- Evasion +5
    (23701, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (711, 0, 'Csmr_Feather', 'csmr_feather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (28596, 0, 'Casimira_Mantle', 'casimira_mantle', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28596, "CsmraDGMnt", 29, 0, 131, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28596, 1, 4), -- DEF +4
    (28596, 2, 40), -- HP +40
    (28596, 8, 6), -- STR +6
    (28596, 10, 6), -- VIT +6
    (28596, 23, 12), -- Attack +12
    (28596, 25, 10), -- Accuracy +10
    (28596, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (11663, 0, 'Casimira_Ring', 'casimira_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11663, "CsmraGRng", 14, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11663, 8, 2), -- STR +2
    (11663, 9, 3), -- DEX +3
    (11663, 23, 6), -- Attack +6
    (11663, 25, 8), -- Accuracy +8
    (11663, 73, 3), -- Store TP +3
    (11663, 384, 100), -- Haste +1%
    (11663, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (714, 0, 'Bnvntr_Beak', 'bnvntr_beak', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23393, 0, 'Bnvntr_Helm', 'bnvntr_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23393, "BnvntGHlm", 35, 0, 131, 211, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23393, 1, 8), -- DEF +8
    (23393, 2, 40), -- HP +40
    (23393, 8, 6), -- STR +6
    (23393, 10, 6), -- VIT +6
    (23393, 23, 12), -- Attack +12
    (23393, 25, 10), -- Accuracy +10
    (23393, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (28467, 0, 'Bnvntr_Belt', 'bnvntr_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28467, "BnvntCBlt", 16, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28467, 1, 1), -- DEF +1
    (28467, 5, 15), -- MP +15
    (28467, 12, 3), -- INT +3
    (28467, 13, 2), -- MND +2
    (28467, 14, 2), -- CHR +2
    (28467, 28, 3), -- MAB +3
    (28467, 30, 3), -- MACC +3
    (28467, 562, 2), -- M.Crit +2
    (28467, 563, 3), -- M.Crit Dmg. +3
    (28467, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (717, 0, 'Srphns_Feather', 'srphns_feather', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23959, 0, 'Srphns_Plate', 'srphns_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23959, "SrphnusSKPlt", 52, 0, 131, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23959, 1, 18), -- DEF +18
    (23959, 2, 70), -- HP +70
    (23959, 8, 9), -- STR +9
    (23959, 10, 9), -- VIT +9
    (23959, 23, 18), -- Attack +18
    (23959, 25, 15), -- Accuracy +15
    (23959, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES (11651, 0, 'Seraphinus_Ring', 'seraphinus_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11651, "SrphnusDRng", 33, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11651, 5, 30), -- MP +30
    (11651, 12, 6), -- INT +6
    (11651, 13, 4), -- MND +4
    (11651, 14, 4), -- CHR +4
    (11651, 28, 6), -- MAB +6
    (11651, 30, 6), -- MACC +6
    (11651, 562, 3), -- M.Crit +3
    (11651, 563, 5), -- M.Crit Dmg. +5
    (11651, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (720, 0, 'Chchstr_Pebble', 'chchstr_pebble', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11670, 0, 'Chichester_Ring', 'chichester_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11670, "ChchtrCRng", 14, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11670, 8, 2), -- STR +2
    (11670, 9, 3), -- DEX +3
    (11670, 23, 6), -- Attack +6
    (11670, 25, 8), -- Accuracy +8
    (11670, 73, 3), -- Store TP +3
    (11670, 384, 100), -- Haste +1%
    (11670, 165, 2); -- Crit Rate +2

REPLACE INTO `item_basic` VALUES (23702, 0, 'Chchstr_Boots', 'chchstr_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23702, "ChchtrNBts", 9, 0, 131, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23702, 1, 3), -- DEF +3
    (23702, 2, 20), -- HP +20
    (23702, 8, 3), -- STR +3
    (23702, 10, 3), -- VIT +3
    (23702, 23, 6), -- Attack +6
    (23702, 25, 5), -- Accuracy +5
    (23702, 421, 2); -- Crit Dmg. +2
REPLACE INTO `item_basic` VALUES (723, 0, 'Theodolinda_Gem', 'theodolinda_gem', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23515, 0, 'Thdlnd_Mitts', 'thdlnd_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23515, "ThdlndPMtt", 17, 0, 16924, 76, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23515, 1, 3), -- DEF +3
    (23515, 5, 15), -- MP +15
    (23515, 12, 3), -- INT +3
    (23515, 13, 2), -- MND +2
    (23515, 14, 2), -- CHR +2
    (23515, 28, 3), -- MAB +3
    (23515, 30, 3), -- MACC +3
    (23515, 562, 2), -- M.Crit +2
    (23515, 563, 3), -- M.Crit Dmg. +3
    (23515, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (26102, 0, 'Thdlnd_Earring', 'thdlnd_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26102, "ThdlndSEar", 30, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26102, 5, 30), -- MP +30
    (26102, 12, 6), -- INT +6
    (26102, 13, 4), -- MND +4
    (26102, 14, 4), -- CHR +4
    (26102, 28, 6), -- MAB +6
    (26102, 30, 6), -- MACC +6
    (26102, 562, 3), -- M.Crit +3
    (26102, 563, 5), -- M.Crit Dmg. +5
    (26102, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (726, 0, 'Blthzr_Banana', 'blthzr_banana', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23411, 0, 'Balthazar_Crown', 'balthazar_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23411, "BlthzrJCrn", 32, 0, 131, 91, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23411, 1, 8), -- DEF +8
    (23411, 2, 40), -- HP +40
    (23411, 8, 6), -- STR +6
    (23411, 10, 6), -- VIT +6
    (23411, 23, 12), -- Attack +12
    (23411, 25, 10), -- Accuracy +10
    (23411, 421, 4); -- Crit Dmg. +4

REPLACE INTO `item_basic` VALUES (28426, 0, 'Balthazar_Belt', 'balthazar_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28426, "BlthzrTBlt", 28, 0, 131, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28426, 1, 3), -- DEF +3
    (28426, 2, 40), -- HP +40
    (28426, 8, 6), -- STR +6
    (28426, 10, 6), -- VIT +6
    (28426, 23, 12), -- Attack +12
    (28426, 25, 10), -- Accuracy +10
    (28426, 421, 4); -- Crit Dmg. +4
REPLACE INTO `item_basic` VALUES (729, 0, 'Plgs_Insignia', 'plgs_insignia', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23960, 0, 'Pelagius_Robe', 'pelagius_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23960, "PlgsJKRbe", 56, 0, 131, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23960, 1, 18), -- DEF +18
    (23960, 2, 70), -- HP +70
    (23960, 8, 9), -- STR +9
    (23960, 10, 9), -- VIT +9
    (23960, 23, 18), -- Attack +18
    (23960, 25, 15), -- Accuracy +15
    (23960, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES (11672, 0, 'Pelagius_Ring', 'pelagius_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11672, "PlgsAlpRng", 59, 0, 6146, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11672, 8, 6), -- STR +6
    (11672, 9, 9), -- DEX +9
    (11672, 23, 18), -- Attack +18
    (11672, 25, 20), -- Accuracy +20
    (11672, 73, 8), -- Store TP +8
    (11672, 384, 300), -- Haste +3%
    (11672, 165, 4); -- Crit Rate +4
REPLACE INTO `item_basic` VALUES (732, 0, 'Gldnstrn_Claw', 'gldnstrn_claw', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23516, 0, 'Gldnstr_Bracers', 'gldnstr_bracers', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23516, "GldnstrnBrc", 16, 0, 16924, 78, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23516, 1, 3), -- DEF +3
    (23516, 5, 15), -- MP +15
    (23516, 12, 3), -- INT +3
    (23516, 13, 2), -- MND +2
    (23516, 14, 2), -- CHR +2
    (23516, 28, 3), -- MAB +3
    (23516, 30, 3), -- MACC +3
    (23516, 562, 2), -- M.Crit +2
    (23516, 563, 3), -- M.Crit Dmg. +3
    (23516, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28427, 0, 'Gldnstrn_Belt', 'gldnstrn_belt', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28427, "GldnstrnHBlt", 11, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28427, 1, 1), -- DEF +1
    (28427, 5, 15), -- MP +15
    (28427, 12, 3), -- INT +3
    (28427, 13, 2), -- MND +2
    (28427, 14, 2), -- CHR +2
    (28427, 28, 3), -- MAB +3
    (28427, 30, 3), -- MACC +3
    (28427, 562, 2), -- M.Crit +2
    (28427, 563, 3), -- M.Crit Dmg. +3
    (28427, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (735, 0, 'Petronio_Mark', 'petronio_mark', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23412, 0, 'Petronio_Helm', 'petronio_helm', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23412, "PtrnoPHlm", 35, 0, 16924, 93, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23412, 1, 8), -- DEF +8
    (23412, 5, 30), -- MP +30
    (23412, 12, 6), -- INT +6
    (23412, 13, 4), -- MND +4
    (23412, 14, 4), -- CHR +4
    (23412, 28, 6), -- MAB +6
    (23412, 30, 6), -- MACC +6
    (23412, 562, 3), -- M.Crit +3
    (23412, 563, 5), -- M.Crit Dmg. +5
    (23412, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (11671, 0, 'Petronio_Ring', 'petronio_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11671, "PtrnoDRng", 30, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11671, 5, 30), -- MP +30
    (11671, 12, 6), -- INT +6
    (11671, 13, 4), -- MND +4
    (11671, 14, 4), -- CHR +4
    (11671, 28, 6), -- MAB +6
    (11671, 30, 6), -- MACC +6
    (11671, 562, 3), -- M.Crit +3
    (11671, 563, 5), -- M.Crit Dmg. +5
    (11671, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (738, 0, 'Malaclypse_Fang', 'malaclypse_fang', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23961, 0, 'Mlclyps_Hauberk', 'mlclyps_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23961, "MlclpsSHbk", 59, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23961, 1, 18), -- DEF +18
    (23961, 5, 45), -- MP +45
    (23961, 12, 9), -- INT +9
    (23961, 13, 6), -- MND +6
    (23961, 14, 6), -- CHR +6
    (23961, 28, 9), -- MAB +9
    (23961, 30, 9), -- MACC +9
    (23961, 562, 4), -- M.Crit +4
    (23961, 563, 7), -- M.Crit Dmg. +7
    (23961, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (11668, 0, 'Malaclypse_Ring', 'malaclypse_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11668, "MlclpsPRng", 41, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11668, 5, 45), -- MP +45
    (11668, 12, 9), -- INT +9
    (11668, 13, 6), -- MND +6
    (11668, 14, 6), -- CHR +6
    (11668, 28, 9), -- MAB +9
    (11668, 30, 9), -- MACC +9
    (11668, 562, 4), -- M.Crit +4
    (11668, 563, 7), -- M.Crit Dmg. +7
    (11668, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (741, 0, 'Apllnrs_Fang', 'apllnrs_fang', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23969, 0, 'Apllnrs_Plate', 'apllnrs_plate', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23969, "ApllnrsAPlt", 55, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23969, 1, 18), -- DEF +18
    (23969, 5, 45), -- MP +45
    (23969, 12, 9), -- INT +9
    (23969, 13, 6), -- MND +6
    (23969, 14, 6), -- CHR +6
    (23969, 28, 9), -- MAB +9
    (23969, 30, 9), -- MACC +9
    (23969, 562, 4), -- M.Crit +4
    (23969, 563, 7), -- M.Crit Dmg. +7
    (23969, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (23413, 0, 'Apllnrs_Crown', 'apllnrs_crown', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23413, "ApllnrsPCrn", 52, 0, 16924, 166, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23413, 1, 12), -- DEF +12
    (23413, 5, 45), -- MP +45
    (23413, 12, 9), -- INT +9
    (23413, 13, 6), -- MND +6
    (23413, 14, 6), -- CHR +6
    (23413, 28, 9), -- MAB +9
    (23413, 30, 9), -- MACC +9
    (23413, 562, 4), -- M.Crit +4
    (23413, 563, 7), -- M.Crit Dmg. +7
    (23413, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (744, 0, 'Tibalt_Chip', 'tibalt_chip', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11667, 0, 'Tibalt_Ring', 'tibalt_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11667, "TbltShRng", 8, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11667, 5, 15), -- MP +15
    (11667, 12, 3), -- INT +3
    (11667, 13, 2), -- MND +2
    (11667, 14, 2), -- CHR +2
    (11667, 28, 3), -- MAB +3
    (11667, 30, 3), -- MACC +3
    (11667, 562, 2), -- M.Crit +2
    (11667, 563, 3), -- M.Crit Dmg. +3
    (11667, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (23703, 0, 'Tibalt_Sandals', 'tibalt_sandals', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23703, "TbltPSnd", 14, 0, 131, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23703, 1, 3), -- DEF +3
    (23703, 2, 20), -- HP +20
    (23703, 8, 3), -- STR +3
    (23703, 10, 3), -- VIT +3
    (23703, 23, 6), -- Attack +6
    (23703, 25, 5), -- Accuracy +5
    (23703, 421, 2); -- Crit Dmg. +2
REPLACE INTO `item_basic` VALUES (747, 0, 'Archibald_Shell', 'archibald_shell', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25527, 0, 'Archbld_Collar', 'archbld_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25527, "ArchbldFCl", 41, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25527, 5, 45), -- MP +45
    (25527, 12, 9), -- INT +9
    (25527, 13, 6), -- MND +6
    (25527, 14, 6), -- CHR +6
    (25527, 28, 9), -- MAB +9
    (25527, 30, 9), -- MACC +9
    (25527, 562, 4), -- M.Crit +4
    (25527, 563, 7), -- M.Crit Dmg. +7
    (25527, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (23704, 0, 'Archibald_Boots', 'archibald_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23704, "ArchbldRBts", 21, 0, 131, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23704, 1, 6), -- DEF +6
    (23704, 2, 40), -- HP +40
    (23704, 8, 6), -- STR +6
    (23704, 10, 6), -- VIT +6
    (23704, 23, 12), -- Attack +12
    (23704, 25, 10), -- Accuracy +10
    (23704, 421, 4); -- Crit Dmg. +4
REPLACE INTO `item_basic` VALUES (750, 0, 'Eleanor_Shell', 'eleanor_shell', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23970, 0, 'Elnr_Carapace', 'elnr_carapace', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23970, "ElnrACrp", 53, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23970, 1, 18), -- DEF +18
    (23970, 5, 45), -- MP +45
    (23970, 12, 9), -- INT +9
    (23970, 13, 6), -- MND +6
    (23970, 14, 6), -- CHR +6
    (23970, 28, 9), -- MAB +9
    (23970, 30, 9), -- MACC +9
    (23970, 562, 4), -- M.Crit +4
    (23970, 563, 7), -- M.Crit Dmg. +7
    (23970, 369, 2); -- Refresh +2

REPLACE INTO `item_basic` VALUES (11647, 0, 'Eleanor_Ring', 'eleanor_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11647, "ElnrStnRng", 31, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11647, 5, 30), -- MP +30
    (11647, 12, 6), -- INT +6
    (11647, 13, 4), -- MND +4
    (11647, 14, 4), -- CHR +4
    (11647, 28, 6), -- MAB +6
    (11647, 30, 6), -- MACC +6
    (11647, 562, 3), -- M.Crit +3
    (11647, 563, 5), -- M.Crit Dmg. +5
    (11647, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (753, 0, 'Alxndrs_Shell', 'alxndrs_shell', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23971, 0, 'Alxndr_Fortress', 'alxndr_fortress', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23971, "AlxndrsTF", 72, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23971, 1, 25), -- DEF +25
    (23971, 5, 60), -- MP +60
    (23971, 12, 12), -- INT +12
    (23971, 13, 8), -- MND +8
    (23971, 14, 8), -- CHR +8
    (23971, 28, 12), -- MAB +12
    (23971, 30, 12), -- MACC +12
    (23971, 562, 5), -- M.Crit +5
    (23971, 563, 10), -- M.Crit Dmg. +10
    (23971, 369, 3); -- Refresh +3

REPLACE INTO `item_basic` VALUES (11648, 0, 'Alexandros_Ring', 'alexandros_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11648, "AlxndrsBRng", 53, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11648, 5, 45), -- MP +45
    (11648, 12, 9), -- INT +9
    (11648, 13, 6), -- MND +6
    (11648, 14, 6), -- CHR +6
    (11648, 28, 9), -- MAB +9
    (11648, 30, 9), -- MACC +9
    (11648, 562, 4), -- M.Crit +4
    (11648, 563, 7), -- M.Crit Dmg. +7
    (11648, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (756, 0, 'Callirhoe_Ring', 'callirhoe_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26103, 0, 'Cllrh_Earring', 'cllrh_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26103, "CllrhoeEar", 15, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26103, 5, 15), -- MP +15
    (26103, 12, 3), -- INT +3
    (26103, 13, 2), -- MND +2
    (26103, 14, 2), -- CHR +2
    (26103, 28, 3), -- MAB +3
    (26103, 30, 3), -- MACC +3
    (26103, 562, 2), -- M.Crit +2
    (26103, 563, 3), -- M.Crit Dmg. +3
    (26103, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (28428, 0, 'Callirhoe_Sash', 'callirhoe_sash', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (28428, "CllrhoeSsh", 59, 0, 263200, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (28428, 1, 5), -- DEF +5
    (28428, 9, 9), -- DEX +9
    (28428, 11, 9), -- AGI +9
    (28428, 25, 15), -- Accuracy +15
    (28428, 26, 15), -- Rng. Acc. +15
    (28428, 23, 18), -- Attack +18
    (28428, 24, 18), -- Rng. Atk. +18
    (28428, 68, 15), -- Evasion +15
    (28428, 165, 4); -- Crit Rate +4
REPLACE INTO `item_basic` VALUES (759, 0, 'Chrysnthm_Bead', 'chrysnthm_bead', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25531, 0, 'Chrysnth_Collar', 'chrysnth_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25531, "ChrsnthmCCl", 64, 0, 263200, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25531, 9, 12), -- DEX +12
    (25531, 11, 12), -- AGI +12
    (25531, 25, 20), -- Accuracy +20
    (25531, 26, 20), -- Rng. Acc. +20
    (25531, 23, 24), -- Attack +24
    (25531, 24, 24), -- Rng. Atk. +24
    (25531, 68, 20), -- Evasion +20
    (25531, 165, 5); -- Crit Rate +5

REPLACE INTO `item_basic` VALUES (11649, 0, 'Chrysnthm_Ring', 'chrysnthm_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11649, "ChrsnthmLRng", 22, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11649, 5, 30), -- MP +30
    (11649, 12, 6), -- INT +6
    (11649, 13, 4), -- MND +4
    (11649, 14, 4), -- CHR +4
    (11649, 28, 6), -- MAB +6
    (11649, 30, 6), -- MACC +6
    (11649, 562, 3), -- M.Crit +3
    (11649, 563, 5), -- M.Crit Dmg. +5
    (11649, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (762, 0, 'Srphm_Scale', 'srphm_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23972, 0, 'Seraphimia_Robe', 'seraphimia_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23972, "SrphmSRbe", 72, 0, 10240, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23972, 1, 25), -- DEF +25
    (23972, 8, 12), -- STR +12
    (23972, 9, 12), -- DEX +12
    (23972, 23, 24), -- Attack +24
    (23972, 25, 24), -- Accuracy +24
    (23972, 73, 10), -- Store TP +10
    (23972, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (11650, 0, 'Seraphimia_Ring', 'seraphimia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11650, "SrphmTmpRng", 19, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11650, 5, 15), -- MP +15
    (11650, 12, 3), -- INT +3
    (11650, 13, 2), -- MND +2
    (11650, 14, 2), -- CHR +2
    (11650, 28, 3), -- MAB +3
    (11650, 30, 3), -- MACC +3
    (11650, 562, 2), -- M.Crit +2
    (11650, 563, 3), -- M.Crit Dmg. +3
    (11650, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (765, 0, 'Sophronia_Scale', 'sophronia_scale', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23414, 0, 'Sophronia_Tiara', 'sophronia_tiara', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23414, "SphrnaSTar", 74, 0, 10240, 168, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23414, 1, 16), -- DEF +16
    (23414, 8, 12), -- STR +12
    (23414, 9, 12), -- DEX +12
    (23414, 23, 24), -- Attack +24
    (23414, 25, 24), -- Accuracy +24
    (23414, 73, 10), -- Store TP +10
    (23414, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (11646, 0, 'Sophronia_Ring', 'sophronia_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11646, "SphrnaSOvRng", 43, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11646, 5, 45), -- MP +45
    (11646, 12, 9), -- INT +9
    (11646, 13, 6), -- MND +6
    (11646, 14, 6), -- CHR +6
    (11646, 28, 9), -- MAB +9
    (11646, 30, 9), -- MACC +9
    (11646, 562, 4), -- M.Crit +4
    (11646, 563, 7), -- M.Crit Dmg. +7
    (11646, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (768, 0, 'Brnrd_Bloodsack', 'brnrd_bloodsack', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (26104, 0, 'Barnard_Earring', 'barnard_earring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (26104, "BrndCEar", 13, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (26104, 5, 15), -- MP +15
    (26104, 12, 3), -- INT +3
    (26104, 13, 2), -- MND +2
    (26104, 14, 2), -- CHR +2
    (26104, 28, 3), -- MAB +3
    (26104, 30, 3), -- MACC +3
    (26104, 562, 2), -- M.Crit +2
    (26104, 563, 3), -- M.Crit Dmg. +3
    (26104, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (15858, 0, 'Barnard_Ring', 'barnard_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (15858, "BrndDrRng", 24, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (15858, 5, 30), -- MP +30
    (15858, 12, 6), -- INT +6
    (15858, 13, 4), -- MND +4
    (15858, 14, 4), -- CHR +4
    (15858, 28, 6), -- MAB +6
    (15858, 30, 6), -- MACC +6
    (15858, 562, 3), -- M.Crit +3
    (15858, 563, 5), -- M.Crit Dmg. +5
    (15858, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (771, 0, 'Griselda_Sac', 'griselda_sac', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25532, 0, 'Griselda_Collar', 'griselda_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25532, "GrsldaBCll", 27, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25532, 5, 30), -- MP +30
    (25532, 12, 6), -- INT +6
    (25532, 13, 4), -- MND +4
    (25532, 14, 4), -- CHR +4
    (25532, 28, 6), -- MAB +6
    (25532, 30, 6), -- MACC +6
    (25532, 562, 3), -- M.Crit +3
    (25532, 563, 5), -- M.Crit Dmg. +5
    (25532, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (23520, 0, 'Griselda_Mitts', 'griselda_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23520, "GrsldaGMtt", 10, 0, 131, 86, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23520, 1, 3), -- DEF +3
    (23520, 2, 20), -- HP +20
    (23520, 8, 3), -- STR +3
    (23520, 10, 3), -- VIT +3
    (23520, 23, 6), -- Attack +6
    (23520, 25, 5), -- Accuracy +5
    (23520, 421, 2); -- Crit Dmg. +2
REPLACE INTO `item_basic` VALUES (774, 0, 'Placida_Flask', 'placida_flask', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23973, 0, 'Placida_Hauberk', 'placida_hauberk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23973, "PlcdaMHbk", 39, 0, 16924, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23973, 1, 12), -- DEF +12
    (23973, 5, 30), -- MP +30
    (23973, 12, 6), -- INT +6
    (23973, 13, 4), -- MND +4
    (23973, 14, 4), -- CHR +4
    (23973, 28, 6), -- MAB +6
    (23973, 30, 6), -- MACC +6
    (23973, 562, 3), -- M.Crit +3
    (23973, 563, 5), -- M.Crit Dmg. +5
    (23973, 369, 1); -- Refresh +1

REPLACE INTO `item_basic` VALUES (11637, 0, 'Placida_Ring', 'placida_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11637, "PlcdaSpRng", 21, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11637, 5, 30), -- MP +30
    (11637, 12, 6), -- INT +6
    (11637, 13, 4), -- MND +4
    (11637, 14, 4), -- CHR +4
    (11637, 28, 6), -- MAB +6
    (11637, 30, 6), -- MACC +6
    (11637, 562, 3), -- M.Crit +3
    (11637, 563, 5), -- M.Crit Dmg. +5
    (11637, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (777, 0, 'Agstn_Sucker', 'agstn_sucker', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23974, 0, 'Augustine_Robe', 'augustine_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23974, "AgstnLDRbe", 55, 0, 131, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23974, 1, 18), -- DEF +18
    (23974, 2, 70), -- HP +70
    (23974, 8, 9), -- STR +9
    (23974, 10, 9), -- VIT +9
    (23974, 23, 18), -- Attack +18
    (23974, 25, 15), -- Accuracy +15
    (23974, 421, 6); -- Crit Dmg. +6

REPLACE INTO `item_basic` VALUES (11639, 0, 'Augustine_Ring', 'augustine_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11639, "AgstnVtRng", 44, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11639, 5, 45), -- MP +45
    (11639, 12, 9), -- INT +9
    (11639, 13, 6), -- MND +6
    (11639, 14, 6), -- CHR +6
    (11639, 28, 9), -- MAB +9
    (11639, 30, 9), -- MACC +9
    (11639, 562, 4), -- M.Crit +4
    (11639, 563, 7), -- M.Crit Dmg. +7
    (11639, 369, 2); -- Refresh +2
REPLACE INTO `item_basic` VALUES (780, 0, 'Lavrentiy_Silk', 'lavrentiy_silk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (11644, 0, 'Lavrentiy_Ring', 'lavrentiy_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11644, "LvrnCRng", 32, 0, 10240, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11644, 8, 6), -- STR +6
    (11644, 9, 6), -- DEX +6
    (11644, 23, 12), -- Attack +12
    (11644, 25, 12), -- Accuracy +12
    (11644, 73, 5), -- Store TP +5
    (11644, 384, 200); -- Haste +2%

REPLACE INTO `item_basic` VALUES (23705, 0, 'Lavrentiy_Boots', 'lavrentiy_boots', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23705, "LvrnWBts", 6, 0, 263200, 339, 0, 0, 256, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23705, 1, 3), -- DEF +3
    (23705, 9, 3), -- DEX +3
    (23705, 11, 3), -- AGI +3
    (23705, 25, 5), -- Accuracy +5
    (23705, 26, 5), -- Rng. Acc. +5
    (23705, 23, 6), -- Attack +6
    (23705, 24, 6), -- Rng. Atk. +6
    (23705, 68, 5), -- Evasion +5
    (23705, 165, 2); -- Crit Rate +2
REPLACE INTO `item_basic` VALUES (783, 0, 'Sebestyen_Silk', 'sebestyen_silk', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (25533, 0, 'Sbstyn_Collar', 'sbstyn_collar', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (25533, "SbstynWCll", 56, 0, 10240, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (25533, 8, 9), -- STR +9
    (25533, 9, 9), -- DEX +9
    (25533, 23, 18), -- Attack +18
    (25533, 25, 18), -- Accuracy +18
    (25533, 73, 7), -- Store TP +7
    (25533, 384, 300); -- Haste +3%

REPLACE INTO `item_basic` VALUES (23528, 0, 'Sebestyen_Mitts', 'sebestyen_mitts', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23528, "SbstynSMtt", 12, 0, 16924, 211, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23528, 1, 3), -- DEF +3
    (23528, 5, 15), -- MP +15
    (23528, 12, 3), -- INT +3
    (23528, 13, 2), -- MND +2
    (23528, 14, 2), -- CHR +2
    (23528, 28, 3), -- MAB +3
    (23528, 30, 3), -- MACC +3
    (23528, 562, 2), -- M.Crit +2
    (23528, 563, 3), -- M.Crit Dmg. +3
    (23528, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (786, 0, 'Melchior_Core', 'melchior_core', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23975, 0, 'Melchior_Robe', 'melchior_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23975, "MlchrTRbe", 67, 0, 10240, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23975, 1, 25), -- DEF +25
    (23975, 8, 12), -- STR +12
    (23975, 9, 12), -- DEX +12
    (23975, 23, 24), -- Attack +24
    (23975, 25, 24), -- Accuracy +24
    (23975, 73, 10), -- Store TP +10
    (23975, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (11645, 0, 'Melchior_Ring', 'melchior_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11645, "MlchrERng", 24, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11645, 5, 30), -- MP +30
    (11645, 12, 6), -- INT +6
    (11645, 13, 4), -- MND +4
    (11645, 14, 4), -- CHR +4
    (11645, 28, 6), -- MAB +6
    (11645, 30, 6), -- MACC +6
    (11645, 562, 3), -- M.Crit +3
    (11645, 563, 5), -- M.Crit Dmg. +5
    (11645, 369, 1); -- Refresh +1
REPLACE INTO `item_basic` VALUES (789, 0, 'Mlpmn_Chrysalis', 'mlpmn_chrysalis', 1, 59476, 0, 1, 0);
REPLACE INTO `item_basic` VALUES (23976, 0, 'Melpomene_Robe', 'melpomene_robe', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (23976, "MlpmARbe", 62, 0, 10240, 480, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (23976, 1, 25), -- DEF +25
    (23976, 8, 12), -- STR +12
    (23976, 9, 12), -- DEX +12
    (23976, 23, 24), -- Attack +24
    (23976, 25, 24), -- Accuracy +24
    (23976, 73, 10), -- Store TP +10
    (23976, 384, 400); -- Haste +4%

REPLACE INTO `item_basic` VALUES (11664, 0, 'Melpomene_Ring', 'melpomene_ring', 1, 59476, 0, 1, 0);
REPLACE INTO `item_equipment` VALUES (11664, "MlpmCRng", 49, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (11664, 5, 45), -- MP +45
    (11664, 12, 9), -- INT +9
    (11664, 13, 6), -- MND +6
    (11664, 14, 6), -- CHR +6
    (11664, 28, 9), -- MAB +9
    (11664, 30, 9), -- MACC +9
    (11664, 562, 4), -- M.Crit +4
    (11664, 563, 7), -- M.Crit Dmg. +7
    (11664, 369, 2); -- Refresh +2
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
REPLACE INTO `item_equipment` VALUES (228, "crawl_silk_mnt", 53, 0, 263200, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (228, 1, 6), -- DEF +6
    (228, 9, 9), -- DEX +9
    (228, 11, 9), -- AGI +9
    (228, 25, 15), -- Accuracy +15
    (228, 26, 15), -- Rng. Acc. +15
    (228, 23, 18), -- Attack +18
    (228, 24, 18), -- Rng. Atk. +18
    (228, 68, 15), -- Evasion +15
    (228, 165, 4); -- Crit Rate +4
-- 229: Bat Sonar Earring  (EAR, lv5)  — Frenzied Bat
-- A crystallized membrane granting uncanny spatial awareness.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (229, 0, 'bat_earring', 'bat_earring', 1, 59476, 0, 0, 28197);
REPLACE INTO `item_equipment` VALUES (229, "bat_sonar_erng", 38, 0, 16924, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (229, 5, 30), -- MP +30
    (229, 12, 6), -- INT +6
    (229, 13, 4), -- MND +4
    (229, 14, 4), -- CHR +4
    (229, 28, 6), -- MAB +6
    (229, 30, 6), -- MACC +6
    (229, 562, 3), -- M.Crit +3
    (229, 563, 5), -- M.Crit Dmg. +5
    (229, 369, 1); -- Refresh +1
-- 230: Bomb Core Fragment  (RING, lv10)  — Enraged Bomb
-- A shard of a bomb's explosive core. Still warm. Wearing it is inadvisable.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (230, 0, 'bomb_fragment', 'bomb_fragment', 1, 59476, 0, 0, 1200);
REPLACE INTO `item_equipment` VALUES (230, "bomb_core_frag", 47, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (230, 5, 45), -- MP +45
    (230, 12, 9), -- INT +9
    (230, 13, 6), -- MND +6
    (230, 14, 6), -- CHR +6
    (230, 28, 9), -- MAB +9
    (230, 30, 9), -- MACC +9
    (230, 562, 4), -- M.Crit +4
    (230, 563, 7), -- M.Crit Dmg. +7
    (230, 369, 2); -- Refresh +2
-- 231: Rogue Scout's Beret  (HEAD, lv12)  — Rogue Quadav
-- Standard-issue headgear of a Quadav infiltrator. Smells of brine and regret.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (231, 0, 'rogue_beret', 'rogue_beret', 1, 59476, 0, 0, 2000);
REPLACE INTO `item_equipment` VALUES (231, "rogue_sct_brt", 51, 0, 10240, 388, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (231, 1, 12), -- DEF +12
    (231, 8, 9), -- STR +9
    (231, 9, 9), -- DEX +9
    (231, 23, 18), -- Attack +18
    (231, 25, 18), -- Accuracy +18
    (231, 73, 7), -- Store TP +7
    (231, 384, 300); -- Haste +3%
-- 232: Tiger's Bloodmane Cloak  (BACK, lv25)  — Frenzied Tiger
-- The vivid mane of a tiger driven mad by ley-line energy. Still radiates heat.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (232, 0, 'tigers_cloak', 'tigers_cloak', 1, 59476, 0, 0, 5000);
REPLACE INTO `item_equipment` VALUES (232, "tigr_blood_mnt", 61, 0, 131, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (232, 1, 8), -- DEF +8
    (232, 2, 100), -- HP +100
    (232, 8, 12), -- STR +12
    (232, 10, 12), -- VIT +12
    (232, 23, 24), -- Attack +24
    (232, 25, 20), -- Accuracy +20
    (232, 421, 8); -- Crit Dmg. +8
-- 233: Shade Wraith Tabard  (BODY, lv30)  — Wandering Shade
-- Woven from ectoplasmic essence. Cold to the touch; warm to the soul. Probably.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (233, 0, 'shade_tabard', 'shade_tabard', 1, 59476, 0, 0, 8000);
REPLACE INTO `item_equipment` VALUES (233, "shade_wrth_tab", 74, 0, 16924, 5, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (233, 1, 25), -- DEF +25
    (233, 5, 60), -- MP +60
    (233, 12, 12), -- INT +12
    (233, 13, 8), -- MND +8
    (233, 14, 8), -- CHR +8
    (233, 28, 12), -- MAB +12
    (233, 30, 12), -- MACC +12
    (233, 562, 5), -- M.Crit +5
    (233, 563, 10), -- M.Crit Dmg. +10
    (233, 369, 3); -- Refresh +3
-- 234: Goblin's Overstuffed Satchel  (WAIST, lv20)  — Treasure Goblin
-- Contains everything. No one knows how it holds so much.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (234, 0, 'goblins_satchel', 'goblins_satchel', 1, 59476, 0, 0, 3000);
REPLACE INTO `item_equipment` VALUES (234, "gob_ovst_sach", 63, 0, 16924, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (234, 1, 7), -- DEF +7
    (234, 5, 60), -- MP +60
    (234, 12, 12), -- INT +12
    (234, 13, 8), -- MND +8
    (234, 14, 8), -- CHR +8
    (234, 28, 12), -- MAB +12
    (234, 30, 12), -- MACC +12
    (234, 562, 5), -- M.Crit +5
    (234, 563, 10), -- M.Crit Dmg. +10
    (234, 369, 3); -- Refresh +3
-- 235: Goblin's Jackpot Bell  (EAR, lv40)  — Treasure Goblin (rare variant)
-- The bell the goblin rings when it strikes it rich. Now it rings for you.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (235, 0, 'goblins_bell', 'goblins_bell', 1, 59476, 0, 0, 6000);
REPLACE INTO `item_equipment` VALUES (235, "gob_jkpt_bell", 74, 0, 10240, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (235, 8, 12), -- STR +12
    (235, 9, 12), -- DEX +12
    (235, 23, 24), -- Attack +24
    (235, 25, 24), -- Accuracy +24
    (235, 73, 10), -- Store TP +10
    (235, 384, 400); -- Haste +4%
-- 236: Goobbue Rootbelt  (WAIST, lv35)  — Rampaging Goobbue
-- Twisted from the living roots off a Goobbue's shoulders. Still trying to grow.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (236, 0, 'gbb_rootbelt', 'gbb_rootbelt', 1, 59476, 0, 0, 7000);
REPLACE INTO `item_equipment` VALUES (236, "goob_rootbelt", 69, 0, 131, 0, 0, 0, 1024, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (236, 1, 7), -- DEF +7
    (236, 2, 100), -- HP +100
    (236, 8, 12), -- STR +12
    (236, 10, 12), -- VIT +12
    (236, 23, 24), -- Attack +24
    (236, 25, 20), -- Accuracy +20
    (236, 421, 8); -- Crit Dmg. +8
-- 237: Dread Hunter's Choker  (NECK, lv50)  — Dread Hunter (Coeurl)
-- Crystallized mane-fur from a coeurl that fed on too many crystals.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (237, 0, 'dread_choker', 'dread_choker', 1, 59476, 0, 0, 12000);
REPLACE INTO `item_equipment` VALUES (237, "drd_hnt_chokr", 64, 0, 10240, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (237, 8, 12), -- STR +12
    (237, 9, 12), -- DEX +12
    (237, 23, 24), -- Attack +24
    (237, 25, 24), -- Accuracy +24
    (237, 73, 10), -- Store TP +10
    (237, 384, 400); -- Haste +4%
-- 238: Fell Commander's Vambrace  (HANDS, lv55)  — Fell Commander
-- Bronze vambrace of a Quadav war-leader. The engravings still pulse.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (238, 0, 'fell_vambrace', 'fell_vambrace', 1, 59476, 0, 0, 15000);
REPLACE INTO `item_equipment` VALUES (238, "fell_cmd_vamb", 65, 0, 6146, 56, 0, 0, 64, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (238, 1, 12), -- DEF +12
    (238, 8, 8), -- STR +8
    (238, 9, 12), -- DEX +12
    (238, 23, 24), -- Attack +24
    (238, 25, 26), -- Accuracy +26
    (238, 73, 12), -- Store TP +12
    (238, 384, 400), -- Haste +4%
    (238, 165, 5); -- Crit Rate +5
-- 239: Nexus Core Helm  (HEAD, lv50)  — Storm Nexus
-- Elemental forces solidified into a helmet. The wearer sees reality differently.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (239, 0, 'nexus_core_helm', 'nexus_core_helm', 1, 59476, 0, 0, 13000);
REPLACE INTO `item_equipment` VALUES (239, "nexus_core_hlm", 67, 0, 16924, 388, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (239, 1, 16), -- DEF +16
    (239, 5, 60), -- MP +60
    (239, 12, 12), -- INT +12
    (239, 13, 8), -- MND +8
    (239, 14, 8), -- CHR +8
    (239, 28, 12), -- MAB +12
    (239, 30, 12), -- MACC +12
    (239, 562, 5), -- M.Crit +5
    (239, 563, 10), -- M.Crit Dmg. +10
    (239, 369, 3); -- Refresh +3
-- 240: Crystal Golem's Heart  (EAR, lv55)  — Crystal Golem
-- The gemstone core that animated the golem. Still pulses like a heartbeat.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (240, 0, 'crystal_heart', 'crystal_heart', 1, 59476, 0, 0, 11000);
REPLACE INTO `item_equipment` VALUES (240, "cryst_golm_hrt", 73, 0, 131, 0, 0, 0, 6144, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (240, 2, 100), -- HP +100
    (240, 8, 12), -- STR +12
    (240, 10, 12), -- VIT +12
    (240, 23, 24), -- Attack +24
    (240, 25, 20), -- Accuracy +20
    (240, 421, 8); -- Crit Dmg. +8
-- 241: Void Wyrm's Fang  (NECK, lv75)  — Void Wyrm
-- A tooth from the void dragon, still leaking destructive essence.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (241, 0, 'void_wyrms_fang', 'void_wyrms_fang', 1, 59476, 0, 0, 40000);
REPLACE INTO `item_equipment` VALUES (241, "void_wyrm_fang", 68, 0, 16924, 0, 0, 0, 512, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (241, 5, 60), -- MP +60
    (241, 12, 12), -- INT +12
    (241, 13, 8), -- MND +8
    (241, 14, 8), -- CHR +8
    (241, 28, 12), -- MAB +12
    (241, 30, 12), -- MACC +12
    (241, 562, 5), -- M.Crit +5
    (241, 563, 10), -- M.Crit Dmg. +10
    (241, 369, 3); -- Refresh +3
-- 242: Abyssal Tyrant's Diadem  (HEAD, lv75)  — Abyssal Tyrant
-- The horned crown of a demon lord. It fits. This is alarming.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (242, 0, 'abyssal_diadem', 'abyssal_diadem', 1, 59476, 0, 0, 50000);
REPLACE INTO `item_equipment` VALUES (242, "abys_typ_diad", 68, 0, 16924, 388, 0, 0, 16, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (242, 1, 16), -- DEF +16
    (242, 5, 60), -- MP +60
    (242, 12, 12), -- INT +12
    (242, 13, 8), -- MND +8
    (242, 14, 8), -- CHR +8
    (242, 28, 12), -- MAB +12
    (242, 30, 12), -- MACC +12
    (242, 562, 5), -- M.Crit +5
    (242, 563, 10), -- M.Crit Dmg. +10
    (242, 369, 3); -- Refresh +3
-- 243: Ancient King's Carapace  (BODY, lv75)  — Ancient King
-- Armor shaped from the shell of the Ancient King. A village sheltered here once.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (243, 0, 'kings_carapace', 'kings_carapace', 1, 59476, 0, 0, 60000);
REPLACE INTO `item_equipment` VALUES (243, "anc_kng_carap", 66, 0, 131, 5, 0, 0, 32, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (243, 1, 25), -- DEF +25
    (243, 2, 100), -- HP +100
    (243, 8, 12), -- STR +12
    (243, 10, 12), -- VIT +12
    (243, 23, 24), -- Attack +24
    (243, 25, 20), -- Accuracy +20
    (243, 421, 8); -- Crit Dmg. +8
-- 244: Apex Soulstone  (RING, lv60)  — Apex-tier (generic)
-- A gemstone formed from crystallized dynamic energy.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (244, 0, 'apex_soulstone', 'apex_soulstone', 1, 59476, 0, 0, 20000);
REPLACE INTO `item_equipment` VALUES (244, "apex_soulstone", 68, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (244, 5, 60), -- MP +60
    (244, 12, 12), -- INT +12
    (244, 13, 8), -- MND +8
    (244, 14, 8), -- CHR +8
    (244, 28, 12), -- MAB +12
    (244, 30, 12), -- MACC +12
    (244, 562, 5), -- M.Crit +5
    (244, 563, 10), -- M.Crit Dmg. +10
    (244, 369, 3); -- Refresh +3
-- 245: Wanderer's Legacy  (RING, lv75)  — Apex-tier (prestige)
-- A ring worn by adventurers who have hunted the Dynamic World thoroughly.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (245, 0, 'wndrrs_legacy', 'wndrrs_legacy', 1, 59476, 0, 0, 75000);
REPLACE INTO `item_equipment` VALUES (245, "wandrers_lgcy", 61, 0, 16924, 0, 0, 0, 24576, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (245, 5, 60), -- MP +60
    (245, 12, 12), -- INT +12
    (245, 13, 8), -- MND +8
    (245, 14, 8), -- CHR +8
    (245, 28, 12), -- MAB +12
    (245, 30, 12), -- MACC +12
    (245, 562, 5), -- M.Crit +5
    (245, 563, 10), -- M.Crit Dmg. +10
    (245, 369, 3); -- Refresh +3
-- 249: Void Wyrm Scale  (BACK, lv75)  — Void Wyrm (alternate drop)
-- A scale the size of a shield. Absorbs blows and helps you hit harder.
-- ---------------------------------------------------------------------------
REPLACE INTO `item_basic` VALUES (249, 0, 'void_wyrm_scale', 'void_wyrm_scale', 1, 59476, 0, 0, 45000);
REPLACE INTO `item_equipment` VALUES (249, "void_wyrm_scl", 70, 0, 131, 0, 0, 0, 32768, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (249, 1, 8), -- DEF +8
    (249, 2, 100), -- HP +100
    (249, 8, 12), -- STR +12
    (249, 10, 12), -- VIT +12
    (249, 23, 24), -- Attack +24
    (249, 25, 20), -- Accuracy +20
    (249, 421, 8); -- Crit Dmg. +8

-- =============================================================================
-- SECTION 4: CUSTOM WEAPON CHASE DROPS
-- =============================================================================
-- Generated from the current working weapons.yml. Do not regenerate weapons.yml.

-- Restore retired experimental weapon rows to upstream/base SQL values.
DELETE FROM `item_mods` WHERE `itemId` IN (18831, 18832, 18840, 18844, 18847, 18852, 18853, 18869, 18883, 18884, 18886, 18933, 18937, 18971, 18972, 18973, 18974, 18975, 18976, 18977, 18978, 18979, 18980, 18981, 18982, 18983, 18984, 18985, 18986, 18987, 18988, 18990, 18991, 18994, 18995, 18996, 18997, 18999, 19005, 19088, 19101, 19105, 19221, 19224, 19226, 19230, 20713);
DELETE FROM `item_mods_pet` WHERE `itemId` IN (18831, 18832, 18840, 18844, 18847, 18852, 18853, 18869, 18883, 18884, 18886, 18933, 18937, 18971, 18972, 18973, 18974, 18975, 18976, 18977, 18978, 18979, 18980, 18981, 18982, 18983, 18984, 18985, 18986, 18987, 18988, 18990, 18991, 18994, 18995, 18996, 18997, 18999, 19005, 19088, 19101, 19105, 19221, 19224, 19226, 19230, 20713);
REPLACE INTO `item_basic` VALUES (18831,0,'crooners_cithara','crooners_cithara',1,63572,0,1,0);
REPLACE INTO `item_equipment` VALUES (18831,'crooners_cithara',85,0,512,81,0,0,4,0,0,0);
REPLACE INTO `item_weapon` VALUES (18831,'crooners_cithara',41,0,0,0,0,0,1,240,0,0);
REPLACE INTO `item_mods` VALUES
    (18831, 442, 1);

REPLACE INTO `item_basic` VALUES (18832,0,'apollos_flute','apollos_flute',1,63572,0,1,0);
REPLACE INTO `item_equipment` VALUES (18832,'apollos_flute',83,0,512,64,0,0,4,0,0,0);
REPLACE INTO `item_weapon` VALUES (18832,'apollos_flute',42,0,0,0,0,1,1,240,0,0);
REPLACE INTO `item_mods` VALUES
    (18832, 434, 3);

REPLACE INTO `item_basic` VALUES (18840,0,'gjallarhorn_99_ii','gjallarhorn',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18840,'gjallarhorn',99,0,512,105,0,0,4,0,0,0);
REPLACE INTO `item_weapon` VALUES (18840,'gjallarhorn',42,0,0,0,0,0,1,240,0,0);
REPLACE INTO `item_mods` VALUES
    (18840, 14, 10),
    (18840, 119, 25),
    (18840, 121, 25),
    (18840, 452, 4);

REPLACE INTO `item_basic` VALUES (18844,0,'miracle_wand','miracle_wand',1,64624,0,1,0);
REPLACE INTO `item_equipment` VALUES (18844,'miracle_wand',1,0,4194303,373,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18844,'miracle_wand',11,0,0,0,0,3,1,264,2,0);

REPLACE INTO `item_basic` VALUES (18847,0,'seveneyes','seveneyes',1,63572,0,1,0);
REPLACE INTO `item_equipment` VALUES (18847,'seveneyes',71,0,1622044,359,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18847,'seveneyes',11,0,0,0,0,3,1,217,27,0);
REPLACE INTO `item_mods` VALUES
    (18847, 2, 27),
    (18847, 5, 27),
    (18847, 19, 7),
    (18847, 20, 7),
    (18847, 21, 7),
    (18847, 115, 7),
    (18847, 296, 7);

REPLACE INTO `item_basic` VALUES (18852,0,'octave_club','octave_club',1,63568,0,1,0);
REPLACE INTO `item_equipment` VALUES (18852,'octave_club',63,0,32767,110,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18852,'octave_club',11,0,0,0,0,3,1,264,11,0);

REPLACE INTO `item_basic` VALUES (18853,0,'spirit_maul','spirit_maul',1,3108,11,0,1718);
REPLACE INTO `item_equipment` VALUES (18853,'spirit_maul',38,0,1048580,116,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18853,'spirit_maul',11,0,0,0,0,3,1,324,26,0);
REPLACE INTO `item_mods` VALUES
    (18853, 13, 2),
    (18853, 22, 3),
    (18853, 431, 1),
    (18853, 499, 7),
    (18853, 500, 21),
    (18853, 501, 5),
    (18853, 950, 7);

REPLACE INTO `item_basic` VALUES (18869,0,'lady_bell_+1','lady_bell_+1',1,2080,11,0,56);
REPLACE INTO `item_equipment` VALUES (18869,'lady_bell_+1',1,0,4194303,456,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18869,'lady_bell_+1',11,0,0,0,0,3,1,210,2,0);

REPLACE INTO `item_basic` VALUES (18883,0,'luckitoo','luckitoo',1,34820,11,0,0);
REPLACE INTO `item_equipment` VALUES (18883,'luckitoo',97,0,68,360,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18883,'luckitoo',11,0,0,0,0,3,1,340,75,0);
REPLACE INTO `item_mods` VALUES
    (18883, 8, 6),
    (18883, 13, -10),
    (18883, 384, 300);

REPLACE INTO `item_basic` VALUES (18884,0,'vejovis_wand','vejovis_wand',1,2084,11,0,0);
REPLACE INTO `item_equipment` VALUES (18884,'vejovis_wand',97,0,1622044,225,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18884,'vejovis_wand',11,0,0,0,0,3,1,216,55,0);
REPLACE INTO `item_mods` VALUES
    (18884, 519, 3);

REPLACE INTO `item_basic` VALUES (18886,0,'dhyana_rod','dhyana_rod',1,63572,0,1,0);
REPLACE INTO `item_equipment` VALUES (18886,'dhyana_rod',99,0,1589260,595,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18886,'dhyana_rod',11,0,0,0,0,3,1,288,65,0);
REPLACE INTO `item_mods` VALUES
    (18886, 13, 10);

REPLACE INTO `item_basic` VALUES (18933,0,'harrier','harrier',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18933,'harrier',80,0,1024,35,0,0,4,0,0,0);
REPLACE INTO `item_weapon` VALUES (18933,'harrier',25,0,0,0,0,1,1,524,84,0);

REPLACE INTO `item_basic` VALUES (18937,0,'bedlam','bedlam',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18937,'bedlam',80,0,66560,57,0,0,4,0,0,0);
REPLACE INTO `item_weapon` VALUES (18937,'bedlam',26,1,0,0,0,1,1,600,51,0);

REPLACE INTO `item_basic` VALUES (18971,0,'conqueror_base','conqueror',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18971,'conqueror',75,0,1,414,0,0,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (18971,'conqueror',6,0,0,0,0,2,1,504,93,0);

REPLACE INTO `item_basic` VALUES (18972,0,'glanzfaust_base','glanzfaust',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18972,'glanzfaust',75,0,2,502,0,0,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (18972,'glanzfaust',1,0,0,0,0,4,1,576,20,0);

REPLACE INTO `item_basic` VALUES (18973,0,'yagrush_base','yagrush',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18973,'yagrush',75,0,4,415,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18973,'yagrush',11,0,0,0,0,3,1,267,43,0);

REPLACE INTO `item_basic` VALUES (18974,0,'laevateinn_base','laevateinn',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18974,'laevateinn',75,0,8,416,0,0,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (18974,'laevateinn',12,0,0,0,0,3,1,402,62,0);

REPLACE INTO `item_basic` VALUES (18975,0,'murgleis_base','murgleis',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18975,'murgleis',75,0,16,420,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18975,'murgleis',3,0,0,0,0,2,1,224,40,0);

REPLACE INTO `item_basic` VALUES (18976,0,'vajra_base','vajra',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18976,'vajra',75,0,32,422,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18976,'vajra',2,0,0,0,0,1,1,200,31,0);

REPLACE INTO `item_basic` VALUES (18977,0,'burtgang_base','burtgang',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18977,'burtgang',75,0,64,426,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18977,'burtgang',3,0,0,0,0,2,1,264,46,0);

REPLACE INTO `item_basic` VALUES (18978,0,'liberator_base','liberator',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18978,'liberator',75,0,128,425,0,0,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (18978,'liberator',7,0,0,0,0,2,1,528,93,0);

REPLACE INTO `item_basic` VALUES (18979,0,'aymur_base','aymur',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18979,'aymur',75,0,256,413,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18979,'aymur',5,0,0,0,0,2,1,312,50,0);

REPLACE INTO `item_basic` VALUES (18980,0,'carnwenhan_base','carnwenhan',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18980,'carnwenhan',75,0,512,427,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18980,'carnwenhan',2,0,0,0,0,1,1,186,29,0);

REPLACE INTO `item_basic` VALUES (18981,0,'gastraphetes_base','gastraphetes',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18981,'gastraphetes',75,0,1024,96,0,0,4,0,0,0);
REPLACE INTO `item_weapon` VALUES (18981,'gastraphetes',26,0,0,0,0,1,1,288,39,0);

REPLACE INTO `item_basic` VALUES (18982,0,'kogarasumaru_base','kogarasumaru',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18982,'kogarasumaru',75,0,2048,424,0,0,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (18982,'kogarasumaru',10,0,0,0,0,2,1,450,81,0);

REPLACE INTO `item_basic` VALUES (18983,0,'nagi_base','nagi',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18983,'nagi',75,0,4096,421,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18983,'nagi',9,0,0,0,0,2,1,227,37,0);

REPLACE INTO `item_basic` VALUES (18984,0,'ryunohige_base','ryunohige',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18984,'ryunohige',75,0,8192,423,0,0,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (18984,'ryunohige',8,0,0,0,0,1,1,492,91,0);

REPLACE INTO `item_basic` VALUES (18985,0,'nirvana_base','nirvana',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18985,'nirvana',75,0,16384,417,0,0,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (18985,'nirvana',12,0,0,0,0,3,1,402,62,0);

REPLACE INTO `item_basic` VALUES (18986,0,'tizona_base','tizona',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18986,'tizona',75,0,32768,419,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18986,'tizona',3,0,0,0,0,2,1,236,42,0);

REPLACE INTO `item_basic` VALUES (18987,0,'death_penalty_base','death_penalty',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18987,'death_penalty',75,0,65536,95,0,0,4,0,0,0);
REPLACE INTO `item_weapon` VALUES (18987,'death_penalty',26,1,0,0,0,1,1,480,40,0);

REPLACE INTO `item_basic` VALUES (18988,0,'kenkonken_base','kenkonken',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18988,'kenkonken',75,0,131072,503,0,0,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (18988,'kenkonken',1,0,0,0,0,4,1,529,17,0);

REPLACE INTO `item_basic` VALUES (18990,0,'tupsimati_75','tupsimati',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18990,'tupsimati',75,0,524288,429,0,1,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (18990,'tupsimati',12,0,0,0,0,3,1,402,62,0);
REPLACE INTO `item_mods` VALUES
    (18990, 25, 30),
    (18990, 28, 20),
    (18990, 30, 10),
    (18990, 256, 31),
    (18990, 355, 188);

REPLACE INTO `item_basic` VALUES (18991,0,'conqueror_75','conqueror',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18991,'conqueror',75,0,1,414,0,1,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (18991,'conqueror',6,0,0,0,0,2,1,504,93,0);
REPLACE INTO `item_mods` VALUES
    (18991, 256, 29),
    (18991, 355, 90),
    (18991, 948, 5);

REPLACE INTO `item_basic` VALUES (18994,0,'laevateinn_75','laevateinn',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18994,'laevateinn',75,0,8,416,0,1,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (18994,'laevateinn',12,0,0,0,0,3,1,402,62,0);
REPLACE INTO `item_mods` VALUES
    (18994, 25, 30),
    (18994, 28, 20),
    (18994, 30, 10),
    (18994, 256, 31),
    (18994, 355, 186),
    (18994, 1149, 10);

REPLACE INTO `item_basic` VALUES (18995,0,'murgleis_75','murgleis',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18995,'murgleis',75,0,16,420,0,1,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18995,'murgleis',3,0,0,0,0,2,1,224,40,0);
REPLACE INTO `item_mods` VALUES
    (18995, 30, 10),
    (18995, 256, 31),
    (18995, 355, 44),
    (18995, 525, 50);

REPLACE INTO `item_basic` VALUES (18996,0,'vajra_75','vajra',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18996,'vajra',75,0,32,422,0,1,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18996,'vajra',2,0,0,0,0,1,1,200,31,0);
REPLACE INTO `item_mods` VALUES
    (18996, 256, 29),
    (18996, 355, 27),
    (18996, 526, 10),
    (18996, 527, 10);

REPLACE INTO `item_basic` VALUES (18997,0,'burtgang_75','burtgang',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18997,'burtgang',75,0,64,426,0,1,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18997,'burtgang',3,0,0,0,0,2,1,264,46,0);
REPLACE INTO `item_mods` VALUES
    (18997, 27, 10),
    (18997, 190, -1000),
    (18997, 256, 29),
    (18997, 355, 45),
    (18997, 427, 11);

REPLACE INTO `item_basic` VALUES (18999,0,'aymur_75','aymur',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (18999,'aymur',75,0,256,413,0,1,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (18999,'aymur',5,0,0,0,0,2,1,312,50,0);
REPLACE INTO `item_mods` VALUES
    (18999, 256, 29),
    (18999, 355, 74);
REPLACE INTO `item_mods_pet` VALUES
    (18999, 23, 40, 0);

REPLACE INTO `item_basic` VALUES (19005,0,'nirvana_75','nirvana',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (19005,'nirvana',75,0,16384,417,0,1,1,0,0,0);
REPLACE INTO `item_weapon` VALUES (19005,'nirvana',12,0,0,0,0,3,1,402,62,0);
REPLACE INTO `item_mods` VALUES
    (19005, 25, 30),
    (19005, 256, 29),
    (19005, 346, 4),
    (19005, 355, 187);
REPLACE INTO `item_mods_pet` VALUES
    (19005, 28, 20, 1);

REPLACE INTO `item_basic` VALUES (19088,0,'aymur_85','aymur',1,63552,0,1,0);
REPLACE INTO `item_equipment` VALUES (19088,'aymur',85,0,256,413,0,1,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (19088,'aymur',5,0,0,0,0,2,1,312,69,0);
REPLACE INTO `item_mods` VALUES
    (19088, 256, 34),
    (19088, 355, 74);
REPLACE INTO `item_mods_pet` VALUES
    (19088, 23, 60, 0);

REPLACE INTO `item_basic` VALUES (19101,0,'trainee_knife','trainee_knife',1,63568,0,1,0);
REPLACE INTO `item_equipment` VALUES (19101,'trainee_knife',1,0,4194303,317,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (19101,'trainee_knife',2,0,0,0,0,1,1,200,1,0);

REPLACE INTO `item_basic` VALUES (19105,0,'thugs_jambiya','thugs_jambiya',1,2084,2,0,3168);
REPLACE INTO `item_equipment` VALUES (19105,'thugs_jambiya',30,0,474849,379,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (19105,'thugs_jambiya',2,0,0,0,0,1,1,201,13,0);
REPLACE INTO `item_mods` VALUES
    (19105, 9, 1);

REPLACE INTO `item_basic` VALUES (19221,0,'firefly','firefly',1,63572,0,1,0);
REPLACE INTO `item_equipment` VALUES (19221,'firefly',5,0,70688,59,0,0,4,0,0,0);
REPLACE INTO `item_weapon` VALUES (19221,'firefly',26,1,0,0,0,1,1,600,11,0);
REPLACE INTO `item_mods` VALUES
    (19221, 11, 1);

REPLACE INTO `item_basic` VALUES (19224,0,'musketoon','musketoon',1,2084,13,0,100);
REPLACE INTO `item_equipment` VALUES (19224,'musketoon',6,0,70688,59,0,0,4,0,0,0);
REPLACE INTO `item_weapon` VALUES (19224,'musketoon',26,1,0,0,0,1,1,600,9,0);

REPLACE INTO `item_basic` VALUES (19226,0,'blunderbuss','blunderbuss',1,2084,13,0,3606);
REPLACE INTO `item_equipment` VALUES (19226,'blunderbuss',61,0,70688,58,0,0,4,0,0,0);
REPLACE INTO `item_weapon` VALUES (19226,'blunderbuss',26,1,0,0,0,1,1,600,37,0);
REPLACE INTO `item_mods` VALUES
    (19226, 11, 2);

REPLACE INTO `item_basic` VALUES (19230,0,'nous_arbalest','nous_arbalest',1,34820,13,0,0);
REPLACE INTO `item_equipment` VALUES (19230,'nous_arbalest',31,0,1185,56,0,0,4,0,0,0);
REPLACE INTO `item_weapon` VALUES (19230,'nous_arbalest',26,0,0,0,0,1,1,288,20,0);
REPLACE INTO `item_mods` VALUES
    (19230, 13, 4);

REPLACE INTO `item_basic` VALUES (20713,0,'excalipoor','excalipoor',1,30784,0,1,0);
REPLACE INTO `item_equipment` VALUES (20713,'excalipoor',1,0,4194303,729,0,0,3,0,0,0);
REPLACE INTO `item_weapon` VALUES (20713,'excalipoor',3,0,0,0,0,2,1,240,1,0);

-- Current custom weapons from weapons.yml.
DELETE FROM `item_mods` WHERE `itemId` IN (16428, 16498, 16582, 16654, 17110, 17131, 17273, 17801, 17961, 18313, 18511, 18828, 18938, 18939, 19073, 19408, 19422, 20571, 21554, 21572, 22124);
DELETE FROM `item_mods_pet` WHERE `itemId` IN (16428, 16498, 16582, 16654, 17110, 17131, 17273, 17801, 17961, 18313, 18511, 18828, 18938, 18939, 19073, 19408, 19422, 20571, 21554, 21572, 22124);

-- Death Dealer (Lv1)
REPLACE INTO `item_basic` VALUES (22124, 0, 'Death_Dealer', 'death_dealer', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (22124, "death_dealer", 1, 0, 4194303, 138, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (22124, "death_dealer", 25, 0, 0, 0, 0, 1, 1, 360, 1, 0);
REPLACE INTO `item_mods` VALUES
    (22124, 11, 35),
    (22124, 24, 150),
    (22124, 26, 150),
    (22124, 365, 40),
    (22124, 359, 50),
    (22124, 376, 220),
    (22124, 479, 50),
    (22124, 840, 50),
    (22124, 949, 35);

-- Flick Knife (Lv5)
REPLACE INTO `item_basic` VALUES (18828, 0, 'Flick_Knife', 'flick_knife', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18828, "flick_knife", 5, 0, 262176, 597, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18828, "flick_knife", 2, 0, 0, 0, 0, 1, 1, 150, 18, 0);
REPLACE INTO `item_mods` VALUES
    (18828, 9, 5),
    (18828, 11, 5),
    (18828, 23, 10),
    (18828, 25, 10),
    (18828, 288, 5),
    (18828, 289, 10);

-- Tin Popgun (Lv5)
REPLACE INTO `item_basic` VALUES (18939, 0, 'Tin_Popgun', 'tin_popgun', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18939, "tin_popgun", 5, 0, 66560, 59, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18939, "tin_popgun", 26, 1, 0, 0, 0, 1, 1, 360, 30, 0);
REPLACE INTO `item_mods` VALUES
    (18939, 11, 5),
    (18939, 24, 10),
    (18939, 26, 10),
    (18939, 365, 8),
    (18939, 359, 8),
    (18939, 376, 15);

-- Firefly Gun (Lv15)
REPLACE INTO `item_basic` VALUES (18938, 0, 'Firefly_Gun', 'firefly_gun', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18938, "firefly_gun", 15, 0, 66560, 60, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18938, "firefly_gun", 26, 1, 0, 0, 0, 1, 1, 360, 55, 0);
REPLACE INTO `item_mods` VALUES
    (18938, 11, 8),
    (18938, 24, 20),
    (18938, 26, 20),
    (18938, 365, 10),
    (18938, 359, 12),
    (18938, 376, 30),
    (18938, 479, 10);

-- Bandit Fnag (Lv30)
REPLACE INTO `item_basic` VALUES (16498, 0, 'Bandit_Fnag', 'bandit_fang', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (16498, "bandit_fang", 30, 0, 262192, 179, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (16498, "bandit_fang", 2, 0, 0, 0, 0, 1, 1, 160, 65, 0);
REPLACE INTO `item_mods` VALUES
    (16498, 9, 12),
    (16498, 11, 12),
    (16498, 23, 25),
    (16498, 25, 25),
    (16498, 289, 15),
    (16498, 302, 10),
    (16498, 840, 15);

-- Sams Sticker (Lv30)
REPLACE INTO `item_basic` VALUES (21572, 0, 'Sams_Sticker', 'sams_sticker', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (21572, "sams_sticker", 30, 0, 4194303, 805, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (21572, "sams_sticker", 2, 0, 0, 0, 0, 1, 1, 120, 75, 0);
REPLACE INTO `item_mods` VALUES
    (21572, 9, 15),
    (21572, 11, 15),
    (21572, 23, 25),
    (21572, 24, 25),
    (21572, 25, 25),
    (21572, 26, 25),
    (21572, 288, 25),
    (21572, 302, 10),
    (21572, 840, 25),
    (21572, 949, 25),
    (21572, 506, 250),
    (21572, 507, 250);

-- Beast Axe (Lv35)
REPLACE INTO `item_basic` VALUES (16654, 0, 'Beast_Axe', 'beast_axe', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (16654, "beast_axe", 35, 0, 256, 519, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (16654, "beast_axe", 5, 0, 0, 0, 0, 2, 1, 240, 105, 0);
REPLACE INTO `item_mods` VALUES
    (16654, 8, 12),
    (16654, 23, 25),
    (16654, 25, 25),
    (16654, 273, 30),
    (16654, 564, 2),
    (16654, 1052, 10),
    (16654, 990, 110),
    (16654, 991, 90),
    (16654, 994, 50),
    (16654, 995, 1000),
    (16654, 1034, 70),
    (16654, 840, 15);
REPLACE INTO `item_mods_pet` VALUES
    (16654, 368, 10, 0);

-- Wyvern Pike (Lv45)
REPLACE INTO `item_basic` VALUES (19073, 0, 'Wyvern_Pike', 'wyvern_pike', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19073, "wyvern_pike", 45, 0, 8192, 423, 0, 1, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19073, "wyvern_pike", 8, 0, 0, 0, 0, 1, 1, 360, 190, 0);
REPLACE INTO `item_mods` VALUES
    (19073, 8, 18),
    (19073, 9, 12),
    (19073, 23, 40),
    (19073, 25, 35),
    (19073, 361, 50),
    (19073, 402, 40),
    (19073, 829, 3),
    (19073, 986, 30),
    (19073, 1043, 10),
    (19073, 990, 100),
    (19073, 991, 80),
    (19073, 994, 45),
    (19073, 1034, 60),
    (19073, 840, 25);

-- Avatar Spire (Lv50)
REPLACE INTO `item_basic` VALUES (17110, 0, 'Avatar_Spire', 'avatar_spire', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (17110, "avatar_spire", 50, 0, 16384, 297, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (17110, "avatar_spire", 12, 0, 0, 0, 0, 3, 1, 300, 140, 0);
REPLACE INTO `item_mods` VALUES
    (17110, 5, 150),
    (17110, 12, 18),
    (17110, 13, 18),
    (17110, 117, 25),
    (17110, 346, 12),
    (17110, 913, 40),
    (17110, 1034, 60),
    (17110, 1035, 60),
    (17110, 1040, 15),
    (17110, 1154, 3),
    (17110, 990, 100),
    (17110, 991, 90),
    (17110, 992, 70),
    (17110, 993, 70),
    (17110, 994, 55),
    (17110, 995, 1200),
    (17110, 369, 5);

-- Railgun (Lv60)
REPLACE INTO `item_basic` VALUES (17273, 0, 'Railgun', 'railgun', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (17273, "railgun", 60, 0, 66560, 58, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (17273, "railgun", 26, 1, 0, 0, 0, 1, 1, 300, 260, 0);
REPLACE INTO `item_mods` VALUES
    (17273, 11, 25),
    (17273, 24, 80),
    (17273, 26, 80),
    (17273, 365, 35),
    (17273, 359, 40),
    (17273, 376, 160),
    (17273, 840, 40),
    (17273, 949, 25),
    (17273, 479, 35),
    (17273, 506, 300),
    (17273, 507, 300);

-- Moon Fang (Lv65)
REPLACE INTO `item_basic` VALUES (17801, 0, 'Moon_Fang', 'moon_fang', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (17801, "moon_fang", 65, 0, 2048, 440, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (17801, "moon_fang", 10, 0, 0, 0, 0, 2, 1, 360, 170, 0);
REPLACE INTO `item_mods` VALUES
    (17801, 8, 20),
    (17801, 9, 20),
    (17801, 23, 45),
    (17801, 25, 40),
    (17801, 73, 20),
    (17801, 840, 30),
    (17801, 175, 50),
    (17801, 174, 25),
    (17801, 949, 20),
    (17801, 1144, 128);

-- Blinksteel (Lv65)
REPLACE INTO `item_basic` VALUES (18313, 0, 'Blinksteel', 'blinksteel', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18313, "blinksteel", 65, 0, 4096, 344, 0, 1, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18313, "blinksteel", 9, 0, 0, 0, 0, 2, 1, 160, 90, 0);
REPLACE INTO `item_mods` VALUES
    (18313, 9, 22),
    (18313, 11, 18),
    (18313, 23, 40),
    (18313, 25, 45),
    (18313, 73, 18),
    (18313, 384, 1000),
    (18313, 302, 12),
    (18313, 430, 5),
    (18313, 840, 25),
    (18313, 949, 20);

-- Meteor Fists (Lv75)
REPLACE INTO `item_basic` VALUES (16428, 0, 'Meteor_Fists', 'meteor_fists', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (16428, "meteor_fists", 75, 0, 2, 499, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (16428, "meteor_fists", 1, 0, 0, 0, 0, 4, 1, 50, 100, 0);
REPLACE INTO `item_mods` VALUES
    (16428, 8, 30),
    (16428, 9, 30),
    (16428, 23, 80),
    (16428, 25, 80),
    (16428, 289, 30),
    (16428, 302, 30),
    (16428, 430, 15),
    (16428, 840, 45),
    (16428, 949, 30);

-- Black Star (Lv75)
REPLACE INTO `item_basic` VALUES (17131, 0, 'Black_Star', 'black_star', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (17131, "black_star", 75, 0, 1589260, 303, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (17131, "black_star", 12, 0, 0, 0, 0, 3, 1, 420, 78, 0);
REPLACE INTO `item_mods` VALUES
    (17131, 5, 250),
    (17131, 12, 50),
    (17131, 28, 100),
    (17131, 30, 80),
    (17131, 311, 350),
    (17131, 530, 60),
    (17131, 562, 30),
    (17131, 563, 75),
    (17131, 369, 6);

-- Packlord Axe (Lv75)
REPLACE INTO `item_basic` VALUES (17961, 0, 'Packlord_Axe', 'packlord_axe', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (17961, "packlord_axe", 75, 0, 256, 88, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (17961, "packlord_axe", 5, 0, 0, 0, 0, 2, 1, 276, 44, 0);
REPLACE INTO `item_mods` VALUES
    (17961, 8, 35),
    (17961, 23, 80),
    (17961, 25, 80),
    (17961, 273, 60),
    (17961, 1052, 25),
    (17961, 990, 200),
    (17961, 991, 160),
    (17961, 994, 100),
    (17961, 995, 2500),
    (17961, 1034, 100);
REPLACE INTO `item_mods_pet` VALUES
    (17961, 23, 180, 0),
    (17961, 25, 160, 0),
    (17961, 161, -1500, 0),
    (17961, 163, -1500, 0),
    (17961, 288, 35, 0),
    (17961, 289, 50, 0),
    (17961, 370, 20, 0);

-- Titan Breaker (Lv75)
REPLACE INTO `item_basic` VALUES (18511, 0, 'Titan_Breaker', 'titan_breaker', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18511, "titan_breaker", 75, 0, 2097281, 96, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18511, "titan_breaker", 6, 0, 0, 0, 0, 2, 1, 430, 320, 0);
REPLACE INTO `item_mods` VALUES
    (18511, 8, 45),
    (18511, 10, 35),
    (18511, 23, 120),
    (18511, 25, 80),
    (18511, 73, 30),
    (18511, 840, 100),
    (18511, 841, 75),
    (18511, 175, 100),
    (18511, 174, 50),
    (18511, 161, -1000),
    (18511, 163, -1000),
    (18511, 949, 40);

-- Ghost Knife (Lv75)
REPLACE INTO `item_basic` VALUES (20571, 0, 'Ghost_Knife', 'ghost_knife', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (20571, "ghost_knife", 75, 0, 262688, 805, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (20571, "ghost_knife", 2, 0, 0, 0, 0, 1, 1, 120, 150, 0);
REPLACE INTO `item_mods` VALUES
    (20571, 9, 35),
    (20571, 11, 35),
    (20571, 23, 90),
    (20571, 25, 90),
    (20571, 289, 30),
    (20571, 302, 30),
    (20571, 430, 10),
    (20571, 840, 50),
    (20571, 949, 40),
    (20571, 506, 400),
    (20571, 507, 500);

-- Bloody Saber (Lv80)
REPLACE INTO `item_basic` VALUES (16582, 0, 'Bloody_Saber', 'blood_saber', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (16582, "blood_saber", 80, 0, 2130113, 288, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (16582, "blood_saber", 3, 0, 0, 0, 0, 2, 1, 224, 180, 0);
REPLACE INTO `item_mods` VALUES
    (16582, 2, 250),
    (16582, 10, 25),
    (16582, 13, 15),
    (16582, 23, 35),
    (16582, 25, 35),
    (16582, 27, 10),
    (16582, 109, 30),
    (16582, 161, -1200),
    (16582, 163, -1200),
    (16582, 190, -800),
    (16582, 518, 20),
    (16582, 840, 25),
    (16582, 431, 5),
    (16582, 500, 200),
    (16582, 501, 60);

-- Hvergelmir (Lv80)
REPLACE INTO `item_basic` VALUES (19408, 0, 'Hvergelmir', 'hvergelmir', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19408, "hvergelmir", 80, 0, 540680, 516, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19408, "hvergelmir", 12, 0, 0, 0, 0, 3, 1, 390, 87, 0);

-- Foam Sword (Lv80)
REPLACE INTO `item_basic` VALUES (19422, 0, 'Foam_Sword', 'foam_sword', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19422, "foam_sword", 80, 0, 32848, 253, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19422, "foam_sword", 3, 0, 0, 0, 0, 2, 1, 180, 22, 0);
REPLACE INTO `item_mods` VALUES
    (19422, 2, 40),
    (19422, 23, 8),
    (19422, 25, 8),
    (19422, 289, 10),
    (19422, 161, -300),
    (19422, 370, 1);

-- Arasy Knife (Lv99)
REPLACE INTO `item_basic` VALUES (21554, 0, 'Arasy_Knife', 'arasy_knife', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (21554, "arasy_knife", 99, 0, 474849, 157, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (21554, "arasy_knife", 2, 0, 242, 242, 188, 1, 1, 183, 94, 0);
REPLACE INTO `item_mods` VALUES
    (21554, 9, 6),
    (21554, 11, 6),
    (21554, 14, 6),
    (21554, 25, 10),
    (21554, 31, 22),
    (21554, 165, 2);

-- Defensive shield chase drops
DELETE FROM `item_mods` WHERE `itemId` IN (12408, 16183, 16185);

-- Bubble Shield (lv15)
REPLACE INTO `item_basic` VALUES (16185, 0, 'bubble_shield', 'bubble_shield', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (16185, "bubble_shield", 15, 0, 2132437, 36, 2, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (16185, 1, 20),
    (16185, 2, 60),
    (16185, 10, 6),
    (16185, 27, 3),
    (16185, 109, 10),
    (16185, 161, -500),
    (16185, 163, -500),
    (16185, 518, 10);

-- Nomad Guard (lv45)
REPLACE INTO `item_basic` VALUES (16183, 0, 'nomad_guard', 'nomad_guard', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (16183, "nomad_guard", 45, 0, 4194303, 56, 3, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (16183, 1, 45),
    (16183, 2, 150),
    (16183, 10, 12),
    (16183, 27, 6),
    (16183, 109, 20),
    (16183, 161, -1000),
    (16183, 163, -1000),
    (16183, 485, 25),
    (16183, 518, 20),
    (16183, 905, 20);

-- Apex Bulwark (lv75)
REPLACE INTO `item_basic` VALUES (12408, 0, 'apex_bulwark', 'apex_bulwark', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (12408, "apex_bulwark", 75, 0, 2099537, 46, 4, 0, 2, 0, 0, 0);
REPLACE INTO `item_mods` VALUES
    (12408, 1, 80),
    (12408, 2, 300),
    (12408, 10, 30),
    (12408, 27, 15),
    (12408, 29, 20),
    (12408, 109, 50),
    (12408, 161, -2000),
    (12408, 163, -2000),
    (12408, 190, -1000),
    (12408, 485, 50),
    (12408, 518, 35),
    (12408, 905, 50),
    (12408, 1082, 10);
