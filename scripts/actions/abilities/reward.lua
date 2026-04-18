-----------------------------------
-- Ability: Reward
-- Job: Beastmaster
-- Feed pet to restore HP.
-- Solo bonus: Regen to self — the master tends to both beast and body.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.beastmaster.onAbilityCheckReward(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local result = xi.job_utils.beastmaster.onUseAbilityReward(player, target, ability)

    local lvl   = player:getMainLvl()
    local isBST = player:getMainJob() == xi.job.BST
    local regen = isBST and math.max(2, math.floor(lvl / 14)) or 1

    player:addStatusEffect(xi.effect.REGEN, regen, 3, 60)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Reward', string.format('Regen +%d (self)', regen))
    end

    return result
end

return abilityObject
