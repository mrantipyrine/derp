-----------------------------------
-- Ability: Tomahawk
-- Job: Warrior
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.warrior.checkTomahawk(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.warrior.useTomahawk(player, target, ability)
    -- Solo bonus
    local isWAR = player:getMainJob() == xi.job.WAR
    local lvl = player:getMainLvl()
    local strBonus = isWAR and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local attBonus = isWAR and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.ATT, attBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.ATT, attBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Tomahawk', string.format('STR +%d  ATT +%d', strBonus, attBonus))
    end
end

return abilityObject
