-----------------------------------
-- Hard Slash
-- Great Sword weapon skill
-- Skill level: 5
-- Delivers a single-hit attack. Damage varies with TP.
-- Modifiers: STR:30%
-- 100%TP     200%TP     300%TP
-- 1.5         1.75        2.0
-----------------------------------
local weaponskillObject = {}

weaponskillObject.onUseWeaponSkill = function(player, target, wsID, tp, primary, action, taChar)
    local params = {}
    params.numHits = 1
    params.ftpMod = { 1.5, 1.75, 2.0 }
    -- wscs are in % so 0.2=20%
    params.str_wsc = 0.3

    if xi.settings.main.USE_ADOULIN_WEAPON_SKILL_CHANGES then
        params.str_wsc = 1.0
    end

    -- Calculate HP restoration based on TP
    local hpRestore = math.floor(tp / 1000) * 0.2 * player:getMaxHP()
    player:addHP(hpRestore)

    -- Restore HP to the player
    if math.random(0, 100) <= 30 then
        player:addTP(1500)
    end

    local strIncrease = player:getMainLvl() <= 8 and 1 or player:getMainJob() == xi.job.WAR and player:getMainLvl() / 6 or player:getMainLvl() / 8
    local duration = 25

    player:addStatusEffect(xi.effect.STR_BOOST, strIncrease, 0, duration, 0, 0, 0)

    local damage, criticalHit, tpHits, extraHits = xi.weaponskills.doPhysicalWeaponskill(player, target, wsID, params, tp, action, primary, taChar)
    return tpHits, extraHits, criticalHit, damage
end

return weaponskillObject
