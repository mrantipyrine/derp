-----------------------------------
-- Ability: Tabula Rasa
-- Optimizes both white and black magic capabilities while allowing charge-free stratagem use.
-- Obtained: Scholar Level 1
-- Recast Time: 1:00:00
-- Duration: 0:03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))

    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isSCH = player:getMainJob() == xi.job.SCH
    local lvl   = player:getMainLvl()

    local regenbonus = 0

    if isSCH and lvl >= 20 then
        regenbonus = 3 * math.floor((lvl - 10) / 10)
    end

    local helixbonus = 0

    if isSCH and lvl >= 20 then
        helixbonus = math.floor(lvl / 4)
    end

    local jpValue = player:getJobPointLevel(xi.jp.TABULA_RASA_EFFECT)

    if jpValue > 0 then
        player:addMP(player:getMaxMP() * 0.02 * jpValue)
    end

    player:resetRecast(xi.recast.ABILITY, 228)
    player:resetRecast(xi.recast.ABILITY, 231)
    player:resetRecast(xi.recast.ABILITY, 232)
    player:addStatusEffect(xi.effect.TABULA_RASA, math.floor(helixbonus * 1.5), 0, 180, 0, math.floor(regenbonus * 1.5))

    -- Solo bonus: big INT+MND spike for the 3-minute window
    local intBonus = isSCH and math.floor(lvl * 0.35) or math.floor(lvl * 0.18)
    local mndBonus = isSCH and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(180000, function(p)
        p:delMod(xi.mod.INT, intBonus)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Tabula Rasa', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end

    return xi.effect.TABULA_RASA
end

return abilityObject
