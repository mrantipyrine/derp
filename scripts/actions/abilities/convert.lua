-----------------------------------
-- Ability: Convert
-- Job: Red Mage
-- Swaps HP and MP.
-- Solo bonus: Regain + brief Haste to recover and re-engage fast.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.red_mage.useConvert(player, target, ability)

    local lvl   = player:getMainLvl()
    local isRDM = player:getMainJob() == xi.job.RDM

    local regain   = isRDM and math.max(3, math.floor(lvl / 12)) or math.max(1, math.floor(lvl / 22))
    local hasteAmt = isRDM and 10 or 5

    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 30)
    player:addStatusEffect(xi.effect.HASTE,  hasteAmt, 0, 20)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Convert', string.format('Regain +%d  Haste +%d%% (20s)', regain, hasteAmt))
    end
end

return abilityObject
