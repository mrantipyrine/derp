-----------------------------------
-- Ability: Feather Step
-- Description Lowers a target's critical hit evasion. If successful, will earn you a finishing move.
-- Obtained: DNC Level 83
-- Recast Time: 00:00:05 (Step)
-- Duration: 00:01:00
-- Cost: 100TP
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dancer.checkStepAbility(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    -- Solo bonus
    local isDNC = player:getMainJob() == xi.job.DNC
    local lvl = player:getMainLvl()
    local agiBonus = isDNC and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.AGI, agiBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.AGI, agiBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Feather Step', string.format('AGI +%d', agiBonus))
    end

    return xi.job_utils.dancer.useStepAbility(player, target, ability, action, xi.effect.BEWILDERED_DAZE_1, 2, 6)
end

return abilityObject
