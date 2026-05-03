-----------------------------------
-- Ability: Corsair's Roll
-- Increases the amount of experience points earned by party members within area of effect
-- Optimal Job: Corsair
-- Lucky Number: 5
-- Unlucky Number: 9
-- Level: 5
-- Phantom Roll +1 Value: 2
--
-- Die Roll    |Exp Bonus%
-- --------    -----------
-- 1           |10%
-- 2           |11%
-- 3           |11%
-- 4           |12%
-- 5           |20%
-- 6           |13%
-- 7           |15%
-- 8           |16%
-- 9           |8%
-- 10          |17%
-- 11          |24%
-- 12+         |-6%
--
-- Bust for Corsair set as subjob is also -6%.
-- Corsair set as subjob is 7% on Lucky roll (5) and 1% on Unlucky roll (9).
-- The EXP bonus afforded by Corsair's Roll does not apply within Abyssea.
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
        xi.soloSynergy.flashBuff(caster, 'Corsair\'s Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
