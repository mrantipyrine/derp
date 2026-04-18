-----------------------------------
-- Ability: Focus
-- Job: Monk
-- Precision mode. Big ACC, counter window, triple attack burst, TP spike.
-- The setup ability before a series of heavy hits.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMNK = player:getMainJob() == xi.job.MNK
    local lvl   = player:getMainLvl()
    local duration = 120

    -- ACC: primary benefit
    local accBonus = isMNK and math.floor(lvl / 5) or math.floor(lvl / 8)

    -- Small Temple Crown bonus kept as flavour (toned down)
    if player:getEquipID(xi.slot.HEAD) == xi.item.TEMPLE_CROWN then
        accBonus = accBonus + 10
    end

    player:addStatusEffect(xi.effect.ACCURACY_BOOST, accBonus, 3, duration)

    -- TP spike: MNK gets a real boost, sub gets something
    local tpGain = isMNK and math.random(400, 600) or math.random(100, 200)
    player:addTP(tpGain)

    -- Triple attack window: 15% MNK main, 6% sub (short burst feel)
    local taRate = isMNK and 15 or 6
    player:addMod(xi.mod.TRIPLE_ATTACK, taRate, 3, duration, 0, 10, 1)

    -- Counter boost for MNK only — this is part of their identity
    if isMNK then
        player:addStatusEffect(xi.effect.COUNTER_BOOST, lvl, 3, duration, 0, 10, 1)
    end

    xi.job_utils.monk.useFocus(player, target, ability)
end

return abilityObject
