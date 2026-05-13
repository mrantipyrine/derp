#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

SOURCE = File.expand_path('../armor2_custom_reworked.yml', __dir__)

RING_OVERRIDES =
{
  27564 => {
    jobs: %w[WHM RDM SCH BRD SMN GEO],
    modifiers: {
      'MND' => 7, 'CurePotency' => 4, 'FastCast' => 4, 'Refresh' => 1, 'HealingMagicSkill' => 8, 'MagicAccuracy' => 6
    },
  },
  27568 => {
    jobs: %w[BLM RDM SCH GEO SMN],
    modifiers: {
      'INT' => 7, 'MagicAttackBonus' => 12, 'MagicAccuracy' => 10, 'MagicBurstBonus' => 4, 'FastCast' => 2
    },
  },
  27574 => {
    jobs: %w[WHM RDM BRD SMN SCH GEO],
    modifiers: {
      'CHR' => 7, 'MND' => 5, 'FastCast' => 4, 'Refresh' => 2, 'HealingMagicSkill' => 6, 'SummoningMagicSkill' => 6
    },
  },
  28529 => {
    jobs: %w[WAR MNK DRG SAM DRK THF DNC NIN BLU],
    modifiers: {
      'STR' => 6, 'DEX' => 6, 'Attack' => 12, 'Accuracy' => 12, 'StoreTP' => 4, 'CriticalHitRate' => 2
    },
  },
  28547 => {
    jobs: %w[BLM RDM SMN SCH GEO],
    modifiers: {
      'INT' => 6, 'MagicAccuracy' => 12, 'FastCast' => 5, 'MagicBurstBonus' => 3, 'Refresh' => 1
    },
  },
  28549 => {
    jobs: %w[WAR PLD DRK RUN BST DRG],
    modifiers: {
      'VIT' => 7, 'Defense' => 18, 'Enmity' => 5, 'DamageTaken' => -2, 'StoreTP' => 2
    },
  },
  28550 => {
    jobs: %w[BLM RDM SCH GEO],
    modifiers: {
      'INT' => 5, 'MagicAttackBonus' => 10, 'MagicAccuracy' => 8, 'FastCast' => 4, 'Refresh' => 1, 'MagicBurstBonus' => 2
    },
  },
  28553 => {
    jobs: %w[WHM RDM BRD SMN SCH GEO],
    modifiers: {
      'MND' => 6, 'CHR' => 6, 'CurePotency' => 3, 'FastCast' => 3, 'Refresh' => 1, 'SummoningMagicSkill' => 5
    },
  },
  28567 => {
    jobs: %w[WAR PLD DRK RUN BST],
    modifiers: {
      'STR' => 5, 'VIT' => 5, 'Attack' => 10, 'Accuracy' => 8, 'Enmity' => 4, 'DamageTaken' => -2
    },
  },
  28575 => {
    jobs: %w[BLM RDM SMN SCH GEO WHM],
    modifiers: {
      'INT' => 6, 'MND' => 4, 'MagicAttackBonus' => 10, 'MagicAccuracy' => 10, 'FastCast' => 3, 'Refresh' => 1
    },
  },
  28579 => {
    jobs: %w[WHM RDM BRD SMN SCH GEO],
    modifiers: {
      'MND' => 7, 'HealingMagicSkill' => 8, 'CurePotency' => 3, 'FastCast' => 3, 'Refresh' => 1, 'CHR' => 4
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
  key == 'DamageTaken' ? "#{label}#{value}%" : "#{label}+#{value}"
end

doc = YAML.load_file(SOURCE)
items = doc['items']

RING_OVERRIDES.each do |id, override|
  item = items.find { |row| row['id'] == id }
  next unless item

  item['equipment']['jobs'] = override[:jobs]
  item['modifiers'] = override[:modifiers]
  item['strings']['description'] = override[:modifiers].map { |key, value| desc_fragment(key, value) }.join(' ')
  item['design'] ||= {}
  item['design']['ring_tuned'] = true
end

File.write(SOURCE, YAML.dump(doc))
