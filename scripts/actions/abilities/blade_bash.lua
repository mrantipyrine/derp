-----------------------------------
-- Ability: Blade Bash
-- Deliver an attack that can stun the target and occasionally cause Plague.
-- Obtained: Samurai Level 75
-- Recast Time: 3:00
-- Duration: Instant
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if not player:isWeaponTwoHanded() then
        return xi.msg.basic.NEEDS_2H_WEAPON, 0
    end

    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    -- Stun rate
    if math.random(1, 100) < 99 then
        target:addStatusEffect(xi.effect.STUN, 1, 0, 6)
    end

    -- Yes, even Blade Bash deals damage dependant of Dark Knight level
    local jobLevel = utils.getActiveJobLevel(player, xi.job.DRK)
    local damage   = math.floor(player:getMod(xi.mod.WEAPON_BASH) + (jobLevel + 11) / 4)

    -- Calculating and applying Blade Bash damage
    damage = utils.stoneskin(target, damage)
    target:takeDamage(damage, player, xi.attackType.PHYSICAL, xi.damageType.BLUNT)
    target:updateEnmityFromDamage(player, damage)

    -- Applying Plague based on merit level.
    if math.random(1, 100) < 65 then
        target:addStatusEffect(xi.effect.PLAGUE, 5, 0, 15 + player:getMerit(xi.merit.BLADE_BASH))
    end

    ability:setMsg(xi.msg.basic.JA_DAMAGE)

    -- Solo bonus
    local isWAR = player:getMainJob() == xi.job.WAR
    local lvl = player:getMainLvl()
    local strBonus = isWAR and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)
    local attBonus = isWAR and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    player:addMod(xi.mod.STR, strBonus)
    player:addMod(xi.mod.ATT, attBonus)
    player:timer(30000, function(p) p:delMod(xi.mod.STR, strBonus) p:delMod(xi.mod.ATT, attBonus) end)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Blade Bash', string.format('STR +%d  ATT +%d', strBonus, attBonus))
    end

    return damage
end

return abilityObject
