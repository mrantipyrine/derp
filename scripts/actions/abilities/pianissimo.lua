-----------------------------------
-- Ability: Pianissimo
-- Limits area of effect of next song to a single target.
-- Obtained: Bard Level 20
-- Recast Time: 0:00:15
-- Duration: 00:01:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.PIANISSIMO, 0, 0, 60)
    -- Solo bonus
    local isBRD = player:getMainJob() == xi.job.BRD
    local lvl = player:getMainLvl()
    local chrBonus = isBRD and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.CHR, chrBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.CHR, chrBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Pianissimo', string.format('CHR +%d', chrBonus))
    end
end

return abilityObject
