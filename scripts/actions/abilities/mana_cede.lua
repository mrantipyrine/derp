-----------------------------------
-- Ability: Mana Cede
-- Description: Channels your MP into TP for avatars and elementals.
-- Obtained: SMN Level 87
-- Recast Time: 00:05:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    local playerMP = player:getMP()
    local avatar   = player:getPet()

    -- Retail only checks if you have an avatar summoned, but we can do better.
    -- Actual behavior: Ability can still be used at 3000 TP and < 100 MP.
    -- Results in player expending the rest of their MP and subsequently dismissing avatar.
    if avatar ~= nil then
        local avatarTP = avatar:getTP()
        if avatarTP == 3000 or playerMP < 100 then
            return xi.msg.basic.UNABLE_TO_USE_JA, 0
        end
    elseif avatar == nil then
        return xi.msg.basic.REQUIRES_A_PET, 0
    end
end

abilityObject.onUseAbility = function(player, target, ability, action)
    xi.job_utils.summoner.useManaCede(player, ability, action)
    -- Solo bonus
    local isSMN = player:getMainJob() == xi.job.SMN
    local lvl = player:getMainLvl()
    local intBonus = isSMN and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local mndBonus = isSMN and math.floor(lvl * 0.14) or math.floor(lvl * 0.07)
    player:addMod(xi.mod.INT, intBonus)
    player:addMod(xi.mod.MND, mndBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.INT, intBonus) p:delMod(xi.mod.MND, mndBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Mana Cede', string.format('INT +%d  MND +%d', intBonus, mndBonus))
    end
end

return abilityObject
