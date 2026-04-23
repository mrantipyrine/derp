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
DELETE FROM `item_mods` WHERE `itemId` IN (16428, 16498, 16582, 16654, 17110, 17131, 17273, 17801, 17856, 17961, 18313, 18511, 18775, 18828, 18853, 18863, 18868, 18875, 18883, 18884, 18891, 18921, 18938, 18939, 19073, 19164, 19188, 19191, 19271, 19377, 19402, 19408, 19422, 19448, 19452, 20571, 21554, 21572, 21602, 21804, 21817, 22124);
DELETE FROM `item_mods_pet` WHERE `itemId` IN (16428, 16498, 16582, 16654, 17110, 17131, 17273, 17801, 17856, 17961, 18313, 18511, 18775, 18828, 18853, 18863, 18868, 18875, 18883, 18884, 18891, 18921, 18938, 18939, 19073, 19164, 19188, 19191, 19271, 19377, 19402, 19408, 19422, 19448, 19452, 20571, 21554, 21572, 21602, 21804, 21817, 22124);

-- Death Dealer (Lv1)
REPLACE INTO `item_basic` VALUES (22124, 0, 'Death_Dealer', 'death_dealer', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (22124, "death_dealer", 1, 0, 4194303, 138, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (22124, "death_dealer", 25, 0, 0, 0, 0, 1, 1, 240, 350, 0);
REPLACE INTO `item_mods` VALUES
    (22124, 9, 30),
    (22124, 11, 30),
    (22124, 305, 100),
    (22124, 365, 10),
    (22124, 840, 50),
    (22124, 384, 2000);

-- Solstice Blade (Lv75)
REPLACE INTO `item_basic` VALUES (18891, 0, 'Solstice_Blade', 'solstice_blade', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18891, "solstice_blade", 75, 0, 2130113, 285, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18891, "solstice_blade", 3, 0, 0, 0, 0, 2, 1, 180, 420, 0);
REPLACE INTO `item_mods` VALUES
    (18891, 8, 30),
    (18891, 10, 30),
    (18891, 13, 30),
    (18891, 840, 40),
    (18891, 384, 1000),
    (18891, 161, -1500);

-- Nightstar Katana (Lv75)
REPLACE INTO `item_basic` VALUES (19271, 0, 'Nightstar_Katana', 'nightstar_katana', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19271, "nightstar_katana", 75, 0, 4096, 313, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19271, "nightstar_katana", 9, 0, 0, 0, 0, 2, 1, 150, 250, 0);
REPLACE INTO `item_mods` VALUES
    (19271, 1, 100),
    (19271, 9, 40),
    (19271, 11, 40),
    (19271, 25, 100),
    (19271, 26, 100),
    (19271, 302, 20),
    (19271, 430, 10),
    (19271, 289, 30),
    (19271, 259, 4),
    (19271, 384, 1000);

-- Horizon Tachi (Lv75)
REPLACE INTO `item_basic` VALUES (19448, 0, 'Horizon_Tachi', 'horizon_tachi', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19448, "horizon_tachi", 75, 0, 2048, 323, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19448, "horizon_tachi", 10, 0, 0, 0, 0, 2, 1, 300, 520, 0);
REPLACE INTO `item_mods` VALUES
    (19448, 8, 35),
    (19448, 9, 35),
    (19448, 73, 50),
    (19448, 345, 1000),
    (19448, 840, 75),
    (19448, 384, 800);

-- Worldcleaver (Lv75)
REPLACE INTO `item_basic` VALUES (19164, 0, 'Worldcleaver', 'worldcleaver', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19164, "worldcleaver", 75, 0, 2097281, 525, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19164, "worldcleaver", 4, 0, 0, 0, 0, 2, 1, 360, 700, 0);
REPLACE INTO `item_mods` VALUES
    (19164, 8, 50),
    (19164, 10, 30),
    (19164, 23, 200),
    (19164, 288, 30),
    (19164, 840, 100),
    (19164, 384, 800);

-- Dawn (Lv80)
REPLACE INTO `item_basic` VALUES (19452, 0, 'Dawn', 'dawn', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19452, "dawn", 80, 0, 68, 116, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19452, "dawn", 11, 0, 0, 0, 0, 3, 1, 220, 300, 0);
REPLACE INTO `item_mods` VALUES
    (19452, 13, 50),
    (19452, 8, 20),
    (19452, 374, 50),
    (19452, 860, 25),
    (19452, 370, 20),
    (19452, 384, 800),
    (19452, 840, 90);

-- Soulreaper (Lv75)
REPLACE INTO `item_basic` VALUES (21817, 0, 'Soulreaper', 'soulreaper', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (21817, "soulreaper", 75, 0, 128, 521, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (21817, "soulreaper", 7, 0, 0, 0, 0, 2, 1, 300, 666, 0);
REPLACE INTO `item_mods` VALUES
    (21817, 8, 66),
    (21817, 9, 66),
    (21817, 86, 200),
    (21817, 840, 66),
    (21817, 384, 1500),
    (21817, 165, 50),
    (21817, 315, 100);

-- Flick Knife (Lv5)
REPLACE INTO `item_basic` VALUES (18828, 0, 'Flick_Knife', 'flick_knife', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18828, "flick_knife", 5, 0, 262176, 597, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18828, "flick_knife", 2, 0, 0, 0, 0, 1, 1, 150, 180, 0);
REPLACE INTO `item_mods` VALUES
    (18828, 9, 5),
    (18828, 11, 5);

-- Tin Popgun (Lv5)
REPLACE INTO `item_basic` VALUES (18939, 0, 'Tin_Popgun', 'tin_popgun', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18939, "tin_popgun", 5, 0, 66560, 59, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18939, "tin_popgun", 26, 1, 0, 0, 0, 1, 1, 360, 30, 0);
REPLACE INTO `item_mods` VALUES
    (18939, 26, 10);

-- Firefly Gun (Lv15)
REPLACE INTO `item_basic` VALUES (18938, 0, 'Firefly_Gun', 'firefly_gun', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18938, "firefly_gun", 15, 0, 66560, 60, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18938, "firefly_gun", 26, 1, 0, 0, 0, 1, 1, 360, 55, 0);
REPLACE INTO `item_mods` VALUES
    (18938, 365, 10),
    (18938, 840, 5);

-- Bandit Fnag (Lv30)
REPLACE INTO `item_basic` VALUES (16498, 0, 'Bandit_Fnag', 'bandit_fang', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (16498, "bandit_fang", 30, 0, 262192, 179, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (16498, "bandit_fang", 2, 0, 0, 0, 0, 1, 1, 160, 65, 0);
REPLACE INTO `item_mods` VALUES
    (16498, 9, 2),
    (16498, 302, 4);

-- Sams Sticker (Lv30)
REPLACE INTO `item_basic` VALUES (21572, 0, 'Sams_Sticker', 'sams_sticker', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (21572, "sams_sticker", 30, 0, 4194303, 805, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (21572, "sams_sticker", 2, 0, 100, 100, 0, 1, 1, 160, 75, 0);
REPLACE INTO `item_mods` VALUES
    (21572, 9, 6),
    (21572, 11, 6),
    (21572, 165, 2);

-- Beast Axe (Lv35)
REPLACE INTO `item_basic` VALUES (16654, 0, 'Beast_Axe', 'beast_axe', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (16654, "beast_axe", 35, 0, 256, 519, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (16654, "beast_axe", 5, 0, 0, 0, 0, 2, 1, 240, 105, 0);
REPLACE INTO `item_mods` VALUES
    (16654, 990, 40);
REPLACE INTO `item_mods_pet` VALUES
    (16654, 368, 10, 0),
    (16654, 23, 40, 0);

-- Wyvern Pike (Lv75)
REPLACE INTO `item_basic` VALUES (19073, 0, 'Wyvern_Pike', 'wyvern_pike', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19073, "wyvern_pike", 75, 0, 8192, 423, 0, 1, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19073, "wyvern_pike", 8, 0, 0, 0, 0, 1, 1, 200, 500, 0);
REPLACE INTO `item_mods` VALUES
    (19073, 8, 30),
    (19073, 9, 30),
    (19073, 362, 30),
    (19073, 430, 25),
    (19073, 888, 30),
    (19073, 73, 50),
    (19073, 384, 500),
    (19073, 288, 10);
REPLACE INTO `item_mods_pet` VALUES
    (19073, 23, 4000, 0);

-- Avatar Spire (Lv50)
REPLACE INTO `item_basic` VALUES (17110, 0, 'Avatar_Spire', 'avatar_spire', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (17110, "avatar_spire", 50, 0, 16384, 297, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (17110, "avatar_spire", 12, 0, 0, 0, 0, 3, 1, 300, 140, 0);
REPLACE INTO `item_mods` VALUES
    (17110, 346, 12),
    (17110, 117, 25);
REPLACE INTO `item_mods_pet` VALUES
    (17110, 28, 140, 1);

-- Railgun (Lv60)
REPLACE INTO `item_basic` VALUES (17273, 0, 'Railgun', 'railgun', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (17273, "railgun", 60, 0, 66560, 58, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (17273, "railgun", 26, 1, 0, 0, 0, 1, 1, 300, 260, 0);
REPLACE INTO `item_mods` VALUES
    (17273, 24, 100),
    (17273, 26, 80),
    (17273, 359, 40);

-- Moon Fang (Lv65)
REPLACE INTO `item_basic` VALUES (17801, 0, 'Moon_Fang', 'moon_fang', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (17801, "moon_fang", 65, 0, 2048, 440, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (17801, "moon_fang", 10, 0, 0, 0, 0, 2, 1, 360, 170, 0);
REPLACE INTO `item_mods` VALUES
    (17801, 8, 5),
    (17801, 73, 6),
    (17801, 840, 30);

-- Pixie Piccolo (Lv18)
REPLACE INTO `item_basic` VALUES (17856, 0, 'Pixie_Piccolo', 'pixie_piccolo', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (17856, "pixie_piccolo", 18, 0, 512, 65, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (17856, "pixie_piccolo", 42, 0, 0, 0, 0, 1, 1, 240, 0, 0);
REPLACE INTO `item_mods` VALUES
    (17856, 14, 8),
    (17856, 452, 2),
    (17856, 454, 20);

-- Blinksteel (Lv65)
REPLACE INTO `item_basic` VALUES (18313, 0, 'Blinksteel', 'blinksteel', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18313, "blinksteel", 65, 0, 4096, 344, 0, 1, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18313, "blinksteel", 9, 0, 0, 0, 0, 2, 1, 160, 90, 0);
REPLACE INTO `item_mods` VALUES
    (18313, 23, 100),
    (18313, 384, 1000),
    (18313, 431, 2),
    (18313, 951, 4),
    (18313, 953, 30);

-- Meteor Fists (Lv75)
REPLACE INTO `item_basic` VALUES (16428, 0, 'Meteor_Fists', 'meteor_fists', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (16428, "meteor_fists", 75, 0, 2, 499, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (16428, "meteor_fists", 1, 0, 0, 0, 0, 4, 1, 50, 100, 0);
REPLACE INTO `item_mods` VALUES
    (16428, 165, 30),
    (16428, 292, 20),
    (16428, 384, 1500);

-- Black Star (Lv75)
REPLACE INTO `item_basic` VALUES (17131, 0, 'Black_Star', 'black_star', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (17131, "black_star", 75, 0, 1589260, 303, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (17131, "black_star", 12, 0, 0, 0, 0, 3, 1, 402, 78, 0);
REPLACE INTO `item_mods` VALUES
    (17131, 28, 250),
    (17131, 30, 150),
    (17131, 865, 40);

-- Packlord Axe (Lv75)
REPLACE INTO `item_basic` VALUES (17961, 0, 'Packlord_Axe', 'packlord_axe', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (17961, "packlord_axe", 75, 0, 256, 88, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (17961, "packlord_axe", 5, 0, 0, 0, 0, 2, 1, 200, 200, 0);
REPLACE INTO `item_mods` VALUES
    (17961, 8, 30),
    (17961, 14, 30),
    (17961, 364, 14),
    (17961, 990, 80);
REPLACE INTO `item_mods_pet` VALUES
    (17961, 23, 20, 0),
    (17961, 25, 30, 0),
    (17961, 370, 20, 0),
    (17961, 384, 800, 0);

-- Titan Breaker (Lv75)
REPLACE INTO `item_basic` VALUES (18511, 0, 'Titan_Breaker', 'titan_breaker', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18511, "titan_breaker", 75, 0, 2097281, 96, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18511, "titan_breaker", 6, 0, 0, 0, 0, 2, 1, 300, 600, 0);
REPLACE INTO `item_mods` VALUES
    (18511, 8, 40),
    (18511, 10, 40),
    (18511, 840, 100),
    (18511, 161, -1000),
    (18511, 384, 1100);

-- Ghost Knife (Lv75)
REPLACE INTO `item_basic` VALUES (20571, 0, 'Ghost_Knife', 'ghost_knife', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (20571, "ghost_knife", 75, 0, 262688, 805, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (20571, "ghost_knife", 2, 0, 0, 0, 0, 1, 1, 150, 250, 0);
REPLACE INTO `item_mods` VALUES
    (20571, 9, 30),
    (20571, 11, 30),
    (20571, 302, 20),
    (20571, 526, 50),
    (20571, 259, 3),
    (20571, 384, 1000);

-- Storm Knuckles (Lv36)
REPLACE INTO `item_basic` VALUES (18775, 0, 'Storm_Knuckles', 'storm_knuckles', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18775, "storm_knuckles", 36, 0, 131074, 506, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18775, "storm_knuckles", 1, 0, 0, 0, 0, 4, 1, 287, 48, 0);
REPLACE INTO `item_mods` VALUES
    (18775, 289, 10),
    (18775, 384, 800);

-- Baarbara Bell (Lv1)
REPLACE INTO `item_basic` VALUES (18863, 0, 'Baarbara_Bell', 'baarbara_bell', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18863, "baarbara_bell", 1, 0, 4194303, 449, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18863, "baarbara_bell", 11, 0, 0, 0, 0, 3, 1, 210, 18, 0);
REPLACE INTO `item_mods` VALUES
    (18863, 5, 25),
    (18863, 12, 4),
    (18863, 13, 4),
    (18863, 28, 5),
    (18863, 369, 1);

-- Baarbara Bell (Lv1 alternate)
REPLACE INTO `item_basic` VALUES (18868, 0, 'Baarbara_Bell_Alt', 'baarbara_bell_alt', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18868, "baarbara_bell", 1, 0, 4194303, 456, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18868, "baarbara_bell", 11, 0, 0, 0, 0, 3, 1, 216, 99, 0);

-- Seveneye Rod (Lv45)
REPLACE INTO `item_basic` VALUES (18875, 0, 'Seveneye_Rod', 'seveneye_rod', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18875, "seveneye_rod", 45, 0, 16460, 103, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18875, "seveneye_rod", 11, 0, 0, 0, 0, 3, 1, 190, 95, 0);
REPLACE INTO `item_mods` VALUES
    (18875, 170, 30);

-- Ember Staff (Lv55)
REPLACE INTO `item_basic` VALUES (18921, 0, 'Ember_Staff', 'ember_staff', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (18921, "ember_staff", 55, 0, 540680, 298, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (18921, "ember_staff", 12, 0, 0, 0, 0, 3, 1, 402, 79, 0);
REPLACE INTO `item_mods` VALUES
    (18921, 28, 45),
    (18921, 369, 3);

-- Sky Bow (Lv45)
REPLACE INTO `item_basic` VALUES (19188, 0, 'Sky_Bow', 'sky_bow', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19188, "sky_bow", 45, 0, 7665, 41, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19188, "sky_bow", 25, 0, 0, 0, 0, 1, 1, 300, 160, 0);
REPLACE INTO `item_mods` VALUES
    (19188, 26, 25),
    (19188, 365, 40);

-- Boomstick (Lv60)
REPLACE INTO `item_basic` VALUES (19191, 0, 'Boomstick', 'boomstick', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19191, "boomstick", 60, 0, 66560, 58, 0, 0, 4, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19191, "boomstick", 26, 1, 0, 0, 0, 1, 1, 582, 400, 0);
REPLACE INTO `item_mods` VALUES
    (19191, 24, 60),
    (19191, 26, 40);

-- Luckitoo (Lv35)
REPLACE INTO `item_basic` VALUES (19377, 0, 'Luckitoo', 'luckitoo', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19377, "luckitoo", 35, 0, 65, 113, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19377, "luckitoo", 11, 0, 0, 0, 0, 3, 1, 180, 80, 0);
REPLACE INTO `item_mods` VALUES
    (19377, 8, 6),
    (19377, 13, -10),
    (19377, 384, 300);

-- Jims Cleaver (Lv25)
REPLACE INTO `item_basic` VALUES (19402, 0, 'Jims_Cleaver', 'jims_cleaver', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19402, "jims_cleaver", 25, 0, 129, 469, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19402, "jims_cleaver", 6, 0, 0, 0, 0, 2, 1, 350, 120, 0);
REPLACE INTO `item_mods` VALUES
    (19402, 8, 20),
    (19402, 840, 25);

-- Guardbreak (Lv40)
REPLACE INTO `item_basic` VALUES (21602, 0, 'Guardbreak', 'guardbreak', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (21602, "guardbreak", 40, 0, 4194303, 787, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (21602, "guardbreak", 3, 0, 0, 0, 0, 2, 1, 220, 115, 0);
REPLACE INTO `item_mods` VALUES
    (21602, 10, 20),
    (21602, 161, -800);

-- Grave Scythe (Lv49)
REPLACE INTO `item_basic` VALUES (21804, 0, 'Grave_Scythe', 'grave_scythe', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (21804, "grave_scythe", 49, 0, 128, 393, 0, 0, 1, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (21804, "grave_scythe", 7, 0, 0, 0, 0, 2, 1, 420, 180, 0);
REPLACE INTO `item_mods` VALUES
    (21804, 8, 22),
    (21804, 431, 5),
    (21804, 500, 100),
    (21804, 501, 40),
    (21804, 840, 35);

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

-- Foam Sword (Lv5)
REPLACE INTO `item_basic` VALUES (19422, 0, 'Foam_Sword', 'foam_sword', 1, 59476, 99, 0, 0);
REPLACE INTO `item_equipment` VALUES (19422, "foam_sword", 5, 0, 32849, 253, 0, 0, 3, 0, 0, 0);
REPLACE INTO `item_weapon` VALUES (19422, "foam_sword", 3, 0, 0, 0, 0, 2, 1, 180, 22, 0);
REPLACE INTO `item_mods` VALUES
    (19422, 8, 5),
    (19422, 10, 5),
    (19422, 161, -300),
    (19422, 288, 5);

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

-- =============================================================================
-- GENERATED NOVELTY LEVEL 5-75 EQUIPMENT UPGRADES
-- Mirrors armor.yml, armor2.yml, and weapon.yml display changes in server SQL.
-- Regenerate from novelty_armor_upgrades.yml and novelty_weapon_upgrades.yml.
-- =============================================================================

DELETE FROM `item_mods` WHERE `itemId` IN (10250, 10251, 10252, 10253, 10254, 10256, 10257, 10258, 10259, 10260, 10261, 10262, 10263, 10264, 10265, 10266, 10267, 10268, 10269, 10270, 10271, 10293, 10330, 10331, 10332, 10333, 10334, 10335, 10336, 10337, 10382, 10383, 10384, 10385, 10429, 10430, 10431, 10432, 10433, 10446, 10593, 10594, 10595, 10596, 10808, 10809, 10810, 10811, 10812, 10847, 10848, 10849, 10850, 10851, 10852, 10875, 11002, 11265, 11266, 11267, 11268, 11269, 11270, 11271, 11272, 11273, 11274, 11275, 11276, 11277, 11278, 11279, 11280, 11316, 11317, 11318, 11319, 11320, 11321, 11322, 11323, 11324, 11325, 11326, 11327, 11328, 11490, 11491, 11500, 11811, 11812, 11861, 11862, 11965, 11966, 11967, 11968, 12491, 12619, 12951, 12960, 13121, 13122, 13517, 13682, 13683, 13684, 13810, 13819, 13820, 13821, 13822, 13842, 14070, 14072, 14117, 14171, 14173, 14242, 14292, 14294, 14519, 14520, 14532, 14533, 14534, 14535, 14628, 14629, 14647, 14648, 15178, 15179, 15204, 15212, 15288, 15289, 15297, 15298, 15299, 15444, 15446, 15447, 15448, 15450, 15451, 15452, 15453, 15454, 15752, 15753, 15847, 15848, 15860, 15919, 15921, 15929, 15933, 16003, 16075, 16109, 16118, 16119, 16223, 16224, 16225, 16226, 16227, 16243, 16249, 16257, 16273, 16323, 16324, 16325, 16326, 16327, 16328, 17031, 17032, 17074, 17345, 17353, 17372, 17373, 18102, 18103, 18399, 18400, 18401, 18464, 18545, 18563, 18842, 18871, 18880, 18881, 18912, 18913, 20532, 20533, 21074, 21086, 21087, 21153, 21154, 21760, 22003, 22004, 22005, 22019, 22020, 22043, 22044, 22047, 22048, 22049, 22051, 22069, 22283, 23730, 23731, 23737, 23790, 23791, 23805, 23806, 23807, 23809, 23810, 23816, 23819, 23833, 23848, 23862, 23863, 23864, 23865, 23870, 23871, 23872, 23873, 23874, 23893, 23894, 25585, 25586, 25587, 25604, 25632, 25638, 25639, 25645, 25652, 25657, 25658, 25669, 25670, 25671, 25672, 25673, 25675, 25677, 25678, 25679, 25711, 25712, 25713, 25715, 25734, 25735, 25736, 25737, 25738, 25739, 25740, 25741, 25742, 25743, 25744, 25755, 25756, 25757, 25758, 25759, 25774, 25775, 25776, 25838, 25839, 25850, 25851, 25864, 25909, 25910, 26271, 26272, 26330, 26352, 26406, 26415, 26416, 26426, 26431, 26436, 26441, 26446, 26451, 26456, 26461, 26465, 26468, 26471, 26474, 26477, 26480, 26483, 26486, 26516, 26517, 26519, 26523, 26546, 26693, 26694, 26704, 26705, 26706, 26708, 26717, 26718, 26719, 26720, 26728, 26730, 26738, 26739, 26788, 26798, 26799, 26954, 26955, 26966, 26967, 26968, 27110, 27293, 27294, 27625, 27626, 27631, 27632, 27715, 27716, 27717, 27718, 27726, 27727, 27733, 27734, 27755, 27756, 27758, 27759, 27760, 27765, 27803, 27804, 27805, 27806, 27854, 27855, 27866, 27867, 27879, 27880, 27906, 27911, 28086, 28087, 28302, 28303, 28510, 28651, 28652, 28653, 28670);
DELETE FROM `item_mods_pet` WHERE `itemId` IN (17031, 17032, 17074, 17345, 17353, 17372, 17373, 18102, 18103, 18399, 18400, 18401, 18464, 18545, 18563, 18842, 18871, 18880, 18881, 18912, 18913, 20532, 20533, 21074, 21086, 21087, 21153, 21154, 21760, 22003, 22004, 22005, 22019, 22020, 22043, 22044, 22047, 22048, 22049, 22051, 22069, 22283);

-- Equipment levels: armor novelty items and upgraded novelty weapons.
REPLACE INTO `item_equipment` VALUES
    (10250, 'moogle_suit', 40, 0, 4194303, 307, 0, 3, 32, 448, 0, 0),
    (10251, 'decennial_coat', 45, 0, 4194303, 331, 0, 0, 32, 64, 0, 0),
    (10252, 'decennial_dress', 50, 0, 4194303, 332, 0, 0, 32, 64, 0, 0),
    (10253, 'decennial_coat_+1', 60, 0, 4194303, 331, 0, 0, 32, 64, 0, 0),
    (10254, 'decennial_dress_+1', 65, 0, 4194303, 332, 0, 0, 32, 64, 0, 0),
    (10256, 'marine_gilet', 70, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10257, 'marine_top', 75, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10258, 'woodsy_gilet', 5, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10259, 'woodsy_top', 10, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10260, 'creek_maillot', 15, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10261, 'creek_top', 20, 0, 4194303, 335, 0, 0, 32, 64, 0, 0),
    (10262, 'river_top', 25, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10263, 'dune_gilet', 30, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10264, 'marine_gilet_+1', 40, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10265, 'marine_top_+1', 45, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10266, 'woodsy_gilet_+1', 50, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10267, 'woodsy_top_+1', 55, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10268, 'creek_maillot_+1', 60, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10269, 'creek_top_+1', 65, 0, 4194303, 335, 0, 0, 32, 64, 0, 0),
    (10270, 'river_top_+1', 70, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10271, 'dune_gilet_+1', 75, 0, 4194303, 334, 0, 0, 32, 64, 0, 0),
    (10293, 'chocobo_shirt', 30, 0, 4194303, 309, 0, 0, 32, 0, 0, 0),
    (10330, 'marine_boxers', 10, 0, 4194303, 334, 0, 0, 128, 256, 0, 0),
    (10331, 'marine_shorts', 15, 0, 4194303, 334, 0, 0, 128, 256, 0, 0),
    (10332, 'woodsy_boxers', 20, 0, 4194303, 334, 0, 0, 128, 256, 0, 0),
    (10333, 'woodsy_shorts', 25, 0, 4194303, 334, 0, 0, 128, 256, 0, 0),
    (10334, 'creek_boxers', 30, 0, 4194303, 334, 0, 0, 128, 256, 0, 0),
    (10335, 'creek_shorts', 35, 0, 4194303, 335, 0, 0, 128, 256, 0, 0),
    (10336, 'river_shorts', 40, 0, 4194303, 334, 0, 0, 128, 256, 0, 0),
    (10337, 'dune_boxers', 45, 0, 4194303, 334, 0, 0, 128, 256, 0, 0),
    (10382, 'dream_mittens', 35, 0, 4194303, 122, 0, 0, 64, 0, 0, 0),
    (10383, 'dream_mittens_+1', 45, 0, 4194303, 122, 0, 0, 64, 0, 0, 0),
    (10384, 'cumulus_masque', 25, 0, 4194303, 388, 0, 0, 16, 0, 0, 0),
    (10385, 'cumulus_masque_+1', 35, 0, 4194303, 388, 0, 0, 16, 0, 0, 0),
    (10429, 'moogle_masque', 25, 0, 4194303, 307, 0, 0, 16, 0, 0, 0),
    (10430, 'decennial_crown', 30, 0, 4194303, 331, 0, 0, 16, 0, 0, 0),
    (10431, 'decennial_tiara', 35, 0, 4194303, 332, 0, 0, 16, 0, 0, 0),
    (10432, 'decennial_crown_+1', 45, 0, 4194303, 331, 0, 0, 16, 0, 0, 0),
    (10433, 'decennial_tiara_+1', 50, 0, 4194303, 332, 0, 0, 16, 0, 0, 0),
    (10446, 'ahriman_cap', 35, 0, 4194303, 328, 0, 0, 16, 0, 0, 0),
    (10593, 'decennial_tights', 50, 0, 4194303, 331, 0, 0, 128, 256, 0, 0),
    (10594, 'decennial_hose', 55, 0, 4194303, 332, 0, 0, 128, 256, 0, 0),
    (10595, 'decennial_tights_+1', 65, 0, 4194303, 331, 0, 0, 128, 256, 0, 0),
    (10596, 'decennial_hose_+1', 70, 0, 4194303, 332, 0, 0, 128, 256, 0, 0),
    (10808, 'janus_guard', 15, 0, 4194303, 63, 1, 0, 2, 0, 0, 0),
    (10809, 'moogle_guard', 20, 0, 4194303, 642, 1, 0, 2, 0, 0, 0),
    (10810, 'moogle_guard_+1', 30, 0, 4194303, 642, 1, 0, 2, 0, 0, 0),
    (10811, 'chocobo_shield', 30, 0, 4194303, 643, 1, 0, 2, 0, 0, 0),
    (10812, 'choco._shield_+1', 40, 0, 4194303, 643, 1, 0, 2, 0, 0, 0),
    (10847, 'orc_belt', 65, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (10848, 'quadav_belt', 70, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (10849, 'yagudo_belt', 75, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (10850, 'leech_belt', 5, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (10851, 'slime_belt', 10, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (10852, 'hecteyes_belt', 15, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (10875, 'snowman_cap', 5, 0, 4194303, 122, 0, 0, 16, 0, 0, 0),
    (11002, 'dragon_tank', 25, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (11265, 'custom_gilet', 15, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11266, 'custom_top', 20, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11267, 'magna_gilet', 25, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11268, 'magna_top', 30, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11269, 'wonder_maillot', 35, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11270, 'wonder_top', 40, 0, 4194303, 226, 0, 0, 32, 64, 0, 0),
    (11271, 'savage_top', 45, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11272, 'elder_gilet', 50, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11273, 'custom_gilet_+1', 60, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11274, 'custom_top_+1', 65, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11275, 'magna_gilet_+1', 70, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11276, 'magna_top_+1', 75, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11277, 'wonder_maillot_+1', 75, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11278, 'wonder_top_+1', 10, 0, 4194303, 226, 0, 0, 32, 64, 0, 0),
    (11279, 'savage_top_+1', 15, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11280, 'elder_gilet_+1', 20, 0, 4194303, 225, 0, 0, 32, 64, 0, 0),
    (11316, 'otokogusa_yukata', 45, 0, 4194303, 243, 0, 0, 32, 0, 0, 0),
    (11317, 'onnagusa_yukata', 50, 0, 4194303, 244, 0, 0, 32, 0, 0, 0),
    (11318, 'otokoeshi_yukata', 55, 0, 4194303, 243, 0, 0, 32, 0, 0, 0),
    (11319, 'ominaeshi_yukata', 60, 0, 4194303, 244, 0, 0, 32, 0, 0, 0),
    (11320, 'skeleton_robe', 65, 0, 4194303, 18, 0, 0, 32, 0, 0, 0),
    (11321, 'orange_race_silks', 70, 0, 4194303, 187, 0, 0, 32, 0, 0, 0),
    (11322, 'black_race_silks', 75, 0, 4194303, 188, 0, 0, 32, 0, 0, 0),
    (11323, 'purple_race_silks', 5, 0, 4194303, 189, 0, 0, 32, 0, 0, 0),
    (11324, 's._blue_race_silks', 10, 0, 4194303, 190, 0, 0, 32, 0, 0, 0),
    (11325, 'blue_race_silks', 15, 0, 4194303, 191, 0, 0, 32, 0, 0, 0),
    (11326, 'red_race_silks', 20, 0, 4194303, 192, 0, 0, 32, 0, 0, 0),
    (11327, 'white_race_silks', 25, 0, 4194303, 193, 0, 0, 32, 0, 0, 0),
    (11328, 'green_race_silks', 30, 0, 4194303, 194, 0, 0, 32, 0, 0, 0),
    (11490, 'snow_bunny_hat', 5, 0, 4194303, 142, 0, 0, 16, 0, 0, 0),
    (11491, 's._bunny_hat_+1', 15, 0, 4194303, 142, 0, 0, 16, 0, 0, 0),
    (11500, 'chocobo_beret', 55, 0, 4194303, 102, 0, 0, 16, 0, 0, 0),
    (11811, 'destrier_beret', 35, 0, 4194303, 112, 0, 0, 16, 0, 0, 0),
    (11812, 'charity_cap', 40, 0, 4194303, 113, 0, 0, 16, 0, 0, 0),
    (11861, 'hikogami_yukata', 70, 0, 4194303, 224, 0, 0, 32, 0, 0, 0),
    (11862, 'himegami_yukata', 75, 0, 4194303, 233, 0, 0, 32, 0, 0, 0),
    (11965, 'dream_trousers', 10, 0, 4194303, 243, 0, 0, 128, 0, 0, 0),
    (11966, 'dream_trousers_+1', 20, 0, 4194303, 243, 0, 0, 128, 0, 0, 0),
    (11967, 'dream_pants', 20, 0, 4194303, 244, 0, 0, 128, 0, 0, 0),
    (11968, 'dream_pants_+1', 30, 0, 4194303, 244, 0, 0, 128, 0, 0, 0),
    (12491, 'onion_cap', 60, 0, 1, 1, 0, 0, 16, 0, 0, 0),
    (12619, 'onion_harness', 35, 0, 1, 15, 0, 0, 32, 0, 0, 0),
    (12951, 'brz._leggings_+1', 75, 0, 2472947, 15, 0, 0, 256, 0, 0, 0),
    (12960, 'bronze_leggings', 45, 0, 2472947, 15, 0, 0, 256, 0, 0, 0),
    (13121, 'beast_collar', 75, 0, 4194303, 0, 0, 0, 512, 0, 0, 0),
    (13122, 'miners_pendant', 5, 0, 4194303, 0, 0, 0, 512, 0, 0, 0),
    (13517, 'wedding_ring', 50, 0, 4194303, 0, 0, 0, 24576, 0, 0, 0),
    (13682, 'ether_tank', 75, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (13683, 'water_tank', 5, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (13684, 'potion_tank', 10, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (13810, 'choc._jack_coat', 65, 0, 4194303, 103, 0, 0, 32, 0, 0, 0),
    (13819, 'onoko_yukata', 35, 0, 4194303, 126, 0, 0, 32, 0, 0, 0),
    (13820, 'omina_yukata', 40, 0, 4194303, 127, 0, 0, 32, 0, 0, 0),
    (13821, 'lords_yukata', 45, 0, 4194303, 126, 0, 0, 32, 0, 0, 0),
    (13822, 'ladys_yukata', 50, 0, 4194303, 127, 0, 0, 32, 0, 0, 0),
    (13842, 'tavnazian_mask', 65, 0, 4194303, 28, 0, 0, 16, 0, 0, 0),
    (14070, 'fsh._gloves', 25, 0, 4194303, 102, 0, 0, 64, 0, 0, 0),
    (14072, 'chocobo_gloves', 35, 0, 4194303, 103, 0, 0, 64, 0, 0, 0),
    (14117, 'rusty_leggings', 55, 0, 2472947, 15, 0, 0, 256, 0, 0, 0),
    (14171, 'fishermans_boots', 25, 0, 4194303, 102, 0, 0, 256, 0, 0, 0),
    (14173, 'chocobo_boots', 35, 0, 4194303, 103, 0, 0, 256, 0, 0, 0),
    (14242, 'rusty_subligar', 70, 0, 2472947, 15, 0, 0, 128, 0, 0, 0),
    (14292, 'fishermans_hose', 20, 0, 4194303, 102, 0, 0, 128, 0, 0, 0),
    (14294, 'chocobo_hose', 30, 0, 4194303, 103, 0, 0, 128, 0, 0, 0),
    (14519, 'dream_robe', 10, 0, 4194303, 140, 0, 0, 32, 0, 0, 0),
    (14520, 'dream_robe_+1', 20, 0, 4194303, 140, 0, 0, 32, 0, 0, 0),
    (14532, 'otoko_yukata', 75, 0, 4194303, 126, 0, 0, 32, 0, 0, 0),
    (14533, 'onago_yukata', 5, 0, 4194303, 127, 0, 0, 32, 0, 0, 0),
    (14534, 'otokogimi_yukata', 10, 0, 4194303, 126, 0, 0, 32, 0, 0, 0),
    (14535, 'onnagimi_yukata', 15, 0, 4194303, 127, 0, 0, 32, 0, 0, 0),
    (14628, 'castors_ring', 55, 0, 4194303, 0, 0, 0, 24576, 0, 0, 0),
    (14629, 'polluxs_ring', 60, 0, 4194303, 0, 0, 0, 24576, 0, 0, 0),
    (14647, 'castors_ring', 75, 0, 4194303, 0, 0, 0, 24576, 0, 0, 0),
    (14648, 'polluxs_ring', 5, 0, 4194303, 0, 0, 0, 24576, 0, 0, 0),
    (15178, 'dream_hat', 70, 0, 4194303, 140, 0, 0, 16, 0, 0, 0),
    (15179, 'dream_hat_+1', 75, 0, 4194303, 140, 0, 0, 16, 0, 0, 0),
    (15204, 'mandragora_beret', 50, 0, 4194303, 153, 0, 0, 16, 0, 0, 0),
    (15212, 'stars_cap', 15, 0, 4194303, 155, 0, 0, 16, 0, 0, 0),
    (15288, 'pellet_belt', 70, 0, 30639, 0, 0, 0, 1024, 0, 0, 0),
    (15289, 'bolt_belt', 75, 0, 1153, 0, 0, 0, 1024, 0, 0, 0),
    (15297, 'rabbit_belt', 40, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15298, 'worm_belt', 45, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15299, 'mandragora_belt', 50, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15444, 'carpenters_belt', 25, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15446, 'goldsmiths_belt', 35, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15447, 'weavers_belt', 40, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15448, 'tanners_belt', 45, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15450, 'alchemists_belt', 55, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15451, 'culinarians_belt', 60, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15452, 'fishermans_belt', 65, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15453, 'lugworm_belt', 70, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15454, 'little_worm_belt', 75, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15752, 'dream_boots', 55, 0, 4194303, 140, 0, 0, 256, 0, 0, 0),
    (15753, 'dream_boots_+1', 65, 0, 4194303, 140, 0, 0, 256, 0, 0, 0),
    (15847, 'matrimony_ring', 75, 0, 4194303, 0, 0, 0, 24576, 0, 0, 0),
    (15848, 'matrimony_band', 5, 0, 4194303, 0, 0, 0, 24576, 0, 0, 0),
    (15860, 'gyokuto_obi', 5, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15919, 'drovers_belt', 75, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15921, 'detonator_belt', 10, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15929, 'goblin_belt', 50, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (15933, 'stirge_belt', 70, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (16003, 'raising_earring', 20, 0, 4194303, 0, 0, 0, 6144, 0, 0, 0),
    (16075, 'witch_hat', 55, 0, 4194303, 181, 0, 0, 16, 0, 0, 0),
    (16109, 'egg_helm', 75, 0, 4194303, 198, 0, 0, 16, 0, 0, 0),
    (16118, 'moogle_cap', 45, 0, 4194303, 203, 0, 0, 16, 0, 0, 0),
    (16119, 'nomad_cap', 50, 0, 4194303, 204, 0, 0, 16, 0, 0, 0),
    (16223, 'orange_tank', 30, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (16224, 'apple_tank', 35, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (16225, 'pear_tank', 40, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (16226, 'pamama_tank', 45, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (16227, 'persikos_tank', 50, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (16243, 'drovers_mantle', 55, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (16249, 'elixir_tank', 10, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (16257, 'ghost_cape', 50, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (16273, 'pullus_torque', 10, 0, 4194303, 0, 0, 0, 512, 0, 0, 0),
    (16323, 'magna_trunks', 50, 0, 4194303, 225, 0, 0, 128, 256, 0, 0),
    (16324, 'magna_shorts', 55, 0, 4194303, 225, 0, 0, 128, 256, 0, 0),
    (16325, 'wonder_trunks', 60, 0, 4194303, 225, 0, 0, 128, 256, 0, 0),
    (16326, 'wonder_shorts', 65, 0, 4194303, 226, 0, 0, 128, 256, 0, 0),
    (16327, 'savage_shorts', 70, 0, 4194303, 225, 0, 0, 128, 256, 0, 0),
    (16328, 'elder_trunks', 75, 0, 4194303, 225, 0, 0, 128, 256, 0, 0),
    (17031, 'shell_scepter', 35, 0, 4194303, 592, 0, 0, 3, 0, 0, 0),
    (17032, 'gobbie_gavel', 40, 0, 4194303, 593, 0, 0, 3, 0, 0, 0),
    (17074, 'chocobo_wand', 25, 0, 4194303, 236, 0, 0, 3, 0, 0, 0),
    (17345, 'flute', 40, 0, 512, 65, 0, 0, 4, 0, 0, 0),
    (17353, 'maple_harp', 15, 0, 512, 75, 0, 0, 4, 0, 0, 0),
    (17372, 'flute_+1', 30, 0, 512, 65, 0, 0, 4, 0, 0, 0),
    (17373, 'maple_harp_+1', 45, 0, 512, 75, 0, 0, 4, 0, 0, 0),
    (18102, 'pitchfork', 20, 0, 4194303, 369, 0, 0, 1, 0, 0, 0),
    (18103, 'pitchfork_+1', 30, 0, 4194303, 369, 0, 0, 1, 0, 0, 0),
    (18399, 'charm_wand', 50, 0, 4194303, 373, 0, 0, 3, 0, 0, 0),
    (18400, 'charm_wand_+1', 60, 0, 4194303, 373, 0, 0, 3, 0, 0, 0),
    (18401, 'moogle_rod', 60, 0, 4194303, 374, 0, 0, 3, 0, 0, 0),
    (18464, 'ark_tachi', 40, 0, 4194303, 588, 0, 0, 1, 0, 0, 0),
    (18545, 'ark_tabar', 5, 0, 4194303, 587, 0, 0, 3, 0, 0, 0),
    (18563, 'ark_scythe', 30, 0, 4194303, 586, 0, 0, 1, 0, 0, 0),
    (18842, 'nmd._moogle_rod', 15, 0, 4194303, 383, 0, 0, 3, 0, 0, 0),
    (18871, 'kitty_rod', 10, 0, 4194303, 240, 0, 0, 3, 0, 0, 0),
    (18880, 'maestros_baton', 55, 0, 4194303, 539, 0, 0, 3, 0, 0, 0),
    (18881, 'melomane_mallet', 60, 0, 4194303, 540, 0, 0, 3, 0, 0, 0),
    (18912, 'ark_saber', 5, 0, 4194303, 584, 0, 0, 3, 0, 0, 0),
    (18913, 'ark_sword', 10, 0, 4194303, 585, 0, 0, 3, 0, 0, 0),
    (20532, 'worm_feelers', 15, 0, 4194303, 489, 0, 0, 1, 0, 0, 0),
    (20533, 'worm_feelers_+1', 25, 0, 4194303, 489, 0, 0, 1, 0, 0, 0),
    (21074, 'kupo_rod', 75, 0, 4194303, 374, 0, 0, 3, 0, 0, 0),
    (21086, 'heartstopper', 60, 0, 4194303, 755, 0, 0, 3, 0, 0, 0),
    (21087, 'heartstopper_+1', 70, 0, 4194303, 755, 0, 0, 3, 0, 0, 0),
    (21153, 'malice_masher', 55, 0, 4194303, 754, 0, 0, 1, 0, 0, 0),
    (21154, 'malice_masher_+1', 65, 0, 4194303, 754, 0, 0, 1, 0, 0, 0),
    (21760, 'dispatcher_s_axe', 25, 0, 4194303, 0, 0, 0, 1, 0, 0, 0),
    (22003, 'arthro_s_scepter', 70, 0, 4194303, 0, 0, 0, 3, 0, 0, 0),
    (22004, 'soulflayers_wand', 75, 0, 4194303, 823, 0, 0, 3, 0, 0, 0),
    (22005, 'burrowers_wand', 5, 0, 4194303, 823, 0, 0, 3, 0, 0, 0),
    (22019, 'jingly_rod', 75, 0, 4194303, 801, 0, 0, 3, 0, 0, 0),
    (22020, 'jingly_rod_+1', 10, 0, 4194303, 801, 0, 0, 3, 0, 0, 0),
    (22043, 'apkallu_scepter', 45, 0, 4194303, 897, 0, 0, 3, 0, 0, 0),
    (22044, 'tengu_war_fan', 50, 0, 4194303, 899, 0, 0, 3, 0, 0, 0),
    (22047, 'korrigan_mallet', 65, 0, 4194303, 539, 0, 0, 3, 0, 0, 0),
    (22048, 'adenium_mallet', 70, 0, 4194303, 540, 0, 0, 3, 0, 0, 0),
    (22049, 'citrullus_mallet', 75, 0, 4194303, 865, 0, 0, 3, 0, 0, 0),
    (22051, 'lycopodium_mallet', 10, 0, 4194303, 540, 0, 0, 3, 0, 0, 0),
    (22069, 'hapy_staff', 60, 0, 4194303, 806, 0, 0, 1, 0, 0, 0),
    (22283, 'marvelous_cheer', 55, 0, 4194303, 136, 0, 0, 4, 0, 0, 0),
    (23730, 'karakul_cap', 5, 0, 4194303, 454, 0, 0, 16, 0, 0, 0),
    (23731, 'ryl._chocobo_beret', 10, 0, 4194303, 455, 0, 0, 16, 0, 0, 0),
    (23737, 'byakko_masque', 40, 0, 4194303, 0, 0, 0, 16, 0, 0, 0),
    (23790, 'adenium_masque', 5, 0, 4194303, 471, 0, 0, 16, 0, 0, 0),
    (23791, 'adenium_suit', 20, 0, 4194303, 471, 0, 0, 32, 448, 0, 0),
    (23805, 'morbol_apron', 15, 0, 4194303, 478, 0, 0, 32, 0, 0, 0),
    (23806, 'vaquero_hat', 10, 0, 4194303, 0, 0, 0, 16, 0, 0, 0),
    (23807, 'esthetes_masque', 15, 0, 4194303, 480, 0, 0, 16, 0, 0, 0),
    (23809, 'esthetes_hose', 55, 0, 4194303, 480, 0, 0, 128, 256, 0, 0),
    (23810, 'knit_cap', 30, 0, 4194303, 0, 0, 0, 16, 0, 0, 0),
    (23816, 'sapphire_leggings', 25, 0, 4194303, 0, 0, 0, 256, 0, 0, 0),
    (23819, 'jadeite_gloves', 20, 0, 4194303, 0, 0, 0, 64, 0, 0, 0),
    (23833, 'ruby_robe', 5, 0, 4194303, 0, 0, 0, 32, 0, 0, 0),
    (23848, 'cowardice_gloves', 15, 0, 4194303, 0, 0, 0, 64, 0, 0, 0),
    (23862, 'boudox_s_masque', 65, 0, 4194303, 0, 0, 0, 16, 0, 0, 0),
    (23863, 'boudox_s_suit', 5, 0, 4194303, 0, 0, 0, 32, 0, 0, 0),
    (23864, 'magh_bihu_s_masque', 75, 0, 4194303, 0, 0, 0, 16, 0, 0, 0),
    (23865, 'magh_bihu_s_suit', 15, 0, 4194303, 0, 0, 0, 32, 0, 0, 0),
    (23870, 'eyre_cap', 30, 0, 4194303, 0, 0, 0, 16, 0, 0, 0),
    (23871, 'hebenus_gilet', 45, 0, 4194303, 0, 0, 0, 32, 0, 0, 0),
    (23872, 'hebenus_boxers', 70, 0, 4194303, 0, 0, 0, 128, 0, 0, 0),
    (23873, 'hebenus_top', 55, 0, 4194303, 0, 0, 0, 32, 0, 0, 0),
    (23874, 'hebenus_shorts', 5, 0, 4194303, 0, 0, 0, 128, 0, 0, 0),
    (23893, 'dhalmel_trousers', 25, 0, 4194303, 0, 0, 0, 128, 0, 0, 0),
    (23894, 'prishe_s_boots', 40, 0, 4194303, 0, 0, 0, 256, 0, 0, 0),
    (25585, 'bl._chocobo_cap', 55, 0, 4194303, 449, 0, 0, 16, 0, 0, 0),
    (25586, 'kakai_cap', 60, 0, 4194303, 450, 0, 0, 16, 0, 0, 0),
    (25587, 'kakai_cap_+1', 70, 0, 4194303, 450, 0, 0, 16, 0, 0, 0),
    (25604, 'buffalo_cap', 75, 0, 4194303, 402, 0, 0, 16, 0, 0, 0),
    (25632, 'carbie_cap', 65, 0, 4194303, 403, 0, 0, 16, 0, 0, 0),
    (25638, 'pachy._masque', 20, 0, 4194303, 417, 0, 0, 16, 0, 0, 0),
    (25639, 'korrigan_masque', 25, 0, 4194303, 418, 0, 0, 16, 0, 0, 0),
    (25645, 'kupo_masque', 55, 0, 4194303, 373, 0, 0, 16, 0, 0, 0),
    (25652, 'crab_cap', 15, 0, 4194303, 438, 0, 0, 16, 0, 0, 0),
    (25657, 'wyrmking_masque', 40, 0, 4194303, 414, 0, 0, 16, 0, 0, 0),
    (25658, 'wyrm._masque_+1', 50, 0, 4194303, 414, 0, 0, 16, 0, 0, 0),
    (25669, 'crab_cap_+1', 30, 0, 4194303, 438, 0, 0, 16, 0, 0, 0),
    (25670, 'rarab_cap', 30, 0, 4194303, 435, 0, 0, 16, 0, 0, 0),
    (25671, 'rarab_cap_+1', 40, 0, 4194303, 435, 0, 0, 16, 0, 0, 0),
    (25672, 'snoll_masque', 40, 0, 4194303, 437, 0, 0, 16, 0, 0, 0),
    (25673, 'snoll_masque_+1', 50, 0, 4194303, 437, 0, 0, 16, 0, 0, 0),
    (25675, 'wh._rarab_cap', 55, 0, 4194303, 436, 0, 0, 16, 0, 0, 0),
    (25677, 'arthros_cap', 65, 0, 4194303, 446, 0, 0, 16, 0, 0, 0),
    (25678, 'arthros_cap_+1', 75, 0, 4194303, 446, 0, 0, 16, 0, 0, 0),
    (25679, 'wh._rarab_cap_+1', 75, 0, 4194303, 436, 0, 0, 16, 0, 0, 0),
    (25711, 'botulus_suit', 20, 0, 4194303, 419, 0, 0, 32, 80, 0, 0),
    (25712, 'botulus_suit_+1', 30, 0, 4194303, 419, 0, 0, 32, 80, 0, 0),
    (25713, 'track_shirt', 30, 0, 4194303, 579, 0, 0, 32, 64, 0, 0),
    (25715, 'korrigan_suit', 40, 0, 4194303, 417, 0, 0, 32, 128, 448, 0),
    (25734, 'pieuje_unity_shirt', 60, 0, 4194303, 424, 0, 0, 32, 0, 0, 0),
    (25735, 'ayame_unity_shirt', 65, 0, 4194303, 425, 0, 0, 32, 0, 0, 0),
    (25736, 'i._shield_unity_shirt', 70, 0, 4194303, 426, 0, 0, 32, 0, 0, 0),
    (25737, 'apururu_unity_shirt', 75, 0, 4194303, 427, 0, 0, 32, 0, 0, 0),
    (25738, 'maat_unity_shirt', 5, 0, 4194303, 428, 0, 0, 32, 0, 0, 0),
    (25739, 'aldo_unity_shirt', 10, 0, 4194303, 429, 0, 0, 32, 0, 0, 0),
    (25740, 'jakoh_unity_shirt', 15, 0, 4194303, 430, 0, 0, 32, 0, 0, 0),
    (25741, 'naja_unity_shirt', 20, 0, 4194303, 431, 0, 0, 32, 0, 0, 0),
    (25742, 'flaviria_unity_shirt', 25, 0, 4194303, 432, 0, 0, 32, 0, 0, 0),
    (25743, 'yoran_unity_shirt', 30, 0, 4194303, 433, 0, 0, 32, 0, 0, 0),
    (25744, 'sylvie_unity_shirt', 35, 0, 4194303, 434, 0, 0, 32, 0, 0, 0),
    (25755, 'crustacean_shirt', 15, 0, 4194303, 584, 0, 0, 32, 0, 0, 0),
    (25756, 'wyrmking_suit', 20, 0, 4194303, 414, 0, 0, 32, 128, 448, 0),
    (25757, 'wyrmking_suit_+1', 30, 0, 4194303, 414, 0, 0, 32, 128, 448, 0),
    (25758, 'rhapsody_shirt', 30, 0, 4194303, 581, 0, 0, 32, 0, 0, 0),
    (25759, 'rhapsody_shirt_+1', 40, 0, 4194303, 581, 0, 0, 32, 0, 0, 0),
    (25774, 'fancy_gilet', 35, 0, 4194303, 447, 0, 0, 32, 64, 0, 0),
    (25775, 'fancy_top', 40, 0, 4194303, 448, 0, 0, 32, 64, 0, 0),
    (25776, 'bl._chocobo_suit', 45, 0, 4194303, 449, 0, 0, 32, 448, 0, 0),
    (25838, 'fancy_trunks', 75, 0, 4194303, 447, 0, 0, 128, 256, 0, 0),
    (25839, 'fancy_shorts', 5, 0, 4194303, 448, 0, 0, 128, 256, 0, 0),
    (25850, 'pretty_pink_subligar', 60, 0, 4194303, 453, 0, 0, 128, 0, 0, 0),
    (25851, 'ashen_subligar', 65, 0, 4194303, 0, 0, 0, 128, 0, 0, 0),
    (25864, 'stinky_subligar', 55, 0, 2472947, 14, 0, 0, 128, 0, 0, 0),
    (25909, 'morbol_subligar', 55, 0, 4194303, 461, 0, 0, 128, 0, 0, 0),
    (25910, 'cait_sith_subligar', 60, 0, 4194303, 463, 0, 0, 128, 0, 0, 0),
    (26271, 'hi-elixir_tank', 20, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (26272, 'super_reraiser_tank', 25, 0, 4194303, 0, 0, 0, 32768, 0, 0, 0),
    (26330, 'wailing_belt', 5, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (26352, 'moogle_sacoche', 40, 0, 4194303, 0, 0, 0, 1024, 0, 0, 0),
    (26406, 'kupo_shield', 5, 0, 4194303, 56, 3, 0, 2, 0, 0, 0),
    (26415, '', 50, 0, 4194303, 0, 3, 0, 2, 0, 0, 0),
    (26416, '', 55, 0, 4194303, 0, 2, 0, 2, 0, 0, 0),
    (26426, 'joiners_shield', 30, 0, 4194303, 41, 3, 0, 2, 0, 0, 0),
    (26431, 'smythes_shield', 55, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26436, 'toreutic_shield', 5, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26441, 'plaiters_shield', 30, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26446, 'bevelers_shield', 55, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26451, 'ossifiers_shield', 5, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26456, 'brewers_shield', 30, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26461, 'chefs_shield', 55, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26465, 'joiners_shield_-1', 75, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26468, 'smythes_shield_-1', 15, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26471, 'toreutic_shield_-1', 30, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26474, 'plaiters_shield_-1', 45, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26477, 'bevelers_shield_-1', 60, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26480, 'ossifiers_shield_-1', 75, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26483, 'brewers_shield_-1', 15, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26486, 'chefs_shield_-1', 30, 0, 4194303, 25, 3, 0, 2, 0, 0, 0),
    (26516, 'citrullus_shirt', 70, 0, 4194303, 0, 0, 0, 32, 0, 0, 0),
    (26517, 'shadow_lord_shirt', 75, 0, 4194303, 588, 0, 0, 32, 0, 0, 0),
    (26519, 'mandragora_shirt', 10, 0, 4194303, 0, 0, 0, 32, 0, 0, 0),
    (26523, 'delegates_garb', 30, 0, 4194303, 441, 0, 0, 32, 0, 0, 0),
    (26546, 'moogle_shirt', 70, 0, 4194303, 0, 0, 0, 32, 0, 0, 0),
    (26693, 'morbol_cap', 45, 0, 4194303, 374, 0, 0, 16, 0, 0, 0),
    (26694, 'cassies_cap', 50, 0, 4194303, 374, 0, 0, 16, 0, 0, 0),
    (26704, 'lyco._masque_+1', 30, 0, 4194303, 377, 0, 0, 16, 0, 0, 0),
    (26705, 'mandra._masque', 30, 0, 4194303, 376, 0, 0, 16, 0, 0, 0),
    (26706, 'mandra._masque_+1', 40, 0, 4194303, 376, 0, 0, 16, 0, 0, 0),
    (26708, 'flan_masque_+1', 50, 0, 4194303, 378, 0, 0, 16, 0, 0, 0),
    (26717, 'cait_sith_cap', 15, 0, 4194303, 379, 0, 0, 16, 0, 0, 0),
    (26718, 'cait_sith_cap_+1', 25, 0, 4194303, 379, 0, 0, 16, 0, 0, 0),
    (26719, 'sheep_cap', 25, 0, 4194303, 383, 0, 0, 16, 0, 0, 0),
    (26720, 'sheep_cap_+1', 35, 0, 4194303, 383, 0, 0, 16, 0, 0, 0),
    (26728, 'frosty_cap', 70, 0, 4194303, 122, 0, 0, 16, 0, 0, 0),
    (26730, 'celeste_cap', 5, 0, 4194303, 155, 0, 0, 16, 0, 0, 0),
    (26738, 'leafkin_cap', 45, 0, 4194303, 385, 0, 0, 16, 0, 0, 0),
    (26739, 'leafkin_cap_+1', 55, 0, 4194303, 385, 0, 0, 16, 0, 0, 0),
    (26788, 'rabbit_cap', 70, 0, 4194303, 386, 0, 0, 16, 0, 0, 0),
    (26798, 'behemoth_masque', 45, 0, 4194303, 396, 0, 0, 16, 0, 0, 0),
    (26799, 'behe._masque_+1', 55, 0, 4194303, 396, 0, 0, 16, 0, 0, 0),
    (26954, 'behemoth_suit', 10, 0, 4194303, 396, 0, 0, 32, 128, 448, 0),
    (26955, 'behemoth_suit_+1', 20, 0, 4194303, 396, 0, 0, 32, 128, 448, 0),
    (26966, 'ta_moko_+1', 75, 0, 4194303, 404, 0, 0, 32, 64, 0, 0),
    (26967, 'cossie_top', 75, 0, 4194303, 405, 0, 0, 32, 64, 0, 0),
    (26968, 'cossie_top_+1', 10, 0, 4194303, 405, 0, 0, 32, 64, 0, 0),
    (27110, 'kachina_gloves', 50, 0, 4194303, 24, 0, 0, 64, 0, 0, 0),
    (27293, 'cossie_bottom', 75, 0, 4194303, 405, 0, 0, 128, 256, 0, 0),
    (27294, 'cossie_bottom_+1', 10, 0, 4194303, 405, 0, 0, 128, 256, 0, 0),
    (27625, 'morbol_shield', 25, 0, 4194303, 652, 2, 0, 2, 0, 0, 0),
    (27626, 'cassies_shield', 30, 0, 4194303, 652, 2, 0, 2, 0, 0, 0),
    (27631, 'cait_sith_guard', 55, 0, 4194303, 654, 1, 0, 2, 0, 0, 0),
    (27632, 'cait_sith_gua._+1', 65, 0, 4194303, 654, 1, 0, 2, 0, 0, 0),
    (27715, 'goblin_masque', 55, 0, 4194303, 372, 0, 0, 16, 0, 0, 0),
    (27716, 'g._moogle_masque', 60, 0, 4194303, 373, 0, 0, 16, 0, 0, 0),
    (27717, 'worm_masque', 65, 0, 4194303, 370, 0, 0, 16, 0, 0, 0),
    (27718, 'worm_masque_+1', 75, 0, 4194303, 370, 0, 0, 16, 0, 0, 0),
    (27726, 'she-slime_hat', 35, 0, 4194303, 368, 0, 0, 16, 0, 0, 0),
    (27727, 'metal_slime_hat', 40, 0, 4194303, 369, 0, 0, 16, 0, 0, 0),
    (27733, 'straw_hat', 70, 0, 4194303, 366, 0, 0, 16, 0, 0, 0),
    (27734, 'straw_hat', 75, 0, 4194303, 366, 0, 0, 16, 0, 0, 0),
    (27755, '', 30, 0, 4194303, 0, 0, 0, 16, 0, 0, 0),
    (27756, 'slime_cap', 35, 0, 4194303, 358, 0, 0, 16, 0, 0, 0),
    (27758, 'bomb_masque_+1', 50, 0, 4194303, 359, 0, 0, 16, 0, 0, 0),
    (27759, 'korrigan_beret', 50, 0, 4194303, 154, 0, 0, 16, 0, 0, 0),
    (27760, 'chocobo_masque_+1', 60, 0, 4194303, 353, 0, 0, 16, 0, 0, 0),
    (27765, 'chocobo_masque', 5, 0, 4194303, 353, 0, 0, 16, 0, 0, 0),
    (27803, 'rustic_maillot', 55, 0, 4194303, 358, 0, 0, 32, 64, 0, 0),
    (27804, 'shoal_maillot', 60, 0, 4194303, 359, 0, 0, 32, 64, 0, 0),
    (27805, 'rustic_maillot_+1', 70, 0, 4194303, 358, 0, 0, 32, 64, 0, 0),
    (27806, 'shoal_maillot_+1', 75, 0, 4194303, 359, 0, 0, 32, 64, 0, 0),
    (27854, 'mandra._suit', 10, 0, 4194303, 376, 0, 0, 32, 128, 448, 0),
    (27855, 'mandra._suit_+1', 20, 0, 4194303, 376, 0, 0, 32, 128, 448, 0),
    (27866, 'goblin_suit', 70, 0, 4194303, 372, 0, 0, 32, 320, 448, 0),
    (27867, 'g._moogle_suit', 75, 0, 4194303, 307, 0, 0, 32, 320, 448, 0),
    (27879, 'overalls', 60, 0, 4194303, 366, 0, 0, 32, 128, 0, 0),
    (27880, 'overalls', 65, 0, 4194303, 366, 0, 0, 32, 128, 0, 0),
    (27906, 'chocobo_suit_+1', 50, 0, 4194303, 353, 0, 0, 32, 320, 448, 0),
    (27911, 'chocobo_suit', 70, 0, 4194303, 353, 0, 0, 32, 320, 448, 0),
    (28086, 'rustic_trunks', 65, 0, 4194303, 0, 0, 0, 128, 256, 0, 0),
    (28087, 'shoal_trunks', 70, 0, 4194303, 0, 0, 0, 128, 256, 0, 0),
    (28302, 'thatch_boots', 30, 0, 4194303, 366, 0, 0, 256, 0, 0, 0),
    (28303, 'thatch_boots', 35, 0, 4194303, 366, 0, 0, 256, 0, 0, 0),
    (28510, 'm._slime_earring', 5, 0, 4194303, 0, 0, 0, 6144, 0, 0, 0),
    (28651, 'metal_slime_shield', 55, 0, 4194303, 650, 1, 0, 2, 0, 0, 0),
    (28652, 'hatchling_shield', 60, 0, 4194303, 651, 1, 0, 2, 0, 0, 0),
    (28653, 'mundus_shield', 65, 0, 4194303, 644, 1, 0, 2, 0, 0, 0),
    (28670, 'leafkin_shield', 75, 0, 4194303, 641, 1, 0, 2, 0, 0, 0);

-- Weapon damage/delay: safe novelty weapon bases only.
REPLACE INTO `item_weapon` VALUES
    (17031, 'shell_scepter', 11, 0, 0, 0, 0, 3, 1, 216, 113, 0),
    (17032, 'gobbie_gavel', 11, 0, 0, 0, 0, 3, 1, 216, 128, 0),
    (17074, 'chocobo_wand', 11, 0, 0, 0, 0, 3, 1, 216, 83, 0),
    (17345, 'flute', 42, 0, 0, 0, 0, 1, 1, 240, 0, 0),
    (17353, 'maple_harp', 41, 0, 0, 0, 0, 1, 1, 240, 0, 0),
    (17372, 'flute_+1', 42, 0, 0, 0, 0, 1, 1, 240, 0, 0),
    (17373, 'maple_harp_+1', 41, 0, 0, 0, 0, 1, 1, 240, 0, 0),
    (18102, 'pitchfork', 8, 0, 0, 0, 0, 1, 1, 340, 112, 0),
    (18103, 'pitchfork_+1', 8, 0, 0, 0, 0, 1, 1, 340, 162, 0),
    (18399, 'charm_wand', 11, 0, 0, 0, 0, 3, 1, 216, 158, 0),
    (18400, 'charm_wand_+1', 11, 0, 0, 0, 0, 3, 1, 180, 188, 0),
    (18401, 'moogle_rod', 11, 0, 0, 0, 0, 3, 1, 180, 188, 0),
    (18464, 'ark_tachi', 10, 0, 0, 0, 0, 2, 1, 360, 255, 0),
    (18545, 'ark_tabar', 5, 0, 0, 0, 0, 2, 1, 280, 37, 0),
    (18563, 'ark_scythe', 7, 0, 0, 0, 0, 2, 1, 390, 228, 0),
    (18842, 'nmd._moogle_rod', 11, 0, 0, 0, 0, 3, 1, 216, 53, 0),
    (18871, 'kitty_rod', 11, 0, 0, 0, 0, 3, 1, 216, 38, 0),
    (18880, 'maestros_baton', 11, 0, 0, 0, 0, 3, 1, 180, 173, 0),
    (18881, 'melomane_mallet', 11, 0, 0, 0, 0, 3, 1, 180, 188, 0),
    (18912, 'ark_saber', 3, 0, 0, 0, 0, 2, 1, 220, 30, 0),
    (18913, 'ark_sword', 3, 0, 0, 0, 0, 2, 1, 220, 50, 0),
    (20532, 'worm_feelers', 1, 0, 0, 0, 0, 4, 1, 160, 34, 0),
    (20533, 'worm_feelers_+1', 1, 0, 0, 0, 0, 4, 1, 160, 54, 0),
    (21074, 'kupo_rod', 11, 0, 0, 0, 0, 3, 1, 180, 233, 0),
    (21086, 'heartstopper', 11, 0, 0, 0, 0, 3, 1, 180, 188, 0),
    (21087, 'heartstopper_+1', 11, 0, 0, 0, 0, 3, 1, 180, 218, 0),
    (21153, 'malice_masher', 12, 0, 0, 0, 0, 3, 1, 330, 230, 0),
    (21154, 'malice_masher_+1', 12, 0, 0, 0, 0, 3, 1, 300, 270, 0),
    (21760, 'dispatcher_s_axe', 6, 0, 0, 0, 0, 2, 1, 420, 195, 0),
    (22003, 'arthro_s_scepter', 11, 0, 0, 0, 0, 3, 1, 180, 218, 0),
    (22004, 'soulflayers_wand', 11, 0, 0, 0, 0, 3, 1, 180, 233, 0),
    (22005, 'burrowers_wand', 11, 0, 0, 0, 0, 3, 1, 216, 23, 0),
    (22019, 'jingly_rod', 11, 0, 0, 0, 0, 3, 1, 180, 233, 0),
    (22020, 'jingly_rod_+1', 11, 0, 0, 0, 0, 3, 1, 216, 38, 0),
    (22043, 'apkallu_scepter', 11, 0, 0, 0, 0, 3, 1, 216, 143, 0),
    (22044, 'tengu_war_fan', 11, 0, 0, 0, 0, 3, 1, 216, 158, 0),
    (22047, 'korrigan_mallet', 11, 0, 0, 0, 0, 3, 1, 180, 203, 0),
    (22048, 'adenium_mallet', 11, 0, 0, 0, 0, 3, 1, 180, 218, 0),
    (22049, 'citrullus_mallet', 11, 0, 0, 0, 0, 3, 1, 180, 233, 0),
    (22051, 'lycopodium_mallet', 11, 0, 0, 0, 0, 3, 1, 216, 38, 0),
    (22069, 'hapy_staff', 12, 0, 0, 0, 0, 3, 1, 300, 250, 0),
    (22283, 'marvelous_cheer', 42, 0, 0, 0, 0, 1, 1, 240, 0, 0);

-- Runtime stats matching generated descriptions.
REPLACE INTO `item_mods` VALUES
    (10250, 1, 48),
    (10250, 8, 18),
    (10250, 9, 18),
    (10250, 12, 18),
    (10250, 13, 18),
    (10250, 23, 58),
    (10250, 25, 58),
    (10250, 28, 38),
    (10250, 161, -600),
    (10250, 369, 3),
    (10250, 384, 500),
    (10251, 1, 53),
    (10251, 8, 20),
    (10251, 9, 20),
    (10251, 12, 20),
    (10251, 13, 20),
    (10251, 23, 64),
    (10251, 25, 64),
    (10251, 28, 42),
    (10251, 161, -600),
    (10251, 369, 3),
    (10251, 384, 500),
    (10252, 1, 58),
    (10252, 8, 22),
    (10252, 9, 22),
    (10252, 12, 22),
    (10252, 13, 22),
    (10252, 23, 70),
    (10252, 25, 70),
    (10252, 28, 46),
    (10252, 161, -700),
    (10252, 369, 3),
    (10252, 384, 600),
    (10253, 1, 68),
    (10253, 8, 26),
    (10253, 9, 26),
    (10253, 12, 26),
    (10253, 13, 26),
    (10253, 23, 82),
    (10253, 25, 82),
    (10253, 28, 54),
    (10253, 161, -800),
    (10253, 369, 4),
    (10253, 384, 700),
    (10254, 1, 73),
    (10254, 8, 28),
    (10254, 9, 28),
    (10254, 12, 28),
    (10254, 13, 28),
    (10254, 23, 88),
    (10254, 25, 88),
    (10254, 28, 58),
    (10254, 161, -800),
    (10254, 369, 4),
    (10254, 384, 700),
    (10256, 1, 78),
    (10256, 8, 30),
    (10256, 9, 30),
    (10256, 12, 30),
    (10256, 13, 30),
    (10256, 23, 94),
    (10256, 25, 94),
    (10256, 28, 62),
    (10256, 161, -900),
    (10256, 369, 4),
    (10256, 384, 800),
    (10257, 1, 83),
    (10257, 8, 32),
    (10257, 9, 32),
    (10257, 12, 32),
    (10257, 13, 32),
    (10257, 23, 100),
    (10257, 25, 100),
    (10257, 28, 66),
    (10257, 161, -900),
    (10257, 369, 4),
    (10257, 384, 800),
    (10258, 1, 13),
    (10258, 8, 4),
    (10258, 9, 4),
    (10258, 12, 4),
    (10258, 13, 4),
    (10258, 23, 16),
    (10258, 25, 16),
    (10258, 28, 10),
    (10258, 161, -200),
    (10258, 369, 1),
    (10258, 384, 100),
    (10259, 1, 18),
    (10259, 8, 6),
    (10259, 9, 6),
    (10259, 12, 6),
    (10259, 13, 6),
    (10259, 23, 22),
    (10259, 25, 22),
    (10259, 28, 14),
    (10259, 161, -300),
    (10259, 369, 1),
    (10259, 384, 200),
    (10260, 1, 23),
    (10260, 8, 8),
    (10260, 9, 8),
    (10260, 12, 8),
    (10260, 13, 8),
    (10260, 23, 28),
    (10260, 25, 28),
    (10260, 28, 18),
    (10260, 161, -300),
    (10260, 369, 1),
    (10260, 384, 200),
    (10261, 1, 28),
    (10261, 8, 10),
    (10261, 9, 10),
    (10261, 12, 10),
    (10261, 13, 10),
    (10261, 23, 34),
    (10261, 25, 34),
    (10261, 28, 22),
    (10261, 161, -400),
    (10261, 369, 2),
    (10261, 384, 300),
    (10262, 1, 33),
    (10262, 8, 12),
    (10262, 9, 12),
    (10262, 12, 12),
    (10262, 13, 12),
    (10262, 23, 40),
    (10262, 25, 40),
    (10262, 28, 26),
    (10262, 161, -400),
    (10262, 369, 2),
    (10262, 384, 300),
    (10263, 1, 38),
    (10263, 8, 14),
    (10263, 9, 14),
    (10263, 12, 14),
    (10263, 13, 14),
    (10263, 23, 46),
    (10263, 25, 46),
    (10263, 28, 30),
    (10263, 161, -500),
    (10263, 369, 2),
    (10263, 384, 400),
    (10264, 1, 48),
    (10264, 8, 18),
    (10264, 9, 18),
    (10264, 12, 18),
    (10264, 13, 18),
    (10264, 23, 58),
    (10264, 25, 58),
    (10264, 28, 38),
    (10264, 161, -600),
    (10264, 369, 3),
    (10264, 384, 500),
    (10265, 1, 53),
    (10265, 8, 20),
    (10265, 9, 20),
    (10265, 12, 20),
    (10265, 13, 20),
    (10265, 23, 64),
    (10265, 25, 64),
    (10265, 28, 42),
    (10265, 161, -600),
    (10265, 369, 3),
    (10265, 384, 500),
    (10266, 1, 58),
    (10266, 8, 22),
    (10266, 9, 22),
    (10266, 12, 22),
    (10266, 13, 22),
    (10266, 23, 70),
    (10266, 25, 70),
    (10266, 28, 46),
    (10266, 161, -700),
    (10266, 369, 3),
    (10266, 384, 600),
    (10267, 1, 63),
    (10267, 8, 24),
    (10267, 9, 24),
    (10267, 12, 24),
    (10267, 13, 24),
    (10267, 23, 76),
    (10267, 25, 76),
    (10267, 28, 50),
    (10267, 161, -700),
    (10267, 369, 3),
    (10267, 384, 600),
    (10268, 1, 68),
    (10268, 8, 26),
    (10268, 9, 26),
    (10268, 12, 26),
    (10268, 13, 26),
    (10268, 23, 82),
    (10268, 25, 82),
    (10268, 28, 54),
    (10268, 161, -800),
    (10268, 369, 4),
    (10268, 384, 700),
    (10269, 1, 73),
    (10269, 8, 28),
    (10269, 9, 28),
    (10269, 12, 28),
    (10269, 13, 28),
    (10269, 23, 88),
    (10269, 25, 88),
    (10269, 28, 58),
    (10269, 161, -800),
    (10269, 369, 4),
    (10269, 384, 700),
    (10270, 1, 78),
    (10270, 8, 30),
    (10270, 9, 30),
    (10270, 12, 30),
    (10270, 13, 30),
    (10270, 23, 94),
    (10270, 25, 94),
    (10270, 28, 62),
    (10270, 161, -900),
    (10270, 369, 4),
    (10270, 384, 800),
    (10271, 1, 83),
    (10271, 8, 32),
    (10271, 9, 32),
    (10271, 12, 32),
    (10271, 13, 32),
    (10271, 23, 100),
    (10271, 25, 100),
    (10271, 28, 66),
    (10271, 161, -900),
    (10271, 369, 4),
    (10271, 384, 800),
    (10293, 1, 38),
    (10293, 8, 14),
    (10293, 9, 14),
    (10293, 12, 14),
    (10293, 13, 14),
    (10293, 23, 46),
    (10293, 25, 46),
    (10293, 28, 30),
    (10293, 161, -500),
    (10293, 369, 2),
    (10293, 384, 400),
    (10330, 1, 13),
    (10330, 8, 6),
    (10330, 11, 6),
    (10330, 68, 18),
    (10330, 73, 7),
    (10330, 170, 2),
    (10330, 384, 200),
    (10331, 1, 17),
    (10331, 8, 8),
    (10331, 11, 8),
    (10331, 68, 23),
    (10331, 73, 9),
    (10331, 170, 2),
    (10331, 384, 200),
    (10332, 1, 21),
    (10332, 8, 10),
    (10332, 11, 10),
    (10332, 68, 28),
    (10332, 73, 11),
    (10332, 170, 3),
    (10332, 384, 300),
    (10333, 1, 25),
    (10333, 8, 12),
    (10333, 11, 12),
    (10333, 68, 33),
    (10333, 73, 13),
    (10333, 170, 3),
    (10333, 384, 300),
    (10334, 1, 29),
    (10334, 8, 14),
    (10334, 11, 14),
    (10334, 68, 38),
    (10334, 73, 15),
    (10334, 170, 4),
    (10334, 384, 400),
    (10335, 1, 33),
    (10335, 8, 16),
    (10335, 11, 16),
    (10335, 68, 43),
    (10335, 73, 17),
    (10335, 170, 4),
    (10335, 384, 400),
    (10336, 1, 37),
    (10336, 8, 18),
    (10336, 11, 18),
    (10336, 68, 48),
    (10336, 73, 19),
    (10336, 170, 5),
    (10336, 384, 500),
    (10337, 1, 41),
    (10337, 8, 20),
    (10337, 11, 20),
    (10337, 68, 53),
    (10337, 73, 21),
    (10337, 170, 5),
    (10337, 384, 500),
    (10382, 1, 24),
    (10382, 9, 17),
    (10382, 12, 17),
    (10382, 25, 52),
    (10382, 30, 52),
    (10382, 288, 9),
    (10382, 384, 400),
    (10383, 1, 30),
    (10383, 9, 21),
    (10383, 12, 21),
    (10383, 25, 64),
    (10383, 30, 64),
    (10383, 288, 11),
    (10383, 384, 500),
    (10384, 1, 19),
    (10384, 9, 12),
    (10384, 12, 12),
    (10384, 13, 12),
    (10384, 14, 12),
    (10384, 25, 33),
    (10384, 30, 33),
    (10384, 170, 3),
    (10384, 384, 200),
    (10385, 1, 25),
    (10385, 9, 16),
    (10385, 12, 16),
    (10385, 13, 16),
    (10385, 14, 16),
    (10385, 25, 43),
    (10385, 30, 43),
    (10385, 170, 4),
    (10385, 384, 300),
    (10429, 1, 19),
    (10429, 9, 12),
    (10429, 12, 12),
    (10429, 13, 12),
    (10429, 14, 12),
    (10429, 25, 33),
    (10429, 30, 33),
    (10429, 170, 3),
    (10429, 384, 200),
    (10430, 1, 22),
    (10430, 9, 14),
    (10430, 12, 14),
    (10430, 13, 14),
    (10430, 14, 14),
    (10430, 25, 38),
    (10430, 30, 38),
    (10430, 170, 4),
    (10430, 384, 300),
    (10431, 1, 25),
    (10431, 9, 16),
    (10431, 12, 16),
    (10431, 13, 16),
    (10431, 14, 16),
    (10431, 25, 43),
    (10431, 30, 43),
    (10431, 170, 4),
    (10431, 384, 300),
    (10432, 1, 31),
    (10432, 9, 20),
    (10432, 12, 20),
    (10432, 13, 20),
    (10432, 14, 20),
    (10432, 25, 53),
    (10432, 30, 53),
    (10432, 170, 5),
    (10432, 384, 400),
    (10433, 1, 34),
    (10433, 9, 22),
    (10433, 12, 22),
    (10433, 13, 22),
    (10433, 14, 22),
    (10433, 25, 58),
    (10433, 30, 58),
    (10433, 170, 6),
    (10433, 384, 400),
    (10446, 1, 25),
    (10446, 9, 16),
    (10446, 12, 16),
    (10446, 13, 16),
    (10446, 14, 16),
    (10446, 25, 43),
    (10446, 30, 43),
    (10446, 170, 4),
    (10446, 384, 300),
    (10593, 1, 45),
    (10593, 8, 22),
    (10593, 11, 22),
    (10593, 68, 58),
    (10593, 73, 23),
    (10593, 170, 6),
    (10593, 384, 600),
    (10594, 1, 49),
    (10594, 8, 24),
    (10594, 11, 24),
    (10594, 68, 63),
    (10594, 73, 25),
    (10594, 170, 6),
    (10594, 384, 600),
    (10595, 1, 57),
    (10595, 8, 28),
    (10595, 11, 28),
    (10595, 68, 73),
    (10595, 73, 29),
    (10595, 170, 7),
    (10595, 384, 700),
    (10596, 1, 61),
    (10596, 8, 30),
    (10596, 11, 30),
    (10596, 68, 78),
    (10596, 73, 31),
    (10596, 170, 8),
    (10596, 384, 700),
    (10808, 1, 20),
    (10808, 10, 8),
    (10808, 13, 8),
    (10808, 109, 20),
    (10808, 161, -300),
    (10808, 369, 1),
    (10808, 384, 200),
    (10809, 1, 25),
    (10809, 10, 10),
    (10809, 13, 10),
    (10809, 109, 25),
    (10809, 161, -400),
    (10809, 369, 1),
    (10809, 384, 200),
    (10810, 1, 35),
    (10810, 10, 14),
    (10810, 13, 14),
    (10810, 109, 35),
    (10810, 161, -500),
    (10810, 369, 2),
    (10810, 384, 300),
    (10811, 1, 35),
    (10811, 10, 14),
    (10811, 13, 14),
    (10811, 109, 35),
    (10811, 161, -500),
    (10811, 369, 2),
    (10811, 384, 300),
    (10812, 1, 45),
    (10812, 10, 18),
    (10812, 13, 18),
    (10812, 109, 45),
    (10812, 161, -600),
    (10812, 369, 2),
    (10812, 384, 300),
    (10847, 8, 28),
    (10847, 9, 28),
    (10847, 12, 28),
    (10847, 13, 28),
    (10847, 28, 57),
    (10847, 73, 29),
    (10847, 384, 800),
    (10848, 8, 30),
    (10848, 9, 30),
    (10848, 12, 30),
    (10848, 13, 30),
    (10848, 28, 61),
    (10848, 73, 31),
    (10848, 384, 900),
    (10849, 8, 32),
    (10849, 9, 32),
    (10849, 12, 32),
    (10849, 13, 32),
    (10849, 28, 65),
    (10849, 73, 33),
    (10849, 384, 900),
    (10850, 8, 4),
    (10850, 9, 4),
    (10850, 12, 4),
    (10850, 13, 4),
    (10850, 28, 9),
    (10850, 73, 5),
    (10850, 384, 200),
    (10851, 8, 6),
    (10851, 9, 6),
    (10851, 12, 6),
    (10851, 13, 6),
    (10851, 28, 13),
    (10851, 73, 7),
    (10851, 384, 300),
    (10852, 8, 8),
    (10852, 9, 8),
    (10852, 12, 8),
    (10852, 13, 8),
    (10852, 28, 17),
    (10852, 73, 9),
    (10852, 384, 300),
    (10875, 1, 7),
    (10875, 9, 4),
    (10875, 12, 4),
    (10875, 13, 4),
    (10875, 14, 4),
    (10875, 25, 13),
    (10875, 30, 13),
    (10875, 170, 1),
    (10875, 384, 100),
    (11002, 1, 17),
    (11002, 2, 60),
    (11002, 5, 60),
    (11002, 23, 38),
    (11002, 28, 38),
    (11002, 161, -400),
    (11002, 369, 2),
    (11265, 1, 23),
    (11265, 8, 8),
    (11265, 9, 8),
    (11265, 12, 8),
    (11265, 13, 8),
    (11265, 23, 28),
    (11265, 25, 28),
    (11265, 28, 18),
    (11265, 161, -300),
    (11265, 369, 1),
    (11265, 384, 200),
    (11266, 1, 28),
    (11266, 8, 10),
    (11266, 9, 10),
    (11266, 12, 10),
    (11266, 13, 10),
    (11266, 23, 34),
    (11266, 25, 34),
    (11266, 28, 22),
    (11266, 161, -400),
    (11266, 369, 2),
    (11266, 384, 300),
    (11267, 1, 33),
    (11267, 8, 12),
    (11267, 9, 12),
    (11267, 12, 12),
    (11267, 13, 12),
    (11267, 23, 40),
    (11267, 25, 40),
    (11267, 28, 26),
    (11267, 161, -400),
    (11267, 369, 2),
    (11267, 384, 300),
    (11268, 1, 38),
    (11268, 8, 14),
    (11268, 9, 14),
    (11268, 12, 14),
    (11268, 13, 14),
    (11268, 23, 46),
    (11268, 25, 46),
    (11268, 28, 30),
    (11268, 161, -500),
    (11268, 369, 2),
    (11268, 384, 400),
    (11269, 1, 43),
    (11269, 8, 16),
    (11269, 9, 16),
    (11269, 12, 16),
    (11269, 13, 16),
    (11269, 23, 52),
    (11269, 25, 52),
    (11269, 28, 34),
    (11269, 161, -500),
    (11269, 369, 2),
    (11269, 384, 400),
    (11270, 1, 48),
    (11270, 8, 18),
    (11270, 9, 18),
    (11270, 12, 18),
    (11270, 13, 18),
    (11270, 23, 58),
    (11270, 25, 58),
    (11270, 28, 38),
    (11270, 161, -600),
    (11270, 369, 3),
    (11270, 384, 500),
    (11271, 1, 53),
    (11271, 8, 20),
    (11271, 9, 20),
    (11271, 12, 20),
    (11271, 13, 20),
    (11271, 23, 64),
    (11271, 25, 64),
    (11271, 28, 42),
    (11271, 161, -600),
    (11271, 369, 3),
    (11271, 384, 500),
    (11272, 1, 58),
    (11272, 8, 22),
    (11272, 9, 22),
    (11272, 12, 22),
    (11272, 13, 22),
    (11272, 23, 70),
    (11272, 25, 70),
    (11272, 28, 46),
    (11272, 161, -700),
    (11272, 369, 3),
    (11272, 384, 600),
    (11273, 1, 68),
    (11273, 8, 26),
    (11273, 9, 26),
    (11273, 12, 26),
    (11273, 13, 26),
    (11273, 23, 82),
    (11273, 25, 82),
    (11273, 28, 54),
    (11273, 161, -800),
    (11273, 369, 4),
    (11273, 384, 700),
    (11274, 1, 73),
    (11274, 8, 28),
    (11274, 9, 28),
    (11274, 12, 28),
    (11274, 13, 28),
    (11274, 23, 88),
    (11274, 25, 88),
    (11274, 28, 58),
    (11274, 161, -800),
    (11274, 369, 4),
    (11274, 384, 700),
    (11275, 1, 78),
    (11275, 8, 30),
    (11275, 9, 30),
    (11275, 12, 30),
    (11275, 13, 30),
    (11275, 23, 94),
    (11275, 25, 94),
    (11275, 28, 62),
    (11275, 161, -900),
    (11275, 369, 4),
    (11275, 384, 800),
    (11276, 1, 83),
    (11276, 8, 32),
    (11276, 9, 32),
    (11276, 12, 32),
    (11276, 13, 32),
    (11276, 23, 100),
    (11276, 25, 100),
    (11276, 28, 66),
    (11276, 161, -900),
    (11276, 369, 4),
    (11276, 384, 800),
    (11277, 1, 83),
    (11277, 8, 32),
    (11277, 9, 32),
    (11277, 12, 32),
    (11277, 13, 32),
    (11277, 23, 100),
    (11277, 25, 100),
    (11277, 28, 66),
    (11277, 161, -900),
    (11277, 369, 4),
    (11277, 384, 800),
    (11278, 1, 18),
    (11278, 8, 6),
    (11278, 9, 6),
    (11278, 12, 6),
    (11278, 13, 6),
    (11278, 23, 22),
    (11278, 25, 22),
    (11278, 28, 14),
    (11278, 161, -300),
    (11278, 369, 1),
    (11278, 384, 200),
    (11279, 1, 23),
    (11279, 8, 8),
    (11279, 9, 8),
    (11279, 12, 8),
    (11279, 13, 8),
    (11279, 23, 28),
    (11279, 25, 28),
    (11279, 28, 18),
    (11279, 161, -300),
    (11279, 369, 1),
    (11279, 384, 200),
    (11280, 1, 28),
    (11280, 8, 10),
    (11280, 9, 10),
    (11280, 12, 10),
    (11280, 13, 10),
    (11280, 23, 34),
    (11280, 25, 34),
    (11280, 28, 22),
    (11280, 161, -400),
    (11280, 369, 2),
    (11280, 384, 300),
    (11316, 1, 53),
    (11316, 8, 20),
    (11316, 9, 20),
    (11316, 12, 20),
    (11316, 13, 20),
    (11316, 23, 64),
    (11316, 25, 64),
    (11316, 28, 42),
    (11316, 161, -600),
    (11316, 369, 3),
    (11316, 384, 500),
    (11317, 1, 58),
    (11317, 8, 22),
    (11317, 9, 22),
    (11317, 12, 22),
    (11317, 13, 22),
    (11317, 23, 70),
    (11317, 25, 70),
    (11317, 28, 46),
    (11317, 161, -700),
    (11317, 369, 3),
    (11317, 384, 600),
    (11318, 1, 63),
    (11318, 8, 24),
    (11318, 9, 24),
    (11318, 12, 24),
    (11318, 13, 24),
    (11318, 23, 76),
    (11318, 25, 76),
    (11318, 28, 50),
    (11318, 161, -700),
    (11318, 369, 3),
    (11318, 384, 600),
    (11319, 1, 68),
    (11319, 8, 26),
    (11319, 9, 26),
    (11319, 12, 26),
    (11319, 13, 26),
    (11319, 23, 82),
    (11319, 25, 82),
    (11319, 28, 54),
    (11319, 161, -800),
    (11319, 369, 4),
    (11319, 384, 700),
    (11320, 1, 73),
    (11320, 8, 28),
    (11320, 9, 28),
    (11320, 12, 28),
    (11320, 13, 28),
    (11320, 23, 88),
    (11320, 25, 88),
    (11320, 28, 58),
    (11320, 161, -800),
    (11320, 369, 4),
    (11320, 384, 700),
    (11321, 1, 78),
    (11321, 8, 30),
    (11321, 9, 30),
    (11321, 12, 30),
    (11321, 13, 30),
    (11321, 23, 94),
    (11321, 25, 94),
    (11321, 28, 62),
    (11321, 161, -900),
    (11321, 369, 4),
    (11321, 384, 800),
    (11322, 1, 83),
    (11322, 8, 32),
    (11322, 9, 32),
    (11322, 12, 32),
    (11322, 13, 32),
    (11322, 23, 100),
    (11322, 25, 100),
    (11322, 28, 66),
    (11322, 161, -900),
    (11322, 369, 4),
    (11322, 384, 800),
    (11323, 1, 13),
    (11323, 8, 4),
    (11323, 9, 4),
    (11323, 12, 4),
    (11323, 13, 4),
    (11323, 23, 16),
    (11323, 25, 16),
    (11323, 28, 10),
    (11323, 161, -200),
    (11323, 369, 1),
    (11323, 384, 100),
    (11324, 1, 18),
    (11324, 8, 6),
    (11324, 9, 6),
    (11324, 12, 6),
    (11324, 13, 6),
    (11324, 23, 22),
    (11324, 25, 22),
    (11324, 28, 14),
    (11324, 161, -300),
    (11324, 369, 1),
    (11324, 384, 200),
    (11325, 1, 23),
    (11325, 8, 8),
    (11325, 9, 8),
    (11325, 12, 8),
    (11325, 13, 8),
    (11325, 23, 28),
    (11325, 25, 28),
    (11325, 28, 18),
    (11325, 161, -300),
    (11325, 369, 1),
    (11325, 384, 200),
    (11326, 1, 28),
    (11326, 8, 10),
    (11326, 9, 10),
    (11326, 12, 10),
    (11326, 13, 10),
    (11326, 23, 34),
    (11326, 25, 34),
    (11326, 28, 22),
    (11326, 161, -400),
    (11326, 369, 2),
    (11326, 384, 300),
    (11327, 1, 33),
    (11327, 8, 12),
    (11327, 9, 12),
    (11327, 12, 12),
    (11327, 13, 12),
    (11327, 23, 40),
    (11327, 25, 40),
    (11327, 28, 26),
    (11327, 161, -400),
    (11327, 369, 2),
    (11327, 384, 300),
    (11328, 1, 38),
    (11328, 8, 14),
    (11328, 9, 14),
    (11328, 12, 14),
    (11328, 13, 14),
    (11328, 23, 46),
    (11328, 25, 46),
    (11328, 28, 30),
    (11328, 161, -500),
    (11328, 369, 2),
    (11328, 384, 400),
    (11490, 1, 7),
    (11490, 9, 4),
    (11490, 12, 4),
    (11490, 13, 4),
    (11490, 14, 4),
    (11490, 25, 13),
    (11490, 30, 13),
    (11490, 170, 1),
    (11490, 384, 100),
    (11491, 1, 13),
    (11491, 9, 8),
    (11491, 12, 8),
    (11491, 13, 8),
    (11491, 14, 8),
    (11491, 25, 23),
    (11491, 30, 23),
    (11491, 170, 2),
    (11491, 384, 200),
    (11500, 1, 37),
    (11500, 9, 24),
    (11500, 12, 24),
    (11500, 13, 24),
    (11500, 14, 24),
    (11500, 25, 63),
    (11500, 30, 63),
    (11500, 170, 6),
    (11500, 384, 400),
    (11811, 1, 25),
    (11811, 9, 16),
    (11811, 12, 16),
    (11811, 13, 16),
    (11811, 14, 16),
    (11811, 25, 43),
    (11811, 30, 43),
    (11811, 170, 4),
    (11811, 384, 300),
    (11812, 1, 28),
    (11812, 9, 18),
    (11812, 12, 18),
    (11812, 13, 18),
    (11812, 14, 18),
    (11812, 25, 48),
    (11812, 30, 48),
    (11812, 170, 5),
    (11812, 384, 300),
    (11861, 1, 78),
    (11861, 8, 30),
    (11861, 9, 30),
    (11861, 12, 30),
    (11861, 13, 30),
    (11861, 23, 94),
    (11861, 25, 94),
    (11861, 28, 62),
    (11861, 161, -900),
    (11861, 369, 4),
    (11861, 384, 800),
    (11862, 1, 83),
    (11862, 8, 32),
    (11862, 9, 32),
    (11862, 12, 32),
    (11862, 13, 32),
    (11862, 23, 100),
    (11862, 25, 100),
    (11862, 28, 66),
    (11862, 161, -900),
    (11862, 369, 4),
    (11862, 384, 800),
    (11965, 1, 13),
    (11965, 8, 6),
    (11965, 11, 6),
    (11965, 68, 18),
    (11965, 73, 7),
    (11965, 170, 2),
    (11965, 384, 200),
    (11966, 1, 21),
    (11966, 8, 10),
    (11966, 11, 10),
    (11966, 68, 28),
    (11966, 73, 11),
    (11966, 170, 3),
    (11966, 384, 300),
    (11967, 1, 21),
    (11967, 8, 10),
    (11967, 11, 10),
    (11967, 68, 28),
    (11967, 73, 11),
    (11967, 170, 3),
    (11967, 384, 300),
    (11968, 1, 29),
    (11968, 8, 14),
    (11968, 11, 14),
    (11968, 68, 38),
    (11968, 73, 15),
    (11968, 170, 4),
    (11968, 384, 400),
    (12491, 1, 40),
    (12491, 9, 26),
    (12491, 12, 26),
    (12491, 13, 26),
    (12491, 14, 26),
    (12491, 25, 68),
    (12491, 30, 68),
    (12491, 170, 7),
    (12491, 384, 500),
    (12619, 1, 43),
    (12619, 8, 16),
    (12619, 9, 16),
    (12619, 12, 16),
    (12619, 13, 16),
    (12619, 23, 52),
    (12619, 25, 52),
    (12619, 28, 34),
    (12619, 161, -500),
    (12619, 369, 2),
    (12619, 384, 400),
    (12951, 1, 48),
    (12951, 9, 33),
    (12951, 11, 33),
    (12951, 68, 100),
    (12951, 76, 10),
    (12951, 384, 700),
    (12960, 1, 30),
    (12960, 9, 21),
    (12960, 11, 21),
    (12960, 68, 64),
    (12960, 76, 7),
    (12960, 384, 500),
    (13121, 8, 32),
    (13121, 9, 32),
    (13121, 12, 32),
    (13121, 13, 32),
    (13121, 14, 32),
    (13121, 25, 83),
    (13121, 30, 83),
    (13121, 73, 17),
    (13121, 170, 6),
    (13122, 8, 4),
    (13122, 9, 4),
    (13122, 12, 4),
    (13122, 13, 4),
    (13122, 14, 4),
    (13122, 25, 13),
    (13122, 30, 13),
    (13122, 73, 3),
    (13122, 170, 1),
    (13517, 8, 22),
    (13517, 9, 22),
    (13517, 12, 22),
    (13517, 13, 22),
    (13517, 25, 58),
    (13517, 30, 58),
    (13517, 161, -400),
    (13517, 369, 2),
    (13682, 1, 47),
    (13682, 2, 160),
    (13682, 5, 160),
    (13682, 23, 98),
    (13682, 28, 98),
    (13682, 161, -900),
    (13682, 369, 4),
    (13683, 1, 5),
    (13683, 2, 20),
    (13683, 5, 20),
    (13683, 23, 14),
    (13683, 28, 14),
    (13683, 161, -200),
    (13683, 369, 1),
    (13684, 1, 8),
    (13684, 2, 30),
    (13684, 5, 30),
    (13684, 23, 20),
    (13684, 28, 20),
    (13684, 161, -300),
    (13684, 369, 1),
    (13810, 1, 73),
    (13810, 8, 28),
    (13810, 9, 28),
    (13810, 12, 28),
    (13810, 13, 28),
    (13810, 23, 88),
    (13810, 25, 88),
    (13810, 28, 58),
    (13810, 161, -800),
    (13810, 369, 4),
    (13810, 384, 700),
    (13819, 1, 43),
    (13819, 8, 16),
    (13819, 9, 16),
    (13819, 12, 16),
    (13819, 13, 16),
    (13819, 23, 52),
    (13819, 25, 52),
    (13819, 28, 34),
    (13819, 161, -500),
    (13819, 369, 2),
    (13819, 384, 400),
    (13820, 1, 48),
    (13820, 8, 18),
    (13820, 9, 18),
    (13820, 12, 18),
    (13820, 13, 18),
    (13820, 23, 58),
    (13820, 25, 58),
    (13820, 28, 38),
    (13820, 161, -600),
    (13820, 369, 3),
    (13820, 384, 500),
    (13821, 1, 53),
    (13821, 8, 20),
    (13821, 9, 20),
    (13821, 12, 20),
    (13821, 13, 20),
    (13821, 23, 64),
    (13821, 25, 64),
    (13821, 28, 42),
    (13821, 161, -600),
    (13821, 369, 3),
    (13821, 384, 500),
    (13822, 1, 58),
    (13822, 8, 22),
    (13822, 9, 22),
    (13822, 12, 22),
    (13822, 13, 22),
    (13822, 23, 70),
    (13822, 25, 70),
    (13822, 28, 46),
    (13822, 161, -700),
    (13822, 369, 3),
    (13822, 384, 600),
    (13842, 1, 43),
    (13842, 9, 28),
    (13842, 12, 28),
    (13842, 13, 28),
    (13842, 14, 28),
    (13842, 25, 73),
    (13842, 30, 73),
    (13842, 170, 7),
    (13842, 384, 500),
    (14070, 1, 18),
    (14070, 9, 13),
    (14070, 12, 13),
    (14070, 25, 40),
    (14070, 30, 40),
    (14070, 288, 7),
    (14070, 384, 300),
    (14072, 1, 24),
    (14072, 9, 17),
    (14072, 12, 17),
    (14072, 25, 52),
    (14072, 30, 52),
    (14072, 288, 9),
    (14072, 384, 400),
    (14117, 1, 36),
    (14117, 9, 25),
    (14117, 11, 25),
    (14117, 68, 76),
    (14117, 76, 8),
    (14117, 384, 600),
    (14171, 1, 18),
    (14171, 9, 13),
    (14171, 11, 13),
    (14171, 68, 40),
    (14171, 76, 5),
    (14171, 384, 300),
    (14173, 1, 24),
    (14173, 9, 17),
    (14173, 11, 17),
    (14173, 68, 52),
    (14173, 76, 6),
    (14173, 384, 400),
    (14242, 1, 61),
    (14242, 8, 30),
    (14242, 11, 30),
    (14242, 68, 78),
    (14242, 73, 31),
    (14242, 170, 8),
    (14242, 384, 700),
    (14292, 1, 21),
    (14292, 8, 10),
    (14292, 11, 10),
    (14292, 68, 28),
    (14292, 73, 11),
    (14292, 170, 3),
    (14292, 384, 300),
    (14294, 1, 29),
    (14294, 8, 14),
    (14294, 11, 14),
    (14294, 68, 38),
    (14294, 73, 15),
    (14294, 170, 4),
    (14294, 384, 400),
    (14519, 1, 18),
    (14519, 8, 6),
    (14519, 9, 6),
    (14519, 12, 6),
    (14519, 13, 6),
    (14519, 23, 22),
    (14519, 25, 22),
    (14519, 28, 14),
    (14519, 161, -300),
    (14519, 369, 1),
    (14519, 384, 200),
    (14520, 1, 28),
    (14520, 8, 10),
    (14520, 9, 10),
    (14520, 12, 10),
    (14520, 13, 10),
    (14520, 23, 34),
    (14520, 25, 34),
    (14520, 28, 22),
    (14520, 161, -400),
    (14520, 369, 2),
    (14520, 384, 300),
    (14532, 1, 83),
    (14532, 8, 32),
    (14532, 9, 32),
    (14532, 12, 32),
    (14532, 13, 32),
    (14532, 23, 100),
    (14532, 25, 100),
    (14532, 28, 66),
    (14532, 161, -900),
    (14532, 369, 4),
    (14532, 384, 800),
    (14533, 1, 13),
    (14533, 8, 4),
    (14533, 9, 4),
    (14533, 12, 4),
    (14533, 13, 4),
    (14533, 23, 16),
    (14533, 25, 16),
    (14533, 28, 10),
    (14533, 161, -200),
    (14533, 369, 1),
    (14533, 384, 100),
    (14534, 1, 18),
    (14534, 8, 6),
    (14534, 9, 6),
    (14534, 12, 6),
    (14534, 13, 6),
    (14534, 23, 22),
    (14534, 25, 22),
    (14534, 28, 14),
    (14534, 161, -300),
    (14534, 369, 1),
    (14534, 384, 200),
    (14535, 1, 23),
    (14535, 8, 8),
    (14535, 9, 8),
    (14535, 12, 8),
    (14535, 13, 8),
    (14535, 23, 28),
    (14535, 25, 28),
    (14535, 28, 18),
    (14535, 161, -300),
    (14535, 369, 1),
    (14535, 384, 200),
    (14628, 8, 24),
    (14628, 9, 24),
    (14628, 12, 24),
    (14628, 13, 24),
    (14628, 25, 63),
    (14628, 30, 63),
    (14628, 161, -400),
    (14628, 369, 2),
    (14629, 8, 26),
    (14629, 9, 26),
    (14629, 12, 26),
    (14629, 13, 26),
    (14629, 25, 68),
    (14629, 30, 68),
    (14629, 161, -500),
    (14629, 369, 3),
    (14647, 8, 32),
    (14647, 9, 32),
    (14647, 12, 32),
    (14647, 13, 32),
    (14647, 25, 83),
    (14647, 30, 83),
    (14647, 161, -600),
    (14647, 369, 3),
    (14648, 8, 4),
    (14648, 9, 4),
    (14648, 12, 4),
    (14648, 13, 4),
    (14648, 25, 13),
    (14648, 30, 13),
    (14648, 161, -100),
    (14648, 369, 1),
    (15178, 1, 46),
    (15178, 9, 30),
    (15178, 12, 30),
    (15178, 13, 30),
    (15178, 14, 30),
    (15178, 25, 78),
    (15178, 30, 78),
    (15178, 170, 8),
    (15178, 384, 500),
    (15179, 1, 49),
    (15179, 9, 32),
    (15179, 12, 32),
    (15179, 13, 32),
    (15179, 14, 32),
    (15179, 25, 83),
    (15179, 30, 83),
    (15179, 170, 8),
    (15179, 384, 600),
    (15204, 1, 34),
    (15204, 9, 22),
    (15204, 12, 22),
    (15204, 13, 22),
    (15204, 14, 22),
    (15204, 25, 58),
    (15204, 30, 58),
    (15204, 170, 6),
    (15204, 384, 400),
    (15212, 1, 13),
    (15212, 9, 8),
    (15212, 12, 8),
    (15212, 13, 8),
    (15212, 14, 8),
    (15212, 25, 23),
    (15212, 30, 23),
    (15212, 170, 2),
    (15212, 384, 200),
    (15288, 8, 30),
    (15288, 9, 30),
    (15288, 12, 30),
    (15288, 13, 30),
    (15288, 28, 61),
    (15288, 73, 31),
    (15288, 384, 900),
    (15289, 8, 32),
    (15289, 9, 32),
    (15289, 12, 32),
    (15289, 13, 32),
    (15289, 28, 65),
    (15289, 73, 33),
    (15289, 384, 900),
    (15297, 8, 18),
    (15297, 9, 18),
    (15297, 12, 18),
    (15297, 13, 18),
    (15297, 28, 37),
    (15297, 73, 19),
    (15297, 384, 600),
    (15298, 8, 20),
    (15298, 9, 20),
    (15298, 12, 20),
    (15298, 13, 20),
    (15298, 28, 41),
    (15298, 73, 21),
    (15298, 384, 600),
    (15299, 8, 22),
    (15299, 9, 22),
    (15299, 12, 22),
    (15299, 13, 22),
    (15299, 28, 45),
    (15299, 73, 23),
    (15299, 384, 700),
    (15444, 8, 12),
    (15444, 9, 12),
    (15444, 12, 12),
    (15444, 13, 12),
    (15444, 28, 25),
    (15444, 73, 13),
    (15444, 384, 400),
    (15446, 8, 16),
    (15446, 9, 16),
    (15446, 12, 16),
    (15446, 13, 16),
    (15446, 28, 33),
    (15446, 73, 17),
    (15446, 384, 500),
    (15447, 8, 18),
    (15447, 9, 18),
    (15447, 12, 18),
    (15447, 13, 18),
    (15447, 28, 37),
    (15447, 73, 19),
    (15447, 384, 600),
    (15448, 8, 20),
    (15448, 9, 20),
    (15448, 12, 20),
    (15448, 13, 20),
    (15448, 28, 41),
    (15448, 73, 21),
    (15448, 384, 600),
    (15450, 8, 24),
    (15450, 9, 24),
    (15450, 12, 24),
    (15450, 13, 24),
    (15450, 28, 49),
    (15450, 73, 25),
    (15450, 384, 700),
    (15451, 8, 26),
    (15451, 9, 26),
    (15451, 12, 26),
    (15451, 13, 26),
    (15451, 28, 53),
    (15451, 73, 27),
    (15451, 384, 800),
    (15452, 8, 28),
    (15452, 9, 28),
    (15452, 12, 28),
    (15452, 13, 28),
    (15452, 28, 57),
    (15452, 73, 29),
    (15452, 384, 800),
    (15453, 8, 30),
    (15453, 9, 30),
    (15453, 12, 30),
    (15453, 13, 30),
    (15453, 28, 61),
    (15453, 73, 31),
    (15453, 384, 900),
    (15454, 8, 32),
    (15454, 9, 32),
    (15454, 12, 32),
    (15454, 13, 32),
    (15454, 28, 65),
    (15454, 73, 33),
    (15454, 384, 900),
    (15752, 1, 36),
    (15752, 9, 25),
    (15752, 11, 25),
    (15752, 68, 76),
    (15752, 76, 8),
    (15752, 384, 600),
    (15753, 1, 42),
    (15753, 9, 29),
    (15753, 11, 29),
    (15753, 68, 88),
    (15753, 76, 9),
    (15753, 384, 700),
    (15847, 8, 32),
    (15847, 9, 32),
    (15847, 12, 32),
    (15847, 13, 32),
    (15847, 25, 83),
    (15847, 30, 83),
    (15847, 161, -600),
    (15847, 369, 3),
    (15848, 8, 4),
    (15848, 9, 4),
    (15848, 12, 4),
    (15848, 13, 4),
    (15848, 25, 13),
    (15848, 30, 13),
    (15848, 161, -100),
    (15848, 369, 1),
    (15860, 8, 4),
    (15860, 9, 4),
    (15860, 12, 4),
    (15860, 13, 4),
    (15860, 28, 9),
    (15860, 73, 5),
    (15860, 384, 200),
    (15919, 8, 32),
    (15919, 9, 32),
    (15919, 12, 32),
    (15919, 13, 32),
    (15919, 28, 65),
    (15919, 73, 33),
    (15919, 384, 900),
    (15921, 8, 6),
    (15921, 9, 6),
    (15921, 12, 6),
    (15921, 13, 6),
    (15921, 28, 13),
    (15921, 73, 7),
    (15921, 384, 300),
    (15929, 8, 22),
    (15929, 9, 22),
    (15929, 12, 22),
    (15929, 13, 22),
    (15929, 28, 45),
    (15929, 73, 23),
    (15929, 384, 700),
    (15933, 8, 30),
    (15933, 9, 30),
    (15933, 12, 30),
    (15933, 13, 30),
    (15933, 28, 61),
    (15933, 73, 31),
    (15933, 384, 900),
    (16003, 9, 10),
    (16003, 12, 10),
    (16003, 13, 10),
    (16003, 28, 21),
    (16003, 170, 2),
    (16003, 288, 6),
    (16075, 1, 37),
    (16075, 9, 24),
    (16075, 12, 24),
    (16075, 13, 24),
    (16075, 14, 24),
    (16075, 25, 63),
    (16075, 30, 63),
    (16075, 170, 6),
    (16075, 384, 400),
    (16109, 1, 49),
    (16109, 9, 32),
    (16109, 12, 32),
    (16109, 13, 32),
    (16109, 14, 32),
    (16109, 25, 83),
    (16109, 30, 83),
    (16109, 170, 8),
    (16109, 384, 600),
    (16118, 1, 31),
    (16118, 9, 20),
    (16118, 12, 20),
    (16118, 13, 20),
    (16118, 14, 20),
    (16118, 25, 53),
    (16118, 30, 53),
    (16118, 170, 5),
    (16118, 384, 400),
    (16119, 1, 34),
    (16119, 9, 22),
    (16119, 12, 22),
    (16119, 13, 22),
    (16119, 14, 22),
    (16119, 25, 58),
    (16119, 30, 58),
    (16119, 170, 6),
    (16119, 384, 400),
    (16223, 1, 20),
    (16223, 2, 70),
    (16223, 5, 70),
    (16223, 23, 44),
    (16223, 28, 44),
    (16223, 161, -500),
    (16223, 369, 2),
    (16224, 1, 23),
    (16224, 2, 80),
    (16224, 5, 80),
    (16224, 23, 50),
    (16224, 28, 50),
    (16224, 161, -500),
    (16224, 369, 2),
    (16225, 1, 26),
    (16225, 2, 90),
    (16225, 5, 90),
    (16225, 23, 56),
    (16225, 28, 56),
    (16225, 161, -600),
    (16225, 369, 2),
    (16226, 1, 29),
    (16226, 2, 100),
    (16226, 5, 100),
    (16226, 23, 62),
    (16226, 28, 62),
    (16226, 161, -600),
    (16226, 369, 2),
    (16227, 1, 32),
    (16227, 2, 110),
    (16227, 5, 110),
    (16227, 23, 68),
    (16227, 28, 68),
    (16227, 161, -700),
    (16227, 369, 3),
    (16243, 1, 35),
    (16243, 2, 120),
    (16243, 5, 120),
    (16243, 23, 74),
    (16243, 28, 74),
    (16243, 161, -700),
    (16243, 369, 3),
    (16249, 1, 8),
    (16249, 2, 30),
    (16249, 5, 30),
    (16249, 23, 20),
    (16249, 28, 20),
    (16249, 161, -300),
    (16249, 369, 1),
    (16257, 1, 32),
    (16257, 2, 110),
    (16257, 5, 110),
    (16257, 23, 68),
    (16257, 28, 68),
    (16257, 161, -700),
    (16257, 369, 3),
    (16273, 8, 6),
    (16273, 9, 6),
    (16273, 12, 6),
    (16273, 13, 6),
    (16273, 14, 6),
    (16273, 25, 18),
    (16273, 30, 18),
    (16273, 73, 4),
    (16273, 170, 1),
    (16323, 1, 45),
    (16323, 8, 22),
    (16323, 11, 22),
    (16323, 68, 58),
    (16323, 73, 23),
    (16323, 170, 6),
    (16323, 384, 600),
    (16324, 1, 49),
    (16324, 8, 24),
    (16324, 11, 24),
    (16324, 68, 63),
    (16324, 73, 25),
    (16324, 170, 6),
    (16324, 384, 600),
    (16325, 1, 53),
    (16325, 8, 26),
    (16325, 11, 26),
    (16325, 68, 68),
    (16325, 73, 27),
    (16325, 170, 7),
    (16325, 384, 700),
    (16326, 1, 57),
    (16326, 8, 28),
    (16326, 11, 28),
    (16326, 68, 73),
    (16326, 73, 29),
    (16326, 170, 7),
    (16326, 384, 700),
    (16327, 1, 61),
    (16327, 8, 30),
    (16327, 11, 30),
    (16327, 68, 78),
    (16327, 73, 31),
    (16327, 170, 8),
    (16327, 384, 700),
    (16328, 1, 65),
    (16328, 8, 32),
    (16328, 11, 32),
    (16328, 68, 83),
    (16328, 73, 33),
    (16328, 170, 8),
    (16328, 384, 700),
    (17031, 12, 18),
    (17031, 13, 18),
    (17031, 14, 10),
    (17031, 28, 43),
    (17031, 170, 5),
    (17031, 343, 35),
    (17031, 369, 2),
    (17032, 12, 20),
    (17032, 13, 20),
    (17032, 14, 11),
    (17032, 28, 48),
    (17032, 170, 6),
    (17032, 343, 40),
    (17032, 369, 2),
    (17074, 12, 14),
    (17074, 13, 14),
    (17074, 14, 8),
    (17074, 28, 33),
    (17074, 170, 4),
    (17074, 343, 25),
    (17074, 369, 2),
    (17345, 14, 29),
    (17345, 25, 58),
    (17345, 30, 58),
    (17345, 170, 3),
    (17345, 369, 2),
    (17345, 452, 5),
    (17345, 454, 42),
    (17353, 14, 14),
    (17353, 25, 28),
    (17353, 30, 28),
    (17353, 170, 2),
    (17353, 369, 1),
    (17353, 452, 2),
    (17353, 454, 22),
    (17372, 14, 23),
    (17372, 25, 46),
    (17372, 30, 46),
    (17372, 170, 3),
    (17372, 369, 2),
    (17372, 452, 4),
    (17372, 454, 34),
    (17373, 14, 32),
    (17373, 25, 64),
    (17373, 30, 64),
    (17373, 170, 4),
    (17373, 369, 2),
    (17373, 452, 6),
    (17373, 454, 46),
    (18102, 8, 17),
    (18102, 9, 13),
    (18102, 25, 34),
    (18102, 73, 12),
    (18102, 888, 25),
    (18103, 8, 23),
    (18103, 9, 17),
    (18103, 25, 46),
    (18103, 73, 16),
    (18103, 888, 25),
    (18399, 12, 24),
    (18399, 13, 24),
    (18399, 14, 13),
    (18399, 28, 58),
    (18399, 170, 7),
    (18399, 343, 50),
    (18399, 369, 3),
    (18400, 12, 28),
    (18400, 13, 28),
    (18400, 14, 15),
    (18400, 28, 68),
    (18400, 170, 8),
    (18400, 343, 60),
    (18400, 369, 3),
    (18401, 12, 28),
    (18401, 13, 28),
    (18401, 14, 15),
    (18401, 28, 68),
    (18401, 170, 8),
    (18401, 343, 60),
    (18401, 369, 3),
    (18464, 8, 29),
    (18464, 9, 29),
    (18464, 73, 29),
    (18464, 345, 800),
    (18464, 840, 42),
    (18545, 8, 8),
    (18545, 14, 8),
    (18545, 23, 32),
    (18545, 25, 16),
    (18545, 288, 4),
    (18545, 990, 32),
    (18545, 991, 16),
    (18563, 8, 30),
    (18563, 9, 23),
    (18563, 315, 100),
    (18563, 840, 40),
    (18842, 12, 10),
    (18842, 13, 10),
    (18842, 14, 6),
    (18842, 28, 23),
    (18842, 170, 3),
    (18842, 343, 15),
    (18842, 369, 1),
    (18871, 12, 8),
    (18871, 13, 8),
    (18871, 14, 5),
    (18871, 28, 18),
    (18871, 170, 3),
    (18871, 343, 10),
    (18871, 369, 1),
    (18880, 12, 26),
    (18880, 13, 26),
    (18880, 14, 14),
    (18880, 28, 63),
    (18880, 170, 7),
    (18880, 343, 55),
    (18880, 369, 3),
    (18881, 12, 28),
    (18881, 13, 28),
    (18881, 14, 15),
    (18881, 28, 68),
    (18881, 170, 8),
    (18881, 343, 60),
    (18881, 369, 3),
    (18912, 8, 8),
    (18912, 13, 7),
    (18912, 25, 16),
    (18912, 30, 14),
    (18912, 315, 100),
    (18912, 840, 14),
    (18913, 8, 11),
    (18913, 13, 9),
    (18913, 25, 22),
    (18913, 30, 18),
    (18913, 315, 100),
    (18913, 840, 18),
    (20532, 8, 13),
    (20532, 9, 13),
    (20532, 23, 28),
    (20532, 25, 28),
    (20532, 289, 11),
    (20532, 302, 6),
    (20533, 8, 19),
    (20533, 9, 19),
    (20533, 23, 40),
    (20533, 25, 40),
    (20533, 289, 15),
    (20533, 302, 8),
    (21074, 12, 34),
    (21074, 13, 34),
    (21074, 14, 18),
    (21074, 28, 83),
    (21074, 170, 9),
    (21074, 343, 75),
    (21074, 369, 4),
    (21086, 12, 28),
    (21086, 13, 28),
    (21086, 14, 15),
    (21086, 28, 68),
    (21086, 170, 8),
    (21086, 343, 60),
    (21086, 369, 3),
    (21087, 12, 32),
    (21087, 13, 32),
    (21087, 14, 17),
    (21087, 28, 78),
    (21087, 170, 9),
    (21087, 343, 70),
    (21087, 369, 3),
    (21153, 12, 39),
    (21153, 13, 39),
    (21153, 25, 76),
    (21153, 28, 76),
    (21153, 30, 76),
    (21153, 170, 7),
    (21153, 346, 3),
    (21154, 12, 45),
    (21154, 13, 45),
    (21154, 25, 88),
    (21154, 28, 88),
    (21154, 30, 88),
    (21154, 170, 8),
    (21154, 346, 4),
    (21760, 8, 28),
    (21760, 10, 20),
    (21760, 23, 70),
    (21760, 288, 10),
    (21760, 840, 40),
    (22003, 12, 32),
    (22003, 13, 32),
    (22003, 14, 17),
    (22003, 28, 78),
    (22003, 170, 9),
    (22003, 343, 70),
    (22003, 369, 3),
    (22004, 12, 34),
    (22004, 13, 34),
    (22004, 14, 18),
    (22004, 28, 83),
    (22004, 170, 9),
    (22004, 343, 75),
    (22004, 369, 4),
    (22005, 12, 6),
    (22005, 13, 6),
    (22005, 14, 4),
    (22005, 28, 13),
    (22005, 170, 2),
    (22005, 343, 10),
    (22005, 369, 1),
    (22019, 12, 34),
    (22019, 13, 34),
    (22019, 14, 18),
    (22019, 28, 83),
    (22019, 170, 9),
    (22019, 343, 75),
    (22019, 369, 4),
    (22020, 12, 8),
    (22020, 13, 8),
    (22020, 14, 5),
    (22020, 28, 18),
    (22020, 170, 3),
    (22020, 343, 10),
    (22020, 369, 1),
    (22043, 12, 22),
    (22043, 13, 22),
    (22043, 14, 12),
    (22043, 28, 53),
    (22043, 170, 6),
    (22043, 343, 45),
    (22043, 369, 2),
    (22044, 12, 24),
    (22044, 13, 24),
    (22044, 14, 13),
    (22044, 28, 58),
    (22044, 170, 7),
    (22044, 343, 50),
    (22044, 369, 3),
    (22047, 12, 30),
    (22047, 13, 30),
    (22047, 14, 16),
    (22047, 28, 73),
    (22047, 170, 8),
    (22047, 343, 65),
    (22047, 369, 3),
    (22048, 12, 32),
    (22048, 13, 32),
    (22048, 14, 17),
    (22048, 28, 78),
    (22048, 170, 9),
    (22048, 343, 70),
    (22048, 369, 3),
    (22049, 12, 34),
    (22049, 13, 34),
    (22049, 14, 18),
    (22049, 28, 83),
    (22049, 170, 9),
    (22049, 343, 75),
    (22049, 369, 4),
    (22051, 12, 8),
    (22051, 13, 8),
    (22051, 14, 5),
    (22051, 28, 18),
    (22051, 170, 3),
    (22051, 343, 10),
    (22051, 369, 1),
    (22069, 12, 42),
    (22069, 13, 42),
    (22069, 25, 82),
    (22069, 28, 82),
    (22069, 30, 82),
    (22069, 170, 8),
    (22069, 346, 4),
    (22283, 14, 38),
    (22283, 25, 76),
    (22283, 30, 76),
    (22283, 170, 4),
    (22283, 369, 3),
    (22283, 452, 7),
    (22283, 454, 54),
    (23730, 1, 7),
    (23730, 9, 4),
    (23730, 12, 4),
    (23730, 13, 4),
    (23730, 14, 4),
    (23730, 25, 13),
    (23730, 30, 13),
    (23730, 170, 1),
    (23730, 384, 100),
    (23731, 1, 10),
    (23731, 9, 6),
    (23731, 12, 6),
    (23731, 13, 6),
    (23731, 14, 6),
    (23731, 25, 18),
    (23731, 30, 18),
    (23731, 170, 2),
    (23731, 384, 100),
    (23737, 1, 28),
    (23737, 9, 18),
    (23737, 12, 18),
    (23737, 13, 18),
    (23737, 14, 18),
    (23737, 25, 48),
    (23737, 30, 48),
    (23737, 170, 5),
    (23737, 384, 300),
    (23790, 1, 7),
    (23790, 9, 4),
    (23790, 12, 4),
    (23790, 13, 4),
    (23790, 14, 4),
    (23790, 25, 13),
    (23790, 30, 13),
    (23790, 170, 1),
    (23790, 384, 100),
    (23791, 1, 28),
    (23791, 8, 10),
    (23791, 9, 10),
    (23791, 12, 10),
    (23791, 13, 10),
    (23791, 23, 34),
    (23791, 25, 34),
    (23791, 28, 22),
    (23791, 161, -400),
    (23791, 369, 2),
    (23791, 384, 300),
    (23805, 1, 23),
    (23805, 8, 8),
    (23805, 9, 8),
    (23805, 12, 8),
    (23805, 13, 8),
    (23805, 23, 28),
    (23805, 25, 28),
    (23805, 28, 18),
    (23805, 161, -300),
    (23805, 369, 1),
    (23805, 384, 200),
    (23806, 1, 10),
    (23806, 9, 6),
    (23806, 12, 6),
    (23806, 13, 6),
    (23806, 14, 6),
    (23806, 25, 18),
    (23806, 30, 18),
    (23806, 170, 2),
    (23806, 384, 100),
    (23807, 1, 13),
    (23807, 9, 8),
    (23807, 12, 8),
    (23807, 13, 8),
    (23807, 14, 8),
    (23807, 25, 23),
    (23807, 30, 23),
    (23807, 170, 2),
    (23807, 384, 200),
    (23809, 1, 49),
    (23809, 8, 24),
    (23809, 11, 24),
    (23809, 68, 63),
    (23809, 73, 25),
    (23809, 170, 6),
    (23809, 384, 600),
    (23810, 1, 22),
    (23810, 9, 14),
    (23810, 12, 14),
    (23810, 13, 14),
    (23810, 14, 14),
    (23810, 25, 38),
    (23810, 30, 38),
    (23810, 170, 4),
    (23810, 384, 300),
    (23816, 1, 18),
    (23816, 9, 13),
    (23816, 11, 13),
    (23816, 68, 40),
    (23816, 76, 5),
    (23816, 384, 300),
    (23819, 1, 15),
    (23819, 9, 11),
    (23819, 12, 11),
    (23819, 25, 34),
    (23819, 30, 34),
    (23819, 288, 6),
    (23819, 384, 300),
    (23833, 1, 13),
    (23833, 8, 4),
    (23833, 9, 4),
    (23833, 12, 4),
    (23833, 13, 4),
    (23833, 23, 16),
    (23833, 25, 16),
    (23833, 28, 10),
    (23833, 161, -200),
    (23833, 369, 1),
    (23833, 384, 100),
    (23848, 1, 12),
    (23848, 9, 9),
    (23848, 12, 9),
    (23848, 25, 28),
    (23848, 30, 28),
    (23848, 288, 5),
    (23848, 384, 200),
    (23862, 1, 43),
    (23862, 9, 28),
    (23862, 12, 28),
    (23862, 13, 28),
    (23862, 14, 28),
    (23862, 25, 73),
    (23862, 30, 73),
    (23862, 170, 7),
    (23862, 384, 500),
    (23863, 1, 13),
    (23863, 8, 4),
    (23863, 9, 4),
    (23863, 12, 4),
    (23863, 13, 4),
    (23863, 23, 16),
    (23863, 25, 16),
    (23863, 28, 10),
    (23863, 161, -200),
    (23863, 369, 1),
    (23863, 384, 100),
    (23864, 1, 49),
    (23864, 9, 32),
    (23864, 12, 32),
    (23864, 13, 32),
    (23864, 14, 32),
    (23864, 25, 83),
    (23864, 30, 83),
    (23864, 170, 8),
    (23864, 384, 600),
    (23865, 1, 23),
    (23865, 8, 8),
    (23865, 9, 8),
    (23865, 12, 8),
    (23865, 13, 8),
    (23865, 23, 28),
    (23865, 25, 28),
    (23865, 28, 18),
    (23865, 161, -300),
    (23865, 369, 1),
    (23865, 384, 200),
    (23870, 1, 22),
    (23870, 9, 14),
    (23870, 12, 14),
    (23870, 13, 14),
    (23870, 14, 14),
    (23870, 25, 38),
    (23870, 30, 38),
    (23870, 170, 4),
    (23870, 384, 300),
    (23871, 1, 53),
    (23871, 8, 20),
    (23871, 9, 20),
    (23871, 12, 20),
    (23871, 13, 20),
    (23871, 23, 64),
    (23871, 25, 64),
    (23871, 28, 42),
    (23871, 161, -600),
    (23871, 369, 3),
    (23871, 384, 500),
    (23872, 1, 61),
    (23872, 8, 30),
    (23872, 11, 30),
    (23872, 68, 78),
    (23872, 73, 31),
    (23872, 170, 8),
    (23872, 384, 700),
    (23873, 1, 63),
    (23873, 8, 24),
    (23873, 9, 24),
    (23873, 12, 24),
    (23873, 13, 24),
    (23873, 23, 76),
    (23873, 25, 76),
    (23873, 28, 50),
    (23873, 161, -700),
    (23873, 369, 3),
    (23873, 384, 600),
    (23874, 1, 9),
    (23874, 8, 4),
    (23874, 11, 4),
    (23874, 68, 13),
    (23874, 73, 5),
    (23874, 170, 1),
    (23874, 384, 100),
    (23893, 1, 25),
    (23893, 8, 12),
    (23893, 11, 12),
    (23893, 68, 33),
    (23893, 73, 13),
    (23893, 170, 3),
    (23893, 384, 300),
    (23894, 1, 27),
    (23894, 9, 19),
    (23894, 11, 19),
    (23894, 68, 58),
    (23894, 76, 7),
    (23894, 384, 500),
    (25585, 1, 37),
    (25585, 9, 24),
    (25585, 12, 24),
    (25585, 13, 24),
    (25585, 14, 24),
    (25585, 25, 63),
    (25585, 30, 63),
    (25585, 170, 6),
    (25585, 384, 400),
    (25586, 1, 40),
    (25586, 9, 26),
    (25586, 12, 26),
    (25586, 13, 26),
    (25586, 14, 26),
    (25586, 25, 68),
    (25586, 30, 68),
    (25586, 170, 7),
    (25586, 384, 500),
    (25587, 1, 46),
    (25587, 9, 30),
    (25587, 12, 30),
    (25587, 13, 30),
    (25587, 14, 30),
    (25587, 25, 78),
    (25587, 30, 78),
    (25587, 170, 8),
    (25587, 384, 500),
    (25604, 1, 49),
    (25604, 9, 32),
    (25604, 12, 32),
    (25604, 13, 32),
    (25604, 14, 32),
    (25604, 25, 83),
    (25604, 30, 83),
    (25604, 170, 8),
    (25604, 384, 600),
    (25632, 1, 43),
    (25632, 9, 28),
    (25632, 12, 28),
    (25632, 13, 28),
    (25632, 14, 28),
    (25632, 25, 73),
    (25632, 30, 73),
    (25632, 170, 7),
    (25632, 384, 500),
    (25638, 1, 16),
    (25638, 9, 10),
    (25638, 12, 10),
    (25638, 13, 10),
    (25638, 14, 10),
    (25638, 25, 28),
    (25638, 30, 28),
    (25638, 170, 3),
    (25638, 384, 200),
    (25639, 1, 19),
    (25639, 9, 12),
    (25639, 12, 12),
    (25639, 13, 12),
    (25639, 14, 12),
    (25639, 25, 33),
    (25639, 30, 33),
    (25639, 170, 3),
    (25639, 384, 200),
    (25645, 1, 37),
    (25645, 9, 24),
    (25645, 12, 24),
    (25645, 13, 24),
    (25645, 14, 24),
    (25645, 25, 63),
    (25645, 30, 63),
    (25645, 170, 6),
    (25645, 384, 400),
    (25652, 1, 13),
    (25652, 9, 8),
    (25652, 12, 8),
    (25652, 13, 8),
    (25652, 14, 8),
    (25652, 25, 23),
    (25652, 30, 23),
    (25652, 170, 2),
    (25652, 384, 200),
    (25657, 1, 28),
    (25657, 9, 18),
    (25657, 12, 18),
    (25657, 13, 18),
    (25657, 14, 18),
    (25657, 25, 48),
    (25657, 30, 48),
    (25657, 170, 5),
    (25657, 384, 300),
    (25658, 1, 34),
    (25658, 9, 22),
    (25658, 12, 22),
    (25658, 13, 22),
    (25658, 14, 22),
    (25658, 25, 58),
    (25658, 30, 58),
    (25658, 170, 6),
    (25658, 384, 400),
    (25669, 1, 22),
    (25669, 9, 14),
    (25669, 12, 14),
    (25669, 13, 14),
    (25669, 14, 14),
    (25669, 25, 38),
    (25669, 30, 38),
    (25669, 170, 4),
    (25669, 384, 300),
    (25670, 1, 22),
    (25670, 9, 14),
    (25670, 12, 14),
    (25670, 13, 14),
    (25670, 14, 14),
    (25670, 25, 38),
    (25670, 30, 38),
    (25670, 170, 4),
    (25670, 384, 300),
    (25671, 1, 28),
    (25671, 9, 18),
    (25671, 12, 18),
    (25671, 13, 18),
    (25671, 14, 18),
    (25671, 25, 48),
    (25671, 30, 48),
    (25671, 170, 5),
    (25671, 384, 300),
    (25672, 1, 28),
    (25672, 9, 18),
    (25672, 12, 18),
    (25672, 13, 18),
    (25672, 14, 18),
    (25672, 25, 48),
    (25672, 30, 48),
    (25672, 170, 5),
    (25672, 384, 300),
    (25673, 1, 34),
    (25673, 9, 22),
    (25673, 12, 22),
    (25673, 13, 22),
    (25673, 14, 22),
    (25673, 25, 58),
    (25673, 30, 58),
    (25673, 170, 6),
    (25673, 384, 400),
    (25675, 1, 37),
    (25675, 9, 24),
    (25675, 12, 24),
    (25675, 13, 24),
    (25675, 14, 24),
    (25675, 25, 63),
    (25675, 30, 63),
    (25675, 170, 6),
    (25675, 384, 400),
    (25677, 1, 43),
    (25677, 9, 28),
    (25677, 12, 28),
    (25677, 13, 28),
    (25677, 14, 28),
    (25677, 25, 73),
    (25677, 30, 73),
    (25677, 170, 7),
    (25677, 384, 500),
    (25678, 1, 49),
    (25678, 9, 32),
    (25678, 12, 32),
    (25678, 13, 32),
    (25678, 14, 32),
    (25678, 25, 83),
    (25678, 30, 83),
    (25678, 170, 8),
    (25678, 384, 600),
    (25679, 1, 49),
    (25679, 9, 32),
    (25679, 12, 32),
    (25679, 13, 32),
    (25679, 14, 32),
    (25679, 25, 83),
    (25679, 30, 83),
    (25679, 170, 8),
    (25679, 384, 600),
    (25711, 1, 28),
    (25711, 8, 10),
    (25711, 9, 10),
    (25711, 12, 10),
    (25711, 13, 10),
    (25711, 23, 34),
    (25711, 25, 34),
    (25711, 28, 22),
    (25711, 161, -400),
    (25711, 369, 2),
    (25711, 384, 300),
    (25712, 1, 38),
    (25712, 8, 14),
    (25712, 9, 14),
    (25712, 12, 14),
    (25712, 13, 14),
    (25712, 23, 46),
    (25712, 25, 46),
    (25712, 28, 30),
    (25712, 161, -500),
    (25712, 369, 2),
    (25712, 384, 400),
    (25713, 1, 38),
    (25713, 8, 14),
    (25713, 9, 14),
    (25713, 12, 14),
    (25713, 13, 14),
    (25713, 23, 46),
    (25713, 25, 46),
    (25713, 28, 30),
    (25713, 161, -500),
    (25713, 369, 2),
    (25713, 384, 400),
    (25715, 1, 48),
    (25715, 8, 18),
    (25715, 9, 18),
    (25715, 12, 18),
    (25715, 13, 18),
    (25715, 23, 58),
    (25715, 25, 58),
    (25715, 28, 38),
    (25715, 161, -600),
    (25715, 369, 3),
    (25715, 384, 500),
    (25734, 1, 68),
    (25734, 8, 26),
    (25734, 9, 26),
    (25734, 12, 26),
    (25734, 13, 26),
    (25734, 23, 82),
    (25734, 25, 82),
    (25734, 28, 54),
    (25734, 161, -800),
    (25734, 369, 4),
    (25734, 384, 700),
    (25735, 1, 73),
    (25735, 8, 28),
    (25735, 9, 28),
    (25735, 12, 28),
    (25735, 13, 28),
    (25735, 23, 88),
    (25735, 25, 88),
    (25735, 28, 58),
    (25735, 161, -800),
    (25735, 369, 4),
    (25735, 384, 700),
    (25736, 1, 78),
    (25736, 8, 30),
    (25736, 9, 30),
    (25736, 12, 30),
    (25736, 13, 30),
    (25736, 23, 94),
    (25736, 25, 94),
    (25736, 28, 62),
    (25736, 161, -900),
    (25736, 369, 4),
    (25736, 384, 800),
    (25737, 1, 83),
    (25737, 8, 32),
    (25737, 9, 32),
    (25737, 12, 32),
    (25737, 13, 32),
    (25737, 23, 100),
    (25737, 25, 100),
    (25737, 28, 66),
    (25737, 161, -900),
    (25737, 369, 4),
    (25737, 384, 800),
    (25738, 1, 13),
    (25738, 8, 4),
    (25738, 9, 4),
    (25738, 12, 4),
    (25738, 13, 4),
    (25738, 23, 16),
    (25738, 25, 16),
    (25738, 28, 10),
    (25738, 161, -200),
    (25738, 369, 1),
    (25738, 384, 100),
    (25739, 1, 18),
    (25739, 8, 6),
    (25739, 9, 6),
    (25739, 12, 6),
    (25739, 13, 6),
    (25739, 23, 22),
    (25739, 25, 22),
    (25739, 28, 14),
    (25739, 161, -300),
    (25739, 369, 1),
    (25739, 384, 200),
    (25740, 1, 23),
    (25740, 8, 8),
    (25740, 9, 8),
    (25740, 12, 8),
    (25740, 13, 8),
    (25740, 23, 28),
    (25740, 25, 28),
    (25740, 28, 18),
    (25740, 161, -300),
    (25740, 369, 1),
    (25740, 384, 200),
    (25741, 1, 28),
    (25741, 8, 10),
    (25741, 9, 10),
    (25741, 12, 10),
    (25741, 13, 10),
    (25741, 23, 34),
    (25741, 25, 34),
    (25741, 28, 22),
    (25741, 161, -400),
    (25741, 369, 2),
    (25741, 384, 300),
    (25742, 1, 33),
    (25742, 8, 12),
    (25742, 9, 12),
    (25742, 12, 12),
    (25742, 13, 12),
    (25742, 23, 40),
    (25742, 25, 40),
    (25742, 28, 26),
    (25742, 161, -400),
    (25742, 369, 2),
    (25742, 384, 300),
    (25743, 1, 38),
    (25743, 8, 14),
    (25743, 9, 14),
    (25743, 12, 14),
    (25743, 13, 14),
    (25743, 23, 46),
    (25743, 25, 46),
    (25743, 28, 30),
    (25743, 161, -500),
    (25743, 369, 2),
    (25743, 384, 400),
    (25744, 1, 43),
    (25744, 8, 16),
    (25744, 9, 16),
    (25744, 12, 16),
    (25744, 13, 16),
    (25744, 23, 52),
    (25744, 25, 52),
    (25744, 28, 34),
    (25744, 161, -500),
    (25744, 369, 2),
    (25744, 384, 400),
    (25755, 1, 23),
    (25755, 8, 8),
    (25755, 9, 8),
    (25755, 12, 8),
    (25755, 13, 8),
    (25755, 23, 28),
    (25755, 25, 28),
    (25755, 28, 18),
    (25755, 161, -300),
    (25755, 369, 1),
    (25755, 384, 200),
    (25756, 1, 28),
    (25756, 8, 10),
    (25756, 9, 10),
    (25756, 12, 10),
    (25756, 13, 10),
    (25756, 23, 34),
    (25756, 25, 34),
    (25756, 28, 22),
    (25756, 161, -400),
    (25756, 369, 2),
    (25756, 384, 300),
    (25757, 1, 38),
    (25757, 8, 14),
    (25757, 9, 14),
    (25757, 12, 14),
    (25757, 13, 14),
    (25757, 23, 46),
    (25757, 25, 46),
    (25757, 28, 30),
    (25757, 161, -500),
    (25757, 369, 2),
    (25757, 384, 400),
    (25758, 1, 38),
    (25758, 8, 14),
    (25758, 9, 14),
    (25758, 12, 14),
    (25758, 13, 14),
    (25758, 23, 46),
    (25758, 25, 46),
    (25758, 28, 30),
    (25758, 161, -500),
    (25758, 369, 2),
    (25758, 384, 400),
    (25759, 1, 48),
    (25759, 8, 18),
    (25759, 9, 18),
    (25759, 12, 18),
    (25759, 13, 18),
    (25759, 23, 58),
    (25759, 25, 58),
    (25759, 28, 38),
    (25759, 161, -600),
    (25759, 369, 3),
    (25759, 384, 500),
    (25774, 1, 43),
    (25774, 8, 16),
    (25774, 9, 16),
    (25774, 12, 16),
    (25774, 13, 16),
    (25774, 23, 52),
    (25774, 25, 52),
    (25774, 28, 34),
    (25774, 161, -500),
    (25774, 369, 2),
    (25774, 384, 400),
    (25775, 1, 48),
    (25775, 8, 18),
    (25775, 9, 18),
    (25775, 12, 18),
    (25775, 13, 18),
    (25775, 23, 58),
    (25775, 25, 58),
    (25775, 28, 38),
    (25775, 161, -600),
    (25775, 369, 3),
    (25775, 384, 500),
    (25776, 1, 53),
    (25776, 8, 20),
    (25776, 9, 20),
    (25776, 12, 20),
    (25776, 13, 20),
    (25776, 23, 64),
    (25776, 25, 64),
    (25776, 28, 42),
    (25776, 161, -600),
    (25776, 369, 3),
    (25776, 384, 500),
    (25838, 1, 65),
    (25838, 8, 32),
    (25838, 11, 32),
    (25838, 68, 83),
    (25838, 73, 33),
    (25838, 170, 8),
    (25838, 384, 700),
    (25839, 1, 9),
    (25839, 8, 4),
    (25839, 11, 4),
    (25839, 68, 13),
    (25839, 73, 5),
    (25839, 170, 1),
    (25839, 384, 100),
    (25850, 1, 53),
    (25850, 8, 26),
    (25850, 11, 26),
    (25850, 68, 68),
    (25850, 73, 27),
    (25850, 170, 7),
    (25850, 384, 700),
    (25851, 1, 57),
    (25851, 8, 28),
    (25851, 11, 28),
    (25851, 68, 73),
    (25851, 73, 29),
    (25851, 170, 7),
    (25851, 384, 700),
    (25864, 1, 49),
    (25864, 8, 24),
    (25864, 11, 24),
    (25864, 68, 63),
    (25864, 73, 25),
    (25864, 170, 6),
    (25864, 384, 600),
    (25909, 1, 49),
    (25909, 8, 24),
    (25909, 11, 24),
    (25909, 68, 63),
    (25909, 73, 25),
    (25909, 170, 6),
    (25909, 384, 600),
    (25910, 1, 53),
    (25910, 8, 26),
    (25910, 11, 26),
    (25910, 68, 68),
    (25910, 73, 27),
    (25910, 170, 7),
    (25910, 384, 700),
    (26271, 1, 14),
    (26271, 2, 50),
    (26271, 5, 50),
    (26271, 23, 32),
    (26271, 28, 32),
    (26271, 161, -400),
    (26271, 369, 1),
    (26272, 1, 17),
    (26272, 2, 60),
    (26272, 5, 60),
    (26272, 23, 38),
    (26272, 28, 38),
    (26272, 161, -400),
    (26272, 369, 2),
    (26330, 8, 4),
    (26330, 9, 4),
    (26330, 12, 4),
    (26330, 13, 4),
    (26330, 28, 9),
    (26330, 73, 5),
    (26330, 384, 200),
    (26352, 8, 18),
    (26352, 9, 18),
    (26352, 12, 18),
    (26352, 13, 18),
    (26352, 28, 37),
    (26352, 73, 19),
    (26352, 384, 600),
    (26406, 1, 10),
    (26406, 10, 4),
    (26406, 13, 4),
    (26406, 109, 10),
    (26406, 161, -200),
    (26406, 369, 1),
    (26406, 384, 100),
    (26415, 1, 55),
    (26415, 10, 22),
    (26415, 13, 22),
    (26415, 109, 55),
    (26415, 161, -700),
    (26415, 369, 3),
    (26415, 384, 400),
    (26416, 1, 60),
    (26416, 10, 24),
    (26416, 13, 24),
    (26416, 109, 60),
    (26416, 161, -700),
    (26416, 369, 3),
    (26416, 384, 400),
    (26426, 1, 35),
    (26426, 10, 14),
    (26426, 13, 14),
    (26426, 109, 35),
    (26426, 161, -500),
    (26426, 369, 2),
    (26426, 384, 300),
    (26431, 1, 60),
    (26431, 10, 24),
    (26431, 13, 24),
    (26431, 109, 60),
    (26431, 161, -700),
    (26431, 369, 3),
    (26431, 384, 400),
    (26436, 1, 10),
    (26436, 10, 4),
    (26436, 13, 4),
    (26436, 109, 10),
    (26436, 161, -200),
    (26436, 369, 1),
    (26436, 384, 100),
    (26441, 1, 35),
    (26441, 10, 14),
    (26441, 13, 14),
    (26441, 109, 35),
    (26441, 161, -500),
    (26441, 369, 2),
    (26441, 384, 300),
    (26446, 1, 60),
    (26446, 10, 24),
    (26446, 13, 24),
    (26446, 109, 60),
    (26446, 161, -700),
    (26446, 369, 3),
    (26446, 384, 400),
    (26451, 1, 10),
    (26451, 10, 4),
    (26451, 13, 4),
    (26451, 109, 10),
    (26451, 161, -200),
    (26451, 369, 1),
    (26451, 384, 100),
    (26456, 1, 35),
    (26456, 10, 14),
    (26456, 13, 14),
    (26456, 109, 35),
    (26456, 161, -500),
    (26456, 369, 2),
    (26456, 384, 300),
    (26461, 1, 60),
    (26461, 10, 24),
    (26461, 13, 24),
    (26461, 109, 60),
    (26461, 161, -700),
    (26461, 369, 3),
    (26461, 384, 400),
    (26465, 1, 80),
    (26465, 10, 32),
    (26465, 13, 32),
    (26465, 109, 80),
    (26465, 161, -900),
    (26465, 369, 4),
    (26465, 384, 600),
    (26468, 1, 20),
    (26468, 10, 8),
    (26468, 13, 8),
    (26468, 109, 20),
    (26468, 161, -300),
    (26468, 369, 1),
    (26468, 384, 200),
    (26471, 1, 35),
    (26471, 10, 14),
    (26471, 13, 14),
    (26471, 109, 35),
    (26471, 161, -500),
    (26471, 369, 2),
    (26471, 384, 300),
    (26474, 1, 50),
    (26474, 10, 20),
    (26474, 13, 20),
    (26474, 109, 50),
    (26474, 161, -600),
    (26474, 369, 2),
    (26474, 384, 400),
    (26477, 1, 65),
    (26477, 10, 26),
    (26477, 13, 26),
    (26477, 109, 65),
    (26477, 161, -800),
    (26477, 369, 3),
    (26477, 384, 500),
    (26480, 1, 80),
    (26480, 10, 32),
    (26480, 13, 32),
    (26480, 109, 80),
    (26480, 161, -900),
    (26480, 369, 4),
    (26480, 384, 600),
    (26483, 1, 20),
    (26483, 10, 8),
    (26483, 13, 8),
    (26483, 109, 20),
    (26483, 161, -300),
    (26483, 369, 1),
    (26483, 384, 200),
    (26486, 1, 35),
    (26486, 10, 14),
    (26486, 13, 14),
    (26486, 109, 35),
    (26486, 161, -500),
    (26486, 369, 2),
    (26486, 384, 300),
    (26516, 1, 78),
    (26516, 8, 30),
    (26516, 9, 30),
    (26516, 12, 30),
    (26516, 13, 30),
    (26516, 23, 94),
    (26516, 25, 94),
    (26516, 28, 62),
    (26516, 161, -900),
    (26516, 369, 4),
    (26516, 384, 800),
    (26517, 1, 83),
    (26517, 8, 32),
    (26517, 9, 32),
    (26517, 12, 32),
    (26517, 13, 32),
    (26517, 23, 100),
    (26517, 25, 100),
    (26517, 28, 66),
    (26517, 161, -900),
    (26517, 369, 4),
    (26517, 384, 800),
    (26519, 1, 18),
    (26519, 8, 6),
    (26519, 9, 6),
    (26519, 12, 6),
    (26519, 13, 6),
    (26519, 23, 22),
    (26519, 25, 22),
    (26519, 28, 14),
    (26519, 161, -300),
    (26519, 369, 1),
    (26519, 384, 200),
    (26523, 1, 38),
    (26523, 8, 14),
    (26523, 9, 14),
    (26523, 12, 14),
    (26523, 13, 14),
    (26523, 23, 46),
    (26523, 25, 46),
    (26523, 28, 30),
    (26523, 161, -500),
    (26523, 369, 2),
    (26523, 384, 400),
    (26546, 1, 78),
    (26546, 8, 30),
    (26546, 9, 30),
    (26546, 12, 30),
    (26546, 13, 30),
    (26546, 23, 94),
    (26546, 25, 94),
    (26546, 28, 62),
    (26546, 161, -900),
    (26546, 369, 4),
    (26546, 384, 800),
    (26693, 1, 31),
    (26693, 9, 20),
    (26693, 12, 20),
    (26693, 13, 20),
    (26693, 14, 20),
    (26693, 25, 53),
    (26693, 30, 53),
    (26693, 170, 5),
    (26693, 384, 400),
    (26694, 1, 34),
    (26694, 9, 22),
    (26694, 12, 22),
    (26694, 13, 22),
    (26694, 14, 22),
    (26694, 25, 58),
    (26694, 30, 58),
    (26694, 170, 6),
    (26694, 384, 400),
    (26704, 1, 22),
    (26704, 9, 14),
    (26704, 12, 14),
    (26704, 13, 14),
    (26704, 14, 14),
    (26704, 25, 38),
    (26704, 30, 38),
    (26704, 170, 4),
    (26704, 384, 300),
    (26705, 1, 22),
    (26705, 9, 14),
    (26705, 12, 14),
    (26705, 13, 14),
    (26705, 14, 14),
    (26705, 25, 38),
    (26705, 30, 38),
    (26705, 170, 4),
    (26705, 384, 300),
    (26706, 1, 28),
    (26706, 9, 18),
    (26706, 12, 18),
    (26706, 13, 18),
    (26706, 14, 18),
    (26706, 25, 48),
    (26706, 30, 48),
    (26706, 170, 5),
    (26706, 384, 300),
    (26708, 1, 34),
    (26708, 9, 22),
    (26708, 12, 22),
    (26708, 13, 22),
    (26708, 14, 22),
    (26708, 25, 58),
    (26708, 30, 58),
    (26708, 170, 6),
    (26708, 384, 400),
    (26717, 1, 13),
    (26717, 9, 8),
    (26717, 12, 8),
    (26717, 13, 8),
    (26717, 14, 8),
    (26717, 25, 23),
    (26717, 30, 23),
    (26717, 170, 2),
    (26717, 384, 200),
    (26718, 1, 19),
    (26718, 9, 12),
    (26718, 12, 12),
    (26718, 13, 12),
    (26718, 14, 12),
    (26718, 25, 33),
    (26718, 30, 33),
    (26718, 170, 3),
    (26718, 384, 200),
    (26719, 1, 19),
    (26719, 9, 12),
    (26719, 12, 12),
    (26719, 13, 12),
    (26719, 14, 12),
    (26719, 25, 33),
    (26719, 30, 33),
    (26719, 170, 3),
    (26719, 384, 200),
    (26720, 1, 25),
    (26720, 9, 16),
    (26720, 12, 16),
    (26720, 13, 16),
    (26720, 14, 16),
    (26720, 25, 43),
    (26720, 30, 43),
    (26720, 170, 4),
    (26720, 384, 300),
    (26728, 1, 46),
    (26728, 9, 30),
    (26728, 12, 30),
    (26728, 13, 30),
    (26728, 14, 30),
    (26728, 25, 78),
    (26728, 30, 78),
    (26728, 170, 8),
    (26728, 384, 500),
    (26730, 1, 7),
    (26730, 9, 4),
    (26730, 12, 4),
    (26730, 13, 4),
    (26730, 14, 4),
    (26730, 25, 13),
    (26730, 30, 13),
    (26730, 170, 1),
    (26730, 384, 100),
    (26738, 1, 31),
    (26738, 9, 20),
    (26738, 12, 20),
    (26738, 13, 20),
    (26738, 14, 20),
    (26738, 25, 53),
    (26738, 30, 53),
    (26738, 170, 5),
    (26738, 384, 400),
    (26739, 1, 37),
    (26739, 9, 24),
    (26739, 12, 24),
    (26739, 13, 24),
    (26739, 14, 24),
    (26739, 25, 63),
    (26739, 30, 63),
    (26739, 170, 6),
    (26739, 384, 400),
    (26788, 1, 46),
    (26788, 9, 30),
    (26788, 12, 30),
    (26788, 13, 30),
    (26788, 14, 30),
    (26788, 25, 78),
    (26788, 30, 78),
    (26788, 170, 8),
    (26788, 384, 500),
    (26798, 1, 31),
    (26798, 9, 20),
    (26798, 12, 20),
    (26798, 13, 20),
    (26798, 14, 20),
    (26798, 25, 53),
    (26798, 30, 53),
    (26798, 170, 5),
    (26798, 384, 400),
    (26799, 1, 37),
    (26799, 9, 24),
    (26799, 12, 24),
    (26799, 13, 24),
    (26799, 14, 24),
    (26799, 25, 63),
    (26799, 30, 63),
    (26799, 170, 6),
    (26799, 384, 400),
    (26954, 1, 18),
    (26954, 8, 6),
    (26954, 9, 6),
    (26954, 12, 6),
    (26954, 13, 6),
    (26954, 23, 22),
    (26954, 25, 22),
    (26954, 28, 14),
    (26954, 161, -300),
    (26954, 369, 1),
    (26954, 384, 200),
    (26955, 1, 28),
    (26955, 8, 10),
    (26955, 9, 10),
    (26955, 12, 10),
    (26955, 13, 10),
    (26955, 23, 34),
    (26955, 25, 34),
    (26955, 28, 22),
    (26955, 161, -400),
    (26955, 369, 2),
    (26955, 384, 300),
    (26966, 1, 83),
    (26966, 8, 32),
    (26966, 9, 32),
    (26966, 12, 32),
    (26966, 13, 32),
    (26966, 23, 100),
    (26966, 25, 100),
    (26966, 28, 66),
    (26966, 161, -900),
    (26966, 369, 4),
    (26966, 384, 800),
    (26967, 1, 83),
    (26967, 8, 32),
    (26967, 9, 32),
    (26967, 12, 32),
    (26967, 13, 32),
    (26967, 23, 100),
    (26967, 25, 100),
    (26967, 28, 66),
    (26967, 161, -900),
    (26967, 369, 4),
    (26967, 384, 800),
    (26968, 1, 18),
    (26968, 8, 6),
    (26968, 9, 6),
    (26968, 12, 6),
    (26968, 13, 6),
    (26968, 23, 22),
    (26968, 25, 22),
    (26968, 28, 14),
    (26968, 161, -300),
    (26968, 369, 1),
    (26968, 384, 200),
    (27110, 1, 33),
    (27110, 9, 23),
    (27110, 12, 23),
    (27110, 25, 70),
    (27110, 30, 70),
    (27110, 288, 12),
    (27110, 384, 600),
    (27293, 1, 65),
    (27293, 8, 32),
    (27293, 11, 32),
    (27293, 68, 83),
    (27293, 73, 33),
    (27293, 170, 8),
    (27293, 384, 700),
    (27294, 1, 13),
    (27294, 8, 6),
    (27294, 11, 6),
    (27294, 68, 18),
    (27294, 73, 7),
    (27294, 170, 2),
    (27294, 384, 200),
    (27625, 1, 30),
    (27625, 10, 12),
    (27625, 13, 12),
    (27625, 109, 30),
    (27625, 161, -400),
    (27625, 369, 2),
    (27625, 384, 200),
    (27626, 1, 35),
    (27626, 10, 14),
    (27626, 13, 14),
    (27626, 109, 35),
    (27626, 161, -500),
    (27626, 369, 2),
    (27626, 384, 300),
    (27631, 1, 60),
    (27631, 10, 24),
    (27631, 13, 24),
    (27631, 109, 60),
    (27631, 161, -700),
    (27631, 369, 3),
    (27631, 384, 400),
    (27632, 1, 70),
    (27632, 10, 28),
    (27632, 13, 28),
    (27632, 109, 70),
    (27632, 161, -800),
    (27632, 369, 3),
    (27632, 384, 500),
    (27715, 1, 37),
    (27715, 9, 24),
    (27715, 12, 24),
    (27715, 13, 24),
    (27715, 14, 24),
    (27715, 25, 63),
    (27715, 30, 63),
    (27715, 170, 6),
    (27715, 384, 400),
    (27716, 1, 40),
    (27716, 9, 26),
    (27716, 12, 26),
    (27716, 13, 26),
    (27716, 14, 26),
    (27716, 25, 68),
    (27716, 30, 68),
    (27716, 170, 7),
    (27716, 384, 500),
    (27717, 1, 43),
    (27717, 9, 28),
    (27717, 12, 28),
    (27717, 13, 28),
    (27717, 14, 28),
    (27717, 25, 73),
    (27717, 30, 73),
    (27717, 170, 7),
    (27717, 384, 500),
    (27718, 1, 49),
    (27718, 9, 32),
    (27718, 12, 32),
    (27718, 13, 32),
    (27718, 14, 32),
    (27718, 25, 83),
    (27718, 30, 83),
    (27718, 170, 8),
    (27718, 384, 600),
    (27726, 1, 25),
    (27726, 9, 16),
    (27726, 12, 16),
    (27726, 13, 16),
    (27726, 14, 16),
    (27726, 25, 43),
    (27726, 30, 43),
    (27726, 170, 4),
    (27726, 384, 300),
    (27727, 1, 28),
    (27727, 9, 18),
    (27727, 12, 18),
    (27727, 13, 18),
    (27727, 14, 18),
    (27727, 25, 48),
    (27727, 30, 48),
    (27727, 170, 5),
    (27727, 384, 300),
    (27733, 1, 46),
    (27733, 9, 30),
    (27733, 12, 30),
    (27733, 13, 30),
    (27733, 14, 30),
    (27733, 25, 78),
    (27733, 30, 78),
    (27733, 170, 8),
    (27733, 384, 500),
    (27734, 1, 49),
    (27734, 9, 32),
    (27734, 12, 32),
    (27734, 13, 32),
    (27734, 14, 32),
    (27734, 25, 83),
    (27734, 30, 83),
    (27734, 170, 8),
    (27734, 384, 600),
    (27755, 1, 22),
    (27755, 9, 14),
    (27755, 12, 14),
    (27755, 13, 14),
    (27755, 14, 14),
    (27755, 25, 38),
    (27755, 30, 38),
    (27755, 170, 4),
    (27755, 384, 300),
    (27756, 1, 25),
    (27756, 9, 16),
    (27756, 12, 16),
    (27756, 13, 16),
    (27756, 14, 16),
    (27756, 25, 43),
    (27756, 30, 43),
    (27756, 170, 4),
    (27756, 384, 300),
    (27758, 1, 34),
    (27758, 9, 22),
    (27758, 12, 22),
    (27758, 13, 22),
    (27758, 14, 22),
    (27758, 25, 58),
    (27758, 30, 58),
    (27758, 170, 6),
    (27758, 384, 400),
    (27759, 1, 34),
    (27759, 9, 22),
    (27759, 12, 22),
    (27759, 13, 22),
    (27759, 14, 22),
    (27759, 25, 58),
    (27759, 30, 58),
    (27759, 170, 6),
    (27759, 384, 400),
    (27760, 1, 40),
    (27760, 9, 26),
    (27760, 12, 26),
    (27760, 13, 26),
    (27760, 14, 26),
    (27760, 25, 68),
    (27760, 30, 68),
    (27760, 170, 7),
    (27760, 384, 500),
    (27765, 1, 7),
    (27765, 9, 4),
    (27765, 12, 4),
    (27765, 13, 4),
    (27765, 14, 4),
    (27765, 25, 13),
    (27765, 30, 13),
    (27765, 170, 1),
    (27765, 384, 100),
    (27803, 1, 63),
    (27803, 8, 24),
    (27803, 9, 24),
    (27803, 12, 24),
    (27803, 13, 24),
    (27803, 23, 76),
    (27803, 25, 76),
    (27803, 28, 50),
    (27803, 161, -700),
    (27803, 369, 3),
    (27803, 384, 600),
    (27804, 1, 68),
    (27804, 8, 26),
    (27804, 9, 26),
    (27804, 12, 26),
    (27804, 13, 26),
    (27804, 23, 82),
    (27804, 25, 82),
    (27804, 28, 54),
    (27804, 161, -800),
    (27804, 369, 4),
    (27804, 384, 700),
    (27805, 1, 78),
    (27805, 8, 30),
    (27805, 9, 30),
    (27805, 12, 30),
    (27805, 13, 30),
    (27805, 23, 94),
    (27805, 25, 94),
    (27805, 28, 62),
    (27805, 161, -900),
    (27805, 369, 4),
    (27805, 384, 800),
    (27806, 1, 83),
    (27806, 8, 32),
    (27806, 9, 32),
    (27806, 12, 32),
    (27806, 13, 32),
    (27806, 23, 100),
    (27806, 25, 100),
    (27806, 28, 66),
    (27806, 161, -900),
    (27806, 369, 4),
    (27806, 384, 800),
    (27854, 1, 18),
    (27854, 8, 6),
    (27854, 9, 6),
    (27854, 12, 6),
    (27854, 13, 6),
    (27854, 23, 22),
    (27854, 25, 22),
    (27854, 28, 14),
    (27854, 161, -300),
    (27854, 369, 1),
    (27854, 384, 200),
    (27855, 1, 28),
    (27855, 8, 10),
    (27855, 9, 10),
    (27855, 12, 10),
    (27855, 13, 10),
    (27855, 23, 34),
    (27855, 25, 34),
    (27855, 28, 22),
    (27855, 161, -400),
    (27855, 369, 2),
    (27855, 384, 300),
    (27866, 1, 78),
    (27866, 8, 30),
    (27866, 9, 30),
    (27866, 12, 30),
    (27866, 13, 30),
    (27866, 23, 94),
    (27866, 25, 94),
    (27866, 28, 62),
    (27866, 161, -900),
    (27866, 369, 4),
    (27866, 384, 800),
    (27867, 1, 83),
    (27867, 8, 32),
    (27867, 9, 32),
    (27867, 12, 32),
    (27867, 13, 32),
    (27867, 23, 100),
    (27867, 25, 100),
    (27867, 28, 66),
    (27867, 161, -900),
    (27867, 369, 4),
    (27867, 384, 800),
    (27879, 1, 68),
    (27879, 8, 26),
    (27879, 9, 26),
    (27879, 12, 26),
    (27879, 13, 26),
    (27879, 23, 82),
    (27879, 25, 82),
    (27879, 28, 54),
    (27879, 161, -800),
    (27879, 369, 4),
    (27879, 384, 700),
    (27880, 1, 73),
    (27880, 8, 28),
    (27880, 9, 28),
    (27880, 12, 28),
    (27880, 13, 28),
    (27880, 23, 88),
    (27880, 25, 88),
    (27880, 28, 58),
    (27880, 161, -800),
    (27880, 369, 4),
    (27880, 384, 700),
    (27906, 1, 58),
    (27906, 8, 22),
    (27906, 9, 22),
    (27906, 12, 22),
    (27906, 13, 22),
    (27906, 23, 70),
    (27906, 25, 70),
    (27906, 28, 46),
    (27906, 161, -700),
    (27906, 369, 3),
    (27906, 384, 600),
    (27911, 1, 78),
    (27911, 8, 30),
    (27911, 9, 30),
    (27911, 12, 30),
    (27911, 13, 30),
    (27911, 23, 94),
    (27911, 25, 94),
    (27911, 28, 62),
    (27911, 161, -900),
    (27911, 369, 4),
    (27911, 384, 800),
    (28086, 1, 57),
    (28086, 8, 28),
    (28086, 11, 28),
    (28086, 68, 73),
    (28086, 73, 29),
    (28086, 170, 7),
    (28086, 384, 700),
    (28087, 1, 61),
    (28087, 8, 30),
    (28087, 11, 30),
    (28087, 68, 78),
    (28087, 73, 31),
    (28087, 170, 8),
    (28087, 384, 700),
    (28302, 1, 21),
    (28302, 9, 15),
    (28302, 11, 15),
    (28302, 68, 46),
    (28302, 76, 6),
    (28302, 384, 400),
    (28303, 1, 24),
    (28303, 9, 17),
    (28303, 11, 17),
    (28303, 68, 52),
    (28303, 76, 6),
    (28303, 384, 400),
    (28510, 9, 4),
    (28510, 12, 4),
    (28510, 13, 4),
    (28510, 28, 9),
    (28510, 170, 1),
    (28510, 288, 3),
    (28651, 1, 60),
    (28651, 10, 24),
    (28651, 13, 24),
    (28651, 109, 60),
    (28651, 161, -700),
    (28651, 369, 3),
    (28651, 384, 400),
    (28652, 1, 65),
    (28652, 10, 26),
    (28652, 13, 26),
    (28652, 109, 65),
    (28652, 161, -800),
    (28652, 369, 3),
    (28652, 384, 500),
    (28653, 1, 70),
    (28653, 10, 28),
    (28653, 13, 28),
    (28653, 109, 70),
    (28653, 161, -800),
    (28653, 369, 3),
    (28653, 384, 500),
    (28670, 1, 80),
    (28670, 10, 32),
    (28670, 13, 32),
    (28670, 109, 80),
    (28670, 161, -900),
    (28670, 369, 4),
    (28670, 384, 600);

-- Pet-specific generated weapon bonuses.
REPLACE INTO `item_mods_pet` VALUES
    (18545, 384, 200, 0);
