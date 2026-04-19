-----------------------------------
-- Ability: Companion's Roll
-- Grants "Regain" and "Regen" effects to pets of party members within area of effect.
-- Optimal Job: None
-- Lucky Number: 2
-- Unlucky Number: 10
-- Level: 95
-- Phantom Roll +1 Value: 5/2
--
-- Die Roll Logic in globals/effects/companions_roll.lua
--
-- Die Roll    | Regain | Regen
-- --------    -------   -------
-- 1           |+20     |+4
-- 2           |+50     |+20
-- 3           |+20     |+6
-- 4           |+20     |+8
-- 5           |+30     |+10
-- 6           |+30     |+12
-- 7           |+30     |+14
-- 8           |+40     |+16
-- 9           |+40     |+18
-- 10          |+10     |+3
-- 11          |+60     |+25
-- Bust        |-0      | 0
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
        xi.soloSynergy.flashBuff(caster, 'Companions\' Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
