-----------------------------------
-- Ability: Souleater
-- Job: Dark Knight
-- Consumes your own HP to enhance attacks.
-- Solo bonus: ATT boost + Regain so the DRK doesn't collapse mid-fight.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dark_knight.useSouleater(player, target, ability)

    local lvl   = player:getMainLvl()
    local isDRK = player:getMainJob() == xi.job.DRK

    local attBonus = isDRK and math.floor(lvl * 0.22) or math.floor(lvl * 0.10)
    local regain   = isDRK and math.max(3, math.floor(lvl / 12)) or math.max(1, math.floor(lvl / 20))

    player:addStatusEffect(xi.effect.ATT_BOOST, attBonus, 0, 60)
    player:addStatusEffect(xi.effect.REGAIN,    regain * 10, 3, 60)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Souleater', string.format('ATT +%d  Regain +%d', attBonus, regain))
    end
end

return abilityObject
