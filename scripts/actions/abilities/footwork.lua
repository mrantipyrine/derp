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
    
    -- Calculate attack, damage, and kick damage boosts (scale 5-10 from level 65-75)
    local attackIncrease, damageIncrease, kickDamage
    if mainLevel <= 8 then
        -- Low-level characters get fixed +1 for all boosts
        attackIncrease = 1
        damageIncrease = 1
        kickDamage = 1
    elseif isMainJobMonk then
        -- Monks scale from 5 to 10 over levels 65-75
        attackIncrease = math.floor(math.max(1, math.min(10, 5 + (mainLevel - 65) * 0.5)))
        damageIncrease = math.floor(math.max(1, math.min(10, 5 + (mainLevel - 65) * 0.5)))
        kickDamage = math.floor(math.max(1, math.min(10, 5 + (mainLevel - 65) * 0.5)))
    else
        -- Other jobs scale from 3 to 6 over levels 65-75
        attackIncrease = math.floor(math.max(1, math.min(7, 3 + (mainLevel - 65) * 0.3)))
        damageIncrease = math.floor(math.max(1, math.min(7, 3 + (mainLevel - 65) * 0.3)))
        kickDamage = math.floor(math.max(1, math.min(7, 3 + (mainLevel - 65) * 0.3)))
    end
    
    -- Apply accuracy, attack, damage, and kick damage boosts
    player:addMod(xi.mod.ACC, accuracyIncrease, 3, duration, 0, 10, 1)
    player:addMod(xi.mod.ATT, attackIncrease, 3, duration, 0, 10, 1)
    player:addMod(xi.mod.DMG, damageIncrease, 3, duration, 0, 10, 1)
    player:addMod(xi.mod.KICK_DMG, kickDamage, 3, duration, 0, 10, 1)
    
    -- Trigger the Focus ability
    xi.job_utils.monk.useFocus(player, target, ability)
end

return abilityObject