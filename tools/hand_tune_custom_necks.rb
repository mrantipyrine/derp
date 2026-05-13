#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

SOURCE = File.expand_path('../armor2_custom_reworked.yml', __dir__)

NECK_OVERRIDES =
{
  25419 => { jobs: %w[WHM BLM RDM SCH GEO], modifiers: { 'INT' => 8, 'MND' => 6, 'MagicAttackBonus' => 14, 'MagicAccuracy' => 12, 'FastCast' => 4, 'Refresh' => 1 } },
  25431 => { jobs: %w[WAR DRG DRK SAM], modifiers: { 'STR' => 9, 'Attack' => 22, 'Accuracy' => 14, 'StoreTP' => 4, 'DoubleAttack' => 2 } },
  25526 => { jobs: %w[SMN SCH GEO RDM], modifiers: { 'INT' => 7, 'SummoningMagicSkill' => 14, 'MagicBurstBonus' => 4, 'MagicAccuracy' => 12, 'Refresh' => 1 } },
  25527 => { jobs: %w[BLM RDM SCH GEO], modifiers: { 'INT' => 9, 'MagicAttackBonus' => 16, 'MagicAccuracy' => 14, 'MagicBurstBonus' => 5, 'FastCast' => 3 } },
  25531 => { jobs: %w[RNG COR THF DNC], modifiers: { 'AGI' => 10, 'RangedAttack' => 20, 'RangedAccuracy' => 18, 'Snapshot' => 4, 'StoreTP' => 4 } },
  25532 => { jobs: %w[WHM RDM BRD SMN], modifiers: { 'MND' => 8, 'CHR' => 9, 'HealingMagicSkill' => 14, 'CurePotency' => 4, 'FastCast' => 4, 'Refresh' => 1 } },
  25533 => { jobs: %w[MNK NIN SAM BLU], modifiers: { 'STR' => 8, 'DEX' => 8, 'Accuracy' => 18, 'SubtleBlow' => 5, 'StoreTP' => 4, 'CriticalHitDamage' => 3 } },
  25537 => { jobs: %w[WAR MNK DRG SAM DRK], modifiers: { 'STR' => 8, 'Attack' => 18, 'Accuracy' => 16, 'CriticalHitRate' => 3, 'StoreTP' => 4 } },
  25538 => { jobs: %w[THF NIN DNC COR BLU], modifiers: { 'DEX' => 9, 'AGI' => 8, 'Accuracy' => 16, 'Evasion' => 12, 'TripleAttack' => 2, 'MovementSpeed' => 8 } },
  25544 => { jobs: %w[PLD RUN DRK BST], modifiers: { 'VIT' => 10, 'Defense' => 22, 'Enmity' => 6, 'DamageTaken' => -3, 'FastCast' => 3 } },
  25545 => { jobs: %w[RDM SCH GEO SMN], modifiers: { 'INT' => 7, 'MND' => 7, 'MagicAccuracy' => 15, 'FastCast' => 5, 'Refresh' => 1, 'SummoningMagicSkill' => 8 } },
  26000 => { jobs: %w[WAR PLD DRK RUN BST], modifiers: { 'VIT' => 10, 'Defense' => 20, 'Enmity' => 5, 'DamageTaken' => -3, 'StoreTP' => 3 } },
  26001 => { jobs: %w[WAR DRG SAM DRK BST], modifiers: { 'STR' => 8, 'Attack' => 18, 'Accuracy' => 15, 'CriticalHitDamage' => 4, 'StoreTP' => 3 } },
  26002 => { jobs: %w[WHM RDM SCH BRD], modifiers: { 'MND' => 10, 'HealingMagicSkill' => 14, 'CurePotency' => 5, 'MagicAccuracy' => 8, 'FastCast' => 4 } },
  26003 => { jobs: %w[BLM RDM SMN SCH GEO], modifiers: { 'INT' => 8, 'MagicAttackBonus' => 12, 'MagicAccuracy' => 14, 'FastCast' => 4, 'SummoningMagicSkill' => 8 } },
  26004 => { jobs: %w[BLM RDM SCH GEO], modifiers: { 'INT' => 9, 'MagicAttackBonus' => 14, 'MagicAccuracy' => 14, 'MagicBurstBonus' => 4, 'Refresh' => 1 } },
  26005 => { jobs: %w[WHM BRD SMN GEO], modifiers: { 'CHR' => 10, 'MND' => 7, 'HealingMagicSkill' => 10, 'SummoningMagicSkill' => 10, 'Refresh' => 2 } },
  26006 => { jobs: %w[WHM RDM SCH GEO], modifiers: { 'MND' => 9, 'HealingMagicSkill' => 12, 'CurePotency' => 4, 'FastCast' => 4, 'Refresh' => 1 } },
  26007 => { jobs: %w[WHM RDM BRD SMN], modifiers: { 'CHR' => 9, 'MND' => 8, 'FastCast' => 4, 'Refresh' => 2, 'HealingMagicSkill' => 8, 'SummoningMagicSkill' => 8 } },
  26008 => { jobs: %w[MNK THF NIN DNC], modifiers: { 'DEX' => 8, 'AGI' => 8, 'Accuracy' => 16, 'CriticalHitRate' => 4, 'TripleAttack' => 2, 'MovementSpeed' => 6 } },
  26009 => { jobs: %w[RNG COR THF], modifiers: { 'AGI' => 9, 'RangedAttack' => 18, 'RangedAccuracy' => 18, 'Snapshot' => 5, 'CriticalHitRate' => 2 } },
  26010 => { jobs: %w[WAR DRG DRK SAM], modifiers: { 'STR' => 10, 'Attack' => 20, 'Accuracy' => 14, 'StoreTP' => 4, 'DoubleAttack' => 2 } },
  26011 => { jobs: %w[WAR MNK SAM DRK BLU], modifiers: { 'STR' => 8, 'DEX' => 8, 'Accuracy' => 16, 'SubtleBlow' => 4, 'CriticalHitDamage' => 4 } },
  26012 => { jobs: %w[PLD RUN DRK BST WAR], modifiers: { 'VIT' => 9, 'Defense' => 18, 'Enmity' => 6, 'DamageTaken' => -3, 'FastCast' => 2 } },
  26013 => { jobs: %w[WAR DRG SAM DRK THF DNC], modifiers: { 'STR' => 7, 'DEX' => 7, 'Attack' => 16, 'Accuracy' => 16, 'StoreTP' => 3, 'CriticalHitRate' => 3 } },
  26014 => { jobs: %w[THF NIN RNG DNC COR], modifiers: { 'DEX' => 8, 'AGI' => 8, 'Accuracy' => 14, 'RangedAccuracy' => 14, 'CriticalHitRate' => 3, 'Snapshot' => 4 } },
  26015 => { jobs: %w[SMN SCH GEO RDM WHM], modifiers: { 'INT' => 6, 'MND' => 6, 'SummoningMagicSkill' => 12, 'FastCast' => 4, 'Refresh' => 2, 'MagicAccuracy' => 10 } },
  26042 => { jobs: %w[PLD RUN DRK BST], modifiers: { 'VIT' => 11, 'Defense' => 24, 'Enmity' => 7, 'DamageTaken' => -4, 'StoreTP' => 2 } },
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

doc = YAML.load_file(SOURCE)
items = doc['items']

NECK_OVERRIDES.each do |id, override|
  item = items.find { |row| row['id'] == id }
  next unless item

  item['equipment']['jobs'] = override[:jobs]
  item['modifiers'] = override[:modifiers]
  item['strings']['description'] = override[:modifiers].map { |key, value| desc_fragment(key, value) }.join(' ')
  item['design'] ||= {}
  item['design']['neck_tuned'] = true
end

File.write(SOURCE, YAML.dump(doc))
