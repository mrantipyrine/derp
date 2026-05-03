-----------------------------------
-- Ability: Scarlet Delirium
-- Description: Channels damage taken into enhanced attack and magic attack.
-- Obtained: Dark Knight Level 95
-- Recast Time: 00:01:30
-- Duration: 00:01:30
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dark_knight.useScarletDelirium(player, target, ability)
    -- Solo bonus
    local isPUP = player:getMainJob() == xi.job.PUP
    local lvl = player:getMainLvl()
    local strBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local intBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.INT, intBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Scarlet Delirium', string.format('STR +%d  INT +%d', strBonus, intBonus))
    end
end

return abilityObject
