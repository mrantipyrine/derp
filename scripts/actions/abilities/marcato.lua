-----------------------------------
-- Ability: Marcato
-- Job: Bard
-- Next song enhanced effect.
-- Solo bonus: CHR boost for the window.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.MARCATO, 0, 0, 60)

    local lvl   = player:getMainLvl()
    local isBRD = player:getMainJob() == xi.job.BRD
    local chrBonus = isBRD and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)

    player:addMod(xi.mod.CHR, chrBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.CHR, chrBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Marcato', string.format('CHR +%d (song window)', chrBonus))
    end
end

return abilityObject
