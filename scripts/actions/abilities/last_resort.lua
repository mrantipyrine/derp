-----------------------------------
-- Ability: Last Resort
-- Job: Dark Knight
-- ATT up, DEF down — the desperate gamble.
-- Solo bonus: DA to make the attack window count, Regain to keep pressure up.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.dark_knight.useLastResort(player, target, ability)

    local lvl   = player:getMainLvl()
    local isDRK = player:getMainJob() == xi.job.DRK

    local daRate = isDRK and 12 or 6
    local regain = isDRK and math.max(2, math.floor(lvl / 14)) or 1

    player:addMod(xi.mod.DOUBLE_ATTACK, daRate)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 180)
    player:timer(180000, function(p)
        p:delMod(xi.mod.DOUBLE_ATTACK, daRate)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Last Resort', string.format('DA +%d%%  Regain +%d', daRate, regain))
    end
end

return abilityObject
