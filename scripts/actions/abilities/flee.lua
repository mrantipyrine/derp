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
    
    regenDuration = 60 
    regenAmount = 30

    -- Making Flee useful for solo play 
    if player:getMainJob() == xi.job.THF then
       regenDuration = regenDuration * 10
       regainAmount = math.random(10, 25)
       regainDuration = 240
    end

    player:addStatusEffect(xi.effect.REGAIN, regainAmount, 3, regainDuration, 0)
    player:addStatusEffect(xi.effect.REGEN, regenAmount, 3, regenDuration, 0, 10, 1)

    xi.job_utils.thief.useFlee(player, target, ability)
end

return abilityObject
