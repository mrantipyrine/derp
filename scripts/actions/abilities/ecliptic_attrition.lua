-----------------------------------
-- Ability: Ecliptic Attrition
-- Enhances the effects of your luopan.
-- Increases the rate at which your luopan consumes its HP.
-- Obtained: Geomancer Level 25
-- Recast Time: 00:05:00
-- Duration: N/A
-- Notes: Luopan Potency +25%
-- Base HP drain rate is 24HP/tic. With Ecliptic attrition it is 30HP/tic.
-- Operates on a shared recast timer with Lasting Emanation
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.geomancer.geoOnAbilityCheck(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.geomancer.eclipticAttrition(player, target, ability)
    -- Solo bonus
    local isGEO = player:getMainJob() == xi.job.GEO
    local lvl = player:getMainLvl()
    local intBonus = isGEO and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local mndBonus = isGEO and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Ecliptic Attrition', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
