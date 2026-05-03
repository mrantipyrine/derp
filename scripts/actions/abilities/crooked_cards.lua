-----------------------------------
-- Ability: Crooked Cards
-- Description: Increases the effects of the next phantom roll.
-- Obtained: COR Level 95
-- Recast Time: 0:10:00
-- Duration: 0:01:00(or the next roll used)
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    target:addStatusEffect(xi.effect.CROOKED_CARDS, 20, 0, 60)

    -- Solo bonus: CHR spike to maximise the next enhanced roll
    local isCOR   = player:getMainJob() == xi.job.COR
    local lvl     = player:getMainLvl()
    local chrBonus = isCOR and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.CHR, chrBonus)
    player:timer(60000, function(p)
        p:delMod(xi.mod.CHR, chrBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Crooked Cards', string.format('CHR +%d', chrBonus))
    end
end

return abilityObject
