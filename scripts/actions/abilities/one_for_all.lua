-----------------------------------
-- Ability: One for All
-- Grants a Magic Shield effect for party members within area of effect.
-- Obtained: Rune Fencer Level 95
-- Recast Time: 0:30
-- Duration: 5:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local result = xi.job_utils.rune_fencer.useOneForAll(player, target, ability, action)

    local isRUN   = player:getMainJob() == xi.job.RUN
    local lvl     = player:getMainLvl()
    local defBonus = isRUN and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regen    = isRUN and math.max(2, math.floor(lvl / 18)) or 1
    player:addMod(xi.mod.DEF, defBonus)
    player:timer(300000, function(p)
        p:delMod(xi.mod.DEF, defBonus)
    end)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 300)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'One for All', string.format('DEF +%d  Regen +%d', defBonus, regen))
    end

    return result
end

return abilityObject
