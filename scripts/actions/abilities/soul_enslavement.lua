-----------------------------------
-- Ability: Soul Enslavement
-- Description: Melee attacks absorb target's TP.
-- Obtained: Dark Knight Level 96
-- Recast Time: 01:00:00
-- Duration: 00:00:30
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dark_knight.checkSoulEnslavement(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dark_knight.useSoulEnslavement(player, target, ability)
    -- Solo bonus
    local isBST = player:getMainJob() == xi.job.BST
    local lvl = player:getMainLvl()
    local strBonus = isBST and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local tpGain   = isBST and math.random(150, 300) or math.random(50, 120)
    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Soul Enslavement', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end
end

return abilityObject
