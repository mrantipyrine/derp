-----------------------------------
-- Ability: Drain Samba
-- Job: Dancer
-- Inflicts Drain daze on struck enemy.
-- Solo bonus: STR + Regain — the dance of hunger.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:hasStatusEffect(xi.effect.FAN_DANCE) then
        return xi.msg.basic.UNABLE_TO_USE_JA2, 0
    elseif player:getTP() < 100 then
        return xi.msg.basic.NOT_ENOUGH_TP, 0
    end
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    if not player:hasStatusEffect(xi.effect.TRANCE) then
        player:delTP(100)
    end

    local duration = 120 + player:getMod(xi.mod.SAMBA_DURATION) + (player:getJobPointLevel(xi.jp.SAMBA_DURATION) * 2)
    duration       = duration * (100 + player:getMod(xi.mod.SAMBA_PDURATION)) / 100
    player:delStatusEffect(xi.effect.HASTE_SAMBA)
    player:delStatusEffect(xi.effect.ASPIR_SAMBA)
    player:addStatusEffect(xi.effect.DRAIN_SAMBA, 1, 0, duration)

    local lvl   = player:getMainLvl()
    local isDNC = player:getMainJob() == xi.job.DNC
    local strBonus = isDNC and math.floor(lvl * 0.12) or math.floor(lvl * 0.06)
    local regain   = isDNC and math.max(2, math.floor(lvl / 14)) or 1
    player:addMod(xi.mod.STR, strBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, math.floor(duration))
    player:timer(math.floor(duration) * 1000, function(p) p:delMod(xi.mod.STR, strBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Drain Samba', string.format('STR +%d  Regain +%d', strBonus, regain))
    end
end

return abilityObject
