-----------------------------------
-- Ability: Hide
-- User becomes invisible.
-- Obtained: Thief Level 45
-- Recast Time: 5:00
-- Hide sets up Sneak Attack. Reward precision, not raw power.
-- Removed: level*5 DA/ATT (375% at 75) — that was more than all of WAR stacked.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isTHF  = player:getMainJob() == xi.job.THF
    local lvl    = player:getMainLvl()
    local duration = 120

    -- EVA boost: you're hiding, not charging in blind
    local evaBonus = isTHF and 80 or 20
    player:addStatusEffect(xi.effect.EVASION_BOOST, evaBonus, 3, duration, 0, 10, 1)

    -- THF main: ACC bonus to set up a clean SA/TA combo
    if isTHF then
        local accBonus = math.floor(lvl * 0.25)
        player:addMod(xi.mod.ACC, accBonus, 3, duration, 0, 10, 1)
    end

    xi.job_utils.thief.useHide(player, target, ability)
end

return abilityObject
