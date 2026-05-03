-----------------------------------
-- Ability: Meditate
-- Gradually charges TP.
-- Obtained: Samurai Level 30
-- Recast Time: 3:00 (reducible via merits)
-- Duration: 15 seconds
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local amount   = 12
    local duration = 15 + player:getMod(xi.mod.MEDITATE_DURATION)

    if player:getMainJob() == xi.job.SAM then
        amount = 20
    end

    -- Solo/duo bonus: +5 TP/tick and +5s window (down from +8, still meaningful)
    if player:getPartySize() <= 2 and xi.soloSynergy then
        amount   = amount + 5
        duration = duration + 5
        local stacks = xi.soloSynergy.getMomentum(player)
        if stacks >= 5 then
            xi.soloSynergy.restoreMP(player, xi.soloSynergy.scaledPower(player, 20, 1.0))
        end
        xi.soloSynergy.flash(player, 'Meditate: enhanced TP charge (solo bonus)!')
    end

    -- Prime Echo Strike once per Meditate use (single do-block, no double-wrap)
    if xi.soloSynergy then
        xi.soloSynergy.onAbilityUse(player, target, ability)
        player:setLocalVar('SS_ECHO_STRIKE', 1)
    end

    player:addStatusEffectEx(xi.effect.MEDITATE, 0, amount, 3, duration)
end

return abilityObject
