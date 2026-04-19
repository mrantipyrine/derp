-----------------------------------
-- Ability: Cutting Cards
-- Description: Reduces the recast times of other party members' special abilities. The degree to which they are reduced is determined by the number rolled.
-- Obtained: COR Level 96
-- Recast Time: 01:00:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

abilityObject.onUseAbility = function(caster, target, ability, action)
    xi.job_utils.corsair.useCuttingCards(caster, target, ability, action)
    -- Solo bonus
    local isCOR = player:getMainJob() == xi.job.COR
    local lvl = player:getMainLvl()
    local chrBonus = isCOR and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local tpGain   = isCOR and math.random(150, 300) or math.random(50, 100)
    player:addMod(xi.mod.CHR, chrBonus)
    player:addTP(tpGain)
    player:timer(60000, function(p) p:delMod(xi.mod.CHR, chrBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Cutting Cards', string.format('CHR +%d  TP +%d', chrBonus, tpGain))
    end
end

return abilityObject
