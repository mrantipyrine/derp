-----------------------------------
-- Ability: Call Beast
-- Job: Beastmaster
-- Calls a jug pet.
-- Solo bonus: STR + brief Haste on call — ready to fight immediately.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.beastmaster.onAbilityCheckJug(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    local result = xi.job_utils.beastmaster.onUseAbilityJug(player, target, ability)

    local lvl   = player:getMainLvl()
    local isBST = player:getMainJob() == xi.job.BST
    local strBonus = isBST and math.floor(lvl * 0.12) or math.floor(lvl * 0.06)
    local hasteAmt = isBST and 8 or 4

    player:addMod(xi.mod.STR, strBonus)
    player:addStatusEffect(xi.effect.HASTE, hasteAmt, 0, 30)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Call Beast', string.format('STR +%d  Haste +%d%% (30s)', strBonus, hasteAmt))
    end

    return result
end

return abilityObject
