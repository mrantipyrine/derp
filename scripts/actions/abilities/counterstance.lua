-----------------------------------
-- Ability: Counterstance
-- Increases chance to counter but lowers defense.
-- Obtained: Monk Level 45
-- Recast Time: 5:00
-- Duration: 5:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMainJobMonk = player:getMainJob() == xi.job.MNK
    local mainLevel = player:getMainLvl()
    
    -- Set durations (5 minutes = 300 seconds for core effects, 60 seconds for attack chances)
    local coreDuration = 300
    local attackDuration = 60
    
    -- Calculate evasion, kick rate, kick damage, and counter boost based on level and job
    local evasionIncrease, kickRate, kickDamage, counterBoost
    if mainLevel <= 8 then
        -- Low-level characters (level 8 or below) get fixed +1 for all boosts
        evasionIncrease = 1
        kickRate = 1
        kickDamage = 1
        counterBoost = 1
    elseif isMainJobMonk then
        -- Monks gain higher boosts (level / 6, rounded down)
        evasionIncrease = math.floor(mainLevel / 6)
        kickRate = math.floor(mainLevel / 6)
        kickDamage = math.floor(mainLevel / 6)
        counterBoost = math.floor(mainLevel / 6)
    else
        -- Other jobs gain lower boosts (level / 8, rounded down)
        evasionIncrease = math.floor(mainLevel / 8)
        kickRate = math.floor(mainLevel / 8)
        kickDamage = math.floor(mainLevel / 8)
        counterBoost = math.floor(mainLevel / 8)
    end
    
    -- Scale counter boost by 2 per counter rate merit
    local meritBonus = player:getMerit(xi.merit.COUNTER_RATE) * 2
    counterBoost = counterBoost + meritBonus
    
    -- Apply defense penalty (25% reduction for Monks, 15% for non-Monks)
    local defensePenalty = isMainJobMonk and -25 or -15
    
    -- Apply core effects
    player:addStatusEffect(xi.effect.EVASION_BOOST, evasionIncrease, 3, coreDuration, 0, 10, 1)
    player:addMod(xi.mod.KICK_ATTACK_RATE, kickRate, 3, coreDuration, 0, 10, 1)
    player:addMod(xi.mod.KICK_DMG, kickDamage, 3, coreDuration, 0, 10, 1)
    player:addStatusEffect(xi.effect.COUNTER_BOOST, counterBoost, 3, coreDuration, 0, 10, 1)
    player:addMod(xi.mod.DEF, defensePenalty, 3, coreDuration)
    
    -- Apply attack chance effects (1% quad, 5% triple, 10% double for 60 seconds)
    player:addMod(xi.mod.QUAD_ATTACK, 1, 3, attackDuration, 0, 10, 1)
    player:addMod(xi.mod.TRIPLE_ATTACK, 5, 3, attackDuration, 0, 10, 1)
    player:addMod(xi.mod.DOUBLE_ATTACK, 10, 3, attackDuration, 0, 10, 1)
    
    -- Trigger the Counterstance ability
    xi.job_utils.monk.useCounterstance(player, target, ability)
end

return abilityObject