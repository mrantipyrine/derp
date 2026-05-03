-----------------------------------
-- Ability: Dragon Breaker
-- Job: Dragoon
-- Lowers dragon ACC, EVA, MACC, MEVA, TP gain.
-- Solo bonus: STR + ATT boost — press the advantage against the weakened wyrm.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dragoon.useDragonBreaker(player, target, ability)

    local lvl   = player:getMainLvl()
    local isDRG = player:getMainJob() == xi.job.DRG

    local strBonus = isDRG and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local attBonus = isDRG and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)

    player:addMod(xi.mod.STR, strBonus)
    player:addStatusEffect(xi.effect.ATT_BOOST, attBonus, 0, 180)
    player:timer(180000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Dragon Breaker', string.format('STR +%d  ATT +%d', strBonus, attBonus))
    end
end

return abilityObject
