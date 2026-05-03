-----------------------------------
-- Ability: Accomplice
-- Steals half of the target party member's enmity and redirects it to the thief.
-- Obtained: Thief Level 65
-- Recast Time: 5:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.thief.checkAccomplice(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.thief.useAccomplice(player, target, ability)
    -- Solo bonus
    local isTHF = player:getMainJob() == xi.job.THF
    local lvl = player:getMainLvl()
    local agiBonus = isTHF and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local evaBonus = isTHF and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.AGI, agiBonus)
    player:addMod(xi.mod.EVA, evaBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.AGI, agiBonus) p:delMod(xi.mod.EVA, evaBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Accomplice', string.format('AGI +%d  EVA +%d', agiBonus, evaBonus))
    end
end

return abilityObject
