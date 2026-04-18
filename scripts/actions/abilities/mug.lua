-----------------------------------
-- Ability: Mug
-- Steal HP and TP from an enemy.
-- Obtained: Thief Level 35
-- Recast Time: 5:00
-- Removed: 20% insta-kill chance. That wasn't Mug, that was a cheat code.
-- Kept: HP and TP drain with reasonable scaling.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability, action)
    if player:getMainJob() ~= xi.job.THF then
        return xi.job_utils.thief.useMug(player, target, ability, action)
    end

    local lvl = player:getMainLvl()

    -- HP steal: decent sustain, scales with level
    local hpSteal = lvl > 40 and math.random(200, 500) or math.random(80, 250)
    -- TP steal: punishes the mob, rewards you
    local tpSteal = lvl > 40 and math.random(400, 800) or math.random(150, 400)

    -- Cap stolen HP to what target actually has
    hpSteal = math.min(hpSteal, target:getHP() - 1)

    if hpSteal > 0 then
        player:addHP(hpSteal)
        target:addHP(-hpSteal)
    end

    player:addTP(tpSteal)
    target:addTP(-tpSteal)

    return xi.job_utils.thief.useMug(player, target, ability, action)
end

return abilityObject
