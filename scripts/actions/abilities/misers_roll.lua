-----------------------------------
-- Ability: Miser's Roll
-- Grants "Save TP" effect to party members within area of effect.
-- Optimal Job: None
-- Lucky Number: 5
-- Unlucky Number: 7
-- Level: 92
-- Phantom Roll +1 Value: 15
--
-- Die Roll    | Skillchain Bonus
-- --------    -------
-- 1           |+30
-- 2           |+50
-- 3           |+70
-- 4           |+90
-- 5           |+200
-- 6           |+110
-- 7           |+20
-- 8           |+130
-- 9           |+150
-- 10          |+170
-- 11          |+250
-- Bust        |-0
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
        xi.soloSynergy.flashBuff(caster, 'Miser\'s Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
