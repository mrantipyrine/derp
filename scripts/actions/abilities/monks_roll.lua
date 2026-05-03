-----------------------------------
-- Ability: Monk's Roll
-- Enhances "Subtle Blow" effect for party members within area of effect
-- Optimal Job: Monk
-- Lucky Number: 3
-- Unlucky Number: 7
-- Level: 31
-- Phantom Roll +1 Value: 4
--
-- Die Roll    |No MNK  |With MNK
-- --------    -------- -----------
-- 1           |+8      |+18
-- 2           |+10     |+20
-- 3           |+32     |+42
-- 4           |+12     |+22
-- 5           |+14     |+24
-- 6           |+16     |+26
-- 7           |+4      |+14
-- 8           |+20     |+30
-- 9           |+22     |+32
-- 10          |+24     |+34
-- 11          |+40     |+50
-- Bust        |-11     |-11
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
        xi.soloSynergy.flashBuff(caster, 'Monk\'s Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
