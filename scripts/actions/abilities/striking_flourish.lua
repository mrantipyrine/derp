-----------------------------------
-- Ability: Striking Flourish
-- Description: Allows you to deliver a twofold attack. Requires at least two finishing moves.
-- Obtained: DNC Level 89
-- Recast Time: 00:00:30 (Flourishes III)
-- Duration: 00:01:00
-- Cost: 2 Finishing Move charges
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if
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
    if player:hasStatusEffect(xi.effect.FINISHING_MOVE_2) then
        player:delStatusEffect(xi.effect.FINISHING_MOVE_2)
        player:addStatusEffect(xi.effect.STRIKING_FLOURISH, 2, 0, 60, 0, player:getMerit(xi.merit.STRIKING_FLOURISH_EFFECT))
    elseif player:hasStatusEffect(xi.effect.FINISHING_MOVE_3) then
        player:delStatusEffect(xi.effect.FINISHING_MOVE_3)
        player:addStatusEffect(xi.effect.FINISHING_MOVE_1, 1, 0, 7200)
        player:addStatusEffect(xi.effect.STRIKING_FLOURISH, 3, 0, 60, 0, player:getMerit(xi.merit.STRIKING_FLOURISH_EFFECT))
    elseif player:hasStatusEffect(xi.effect.FINISHING_MOVE_4) then
        player:delStatusEffect(xi.effect.FINISHING_MOVE_4)
        player:addStatusEffect(xi.effect.FINISHING_MOVE_2, 1, 0, 7200)
        player:addStatusEffect(xi.effect.STRIKING_FLOURISH, 3, 0, 60, 0, player:getMerit(xi.merit.STRIKING_FLOURISH_EFFECT))
    elseif player:hasStatusEffect(xi.effect.FINISHING_MOVE_5) then
        player:delStatusEffect(xi.effect.FINISHING_MOVE_5)
        player:addStatusEffect(xi.effect.FINISHING_MOVE_3, 1, 0, 7200)
        player:addStatusEffect(xi.effect.STRIKING_FLOURISH, 3, 0, 60, 0, player:getMerit(xi.merit.STRIKING_FLOURISH_EFFECT))
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
        xi.soloSynergy.flashBuff(player, 'Striking Flourish', string.format('AGI +%d  TP +%d', agiBonus, tpGain))
    end
end

return abilityObject
