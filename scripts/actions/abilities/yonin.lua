-----------------------------------
-- Ability: Yonin
-- Job: Ninja
-- Front-face defensive stance: EVA up, enemy crit down, enmity up.
-- Solo bonus: DEF + Regen — the patient guardian stance.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:delStatusEffect(xi.effect.INNIN)
    target:delStatusEffect(xi.effect.YONIN)
    target:addStatusEffect(xi.effect.YONIN, 30, 15, 300, 0, 20)

    local lvl   = player:getMainLvl()
    local isNIN = player:getMainJob() == xi.job.NIN

    local defBonus = isNIN and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local regen    = isNIN and math.max(2, math.floor(lvl / 14)) or 1

    player:addMod(xi.mod.DEF, defBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 300)
    player:timer(300000, function(p)
        p:delMod(xi.mod.DEF, defBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Yonin', string.format('DEF +%d  Regen +%d', defBonus, regen))
    end
end

return abilityObject
