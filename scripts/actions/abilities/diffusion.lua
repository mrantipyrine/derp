-----------------------------------
-- Ability: Diffusion
-- Grants the effect of your next support Blue Magic spell to party members within range.
-- Obtained: Blue Mage Level 75
-- Recast Time: 10:00
-- Duration: 1:00, or until the next blue magic spell is cast.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:hasStatusEffect(xi.effect.DIFFUSION) then
        return xi.msg.basic.EFFECT_ALREADY_ACTIVE, 0
    end

    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.DIFFUSION, 1, 0, 60)

    -- Solo bonus
    local isGEO = player:getMainJob() == xi.job.GEO
    local lvl = player:getMainLvl()
    local intBonus = isGEO and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local mndBonus = isGEO and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Diffusion', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end

    return xi.effect.DIFFUSION
end

return abilityObject
