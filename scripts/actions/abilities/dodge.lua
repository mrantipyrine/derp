-----------------------------------
-- Ability: Dodge
-- Job: Monk
-- Pure evasion. Removed the MAX_HP_BOOST (that was insane at 200%).
-- MNK gets a real EVA number and a brief stoneskin-style buffer instead.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMNK = player:getMainJob() == xi.job.MNK
    local lvl   = player:getMainLvl()
    local duration = isMNK and 290 or 120

    -- EVA: meaningful but not "untouchable"
    -- MNK: floor(lvl * 0.5) = ~37 at 75. Sub: floor(lvl * 0.25) = ~18.
    local evaBonus = isMNK and math.floor(lvl * 0.50) or math.floor(lvl * 0.25)
    evaBonus = math.max(5, evaBonus)

    player:addStatusEffect(xi.effect.EVASION_BOOST, evaBonus, 3, duration, 0, 10, 1)

    -- MNK only: small stoneskin-equivalent — absorbs a couple of hits
    if isMNK then
        local shield = math.floor(lvl * 2.5)  -- ~187 at 75, absorbs a big hit
        player:addStatusEffect(xi.effect.STONESKIN, shield, 0, duration)
    end

    xi.job_utils.monk.useDodge(player, target, ability)
end

return abilityObject
