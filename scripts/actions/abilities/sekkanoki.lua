-----------------------------------
-- Ability: Sekkanoki
-- Limits TP cost of next weapon skill to 100.
-- Obtained: Samurai Level 40
-- Recast Time: 0:05:00
-- Duration: 01:00, or until a weapon skill is used
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:delStatusEffect(xi.effect.SEKKANOKI)
    target:addStatusEffect(xi.effect.SEKKANOKI, 1, 0, 60)
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
    end
end
