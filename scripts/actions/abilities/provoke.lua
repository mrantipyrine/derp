-----------------------------------
-- Ability: Provoke
-- Job: Warrior
-- Taunt + fight-starter. Grabs enmity, generates TP, gives a brief VIT spike.
-- No HP restore — Defender is your survive button.
-- Fixed: removed undefined tpGain reference.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local lvl   = player:getMainLvl()
    local isWAR = player:getMainJob() == xi.job.WAR

    -- TP on taunt: rewards opening with Provoke, not spamming it for healing
    local tpGain = isWAR and math.random(300, 500) or math.random(80, 200)
    player:addTP(tpGain)

    -- Brief VIT bump — makes the next hit a little less painful
    local vitBoost   = math.max(1, isWAR and math.floor(lvl / 6) or math.floor(lvl / 10))
    local vitDuration = 25
    player:addStatusEffect(xi.effect.VIT_BOOST, vitBoost, 0, vitDuration, 0, 0, 0)

    -- Enmity transfer handled by the base ability
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Provoke', 'TP +' .. tpGain .. '  VIT +' .. vitBoost)
    end
    xi.job_utils.warrior.useProvoke(player, target, ability)
end

return abilityObject
