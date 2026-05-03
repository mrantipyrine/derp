-----------------------------------
-- Ability: Inner Strength
-- Description: Increases your maximum HP.
-- Obtained: MNK Level 96
-- Recast Time: 01:00:00
-- Duration: 0:00:30
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.monk.checkInnerStrength(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.monk.useInnerStrength(player, target, ability)

    local isMNK    = player:getMainJob() == xi.job.MNK
    local lvl      = player:getMainLvl()

    -- STR for the punch-through; Regen to help burn through the HP cost
    local strBonus = isMNK and math.floor(lvl * 0.32) or math.floor(lvl * 0.16)
    local regen    = isMNK and math.max(3, math.floor(lvl / 12)) or 1
    player:addMod(xi.mod.STR, strBonus)
    player:timer(30000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 30)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Inner Strength', string.format('STR +%d  Regen +%d', strBonus, regen))
    end
end

return abilityObject
