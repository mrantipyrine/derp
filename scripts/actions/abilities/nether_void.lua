-----------------------------------
-- Ability: Nether Void
-- Job: Dark Knight
-- Next dark magic absorption is enhanced.
-- Solo bonus: INT boost for 60s to ride on the absorption window.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dark_knight.useNetherVoid(player, target, ability)

    local lvl   = player:getMainLvl()
    local isDRK = player:getMainJob() == xi.job.DRK

    local intBonus = isDRK and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)

    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p)
        p:delMod(xi.mod.INT, intBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Nether Void', string.format('INT +%d (dark magic window)', intBonus))
    end
end

return abilityObject
