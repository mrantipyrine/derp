-----------------------------------
-- Ability: Divine Waltz
-- Heals party members within area of effect.
-- Obtained: Dancer Level 25
-- TP Required: 40%
-- Recast Time: 00:13
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.dancer.checkWaltzAbility(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    -- Solo bonus
    local isDNC = player:getMainJob() == xi.job.DNC
    local lvl = player:getMainLvl()
    local mndBonus = isDNC and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Divine Waltz', string.format('MND +%d', mndBonus))
    end

    return xi.job_utils.dancer.useWaltzAbility(player, target, ability, action)
end

return abilityObject
