-----------------------------------
-- Ability: Hagakure
-- Grants "Save TP" effect and a TP bonus to your next weapon skill.
-- Obtained: Samurai Level 95
-- Recast Time: 3:00
-- Duration: 1:00 or Next Weaponskill
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:delStatusEffect(xi.effect.HAGAKURE)

    -- Solo Synergy: Hagakure also restores TP immediately + builds momentum
    -- (the lone samurai makes the most of every sacrifice)
    if player:getPartySize() <= 2 and xi.soloSynergy then
        local tpGrant = math.random(150, 300)
        player:addTP(tpGrant)
        xi.soloSynergy.addMomentum(player, 2)
        xi.soloSynergy.flashMomentum(player)
        xi.soloSynergy.flash(player, string.format('Hagakure: +%d TP, momentum surge (solo)!', tpGrant))
    end

    player:addStatusEffect(xi.effect.HAGAKURE, 1, 0, 60)
end

return abilityObject
