-----------------------------------
-- Ability: Stymie
-- Greatly increases the accuracy of the next enfeebling magic spell.
-- Obtained: Red Mage Level 96
-- Recast Time: 1:00:00
-- Duration: Stymie fades after either sixty seconds passes or a spell lands, but it does not fade if the spell is resisted.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.red_mage.checkStymie(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.red_mage.useStymie(player, target, ability)
    -- Solo bonus
    local isBLM = player:getMainJob() == xi.job.BLM
    local lvl = player:getMainLvl()
    local intBonus = isBLM and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Stymie', string.format('INT +%d', intBonus))
    end
end

return abilityObject
