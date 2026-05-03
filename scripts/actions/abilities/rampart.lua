-----------------------------------
-- Ability: Rampart
-- Job: Paladin
-- Party-wide SDT -25% for 30s.
-- Solo bonus: MaxHP boost + Regen — standing alone behind the rampart.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.paladin.useRampart(player, target, ability)

    local lvl   = player:getMainLvl()
    local isPLD = player:getMainJob() == xi.job.PLD

    local hpBonus = isPLD and math.floor(lvl * 2.5) or math.floor(lvl * 1.2)
    local regen   = isPLD and math.max(3, math.floor(lvl / 12)) or 1

    player:addMod(xi.mod.MAX_HP, hpBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 30)
    player:timer(30000, function(p)
        p:delMod(xi.mod.MAX_HP, hpBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Rampart', string.format('MaxHP +%d  Regen +%d', hpBonus, regen))
    end
end

return abilityObject
