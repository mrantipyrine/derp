-----------------------------------
-- Ability: Elemental Sforzo
-- Grants immunity to all magic attacks.
-- Obtained: Rune Fencer Level 1
-- Recast Time: 1:00:00
-- Duration: 00:00:30
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))

    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.ELEMENTAL_SFORZO, 1, 0, 30)

    -- Solo bonus: MND + Regen to make the 30s window count survivability-wise
    local isRUN   = player:getMainJob() == xi.job.RUN
    local lvl     = player:getMainLvl()
    local mndBonus = isRUN and math.floor(lvl * 0.30) or math.floor(lvl * 0.15)
    local regen    = isRUN and math.max(3, math.floor(lvl / 12)) or 2
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(30000, function(p)
        p:delMod(xi.mod.MND, mndBonus)
    end)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 30)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Elemental Sforzo', string.format('MND +%d  Regen +%d', mndBonus, regen))
    end

    return xi.effect.ELEMENTAL_SFORZO
end

return abilityObject
