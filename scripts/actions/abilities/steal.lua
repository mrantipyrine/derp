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
    local duration = 320
    local equippedNECK = player:getEquipID(xi.slot.NECK)

    -- Stat multiplier: 10 at level 5, +1 per level above 5
    local statMultiplier = 10 + math.max(0, level - 5)
    local acc = level * statMultiplier
    local att = acc
    local evasion = level * 4
    local regain = math.random(10, 50)

    if player:getMainJob() == xi.job.THF then
        -- Temporary stat boosts for Thief main job
        player:addStatusEffect(xi.effect.EVASION_BOOST, evasion, 3, duration, 0, 10, 1)
        player:addStatusEffect(xi.effect.REGAIN, regain, 0, duration)
    end

    if equippedNECK == 13112 then 
        local dexIncrease = target:getMainLvl()
        local agiIncrease = target:getMainLvl()
        local neckDuration = 180

        player:addStatusEffect(xi.effect.DEX_BOOST, dexIncrease, 0, neckDuration, 0, 0, 0)
        player:addStatusEffect(xi.effect.AGI_BOOST, agiIncrease, 0, neckDuration, 0, 0, 0)
    end

    return xi.job_utils.thief.useSteal(player, target, ability, action)
end

return abilityObject
