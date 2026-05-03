-----------------------------------
-- Ability: Vallation
-- Reduces elemental damage. The types of elemental damage reduced depend on the runes you harbor.
-- Obtained: Rune Fencer Level 10
-- Recast Time: 3:00
-- Duration: 2:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.rune_fencer.checkHaveRunes(player)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local result = xi.job_utils.rune_fencer.useVallationValiance(player, target, ability, action)

    local isRUN   = player:getMainJob() == xi.job.RUN
    local lvl     = player:getMainLvl()
    local defBonus = isRUN and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regen    = isRUN and math.max(2, math.floor(lvl / 20)) or 1
    player:addMod(xi.mod.DEF, defBonus)
    player:timer(120000, function(p)
        p:delMod(xi.mod.DEF, defBonus)
    end)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 120)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Vallation', string.format('DEF +%d  Regen +%d', defBonus, regen))
    end

    return result
end

return abilityObject
