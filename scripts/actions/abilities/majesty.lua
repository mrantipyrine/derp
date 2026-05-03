-----------------------------------
-- Ability: Majesty
-- Description: Increases Cure potency and reduces Cure recast time. Additionally, causes Cure and Protect spells to affect party members in area of effect.
-- Obtained: PLD Level 70
-- Recast Time: 00:01:00
-- Duration: 00:03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.paladin.useMajesty(player, target, ability)
    -- Solo bonus
    local isWHM = player:getMainJob() == xi.job.WHM
    local lvl = player:getMainLvl()
    local mndBonus = isWHM and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regen    = isWHM and math.max(2, math.floor(lvl / 20)) or 1
    player:addMod(xi.mod.MND, mndBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 30)
    player:timer(30000, function(p) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Majesty', string.format('MND +%d  Regen +%d', mndBonus, regen))
    end
end

return abilityObject
