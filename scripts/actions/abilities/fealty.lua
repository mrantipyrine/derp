-----------------------------------
-- Ability: Fealty
-- Job: Paladin
-- Strong resistance to enfeebling magic for 60s.
-- Solo bonus: MND boost to amplify cures + Regen for the patient knight.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.paladin.useFealty(player, target, ability)

    local lvl   = player:getMainLvl()
    local isPLD = player:getMainJob() == xi.job.PLD

    local mndBonus = isPLD and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local regen    = isPLD and math.max(3, math.floor(lvl / 12)) or 1

    player:addMod(xi.mod.MND, mndBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 60)
    player:timer(60000, function(p)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Fealty', string.format('MND +%d  Regen +%d', mndBonus, regen))
    end
end

return abilityObject
