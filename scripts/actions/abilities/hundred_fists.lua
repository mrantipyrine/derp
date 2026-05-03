-----------------------------------
-- Ability: Hundred Fists
-- Speeds up attacks.
-- Obtained: Monk Level 1
-- Recast Time: 1:00:00
-- Duration: 0:00:45
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.monk.checkHundredFists(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.monk.useHundredFists(player, target, ability)

    local isMNK   = player:getMainJob() == xi.job.MNK
    local lvl     = player:getMainLvl()

    -- STR bonus for the duration of the frenzy
    local strBonus = isMNK and math.floor(lvl * 0.30) or math.floor(lvl * 0.15)
    player:addMod(xi.mod.STR, strBonus)
    player:timer(45000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)

    -- Regain: keep TP cycling so every hit feeds into WS usage
    local regain = isMNK and 4 or 2
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 45)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Hundred Fists', string.format('STR +%d  Regain +%d', strBonus, regain))
    end
end

return abilityObject
