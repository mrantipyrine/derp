-----------------------------------
-- Ability: Deactivate
-- Deactivates your automaton.
-- Obtained: Puppetmaster Level 1
-- Recast Time: 1:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    -- Reset the Activate ability.
    local pet = player:getPet()

    if pet:getHP() == pet:getMaxHP() then
        player:resetRecast(xi.recast.ABILITY, 205) -- activate
    end

    target:despawnPet()
    -- Solo bonus
    local isPUP = player:getMainJob() == xi.job.PUP
    local lvl = player:getMainLvl()
    local strBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local intBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.INT, intBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Deactivate', string.format('STR +%d  INT +%d', strBonus, intBonus))
    end
end

return abilityObject
