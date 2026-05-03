-----------------------------------
-- Ability: Smiting Breath
-- Job: Dragoon
-- Commands wyvern to attack with breath.
-- Solo bonus: TP gain + STR — rider and wyvern strike in unison.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dragoon.abilityCheckRequiresPet(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    xi.job_utils.dragoon.useSmitingBreath(player, target, ability, action, true)

    local lvl   = player:getMainLvl()
    local isDRG = player:getMainJob() == xi.job.DRG

    local tpGain   = isDRG and math.random(150, 280) or math.random(60, 120)
    local strBonus = isDRG and math.floor(lvl * 0.10) or math.floor(lvl * 0.05)

    player:addTP(tpGain)
    player:addMod(xi.mod.STR, strBonus)
    player:timer(20000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Smiting Breath', string.format('TP +%d  STR +%d (20s)', tpGain, strBonus))
    end
end

return abilityObject
