-----------------------------------
-- Ability: Spontaneity
-- Job: Red Mage
-- Reduces next spell cast time.
-- Solo bonus: MP restore + Regain — the sorcerer seizes the moment.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.red_mage.useSpontaneity(player, target, ability)

    local lvl   = player:getMainLvl()
    local isRDM = player:getMainJob() == xi.job.RDM

    local mpGain = isRDM and math.floor(lvl * 1.2) or math.floor(lvl * 0.5)
    local regain = isRDM and math.max(2, math.floor(lvl / 14)) or 1

    player:addMP(mpGain)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 30)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Spontaneity', string.format('MP +%d  Regain +%d', mpGain, regain))
    end
end

return abilityObject
