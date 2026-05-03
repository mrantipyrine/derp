-----------------------------------
-- Ability: Mighty Strikes
-- Job: Warrior
-- All attacks are critical hits for 45 seconds.
-- Solo bonus: Regain + ATT burst — make every second of the window devastating.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.warrior.checkMightyStrikes(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.warrior.useMightyStrikes(player, target, ability)

    local lvl   = player:getMainLvl()
    local isWAR = player:getMainJob() == xi.job.WAR

    local attBonus = isWAR and math.floor(lvl * 0.25) or math.floor(lvl * 0.12)
    local regain   = isWAR and math.max(4, math.floor(lvl / 10)) or math.max(2, math.floor(lvl / 18))

    player:addStatusEffect(xi.effect.ATT_BOOST, attBonus, 0, 45)
    player:addStatusEffect(xi.effect.REGAIN,    regain * 10, 3, 45)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Mighty Strikes', string.format('ATT +%d  Regain +%d', attBonus, regain))
    end
end

return abilityObject
