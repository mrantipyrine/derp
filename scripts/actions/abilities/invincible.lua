-----------------------------------
-- Ability: Invincible
-- Job: Paladin
-- Full physical immunity for 30s.
-- Solo bonus: Regen + MP restore — the knight uses the invulnerable window to recover.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.paladin.checkInvincible(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.paladin.useInvincible(player, target, ability)

    local lvl   = player:getMainLvl()
    local isPLD = player:getMainJob() == xi.job.PLD

    local regen  = isPLD and math.max(4, math.floor(lvl / 10)) or math.max(2, math.floor(lvl / 18))
    local mpGain = isPLD and math.floor(lvl * 1.5) or math.floor(lvl * 0.7)

    player:addStatusEffect(xi.effect.REGEN, regen, 3, 30)
    player:addMP(mpGain)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Invincible', string.format('Regen +%d  MP +%d', regen, mpGain))
    end
end

return abilityObject
