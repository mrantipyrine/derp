-----------------------------------
-- Ability: Climactic Flourish
-- Description: Allows you to deal critical hits. Requires at least one finishing move.
-- Obtained: DNC Level 80
-- Recast Time: 00:01:30 (Flourishes III)
-- Duration: 00:01:00
-- Cost: 1-5 Finishing Move charges
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if
        player:hasStatusEffect(xi.effect.FINISHING_MOVE_1) or
        player:hasStatusEffect(xi.effect.FINISHING_MOVE_2) or
        player:hasStatusEffect(xi.effect.FINISHING_MOVE_3) or
        player:hasStatusEffect(xi.effect.FINISHING_MOVE_4) or
        player:hasStatusEffect(xi.effect.FINISHING_MOVE_5)
    then
        return 0, 0
    end

    return xi.msg.basic.NO_FINISHINGMOVES, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    for move = xi.effect.FINISHING_MOVE_1, xi.effect.FINISHING_MOVE_5 do
        player:delStatusEffect(move)
        player:addStatusEffect(xi.effect.CLIMACTIC_FLOURISH, 3, 0, 60, 0, player:getMerit(xi.merit.CLIMACTIC_FLOURISH_EFFECT))
    end
    -- Solo bonus
    local isDNC = player:getMainJob() == xi.job.DNC
    local lvl = player:getMainLvl()
    local agiBonus = isDNC and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local tpGain  = isDNC and math.random(200, 400) or math.random(80, 160)
    player:addMod(xi.mod.AGI, agiBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p) p:delMod(xi.mod.AGI, agiBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Climactic Flourish', string.format('AGI +%d  TP +%d', agiBonus, tpGain))
    end
end

return abilityObject
