-----------------------------------
-- Ability: Clarion Call
-- Job: Bard
-- 1hr: +1 song slot for party for 3min.
-- Solo bonus: CHR + Regain — sing more, rest never.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.CLARION_CALL, 10, 0, 180)

    local lvl   = player:getMainLvl()
    local isBRD = player:getMainJob() == xi.job.BRD
    local chrBonus = isBRD and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local regain   = isBRD and math.max(3, math.floor(lvl / 12)) or 1

    player:addMod(xi.mod.CHR, chrBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 180)
    player:timer(180000, function(p) p:delMod(xi.mod.CHR, chrBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Clarion Call', string.format('CHR +%d  Regain +%d', chrBonus, regain))
    end
end

return abilityObject
