-----------------------------------
-- Ability: Mana Wall
-- Description: Allows you to take damage with MP.
-- Obtained: BLM Level 76
-- Recast Time: 00:10:00
-- Duration: 00:05:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.black_mage.useManaWall(player, target, ability)
    -- Solo bonus
    local isSMN = player:getMainJob() == xi.job.SMN
    local lvl = player:getMainLvl()
    local intBonus = isSMN and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local mndBonus = isSMN and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Mana Wall', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
