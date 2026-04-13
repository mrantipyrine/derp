local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMainJobMonk = player:getMainJob() == xi.job.MNK
    local mainLevel = player:getMainLvl()

    -- Apply Boost effect from job utilities
    xi.job_utils.monk.useBoost(player, target, ability)

    -- Restore HP if main job is Monk
    if isMainJobMonk then
        local hpRestorePercent = math.random(30, 80)
        local lostHP = player:getMaxHP() - player:getHP()
        local hpToRestore = math.floor(lostHP * hpRestorePercent / 100)
        player:setHP(player:getHP() + hpToRestore)
    end

    -- Calculate TP increase based on job
    local tpIncrease
    if isMainJobMonk then
        -- Monks gain higher TP (700-1400)
        tpIncrease = math.random(700, 1400)
    else
        -- Other jobs gain lower TP (100-700)
        tpIncrease = math.random(100, 700)
    end
    player:addTP(tpIncrease)

    -- Calculate STR increase based on job
    local strIncrease
    if isMainJobMonk then
        -- Monks gain 15-20 STR
        strIncrease = math.random(15, 20)
    else
        -- Other jobs gain 9-12 STR
        strIncrease = math.random(9, 12)
    end

    -- Apply STR Boost status effect for 3 minutes (180 seconds)
    local duration = 180
    player:addStatusEffect(xi.effect.STR_BOOST, strIncrease, 0, duration, 0, 0, 0)
end

return abilityObject