-----------------------------------
-- Ability: Sacrosanctity
-- Job: White Mage
-- Party magic defense up for 60s.
-- Solo bonus: MND + Regen — divine protection made personal.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.white_mage.useSacrosanctity(player, target, ability)

    local lvl   = player:getMainLvl()
    local isWHM = player:getMainJob() == xi.job.WHM

    local mndBonus = isWHM and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local regen    = isWHM and math.max(3, math.floor(lvl / 12)) or 1

    player:addMod(xi.mod.MND, mndBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 60)
    player:timer(60000, function(p)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Sacrosanctity', string.format('MND +%d  Regen +%d', mndBonus, regen))
    end
end

return abilityObject
