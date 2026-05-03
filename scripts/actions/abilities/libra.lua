-----------------------------------
-- Ability: Libra
-- Description: Examines the target's enmity level.
-- Obtained: SCH Level 76
-- Recast Time: 00:01:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    -- player:addStatusEffect(xi.effect.LIBRA, 20, 1, 1) -- TODO: implement xi.effect.LIBRA
    -- Solo bonus
    local isGEO = player:getMainJob() == xi.job.GEO
    local lvl = player:getMainLvl()
    local intBonus = isGEO and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local mndBonus = isGEO and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Libra', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
