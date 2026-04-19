-----------------------------------
-- Ability: Life Cycle
-- Distributes one fourth of your HP to your luopan.
-- Obtained: Geomancer Level 50
-- Recast Time: 10 minutes
-- Grants your luopan 25% of your current HP.
-- The HP lost is not affected by gear or job points.
-- You also subsequently cannot kill yourself using this JA.
-- The increase in Life Cycle potency from Job points is applied in the same set as equipment bonuses.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.geomancer.geoOnLifeCycleAbilityCheck(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    return xi.job_utils.geomancer.lifeCycle(player, target, ability)
    -- Solo bonus
    local isGEO = player:getMainJob() == xi.job.GEO
    local lvl = player:getMainLvl()
    local intBonus = isGEO and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local mndBonus = isGEO and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Life Cycle', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
