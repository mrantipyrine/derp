-----------------------------------
-- Ability: Martyr
-- Sacrifices HP to heal a party member double the amount.
-- Obtained: White Mage Level 75
-- Recast Time: 0:10:00
-- Duration: Instant
-- Target: Party member, cannot target self.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.white_mage.checkMartyr(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    return xi.job_utils.white_mage.useMartyr(player, target, ability)
    -- Solo bonus
    local isWHM = player:getMainJob() == xi.job.WHM
    local lvl = player:getMainLvl()
    local mndBonus = isWHM and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local regen    = isWHM and math.max(2, math.floor(lvl / 20)) or 1
    player:addMod(xi.mod.MND, mndBonus)
    player:addStatusEffect(xi.effect.REGEN, regen, 3, 30)
    player:timer(30000, function(p) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Martyr', string.format('MND +%d  Regen +%d', mndBonus, regen))
    end
end

return abilityObject
