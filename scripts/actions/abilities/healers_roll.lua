-----------------------------------
-- Ability: Healer's Roll
-- Increases potency of "Cure" effect received for party members within area of effect
-- Optimal Job: White Mage
-- Lucky Number: 3
-- Unlucky Number: 7
-- Level: 20
-- Phantom Roll +1 Value: 3
--
-- Die Roll    |No WHM  |With WHM
-- --------    -------  -----------
-- 1           |+3%     |+7%
-- 2           |+4%     |+8%
-- 3           |+12%    |+16%
-- 4           |+5%     |+9%
-- 5           |+6%     |+10%
-- 6           |+7%     |+11%
-- 7           |+1%     |+5%
-- 8           |+8%     |+12%
-- 9           |+9%     |+13%
-- 10          |+10%    |+14%
-- 11          |+16%    |+20%
-- Bust        |-4%     |-4%
--
-- Note that this roll will increase potency of cures received, not the potency of the caster's spells
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
        xi.soloSynergy.flashBuff(caster, 'Healer\'s Roll', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end

    return result
end

return abilityObject
