-----------------------------------
-- Ability: Blood Weapon
-- Job: Dark Knight
-- Causes all attacks to drain enemy HP.
-- Solo bonus: TP on activation + Regain to sustain the drain window.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dark_knight.checkBloodWeapon(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dark_knight.useBloodWeapon(player, target, ability)

    local lvl   = player:getMainLvl()
    local isDRK = player:getMainJob() == xi.job.DRK

    local tpGain = isDRK and math.random(200, 400) or math.random(80, 150)
    local regain = isDRK and math.max(2, math.floor(lvl / 14)) or 1

    player:addTP(tpGain)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 30)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Blood Weapon', string.format('TP +%d  Regain +%d', tpGain, regain))
    end
end

return abilityObject
