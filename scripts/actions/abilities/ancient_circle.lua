-----------------------------------
-- Ability: Ancient Circle
-- Grants resistance, defense, and attack against dragons to party members within the area of effect.
-- Obtained: Dragoon Level 5
-- Recast Time: 5:00
-- Duration: 03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dragoon.useAncientCircle(player, target, ability)
    -- Solo bonus
    local isWAR = player:getMainJob() == xi.job.WAR
    local lvl = player:getMainLvl()
    local strBonus = isWAR and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local attBonus = isWAR and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.ATT, attBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.ATT, attBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Ancient Circle', string.format('STR +%d  ATT +%d', strBonus, attBonus))
    end
end

return abilityObject
