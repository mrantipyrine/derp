-----------------------------------
-- Ability: Flee
-- Increases movement speed.
-- Obtained: Thief Level 25
-- Recast Time: 5:00 / Duration: 0:30
-- THF identity: speed = offensive burst. DA bonus during Flee window.
-- Fixed: player.delMod -> player:delMod (dot crash), scaled DA down from lvl*1.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isTHF    = player:getMainJob() == xi.job.THF
    local duration = 30   -- matches Flee's actual duration

    -- DA during sprint: moving fast = attacking fast. Fun, not broken.
    local daRate = isTHF and 15 or 8
    player:addMod(xi.mod.DOUBLE_ATTACK, daRate, 3, duration, 0, 10, 1)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Flee', 'DA +' .. daRate .. '% during sprint')
    end
    xi.job_utils.thief.useFlee(player, target, ability)
end

return abilityObject
