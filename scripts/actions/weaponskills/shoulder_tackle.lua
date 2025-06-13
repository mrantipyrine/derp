-----------------------------------
-- Shoulder Tackle
-- Hand-to-Hand weapon skill
-- Skill Level: 40
-- Stuns target. Chance of stunning varies with TP.
-- Will stack with Sneak Attack.
-- Aligned with the Aqua Gorget & Thunder Gorget.
-- Aligned with the Aqua Belt & Thunder Belt.
-- Element: None
-- Modifiers: VIT:30%
-- 100%TP    200%TP    300%TP
-- 1.00      1.00      1.00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    
    local tpGain = math.random(500, 1500)
    
    -- Grant TP to the player
    player:addTP(tpGain)

    -- Increase evasion by 50 for 2 minutes
    local evasionIncrease = 50
    local evasionDuration = 120 -- 2 minutes in seconds
    player:addStatusEffect(xi.effect.EVASION_BOOST, evasionIncrease, 3, evasionDuration, 0, 10, 1)

    -- Enhance counter ability by +5 for 2 minutes
    local counterIncrease = 5
    local counterDuration = 120 -- 2 minutes in seconds
    player:addStatusEffect(xi.effect.COUNTER_BOOST, counterIncrease, 3, counterDuration, 0, 10, 1)

end 

return abilityObject
