-----------------------------------
-- Ability: Chi Blast
-- Releases Chi to attack an enemy.
-- Obtained: Monk Level 41
-- Recast Time: 3:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    
    local regenAmount = player:getMainJob() * 2
    local regenDuration = 240

    -- Adds regen and regain 
    if player:getMainJob() == xi.job.MNK then
        local regainAmount = player:getMainJob() * 2
        local regainDuration = 240
        regenAmount = player:getMainJob() * 10
        player:addStatusEffect(xi.effect.REGAIN, regainAmount, 3, regainDuration, 0, 10, 1)
        player:addStatusEffect(xi.effect.REGEN, regenAmount, 3, regenDuration, 0, 10, 1)
    end 
 
    return xi.job_utils.monk.useChiBlast(player, target, ability)
end

return abilityObject
