-----------------------------------
-- Ability: Warcry
-- Job: Warrior
-- Adds Att
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    
    local accDuration = 180
    local accIncrease = player:getMainLvl() / 8
    local regainAmount = player:getMainLvl() / 8 

    if player:getMainJob() == xi.job.WAR then
        accIncrease = player:getMainLvl() 
        regainAmount = player:getMainLvl() / 3
        duration = 290
    end 

    player:addMod(xi.mod.REGAIN, regainAmount, 3, duration, 0, 10, 1)
    player:addMod(xi.mod.ACC, accIncrease, 3, accDuration, 3, 10, 1)
    
    return xi.job_utils.warrior.useWarcry(player, target, ability)
end

return abilityObject
