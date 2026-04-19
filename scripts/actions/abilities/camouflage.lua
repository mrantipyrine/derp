-----------------------------------
-- Ability: Camouflage
-- Job: Ranger
-- Hides from enemies for a random duration.
-- Solo bonus: ACC burst when activated — the hunter lines up the perfect shot.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local duration = math.random(30, 300) * (1 + 0.01 * player:getMod(xi.mod.CAMOUFLAGE_DURATION))
    local finalDur = math.floor(duration * xi.settings.main.SNEAK_INVIS_DURATION_MULTIPLIER)
    player:addStatusEffect(xi.effect.CAMOUFLAGE, 1, 0, finalDur)

    local lvl   = player:getMainLvl()
    local isRNG = player:getMainJob() == xi.job.RNG

    local accBonus  = isRNG and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local raccBonus = isRNG and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)

    player:addMod(xi.mod.ACC,  accBonus)
    player:addMod(xi.mod.RACC, raccBonus)
    player:timer(finalDur * 1000, function(p)
        p:delMod(xi.mod.ACC,  accBonus)
        p:delMod(xi.mod.RACC, raccBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Camouflage', string.format('ACC +%d  Racc +%d', accBonus, raccBonus))
    end
end

return abilityObject
