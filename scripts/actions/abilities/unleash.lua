-----------------------------------
-- Ability: Unleash
-- Description: Increases the accuracy of Charm and reduces the recast times of Sic and Ready.
-- Obtained: BST Level 96
-- Recast Time: 01:00:00
-- Duration: 0:01:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.beastmaster.onAbilityCheckUnleash(player, target, ability)
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
        xi.soloSynergy.flashBuff(player, 'Unleash', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end

    return xi.job_utils.beastmaster.onUseAbilityUnleash(player, target, ability)
end

return abilityObject
