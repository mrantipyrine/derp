-----------------------------------
-- Ability: Composure
-- Job: Red Mage
-- ACC up, enhancement spells last longer on self.
-- Solo bonus: INT + MND so the lone RDM buffs and debuffs with maximum potency.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.red_mage.useComposure(player, target, ability)

    local lvl   = player:getMainLvl()
    local isRDM = player:getMainJob() == xi.job.RDM

    local intBonus = isRDM and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local mndBonus = isRDM and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)

    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(7200000, function(p)
        p:delMod(xi.mod.INT, intBonus)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Composure', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
