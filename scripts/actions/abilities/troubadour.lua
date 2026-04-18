-----------------------------------
-- Ability: Troubadour
-- Job: Bard
-- Doubles song effect duration for 60s.
-- Solo bonus: CHR + Regen — sustain the solo performance.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.TROUBADOUR, 0, 0, 60)

    local lvl   = player:getMainLvl()
    local isBRD = player:getMainJob() == xi.job.BRD
    local chrBonus = isBRD and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local regen    = isBRD and math.max(2, math.floor(lvl / 14)) or 1

    player:addMod(xi.mod.CHR, chrBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 60)
    player:timer(60000, function(p) p:delMod(xi.mod.CHR, chrBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Troubadour', string.format('CHR +%d  Regen +%d', chrBonus, regen))
    end
end

return abilityObject
