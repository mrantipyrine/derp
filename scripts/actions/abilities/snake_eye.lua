-----------------------------------
-- Ability: Snake Eye
-- Your next roll will automatically be a 1.
-- Obtained: Corsair Level 75
-- Recast Time: 0:05:00
-- Duration: 0:01:00 or the next usage of Phantom Roll or Double-Up
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.SNAKE_EYE, (player:getMerit(xi.merit.SNAKE_EYE) - 10), 0, 60)

    -- Solo bonus: CHR to push that guaranteed-1 into a good position result
    local isCOR   = player:getMainJob() == xi.job.COR
    local lvl     = player:getMainLvl()
    local chrBonus = isCOR and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    player:addMod(xi.mod.CHR, chrBonus)
    player:timer(60000, function(p)
        p:delMod(xi.mod.CHR, chrBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Snake Eye', string.format('CHR +%d', chrBonus))
    end

    return xi.effect.SNAKE_EYE
end

return abilityObject
