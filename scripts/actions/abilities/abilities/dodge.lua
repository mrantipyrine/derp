-----------------------------------
-- Ability: Dodge
-- Enhances user's evasion.
-- Obtained: Monk Level 15
-- Recast Time: 5:00
-- Duration: 2:00 (4:50 for Monks)
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMainJobMonk = player:getMainJob() == xi.job.MNK
    local mainLevel = player:getMainLvl()
    
    -- Set duration (2 minutes = 120 seconds, 4:50 = 290 seconds for Monks)
    local duration = isMainJobMonk and 290 or 120
    
    -- Calculate evasion and HP boost based on level and job
    local evasionIncrease, hpBoostPower
    if mainLevel <= 8 then
        -- Low-level characters (level 8 or below) get fixed +10 evasion and +10% max HP
        evasionIncrease = 10
        hpBoostPower = isMainJobMonk and 10 or 0
    elseif isMainJobMonk then
        -- Monks gain higher evasion and HP boost (level * 8/3, rounded down, capped at 200)
        evasionIncrease = math.min(math.floor(mainLevel * 8 / 3), 200)
        hpBoostPower = math.min(math.floor(mainLevel * 8 / 3), 200)
    else
        -- Other jobs gain lower evasion boost (level * 2, rounded down) and no HP boost
        evasionIncrease = math.floor(mainLevel * 2)
        hpBoostPower = 0
    end

    -- Apply max HP boost for Monks if applicable
    if hpBoostPower > 0 then
        -- Increase maximum HP by hpBoostPower% for the duration
        player:addStatusEffect(xi.effect.MAX_HP_BOOST, hpBoostPower, 1, duration)
    end

    -- Apply evasion boost
    player:addStatusEffect(xi.effect.EVASION_BOOST, evasionIncrease, 3, duration)

    -- Trigger the Dodge ability
    xi.job_utils.monk.useDodge(player, target, ability)
end

return abilityObject