-----------------------------------
-- Ability: Chain Affinity
-- Job: Blue Mage
-- Next physical blue magic can be used in a skillchain.
-- Solo bonus: STR + TP to maximize the physical spell's impact.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.CHAIN_AFFINITY, 1, 0, 30)

    local lvl   = player:getMainLvl()
    local isBLU = player:getMainJob() == xi.job.BLU

    local strBonus = isBLU and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local tpGain   = isBLU and math.random(200, 350) or math.random(80, 150)

    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Chain Affinity', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end

    return xi.effect.CHAIN_AFFINITY
end

return abilityObject
