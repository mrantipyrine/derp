-----------------------------------
-- Ability: Hide
-- User becomes invisible.
-- Obtained: Thief Level 45
-- Recast Time: 5:00
-- Duration: Random
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)

    evasionIncrease = 20
    evasionDuration = 120 -- 2 minutes in seconds
    
    if player:getMainJob() == xi.job.THF then
        evasionIncrease = evasionIncrease * 4
        local doubleAtt = player:getMainLvl() * 5
        local doubleAttdmg = player:getMainLvl() 
        local duration = 120 
        local attack = player:getMainLvl() * 5
        player:addMod(xi.mod.DOUBLE_ATTACK, doubleAtt, 3, duration, 0, 10, 1)
        player:addMod(xi.mod.DOUBLE_ATTACK_DMG, doubleAttdmg, 3, duration, 0, 10, 1)
        player:addMod(xi.mod.ATT, attack, 3, duration, 0, 10, 1)
    end
     
    xi.job_utils.thief.useHide(player, target, ability)
end

return abilityObject
