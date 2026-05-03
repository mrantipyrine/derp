-----------------------------------
-- Ability: Alacrity
-- Reduces the casting and the recast time of your next black magic spell by 50%.
-- Obtained: Scholar Level 25
-- Recast Time: Stratagem Charge
-- Duration: 1 black magic spell or 60 seconds, whichever occurs first.
--
-- Level   |Charges |Recharge Time per Charge
-- -----   -------- ---------------
-- 10      |1       |4:00 minutes
-- 30      |2       |2:00 minutes
-- 50      |3       |1:20 minutes
-- 70      |4       |1:00 minute
-- 90      |5       |48 seconds
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:hasStatusEffect(xi.effect.ALACRITY) then
        return xi.msg.basic.EFFECT_ALREADY_ACTIVE, 0
    end

    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.ALACRITY, 1, 0, 60)

    -- Solo bonus
    local isSCH = player:getMainJob() == xi.job.SCH
    local lvl = player:getMainLvl()
    local intBonus = isSCH and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local mndBonus = isSCH and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Alacrity', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end

    return xi.effect.ALACRITY
end

return abilityObject
