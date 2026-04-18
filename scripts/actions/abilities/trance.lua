-----------------------------------
-- Ability: Trance
-- Job: Dancer
-- 1hr: dances and steps cost 0 TP for 60s.
-- Solo bonus: AGI + Regain — the dancer transcends physical limits.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.TRANCE, 1, 0, 60)
    player:addTP(100 * player:getJobPointLevel(xi.jp.TRANCE_EFFECT))

    local lvl   = player:getMainLvl()
    local isDNC = player:getMainJob() == xi.job.DNC
    local agiBonus = isDNC and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regain   = isDNC and math.max(4, math.floor(lvl / 10)) or math.max(2, math.floor(lvl / 18))

    player:addMod(xi.mod.AGI, agiBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 60)
    player:timer(60000, function(p) p:delMod(xi.mod.AGI, agiBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Trance', string.format('AGI +%d  Regain +%d', agiBonus, regain))
    end
end

return abilityObject
