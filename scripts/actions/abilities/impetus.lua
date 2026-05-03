-----------------------------------
-- Ability: Impetus
-- Description: Enhances attack and critical hit rate with each successive melee attack you land.
-- Obtained: MNK Level 88
-- Recast Time: 00:05:00
-- Duration: 0:03:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.monk.useImpetus(player, target, ability)

    local isMNK   = player:getMainJob() == xi.job.MNK
    local lvl     = player:getMainLvl()

    -- ACC seeding so early hits connect and start stacking the effect
    local accBonus = isMNK and math.floor(lvl * 0.30) or math.floor(lvl * 0.15)
    player:addMod(xi.mod.ACC, accBonus)
    player:timer(180000, function(p)
        p:delMod(xi.mod.ACC, accBonus)
    end)

    -- Regain so you can WS more frequently as stacks build
    local regain = isMNK and 3 or 1
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 180)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Impetus', string.format('ACC +%d  Regain +%d', accBonus, regain))
    end
end

return abilityObject
