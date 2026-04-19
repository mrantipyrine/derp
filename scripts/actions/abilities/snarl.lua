-----------------------------------
-- Ability: Snarl
-- Transfers hate to your pet. Only works on pets invoked with the "Call Beast" ability.
-- Obtained: Beastmaster Level 45
-- Recast Time: 30 seconds
-- Duration: N/A
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.beastmaster.onAbilityCheckSnarl(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    return xi.job_utils.beastmaster.onUseAbilitySnarl(player, target, ability)
    -- Solo bonus
    local isBST = player:getMainJob() == xi.job.BST
    local lvl = player:getMainLvl()
    local strBonus = isBST and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local tpGain   = isBST and math.random(150, 300) or math.random(50, 120)
    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Snarl', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end
end

return abilityObject
