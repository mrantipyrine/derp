-----------------------------------
-- Ability: Sekkanoki
-- Limits TP cost of next weapon skill to 100.
-- Obtained: Samurai Level 40
-- Recast Time: 0:05:00
-- Duration: 01:00, or until a weapon skill is used
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:delStatusEffect(xi.effect.SEKKANOKI)
    target:addStatusEffect(xi.effect.SEKKANOKI, 1, 0, 60)

    -- Solo bonus: STR and TP so the cheap WS still hits hard
    local isSAM   = player:getMainJob() == xi.job.SAM
    local lvl     = player:getMainLvl()
    local strBonus = isSAM and math.floor(lvl * 0.26) or math.floor(lvl * 0.13)
    local tpGain   = isSAM and math.random(300, 500) or math.random(100, 200)
    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(60000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Sekkanoki', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end
end

return abilityObject
