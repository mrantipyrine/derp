-----------------------------------
-- Ability: Retreat
-- Orders the avatar to hold back.
-- Obtained: Summoner Level 1
-- Recast Time: 10 sec
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:petRetreat()
    -- Solo bonus
    local isSMN = player:getMainJob() == xi.job.SMN
    local lvl = player:getMainLvl()
    local intBonus = isSMN and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local mndBonus = isSMN and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Retreat', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
