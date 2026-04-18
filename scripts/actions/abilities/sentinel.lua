-----------------------------------
-- Ability: Sentinel
-- Job: Paladin
-- Reduces physical damage taken, boosts enmity.
-- Solo bonus: Regen + DEF boost — the lone guardian endures.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.paladin.useSentinel(player, target, ability)

    local lvl   = player:getMainLvl()
    local isPLD = player:getMainJob() == xi.job.PLD

    local defBonus = isPLD and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local regen    = isPLD and math.max(3, math.floor(lvl / 12)) or 1

    player:addMod(xi.mod.DEF, defBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 30)
    player:timer(30000, function(p)
        p:delMod(xi.mod.DEF, defBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Sentinel', string.format('DEF +%d  Regen +%d', defBonus, regen))
    end
end

return abilityObject
