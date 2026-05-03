-----------------------------------
-- Ability: Aggressor
-- Job: Warrior
-- Focused offense: ACC, double/triple attack, and weapon-specific bonuses.
-- Stacks with Berserk for ~35% DA combined — strong but not broken.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    local lvl      = player:getMainLvl()
    local isWAR    = player:getMainJob() == xi.job.WAR
    local duration = isWAR and 180 or 120

    -- ACC scales nicely with level; ATT is a moderate flat bonus
    local accBonus = isWAR and math.floor(lvl * 0.35) or math.floor(lvl * 0.18)
    local attBonus = isWAR and math.floor(lvl * 0.30) or math.floor(lvl * 0.15)
    -- DA 15% main / 8% sub — combined with Berserk's 20% gives ~35% max
    local daRate   = isWAR and 15 or 8
    local daDmg    = isWAR and 8  or 4

    if player:getWeaponSkillType(xi.slot.MAIN) == xi.skill.GREAT_AXE then
        -- Great Axe: swap DA for Triple Attack + light Haste
        player:addMod(xi.mod.TRIPLE_ATTACK,     daRate, 3, duration, 0, 10, 1)
        player:addMod(xi.mod.TRIPLE_ATTACK_DMG, daDmg,  3, duration, 0, 10, 1)
        player:addStatusEffect(xi.effect.HASTE, isWAR and 12 or 6, 3, duration)
    else
        player:addMod(xi.mod.ACC,               accBonus, 3, duration, 0, 10, 1)
        player:addMod(xi.mod.DOUBLE_ATTACK,     daRate,   3, duration, 0, 10, 1)
        player:addMod(xi.mod.DOUBLE_ATTACK_DMG, daDmg,    3, duration, 0, 10, 1)
    end

    player:addMod(xi.mod.ATT, attBonus, 3, duration, 0, 10, 1)

    if xi.soloSynergy then
        local wep = player:getWeaponSkillType(xi.slot.MAIN) == xi.skill.GREAT_AXE
        local tag = wep and 'TA +' .. daRate .. '%  Haste' or 'DA +' .. daRate .. '%  ATT +' .. attBonus
        xi.soloSynergy.flashBuff(player, 'Aggressor', tag)
    end
    xi.job_utils.warrior.useAggressor(player, target, ability)
end

return abilityObject
