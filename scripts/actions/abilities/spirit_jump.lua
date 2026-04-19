-----------------------------------
-- Ability: Spirit Jump
-- Job: Dragoon
-- Jump attack + enmity down, enhanced with wyvern.
-- Solo bonus: TP + Regen — wyvern and rider in sync.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local result = xi.job_utils.dragoon.useSpiritJump(player, target, ability, action)

    local lvl   = player:getMainLvl()
    local isDRG = player:getMainJob() == xi.job.DRG

    local tpGain = isDRG and math.random(180, 320) or math.random(70, 140)
    local regen  = isDRG and math.max(2, math.floor(lvl / 14)) or 1

    player:addTP(tpGain)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 30)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Spirit Jump', string.format('TP +%d  Regen +%d', tpGain, regen))
    end

    return result
end

return abilityObject
