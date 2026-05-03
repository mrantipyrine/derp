-----------------------------------
-- Ability: Afflatus Solace
-- Job: White Mage
-- Draw strength from cures cast on others — Stoneskin on cure.
-- Solo bonus: MND + Regen — the lone healer draws comfort from their own light.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.white_mage.useAfflatusSolace(player, target, ability)

    local lvl   = player:getMainLvl()
    local isWHM = player:getMainJob() == xi.job.WHM

    local mndBonus = isWHM and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local regen    = isWHM and math.max(2, math.floor(lvl / 14)) or 1

    player:addMod(xi.mod.MND, mndBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 7200)
    player:timer(7200000, function(p)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Afflatus Solace', string.format('MND +%d  Regen +%d', mndBonus, regen))
    end
end

return abilityObject
