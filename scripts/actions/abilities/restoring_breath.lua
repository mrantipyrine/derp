-----------------------------------
-- Ability: Restoring Breath
-- Orders the wyvern to heal with its breath.
-- Obtained: Dragoon Level 90
-- Recast Time: 01:00
-- Duration: instant
-----------------------------------
local abilityObject = {}

-- TODO: find out what checks can result in being unable to use ability on the pet --
-- such as if the wyvern has amnesia, stun, etc
abilityObject.onAbilityCheck = function(player, target, ability)
    -- You can't actually use Restoring Breath on retail unless your wyvern is up
    -- This is on the pet menu, but just in case...
    return xi.job_utils.dragoon.abilityCheckRequiresPet(player, target, ability, true)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    xi.job_utils.dragoon.useRestoringBreath(player, ability, action)
    -- Solo bonus
    local isDRG = player:getMainJob() == xi.job.DRG
    local lvl = player:getMainLvl()
    local strBonus = isDRG and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regain   = isDRG and 2 or 1
    player:addMod(xi.mod.STR, strBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 60)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Restoring Breath', string.format('STR +%d  Regain +%d', strBonus, regain))
    end
end

return abilityObject
