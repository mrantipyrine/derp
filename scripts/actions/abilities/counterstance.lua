-----------------------------------
-- Ability: Counterstance
-- Increases chance to counter but lowers defense.
-- Obtained: Monk Level 45
-- Recast Time: 5:00
-- Duration: 5:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)

    local evasionIncrease = player:getMainLvl() * 5
    local evasionDuration = 240

    local kickDmg = player:getMainLvl()
    local kickRate = player:getMainLvl() * 5
    local kickDuration = 240

    player:addMod(xi.mod.KICK_ATTACK_RATE, kickRate, 3, kickDuration, 0, 10, 1)
    player:addMod(xi.mod.KICK_DMG, kickDmg, 3, kickDuration, 0, 10, 1)

    player:addStatusEffect(xi.effect.EVASION_BOOST, evasionIncrease, 3, evasionDuration, 0, 10, 1)
    
    xi.job_utils.monk.useCounterstance(player, target, ability)
end

return abilityObject