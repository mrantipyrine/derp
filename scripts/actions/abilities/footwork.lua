-----------------------------------
-- Ability: Footwork
-- Enhances kick attacks and combat capability.
-- Obtained: Monk Level 25
-- Recast Time: 5:00 / Duration: 2:00
-- Values are fine. Fixed: wrong header said "Focus".
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMNK  = player:getMainJob() == xi.job.MNK
    local lvl    = player:getMainLvl()
    local duration = 120

    local accBonus = isMNK and math.floor(lvl / 6) or math.floor(lvl / 8)
    accBonus = math.max(1, accBonus)

    -- ATT/DMG/KICK scale 5-10 for MNK (65-75), 3-6 for sub
    local offBonus
    if isMNK then
        offBonus = math.floor(math.max(1, math.min(10, 5 + (lvl - 65) * 0.5)))
    else
        offBonus = math.floor(math.max(1, math.min(7,  3 + (lvl - 65) * 0.3)))
    end

    player:addMod(xi.mod.ACC,      accBonus,  3, duration, 0, 10, 1)
    player:addMod(xi.mod.ATT,      offBonus,  3, duration, 0, 10, 1)
    player:addMod(xi.mod.DMG,      offBonus,  3, duration, 0, 10, 1)
    player:addMod(xi.mod.KICK_DMG, offBonus,  3, duration, 0, 10, 1)

    xi.job_utils.monk.useFocus(player, target, ability)
end

return abilityObject
