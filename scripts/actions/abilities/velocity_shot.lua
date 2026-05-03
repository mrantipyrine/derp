-----------------------------------
-- Ability: Velocity Shot
-- Job: Ranger
-- Increases ranged damage/speed, reduces melee.
-- Solo bonus: extra Racc to ensure the ranged specialist lands every shot.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.VELOCITY_SHOT, 1, 0, 7200)

    local lvl   = player:getMainLvl()
    local isRNG = player:getMainJob() == xi.job.RNG

    local raccBonus = isRNG and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)

    player:addMod(xi.mod.RACC, raccBonus)
    player:timer(7200000, function(p)
        p:delMod(xi.mod.RACC, raccBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Velocity Shot', string.format('Racc +%d', raccBonus))
    end
end

return abilityObject
