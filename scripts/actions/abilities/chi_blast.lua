-----------------------------------
-- Ability: Chi Blast
-- Job: Monk
-- The long-range nuke + CC. Drains all target TP, stuns, then rewards you
-- with Regen and Regain to keep the fight going.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMNK  = player:getMainJob() == xi.job.MNK
    local lvl    = player:getMainLvl()
    local duration = isMNK and 150 or 90

    -- Target CC: TP drain + stun (retail-correct)
    target:setTP(0)
    target:addStatusEffect(xi.effect.STUN, 1, 0, 5)

    -- Self reward: Regen + Regain to recover from the buildup
    local regenAmt  = isMNK and math.floor(lvl / 12) or math.floor(lvl / 16)
    local regainAmt = isMNK and math.floor(lvl / 12) or math.floor(lvl / 16)
    regenAmt  = math.max(2, regenAmt)
    regainAmt = math.max(2, regainAmt)

    player:addStatusEffect(xi.effect.REGEN,  regenAmt,  3, duration, 0, 10, 1)
    player:addStatusEffect(xi.effect.REGAIN, regainAmt, 3, duration, 0, 10, 1)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Chi Blast', 'TP Drained  Regen +' .. regenAmt .. '  Regain +' .. regainAmt)
    end
    return xi.job_utils.monk.useChiBlast(player, target, ability)
end

return abilityObject
