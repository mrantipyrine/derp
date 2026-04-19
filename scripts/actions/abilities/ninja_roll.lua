-----------------------------------
-- Ability: Ninja Roll
-- Enhances evasion for party members within area of effect
-- Optimal Job: Ninja
-- Lucky Number: 4
-- Unlucky Number: 8
-- Jobs:
-- Corsair Level 8
-- Phantom Roll +1 Value: 2
--
-- Die Roll    |With NIN
-- --------    ----------
-- 1           |+4
-- 2           |+6
-- 3           |+8
-- 4           |+25
-- 5           |+10
-- 6           |+12
-- 7           |+14
-- 8           |+2
-- 9           |+17
-- 10          |+20
-- 11          |+30
-- Bust        |-10
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
        xi.soloSynergy.flashBuff(caster, 'Ninja Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
