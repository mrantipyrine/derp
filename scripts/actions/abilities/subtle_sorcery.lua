-----------------------------------
-- Ability: Subtle Sorcery
-- Description: Reduces the amount of enmity generated from magic spells and increases magic accuracy.
-- Obtained: BLM Level 96
-- Recast Time: 01:00:00
-- Duration: 00:01:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.black_mage.checkSubtleSorcery(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.black_mage.useSubtleSorcery(player, target, ability)
    -- Solo bonus
    local isSCH = player:getMainJob() == xi.job.SCH
    local lvl = player:getMainLvl()
    local intBonus = isSCH and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local mndBonus = isSCH and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Subtle Sorcery', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
