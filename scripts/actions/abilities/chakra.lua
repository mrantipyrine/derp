-----------------------------------
-- Ability: Chakra
-- Cures certain status effects and restores a small amount of HP to user.
-- Obtained: Monk Level 35
-- Recast Time: 5:00
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
    
    -- Calculate vitality, attack, accuracy, and regain based on level and job
    local vitIncrease, attackIncrease, accuracyIncrease, regainAmount
    if isMainJobMonk then
        -- Monks gain higher boosts (level / 6, rounded down)
        vitIncrease = math.floor(mainLevel / 6)
        attackIncrease = math.floor(mainLevel / 6)
        accuracyIncrease = math.floor(mainLevel / 6)
        regainAmount = math.floor(mainLevel / 6)
    else
        -- Other jobs gain lower boosts (level / 8, rounded down)
        vitIncrease = math.floor(mainLevel / 8)
        attackIncrease = math.floor(mainLevel / 8)
        accuracyIncrease = math.floor(mainLevel / 8)
        regainAmount = math.floor(mainLevel / 8)
    end
    
    -- Restore HP for Monks
    if isMainJobMonk then
        local hpRestorePercent = math.random(30, 80)
        local lostHP = player:getMaxHP() - player:getHP()
        local hpToRestore = math.floor(lostHP * hpRestorePercent / 100)
        player:setHP(player:getHP() + hpToRestore)
    end
    
    -- Cure status effects (Blind, Poison, Paralyze)
    player:delStatusEffect(xi.effect.BLINDNESS)
    player:delStatusEffect(xi.effect.POISON)
    player:delStatusEffect(xi.effect.PARALYSIS)
    
    -- Apply vitality, attack, accuracy, and regain effects
    player:addMod(xi.mod.VIT, vitIncrease, 3, duration, 0, 10, 1)
    player:addMod(xi.mod.ATT, attackIncrease, 3, duration, 0, 10, 1)
    player:addMod(xi.mod.ACC, accuracyIncrease, 3, duration, 0, 10, 1)
    player:addStatusEffect(xi.effect.REGAIN, regainAmount, 3, duration, 0, 10, 1)
    
    -- Trigger the Chakra ability and return its result
    return xi.job_utils.monk.useChakra(player, target, ability)
end

return abilityObject