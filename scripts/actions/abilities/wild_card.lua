-----------------------------------
-- Ability: Wild Card
-- Has a random effect on all party members within area of effect.
-- Obtained: Corsair Level 1
-- Recast Time: 1:00:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))

    return 0, 0
end

abilityObject.onUseAbility = function(caster, target, ability, action)
    local result = xi.job_utils.corsair.useWildCard(caster, target, ability, action)

    -- Solo bonus: CHR + big TP burst — you're gambling everything, make it count
    local isCOR  = caster:getMainJob() == xi.job.COR
    local lvl    = caster:getMainLvl()
    local chrBonus = isCOR and math.floor(lvl * 0.25) or math.floor(lvl * 0.12)
    local tpGain   = isCOR and math.random(600, 1000) or math.random(200, 400)
    caster:addMod(xi.mod.CHR, chrBonus)
    caster:addTP(tpGain)
    caster:timer(60000, function(p)
        p:delMod(xi.mod.CHR, chrBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(caster, 'Wild Card', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
