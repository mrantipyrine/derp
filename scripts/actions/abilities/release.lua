-----------------------------------
-- Ability: Release
-- Sends the avatar away.
-- Obtained: Summoner Level 1
-- Recast Time: 10 seconds (shared by all avatars)
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:despawnPet()
    -- Solo bonus
    local isBST = player:getMainJob() == xi.job.BST
    local lvl = player:getMainLvl()
    local strBonus = isBST and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local tpGain   = isBST and math.random(150, 300) or math.random(50, 120)
    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Release', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end
end

return abilityObject
