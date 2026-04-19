-----------------------------------
-- Ability: Dematerialize
-- Enhances the effects of your luopan.
-- Prevents your luopan from receiving damage.
-- Obtained: Geomancer Level 70
-- Recast Time: 00:10:00
-- Duration: 00:01:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.geomancer.geoOnAbilityCheck(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    return xi.job_utils.geomancer.dematerialize(player, target, ability)
    -- Solo bonus
    local isPUP = player:getMainJob() == xi.job.PUP
    local lvl = player:getMainLvl()
    local strBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local intBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.INT, intBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Dematerialize', string.format('STR +%d  INT +%d', strBonus, intBonus))
    end
end

return abilityObject
