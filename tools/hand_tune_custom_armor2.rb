#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

SOURCE = File.expand_path('../armor2_custom_reworked.yml', __dir__)

OVERRIDES =
{
  23252 => {
    jobs: %w[WAR DRG DRK],
    modifiers: {
      'STR' => 12, 'VIT' => 8, 'Attack' => 24, 'Accuracy' => 18, 'StoreTP' => 5, 'DoubleAttack' => 3
    },
  },
  23253 => {
    jobs: %w[THF NIN DNC],
    modifiers: {
      'DEX' => 11, 'AGI' => 11, 'Accuracy' => 18, 'Evasion' => 20, 'CriticalHitRate' => 4, 'TripleAttack' => 2
    },
  },
  23259 => {
    jobs: %w[MNK NIN SAM],
    modifiers: {
      'STR' => 10, 'DEX' => 8, 'Accuracy' => 16, 'StoreTP' => 7, 'SubtleBlow' => 7, 'CriticalHitDamage' => 4
    },
  },
  23260 => {
    jobs: %w[WHM RDM SCH],
    modifiers: {
      'MND' => 12, 'CHR' => 10, 'HealingMagicSkill' => 15, 'CurePotency' => 5, 'FastCast' => 5, 'Refresh' => 2
    },
  },
  23261 => {
    jobs: %w[WAR PLD RUN],
    modifiers: {
      'VIT' => 12, 'Defense' => 28, 'Enmity' => 7, 'DamageTaken' => -4, 'Accuracy' => 10, 'StoreTP' => 3
    },
  },
  23262 => {
    jobs: %w[WAR BST DRG],
    modifiers: {
      'STR' => 11, 'VIT' => 9, 'Attack' => 20, 'Accuracy' => 16, 'DoubleAttack' => 4, 'CriticalHitRate' => 3
    },
  },
  23393 => {
    jobs: %w[WAR PLD RUN],
    modifiers: {
      'VIT' => 10, 'MND' => 8, 'Defense' => 24, 'Enmity' => 7, 'DamageTaken' => -3, 'FastCast' => 3
    },
  },
  23413 => {
    jobs: %w[BLM RDM GEO],
    modifiers: {
      'INT' => 12, 'MagicAttackBonus' => 18, 'MagicAccuracy' => 16, 'MagicBurstBonus' => 5, 'FastCast' => 4
    },
  },
  23418 => {
    jobs: %w[WHM BRD SMN],
    modifiers: {
      'CHR' => 10, 'MND' => 10, 'SummoningMagicSkill' => 12, 'HealingMagicSkill' => 10, 'FastCast' => 5, 'Refresh' => 2
    },
  },
  23423 => {
    jobs: %w[MNK NIN SAM],
    modifiers: {
      'STR' => 9, 'DEX' => 9, 'Accuracy' => 20, 'StoreTP' => 5, 'SubtleBlow' => 6, 'CriticalHitRate' => 3
    },
  },
  23511 => {
    jobs: %w[RDM SMN SCH],
    modifiers: {
      'INT' => 8, 'MND' => 8, 'MagicAccuracy' => 12, 'FastCast' => 6, 'SummoningMagicSkill' => 14, 'Refresh' => 2
    },
  },
  23512 => {
    jobs: %w[WHM RDM SCH],
    modifiers: {
      'MND' => 10, 'CHR' => 6, 'HealingMagicSkill' => 14, 'MagicAccuracy' => 10, 'CurePotency' => 4, 'FastCast' => 5
    },
  },
  27536 => {
    jobs: %w[BLM RDM SMN SCH GEO],
    modifiers: {
      'INT' => 7, 'SummoningMagicSkill' => 12, 'MagicBurstBonus' => 4, 'MagicAccuracy' => 14, 'Refresh' => 1
    },
  },
  28618 => {
    jobs: %w[WHM RDM BRD SMN SCH GEO],
    modifiers: {
      'MND' => 10, 'CHR' => 8, 'HealingMagicSkill' => 14, 'CurePotency' => 4, 'FastCast' => 4, 'Refresh' => 2
    },
  },
  26014 => {
    jobs: %w[THF RNG COR DNC BLU],
    modifiers: {
      'DEX' => 7, 'AGI' => 9, 'Accuracy' => 16, 'RangedAccuracy' => 18, 'StoreTP' => 4, 'CriticalHitRate' => 3
    },
  },
  27537 => {
    jobs: %w[WHM BLM RDM BRD SMN SCH GEO],
    modifiers: {
      'INT' => 8, 'MagicAttackBonus' => 16, 'MagicAccuracy' => 12, 'FastCast' => 3, 'Refresh' => 1
    },
  },
  28451 => {
    jobs: %w[BLM RDM SMN SCH GEO],
    modifiers: {
      'INT' => 7, 'MND' => 7, 'SummoningMagicSkill' => 12, 'MagicAccuracy' => 12, 'FastCast' => 4, 'Refresh' => 1
    },
  },
  28430 => {
    jobs: %w[RDM SMN SCH GEO],
    modifiers: {
      'INT' => 6, 'MND' => 6, 'MagicAccuracy' => 10, 'FastCast' => 6, 'StoreTP' => 3, 'Refresh' => 1
    },
  },
  27538 => {
    jobs: %w[WAR MNK DRG SAM DRK PLD RUN BST],
    modifiers: {
      'STR' => 7, 'DEX' => 5, 'Attack' => 18, 'Accuracy' => 14, 'DoubleAttack' => 2, 'SubtleBlow' => 3
    },
  },
  27539 => {
    jobs: %w[BLM RDM SMN SCH GEO],
    modifiers: {
      'INT' => 6, 'MND' => 6, 'MagicAccuracy' => 14, 'FastCast' => 4, 'MagicBurstBonus' => 3, 'Refresh' => 1
    },
  },
  27564 => {
    jobs: %w[WHM BLM RDM BRD SMN SCH GEO],
    modifiers: {
      'INT' => 6, 'MND' => 6, 'MagicAccuracy' => 10, 'FastCast' => 4, 'Refresh' => 1, 'CurePotency' => 3
    },
  },
  28529 => {
    jobs: %w[WAR MNK SAM DRG DRK THF DNC RNG NIN BLU],
    modifiers: {
      'STR' => 6, 'DEX' => 6, 'Attack' => 12, 'Accuracy' => 12, 'StoreTP' => 4, 'CriticalHitRate' => 2
    },
  },
  28549 => {
    jobs: %w[WAR PLD DRK RUN BST DRG],
    modifiers: {
      'VIT' => 7, 'Defense' => 18, 'Enmity' => 5, 'DamageTaken' => -2, 'StoreTP' => 2
    },
  },
  28575 => {
    jobs: %w[WHM BLM RDM BRD SMN SCH GEO],
    modifiers: {
      'INT' => 5, 'MND' => 5, 'MagicAttackBonus' => 10, 'MagicAccuracy' => 10, 'FastCast' => 3, 'Refresh' => 1
    },
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
  if key == 'DamageTaken'
    "#{label}#{value}%"
  else
    "#{label}+#{value}"
  end
end

doc = YAML.load_file(SOURCE)
items = doc['items']

OVERRIDES.each do |id, override|
  item = items.find { |row| row['id'] == id }
  next unless item

  item['equipment']['jobs'] = override[:jobs]
  item['modifiers'] = override[:modifiers]
  item['strings']['description'] = override[:modifiers].map { |key, value| desc_fragment(key, value) }.join(' ')
  item['design'] ||= {}
  item['design']['hand_tuned'] = true
end

File.write(SOURCE, YAML.dump(doc))
