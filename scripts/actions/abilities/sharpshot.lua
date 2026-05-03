-----------------------------------
-- Ability: Sharpshot
-- Job: Ranger
-- Ranged accuracy bonus.
-- Solo bonus: TP + Regain — the lone sniper needs steady ammo flow.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local power = 40 + player:getMod(xi.mod.SHARPSHOT)
    player:addStatusEffect(xi.effect.SHARPSHOT, power, 0, 60)

    local lvl   = player:getMainLvl()
    local isRNG = player:getMainJob() == xi.job.RNG

    local tpGain = isRNG and math.random(200, 350) or math.random(80, 150)
    local regain = isRNG and math.max(2, math.floor(lvl / 14)) or 1

    player:addTP(tpGain)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 60)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Sharpshot', string.format('TP +%d  Regain +%d', tpGain, regain))
    end
end

return abilityObject
