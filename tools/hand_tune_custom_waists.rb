#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

SOURCE = File.expand_path('../armor2_custom_reworked.yml', __dir__)

WAIST_OVERRIDES =
{
  26325 => { jobs: %w[RNG COR THF DNC], modifiers: { 'AGI' => 9, 'RangedAttack' => 20, 'RangedAccuracy' => 18, 'StoreTP' => 4, 'Evasion' => 10 } },
  26339 => { jobs: %w[RDM SCH GEO SMN], modifiers: { 'INT' => 6, 'MND' => 6, 'MagicAccuracy' => 10, 'FastCast' => 6, 'SummoningMagicSkill' => 10, 'Refresh' => 1 } },
  26345 => { jobs: %w[WHM RDM BRD SCH], modifiers: { 'MND' => 9, 'CHR' => 7, 'HealingMagicSkill' => 12, 'CurePotency' => 4, 'FastCast' => 4, 'Refresh' => 1 } },
  26349 => { jobs: %w[SMN SCH GEO RDM], modifiers: { 'INT' => 6, 'MagicAccuracy' => 12, 'FastCast' => 5, 'SummoningMagicSkill' => 12, 'Refresh' => 1 } },
  28410 => { jobs: %w[WHM BRD SMN GEO], modifiers: { 'CHR' => 9, 'MND' => 7, 'HealingMagicSkill' => 10, 'SummoningMagicSkill' => 10, 'Refresh' => 2 } },
  28414 => { jobs: %w[BLM RDM SCH GEO], modifiers: { 'INT' => 7, 'MagicAttackBonus' => 12, 'MagicAccuracy' => 12, 'FastCast' => 5, 'Refresh' => 1 } },
  28426 => { jobs: %w[WAR DRG DRK SAM], modifiers: { 'STR' => 8, 'Attack' => 20, 'Accuracy' => 14, 'StoreTP' => 5, 'DoubleAttack' => 2 } },
  28427 => { jobs: %w[WHM RDM SCH GEO], modifiers: { 'MND' => 8, 'HealingMagicSkill' => 12, 'CurePotency' => 4, 'MagicAccuracy' => 8, 'FastCast' => 4 } },
  28428 => { jobs: %w[THF NIN DNC COR BLU], modifiers: { 'DEX' => 7, 'AGI' => 7, 'Accuracy' => 14, 'Evasion' => 12, 'TripleAttack' => 2, 'MovementSpeed' => 8 } },
  28429 => { jobs: %w[RNG COR THF], modifiers: { 'AGI' => 8, 'RangedAttack' => 18, 'RangedAccuracy' => 18, 'Snapshot' => 5, 'CriticalHitRate' => 2 } },
  28430 => { jobs: %w[WHM RDM BRD SMN SCH GEO], modifiers: { 'MND' => 8, 'CHR' => 7, 'HealingMagicSkill' => 12, 'CurePotency' => 4, 'FastCast' => 4, 'Refresh' => 1 } },
  28431 => { jobs: %w[BLM RDM SCH GEO SMN], modifiers: { 'INT' => 8, 'MagicAttackBonus' => 12, 'MagicAccuracy' => 12, 'MagicBurstBonus' => 4, 'FastCast' => 4 } },
  28432 => { jobs: %w[MNK THF NIN DNC], modifiers: { 'DEX' => 8, 'AGI' => 7, 'Accuracy' => 14, 'CriticalHitDamage' => 4, 'TripleAttack' => 2, 'MovementSpeed' => 8 } },
  28433 => { jobs: %w[WHM BLM RDM SCH GEO], modifiers: { 'INT' => 7, 'MND' => 7, 'MagicAccuracy' => 12, 'FastCast' => 5, 'Refresh' => 2 } },
  28434 => { jobs: %w[SMN SCH GEO RDM WHM], modifiers: { 'INT' => 6, 'SummoningMagicSkill' => 12, 'MagicAccuracy' => 10, 'FastCast' => 4, 'Refresh' => 2 } },
  28435 => { jobs: %w[WHM RDM BRD SMN], modifiers: { 'CHR' => 9, 'MND' => 7, 'HealingMagicSkill' => 10, 'SummoningMagicSkill' => 8, 'Refresh' => 2 } },
  28436 => { jobs: %w[WAR MNK DRG SAM DRK BLU], modifiers: { 'STR' => 6, 'DEX' => 6, 'Accuracy' => 14, 'CriticalHitDamage' => 3, 'SubtleBlow' => 4, 'StoreTP' => 3 } },
  28437 => { jobs: %w[WHM BLM RDM SCH GEO], modifiers: { 'INT' => 7, 'MND' => 7, 'MagicAttackBonus' => 10, 'MagicAccuracy' => 10, 'FastCast' => 4, 'Refresh' => 1 } },
  28438 => { jobs: %w[THF NIN RNG DNC COR], modifiers: { 'DEX' => 7, 'AGI' => 7, 'Accuracy' => 14, 'RangedAccuracy' => 14, 'CriticalHitRate' => 3, 'Snapshot' => 4 } },
  28439 => { jobs: %w[PLD RUN DRK BST], modifiers: { 'VIT' => 9, 'Defense' => 18, 'Enmity' => 5, 'DamageTaken' => -3, 'FastCast' => 2 } },
  28440 => { jobs: %w[WAR PLD DRK RUN BST], modifiers: { 'VIT' => 8, 'Defense' => 18, 'Enmity' => 5, 'DamageTaken' => -3, 'StoreTP' => 3 } },
  28441 => { jobs: %w[THF NIN RNG DNC COR], modifiers: { 'DEX' => 7, 'AGI' => 7, 'Accuracy' => 14, 'RangedAccuracy' => 14, 'CriticalHitRate' => 3, 'Snapshot' => 4 } },
  28442 => { jobs: %w[RNG COR THF DNC], modifiers: { 'AGI' => 8, 'RangedAttack' => 18, 'RangedAccuracy' => 16, 'Snapshot' => 4, 'StoreTP' => 4 } },
  28443 => { jobs: %w[WAR DRG SAM DRK BST], modifiers: { 'STR' => 8, 'Attack' => 18, 'Accuracy' => 15, 'CriticalHitDamage' => 4, 'StoreTP' => 3 } },
  28445 => { jobs: %w[BLM RDM SMN SCH GEO], modifiers: { 'INT' => 8, 'MagicAttackBonus' => 12, 'MagicAccuracy' => 12, 'MagicBurstBonus' => 4, 'Refresh' => 1 } },
  28446 => { jobs: %w[MNK NIN SAM BLU], modifiers: { 'STR' => 7, 'DEX' => 7, 'Accuracy' => 14, 'SubtleBlow' => 5, 'StoreTP' => 3, 'CriticalHitDamage' => 3 } },
  28447 => { jobs: %w[WAR MNK DRG SAM DRK BLU], modifiers: { 'STR' => 7, 'DEX' => 6, 'Attack' => 16, 'Accuracy' => 14, 'SubtleBlow' => 4, 'StoreTP' => 3 } },
  28448 => { jobs: %w[WHM BLM RDM BRD SMN SCH GEO], modifiers: { 'INT' => 7, 'MND' => 7, 'MagicAttackBonus' => 10, 'MagicAccuracy' => 10, 'FastCast' => 4, 'Refresh' => 1 } },
  28449 => { jobs: %w[WAR PLD DRK RUN BST], modifiers: { 'VIT' => 8, 'Defense' => 18, 'Enmity' => 5, 'DamageTaken' => -3, 'StoreTP' => 3 } },
  28450 => { jobs: %w[RDM SCH GEO SMN WHM], modifiers: { 'INT' => 6, 'MND' => 6, 'MagicAccuracy' => 10, 'FastCast' => 5, 'Refresh' => 2, 'HealingMagicSkill' => 6 } },
  28451 => { jobs: %w[WHM RDM BRD SMN SCH GEO], modifiers: { 'MND' => 8, 'CHR' => 7, 'HealingMagicSkill' => 12, 'CurePotency' => 4, 'FastCast' => 4, 'Refresh' => 1 } },
  28467 => { jobs: %w[WHM BRD SMN GEO], modifiers: { 'CHR' => 8, 'MND' => 8, 'HealingMagicSkill' => 8, 'SummoningMagicSkill' => 10, 'Refresh' => 2 } },
  28534 => { jobs: %w[THF RNG COR DNC BLU], modifiers: { 'DEX' => 6, 'AGI' => 8, 'RangedAttack' => 18, 'RangedAccuracy' => 16, 'StoreTP' => 4, 'Evasion' => 10 } },
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

WAIST_OVERRIDES.each do |id, override|
  item = items.find { |row| row['id'] == id }
  next unless item

  item['equipment']['jobs'] = override[:jobs]
  item['modifiers'] = override[:modifiers]
  item['strings']['description'] = override[:modifiers].map { |key, value| desc_fragment(key, value) }.join(' ')
  item['design'] ||= {}
  item['design']['waist_tuned'] = true
end

File.write(SOURCE, YAML.dump(doc))
