-----------------------------------
-- Ability: Random Deal
-- Has the possibility of resetting the reuse time of a job ability for each party member within area of effect.
-- Obtained: Corsair Level 50
-- Recast Time: 0:20:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(caster, target, ability, action)
    ability:setMsg(xi.msg.basic.JA_RECEIVES_EFFECT_3)
    if not caster:doRandomDeal(target) then
        ability:setMsg(xi.msg.basic.JA_MISS_2)
    end
    -- Solo bonus
    local isCOR = player:getMainJob() == xi.job.COR
    local lvl = player:getMainLvl()
    local chrBonus = isCOR and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local tpGain   = isCOR and math.random(150, 300) or math.random(50, 100)
    player:addMod(xi.mod.CHR, chrBonus)
    player:addTP(tpGain)
    player:timer(60000, function(p) p:delMod(xi.mod.CHR, chrBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Random Deal', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end
end

return abilityObject
