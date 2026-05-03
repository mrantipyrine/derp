-----------------------------------
-- Ability: Bestial Loyalty
-- Calls a beast to fight by your side without consuming bait
-- Obtained: Beastmaster Level 23
-- Recast Time: 20:00
-- Duration: Dependent on jug pet used.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.beastmaster.onAbilityCheckJug(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    -- Solo bonus
    local isBST = player:getMainJob() == xi.job.BST
    local lvl = player:getMainLvl()
    local strBonus = isBST and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local tpGain   = isBST and math.random(150, 300) or math.random(50, 120)
    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Bestial Loyalty', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end

    return xi.job_utils.beastmaster.onUseAbilityJug(player, target, ability)
end

return abilityObject
