-----------------------------------
-- Iron Tempest
-- Great Axe weapon skill
-- Skill Level: 40
-- Delivers a single-hit attack. Damage varies with TP.
-- Will stack with Sneak Attack.
-- Aligned with the Soil Gorget.
-- Aligned with the Soil Belt.
-- Element: None
-- Modifiers: STR:30%
-- 100%TP    200%TP    300%TP
-- 1.00      1.00      1.00
-----------------------------------
local weaponskillObject = {}

weaponskillObject.onUseWeaponSkill = function(player, target, wsID, tp, primary, action, taChar)
    local params = {}
    params.numHits = 1
    params.ftpMod = { 1.0, 1.0, 1.0 }
    params.str_wsc = 0.3
    params.atkVaries = { 1.0, 2.0, 3.5 }

    if xi.settings.main.USE_ADOULIN_WEAPON_SKILL_CHANGES then
        params.str_wsc = 0.6
    end
    
    -- Generate a random TP gain between 500 and 1500
    local tpGain = math.random(100, 500)
    player:addTP(tpGain)

    -- Apply Stoneskin for 2 minutes
    local stoneskinDuration = 240 -- 2 minutes in seconds
    player:addStatusEffect(xi.effect.STONESKIN, 0, 3, stoneskinDuration, 0, 10, 1)

    -- Perform the physical attack
    local damage, criticalHit, tpHits, extraHits = xi.weaponskills.doPhysicalWeaponskill(player, target, wsID, params, tp, action, primary, taChar)
    return tpHits, extraHits, criticalHit, damage
end

return weaponskillObject