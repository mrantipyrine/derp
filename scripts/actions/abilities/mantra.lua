-----------------------------------
-- Ability: Mantra
-- Boosts party stats and grants an elemental Enspell based on the current day.
-- Obtained: Monk Level 75
-- Recast Time: 10:00 / Duration: 3:00
-- Fixed: using getParty() + zone check (matching the pattern used in synergies.lua).
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMNK  = player:getMainJob() == xi.job.MNK
    local lvl    = player:getMainLvl()
    local duration = 180

    local boost = isMNK and math.floor(lvl / 6) or math.floor(lvl / 9)
    boost = math.max(1, boost)

    -- Enspell: changes with the day, gives MNK a magic flavour
    local enspellEffects = {
        [0] = xi.effect.ENFIRE,
        [1] = xi.effect.ENBLIZZARD,
        [2] = xi.effect.ENAERO,
        [3] = xi.effect.ENSTONE,
        [4] = xi.effect.ENTHUNDER,
        [5] = xi.effect.ENWATER,
    }
    local dayElement = VanadielDayElement()
    if dayElement >= 6 then dayElement = math.random(0, 5) end
    local enspellPow = math.floor(lvl / 10)

    -- Apply to all party members in same zone
    local party = player:getParty()
    for _, member in ipairs(party) do
        if member and member:isAlive() and member:getZoneID() == player:getZoneID() then
            member:addStatusEffect(xi.effect.VIT_BOOST,     boost, 3, duration, 0, 10, 1)
            member:addStatusEffect(xi.effect.STR_BOOST,     boost, 0, duration, 0, 0,  0)
            member:addStatusEffect(xi.effect.EVASION_BOOST, boost, 3, duration, 0, 10, 1)
            member:addStatusEffect(xi.effect.COUNTER_BOOST, boost, 3, duration, 0, 10, 1)
            member:addStatusEffect(xi.effect.MAX_HP_BOOST,  boost, 3, duration, 0, 10, 1)
            if enspellEffects[dayElement] then
                member:addStatusEffect(enspellEffects[dayElement], enspellPow, 3, duration, 0, 10, 1)
            end
        end
    end

    return xi.job_utils.monk.useMantra(player, target, ability)
end

return abilityObject
