-----------------------------------
-- Ability: Avenger's Roll
-- Increases chance of countering for party members within area of effect.
-- Optimal Job: None
-- Lucky Number: 4
-- Unlucky Number: 8
-- Level: 97
--
-- No community data available. Substituting Fighters Roll %
-- Phantom Roll +1 Value: 1
--
-- Die Roll    |Counter
-- --------    --------
-- 1           |2%
-- 2           |2%
-- 3           |3%
-- 4           |12%
-- 5           |4%
-- 6           |5%
-- 7           |6%
-- 8           |1%
-- 9           |7%
-- 10          |9%
-- 11          |18%
-- 12+         |-6%
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
        xi.soloSynergy.flashBuff(caster, 'Avengers\' Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
