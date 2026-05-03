-----------------------------------
-- Ability: Familiar
-- Job: Beastmaster
-- 1hr: enhances pet and extends Charm.
-- Solo bonus: STR + ATT — master and beast fight as one.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.beastmaster.onAbilityCheckFamiliar(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    local result = xi.job_utils.beastmaster.onUseAbilityFamiliar(player, target, ability)

    local lvl   = player:getMainLvl()
    local isBST = player:getMainJob() == xi.job.BST
    local strBonus = isBST and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local attBonus = isBST and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)

    player:addMod(xi.mod.STR, strBonus)
    player:addStatusEffect(xi.effect.ATT_BOOST, attBonus, 0, 1800)
    player:timer(1800000, function(p) p:delMod(xi.mod.STR, strBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Familiar', string.format('STR +%d  ATT +%d', strBonus, attBonus))
    end

    return result
end

return abilityObject
