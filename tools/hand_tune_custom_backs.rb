#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

SOURCE = File.expand_path('../armor2_custom_reworked.yml', __dir__)

BACK_OVERRIDES =
{
  27620 => { jobs: %w[SMN SCH GEO RDM], modifiers: { 'INT' => 8, 'SummoningMagicSkill' => 14, 'MagicBurstBonus' => 5, 'MagicAccuracy' => 14, 'Refresh' => 2 } },
  28542 => { jobs: %w[THF NIN RNG DNC COR], modifiers: { 'DEX' => 8, 'AGI' => 10, 'Accuracy' => 14, 'RangedAccuracy' => 16, 'CriticalHitRate' => 4, 'Snapshot' => 4 } },
  28594 => { jobs: %w[WHM RDM BRD SCH], modifiers: { 'MND' => 10, 'HealingMagicSkill' => 16, 'CurePotency' => 5, 'FastCast' => 4, 'Refresh' => 2 } },
  28595 => { jobs: %w[BLM RDM SCH GEO], modifiers: { 'INT' => 10, 'MagicAttackBonus' => 16, 'MagicAccuracy' => 14, 'MagicBurstBonus' => 5, 'Refresh' => 1 } },
  28596 => { jobs: %w[PLD RUN DRK BST], modifiers: { 'VIT' => 11, 'Defense' => 24, 'Enmity' => 7, 'DamageTaken' => -4, 'FastCast' => 3 } },
  28597 => { jobs: %w[WHM BLM RDM SMN SCH GEO], modifiers: { 'INT' => 7, 'MND' => 7, 'MagicAccuracy' => 14, 'FastCast' => 5, 'Refresh' => 2, 'CurePotency' => 3 } },
  28598 => { jobs: %w[SMN SCH GEO RDM WHM], modifiers: { 'MND' => 7, 'SummoningMagicSkill' => 12, 'MagicAccuracy' => 12, 'FastCast' => 4, 'Refresh' => 2, 'HealingMagicSkill' => 8 } },
  28599 => { jobs: %w[THF NIN DNC COR BLU], modifiers: { 'DEX' => 9, 'AGI' => 8, 'Accuracy' => 16, 'Evasion' => 14, 'TripleAttack' => 3, 'MovementSpeed' => 8 } },
  28601 => { jobs: %w[BRD SMN GEO WHM RDM], modifiers: { 'CHR' => 10, 'MND' => 8, 'SummoningMagicSkill' => 12, 'HealingMagicSkill' => 10, 'Refresh' => 2 } },
  28602 => { jobs: %w[BLM RDM SCH GEO SMN], modifiers: { 'INT' => 9, 'MagicAttackBonus' => 14, 'MagicAccuracy' => 14, 'FastCast' => 4, 'MagicBurstBonus' => 4 } },
  28604 => { jobs: %w[WHM BRD RDM SMN], modifiers: { 'CHR' => 9, 'MND' => 9, 'HealingMagicSkill' => 12, 'FastCast' => 4, 'Refresh' => 2, 'CurePotency' => 3 } },
  28605 => { jobs: %w[BLM RDM SMN SCH GEO], modifiers: { 'INT' => 8, 'MagicAccuracy' => 16, 'FastCast' => 5, 'MagicBurstBonus' => 4, 'Refresh' => 2 } },
  28606 => { jobs: %w[WHM RDM SCH GEO], modifiers: { 'MND' => 10, 'HealingMagicSkill' => 14, 'CurePotency' => 4, 'MagicAccuracy' => 10, 'FastCast' => 4, 'Refresh' => 1 } },
  28607 => { jobs: %w[WHM BLM RDM SCH GEO], modifiers: { 'INT' => 8, 'MND' => 8, 'MagicAttackBonus' => 12, 'MagicAccuracy' => 12, 'FastCast' => 4, 'Refresh' => 2 } },
  28608 => { jobs: %w[RNG COR THF DNC NIN], modifiers: { 'AGI' => 10, 'RangedAttack' => 20, 'RangedAccuracy' => 18, 'Snapshot' => 5, 'CriticalHitRate' => 3 } },
  28609 => { jobs: %w[WHM RDM BRD SMN SCH GEO], modifiers: { 'MND' => 9, 'CHR' => 8, 'HealingMagicSkill' => 12, 'SummoningMagicSkill' => 8, 'Refresh' => 2, 'FastCast' => 3 } },
  28610 => { jobs: %w[WAR PLD DRK RUN BST], modifiers: { 'VIT' => 12, 'Defense' => 22, 'Enmity' => 6, 'DamageTaken' => -4, 'StoreTP' => 3 } },
  28611 => { jobs: %w[WAR DRG DRK SAM MNK], modifiers: { 'STR' => 10, 'VIT' => 8, 'Attack' => 20, 'Accuracy' => 16, 'StoreTP' => 4, 'DoubleAttack' => 3 } },
  28612 => { jobs: %w[WHM BRD SMN GEO], modifiers: { 'CHR' => 10, 'MND' => 7, 'HealingMagicSkill' => 8, 'SummoningMagicSkill' => 12, 'Refresh' => 3 } },
  28614 => { jobs: %w[WAR MNK DRG SAM DRK THF DNC], modifiers: { 'STR' => 8, 'DEX' => 8, 'Attack' => 16, 'Accuracy' => 16, 'CriticalHitRate' => 3, 'StoreTP' => 4 } },
  28615 => { jobs: %w[WAR MNK DRG SAM DRK BLU], modifiers: { 'STR' => 8, 'DEX' => 6, 'Attack' => 16, 'Accuracy' => 16, 'SubtleBlow' => 4, 'CriticalHitDamage' => 4 } },
  28616 => { jobs: %w[THF NIN RNG DNC COR], modifiers: { 'DEX' => 9, 'AGI' => 9, 'Accuracy' => 16, 'RangedAccuracy' => 16, 'CriticalHitRate' => 3, 'Snapshot' => 4 } },
  28617 => { jobs: %w[PLD RUN DRK BST WAR], modifiers: { 'VIT' => 10, 'Defense' => 20, 'Enmity' => 6, 'DamageTaken' => -3, 'FastCast' => 3 } },
  28618 => { jobs: %w[WHM RDM BRD SCH GEO], modifiers: { 'MND' => 9, 'CHR' => 9, 'HealingMagicSkill' => 14, 'CurePotency' => 4, 'FastCast' => 4, 'Refresh' => 2 } },
  28619 => { jobs: %w[SMN SCH GEO RDM], modifiers: { 'INT' => 7, 'MND' => 7, 'SummoningMagicSkill' => 12, 'MagicAccuracy' => 12, 'Refresh' => 2, 'FastCast' => 4 } },
  28620 => { jobs: %w[THF NIN DNC COR BLU], modifiers: { 'DEX' => 8, 'AGI' => 8, 'Accuracy' => 14, 'Evasion' => 12, 'TripleAttack' => 2, 'MovementSpeed' => 6 } },
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

BACK_OVERRIDES.each do |id, override|
  item = items.find { |row| row['id'] == id }
  next unless item

  item['equipment']['jobs'] = override[:jobs]
  item['modifiers'] = override[:modifiers]
  item['strings']['description'] = override[:modifiers].map { |key, value| desc_fragment(key, value) }.join(' ')
  item['design'] ||= {}
  item['design']['back_tuned'] = true
end

File.write(SOURCE, YAML.dump(doc))
