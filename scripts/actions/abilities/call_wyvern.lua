-----------------------------------
-- Ability: Call Wyvern
-- Summons a Wyvern to fight by your side.
-- Obtained: Dragoon Level 1
-- Recast Time: 20:00
-- Duration: Instant
-- Special: Only available if Dragoon is your main class.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dragoon.abilityCheckCallWyvern(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dragoon.useCallWyvern(player, target, ability)
    -- Solo bonus
    local isDRG = player:getMainJob() == xi.job.DRG
    local lvl = player:getMainLvl()
    local strBonus = isDRG and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regain   = isDRG and 2 or 1
    player:addMod(xi.mod.STR, strBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 60)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Call Wyvern', string.format('STR +%d  Regain +%d', strBonus, regain))
    end
end

return abilityObject
