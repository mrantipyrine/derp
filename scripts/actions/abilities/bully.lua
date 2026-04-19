-----------------------------------
-- Ability: Bully
-- Intimidates target. (About 15% proc rate)
-- Removes the direction requirement from Sneak Attack for main job Thieves when active.
-- Obtained: Thief Level 93
-- Recast Time: 3:00
-- Duration: 0:30
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    -- Solo bonus
    local isPUP = player:getMainJob() == xi.job.PUP
    local lvl = player:getMainLvl()
    local strBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local intBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.INT, intBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Bully', string.format('STR +%d  INT +%d', strBonus, intBonus))
    end

    return xi.job_utils.thief.useBully(player, target, ability)
end

return abilityObject
