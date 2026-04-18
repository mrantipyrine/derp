-----------------------------------
-- Ability: Warrior's Charge
-- Job: Warrior
-- Grants TP — the WAR converts momentum into weapon skill readiness.
-- Solo bonus: bonus TP + brief Haste to chain into the WS immediately.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.warrior.useWarriorsCharge(player, target, ability)

    local lvl   = player:getMainLvl()
    local isWAR = player:getMainJob() == xi.job.WAR

    local tpGain  = isWAR and math.random(250, 450) or math.random(100, 200)
    local hasteAmt = isWAR and 10 or 5

    player:addTP(tpGain)
    player:addStatusEffect(xi.effect.HASTE, hasteAmt, 0, 20)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, "Warrior's Charge", string.format('TP +%d  Haste +%d%% (20s)', tpGain, hasteAmt))
    end
end

return abilityObject
