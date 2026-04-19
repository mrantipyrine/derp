-----------------------------------
-- Ability: Arcane Circle
-- Job: Dark Knight
-- Resistance, DEF, ATT vs Arcana to party.
-- Solo bonus: INT and MND boost to amplify dark magic damage against Arcana.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dark_knight.useArcaneCircle(player, target, ability)

    local lvl   = player:getMainLvl()
    local isDRK = player:getMainJob() == xi.job.DRK

    local intBonus = isDRK and math.floor(lvl * 0.12) or math.floor(lvl * 0.06)
    local mndBonus = isDRK and math.floor(lvl * 0.08) or math.floor(lvl * 0.04)

    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(180000, function(p)
        p:delMod(xi.mod.INT, intBonus)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Arcane Circle', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
