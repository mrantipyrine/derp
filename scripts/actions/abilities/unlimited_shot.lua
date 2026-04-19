-----------------------------------
-- Ability: Unlimited Shot
-- Job: Ranger
-- Next ranged attack uses no ammo.
-- Solo bonus: Racc + TP — every shot counts when you're solo.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.UNLIMITED_SHOT, 1, 0, 60)

    local lvl   = player:getMainLvl()
    local isRNG = player:getMainJob() == xi.job.RNG

    local raccBonus = isRNG and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local tpGain    = isRNG and math.random(150, 280) or math.random(60, 120)

    player:addMod(xi.mod.RACC, raccBonus)
    player:addTP(tpGain)
    player:timer(60000, function(p)
        p:delMod(xi.mod.RACC, raccBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Unlimited Shot', string.format('Racc +%d  TP +%d', raccBonus, tpGain))
    end
end

return abilityObject
