-----------------------------------
-- Ability: Embolden
-- Enhances the effects of the next enhancing magic spell you cast, but reduces effect duration.
-- Obtained: Rune Fencer Level 60
-- Recast Time: 10:00
-- Duration: 1:00 or first absorb
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability, action)
    target:addStatusEffect(xi.effect.EMBOLDEN, 0, 0, 60) -- effects handled in scripts/globals/spells/spell_enhancing.lua

    -- Solo bonus: MND to boost the enhancing spell potency
    local isRUN   = player:getMainJob() == xi.job.RUN
    local lvl     = player:getMainLvl()
    local mndBonus = isRUN and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Embolden', string.format('MND +%d', mndBonus))
    end
end

return abilityObject
