-----------------------------------
-- Ability: Bolter's Roll
-- Increases Movement speed for party members with area of effect.
-- Optimal Job: None
-- Lucky Number: 3
-- Unlucky Number: 9
-- Level: 76
-- Phantom Roll +1 Value: 4
--
-- Die Roll    | %
-- --------    -------
-- 1           |+6
-- 2           |+6
-- 3           |+16
-- 4           |+8
-- 5           |+8
-- 6           |+10
-- 7           |+10
-- 8           |+12
-- 9           |+4
-- 10          |+14
-- 11          |+20
-- Bust        |0
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
        xi.soloSynergy.flashBuff(caster, 'Bolters\' Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
