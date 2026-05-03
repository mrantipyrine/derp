-----------------------------------
-- Ability: Hamanoha
-- Description: Lowers accuracy, evasion, magic accuracy, magic evasion and TP gain for demons.
-- Obtained: SAM Level 87
-- Recast Time: 00:05:00
-- Duration: 0:03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local jpValue = target:getJobPointLevel(xi.jp.HAMANOHA_DURATION)

    target:addStatusEffect(xi.effect.HAMANOHA, 12, 0, 180 + jpValue)
    -- Solo bonus
    local isSAM = player:getMainJob() == xi.job.SAM
    local lvl = player:getMainLvl()
    local strBonus = isSAM and math.floor(lvl * 0.24) or math.floor(lvl * 0.12)
    local tpGain   = isSAM and math.random(300, 500) or math.random(100, 200)
    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Hamanoha', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end
end

return abilityObject
