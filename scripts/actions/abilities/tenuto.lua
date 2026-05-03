-----------------------------------
-- Ability: Tenuto
-- If the next song you cast affects yourself, it will not subsequently be overwritten by other songs.
-- Obtained: Bard Level 83
-- Recast Time: 0:15
-- Duration: 1:00, or until next song is cast.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    -- TODO: Implement this ability
    player:addStatusEffect(xi.effect.TENUTO, 0, 0, 60)
    -- Solo bonus
    local isBRD = player:getMainJob() == xi.job.BRD
    local lvl = player:getMainLvl()
    local chrBonus = isBRD and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.CHR, chrBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.CHR, chrBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Tenuto', string.format('CHR +%d', chrBonus))
    end
end

return abilityObject
