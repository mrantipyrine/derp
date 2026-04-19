-----------------------------------
-- Ability: Shield Bash
-- Job: Paladin
-- Shield attack that can stun. Shield required.
-- Solo bonus: TP gain on hit + brief DEF boost after the bash.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.paladin.checkShieldBash(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    local result = xi.job_utils.paladin.useShieldBash(player, target, ability)

    local lvl   = player:getMainLvl()
    local isPLD = player:getMainJob() == xi.job.PLD

    local tpGain   = isPLD and math.random(200, 400) or math.random(80, 160)
    local defBonus = isPLD and math.floor(lvl * 0.15) or math.floor(lvl * 0.07)

    player:addTP(tpGain)
    player:addMod(xi.mod.DEF, defBonus)
    player:timer(20000, function(p)
        p:delMod(xi.mod.DEF, defBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Shield Bash', string.format('TP +%d  DEF +%d (20s)', tpGain, defBonus))
    end

    return result
end

return abilityObject
