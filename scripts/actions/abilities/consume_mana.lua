-----------------------------------
-- Ability: Consume Mana
-- Description: Converts all MP into damage for the next attack.
-- Obtained: Dark Knight Level 55
-- Recast Time: 00:01:00 (or next attack)
-- Duration: 00:01:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dark_knight.useConsumeMana(player, target, ability)
    -- Solo bonus
    local isBLM = player:getMainJob() == xi.job.BLM
    local lvl = player:getMainLvl()
    local intBonus = isBLM and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Consume Mana', string.format('INT +%d', intBonus))
    end
end

return abilityObject
