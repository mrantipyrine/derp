-- Ability: Mug
-- Steal gil from enemy.
-- Obtained: Thief Level 35
-- Recast Time: 5:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability, action)
    if player:getMainJob() ~= xi.job.THF then
        return
    end

    local targetLevel = target:getMainLvl()

    if targetLevel >= 80 then
        return
    end

    local hpPercent = target:getMaxHP() / target:getHP() 
    if hpPercent > 0.2 and math.random(0, 100) <= 20 then
        target:setHP(0)
        return
    end

    local hpSteal = math.random(300, 800)
    local tpSteal = math.random(1000, 1500)

    if player:getMainLvl() > 40 then
        hpSteal = math.random(500, 1100)
        tpSteal = math.random(1500, 2000)
    end

    player:addHP(hpSteal)
    player:addTP(tpSteal)

    target:addTP(-tpSteal)
    target:addHP(-hpSteal)

    return xi.job_utils.thief.useMug(player, target, ability, action)
end

return abilityObject
