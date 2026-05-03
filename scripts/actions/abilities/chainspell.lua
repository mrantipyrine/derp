-----------------------------------
-- Ability: Chainspell
-- Job: Red Mage
-- 1hr: rapid spellcasting for 60s.
-- Solo bonus: INT + MND + MP restore — the scarlet sorcerer unleashes everything.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.red_mage.checkChainspell(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.red_mage.useChainspell(player, target, ability)

    local lvl   = player:getMainLvl()
    local isRDM = player:getMainJob() == xi.job.RDM

    local intBonus = isRDM and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local mndBonus = isRDM and math.floor(lvl * 0.16) or math.floor(lvl * 0.08)
    local mpGain   = isRDM and math.floor(lvl * 2.0) or math.floor(lvl * 0.9)

    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:addMP(mpGain)
    player:timer(60000, function(p)
        p:delMod(xi.mod.INT, intBonus)
        p:delMod(xi.mod.MND, mndBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Chainspell', string.format('INT +%d  MND +%d  MP +%d', intBonus, mndBonus, mpGain))
    end
end

return abilityObject
