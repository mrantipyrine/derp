-----------------------------------
-- Ability: Chakra
-- Job: Monk
-- The sustain button. HP restore stays — it's the whole point of Chakra.
-- Heal is VIT-based (deterministic, scales with gear) not a 30-80% lottery.
-- Clears status effects and keeps offensive buffs rolling after.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMNK  = player:getMainJob() == xi.job.MNK
    local lvl    = player:getMainLvl()
    local vit    = player:getStat(xi.mod.VIT)
    local duration = isMNK and 120 or 60

    -- VIT-based heal: rewards stacking VIT, not gambling on RNG
    local healMult = isMNK and 3.0 or 1.5
    local heal     = math.floor(vit * healMult)
    local lostHP   = player:getMaxHP() - player:getHP()
    player:setHP(player:getHP() + math.min(heal, lostHP))

    -- Status cleanse (retail function)
    player:delStatusEffect(xi.effect.BLINDNESS)
    player:delStatusEffect(xi.effect.POISON)
    player:delStatusEffect(xi.effect.PARALYSIS)

    -- Stat buffs: keep offensive pressure after the heal
    local statBonus = isMNK and math.floor(lvl / 7) or math.floor(lvl / 10)
    player:addMod(xi.mod.ATT, statBonus, 3, duration, 0, 10, 1)
    player:addMod(xi.mod.ACC, statBonus, 3, duration, 0, 10, 1)
    player:addStatusEffect(xi.effect.VIT_BOOST, statBonus, 0, duration, 0, 0, 0)

    -- Regain: trickle TP while recovering
    local regainAmt = isMNK and math.floor(lvl / 10) or math.floor(lvl / 14)
    player:addStatusEffect(xi.effect.REGAIN, regainAmt, 3, duration, 0, 10, 1)

    if xi.soloSynergy then
        local healAmt = math.min(math.floor(vit * healMult), lostHP)
        xi.soloSynergy.flashBuff(player, 'Chakra', 'HP +' .. healAmt .. '  ATT/ACC +' .. statBonus)
    end
    return xi.job_utils.monk.useChakra(player, target, ability)
end

return abilityObject
