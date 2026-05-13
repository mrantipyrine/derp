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
  'DoubleAttack' => 288,
  'SubtleBlow' => 289,
  'TripleAttack' => 302,
  'Snapshot' => 365,
  'Refresh' => 369,
  'CurePotency' => 374,
  'CriticalHitDamage' => 421,
  'MagicBurstBonus' => 487,
}.freeze

def jobs_to_mask(jobs)
  jobs.reduce(0) { |mask, job| mask | JOB_BITS.fetch(job) }
end

def extract_first(regex, text)
  matches = {}
  text.scan(regex) do |*captures|
    row = captures.flatten
    matches[row[0].to_i] ||= row
  end
  matches
end

def extract_basic_rows(text)
  matches = {}
  in_basic = false

  text.each_line do |line|
    if line.start_with?('REPLACE INTO `item_basic` VALUES')
      in_basic = true
      if line =~ /REPLACE INTO `item_basic` VALUES\s*\((\d+),\s*(\d+),\s*'([^']*)',\s*'([^']*)',\s*'([^']*)',\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\);/
        row = Regexp.last_match.captures
        matches[row[0].to_i] ||= row
        in_basic = false
      end
      next
    end

    next unless in_basic
    next if line.strip.empty? || line.lstrip.start_with?('--')

    if line =~ /^\s*\((\d+),\s*(\d+),\s*'([^']*)',\s*'([^']*)',\s*'([^']*)',\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\);/
      row = Regexp.last_match.captures
      matches[row[0].to_i] ||= row
    end

    in_basic = false
  end

  matches
end

def extract_equipment_rows(text)
  matches = {}
  in_equipment = false

  text.each_line do |line|
    if line.start_with?('REPLACE INTO `item_equipment` VALUES')
      in_equipment = true
      if line =~ /REPLACE INTO `item_equipment` VALUES\s*\((\d+),\s*"([^"]*)",\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\);/
        row = Regexp.last_match.captures
        matches[row[0].to_i] ||= row
        in_equipment = false
      end
      next
    end

    next unless in_equipment
    next if line.strip.empty? || line.lstrip.start_with?('--')

    if line =~ /^\s*\((\d+),\s*"([^"]*)",\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\);/
      row = Regexp.last_match.captures
      matches[row[0].to_i] ||= row
    end

    in_equipment = false
  end

  matches
end

sql = File.read(SQL_PATH)
sql.sub!(/\n-- BEGIN CUSTOM TUNED OVERRIDES\n.*\n-- END CUSTOM TUNED OVERRIDES\n/m, "\n")

basic_rows = extract_basic_rows(sql)
equipment_rows = extract_equipment_rows(sql)

source_items = YAML.load_file(SOURCE_PATH).fetch('items')

override_lines = []
override_lines << '-- BEGIN CUSTOM TUNED OVERRIDES'
override_lines << '-- Last-writer-wins block for reworked custom items.'

source_items.sort_by { |item| item['id'] }.each do |item|
  item_id = item['id']
  basic = basic_rows.fetch(item_id)
  equipment = equipment_rows.fetch(item_id)

  override_lines << "DELETE FROM `item_mods` WHERE `itemId` = #{item_id};"
  override_lines << "DELETE FROM `item_mods_pet` WHERE `itemId` = #{item_id};"

  override_lines << format(
    "REPLACE INTO `item_basic` VALUES (%<id>d, %<subid>s, '%<name>s', '%<sortname>s', '%<name_jp>s', %<type>s, %<stack>s, %<flags>s, %<ah>s, %<base_sell>s);",
    id: item_id,
    subid: basic[1],
    name: basic[2],
    sortname: basic[3],
    name_jp: basic[4],
    type: basic[5],
    stack: basic[6],
    flags: basic[7],
    ah: basic[8],
    base_sell: basic[9]
  )

  jobs_mask = jobs_to_mask(item.dig('equipment', 'jobs') || [])
  level = item.dig('equipment', 'level') || equipment[2]

  override_lines << format(
    'REPLACE INTO `item_equipment` VALUES (%<id>d, "%<name>s", %<level>s, %<ilevel>s, %<jobs>s, %<mid>s, %<shield>s, %<script>s, %<slot>s, %<rslot>s, %<rslotlook>s, %<su>s);',
    id: item_id,
    name: equipment[1],
    level: level,
    ilevel: equipment[3],
    jobs: jobs_mask,
    mid: equipment[5],
    shield: equipment[6],
    script: equipment[7],
    slot: equipment[8],
    rslot: equipment[9],
    rslotlook: equipment[10],
    su: equipment[11]
  )

  modifiers = item.fetch('modifiers', {})
  mod_lines = modifiers.map do |name, value|
    mod_id = MOD_IDS.fetch(name)
    "    (#{item_id}, #{mod_id}, #{value})"
  end
  override_lines << "REPLACE INTO `item_mods` VALUES\n" + mod_lines.join(",\n") + ';'
end

override_lines << '-- END CUSTOM TUNED OVERRIDES'

sql = sql.rstrip + "\n\n" + override_lines.join("\n") + "\n"
File.write(SQL_PATH, sql)

puts "override_items=#{source_items.size}"
