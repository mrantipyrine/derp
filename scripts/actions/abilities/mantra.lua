-----------------------------------
-- Ability: Mantra
-- Increases the max. HP of party members within area of effect, boosts VIT, STR, evasion, counter, and grants an Enspell effect.
-- Obtainable: Monk Level 75
-- Recast Time: 0:10:00
-- Duration: 0:03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMainJobMonk = player:getMainJob() == xi.job.MNK
    local mainLevel = player:getMainLvl()
    
    -- Set duration (3 minutes = 180 seconds)
    local duration = 180
    
    -- Calculate boosts based on level and job
    local vitIncrease, strIncrease, evasionIncrease, counterBoost, hpBoost
    if mainLevel <= 8 then
        -- Low-level characters (level 8 or below) get fixed +1 for all boosts
        vitIncrease = 1
        strIncrease = 1
        evasionIncrease = 1
        counterBoost = 1
        hpBoost = 1
    elseif isMainJobMonk then
        -- Monks gain higher boosts (level / 6, rounded down)
        vitIncrease = math.floor(mainLevel / 6)
        strIncrease = math.floor(mainLevel / 6)
        evasionIncrease = math.floor(mainLevel / 6)
        counterBoost = math.floor(mainLevel / 6)
        hpBoost = math.floor(mainLevel / 6)
    else
        -- Other jobs gain lower boosts (level / 8, rounded down)
        vitIncrease = math.floor(mainLevel / 8)
        strIncrease = math.floor(mainLevel / 8)
        evasionIncrease = math.floor(mainLevel / 8)
        counterBoost = math.floor(mainLevel / 8)
        hpBoost = math.floor(mainLevel / 8)
    end
    
    -- Determine Enspell effect based on game day
    local enspellEffect
    local dayElement = VanadielDayElement()
    if dayElement == 6 or dayElement == 7 then
        -- Light or Dark day: random Enspell (Fire, Ice, Wind, Earth, Thunder, Water)
        dayElement = math.random(0, 5)
    end
    local enspellEffects = {
        [0] = xi.effect.ENFIRE,
        [1] = xi.effect.ENBLIZZARD,
        [2] = xi.effect.ENAERO,
        [3] = xi.effect.ENSTONE,
        [4] = xi.effect.ENTHUNDER,
        [5] = xi.effect.ENWATER
    }
    enspellEffect = enspellEffects[dayElement]
    local enspellPower = math.floor(mainLevel / 10)
    
    -- Apply effects to party members in range
    for _, member in ipairs(player:getParty()) do
        if member:isAlive() and member:getDistance(player) <= 10 then
            -- Apply VIT, STR, evasion, counter, and max HP boosts
            member:addMod(xi.mod.VIT, vitIncrease, 3, duration, 0, 10, 1)
            member:addMod(xi.mod.STR, strIncrease, 3, duration, 0, 10, 1)
            member:addStatusEffect(xi.effect.EVASION_BOOST, evasionIncrease, 3, duration, 0, 10, 1)
            member:addStatusEffect(xi.effect.COUNTER_BOOST, counterBoost, 3, duration, 0, 10, 1)
            member:addStatusEffect(xi.effect.MAX_HP_BOOST, hpBoost, 3, duration, 0, 10, 1)
            -- Apply Enspell effect
            member:addStatusEffect(enspellEffect, enspellPower, 3, duration, 0, 10, 1)
        end
    end
    
    -- Trigger the Mantra ability and return its result
    return xi.job_utils.monk.useMantra(player, target, ability)
end

return abilityObject