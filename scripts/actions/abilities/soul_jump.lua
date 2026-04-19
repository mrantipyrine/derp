-----------------------------------
-- Ability: Soul Jump
-- Job: Dragoon
-- High jump + enmity down, enhanced with wyvern.
-- Solo bonus: STR + TP — dragon soul fuels the rider.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local result = xi.job_utils.dragoon.useSoulJump(player, target, ability, action)

    local lvl   = player:getMainLvl()
    local isDRG = player:getMainJob() == xi.job.DRG

    local strBonus = isDRG and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local tpGain   = isDRG and math.random(200, 380) or math.random(80, 160)

    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Soul Jump', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end

    return result
end

return abilityObject
