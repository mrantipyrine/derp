-----------------------------------
-- Ability: Bolster
-- Enhances the effects of your geomancy spells.
-- Doubles the potency of Geomancy spells while Bolster is active.
-- Obtained: Geomancer Level 1
-- Recast Time: 01:00:00
-- Duration: 00:03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.geomancer.bolster(player, target, ability)

    local isGEO = player:getMainJob() == xi.job.GEO
    local lvl   = player:getMainLvl()

    -- INT carries geomancy potency; MND for support heliodor/indi spells
    local intBonus = isGEO and math.floor(lvl * 0.30) or math.floor(lvl * 0.15)
    local mndBonus = isGEO and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(180000, function(p)
        p:delMod(xi.mod.INT, intBonus)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Bolster', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
