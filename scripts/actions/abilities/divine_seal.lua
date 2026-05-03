-----------------------------------
-- Ability: Divine Seal
-- Job: White Mage
-- Next healing spell is enhanced.
-- Solo bonus: MND boost to ride the enhanced cure window.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.white_mage.useDivineSeal(player, target, ability)

    local lvl   = player:getMainLvl()
    local isWHM = player:getMainJob() == xi.job.WHM

    local mndBonus = isWHM and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)

    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Divine Seal', string.format('MND +%d (cure window)', mndBonus))
    end
end

return abilityObject
