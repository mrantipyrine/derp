-----------------------------------
-- Ability: Steal
-- Steal items from enemy.
-- Obtained: Thief Level 5
-- Recast Time: 5:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.thief.checkSteal(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability, action)

    local level = player:getMainLvl()
    local acc = (level >= 50 and level * 4 or level * 2) or math.floor(level / 2) 
    local att = (level >= 50 and level * 4 or level * 2) or math.floor(level / 2) 
    local duration = 320 
    local evasion  = level * 4 
    local tp = math.random(1000, 2000)

    if player:getMainJob() == xi.job.THF then
        player:addMod(xi.mod.ACC, acc, 3, duration, 3, 10, 1)
        player:addMod(xi.mod.ATT, att, 3, duration, 3, 10, 1)
        player:addStatusEffect(xi.effect.EVASION_BOOST, evasion, 3, duration, 0, 10, 1)
        player:addTP(tp)
    end 
    
    return xi.job_utils.thief.useSteal(player, target, ability, action)
end

return abilityObject
                           
