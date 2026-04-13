-----------------------------------
-- Ability: Third Eye
-- Anticipates and dodges the next attack directed at you.
-- Obtained: Samurai Level 15
-- Recast Time: 1:00
-- Duration: 0:30
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:hasStatusEffect(xi.effect.SEIGAN) then
        ability:setRecast(ability:getRecast() / 2)
    end

    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    if
        player:hasStatusEffect(xi.effect.COPY_IMAGE) or
        player:hasStatusEffect(xi.effect.BLINK)
    then
        -- Returns "no effect" message when Copy Image is active when Third Eye is used.
        ability:setMsg(xi.msg.basic.JA_NO_EFFECT)
    else
        -- Solo Synergy: Third Eye grants brief Haste burst + extends duration with Seigan
        local duration = 30
        if player:getPartySize() <= 2 and xi.soloSynergy then
            duration = 45
            player:addStatusEffect(xi.effect.HASTE, 8, 0, 20)   -- brief burst of footwork
            xi.soloSynergy.addMomentum(player, 1)               -- situational awareness = focus
            xi.soloSynergy.flashMomentum(player)
        end
        player:addStatusEffect(xi.effect.THIRD_EYE, 0, 0, duration)
    end
end

return abilityObject
