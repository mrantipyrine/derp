-----------------------------------
-- Ability: Deep Breathing
-- Job: Dragoon
-- Enhances next wyvern breath.
-- Solo bonus: Regen to player — rider steadies their own breath too.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dragoon.abilityCheckDeepBreathing(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dragoon.useDeepBreathing(player, target, ability)

    local lvl   = player:getMainLvl()
    local isDRG = player:getMainJob() == xi.job.DRG

    local regen = isDRG and math.max(3, math.floor(lvl / 12)) or math.max(1, math.floor(lvl / 22))

    player:addStatusEffect(xi.effect.REGEN, regen, 3, 180)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Deep Breathing', string.format('Regen +%d (rider)', regen))
    end
end

return abilityObject
