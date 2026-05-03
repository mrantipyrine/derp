-----------------------------------
-- Ability: Double Up
-- Enhances an active Phantom Roll effect that is eligible for Double-Up.
-- Obtained: Corsair Level 5
-- Recast Time: 8 seconds
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.corsair.onDoubleUpAbilityCheck(player, target, ability)
end

abilityObject.onUseAbility = function(caster, target, ability, action)
    local result = xi.job_utils.corsair.useDoubleUp(caster, target, ability, action)

    -- Solo bonus: TP on each double-up to reward pressing the roll advantage
    local isCOR  = caster:getMainJob() == xi.job.COR
    local tpGain = isCOR and math.random(150, 300) or math.random(50, 120)
    caster:addTP(tpGain)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(caster, 'Double-Up', string.format('TP +%d', tpGain))
    end

    return result
end

return abilityObject
