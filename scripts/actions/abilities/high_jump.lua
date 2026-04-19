-----------------------------------
-- Ability: High Jump
-- Job: Dragoon
-- Jumping attack + enmity down.
-- Solo bonus: More TP + Regain — the solo DRG keeps the pressure relentless.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local result = xi.job_utils.dragoon.useHighJump(player, target, ability, action)

    local lvl   = player:getMainLvl()
    local isDRG = player:getMainJob() == xi.job.DRG

    local tpGain = isDRG and math.random(200, 350) or math.random(80, 150)
    local regain = isDRG and math.max(2, math.floor(lvl / 14)) or 1

    player:addTP(tpGain)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 30)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'High Jump', string.format('TP +%d  Regain +%d', tpGain, regain))
    end

    return result
end

return abilityObject
