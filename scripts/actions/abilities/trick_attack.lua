-----------------------------------
-- Ability: Trick Attack
-- Deals extra damage when striking from behind a party or alliance member.
-- Obtained: Thief Level 30
-----------------------------------
-- Ability: Trick Attack
-- Deals extra damage when striking from behind a party or alliance member.
-- Obtained: Thief Level 30
-- Recast Time: 1:00
-- Duration: 1:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

-- Lets make TA useful in solo situations 
abilityObject.onUseAbility = function(player, target, ability)
    if player:getMainJob() == xi.job.THF then
        xi.job_utils.thief.useHide(player, target, ability)
    end 
    
    xi.job_utils.thief.useTrickAttack(player, target, ability)
    -- Solo bonus
    local isTHF = player:getMainJob() == xi.job.THF
    local lvl = player:getMainLvl()
    local agiBonus = isTHF and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local evaBonus = isTHF and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.AGI, agiBonus)
    player:addMod(xi.mod.EVA, evaBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.AGI, agiBonus) p:delMod(xi.mod.EVA, evaBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Trick Attack', string.format('AGI +%d  EVA +%d', agiBonus, evaBonus))
    end
end

return abilityObject

