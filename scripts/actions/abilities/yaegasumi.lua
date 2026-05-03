-----------------------------------
-- Ability: Yaegasumi
-- Job: Samurai
-- Evade special attacks; WS damage bonus for each evasion.
-- Solo bonus: EVA + Regain — the lone swordsman reads every move.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.YAEGASUMI, 12, 0, 45)

    local lvl   = player:getMainLvl()
    local isSAM = player:getMainJob() == xi.job.SAM

    local evaBonus = isSAM and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regain   = isSAM and math.max(3, math.floor(lvl / 12)) or 1

    player:addMod(xi.mod.EVA, evaBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 45)
    player:timer(45000, function(p)
        p:delMod(xi.mod.EVA, evaBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Yaegasumi', string.format('EVA +%d  Regain +%d', evaBonus, regain))
    end
end

return abilityObject
