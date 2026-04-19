-----------------------------------
-- Ability: Reverse Flourish
-- Converts remaining finishing moves into TP. Requires at least one Finishing Move.
-- Obtained: Dancer Level 40
-- Finishing Moves Used: 1-5
-- Recast Time: 00:30
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dancer.checkFlourishAbility(player, target, ability, false, 1)
end

abilityObject.onUseAbility = function(player, target, ability)
    return xi.job_utils.dancer.useReverseFlourishAbility(player, target, ability)
    -- Solo bonus
    local isDNC = player:getMainJob() == xi.job.DNC
    local lvl = player:getMainLvl()
    local agiBonus = isDNC and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local tpGain  = isDNC and math.random(200, 400) or math.random(80, 160)
    player:addMod(xi.mod.AGI, agiBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p) p:delMod(xi.mod.AGI, agiBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Reverse Flourish', string.format('AGI +%d  TP +%d', agiBonus, tpGain))
    end
end

return abilityObject
