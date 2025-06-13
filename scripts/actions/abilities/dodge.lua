-----------------------------------
-- Ability: Dodge
-- Enhances user's evasion.
-- Obtained: Monk Level 15
-- Recast Time: 5:00
-- Duration: 2:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    -- Set base evasion increase and duration
    local evasionIncrease = 10
    local duration = 120

    -- Increase evasion and duration if main job is MNK
    if player:getMainJob() == xi.job.MNK then
        evasionIncrease = 50
        duration = 290

        -- Double the player's maximum HP temporarily
        local maxHPBoost =  player:getHP() * 4
        player:addStatusEffect(xi.effect.MAX_HP_BOOST, 90, 1, duration)
    end

    -- Apply evasion boost
    player:addStatusEffect(xi.effect.EVASION_BOOST, evasionIncrease, 3, duration)

    -- Trigger the Dodge ability
    xi.job_utils.monk.useDodge(player, target, ability)
end 

return abilityObject
