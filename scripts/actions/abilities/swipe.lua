-----------------------------------
-- Ability: Swipe
-- Expends a single rune to deal damage to a target.
-- Obtained: Rune Fencer Level 25
-- Recast Time: 1:30
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:getAnimation() ~= 1 then
        return xi.msg.basic.REQUIRES_COMBAT, 0
    end

    return xi.job_utils.rune_fencer.checkHaveRunes(player)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local result = xi.job_utils.rune_fencer.useSwipeLunge(player, target, ability, action)

    -- Solo bonus: small TP refund to maintain melee pressure
    local isRUN = player:getMainJob() == xi.job.RUN
    local tpGain = isRUN and math.random(200, 400) or math.random(80, 150)
    player:addTP(tpGain)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Swipe', string.format('TP +%d', tpGain))
    end

    return result
end

return abilityObject
