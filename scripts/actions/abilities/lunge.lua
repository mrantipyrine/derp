-----------------------------------
-- Ability: Lunge
-- Expends all runes to deal damage to a target.
-- Obtained: Rune Fencer Level 25
-- Recast Time: 3:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:getAnimation() ~= 1 then
        return xi.msg.basic.REQUIRES_COMBAT, 0
    end

    return xi.job_utils.rune_fencer.checkHaveRunes(player)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local result = xi.job_utils.rune_fencer.useSwipeLunge(player, target, ability, action)

    -- Solo bonus: STR spike + TP boost to capitalise on the damage window
    local isRUN   = player:getMainJob() == xi.job.RUN
    local lvl     = player:getMainLvl()
    local strBonus = isRUN and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    local tpGain   = isRUN and math.random(400, 700) or math.random(150, 300)
    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Lunge', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end

    return result
end

return abilityObject
