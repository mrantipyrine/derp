-----------------------------------
-- Ability: Mikage
-- Job: Ninja
-- Bonus main weapon attacks scaling with remaining Utsusemi images.
-- Solo bonus: STR + brief Haste — shadows become strikes.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:addStatusEffect(xi.effect.MIKAGE, 0, 0, 45)

    local lvl   = player:getMainLvl()
    local isNIN = player:getMainJob() == xi.job.NIN

    local strBonus  = isNIN and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local hasteAmt  = isNIN and 10 or 5

    player:addMod(xi.mod.STR, strBonus)
    player:addStatusEffect(xi.effect.HASTE, hasteAmt, 0, 45)
    player:timer(45000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Mikage', string.format('STR +%d  Haste +%d%%', strBonus, hasteAmt))
    end
end

return abilityObject
