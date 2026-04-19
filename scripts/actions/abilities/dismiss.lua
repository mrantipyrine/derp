-----------------------------------
-- Ability: Dismiss
-- Sends the Wyvern away.
-- Obtained: Dragoon Level 1
-- Recast Time: 5.00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    -- You can't actually use dismiss on retail unless your wyvern is up
    -- This is on the pet menu, but just in case...
    return xi.job_utils.dragoon.abilityCheckRequiresPet(player, target, ability, false)
end

abilityObject.onUseAbility = function(player, target, ability)
    -- Reset the Call Wyvern Ability.
    local pet = player:getPet()

    if pet:getHP() == pet:getMaxHP() then
        player:resetRecast(xi.recast.ABILITY, 163) -- call_wyvern
    end

    target:despawnPet()
    -- Solo bonus
    local isSMN = player:getMainJob() == xi.job.SMN
    local lvl = player:getMainLvl()
    local intBonus = isSMN and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local mndBonus = isSMN and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Dismiss', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
