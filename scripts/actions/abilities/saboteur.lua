-----------------------------------
-- Ability: Saboteur
-- Job: Red Mage
-- Next enfeebling spell enhanced effect and duration.
-- Solo bonus: INT boost to amplify the enfeeble window.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.red_mage.useSaboteur(player, target, ability)

    local lvl   = player:getMainLvl()
    local isRDM = player:getMainJob() == xi.job.RDM

    local intBonus = isRDM and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)

    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p)
        p:delMod(xi.mod.INT, intBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Saboteur', string.format('INT +%d (enfeeble window)', intBonus))
    end
end

return abilityObject
