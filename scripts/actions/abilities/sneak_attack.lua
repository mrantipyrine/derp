-- Ability: Sneak Attack
-- Deals critical damage when striking from behind.
-- Obtained: Thief Level 15
-- Recast Time: 1:00
-- Duration: 1:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)

    power = player:getMainLvl()
    duration = 60

    --- maybe into their own if statements instead of one block?
    --- is this providing too much?
    if player:getMainJob() == xi.job.THF then
        power = power * 5
    end

    player:addMod(xi.mod.ACC, power, 3, duration, 3, 10, 1)
    player:addMod(xi.mod.ATT, power, 3, duration, 3, 10, 1)

    xi.job_utils.thief.useSneakAttack(player, target, ability)

end

return abilityObject4