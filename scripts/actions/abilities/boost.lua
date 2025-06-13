-- Ability: Boost
-- Enhances user's next attack.
-- Obtained: Monk Level 5
-- Recast Time: 0:15
-- Duration: 3:00
-- Increase TP / STR 
-- If main job is MNK the increase is greater and 30-80% of HP is restored
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.monk.useBoost(player, target, ability)

    -- Restore HP based on job
    local hpRestorePercent = player:getMainJob() == xi.job.MNK and math.random(30, 80) or 0
    local lostHP = player:getMaxHP() - player:getHP()
    local hpToRestore = math.floor(lostHP * hpRestorePercent / 100)
    player:setHP(player:getHP() + hpToRestore)

    -- Increase TP
    player:addTP(player:getMainJob() == xi.job.MNK and math.random(700, 1400) or math.random(100, 700))

    -- Increase STR
    local strIncrease = player:getMainLvl() <= 8 and 1 or player:getMainJob() == xi.job.MNK and player:getMainLvl() / 6 or player:getMainLvl() / 8

    -- Apply status effect
    local duration = 19
    -- 3 minutes in seconds
    player:addStatusEffect(xi.effect.STR_BOOST, strIncrease, 0, duration, 0, 0, 0)
end

return abilityObject