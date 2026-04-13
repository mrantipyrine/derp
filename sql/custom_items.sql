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
    (30000,  9,   5),   -- MND +5   (he's wise in mushroom ways)
    (30000, 10,   5);   -- CHR +5   (very charming hat)


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
    (30002,  3,  15),   -- MP +15
    (30002, 47,   5);   -- Haste +5


-- =============================================================================
-- SECTION 2: DYNAMIC WORLD TIER REWARDS
-- Generic rare drops from Elite / Apex tiers
-- =============================================================================

-- [30010] Wanderer's Token  (ring, all jobs, lv1 — proof you fought one)
REPLACE INTO `item_basic` VALUES
    (30010, 0, "Wanderer's_Token", "wanderers_token", 1, 46660, 99, 0, 200);

REPLACE INTO `item_equipment` VALUES
    (30010, "wanderers_token",           1,  0,  4194303,    0,        0,         0,   64,     0,         0,     0);
    --                                                                                   ^RING1 slot

REPLACE INTO `item_mods` VALUES
    (30010,  4,   3),   -- STR +3
    (30010,  5,   3);   -- DEX +3


-- [30011] Nomad's Cord  (waist, all jobs, lv20)
REPLACE INTO `item_basic` VALUES
    (30011, 0, "Nomad's_Cord", "nomads_cord", 1, 46660, 99, 0, 1000);

REPLACE INTO `item_equipment` VALUES
    (30011, "nomads_cord",              20,  0,  4194303,    0,        0,         0,  512,     0,         0,     0);
    --                                                                                   ^WAIST slot

REPLACE INTO `item_mods` VALUES
    (30011,  4,   5),   -- STR +5
    (30011,  6,   5),   -- VIT +5
    (30011, 11,  10);   -- ATT +10


-- [30012] Elite's Resolve  (back, all jobs, lv40)
REPLACE INTO `item_basic` VALUES
    (30012, 0, "Elite's_Resolve", "elites_resolve", 1, 46660, 99, 0, 3000);

REPLACE INTO `item_equipment` VALUES
    (30012, "elites_resolve",           40,  0,  4194303,    0,        0,         0,  256,     0,         0,     0);
    --                                                                                   ^BACK slot

REPLACE INTO `item_mods` VALUES
    (30012,  2,  50),   -- HP +50
    (30012,  4,   8),   -- STR +8
    (30012, 11,  15),   -- ATT +15
    (30012, 12,  10);   -- ACC +10


-- [30013] Apex Shard  (ring, all jobs, lv50 — very rare Apex drop)
REPLACE INTO `item_basic` VALUES
    (30013, 0, "Apex_Shard", "apex_shard", 1, 46660, 99, 0, 10000);

REPLACE INTO `item_equipment` VALUES
    (30013, "apex_shard",               50,  0,  4194303,    0,        0,         0,   64,     0,         0,     0);

REPLACE INTO `item_mods` VALUES
    (30013,  2, 100),   -- HP +100
    (30013,  3,  50),   -- MP +50
    (30013,  4,  10),   -- STR +10
    (30013,  8,  10),   -- INT +10
    (30013, 47,  10);   -- Haste +10


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
