-----------------------------------
-- Ability: Double Shot
-- Occasionally uses two units of ammunition to deal double damage.
-- Obtained: Ranger Level 79
-- Recast Time: 3:00
-- Duration: 1:30
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.DOUBLE_SHOT, 40, 0, 90)
    -- Solo bonus
    local isRNG = player:getMainJob() == xi.job.RNG
    local lvl = player:getMainLvl()
    local raccBonus = isRNG and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    local tpGain   = isRNG and math.random(200, 400) or math.random(80, 160)
    player:addMod(xi.mod.RACC, raccBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p) p:delMod(xi.mod.RACC, raccBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Double Shot', string.format('RACC +%d  TP +%d', raccBonus, tpGain))
    end
end

return abilityObject
