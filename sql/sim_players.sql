-- =============================================================================
-- Sim Players: Autonomous player-like entities for the Dynamic World system.
--
-- sim_players         : identity, level, XP, HP, zone, death state, gil
-- sim_player_inventory: item accumulation (sells excess to AH)
-- sim_player_equip    : currently equipped item IDs per slot
--
-- fake_charid is a stable synthetic char ID used as the AH seller reference.
-- Choose IDs well above your real player range (9,000,000+).
-- =============================================================================

SET FOREIGN_KEY_CHECKS=0;

-- ---------------------------------------------------------------------------
-- sim_players
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS `sim_players`;
CREATE TABLE `sim_players` (
  `id`            int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name`          varchar(15)      NOT NULL,
  `race`          tinyint unsigned NOT NULL DEFAULT 1,   -- xi.race value
  `face`          tinyint unsigned NOT NULL DEFAULT 1,
  `job`           tinyint unsigned NOT NULL DEFAULT 1,   -- xi.job value
  `level`         tinyint unsigned NOT NULL DEFAULT 1,
  `xp`            int(10) unsigned NOT NULL DEFAULT 0,
  `hp`            int(10)          NOT NULL DEFAULT 100, -- current HP (signed: can go -ve briefly)
  `max_hp`        int(10) unsigned NOT NULL DEFAULT 100,
  `gil`           int(10) unsigned NOT NULL DEFAULT 0,
  `current_zone`  smallint(5) unsigned NOT NULL DEFAULT 100,
  `death_time`    int(10) unsigned NOT NULL DEFAULT 0,   -- unix ts of death (0 = alive)
  `is_dead`       tinyint(1)       NOT NULL DEFAULT 0,
  `gear_score`    tinyint unsigned NOT NULL DEFAULT 0,   -- 0-5 overall gear quality tier
  `sim_state`     varchar(20)      NOT NULL DEFAULT 'idle', -- idle|hunting|resting|traveling|dead
  `fake_charid`   int(10) unsigned NOT NULL,             -- unique ID used for AH seller_name lookup
  `last_activity` int(10) unsigned NOT NULL DEFAULT 0,   -- unix ts of last tick
  `created_at`    int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_name`       (`name`),
  UNIQUE KEY `uq_fake_charid` (`fake_charid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ---------------------------------------------------------------------------
-- sim_player_inventory
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS `sim_player_inventory`;
CREATE TABLE `sim_player_inventory` (
  `simid`    int(10) unsigned NOT NULL,
  `itemid`   smallint(5) unsigned NOT NULL,
  `quantity` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`simid`, `itemid`),
  KEY `fk_spi_simid` (`simid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ---------------------------------------------------------------------------
-- sim_player_equip
-- ---------------------------------------------------------------------------
-- Slot IDs mirror FFXI equip slot ordering (same as char_equip.slotid):
--   0=main 1=sub 2=ranged 3=ammo 4=head 5=body 6=hands 7=legs 8=feet
--   9=neck 10=waist 11=left_ear 12=right_ear 13=left_ring 14=right_ring 15=back
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS `sim_player_equip`;
CREATE TABLE `sim_player_equip` (
  `simid`  int(10) unsigned NOT NULL,
  `slot`   tinyint unsigned NOT NULL,
  `itemid` smallint(5) unsigned NOT NULL DEFAULT 0,  -- 0 = nothing equipped
  PRIMARY KEY (`simid`, `slot`),
  KEY `fk_spe_simid` (`simid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

SET FOREIGN_KEY_CHECKS=1;
