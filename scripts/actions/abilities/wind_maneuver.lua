-----------------------------------
-- Ability: Wind Maneuver
-- Enhances the effect of wind attachments. Must have animator equipped.
-- Obtained: Puppetmaster level 1
-- Recast Time: 10 seconds (shared with all maneuvers)
-- Duration: 1 minute
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.automaton.onManeuverCheck(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    return xi.automaton.onUseManeuver(player, target, ability, action)
    -- Solo bonus
    local isPUP = player:getMainJob() == xi.job.PUP
    local lvl = player:getMainLvl()
    local strBonus = isPUP and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local intBonus = isPUP and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.INT, intBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Wind Maneuver', string.format('STR +%d  INT +%d', strBonus, intBonus))
    end
end

return abilityObject
