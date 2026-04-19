-----------------------------------
-- Ability: Contradance
-- Description: Increases the amount of HP restored by your next Waltz.
-- Obtained: DNC Level 50
-- Recast Time: 00:05:00
-- Duration: 00:01:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    return xi.job_utils.dancer.useContradanceAbility(player, target, ability)
    -- Solo bonus
    local isDNC = player:getMainJob() == xi.job.DNC
    local lvl = player:getMainLvl()
    local agiBonus = isDNC and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local evaBonus = isDNC and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.AGI, agiBonus)
    player:addMod(xi.mod.EVA, evaBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.AGI, agiBonus) p:delMod(xi.mod.EVA, evaBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Contradance', string.format('AGI +%d  EVA +%d', agiBonus, evaBonus))
    end
end

return abilityObject
