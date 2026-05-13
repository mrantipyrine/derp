#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

SOURCE = File.expand_path('../armor2_custom_reworked.yml', __dir__)
ACCESSORY_SLOTS = %w[Ears Rings Neck Waist Back].freeze

LABELS =
{
  'MagicAttackBonus' => 'MAB',
  'MagicAccuracy' => 'MAcc',
  'MagicBurstBonus' => 'MB Bonus',
  'HealingMagicSkill' => 'Healing Skill',
  'SummoningMagicSkill' => 'Summoning Skill',
  'CriticalHitRate' => 'Crit Rate',
  'CriticalHitDamage' => 'Crit Dmg',
  'CurePotency' => 'Cure Pot.',
  'StoreTP' => 'Store TP',
  'FastCast' => 'Fast Cast',
  'DamageTaken' => 'DT',
  'MovementSpeed' => 'Move',
  'RangedAccuracy' => 'R.Acc.',
  'RangedAttack' => 'R.Atk.',
  'WeaponSkillDamage' => 'WSD',
  'SkillchainBonus' => 'SC Bonus',
}.freeze

CORE_PROFILE_JOBS =
{
  'heavy_guard' => %w[PLD WAR RUN DRK],
  'heavy_offense' => %w[WAR DRK DRG],
  'heavy_hybrid' => %w[MNK NIN SAM],
  'scout_ranged' => %w[RNG COR THF],
  'scout_evasive' => %w[THF NIN DNC],
  'mystic_heal' => %w[WHM BRD RDM SMN],
  'mystic_nuke' => %w[BLM RDM SMN SCH GEO],
  'mystic_support' => %w[SMN RDM WHM BRD SCH GEO],
  'hybrid_ws' => %w[MNK NIN SAM],
}.freeze

ACCESSORY_PROFILE_JOBS =
{
  'heavy_guard' => %w[PLD WAR RUN DRK BST],
  'heavy_offense' => %w[WAR DRK DRG SAM MNK],
  'heavy_hybrid' => %w[MNK NIN SAM THF DNC BLU],
  'scout_ranged' => %w[RNG COR THF DNC],
  'scout_evasive' => %w[THF NIN DNC RNG COR],
  'mystic_heal' => %w[WHM BRD RDM SMN SCH GEO],
  'mystic_nuke' => %w[BLM RDM SMN SCH GEO WHM],
  'mystic_support' => %w[SMN RDM WHM BRD SCH GEO],
  'hybrid_ws' => %w[MNK NIN SAM WAR DRK DRG THF DNC BLU],
}.freeze

PROFILE_BOOSTS =
{
  'heavy_guard' => %w[Defense Enmity VIT StoreTP FastCast Accuracy],
  'heavy_offense' => %w[Attack Accuracy STR StoreTP DoubleAttack VIT CriticalHitRate],
  'heavy_hybrid' => %w[Accuracy STR DEX StoreTP SubtleBlow CriticalHitDamage Attack],
  'scout_ranged' => %w[RangedAttack RangedAccuracy AGI Snapshot StoreTP CriticalHitRate Accuracy],
  'scout_evasive' => %w[Accuracy DEX AGI TripleAttack CriticalHitDamage Evasion MovementSpeed],
  'mystic_heal' => %w[HealingMagicSkill CurePotency MND FastCast Refresh CHR MagicAccuracy],
  'mystic_nuke' => %w[MagicAttackBonus MagicAccuracy INT FastCast MagicBurstBonus Refresh MND],
  'mystic_support' => %w[SummoningMagicSkill MagicAccuracy INT MND FastCast Refresh HealingMagicSkill],
  'hybrid_ws' => %w[Attack Accuracy STR DEX StoreTP WeaponSkillDamage Haste Zanshin SkillchainBonus],
}.freeze

def slot_of(item)
  Array(item.dig('equipment', 'slots')).first
end

def desc_fragment(key, value)
  label = LABELS.fetch(key, key)
  key == 'DamageTaken' ? "#{label}#{value}%" : "#{label}+#{value}"
end

def profile_for(item)
  mods = item['modifiers'] || {}
  family = item.dig('design', 'role_family').to_s

  return 'heavy_guard' if mods.key?('DamageTaken') || mods.key?('Enmity') || mods.key?('Defense')
  return 'mystic_heal' if mods.key?('HealingMagicSkill') || mods.key?('CurePotency')
  return 'mystic_support' if mods.key?('SummoningMagicSkill')
  return 'mystic_nuke' if mods.key?('MagicAttackBonus') || mods.key?('MagicBurstBonus')
  return 'scout_ranged' if mods.key?('RangedAttack') || mods.key?('RangedAccuracy') || mods.key?('Snapshot')
  return 'scout_evasive' if mods.key?('TripleAttack') || mods.key?('MovementSpeed')
  return 'heavy_offense' if mods.key?('DoubleAttack')
  return 'heavy_hybrid' if mods.key?('SubtleBlow') || mods.key?('CriticalHitDamage')

  case family
  when 'heavy'
    'heavy_offense'
  when 'scout'
    'scout_evasive'
  when 'mystic'
    'mystic_nuke'
  else
    'hybrid_ws'
  end
end

def jobs_for(item, profile)
  slot = slot_of(item)
  pool =
    if ACCESSORY_SLOTS.include?(slot)
      ACCESSORY_PROFILE_JOBS
    else
      CORE_PROFILE_JOBS
    end

  pool.fetch(profile)
end

def modifier_key(mods)
  mods.sort.map { |key, value| "#{key}=#{value}" }.join('|')
end

def boosted_modifiers(base_modifiers, profile, attempt)
  boostable = PROFILE_BOOSTS.fetch(profile).select { |key| base_modifiers.key?(key) }
  boostable = base_modifiers.keys if boostable.empty?

  key = boostable[attempt % boostable.length]
  amount = 1 + (attempt / boostable.length)
  updated = base_modifiers.transform_values(&:dup)
  updated[key] = updated.fetch(key, 0) + amount
  updated
end

doc = YAML.load_file(SOURCE)
items = doc['items']

items.each do |item|
  profile = profile_for(item)
  item['equipment']['jobs'] = jobs_for(item, profile)
  item['design'] ||= {}
  item['design']['role_grouped'] = true
  item['design']['accessory_relaxed'] = ACCESSORY_SLOTS.include?(slot_of(item))
end

seen_keys = {}

items.sort_by { |item| item['id'].to_i }.each do |item|
  modifiers = item['modifiers']
  next unless modifiers && !modifiers.empty?

  profile = profile_for(item)
  unique_modifiers = modifiers
  attempt = 0

  while seen_keys.key?(modifier_key(unique_modifiers))
    unique_modifiers = boosted_modifiers(modifiers, profile, attempt)
    attempt += 1
  end

  item['modifiers'] = unique_modifiers
  item['strings']['description'] = unique_modifiers.map { |key, value| desc_fragment(key, value) }.join(' ')
  item['design'] ||= {}
  item['design']['modifiers_deduped'] = attempt.positive?
  seen_keys[modifier_key(unique_modifiers)] = item['id']
end

File.write(SOURCE, YAML.dump(doc, line_width: -1))
