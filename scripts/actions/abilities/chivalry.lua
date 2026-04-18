-----------------------------------
-- Ability: Chivalry
-- Job: Paladin
-- Converts TP to MP.
-- Solo bonus: bonus MP on top + Regain to rebuild TP quickly.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local result = xi.job_utils.paladin.useChivalry(player, target, ability)

    local lvl   = player:getMainLvl()
    local isPLD = player:getMainJob() == xi.job.PLD

    local mpBonus = isPLD and math.floor(lvl * 1.2) or math.floor(lvl * 0.5)
    local regain  = isPLD and math.max(2, math.floor(lvl / 14)) or 1

    player:addMP(mpBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 30)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Chivalry', string.format('MP +%d  Regain +%d (30s)', mpBonus, regain))
    end

    return result
end

return abilityObject
