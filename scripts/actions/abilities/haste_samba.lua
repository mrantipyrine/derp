-----------------------------------
-- Ability: Haste Samba
-- Job: Dancer
-- Inflicts Haste daze on struck enemy.
-- Solo bonus: AGI + Regain — the dancer keeps the rhythm flowing.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:hasStatusEffect(xi.effect.FAN_DANCE) then
        return xi.msg.basic.UNABLE_TO_USE_JA2, 0
    elseif player:getTP() < 350 then
        return xi.msg.basic.NOT_ENOUGH_TP, 0
    end
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    if not player:hasStatusEffect(xi.effect.TRANCE) then
        player:delTP(350)
    end

    local duration = 120 + player:getMod(xi.mod.SAMBA_DURATION) + (player:getJobPointLevel(xi.jp.SAMBA_DURATION) * 2)
    duration       = duration * (100 + player:getMod(xi.mod.SAMBA_PDURATION)) / 100
    player:delStatusEffect(xi.effect.DRAIN_SAMBA)
    player:delStatusEffect(xi.effect.ASPIR_SAMBA)
    player:addStatusEffect(xi.effect.HASTE_SAMBA, 500 + player:getMerit(xi.merit.HASTE_SAMBA_EFFECT), 0, duration)

    local lvl   = player:getMainLvl()
    local isDNC = player:getMainJob() == xi.job.DNC
    local agiBonus = isDNC and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local regain   = isDNC and math.max(2, math.floor(lvl / 14)) or 1
    player:addMod(xi.mod.AGI, agiBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, math.floor(duration))
    player:timer(math.floor(duration) * 1000, function(p) p:delMod(xi.mod.AGI, agiBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Haste Samba', string.format('AGI +%d  Regain +%d', agiBonus, regain))
    end
end

return abilityObject
