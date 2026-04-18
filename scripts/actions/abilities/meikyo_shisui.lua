-----------------------------------
-- Ability: Meikyo Shisui
-- Reduces weaponskill TP cost to 0 for 30 seconds.
-- Obtained: Samurai Level 1 (1-hour ability)
-- Free 3000 TP on top of the effect was too much. Gives 1000 TP now —
-- enough to open with a WS the moment you pop it, not skip the whole fight.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.MEIKYO_SHISUI, 1, 0, 30)
    -- Enough TP to open the window with a WS immediately, not to skip needing it
    player:addTP(1000)
end

return abilityObject
