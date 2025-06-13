-----------------------------------
-- Ability: Chakra
-- Cures certain status effects and restores a small amount of HP to user.
-- Obtained: Monk Level 35
-- Recast Time: 5:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)

    -- Level depended att and haste increase 
    local attIncrease = player:getMainJob()
    local attDuration = 290
    local regainAmount = player:getMainJob()
    local regainDuration = 290

    -- Adjust values if main job is MNK 
    if player:getMainJob() == xi.job.MNK then
        accIncrease = player:getMainJob() * 4
        accDuration = 240
        regainAmount = player:getMainJob() * 5
        regainDuration = 240
    end 
    
    --Placeholder for when the Fist of Wu Tang is fully implemented
    --if math.random(0, 100) >= 10 then
    --    player:addStatusEffect(xi.effect.HUNDRED_FISTS, 3, 1, 10)
    --end 

    -- Apply haste and attack increase effects
    player:addStatusEffect(xi.effect.REGAIN, regainAmount, 3, regainDuration, 0, 10, 1)
    player:addMod(xi.mod.ACC, accIncrease, accDuration)

    -- Trigger Chakra ability and return its result
    return xi.job_utils.monk.useChakra(player, target, ability)
end

return abilityObject
