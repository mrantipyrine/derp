-----------------------------------
-- Ability: Formless Strikes
-- While in effect, melee attacks will not be considered physical damage. No effect on weapon skills.
-- Obtainable: Monk Level 75
-- Recast Time: 0:10:00
-- Duration: 0:03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.monk.useFormlessStrikes(player, target, ability)

    local isMNK   = player:getMainJob() == xi.job.MNK
    local lvl     = player:getMainLvl()

    -- INT lets strikes hit harder vs. magic-resistant mobs
    local intBonus = isMNK and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    player:addMod(xi.mod.INT, intBonus)
    player:timer(180000, function(p)
        p:delMod(xi.mod.INT, intBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Formless Strikes', string.format('INT +%d', intBonus))
    end
end

return abilityObject
