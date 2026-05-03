-----------------------------------
-- Ability: Puppet Roll
-- Enhances pet magic attack and magic accuracy for party members within area of effect
-- Optimal Job: Puppetmaster
-- Lucky Number: 3
-- Unlucky Number: 7
-- Level: 52
-- Phantom Roll +1 Value: 3
--
-- Die Roll    |No PUP  |With PUP
-- --------    -------  ----------
-- 1           |+4      |+12
-- 2           |+5      |+13
-- 3           |+18     |+26
-- 4           |+7      |+15
-- 5           |+9      |+17
-- 6           |+10     |+18
-- 7           |+2      |+10
-- 8           |+11     |+19
-- 9           |+13     |+21
-- 10          |+15     |+23
-- 11          |+22     |+30
-- Bust        |-8      |-8
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
        xi.soloSynergy.flashBuff(caster, 'Puppet Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
