-----------------------------------
-- Ability: Spirit Bond
-- Description: Enables the dragoon to take some damage on behalf of their wyvern. Using Healing Breath also restores the wyvern's HP.
-- Obtained: DRG Level 65
-- Recast Time: 00:03:00
-- Duration: 00:01:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dragoon.useSpiritBond(player, target, ability)
    -- Solo bonus
    local isDRG = player:getMainJob() == xi.job.DRG
    local lvl = player:getMainLvl()
    local strBonus = isDRG and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regain   = isDRG and 2 or 1
    player:addMod(xi.mod.STR, strBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 60)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Spirit Bond', string.format('STR +%d  Regain +%d', strBonus, regain))
    end
end

return abilityObject
