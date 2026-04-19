-----------------------------------
-- Ability: Aspir Samba II
-- Job: Dancer
-- Solo bonus: INT + MP restore.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:hasStatusEffect(xi.effect.FAN_DANCE) then
        return xi.msg.basic.UNABLE_TO_USE_JA2, 0
    elseif player:hasStatusEffect(xi.effect.TRANCE) then
        return 0, 0
    elseif player:getTP() < 250 then
        return xi.msg.basic.NOT_ENOUGH_TP, 0
    end
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    if not player:hasStatusEffect(xi.effect.TRANCE) then
        player:delTP(250)
    end
    local duration = 120 + player:getMod(xi.mod.SAMBA_DURATION) + (player:getJobPointLevel(xi.jp.SAMBA_DURATION) * 2)
    duration       = duration * (100 + player:getMod(xi.mod.SAMBA_PDURATION)) / 100
    player:delStatusEffect(xi.effect.HASTE_SAMBA)
    player:delStatusEffect(xi.effect.DRAIN_SAMBA)
    player:addStatusEffect(xi.effect.ASPIR_SAMBA, 2, 0, duration)

    local lvl   = player:getMainLvl()
    local isDNC = player:getMainJob() == xi.job.DNC
    local intBonus = isDNC and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local mpGain   = isDNC and math.floor(lvl * 1.0) or math.floor(lvl * 0.5)
    player:addMod(xi.mod.INT, intBonus)
    player:addMP(mpGain)
    player:timer(math.floor(duration) * 1000, function(p) p:delMod(xi.mod.INT, intBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Aspir Samba II', string.format('INT +%d  MP +%d', intBonus, mpGain))
    end
end

return abilityObject
