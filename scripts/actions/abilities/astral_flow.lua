-----------------------------------
-- Ability: Astral Flow
-- Job: Summoner
-- 1hr: full avatar power + Odin/Alexander access for 3min.
-- Solo bonus: INT + MP restore — channel the astral plane.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.ASTRAL_FLOW, 1, 0, 180)

    local lvl   = player:getMainLvl()
    local isSMN = player:getMainJob() == xi.job.SMN
    local intBonus = isSMN and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local mpGain   = isSMN and math.floor(lvl * 2.5) or math.floor(lvl * 1.2)

    player:addMod(xi.mod.INT, intBonus)
    player:addMP(mpGain)
    player:timer(180000, function(p) p:delMod(xi.mod.INT, intBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Astral Flow', string.format('INT +%d  MP +%d', intBonus, mpGain))
    end

    return xi.effect.ASTRAL_FLOW
end

return abilityObject
