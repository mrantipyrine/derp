-----------------------------------
-- Ability: Sengikori
-- Description: Grants a bonus to skillchains and magic bursts initiated by your next weapon skill.
-- Obtained: SAM Level 77
-- Recast Time: 00:03:00
-- Duration: 0:01:00 or until next Weapon Skill.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.SENGIKORI, 12, 0, 60)

    -- Solo bonus: STR spike for the WS that follows
    local isSAM   = player:getMainJob() == xi.job.SAM
    local lvl     = player:getMainLvl()
    local strBonus = isSAM and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    player:addMod(xi.mod.STR, strBonus)
    player:timer(60000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Sengikori', string.format('STR +%d', strBonus))
    end
end

return abilityObject
