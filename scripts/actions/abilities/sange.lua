-----------------------------------
-- Ability: Sange
-- Job: Ninja
-- Guaranteed Daken (consumes shuriken).
-- Solo bonus: AGI + TP to chain into a WS immediately after the throw storm.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local potency = player:getMerit(xi.merit.SANGE) - 1
    player:addStatusEffect(xi.effect.SANGE, potency * 25, 0, 60)

    local lvl   = player:getMainLvl()
    local isNIN = player:getMainJob() == xi.job.NIN

    local agiBonus = isNIN and math.floor(lvl * 0.12) or math.floor(lvl * 0.06)
    local tpGain   = isNIN and math.random(150, 300) or math.random(60, 120)

    player:addMod(xi.mod.AGI, agiBonus)
    player:addTP(tpGain)
    player:timer(60000, function(p)
        p:delMod(xi.mod.AGI, agiBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Sange', string.format('AGI +%d  TP +%d', agiBonus, tpGain))
    end
end

return abilityObject
