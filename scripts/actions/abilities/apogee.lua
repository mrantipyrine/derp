-----------------------------------
-- Ability: Apogee
-- Job: Summoner
-- Next Blood Pact has 0 recast at increased MP cost.
-- Solo bonus: MP restore + INT — the summoner pours everything into this moment.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:hasStatusEffect(xi.effect.APOGEE) then
        return xi.msg.basic.EFFECT_ALREADY_ACTIVE, 0
    end
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.APOGEE, 1, 0, 60)

    local lvl   = player:getMainLvl()
    local isSMN = player:getMainJob() == xi.job.SMN
    local intBonus = isSMN and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local mpGain   = isSMN and math.floor(lvl * 1.5) or math.floor(lvl * 0.7)

    player:addMod(xi.mod.INT, intBonus)
    player:addMP(mpGain)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Apogee', string.format('INT +%d  MP +%d', intBonus, mpGain))
    end

    return xi.effect.APOGEE
end

return abilityObject
