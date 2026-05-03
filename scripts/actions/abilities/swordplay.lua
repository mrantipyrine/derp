-----------------------------------
-- Ability: Swordplay
-- Increases accuracy and evasion until you take severe damage.
-- Obtained: Rune Fencer level 20
-- Recast Time: 5:00
-- Duration: 2:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.rune_fencer.useSwordplay(player, target, ability)

    local isRUN   = player:getMainJob() == xi.job.RUN
    local lvl     = player:getMainLvl()
    local accBonus = isRUN and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    local evaBonus = isRUN and math.floor(lvl * 0.28) or math.floor(lvl * 0.14)
    player:addMod(xi.mod.ACC, accBonus)
    player:addMod(xi.mod.EVA, evaBonus)
    player:timer(120000, function(p)
        p:delMod(xi.mod.ACC, accBonus)
        p:delMod(xi.mod.EVA, evaBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Swordplay', string.format('ACC +%d  EVA +%d', accBonus, evaBonus))
    end
end

return abilityObject
