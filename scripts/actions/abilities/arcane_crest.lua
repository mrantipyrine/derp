-----------------------------------
-- Ability: Arcane Crest
-- Description: Lowers accuracy, evasion, magic accuracy, magic evasion and TP gain for arcana.
-- Obtained: Dark Knight Level 87
-- Recast Time: 00:05:00
-- Duration: 00:03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dark_knight.checkArcaneCrest(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dark_knight.useArcaneCrest(player, target, ability)
    -- Solo bonus
    local isWAR = player:getMainJob() == xi.job.WAR
    local lvl = player:getMainLvl()
    local strBonus = isWAR and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local attBonus = isWAR and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.ATT, attBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.ATT, attBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Arcane Crest', string.format('STR +%d  ATT +%d', strBonus, attBonus))
    end
end

return abilityObject
