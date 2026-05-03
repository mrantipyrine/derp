-----------------------------------
-- Ability: Defender
-- Job: Warrior
-- The survive button. Hit this when you're in trouble.
-- DEF boost + ATT penalty handled by job_utils.
-- WAR main gets Regen to sustain the defensive window. No full-heal.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local lvl   = player:getMainLvl()
    local isWAR = player:getMainJob() == xi.job.WAR

    -- Core DEF boost + ATT penalty lives in job_utils
    xi.job_utils.warrior.useDefender(player, target, ability)

    local duration = isWAR and 180 or 90

    -- Max HP boost — meaningful breathing room, not a full heal
    local hpBoost = isWAR and 20 or 10
    player:addStatusEffect(xi.effect.MAX_HP_BOOST, hpBoost, 1, duration)

    -- WAR main only: Regen to sustain through the window
    if isWAR then
        local regenPow = math.max(3, math.floor(lvl / 12))
        player:addStatusEffect(xi.effect.REGEN, regenPow, 3, duration)
        if xi.soloSynergy then
            xi.soloSynergy.flashBuff(player, 'Defender', 'MaxHP +' .. hpBoost .. '%  Regen +' .. regenPow)
        end
    elseif xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Defender', 'MaxHP +' .. hpBoost .. '%')
    end
end

return abilityObject
