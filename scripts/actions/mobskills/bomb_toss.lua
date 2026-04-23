-----------------------------------
-- Bomb Toss
-- Throws a bomb at an enemy.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    -- Goblin Friend Logic
    if target:isPC() and xi.soloSynergy then
        local favor = xi.soloSynergy.getGoblinFavor(target)
        if favor >= 500 then
            -- Healing Bomb: If player is hurt, heal instead of damage
            local hpPct = target:getHP() / target:getMaxHP()
            if hpPct < 0.75 then
                local heal = math.floor(target:getMaxHP() * 0.20)
                target:addHP(heal)
                xi.soloSynergy.flash(target, 'Goblin Friend! Healing Bomb thrown.')
                return 0
            end
        end
    end

    local damage = mob:getWeaponDmg() * 3

    damage = xi.mobskills.mobMagicalMove(mob, target, skill, damage, xi.element.FIRE, 1, xi.mobskills.magicalTpBonus.MAB_BONUS, 1)
    damage = xi.mobskills.mobFinalAdjustments(damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS)

    target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)

    return damage
end

return mobskillObject
