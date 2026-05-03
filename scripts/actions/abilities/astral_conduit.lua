-----------------------------------
-- Ability: Astral Conduit
-- Job: Summoner
-- 1hr: Blood Pact recast 0 for 30s.
-- Solo bonus: INT + Regain — the conduit fuels both sides.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.ASTRAL_CONDUIT, 15, 1, 30)

    local lvl   = player:getMainLvl()
    local isSMN = player:getMainJob() == xi.job.SMN
    local intBonus = isSMN and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local regain   = isSMN and math.max(4, math.floor(lvl / 10)) or math.max(2, math.floor(lvl / 18))

    player:addMod(xi.mod.INT, intBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 30)
    player:timer(30000, function(p) p:delMod(xi.mod.INT, intBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Astral Conduit', string.format('INT +%d  Regain +%d', intBonus, regain))
    end
end

return abilityObject
