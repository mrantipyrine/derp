-----------------------------------
-- Ability: Jump
-- Job: Dragoon
-- Jumping attack on target.
-- Solo bonus: TP after landing + STR burst for the follow-up.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local result = xi.job_utils.dragoon.useJump(player, target, ability, action)

    local lvl   = player:getMainLvl()
    local isDRG = player:getMainJob() == xi.job.DRG

    local tpGain   = isDRG and math.random(150, 280) or math.random(60, 120)
    local strBonus = isDRG and math.floor(lvl * 0.10) or math.floor(lvl * 0.05)

    player:addTP(tpGain)
    player:addMod(xi.mod.STR, strBonus)
    player:timer(30000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Jump', string.format('TP +%d  STR +%d (30s)', tpGain, strBonus))
    end

    return result
end

return abilityObject
