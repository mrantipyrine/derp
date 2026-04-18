-----------------------------------
-- Ability: Boost
-- Job: Monk
-- Pre-hit ritual: charges STR and TP. No HP restore — that's Chakra's job.
-- Rewards planning: use it, then throw a hard weaponskill.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMNK = player:getMainJob() == xi.job.MNK

    -- Core Boost WS damage bonus
    xi.job_utils.monk.useBoost(player, target, ability)

    -- STR: feels punchy on MNK, still worth it on sub
    local strBoost = isMNK and math.random(14, 20) or math.random(7, 11)
    player:addStatusEffect(xi.effect.STR_BOOST, strBoost, 0, 180, 0, 0, 0)

    -- TP: get to your next WS faster, not loop forever
    local tpGain = isMNK and math.random(400, 700) or math.random(100, 300)
    player:addTP(tpGain)
end

return abilityObject
