-----------------------------------
-- Ability: Defender
-- Job: Warrior
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.warrior.useDefender(player, target, ability)

    local maxHP = 30
    local duration = 90
    local defIncrease = player:getMainLvl() / 4

    if player:getMainJob() == xi.job.WAR then
        maxHP = maxHP * 0.8
        duration = 179
        defIncrease = player:getMainLvl()
        player:addStatusEffect(xi.effect.REGEN, player:getMainLvl() / 2 , 1, duration )
    end

    -- Increase Max HP and Restore 80% missing  
    player:addStatusEffect(xi.effect.MAX_HP_BOOST, maxHP, 1, duration)

    local lostHP = player:getMaxHP() - player:getHP()
    local hpToRestore = math.floor(lostHP * 0.8)
    player:setHP(player:getHP() + hpToRestore)

end

return abilityObject