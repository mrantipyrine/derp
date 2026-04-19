-----------------------------------
-- Ability: Liement
-- Absorbs elemental damage. The types of elemental damage absorbed depend on the runes you harbor.
-- Obtained: Rune Fencer Level 85
-- Recast Time: 3:00
-- Duration: 10 seconds or first absorb
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.rune_fencer.checkHaveRunes(player)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local result = xi.job_utils.rune_fencer.useLiement(player, target, ability, action)

    -- Solo bonus: MND to improve magic absorb thresholds
    local isRUN   = player:getMainJob() == xi.job.RUN
    local lvl     = player:getMainLvl()
    local mndBonus = isRUN and math.floor(lvl * 0.26) or math.floor(lvl * 0.13)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(20000, function(p)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Liement', string.format('MND +%d', mndBonus))
    end

    return result
end

return abilityObject
