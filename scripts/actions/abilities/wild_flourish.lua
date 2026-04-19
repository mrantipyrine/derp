-----------------------------------
-- Ability: Wild Flourish
-- Readies target for a skillchain. Requires at least two Finishing Moves.
-- Obtained: Dancer Level 60
-- Finishing Moves Used: 2
-- Recast Time: 0:30
-- Duration: 0:05
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dancer.checkFlourishAbility(player, target, ability, true, 2)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    return xi.job_utils.dancer.useWildFlourishAbility(player, target, ability, action)
    -- Solo bonus
    local isDNC = player:getMainJob() == xi.job.DNC
    local lvl = player:getMainLvl()
    local agiBonus = isDNC and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local tpGain  = isDNC and math.random(200, 400) or math.random(80, 160)
    player:addMod(xi.mod.AGI, agiBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p) p:delMod(xi.mod.AGI, agiBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Wild Flourish', string.format('AGI +%d  TP +%d', agiBonus, tpGain))
    end
end

return abilityObject
