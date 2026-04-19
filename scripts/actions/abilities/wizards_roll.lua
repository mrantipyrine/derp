-----------------------------------
-- Ability: Wizard's Roll
-- Enhances magic attack for party members within area of effect
-- Optimal Job: Black Mage
-- Lucky Number: 5
-- Unlucky Number: 9
-- Level 58
-- Phantom Roll +1 Value: 2
--
-- Die Roll    |No BLM  |With BLM
-- --------    -------- -----------
-- 1           |+4      |+14
-- 2           |+6      |+16
-- 3           |+8      |+18
-- 4           |+10     |+20
-- 5           |+25     |+35
-- 6           |+12     |+22
-- 7           |+14     |+24
-- 8           |+17     |+27
-- 9           |+2      |+12
-- 10          |+20     |+10
-- 11          |+30     |+40
-- Bust        |-10     |-10
--
-- If the Corsair is a lower level than the player receiving Wizard's Roll, the +MAB will be reduced
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
        xi.soloSynergy.flashBuff(caster, 'Wizard\'s Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
