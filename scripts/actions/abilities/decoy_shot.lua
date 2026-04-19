-----------------------------------
-- Ability: Decoy Shot
-- Description: Diverts enmity when launching a ranged attack from behind a party member.
-- Obtained: RNG Level 95
-- Recast Time: 00:05:00
-- Duration: 00:03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:addStatusEffect(xi.effect.DECOY_SHOT, 11, 1, 30)
    -- Solo bonus
    local isRNG = player:getMainJob() == xi.job.RNG
    local lvl = player:getMainLvl()
    local raccBonus = isRNG and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    local tpGain   = isRNG and math.random(200, 400) or math.random(80, 160)
    player:addMod(xi.mod.RACC, raccBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p) p:delMod(xi.mod.RACC, raccBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Decoy Shot', string.format('RACC +%d  TP +%d', raccBonus, tpGain))
    end
end

return abilityObject
