-----------------------------------
-- Ability: Overkill
-- Description: Increases ranged attack speed and the chance of activating Double/Triple Shot.
-- Obtained: RNG Level 96
-- Recast Time: 01:00:00
-- Duration: 00:01:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))

    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.OVERKILL, 11, 1, 60)
    -- Solo bonus
    local isWAR = player:getMainJob() == xi.job.WAR
    local lvl = player:getMainLvl()
    local strBonus = isWAR and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local attBonus = isWAR and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.ATT, attBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.ATT, attBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Overkill', string.format('STR +%d  ATT +%d', strBonus, attBonus))
    end
end

return abilityObject
