-----------------------------------
-- Ability: Rayke
-- Expends runes to reduce elemental resistance of the target.
-- Obtained: Rune Fencer level 75 (merit ability)
-- Recast Time: 5:00
-- Duration: 0:30 + an additional 3 for every merit after the first
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.rune_fencer.checkHaveRunes(player)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local result = xi.job_utils.rune_fencer.useRayke(player, target, ability, action)

    -- Solo bonus: STR+ATT to capitalise on the debuffed target
    local isRUN   = player:getMainJob() == xi.job.RUN
    local lvl     = player:getMainLvl()
    local strBonus = isRUN and math.floor(lvl * 0.24) or math.floor(lvl * 0.12)
    local attBonus = isRUN and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.ATT, attBonus)
    player:timer(45000, function(p)
        p:delMod(xi.mod.STR, strBonus)
        p:delMod(xi.mod.ATT, attBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Rayke', string.format('STR +%d  ATT +%d', strBonus, attBonus))
    end

    return result
end

return abilityObject
