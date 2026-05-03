-----------------------------------
-- Ability: Valiance
-- Reduces elemental damage for party members within area of effect. The types of elemental damage reduced depend on the runes you harbor.
-- Obtained: Rune Fencer Level 10
-- Recast Time: 5:00
-- Duration: 3:00
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
    player:timer(180000, function(p)
        p:delMod(xi.mod.DEF, defBonus)
    end)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 180)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Valiance', string.format('DEF +%d  Regen +%d', defBonus, regen))
    end

    return result
end

return abilityObject
