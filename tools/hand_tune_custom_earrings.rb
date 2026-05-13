#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

SOURCE = File.expand_path('../armor2_custom_reworked.yml', __dir__)

EAR_PATTERNS =
{
  'heavy' => [
    [%w[WAR DRG DRK SAM], { 'STR' => 6, 'Attack' => 16, 'Accuracy' => 12, 'StoreTP' => 3, 'DoubleAttack' => 2 }],
    [%w[WAR PLD DRK RUN BST], { 'VIT' => 7, 'Defense' => 16, 'Enmity' => 4, 'DamageTaken' => -2, 'StoreTP' => 2 }],
    [%w[WAR MNK DRG SAM DRK BLU], { 'STR' => 5, 'DEX' => 5, 'Attack' => 14, 'Accuracy' => 14, 'SubtleBlow' => 3, 'CriticalHitRate' => 2 }],
    [%w[WAR DRG SAM DRK BST], { 'STR' => 5, 'Attack' => 12, 'Accuracy' => 10, 'CriticalHitDamage' => 3, 'StoreTP' => 3, 'MovementSpeed' => 4 }],
    [%w[PLD RUN DRK BST WAR], { 'VIT' => 6, 'MND' => 4, 'Defense' => 12, 'Enmity' => 5, 'FastCast' => 2, 'DamageTaken' => -2 }],
  ],
  'scout' => [
    [%w[THF NIN DNC RNG SAM], { 'DEX' => 6, 'AGI' => 6, 'Accuracy' => 14, 'CriticalHitDamage' => 3, 'TripleAttack' => 2, 'MovementSpeed' => 4 }],
    [%w[THF NIN RNG DNC COR], { 'DEX' => 6, 'AGI' => 6, 'Accuracy' => 12, 'RangedAccuracy' => 12, 'CriticalHitRate' => 3, 'Snapshot' => 3 }],
    [%w[THF RNG COR DNC BLU], { 'DEX' => 5, 'AGI' => 7, 'RangedAttack' => 16, 'RangedAccuracy' => 14, 'StoreTP' => 3, 'Evasion' => 8 }],
    [%w[THF NIN DNC COR BLU], { 'DEX' => 5, 'AGI' => 5, 'Accuracy' => 12, 'Evasion' => 12, 'TripleAttack' => 2, 'SubtleBlow' => 3 }],
    [%w[RNG COR THF DNC NIN], { 'AGI' => 7, 'RangedAttack' => 14, 'RangedAccuracy' => 16, 'Snapshot' => 4, 'CriticalHitRate' => 2, 'MovementSpeed' => 3 }],
  ],
  'mystic' => [
    [%w[WHM RDM BRD SMN SCH GEO], { 'MND' => 6, 'CHR' => 6, 'HealingMagicSkill' => 10, 'CurePotency' => 3, 'FastCast' => 3, 'Refresh' => 1 }],
    [%w[WHM BLM RDM BRD SMN SCH GEO], { 'INT' => 5, 'MND' => 5, 'MagicAttackBonus' => 10, 'MagicAccuracy' => 10, 'FastCast' => 3, 'Refresh' => 1 }],
    [%w[BLM RDM SMN SCH GEO], { 'INT' => 6, 'SummoningMagicSkill' => 10, 'MagicBurstBonus' => 3, 'MagicAccuracy' => 12, 'Refresh' => 1 }],
    [%w[RDM SCH GEO SMN WHM], { 'INT' => 4, 'MND' => 6, 'MagicAccuracy' => 12, 'FastCast' => 5, 'HealingMagicSkill' => 6, 'Refresh' => 1 }],
    [%w[BRD SMN RDM SCH GEO], { 'CHR' => 7, 'SummoningMagicSkill' => 8, 'FastCast' => 3, 'Refresh' => 2, 'MagicAccuracy' => 8 }],
  ],
}.freeze

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
}.freeze

def desc_fragment(key, value)
  label = LABELS.fetch(key, key)
  key == 'DamageTaken' ? "#{label}#{value}%" : "#{label}+#{value}"
end

def pick_variant(name, variants)
  variants[name.each_byte.sum % variants.length]
end

doc = YAML.load_file(SOURCE)
items = doc['items']

items.each do |item|
  next unless (item.dig('equipment', 'slots') || []).include?('Ears')

  family = item.dig('design', 'role_family')
  next unless EAR_PATTERNS.key?(family)

  jobs, modifiers = pick_variant(item.dig('strings', 'name').to_s, EAR_PATTERNS[family])
  item['equipment']['jobs'] = jobs
  item['modifiers'] = modifiers
  item['strings']['description'] = modifiers.map { |key, value| desc_fragment(key, value) }.join(' ')
  item['design'] ||= {}
  item['design']['earring_tuned'] = true
end

File.write(SOURCE, YAML.dump(doc))
