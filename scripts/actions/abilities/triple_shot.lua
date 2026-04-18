-----------------------------------
-- Ability: Triple Shot
-- Job: Corsair
-- Occasionally fires three rounds.
-- Solo bonus: Racc + TP — the pirate doesn't miss a shot.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.TRIPLE_SHOT, 40, 0, 90)

    local lvl   = player:getMainLvl()
    local isCOR = player:getMainJob() == xi.job.COR

    local raccBonus = isCOR and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local tpGain    = isCOR and math.random(150, 280) or math.random(60, 120)

    player:addMod(xi.mod.RACC, raccBonus)
    player:addTP(tpGain)
    player:timer(90000, function(p)
        p:delMod(xi.mod.RACC, raccBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Triple Shot', string.format('Racc +%d  TP +%d', raccBonus, tpGain))
    end
end

return abilityObject
