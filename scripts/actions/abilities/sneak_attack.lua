-----------------------------------
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

    attIncrease = 10
    attDuration = 20

    dexIncrease = 10
    dexDuration = 59 -- 2 minutes in seconds  

    tpGain = math.random(250, 500)

    evasionIncrease = 20
    evasionDuration = 59 -- 2 minutes in seconds

    --- maybe into their own if statements instead of one block?
    --- is this providing too much?
    if player:getMainJob() == xi.job.THF then

        attIncrease = attIncrease * 5
        attIncrease = attDuration * 3
        dexIncrease = dexIncrease * 3
        evasionIncrease = evasionIncrease * 5
        tpGain = tpGain * 5
    end 

    player:addTP(tpGain)

    player:addMod(xi.mod.ATT, attIncrease, 3, attDuration, 3, 10, 1)
    player:addStatusEffect(xi.effect.DEX_BOOST, dexIncrease, 3, dexDuration, 0, 10, 1)
    player:addStatusEffect(xi.effect.EVASION_BOOST, evasionIncrease, 3, evasionDuration, 0, 10, 1)

    xi.job_utils.thief.useSneakAttack(player, target, ability)

end

return abilityObject
