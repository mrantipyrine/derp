-----------------------------------
-- Ability: Hunter's Roll
-- Enhances accuracy and ranged accuracy for party members within area of effect
-- Optimal Job: Ranger
-- Lucky Number: 4
-- Unlucky Number: 8
-- Level: 11
-- Phantom Roll +1 Value: 5
--
-- Die Roll    |Without RNG |With RNG
-- --------    ------------ -------
-- 1           |+10         |+25
-- 2           |+13         |+28
-- 3           |+15         |+30
-- 4           |+40         |+55
-- 5           |+18         |+33
-- 6           |+20         |+35
-- 7           |+25         |+40
-- 8           |+5          |+20
-- 9           |+27         |+42
-- 10          |+30         |+45
-- 11          |+50         |+65
-- Bust        |-5          |-5
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
        xi.soloSynergy.flashBuff(caster, 'Hunter\'s Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
