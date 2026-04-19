-----------------------------------
-- Ability: Palisade
-- Job: Paladin
-- Raises block rate, no enmity loss on blocks.
-- Solo bonus: ACC + Regain — every block is a counterattack opportunity.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.paladin.usePalisade(player, target, ability)

    local lvl   = player:getMainLvl()
    local isPLD = player:getMainJob() == xi.job.PLD

    local accBonus = isPLD and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local regain   = isPLD and math.max(2, math.floor(lvl / 14)) or 1

    player:addMod(xi.mod.ACC, accBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 60)
    player:timer(60000, function(p)
        p:delMod(xi.mod.ACC, accBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Palisade', string.format('ACC +%d  Regain +%d', accBonus, regain))
    end
end

return abilityObject
