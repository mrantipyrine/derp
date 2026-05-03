-----------------------------------
-- Ability: Futae
-- Job: Ninja
-- Next elemental ninjutsu uses two tools for bonus effect.
-- Solo bonus: INT boost to ride on the amplified spell.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:addStatusEffect(xi.effect.FUTAE, 0, 0, 60)

    local lvl   = player:getMainLvl()
    local isNIN = player:getMainJob() == xi.job.NIN

    local intBonus = isNIN and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)

    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p)
        p:delMod(xi.mod.INT, intBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Futae', string.format('INT +%d (spell window)', intBonus))
    end
end

return abilityObject
