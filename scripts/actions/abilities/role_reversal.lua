-----------------------------------
-- Ability: Role Reversal
-- Swaps Master's current HP with Automaton's current HP.
-- Obtained: Puppetmaster Level 75
-- Recast Time: 2:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    local pet = player:getPet()

    if not pet then
        return xi.msg.basic.REQUIRES_A_PET, 0
    elseif not pet:isAutomaton() then
        return xi.msg.basic.NO_EFFECT_ON_PET, 0
    else
        return 0, 0
    end
end

abilityObject.onUseAbility = function(player, target, ability)
    local pet = player:getPet()

    if pet then
        local bonus    = 1 + (player:getMerit(xi.merit.ROLE_REVERSAL) - 5) / 100
        local playerHP = player:getHP()
        local petHP    = pet:getHP()

        pet:setHP(math.max(playerHP * bonus, 1))
        player:setHP(math.max(petHP * bonus, 1))
    end
    -- Solo bonus
    local isSMN = player:getMainJob() == xi.job.SMN
    local lvl = player:getMainLvl()
    local intBonus = isSMN and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local mndBonus = isSMN and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Role Reversal', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
