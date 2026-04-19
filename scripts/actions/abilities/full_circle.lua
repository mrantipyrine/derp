-----------------------------------
-- Ability: Full Circle
-- Causes your luopan to vanish.
-- Obtained: Geomancer Level 5
-- Recast Time: 10 seconds
-- Refunds some of the MP consumed by the Geocolure spell that created the luopan.
-- Amount of MP restored varies depending on remaining Luopan HP.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.geomancer.geoOnAbilityCheck(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.geomancer.fullCircle(player, target, ability)
    -- Solo bonus
    local isGEO = player:getMainJob() == xi.job.GEO
    local lvl = player:getMainLvl()
    local intBonus = isGEO and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local mndBonus = isGEO and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Full Circle', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
