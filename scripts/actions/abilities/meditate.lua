-----------------------------------
-- Ability: Meditate
-- Gradually charges TP.
-- Obtained: Samurai Level 30
-- Recast Time: 3:00 (Can be reduced to 2:30 using Merit Points)
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

    -- Solo Synergy: solo/duo gets bonus TP per tick and +5s duration
    if player:getPartySize() <= 2 and xi.soloSynergy then
        amount   = amount + 8                -- extra TP per tick
        duration = duration + 5             -- longer window to build TP
        local stacks = xi.soloSynergy.getMomentum(player)
        if stacks >= 5 then
            -- Deep focus: Meditate also restores a chunk of MP at high momentum
            xi.soloSynergy.restoreMP(player, xi.soloSynergy.scaledPower(player, 20, 1.0))
        end
        xi.soloSynergy.flash(player, 'Meditate: enhanced TP charge (solo bonus)!')
    end

    player:addStatusEffectEx(xi.effect.MEDITATE, 0, amount, 3, duration)
end

do
    local ss = require("scripts/globals/solo_synergy")
    if not ss or ss == true then ss = xi.soloSynergy end

    local _orig = abilityObject.onUseAbility
    abilityObject.onUseAbility = function(p, t, a)
        ss.onAbilityUse(p, t, a)
        _orig(p, t, a)
        p:setLocalVar('SS_ECHO_STRIKE', 1)
    end
end

return abilityObject

-- Solo Synergy — Samurai (75 Era Strict)
do
    local ss = xi.soloSynergy
    local _orig = abilityObject.onUseAbility
    abilityObject.onUseAbility = function(player, target, ability)
        ss.onAbilityUse(player, target, ability)
        _orig(player, target, ability)
        player:setLocalVar('SS_ECHO_STRIKE', 1)
        ss.flash(player, 'ECHO STRIKE primed: next WS hits twice.')
    end
end
