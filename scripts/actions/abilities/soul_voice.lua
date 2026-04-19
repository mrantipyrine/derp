-----------------------------------
-- Ability: Soul Voice
-- Job: Bard
-- 1hr: all songs enhanced for 3min.
-- Solo bonus: CHR + MP — the bard's voice carries across the empty field.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.SOUL_VOICE, 1, 0, 180)

    local lvl   = player:getMainLvl()
    local isBRD = player:getMainJob() == xi.job.BRD
    local chrBonus = isBRD and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local mpGain   = isBRD and math.floor(lvl * 2.0) or math.floor(lvl * 0.9)

    player:addMod(xi.mod.CHR, chrBonus)
    player:addMP(mpGain)
    player:timer(180000, function(p) p:delMod(xi.mod.CHR, chrBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Soul Voice', string.format('CHR +%d  MP +%d', chrBonus, mpGain))
    end
end

return abilityObject
