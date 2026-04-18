-----------------------------------
-- Red Mage Job Utilities
-----------------------------------
require('scripts/globals/utils')
-----------------------------------
xi = xi or {}
xi.job_utils = xi.job_utils or {}
xi.job_utils.red_mage = xi.job_utils.red_mage or {}

-----------------------------------
-- Ability Check Functions
-----------------------------------
xi.job_utils.red_mage.checkChainspell = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

xi.job_utils.red_mage.checkStymie = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

-----------------------------------
-- Ability Use Functions
-----------------------------------
xi.job_utils.red_mage.useChainspell = function(player, target, ability)
    player:addStatusEffect(xi.effect.CHAINSPELL, 1, 0, 60)
end

xi.job_utils.red_mage.useComposure = function(player, target, ability)
    player:delStatusEffect(xi.effect.COMPOSURE)
    player:addStatusEffect(xi.effect.COMPOSURE, 1, 0, 7200)
end

xi.job_utils.red_mage.useConvert = function(player, target, ability)
    local playerMP    = player:getMP()
    local playerHP    = player:getHP()
    local playerMaxHP = player:getMaxHP()

    -- HP bonuses
    local murgleisExtraHP = 0

    if player:getMod(xi.mod.AUGMENTS_CONVERT) > 0 then
        murgleisExtraHP = math.floor(playerMaxHP * player:getMod(xi.mod.AUGMENTS_CONVERT) / 100)
    end

    if playerMP > 0 then -- Safety check, not really needed.
        player:setHP(playerMP + murgleisExtraHP)
        player:setMP(playerHP)
    end
end

xi.job_utils.red_mage.useSaboteur = function(player, target, ability)
    player:addStatusEffect(xi.effect.SABOTEUR, 1, 0, 60)
end

xi.job_utils.red_mage.useSpontaneity = function(player, target, ability)
    target:addStatusEffect(xi.effect.SPONTANEITY, 1, 0, 60)
end

xi.job_utils.red_mage.useStymie = function(player, target, ability)
    target:addStatusEffect(xi.effect.STYMIE, 1, 0, 60)
end

-- ══════════════════════════════════════════════════════════════
-- Solo Synergy — Red Mage (75 Era Strict)
-- ══════════════════════════════════════════════════════════════
require('scripts/globals/solo_synergy')

do
    local ss = xi.soloSynergy
    local _RDM = xi.job_utils.red_mage

    local _convert = _RDM.useConvert
    _RDM.useConvert = function(player, target, ability)
        ss.onAbilityUse(player, target, ability)
        _convert(player, target, ability)
        player:setLocalVar('SS_SPELLBLADE', 1)
        ss.flash(player, 'SPELLBLADE primed: +25% WS damage.')
    end
end
