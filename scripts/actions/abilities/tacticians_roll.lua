-----------------------------------
-- Ability: Tacticians's Roll
-- Grants a Regain effect to party members within area of effect.
-- Optimal Job: None
-- Lucky Number: 5
-- Unlucky Number: 8
-- Level: 86
-- Phantom Roll +1 Value: 2
--
-- Die Roll    | Regain
-- --------    -------
-- 1           |+10
-- 2           |+10
-- 3           |+10
-- 4           |+10
-- 5           |+30
-- 6           |+10
-- 7           |+10
-- 8           |+0
-- 9           |+20
-- 10          |+20
-- 11          |+40
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
        xi.soloSynergy.flashBuff(caster, 'Tactician\'s Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
