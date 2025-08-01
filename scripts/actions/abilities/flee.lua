-----------------------------------
-- Ability: Flee
-- Increases movement speed.
-- Obtained: Thief Level 25
-- Recast Time: 5:00
-- Duration: 0:30
-- print to player 
-- local function error(player, msg)
-- player:printToPlayer(msg)
-- player:printToPlayer('!reset (player)')
-- end

-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end


abilityObject.onUseAbility = function(player, target, ability)
    
    local duration = 200
    local power = player:getMainLvl()

    -- Making Flee useful for solo play 
    if player:getMainJob() == xi.job.THF then
       power = power * 10
    end

    player.delMod(xi.mod.DOUBLE_ATTACK, power)
    player:addMod(xi.mod.DOUBLE_ATTACK, power, 3, duration)

    xi.job_utils.thief.useFlee(player, target, ability)
end

return abilityObject
