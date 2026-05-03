-----------------------------------
-- Ability: Rogue's Roll
-- Improves critical hit rate for party members within area of effect
-- Optimal Job: Thief
-- Lucky Number: 5
-- Unlucky Number: 9
-- Level: 43
-- Phantom Roll +1 Value: 1
--
-- Die Roll    |No THF  |With THF
-- --------    -------  -----------
-- 1           |2%      |8%
-- 2           |2%      |8%
-- 3           |3%      |9%
-- 4           |4%      |10%
-- 5           |12%     |18%
-- 6           |5%      |11%
-- 7           |6%      |12%
-- 8           |6%      |12%
-- 9           |1%      |7%
-- 10          |8%      |14%
-- 11          |19%     |25%
-- 12+         |-6%     |-6%
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
        xi.soloSynergy.flashBuff(caster, 'Rogue\'s Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
