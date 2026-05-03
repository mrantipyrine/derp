-----------------------------------
-- Ability: Unbridled Wisdom
-- Job: Blue Mage
-- 1hr: cast certain BLU spells for 30s.
-- Solo bonus: INT + MND + MP restore — full wisdom unlocked.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:addStatusEffect(xi.effect.UNBRIDLED_WISDOM, 16, 1, 30)

    local lvl   = player:getMainLvl()
    local isBLU = player:getMainJob() == xi.job.BLU

    local intBonus = isBLU and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local mndBonus = isBLU and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local mpGain   = isBLU and math.floor(lvl * 2.0) or math.floor(lvl * 0.9)

    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:addMP(mpGain)
    player:timer(30000, function(p)
        p:delMod(xi.mod.INT, intBonus)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Unbridled Wisdom', string.format('INT +%d  MND +%d  MP +%d', intBonus, mndBonus, mpGain))
    end
end

return abilityObject
