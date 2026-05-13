#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

SOURCE = File.expand_path('../armor2_custom_reworked.yml', __dir__)
TARGET_SLOTS = %w[Ears Rings Neck Waist Back].freeze

FAMILY_PATTERNS =
{
  'heavy' => {
    'Ears' => [
      [%w[WAR DRG DRK SAM], { 'STR' => 6, 'Attack' => 16, 'Accuracy' => 12, 'StoreTP' => 3, 'DoubleAttack' => 2 }],
      [%w[WAR PLD DRK RUN BST], { 'VIT' => 7, 'Defense' => 16, 'Enmity' => 4, 'DamageTaken' => -2, 'StoreTP' => 2 }],
      [%w[WAR MNK DRG SAM DRK BLU], { 'STR' => 5, 'DEX' => 5, 'Attack' => 14, 'Accuracy' => 14, 'SubtleBlow' => 3, 'CriticalHitRate' => 2 }],
    ],
    'Rings' => [
      [%w[WAR MNK SAM DRG DRK THF DNC NIN BLU], { 'STR' => 6, 'DEX' => 6, 'Attack' => 12, 'Accuracy' => 12, 'StoreTP' => 4, 'CriticalHitRate' => 2 }],
      [%w[WAR PLD DRK RUN BST DRG], { 'VIT' => 7, 'Defense' => 18, 'Enmity' => 5, 'DamageTaken' => -2, 'StoreTP' => 2 }],
      [%w[WAR MNK SAM DRG DRK PLD RUN BST BLU], { 'STR' => 5, 'VIT' => 5, 'Attack' => 10, 'Accuracy' => 10, 'FastCast' => 2, 'StoreTP' => 3 }],
    ],
    'Neck' => [
      [%w[WAR DRG DRK SAM MNK], { 'STR' => 9, 'Attack' => 20, 'Accuracy' => 14, 'StoreTP' => 4, 'DoubleAttack' => 2 }],
      [%w[WAR PLD DRK RUN BST], { 'VIT' => 10, 'Defense' => 22, 'Enmity' => 6, 'DamageTaken' => -3, 'StoreTP' => 3 }],
      [%w[WAR MNK DRG SAM DRK PLD RUN BLU], { 'STR' => 7, 'DEX' => 7, 'Attack' => 18, 'Accuracy' => 16, 'SubtleBlow' => 4 }],
    ],
    'Waist' => [
      [%w[WAR DRG DRK SAM MNK], { 'STR' => 8, 'Attack' => 18, 'Accuracy' => 14, 'StoreTP' => 5, 'DoubleAttack' => 2 }],
      [%w[WAR PLD DRK RUN BST], { 'VIT' => 8, 'Defense' => 18, 'Enmity' => 5, 'DamageTaken' => -3, 'StoreTP' => 3 }],
      [%w[WAR MNK DRG SAM DRK BLU], { 'STR' => 6, 'DEX' => 6, 'Accuracy' => 14, 'CriticalHitDamage' => 3, 'SubtleBlow' => 4, 'StoreTP' => 3 }],
    ],
    'Back' => [
      [%w[WAR DRG DRK SAM MNK], { 'STR' => 9, 'VIT' => 7, 'Attack' => 18, 'Accuracy' => 14, 'StoreTP' => 4, 'DoubleAttack' => 3 }],
      [%w[WAR PLD DRK RUN BST], { 'VIT' => 10, 'Defense' => 22, 'Enmity' => 6, 'DamageTaken' => -3, 'FastCast' => 3 }],
      [%w[WAR MNK DRG SAM DRK PLD RUN BLU], { 'STR' => 7, 'DEX' => 5, 'Attack' => 14, 'Accuracy' => 14, 'CriticalHitRate' => 2, 'StoreTP' => 4 }],
    ],
  },
  'scout' => {
    'Ears' => [
      [%w[THF NIN RNG DNC COR], { 'DEX' => 6, 'AGI' => 6, 'Accuracy' => 12, 'RangedAccuracy' => 12, 'CriticalHitRate' => 3, 'Snapshot' => 3 }],
      [%w[THF RNG COR DNC BLU], { 'DEX' => 5, 'AGI' => 7, 'RangedAttack' => 16, 'RangedAccuracy' => 14, 'StoreTP' => 3, 'Evasion' => 8 }],
      [%w[THF NIN DNC RNG SAM], { 'DEX' => 6, 'AGI' => 6, 'Accuracy' => 14, 'CriticalHitDamage' => 3, 'TripleAttack' => 2, 'MovementSpeed' => 4 }],
    ],
    'Rings' => [
      [%w[THF NIN RNG DNC COR BLU], { 'DEX' => 6, 'AGI' => 6, 'Accuracy' => 10, 'RangedAccuracy' => 10, 'CriticalHitRate' => 2, 'StoreTP' => 3 }],
      [%w[THF NIN DNC RNG COR SAM], { 'DEX' => 5, 'AGI' => 7, 'Accuracy' => 12, 'CriticalHitDamage' => 3, 'TripleAttack' => 2 }],
      [%w[THF RNG COR DNC BLU], { 'DEX' => 4, 'AGI' => 8, 'RangedAttack' => 14, 'RangedAccuracy' => 12, 'Snapshot' => 4, 'Evasion' => 6 }],
    ],
    'Neck' => [
      [%w[THF RNG COR DNC BLU], { 'DEX' => 7, 'AGI' => 9, 'RangedAttack' => 18, 'RangedAccuracy' => 16, 'StoreTP' => 4, 'Evasion' => 10 }],
      [%w[THF NIN DNC RNG SAM], { 'DEX' => 8, 'AGI' => 8, 'Accuracy' => 16, 'CriticalHitDamage' => 4, 'TripleAttack' => 2, 'MovementSpeed' => 6 }],
      [%w[THF NIN RNG DNC COR], { 'DEX' => 8, 'AGI' => 8, 'Accuracy' => 14, 'RangedAccuracy' => 14, 'CriticalHitRate' => 3, 'Snapshot' => 4 }],
    ],
    'Waist' => [
      [%w[THF NIN RNG DNC COR], { 'DEX' => 7, 'AGI' => 7, 'Accuracy' => 14, 'RangedAccuracy' => 14, 'CriticalHitRate' => 3, 'Snapshot' => 4 }],
      [%w[THF RNG COR DNC BLU], { 'DEX' => 6, 'AGI' => 8, 'RangedAttack' => 18, 'RangedAccuracy' => 16, 'StoreTP' => 4, 'Evasion' => 10 }],
      [%w[THF NIN DNC RNG SAM], { 'DEX' => 7, 'AGI' => 7, 'Accuracy' => 14, 'CriticalHitDamage' => 4, 'TripleAttack' => 2, 'MovementSpeed' => 8 }],
    ],
    'Back' => [
      [%w[THF NIN RNG DNC COR], { 'DEX' => 8, 'AGI' => 8, 'Accuracy' => 16, 'RangedAccuracy' => 16, 'CriticalHitRate' => 3, 'Snapshot' => 4 }],
      [%w[THF RNG COR DNC BLU], { 'DEX' => 7, 'AGI' => 9, 'RangedAttack' => 18, 'RangedAccuracy' => 16, 'StoreTP' => 4, 'Evasion' => 10 }],
      [%w[THF NIN DNC RNG SAM], { 'DEX' => 8, 'AGI' => 8, 'Accuracy' => 16, 'CriticalHitDamage' => 4, 'TripleAttack' => 3, 'MovementSpeed' => 8 }],
    ],
  },
  'mystic' => {
    'Ears' => [
      [%w[WHM BLM RDM BRD SMN SCH GEO], { 'INT' => 5, 'MND' => 5, 'MagicAttackBonus' => 10, 'MagicAccuracy' => 10, 'FastCast' => 3, 'Refresh' => 1 }],
      [%w[WHM RDM BRD SMN SCH GEO], { 'MND' => 6, 'CHR' => 6, 'HealingMagicSkill' => 10, 'CurePotency' => 3, 'FastCast' => 3, 'Refresh' => 1 }],
      [%w[BLM RDM SMN SCH GEO], { 'INT' => 6, 'SummoningMagicSkill' => 10, 'MagicBurstBonus' => 3, 'MagicAccuracy' => 12, 'Refresh' => 1 }],
    ],
    'Rings' => [
      [%w[WHM BLM RDM BRD SMN SCH GEO], { 'INT' => 5, 'MND' => 5, 'MagicAccuracy' => 10, 'FastCast' => 4, 'Refresh' => 1, 'CurePotency' => 3 }],
      [%w[WHM RDM BRD SMN SCH GEO], { 'MND' => 6, 'CHR' => 6, 'HealingMagicSkill' => 10, 'CurePotency' => 3, 'FastCast' => 3, 'Refresh' => 1 }],
      [%w[BLM RDM SMN SCH GEO], { 'INT' => 6, 'MagicAttackBonus' => 10, 'MagicAccuracy' => 10, 'MagicBurstBonus' => 3, 'Refresh' => 1 }],
    ],
    'Neck' => [
      [%w[WHM BLM RDM BRD SMN SCH GEO], { 'INT' => 8, 'MND' => 8, 'MagicAttackBonus' => 14, 'MagicAccuracy' => 14, 'FastCast' => 4, 'Refresh' => 1 }],
      [%w[WHM RDM BRD SMN SCH GEO], { 'MND' => 9, 'CHR' => 8, 'HealingMagicSkill' => 14, 'CurePotency' => 4, 'FastCast' => 4, 'Refresh' => 1 }],
      [%w[BLM RDM SMN SCH GEO], { 'INT' => 8, 'MND' => 6, 'SummoningMagicSkill' => 12, 'MagicBurstBonus' => 4, 'MagicAccuracy' => 14, 'Refresh' => 1 }],
    ],
    'Waist' => [
      [%w[WHM BLM RDM BRD SMN SCH GEO], { 'INT' => 7, 'MND' => 7, 'MagicAttackBonus' => 12, 'MagicAccuracy' => 12, 'FastCast' => 4, 'Refresh' => 1 }],
      [%w[WHM RDM BRD SMN SCH GEO], { 'MND' => 8, 'CHR' => 7, 'HealingMagicSkill' => 12, 'CurePotency' => 4, 'FastCast' => 4, 'Refresh' => 1 }],
      [%w[RDM SMN SCH GEO], { 'INT' => 6, 'MND' => 6, 'MagicAccuracy' => 10, 'FastCast' => 6, 'SummoningMagicSkill' => 10, 'Refresh' => 1 }],
    ],
    'Back' => [
      [%w[WHM BLM RDM BRD SMN SCH GEO], { 'INT' => 8, 'MND' => 8, 'MagicAttackBonus' => 14, 'MagicAccuracy' => 14, 'FastCast' => 4, 'Refresh' => 1 }],
      [%w[WHM RDM BRD SMN SCH GEO], { 'MND' => 9, 'CHR' => 8, 'HealingMagicSkill' => 14, 'CurePotency' => 4, 'FastCast' => 4, 'Refresh' => 2 }],
      [%w[BLM RDM SMN SCH GEO], { 'INT' => 8, 'MND' => 6, 'SummoningMagicSkill' => 12, 'MagicBurstBonus' => 4, 'MagicAccuracy' => 14, 'Refresh' => 2 }],
    ],
  },
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
  slots = item.dig('equipment', 'slots') || []
  slot = slots.find { |entry| TARGET_SLOTS.include?(entry) }
  next unless slot

  family = item.dig('design', 'role_family')
  next unless FAMILY_PATTERNS.key?(family)

  jobs, modifiers = pick_variant(item.dig('strings', 'name').to_s, FAMILY_PATTERNS[family][slot])
  item['equipment']['jobs'] = jobs
  item['modifiers'] = modifiers
  item['strings']['description'] = modifiers.map { |key, value| desc_fragment(key, value) }.join(' ')
  item['design'] ||= {}
  item['design']['accessory_tuned'] = true
end

File.write(SOURCE, YAML.dump(doc))
