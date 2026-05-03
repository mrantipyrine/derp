-----------------------------------
-- Ability: Blaze of Glory
-- Increases the effects of your next applicable geomancy spell.
-- Consumes half of that luopan's HP.
-- Obtained: Geomancer Level 60
-- Recast Time: 00:10:00
-- Duration: 00:01:00
-- Notes: Luopan Potency +50%
-- Blaze of Glory has to be active first before using any Geocolure spell.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.geomancer.blazeOfGlory(player, target, ability)
    -- Solo bonus
    local isGEO = player:getMainJob() == xi.job.GEO
    local lvl = player:getMainLvl()
    local intBonus = isGEO and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local mndBonus = isGEO and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Blaze Of Glory', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
