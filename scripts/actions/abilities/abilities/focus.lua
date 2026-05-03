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
    local isMainJobMonk = player:getMainJob() == xi.job.MNK
    local mainLevel = player:getMainLvl()
    
    -- Set duration (2 minutes = 120 seconds)
    local duration = 120
    
    -- Calculate accuracy boost based on level and job
    local accuracyIncrease
    if mainLevel <= 8 then
        -- Low-level characters (level 8 or below) get fixed +1 accuracy
        accuracyIncrease = 1
    elseif isMainJobMonk then
        -- Monks gain higher accuracy boost (level / 6, rounded down)
        accuracyIncrease = math.floor(mainLevel / 6)
    else
        -- Other jobs gain lower accuracy boost (level / 8, rounded down)
        accuracyIncrease = math.floor(mainLevel / 8)
    end
    
    -- Add +30 accuracy if Temple Crown is equipped
    if player:getEquipID(xi.slot.HEAD) == xi.item.TEMPLE_CROWN then
        accuracyIncrease = accuracyIncrease + 30
    end
    
    -- Apply accuracy boost (persists even if Temple Crown is unequipped)
    player:addStatusEffect(xi.effect.ACCURACY_BOOST, accuracyIncrease, 3, duration)
    
    -- Set TP gain based on job
    local tpGain = isMainJobMonk and 1000 or 250
    player:addTP(tpGain)
    
    -- Apply Monk-specific effects
    if isMainJobMonk then
        -- Apply counter boost (power scales with level)
        local counterPower = mainLevel * 2
        player:addStatusEffect(xi.effect.COUNTER_BOOST, counterPower, 3, duration, 0, 10, 1)
        
        -- Apply triple attack boost (30% for Monks)
        player:addMod(xi.mod.TRIPLE_ATTACK, 30, 3, duration, 0, 10, 1)
    else
        -- Apply triple attack boost (10% for non-Monks at level 25+)
        if mainLevel >= 25 then
            player:addMod(xi.mod.TRIPLE_ATTACK, 10, 3, duration, 0, 10, 1)
        end
    end
    
    -- Trigger the Focus ability
    xi.job_utils.monk.useFocus(player, target, ability)
end

return abilityObject