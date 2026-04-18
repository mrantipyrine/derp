-----------------------------------
-- Ability: Avatar's Favor
-- Job: Summoner
-- Gradually heals avatar's HP as the SMN spends their own.
-- Solo bonus: MND + Regen — the bond between summoner and avatar sustains both.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.AVATARS_FAVOR, 1, 10, 7200)

    local lvl   = player:getMainLvl()
    local isSMN = player:getMainJob() == xi.job.SMN
    local mndBonus = isSMN and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    local regen    = isSMN and math.max(2, math.floor(lvl / 14)) or 1

    player:addMod(xi.mod.MND, mndBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 7200)
    player:timer(7200000, function(p) p:delMod(xi.mod.MND, mndBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, "Avatar's Favor", string.format('MND +%d  Regen +%d', mndBonus, regen))
    end
end

return abilityObject
