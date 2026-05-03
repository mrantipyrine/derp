-----------------------------------
-- Ability: Unbridled Learning
-- Job: Blue Mage
-- Access additional BLU spells for 60s.
-- Solo bonus: INT + TP to capitalize on the expanded spell pool.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:addStatusEffect(xi.effect.UNBRIDLED_LEARNING, 16, 1, 60)

    local lvl   = player:getMainLvl()
    local isBLU = player:getMainJob() == xi.job.BLU

    local intBonus = isBLU and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local tpGain   = isBLU and math.random(200, 350) or math.random(80, 150)

    player:addMod(xi.mod.INT, intBonus)
    player:addTP(tpGain)
    player:timer(60000, function(p)
        p:delMod(xi.mod.INT, intBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Unbridled Learning', string.format('INT +%d  TP +%d', intBonus, tpGain))
    end
end

return abilityObject
