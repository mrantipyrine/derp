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
    -- Solo bonus
    local isTHF = player:getMainJob() == xi.job.THF
    local lvl = player:getMainLvl()
    local agiBonus = isTHF and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local evaBonus = isTHF and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.AGI, agiBonus)
    player:addMod(xi.mod.EVA, evaBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.AGI, agiBonus) p:delMod(xi.mod.EVA, evaBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Hide', string.format('AGI +%d  EVA +%d', agiBonus, evaBonus))
    end
end

return abilityObject
