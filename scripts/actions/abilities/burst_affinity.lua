-----------------------------------
-- Ability: Burst Affinity
-- Job: Blue Mage
-- Next magical blue magic can magic burst.
-- Solo bonus: INT + MP to fuel the burst.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.BURST_AFFINITY, 1, 0, 30)

    local lvl   = player:getMainLvl()
    local isBLU = player:getMainJob() == xi.job.BLU

    local intBonus = isBLU and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local mpGain   = isBLU and math.floor(lvl * 1.5) or math.floor(lvl * 0.7)

    player:addMod(xi.mod.INT, intBonus)
    player:addMP(mpGain)
    player:timer(30000, function(p)
        p:delMod(xi.mod.INT, intBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Burst Affinity', string.format('INT +%d  MP +%d', intBonus, mpGain))
    end

    return xi.effect.BURST_AFFINITY
end

return abilityObject
