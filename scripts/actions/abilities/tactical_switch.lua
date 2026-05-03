-----------------------------------
-- Ability: Tactical Switch
-- Description: Swaps TP of master and automaton.
-- Obtained: PUP Level 79
-- Recast Time: 00:03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    -- target:addStatusEffect(xi.effect.TACTICAL_SWITCH, 18, 1, 1) -- TODO: implement xi.effect.TACTICAL_SWITCH
    -- Solo bonus
    local isSMN = player:getMainJob() == xi.job.SMN
    local lvl = player:getMainLvl()
    local intBonus = isSMN and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local mndBonus = isSMN and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Tactical Switch', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
