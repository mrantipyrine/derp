-----------------------------------
-- Ability: Steady Wing
-- Creates a barrier that temporarily absorbs a certain amount of damage dealt to your wyvern.
-- Obtained: Dragoon Level 95
-- Recast Time: 05:00
-- Duration:    03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    -- You can't actually use Steady Wing on retail unless your wyvern is up
    -- This is on the pet menu, but just in case...
    return xi.job_utils.dragoon.abilityCheckRequiresPet(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    xi.job_utils.dragoon.useSteadyWing(player, target, ability, action)
    -- Solo bonus
    local isDRG = player:getMainJob() == xi.job.DRG
    local lvl = player:getMainLvl()
    local strBonus = isDRG and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regain   = isDRG and 2 or 1
    player:addMod(xi.mod.STR, strBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 60)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Steady Wing', string.format('STR +%d  Regain +%d', strBonus, regain))
    end
end

return abilityObject
