-----------------------------------
-- Ability: Warding Circle
-- Grants resistance, defense, and attack against Demons to party members within the area of effect.
-- Obtained: Samurai Level 5
-- Recast Time: 5:00 minutes
-- Duration: 3:00 minutes
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local duration = 180 + player:getMod(xi.mod.WARDING_CIRCLE_DURATION)
    local power    = 5

    if player:getMainJob() == xi.job.SAM then
        power = 15
    end

    -- Solo Synergy: solo SAM gets DEF/ATT bonus and Regen instead of relying on party buff
    if player:getPartySize() <= 2 and xi.soloSynergy then
        duration = duration + 60
        player:addStatusEffect(xi.effect.REGEN, xi.soloSynergy.scaledPower(player, 2, 0.1), 3, 90)
        player:addStatusEffect(xi.effect.DEF_BONUS, 10, 0, 90)
        xi.soloSynergy.flash(player, 'Warding Circle: self-fortified (solo bonus)!')
    end

    target:addStatusEffect(xi.effect.WARDING_CIRCLE, power, 0, duration)
end

return abilityObject
