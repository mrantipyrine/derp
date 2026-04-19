-----------------------------------
-- Ability: Enlightenment
-- Your next spell cast may be any from your list regardless of addenda.
-- Obtained: Scholar Level 75
-- Recast Time: 0:05:00
-- Duration: 0:01:00 or 1 Spell, whichever occurs first
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:hasStatusEffect(xi.effect.ENLIGHTENMENT) then
        return xi.msg.basic.EFFECT_ALREADY_ACTIVE, 0
    end

    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local merit = (player:getMerit(xi.merit.ENLIGHTENMENT) - 5)
    player:addStatusEffect(xi.effect.ENLIGHTENMENT, merit, 0, 60)

    return xi.effect.ENLIGHTENMENT
    -- Solo bonus
    local isSCH = player:getMainJob() == xi.job.SCH
    local lvl = player:getMainLvl()
    local intBonus = isSCH and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local mndBonus = isSCH and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Enlightenment', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
