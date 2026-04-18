-----------------------------------
-- Ability: Steal
-- Steal items from enemy.
-- Obtained: Thief Level 5
-- Recast Time: 5:00
-- Fixed: statMultiplier * level was giving 6000+ ACC at level 75.
-- Now gives flat evasion + regain — rewards using Steal as an opener.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.thief.checkSteal(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local isTHF    = player:getMainJob() == xi.job.THF
    local lvl      = player:getMainLvl()
    local duration = 60

    if isTHF then
        -- Evasion: you're in close, stay slippery
        local evaBonus = math.floor(lvl * 0.30)
        player:addStatusEffect(xi.effect.EVASION_BOOST, evaBonus, 3, duration, 0, 10, 1)

        -- Regain: successful steal builds TP
        local regain = math.random(8, 20)
        player:addStatusEffect(xi.effect.REGAIN, regain, 0, duration)
    end

    -- Ninja Chainmail / gear bonuses still apply via job_utils
    local equippedNECK = player:getEquipID(xi.slot.NECK)
    if equippedNECK == 13112 then
        local bonus = math.floor(target:getMainLvl() * 0.5)
        player:addStatusEffect(xi.effect.DEX_BOOST, bonus, 0, 180, 0, 0, 0)
        player:addStatusEffect(xi.effect.AGI_BOOST, bonus, 0, 180, 0, 0, 0)
    end

    return xi.job_utils.thief.useSteal(player, target, ability, action)
end

return abilityObject
