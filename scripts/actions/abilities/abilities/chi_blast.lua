-----------------------------------
-- Ability: Chi Blast
-- Releases Chi to attack an enemy, stuns the target, and drains its TP.
-- Obtained: Monk Level 41
-- Recast Time: 3:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMainJobMonk = player:getMainJob() == xi.job.MNK
    local mainLevel = player:getMainLvl()
    
    -- Set duration (2 minutes = 120 seconds, 4 minutes = 240 seconds for Monks)
    local duration = isMainJobMonk and 240 or 120
    
    -- Calculate regen and regain based on level and job
    local regenAmount, regainAmount
    if mainLevel <= 8 then
        -- Low-level characters (level 8 or below) get fixed +1 regen and regain
        regenAmount = 1
        regainAmount = 1
    elseif isMainJobMonk then
        -- Monks gain higher regen and regain (level / 6, rounded down)
        regenAmount = math.floor(mainLevel / 6)
        regainAmount = math.floor(mainLevel / 6)
    else
        -- Other jobs gain lower regen and regain (level / 8, rounded down)
        regenAmount = math.floor(mainLevel / 8)
        regainAmount = math.floor(mainLevel / 8)
    end
    
    -- Apply stun effect to the target (5 seconds)
    target:addStatusEffect(xi.effect.STUN, 1, 0, 5)
    
    -- Drain all of the target's TP
    target:setTP(0)
    
    -- Apply regen and regain effects to the player
    player:addStatusEffect(xi.effect.REGEN, regenAmount, 3, duration, 0, 10, 1)
    player:addStatusEffect(xi.effect.REGAIN, regainAmount, 3, duration, 0, 10, 1)
    
    -- Trigger the Chi Blast ability and return its result
    return xi.job_utils.monk.useChiBlast(player, target, ability)
end

return abilityObject