-----------------------------------
-- Ability: Focus
-- Enhances user's accuracy.
-- Obtained: Monk Level 25
-- Recast Time: 5:00
-- Duration: 2:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local doubleAtt = player:getMainLvl() * 5
    local doubleAttdmg = player:getMainLvl() 
    local duration = 120 
    local attack = player:getMainLvl() * 5
    player:addMod(xi.mod.DOUBLE_ATTACK, doubleAtt, 3, duration, 0, 10, 1)
    player:addMod(xi.mod.DOUBLE_ATTACK_DMG, doubleAttdmg, 3, duration, 0, 10, 1)
    player:delMod(xi.mod.ATT, attack, 3, duration, 0, 10, 1)
    
    xi.job_utils.monk.useFootwork(player, target, ability)
end

return abilityObject
