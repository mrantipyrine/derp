-----------------------------------
-- Ability: Sic
-- Commands the charmed Pet to make a random special attack.
-- Obtained: Beastmaster Level 25
-- Recast Time: 2 minutes
-- Duration: N/A
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if player:getPet() == nil then
        return xi.msg.basic.REQUIRES_A_PET, 0
    else
        if player:getPet():getHP() == 0 then
            return xi.msg.basic.UNABLE_TO_USE_JA, 0
        elseif player:getPet():getTarget() == nil then
            return xi.msg.basic.PET_CANNOT_DO_ACTION, 0
        elseif not player:getPet():hasTPMoves() then
            return xi.msg.basic.UNABLE_TO_USE_JA, 0
        else
            return 0, 0
        end
    end
end

abilityObject.onUseAbility = function(player, target, ability)
    local function doSic(mob)
        if mob:getTP() >= 1000 then
            mob:useMobAbility()
        elseif mob:hasSpellList() then
            mob:castSpell()
        else
            mob:queue(0, doSic)
        end
    end

    player:getPet():queue(0, doSic)
    -- Solo bonus
    local isBST = player:getMainJob() == xi.job.BST
    local lvl = player:getMainLvl()
    local strBonus = isBST and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local tpGain   = isBST and math.random(150, 300) or math.random(50, 120)
    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Sic', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end
end

return abilityObject
