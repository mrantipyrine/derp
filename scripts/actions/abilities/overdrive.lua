-----------------------------------
-- Ability: Overdrive
-- Augments the fighting ability of your automaton to its maximum level.
-- Obtained: Puppetmaster Level 1
-- Recast Time: 1:00:00
-- Duration: 1:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    local pet = player:getPet()
    if not pet then
        return xi.msg.basic.REQUIRES_A_PET, 0
    elseif not pet:isAutomaton() then
        return xi.msg.basic.NO_EFFECT_ON_PET, 0
    else
        ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
        return 0, 0
    end
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.OVERDRIVE, 0, 0, 60)

    -- Solo bonus
    local isPUP = player:getMainJob() == xi.job.PUP
    local lvl = player:getMainLvl()
    local strBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    local intBonus = isPUP and math.floor(lvl * 0.20) or math.floor(lvl * 0.10)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.INT, intBonus)
    player:timer(60000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.INT, intBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Overdrive', string.format('STR +%d  INT +%d', strBonus, intBonus))
    end

    return xi.effect.OVERDRIVE
end

return abilityObject
