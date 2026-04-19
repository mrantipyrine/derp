-----------------------------------
-- Ability: Super Jump
-- Job: Dragoon
-- Extreme enmity reduction — the DRG literally leaps out of danger.
-- Solo bonus: EVA + Haste on landing for quick repositioning.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dragoon.useSuperJump(player, target, ability)

    local lvl   = player:getMainLvl()
    local isDRG = player:getMainJob() == xi.job.DRG

    local evaBonus = isDRG and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local hasteAmt = isDRG and 10 or 5

    player:addMod(xi.mod.EVA, evaBonus)
    player:addStatusEffect(xi.effect.HASTE, hasteAmt, 0, 20)
    player:timer(20000, function(p)
        p:delMod(xi.mod.EVA, evaBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Super Jump', string.format('EVA +%d  Haste +%d%% (20s)', evaBonus, hasteAmt))
    end
end

return abilityObject
