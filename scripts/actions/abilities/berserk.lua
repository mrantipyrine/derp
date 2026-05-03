-----------------------------------
-- Ability: Berserk
-- Job: Warrior
-- The raw power button. Big ATT, meaningful DA — but leaves you open.
-- Pairs with Aggressor for ~35% DA total. Not 93%.
-----------------------------------
local abilityObject = {}

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.warrior.useBerserk(player, target, ability)

    local lvl   = player:getMainLvl()
    local isWAR = player:getMainJob() == xi.job.WAR

    -- WAR main: big ATT spike, solid DA, long duration
    -- Sub: still worth using, just not overwhelming
    local attBonus  = isWAR and math.floor(lvl * 0.55) or math.floor(lvl * 0.28)
    local daRate    = isWAR and 20 or 10
    local daDmg     = isWAR and 12 or 6
    local duration  = isWAR and 290 or 180

    player:addMod(xi.mod.ATT,               attBonus, 3, duration, 0, 10, 1)
    player:addMod(xi.mod.DOUBLE_ATTACK,     daRate,   3, duration, 0, 10, 1)
    player:addMod(xi.mod.DOUBLE_ATTACK_DMG, daDmg,    3, duration, 0, 10, 1)
    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Berserk', 'ATT +' .. attBonus .. '  DA +' .. daRate .. '%')
    end
end

return abilityObject
