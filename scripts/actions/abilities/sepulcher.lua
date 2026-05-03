-----------------------------------
-- Ability: Sepulcher
-- Description: Lowers accuracy, evasion, magic accuracy, magic evasion and TP gain for undead.
-- Obtained: PLD Level 87
-- Recast Time: 00:05:00
-- Duration: 00:03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.paladin.checkSepulcher(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.paladin.useSepulcher(player, target, ability)
    -- Solo bonus
    local isWHM = player:getMainJob() == xi.job.WHM
    local lvl = player:getMainLvl()
    local mndBonus = isWHM and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regen    = isWHM and math.max(2, math.floor(lvl / 20)) or 1
    player:addMod(xi.mod.MND, mndBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 30)
    player:timer(30000, function(p) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Sepulcher', string.format('MND +%d  Regen +%d', mndBonus, regen))
    end
end

return abilityObject
