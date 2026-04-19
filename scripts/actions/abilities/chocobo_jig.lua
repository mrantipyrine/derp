-----------------------------------
-- Ability: Chocobo jig
-- Increases Movement Speed.
-- Obtained: Dancer Level 55
-- TP Required: 0
-- Recast Time: 1:00
-- Duration: 2:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local baseDuration       = 120 + player:getJobPointLevel(xi.jp.JIG_DURATION)
    local durationMultiplier = 1.0 + utils.clamp(player:getMod(xi.mod.JIG_DURATION), 0, 50) / 100
    local finalDuration      = math.floor(baseDuration * durationMultiplier)

    -- TODO: Chocobo Jig will not override all types of weight effect. Find out which aren't overriden.
    if player:hasStatusEffect(xi.effect.WEIGHT) then
        player:delStatusEffect(xi.effect.WEIGHT)
    end

    player:addStatusEffect(xi.effect.QUICKENING, 20, 0, finalDuration)
    -- Solo bonus
    local isDNC = player:getMainJob() == xi.job.DNC
    local lvl = player:getMainLvl()
    local agiBonus = isDNC and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local evaBonus = isDNC and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.AGI, agiBonus)
    player:addMod(xi.mod.EVA, evaBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.AGI, agiBonus) p:delMod(xi.mod.EVA, evaBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Chocobo Jig', string.format('AGI +%d  EVA +%d', agiBonus, evaBonus))
    end
end

return abilityObject
