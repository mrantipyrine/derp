-----------------------------------
-- Ability: Innin
-- Job: Ninja
-- Rear-attack bonus: ACC, crit rate, ninjutsu damage. Reduced enmity.
-- Solo bonus: AGI + brief EVA to slip between hits while dealing death from behind.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:delStatusEffect(xi.effect.INNIN)
    target:delStatusEffect(xi.effect.YONIN)
    target:addStatusEffect(xi.effect.INNIN, 30, 15, 300, 0, 20)

    local lvl   = player:getMainLvl()
    local isNIN = player:getMainJob() == xi.job.NIN

    local agiBonus = isNIN and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local evaBonus = isNIN and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)

    player:addMod(xi.mod.AGI, agiBonus)
    player:addMod(xi.mod.EVA, evaBonus)
    player:timer(300000, function(p)
        p:delMod(xi.mod.AGI, agiBonus)
        p:delMod(xi.mod.EVA, evaBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Innin', string.format('AGI +%d  EVA +%d', agiBonus, evaBonus))
    end
end

return abilityObject
