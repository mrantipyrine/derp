-----------------------------------
-- Ability: Manafont
-- Job: Black Mage
-- 1hr: free spells for 60s.
-- Solo bonus: INT + Regain — the archmage empties the sky.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.black_mage.checkManafont(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.black_mage.useManafont(player, target, ability)

    local lvl   = player:getMainLvl()
    local isBLM = player:getMainJob() == xi.job.BLM

    local intBonus = isBLM and math.floor(lvl * 0.25) or math.floor(lvl * 0.12)
    local regain   = isBLM and math.max(4, math.floor(lvl / 10)) or math.max(2, math.floor(lvl / 18))

    player:addMod(xi.mod.INT, intBonus)
    player:addStatusEffect(xi.effect.REGAIN, regain * 10, 3, 60)
    player:timer(60000, function(p)
        p:delMod(xi.mod.INT, intBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Manafont', string.format('INT +%d  Regain +%d', intBonus, regain))
    end
end

return abilityObject
