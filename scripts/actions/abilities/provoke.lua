-----------------------------------
-- Ability: Provoke
-- Job: Warrior
-- Restores Health / Gains TP 
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)


    -- Restore HP based on job
    local hpRestorePercent = player:getMainJob() == xi.job.WAR and math.random(30, 80) or 0
    local lostHP = player:getMaxHP() - player:getHP()
    local hpToRestore = math.floor(lostHP * hpRestorePercent / 100)
    player:setHP(player:getHP() + hpToRestore)

    -- Increase TP
    player:addTP(player:getMainJob() == xi.job.WAR and math.random(700, 1400) or math.random(100, 700))

    -- Increase VIT 
    local vitIncrease = player:getMainLvl() <= 8 and 1 or player:getMainJob() == xi.job.WAR and player:getMainLvl() / 6 or player:getMainLvl() / 8
    
    -- 3 minutes in seconds
    duration = 25

    player:addStatusEffect(xi.effect.VIT_BOOST, vitIncrease, 0, duration, 0, 0, 0)
    player:addTP(tpGain)

end

return abilityObject