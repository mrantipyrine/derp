-----------------------------------
-- Ability: Focus
-- Enhances user's accuracy.
-- Obtained: Monk Level 25
-- Recast Time: 5:00
-- Duration: 2:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    -- Set default TP gain
    local tpGain = 250
    
    -- Determine triple attack based on main job level and if main job is MNK
    local tripleAttack = player:getMainJob() == xi.job.MNK and player:getMainLvl() % 2 or (player:getMainLvl() >= 25 and 1 or player:getMainLvl() % 5)
    
    -- Increase TP gain and add status effect if main job is MNK
    if player:getMainJob() == xi.job.MNK then
        -- this will increase with Focus of White Lotus 
        
        tpGain = 1000
        local counterIncrease = player:getMainLvl() * 2
        local counterDuration = player:getMainLvl() * 2
        player:addStatusEffect(xi.effect.COUNTER_BOOST, counterIncrease, 3, counterDuration, 0, 10, 1)
        player:addMod(xi.mod.TRIPLE_ATTACK, 30, 3, 300, 0, 10, 1)
        
    end 
    
    -- Add triple attack mod and grant TP to the player
    player:addTP(tpGain)

    xi.job_utils.monk.useFocus(player, target, ability)
end

return abilityObject
