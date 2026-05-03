-----------------------------------
-- Ability: Benediction
-- Job: White Mage
-- 1hr: massive AoE heal + cleanse.
-- Solo bonus: MND + Regen post-cast — the healer survives what comes next.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.white_mage.checkBenediction(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    local result = xi.job_utils.white_mage.useBenediction(player, target, ability)

    local lvl   = player:getMainLvl()
    local isWHM = player:getMainJob() == xi.job.WHM

    local mndBonus = isWHM and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local regen    = isWHM and math.max(4, math.floor(lvl / 10)) or math.max(2, math.floor(lvl / 18))

    player:addMod(xi.mod.MND, mndBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 60)
    player:timer(60000, function(p)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Benediction', string.format('MND +%d  Regen +%d', mndBonus, regen))
    end

    return result
end

return abilityObject
