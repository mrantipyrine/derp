-----------------------------------
-- Ability: Activate
-- Calls forth your automaton.
-- Obtained: Puppetmaster Level 1
-- Recast Time: 0:20:00 (0:16:40 with full merits)
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:getPet() ~= nil then
        return xi.msg.basic.ALREADY_HAS_A_PET, 0
    elseif not player:canUseMisc(xi.zoneMisc.PET) then
        return xi.msg.basic.CANT_BE_USED_IN_AREA, 0
    elseif player:isExceedingElementalCapacity() then
        return xi.msg.basic.AUTO_EXCEEDS_CAPACITY, 0
    end

    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.pet.spawnPet(player, xi.petId.AUTOMATON)

    local pet = player:getPet()

    if pet then
        local jpValue = player:getJobPointLevel(xi.jp.AUTOMATON_HP_MP_BONUS)
        pet:addMod(xi.mod.HP, jpValue * 10)
        pet:addMod(xi.mod.MP, jpValue * 5)
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
        xi.soloSynergy.flashBuff(player, 'Activate', string.format('STR +%d  INT +%d', strBonus, intBonus))
    end
end

return abilityObject
