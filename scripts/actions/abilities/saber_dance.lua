-----------------------------------
-- Ability: Saber Dance
-- Increases Double Attack rate but renders Waltz unusable. Double Attack rate gradually decreases.
-- Obtained: Dancer Level 75 Merit Group 2
-- Recast Time: 3 minutes
-- Duration: 5 minutes
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.SABER_DANCE, 50, 3, 300)
    -- Solo bonus
    local isDNC = player:getMainJob() == xi.job.DNC
    local lvl = player:getMainLvl()
    local agiBonus = isDNC and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local evaBonus = isDNC and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.AGI, agiBonus)
    player:addMod(xi.mod.EVA, evaBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.AGI, agiBonus) p:delMod(xi.mod.EVA, evaBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Saber Dance', string.format('AGI +%d  EVA +%d', agiBonus, evaBonus))
    end
end

return abilityObject
