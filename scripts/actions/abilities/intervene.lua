-----------------------------------
-- Ability: Intervene
-- Description: Strikes the target with your shield and decreases its attack and accuracy.
-- Obtained: PLD Level 96
-- Recast Time: 01:00:00
-- Duration: 00:00:30
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.paladin.checkIntervene(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    return xi.job_utils.paladin.useIntervene(player, target, ability)
    -- Solo bonus
    local isWHM = player:getMainJob() == xi.job.WHM
    local lvl = player:getMainLvl()
    local mndBonus = isWHM and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regen    = isWHM and math.max(2, math.floor(lvl / 20)) or 1
    player:addMod(xi.mod.MND, mndBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 30)
    player:timer(30000, function(p) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Intervene', string.format('MND +%d  Regen +%d', mndBonus, regen))
    end
end

return abilityObject
