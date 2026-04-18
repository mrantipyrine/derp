-----------------------------------
-- Ability: Elemental Seal
-- Job: Black Mage
-- Next spell ignores resistance — perfect landing guaranteed.
-- Solo bonus: INT boost to ride the guaranteed hit for max damage.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.black_mage.useElementalSeal(player, target, ability)

    local lvl   = player:getMainLvl()
    local isBLM = player:getMainJob() == xi.job.BLM

    local intBonus = isBLM and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)

    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p)
        p:delMod(xi.mod.INT, intBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Elemental Seal', string.format('INT +%d (spell window)', intBonus))
    end
end

return abilityObject
