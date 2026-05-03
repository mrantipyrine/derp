-----------------------------------
-- Ability: Angon
-- Expends an Angon to lower an enemy's defense.
-- Obtained: Dragoon Level 75
-- Recast Time: 0:03:00
-- Duration: 0:00:30 (+0:00:15 for each merit, cap is 0:01:30)
-- Effect: Physical defense of target approximately -20% (51/256).
-- Range: 10.0 yalms
-- Notes: Only fails if it can't apply the def down status.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dragoon.abilityCheckAngon(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    -- Solo bonus
    local isWAR = player:getMainJob() == xi.job.WAR
    local lvl = player:getMainLvl()
    local strBonus = isWAR and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local attBonus = isWAR and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.ATT, attBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.ATT, attBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Angon', string.format('STR +%d  ATT +%d', strBonus, attBonus))
    end

    return xi.job_utils.dragoon.useAngon(player, target, ability)
end

return abilityObject
