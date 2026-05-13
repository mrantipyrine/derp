#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

SOURCE_YAML = 'armor2.yml'
SOURCE_SQL = 'sql/custom_items.sql'
OUTPUT_YAML = 'armor2_custom_reworked.yml'

CUSTOM_ID_REGEX = /REPLACE INTO `item_basic` VALUES\s*\(\s*(\d+)/

HEAVY_ARMOR_JOBS = [
  %w[WAR DRG DRK],
  %w[WAR PLD RUN],
  %w[WAR BST DRG],
  %w[MNK NIN SAM],
].freeze

SCOUT_ARMOR_JOBS = [
  %w[THF DNC RNG],
  %w[THF NIN DNC],
  %w[RNG COR THF],
  %w[THF RNG NIN],
].freeze

MYSTIC_ARMOR_JOBS = [
  %w[WHM RDM SCH],
  %w[BLM RDM GEO],
  %w[WHM BRD SMN],
  %w[RDM SMN SCH],
].freeze

HYBRID_MELEE_JOBS = [
  %w[MNK NIN SAM],
  %w[WAR DRG DRK],
  %w[WAR BST DRG],
].freeze

HEAVY_ACCESSORY_JOBS = [
  %w[WAR MNK SAM DRG DRK],
  %w[WAR PLD DRK RUN BST],
  %w[WAR MNK DRG SAM BLU],
].freeze

SCOUT_ACCESSORY_JOBS = [
  %w[THF NIN RNG DNC COR],
  %w[THF RNG COR DNC BLU],
  %w[THF NIN DNC RNG SAM],
].freeze

MYSTIC_ACCESSORY_JOBS = [
  %w[WHM BLM RDM BRD SMN SCH GEO],
  %w[WHM RDM BRD SMN SCH GEO],
  %w[BLM RDM SMN SCH GEO],
].freeze

SLOT_SCALE = {
  'Head' => 1.00,
  'Body' => 1.25,
  'Hands' => 0.95,
  'Legs' => 1.10,
  'Feet' => 0.90,
  'Neck' => 0.80,
  'Waist' => 0.85,
  'Ears' => 0.75,
  'Rings' => 0.75,
  'Back' => 0.90,
}.freeze

def custom_ids
  File.read(SOURCE_SQL).scan(CUSTOM_ID_REGEX).flatten.map(&:to_i).uniq
end

def role_family(jobs)
  key = jobs.join(',')
  case key
  when 'WAR,MNK,DRK'
    :heavy
  when 'THF,RNG,DNC'
    :scout
  when 'WHM,BLM,RDM,BRD,SMN'
    :mystic
  when 'SAM,DRG', 'SAM,NIN', 'MNK,SAM,NIN'
    :hybrid_melee
  when 'WAR,PLD,DRK,RUN', 'WAR,DRK,RUN'
    :heavy
  else
    :heavy
  end
end

def reworked_family(jobs)
  return :heavy if HEAVY_ARMOR_JOBS.include?(jobs) || HEAVY_ACCESSORY_JOBS.include?(jobs)
  return :scout if SCOUT_ARMOR_JOBS.include?(jobs) || SCOUT_ACCESSORY_JOBS.include?(jobs)
  return :mystic if MYSTIC_ARMOR_JOBS.include?(jobs) || MYSTIC_ACCESSORY_JOBS.include?(jobs)

  :hybrid_melee
end

def accessory_slot?(slot)
  %w[Neck Waist Ears Rings Back].include?(slot)
end

def select_jobs(item)
  jobs = item.dig('equipment', 'jobs') || []
  slot = (item.dig('equipment', 'slots') || []).first || 'Body'
  seed = item['id'].to_i

  family = role_family(jobs)
  pool =
    if accessory_slot?(slot)
      case family
      when :heavy, :hybrid_melee then HEAVY_ACCESSORY_JOBS
      when :scout then SCOUT_ACCESSORY_JOBS
      when :mystic then MYSTIC_ACCESSORY_JOBS
      end
    else
      case family
      when :heavy then HEAVY_ARMOR_JOBS
      when :scout then SCOUT_ARMOR_JOBS
      when :mystic then MYSTIC_ARMOR_JOBS
      when :hybrid_melee then HYBRID_MELEE_JOBS
      end
    end

  pool[seed % pool.length]
end

def scaled(value, slot)
  factor = SLOT_SCALE.fetch(slot, 1.0)
  [(value * factor).round, 1].max
end

def heavy_mods(slot, variant)
  case variant
  when 0
    {
      'STR' => scaled(10, slot),
      'VIT' => scaled(8, slot),
      'Attack' => scaled(24, slot),
      'Accuracy' => scaled(18, slot),
      'StoreTP' => scaled(6, slot),
      'DoubleAttack' => scaled(3, slot),
    }
  when 1
    {
      'STR' => scaled(8, slot),
      'DEX' => scaled(8, slot),
      'Attack' => scaled(20, slot),
      'Accuracy' => scaled(20, slot),
      'CriticalHitRate' => scaled(3, slot),
      'SubtleBlow' => scaled(5, slot),
    }
  else
    {
      'VIT' => scaled(10, slot),
      'MND' => scaled(6, slot),
      'Defense' => scaled(20, slot),
      'Enmity' => scaled(5, slot),
      'DamageTaken' => -scaled(3, slot),
      'StoreTP' => scaled(4, slot),
    }
  end
end

def scout_mods(slot, variant)
  case variant
  when 0
    {
      'DEX' => scaled(10, slot),
      'AGI' => scaled(8, slot),
      'Accuracy' => scaled(20, slot),
      'RangedAccuracy' => scaled(20, slot),
      'CriticalHitRate' => scaled(4, slot),
      'Snapshot' => scaled(4, slot),
    }
  when 1
    {
      'DEX' => scaled(8, slot),
      'AGI' => scaled(10, slot),
      'RangedAttack' => scaled(22, slot),
      'RangedAccuracy' => scaled(18, slot),
      'Evasion' => scaled(16, slot),
      'StoreTP' => scaled(4, slot),
    }
  else
    {
      'DEX' => scaled(9, slot),
      'AGI' => scaled(9, slot),
      'Accuracy' => scaled(18, slot),
      'CriticalHitDamage' => scaled(3, slot),
      'TripleAttack' => scaled(2, slot),
      'MovementSpeed' => scaled(3, slot),
    }
  end
end

def mystic_mods(slot, variant)
  case variant
  when 0
    {
      'INT' => scaled(10, slot),
      'MND' => scaled(8, slot),
      'MagicAttackBonus' => scaled(20, slot),
      'MagicAccuracy' => scaled(18, slot),
      'FastCast' => scaled(4, slot),
      'Refresh' => [scaled(2, slot), 1].max,
    }
  when 1
    {
      'MND' => scaled(10, slot),
      'CHR' => scaled(8, slot),
      'HealingMagicSkill' => scaled(12, slot),
      'CurePotency' => scaled(4, slot),
      'FastCast' => scaled(4, slot),
      'Refresh' => [scaled(2, slot), 1].max,
    }
  else
    {
      'INT' => scaled(8, slot),
      'MND' => scaled(8, slot),
      'SummoningMagicSkill' => scaled(12, slot),
      'MagicBurstBonus' => scaled(4, slot),
      'MagicAccuracy' => scaled(16, slot),
      'Refresh' => [scaled(2, slot), 1].max,
    }
  end
end

def hybrid_melee_mods(slot, variant)
  case variant
  when 0
    {
      'STR' => scaled(9, slot),
      'DEX' => scaled(8, slot),
      'Attack' => scaled(22, slot),
      'Accuracy' => scaled(18, slot),
      'StoreTP' => scaled(6, slot),
      'WeaponSkillDamage' => scaled(3, slot),
    }
  when 1
    {
      'STR' => scaled(8, slot),
      'AGI' => scaled(8, slot),
      'Accuracy' => scaled(18, slot),
      'SubtleBlow' => scaled(6, slot),
      'CriticalHitRate' => scaled(3, slot),
      'Haste' => scaled(3, slot),
    }
  else
    {
      'STR' => scaled(8, slot),
      'VIT' => scaled(8, slot),
      'Attack' => scaled(18, slot),
      'Zanshin' => scaled(4, slot),
      'StoreTP' => scaled(5, slot),
      'SkillchainBonus' => scaled(3, slot),
    }
  end
end

def generate_modifiers(item, jobs)
  slot = (item.dig('equipment', 'slots') || []).first || 'Body'
  family = reworked_family(jobs)

  variant = item['id'].to_i % 3

  case family
  when :heavy then heavy_mods(slot, variant)
  when :scout then scout_mods(slot, variant)
  when :mystic then mystic_mods(slot, variant)
  else hybrid_melee_mods(slot, variant)
  end
end

def build_reworked_item(item)
  item = Marshal.load(Marshal.dump(item))
  jobs = select_jobs(item)
  item['equipment']['jobs'] = jobs
  item['modifiers'] = generate_modifiers(item, jobs)
  item['design'] = {
    'role_family' => reworked_family(jobs).to_s,
    'slot_focus' => (item.dig('equipment', 'slots') || []).first,
    'reworked' => true,
  }
  item
end

all_items = YAML.load_file(SOURCE_YAML)['items']
ids = custom_ids
subset = all_items.select { |item| ids.include?(item['id']) }
reworked = subset.map { |item| build_reworked_item(item) }

File.write(OUTPUT_YAML, { 'items' => reworked }.to_yaml(line_width: -1))
puts "Wrote #{OUTPUT_YAML} (#{reworked.size} items)"
