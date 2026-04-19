-----------------------------------
-- Ability: Perfect Counter
-- Description: Allows you to counter the next attack directed at you.
-- Obtained: MNK Level 79
-- Recast Time: 00:01:00
-- Duration: 0:00:30
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.monk.usePerfectCounter(player, target, ability)

    local isMNK = player:getMainJob() == xi.job.MNK
    local lvl   = player:getMainLvl()

    -- DEF to survive getting hit; ATT so the counter hits hard
    local defBonus = isMNK and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    local attBonus = isMNK and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    player:addMod(xi.mod.DEF, defBonus)
    player:addMod(xi.mod.ATT, attBonus)
    player:timer(30000, function(p)
        p:delMod(xi.mod.DEF, defBonus)
        p:delMod(xi.mod.ATT, attBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Perfect Counter', string.format('DEF +%d  ATT +%d', defBonus, attBonus))
    end
end

return abilityObject
