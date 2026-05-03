-----------------------------------
-- Ability: Holy Circle
-- Job: Paladin
-- DEF, ATT, resistance vs Undead for party.
-- Solo bonus: MND + Regen — the solo PLD calls on divine protection.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.paladin.useHolyCircle(player, target, ability)

    local lvl   = player:getMainLvl()
    local isPLD = player:getMainJob() == xi.job.PLD

    local mndBonus = isPLD and math.floor(lvl * 0.12) or math.floor(lvl * 0.06)
    local regen    = isPLD and math.max(2, math.floor(lvl / 14)) or 1

    player:addMod(xi.mod.MND, mndBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 180)
    player:timer(180000, function(p)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Holy Circle', string.format('MND +%d  Regen +%d', mndBonus, regen))
    end
end

return abilityObject
