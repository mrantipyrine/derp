-----------------------------------
-- Ability: Counterstance
-- Job: Monk
-- Glass cannon mode: big counter chance, kick pressure, BUT lower DEF.
-- The 60s multi-attack burst is fun and intentional — short window.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local isMNK  = player:getMainJob() == xi.job.MNK
    local lvl    = player:getMainLvl()
    local coreDur   = 300
    local burstDur  = 60

    -- Kick and counter scale with level
    local kickRate    = isMNK and math.floor(lvl / 6) or math.floor(lvl / 9)
    local counterBoost = isMNK and math.floor(lvl / 6) or math.floor(lvl / 9)
    counterBoost = counterBoost + player:getMerit(xi.merit.COUNTER_RATE) * 2

    -- DEF penalty: the cost of going full aggro
    local defPenalty = isMNK and -20 or -12
    player:addMod(xi.mod.DEF, defPenalty, 3, coreDur)

    -- Core sustained effects
    player:addStatusEffect(xi.effect.EVASION_BOOST,  math.floor(lvl / 8), 3, coreDur, 0, 10, 1)
    player:addMod(xi.mod.KICK_ATTACK_RATE, kickRate,    3, coreDur, 0, 10, 1)
    player:addMod(xi.mod.KICK_DMG,         kickRate,    3, coreDur, 0, 10, 1)
    player:addStatusEffect(xi.effect.COUNTER_BOOST, counterBoost, 3, coreDur, 0, 10, 1)

    -- 60-second burst: the fun window where you go absolutely feral
    player:addMod(xi.mod.QUAD_ATTACK,   1,  3, burstDur, 0, 10, 1)
    player:addMod(xi.mod.TRIPLE_ATTACK, 8,  3, burstDur, 0, 10, 1)
    player:addMod(xi.mod.DOUBLE_ATTACK, 12, 3, burstDur, 0, 10, 1)

    xi.job_utils.monk.useCounterstance(player, target, ability)
    -- Solo bonus
    local isMNK = player:getMainJob() == xi.job.MNK
    local lvl = player:getMainLvl()
    local strBonus = isMNK and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local tpGain   = isMNK and math.random(200, 400) or math.random(80, 160)
    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Counterstance', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end
end

return abilityObject
