-----------------------------------
-- Ability: Diabolic Eye
-- Job: Dark Knight
-- MaxHP down, ACC up.
-- Solo bonus: INT boost to compensate the HP loss with harder magic + Regen.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dark_knight.useDiabolicEye(player, target, ability)

    local lvl   = player:getMainLvl()
    local isDRK = player:getMainJob() == xi.job.DRK

    local intBonus = isDRK and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local regen    = isDRK and math.max(2, math.floor(lvl / 14)) or 1

    player:addMod(xi.mod.INT, intBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 180)
    player:timer(180000, function(p)
        p:delMod(xi.mod.INT, intBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Diabolic Eye', string.format('INT +%d  Regen +%d', intBonus, regen))
    end
end

return abilityObject
