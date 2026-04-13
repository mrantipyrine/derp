-----------------------------------
-- Ability: Hasso
-- Grants a bonus to attack speed, accuracy, and Strength when using two-handed weapons, but increases recast and casting times.
-- Obtained: Samurai Level 25
-- Recast Time: 1:00
-- Duration: 5:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if not target:isWeaponTwoHanded() then
        return xi.msg.basic.NEEDS_2H_WEAPON, 0
    end

    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local strboost = 0

    if target:getMainJob() == xi.job.SAM then
        strboost = (target:getMainLvl() / 7) + target:getJobPointLevel(xi.jp.HASSO_EFFECT)
    elseif target:getSubJob() == xi.job.SAM then
        strboost = target:getSubLvl() / 7
    end

    if strboost > 0 then
        target:delStatusEffect(xi.effect.HASSO)
        target:delStatusEffect(xi.effect.SEIGAN)

        -- Solo Synergy: Hasso extends 60s and grants bonus ATT
        local duration = 300
        if player:getPartySize() <= 2 and xi.soloSynergy then
            duration = 360
            local attBonus = xi.soloSynergy.scaledPower(player, 10, 0.5)
            player:addStatusEffect(xi.effect.ATT_BOOST, attBonus, 0, 360)
            xi.soloSynergy.flash(player, 'Hasso: extended + ATT (solo bonus)!')
        end

        target:addStatusEffect(xi.effect.HASSO, strboost, 0, duration)
    end
end

return abilityObject
