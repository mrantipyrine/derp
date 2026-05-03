-----------------------------------
-- Ability: Barrage
-- Job: Ranger
-- Fires multiple shots at once.
-- Solo bonus: Racc + TP — the volley leaves no time to breathe.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.BARRAGE, 0, 0, 60)

    local lvl   = player:getMainLvl()
    local isRNG = player:getMainJob() == xi.job.RNG

    local raccBonus = isRNG and math.floor(lvl * 0.25) or math.floor(lvl * 0.12)
    local tpGain    = isRNG and math.random(150, 280) or math.random(60, 120)

    player:addMod(xi.mod.RACC, raccBonus)
    player:addTP(tpGain)
    player:timer(60000, function(p)
        p:delMod(xi.mod.RACC, raccBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Barrage', string.format('Racc +%d  TP +%d', raccBonus, tpGain))
    end
end

return abilityObject
