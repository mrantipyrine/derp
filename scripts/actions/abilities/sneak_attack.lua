-----------------------------------
-- Ability: Sneak Attack
-- Deals critical damage when striking from behind.
-- Obtained: Thief Level 15
-- Recast Time: 1:00 / Duration: 1:00
-- Fixed: global variable leaks (power/duration), return typo (abilityObject4).
-- Scaled: 375 ACC+ATT was way too high. Now 25/12 — meaningful not insane.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isTHF   = player:getMainJob() == xi.job.THF
    local duration = 60

    -- ACC + ATT: sets up the SA crit cleanly. THF main gets more.
    local bonus = isTHF and 25 or 12
    player:addMod(xi.mod.ACC, bonus, 3, duration, 0, 10, 1)
    player:addMod(xi.mod.ATT, bonus, 3, duration, 0, 10, 1)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Sneak Attack', 'ACC +' .. bonus .. '  ATT +' .. bonus)
    end
    xi.job_utils.thief.useSneakAttack(player, target, ability)
end

return abilityObject
