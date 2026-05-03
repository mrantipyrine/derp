-----------------------------------
-- Ability: Issekigan
-- Job: Ninja
-- Parry rate up + enmity on parry.
-- Solo bonus: Regain so parrying refuels your next ninjutsu.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:addStatusEffect(xi.effect.ISSEKIGAN, 25, 0, 60)

    local lvl   = player:getMainLvl()
    local isNIN = player:getMainJob() == xi.job.NIN

    local regain = isNIN and math.max(3, math.floor(lvl / 12)) or math.max(1, math.floor(lvl / 22))

    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 60)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Issekigan', string.format('Regain +%d', regain))
    end
end

return abilityObject
