-----------------------------------
-- Ability: Warcry
-- Job: Warrior
-- The fight-opener. Pumps ACC and gives a burst of TP to get things rolling.
-- Regain is modest — this is a catalyst, not infinite fuel.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local lvl   = player:getMainLvl()
    local isWAR = player:getMainJob() == xi.job.WAR

    -- ACC buff: noticeable for both main and sub
    local accBonus    = isWAR and math.floor(lvl * 0.40) or math.floor(lvl * 0.20)
    local accDuration = 180

    -- Regain: enough to feel good, not enough to loop WSs forever
    local regainAmt  = isWAR and math.floor(lvl / 10) or math.floor(lvl / 16)
    local regainDur  = isWAR and 120 or 60

    -- Burst TP on use: helps open a fight or recover after a WS
    local tpBurst = isWAR and math.random(400, 700) or math.random(100, 250)

    player:addMod(xi.mod.ACC, accBonus, 3, accDuration, 0, 10, 1)
    player:addMod(xi.mod.REGAIN, regainAmt, 3, regainDur, 0, 10, 1)
    player:addTP(tpBurst)

    return xi.job_utils.warrior.useWarcry(player, target, ability)
end

return abilityObject
