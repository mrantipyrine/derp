-----------------------------------
-- Ability: Deus Ex Automata
-- Calls forth your automaton in an unsound state.
-- Obtained: Puppetmaster Level 5
-- Recast Time: 1:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:getPet() ~= nil then
        return xi.msg.basic.ALREADY_HAS_A_PET, 0
    elseif not player:canUseMisc(xi.zoneMisc.PET) then
        return xi.msg.basic.CANT_BE_USED_IN_AREA, 0
    else
        local jpValue = player:getJobPointLevel(xi.jp.DEUS_EX_AUTOMATA_RECAST)

        ability:setRecast(ability:getRecast() - jpValue)

        return 0, 0
    end
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.pet.spawnPet(player, xi.petId.AUTOMATON)
    local pet = player:getPet()

    if pet then
        local percent = math.floor((player:getMainLvl() / 3)) / 100
        pet:setHP(math.max(pet:getHP() * percent, 1))
        pet:setMP(pet:getMP() * percent)
    end
    -- Solo bonus
    local isPUP = player:getMainJob() == xi.job.PUP
    local lvl = player:getMainLvl()
    local strBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local intBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.INT, intBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Deus Ex Automata', string.format('STR +%d  INT +%d', strBonus, intBonus))
    end
end

return abilityObject
