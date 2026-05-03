-----------------------------------
-- Ability: Samurai Roll
-- Enhances "Store TP" effect for party members within area of effect
-- Optimal Job: Samurai
-- Lucky Number: 2
-- Unlucky Number: 6
-- Level 37
-- Phantom Roll +1 Value: 4
--
-- Die Roll    |No SAM  |With SAM
-- 1           |+8      |+18
-- 2           |+32     |+42
-- 3           |+10     |+20
-- 4           |+12     |+22
-- 5           |+14     |+24
-- 6           |+4      |+14
-- 7           |+16     |+26
-- 8           |+20     |+30
-- 9           |+22     |+32
-- 10          |+24     |+34
-- 11          |+40     |+50
-- Bust        |-5      |-5
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.corsair.onRollAbilityCheck(player, target, ability)
end

abilityObject.onUseAbility = function(caster, target, ability, action)
    local result = xi.job_utils.corsair.onRollUseAbility(caster, target, ability, action)

    -- Solo bonus: CHR seeds better roll outcomes; TP lets you WS right after rolling
    local isCOR  = caster:getMainJob() == xi.job.COR
    local lvl    = caster:getMainLvl()
    local chrBonus = isCOR and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local tpGain   = isCOR and math.random(200, 400) or math.random(80, 160)
    caster:addMod(xi.mod.CHR, chrBonus)
    caster:addTP(tpGain)
    caster:timer(180000, function(p)
        p:delMod(xi.mod.CHR, chrBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(caster, 'Samurai Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
