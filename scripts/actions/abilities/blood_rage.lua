-----------------------------------
-- Ability: Blood Rage
-- Job: Warrior
-- Party ATT/DA buff — the battle cry of the berserking warrior.
-- Solo bonus: higher self-buff values + TP surge.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.warrior.useBloodRage(player, target, ability)

    local lvl   = player:getMainLvl()
    local isWAR = player:getMainJob() == xi.job.WAR

    local attBonus = isWAR and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local tpGain   = isWAR and math.random(200, 350) or math.random(80, 150)

    player:addStatusEffect(xi.effect.ATT_BOOST, attBonus, 0, 30)
    player:addTP(tpGain)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Blood Rage', string.format('ATT +%d  TP +%d', attBonus, tpGain))
    end
end

return abilityObject
