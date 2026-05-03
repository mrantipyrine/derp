-----------------------------------
-- Ability: Azure Lore
-- Job: Blue Mage
-- 1hr: enhances all BLU spells for 30s.
-- Solo bonus: INT + STR + Regain — the sage of blue magic burns everything.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.AZURE_LORE, 1, 0, 30)

    local lvl   = player:getMainLvl()
    local isBLU = player:getMainJob() == xi.job.BLU

    local intBonus = isBLU and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local strBonus = isBLU and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local regain   = isBLU and math.max(4, math.floor(lvl / 10)) or math.max(2, math.floor(lvl / 18))

    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.STR, strBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 30)
    player:timer(30000, function(p)
        p:delMod(xi.mod.INT, intBonus)
        p:delMod(xi.mod.STR, strBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Azure Lore', string.format('INT +%d  STR +%d  Regain +%d', intBonus, strBonus, regain))
    end
end

return abilityObject
