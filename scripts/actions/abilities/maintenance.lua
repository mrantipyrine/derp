-----------------------------------
-- Ability: Maintenance
-- Cures your automaton of status ailments. Special items required
-- Obtained: Puppetmaster Level 30
-- Recast Time: 1:30
-- Duration: Instant
-----------------------------------
local abilityObject = {}

local idStrengths =
{
    [18731] = 1, -- Automaton Oil
    [18732] = 2, -- Automaton Oil + 1
    [18733] = 3, -- Automaton Oil + 2
    [19185] = 4  -- Automaton Oil + 3
}

local removableStatus =
{
    xi.effect.PETRIFICATION,
    xi.effect.SILENCE,
    xi.effect.BANE,
    xi.effect.CURSE_II,
    xi.effect.CURSE_I,
    xi.effect.PARALYSIS,
    xi.effect.PLAGUE,
    xi.effect.POISON,
    xi.effect.DISEASE,
    xi.effect.BLINDNESS,
}

local function removeStatus(target)
    for _, effectId in ipairs(removableStatus) do
        if target:delStatusEffect(effectId) then
            return true
        end
    end

    if target:eraseStatusEffect() ~= xi.effect.NONE then
        return true
    end

    return false
end

abilityObject.onAbilityCheck = function(player, target, ability)
    local pet = player:getPet()
    if not pet then
        return xi.msg.basic.REQUIRES_A_PET, 0
    elseif not pet:isAutomaton() then
        return xi.msg.basic.NO_EFFECT_ON_PET, 0
    else
        local id = player:getEquipID(xi.slot.AMMO)
        if idStrengths[id] then
            return 0, 0
        else
            return xi.msg.basic.UNABLE_TO_USE_JA, 0
        end
    end
end

abilityObject.onUseAbility = function(player, target, ability)
    local id         = player:getEquipID(xi.slot.AMMO)
    local pet        = player:getPet()
    local toRemove   = idStrengths[id] or 1
    local numRemoved = 0

    repeat
        if not removeStatus(pet) then
            break
        end

        toRemove   = toRemove - 1
        numRemoved = numRemoved + 1
    until toRemove <= 0

    player:removeAmmo()

    return numRemoved
    -- Solo bonus
    local isPUP = player:getMainJob() == xi.job.PUP
    local lvl = player:getMainLvl()
    local strBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local intBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.INT, intBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Maintenance', string.format('STR +%d  INT +%d', strBonus, intBonus))
    end
end

return abilityObject
