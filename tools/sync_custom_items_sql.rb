#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

ROOT = File.expand_path('..', __dir__)
SOURCE_PATH = File.join(ROOT, 'armor2_custom_reworked.yml')
SQL_PATH = File.join(ROOT, 'sql', 'custom_items.sql')

JOB_BITS =
{
  'WAR' => 1,
  'MNK' => 2,
  'WHM' => 4,
  'BLM' => 8,
  'RDM' => 16,
  'THF' => 32,
  'PLD' => 64,
  'DRK' => 128,
  'BST' => 256,
  'BRD' => 512,
  'RNG' => 1024,
  'SAM' => 2048,
  'NIN' => 4096,
  'DRG' => 8192,
  'SMN' => 16384,
  'BLU' => 32768,
  'COR' => 65536,
  'PUP' => 131072,
  'DNC' => 262144,
  'SCH' => 524288,
  'GEO' => 1048576,
  'RUN' => 2097152,
}.freeze

MOD_IDS =
{
  'Defense' => 1,
  'HP' => 2,
  'MP' => 5,
  'STR' => 8,
  'DEX' => 9,
  'VIT' => 10,
  'AGI' => 11,
  'INT' => 12,
  'MND' => 13,
  'CHR' => 14,
  'Attack' => 23,
  'RangedAttack' => 24,
  'Accuracy' => 25,
  'RangedAccuracy' => 26,
  'Enmity' => 27,
  'MagicAttackBonus' => 28,
  'MagicAccuracy' => 30,
  'Evasion' => 68,
  'StoreTP' => 73,
  'MovementSpeed' => 76,
  'HealingMagicSkill' => 112,
  'SummoningMagicSkill' => 117,
  'DamageTaken' => 160,
  'CriticalHitRate' => 165,
  'FastCast' => 170,
  'MagicBurstBonus' => 487,
  'CurePotency' => 374,
  'Snapshot' => 365,
  'Refresh' => 369,
  'CriticalHitDamage' => 421,
  'DoubleAttack' => 288,
  'SubtleBlow' => 289,
  'TripleAttack' => 302,
}.freeze

def jobs_to_mask(jobs)
  jobs.reduce(0) { |mask, job| mask | JOB_BITS.fetch(job) }
end

def build_mod_block(item)
  item_id = item['id']
  modifiers = item['modifiers'] || {}
  lines = modifiers.map do |name, value|
    mod_id = MOD_IDS.fetch(name)
    "    (#{item_id}, #{mod_id}, #{value})"
  end
  "REPLACE INTO `item_mods` VALUES\n" + lines.join(",\n") + ";\n"
end

source_doc = YAML.load_file(SOURCE_PATH)
items = source_doc.fetch('items')
items_by_id = items.to_h { |item| [item['id'], item] }

text = File.read(SQL_PATH)
statements = text.split(/(?=REPLACE INTO `)/)
prefix = ''

unless statements.empty? || statements.first.start_with?('REPLACE INTO `')
  prefix = statements.shift
end

rewritten = statements.map do |stmt|
  if stmt.start_with?('REPLACE INTO `item_equipment` VALUES')
    if stmt =~ /^\s*REPLACE INTO `item_equipment` VALUES\s*\n\s*\((\d+),\s*"([^"]*)",\s*(\d+),\s*(\d+),\s*(\d+),(.*)\);\s*$/m
      item_id = Regexp.last_match(1).to_i
      item = items_by_id[item_id]
      if item
        name = Regexp.last_match(2)
        level = item.dig('equipment', 'level')
        ilvl = Regexp.last_match(4)
        jobs_mask = jobs_to_mask(item.dig('equipment', 'jobs') || [])
        tail = Regexp.last_match(6).rstrip
        next "REPLACE INTO `item_equipment` VALUES\n    (#{item_id}, \"#{name}\", #{level}, #{ilvl}, #{jobs_mask},#{tail});\n"
      end
    end
  elsif stmt.start_with?('REPLACE INTO `item_mods` VALUES')
    if stmt =~ /^\s*REPLACE INTO `item_mods` VALUES\s*\n\s*\((\d+),/m
      item_id = Regexp.last_match(1).to_i
      item = items_by_id[item_id]
      next build_mod_block(item) if item
    end
  end

  stmt
end

present_mod_ids = rewritten.map do |stmt|
  next unless stmt.start_with?('REPLACE INTO `item_mods` VALUES')
  next unless stmt =~ /^\s*REPLACE INTO `item_mods` VALUES\s*\n\s*\((\d+),/m

  Regexp.last_match(1).to_i
end.compact

missing_mod_blocks = items.reject { |item| present_mod_ids.include?(item['id']) }.map do |item|
  build_mod_block(item)
end

File.write(SQL_PATH, prefix + rewritten.join + missing_mod_blocks.join)
puts "synced_items=#{items.size}"
