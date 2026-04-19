-----------------------------------
-- Ability: Dark Arts
-- Optimizes black magic capability while lowering white magic proficiency. Grants a bonus to enfeebling, elemental, and dark magic. Also grants access to Stratagems.
-- Obtained: Scholar Level 10
-- Recast Time: 1:00
-- Duration: 2:00:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if
        player:hasStatusEffect(xi.effect.DARK_ARTS) or
        player:hasStatusEffect(xi.effect.ADDENDUM_BLACK)
    then
        return xi.msg.basic.EFFECT_ALREADY_ACTIVE, 0
    end

    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:delStatusEffectSilent(xi.effect.LIGHT_ARTS)
    player:delStatusEffect(xi.effect.ADDENDUM_WHITE)
    player:delStatusEffect(xi.effect.PENURY)
    player:delStatusEffect(xi.effect.CELERITY)
    player:delStatusEffect(xi.effect.ACCESSION)
    player:delStatusEffect(xi.effect.RAPTURE)
    player:delStatusEffect(xi.effect.ALTRUISM)
    player:delStatusEffect(xi.effect.TRANQUILITY)
    player:delStatusEffect(xi.effect.PERPETUANCE)

    local helixbonus = 0

    if player:getMainJob() == xi.job.SCH and player:getMainLvl() >= 20 then
        helixbonus = math.floor(player:getMainLvl() / 4)
    end

    player:addStatusEffect(xi.effect.DARK_ARTS, 1, 0, 7200, 0, helixbonus)

    -- Solo bonus
    local isSCH = player:getMainJob() == xi.job.SCH
    local lvl = player:getMainLvl()
    local intBonus = isSCH and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local mndBonus = isSCH and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Dark Arts', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end

    return xi.effect.DARK_ARTS
end

return abilityObject
