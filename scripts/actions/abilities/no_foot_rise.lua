-----------------------------------
-- Ability: No Foot Rise
-- Job: Dancer
-- Instantly grants Finishing Moves.
-- Solo bonus: AGI + brief Haste — perfect footing, perfect speed.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dancer.checkNoFootRiseAbility(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    local result = xi.job_utils.dancer.useNoFootRiseAbility(player, target, ability)

    local lvl   = player:getMainLvl()
    local isDNC = player:getMainJob() == xi.job.DNC
    local agiBonus = isDNC and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local hasteAmt = isDNC and 10 or 5

    player:addMod(xi.mod.AGI, agiBonus)
    player:addStatusEffect(xi.effect.HASTE, hasteAmt, 0, 30)
    player:timer(30000, function(p) p:delMod(xi.mod.AGI, agiBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'No Foot Rise', string.format('AGI +%d  Haste +%d%% (30s)', agiBonus, hasteAmt))
    end

    return result
end

return abilityObject
