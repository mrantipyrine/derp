-----------------------------------
-- Ability: Nightingale
-- Job: Bard
-- Halves song cast/recast for 60s.
-- Solo bonus: CHR + MP — the rapid singer sustains the melody alone.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.NIGHTINGALE, 0, 0, 60)

    local lvl   = player:getMainLvl()
    local isBRD = player:getMainJob() == xi.job.BRD
    local chrBonus = isBRD and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local mpGain   = isBRD and math.floor(lvl * 1.2) or math.floor(lvl * 0.5)

    player:addMod(xi.mod.CHR, chrBonus)
    player:addMP(mpGain)
    player:timer(60000, function(p) p:delMod(xi.mod.CHR, chrBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Nightingale', string.format('CHR +%d  MP +%d', chrBonus, mpGain))
    end
end

return abilityObject
