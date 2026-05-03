-----------------------------------
-- Ability: Afflatus Misery
-- Job: White Mage
-- Draw strength from damage taken — Cureskin and boosted magic on pain.
-- Solo bonus: DEF + VIT so the WHM can actually survive taking hits.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.white_mage.useAfflatusMisery(player, target, ability)

    local lvl   = player:getMainLvl()
    local isWHM = player:getMainJob() == xi.job.WHM

    local defBonus = isWHM and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local vitBonus = isWHM and math.floor(lvl * 0.12) or math.floor(lvl * 0.06)

    player:addMod(xi.mod.DEF, defBonus)
    player:addMod(xi.mod.VIT, vitBonus)
    player:timer(7200000, function(p)
        p:delMod(xi.mod.DEF, defBonus)
        p:delMod(xi.mod.VIT, vitBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Afflatus Misery', string.format('DEF +%d  VIT +%d', defBonus, vitBonus))
    end
end

return abilityObject
