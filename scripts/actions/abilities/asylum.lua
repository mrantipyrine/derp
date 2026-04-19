-----------------------------------
-- Ability: Asylum
-- Job: White Mage
-- 1hr: party enfeeble/Dispel immunity for 30s.
-- Solo bonus: MND + DEF — the sanctuary is absolute.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.white_mage.checkAsylum(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.white_mage.useAsylum(player, target, ability)

    local lvl   = player:getMainLvl()
    local isWHM = player:getMainJob() == xi.job.WHM

    local mndBonus = isWHM and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local defBonus = isWHM and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)

    player:addMod(xi.mod.MND, mndBonus)
    player:addMod(xi.mod.DEF, defBonus)
    player:timer(30000, function(p)
        p:delMod(xi.mod.MND, mndBonus)
        p:delMod(xi.mod.DEF, defBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Asylum', string.format('MND +%d  DEF +%d', mndBonus, defBonus))
    end
end

return abilityObject
