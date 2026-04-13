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
    local jpExtraHP       = math.floor(playerMaxHP * player:getJobPointLevel(xi.jp.CONVERT_EFFECT) / 100)
    local murgleisExtraHP = 0

    if player:getMod(xi.mod.AUGMENTS_CONVERT) > 0 then
        murgleisExtraHP = math.floor(playerMaxHP * player:getMod(xi.mod.AUGMENTS_CONVERT) / 100)
    end

    if playerMP > 0 then -- Safety check, not really needed.
        player:setHP(playerMP + jpExtraHP + murgleisExtraHP)
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
-- Solo Synergy — Red Mage
-- ══════════════════════════════════════════════════════════════
-- Design fantasy: the ultimate solo-capable Swiss army knife.
-- Convert has a safety floor so it can't kill you. Composure
-- doubles self-buff durations when alone. Chainspell briefly
-- resets all spell recast timers after firing. Saboteur lands
-- enfeebles reliably solo.
-- ══════════════════════════════════════════════════════════════
require('scripts/globals/solo_synergy')

do
    local ss   = xi.soloSynergy
    local _RDM = xi.job_utils.red_mage

    -- Convert — safety net: never drops below 5% HP.
    -- Solo bonus: gain a free Refresh tick on top.
    local _conv = _RDM.useConvert
    _RDM.useConvert = function(player, target, ability)
        local hpFloor = math.max(math.floor(player:getMaxHP() * 0.05), 5)
        -- Temporarily floor HP so the swap can't kill
        local preHP = player:getHP()
        if preHP < hpFloor then
            ss.flash(player, 'Convert blocked: HP critically low.')
            return
        end
        _conv(player, target, ability)
        if player:getHP() < hpFloor then
            player:setHP(hpFloor)
        end
        -- Solo: free Refresh burst after Convert
        if player:getPartySize() <= 2 then
            local r = math.floor(player:getMainLvl() / 10) + 3
            player:addStatusEffect(xi.effect.REFRESH, r, 3, 60)
            ss.flash(player, string.format('Solo Convert: safe floor held. Refresh+%d', r))
        end
    end

    -- Composure — solo: buff duration on self is tripled (not doubled).
    local _comp = _RDM.useComposure
    _RDM.useComposure = function(player, target, ability)
        _comp(player, target, ability)
        if player:getPartySize() <= 2 then
            -- Flag for spell enhancement hooks to apply 3x instead of 2x
            player:setLocalVar('SS_RDM_COMPOSURE_SOLO', 1)
            ss.flash(player, 'Solo Composure: self-buff duration tripled.')
        end
    end

    -- Chainspell — solo: also grants a short Haste burst.
    local _cs = _RDM.useChainspell
    _RDM.useChainspell = function(player, target, ability)
        _cs(player, target, ability)
        if player:getPartySize() <= 2 then
            player:addStatusEffect(xi.effect.HASTE, 15, 0, 60)
            ss.flash(player, 'Solo Chainspell: Haste+15 for duration')
        end
    end

    -- Saboteur — solo: guaranteed first enfeeble lands (set a flag).
    local _sab = _RDM.useSaboteur
    _RDM.useSaboteur = function(player, target, ability)
        _sab(player, target, ability)
        if player:getPartySize() <= 2 then
            player:setLocalVar('SS_RDM_SABOTEUR_SURE', 1)
            ss.flash(player, 'Solo Saboteur: next enfeeble guaranteed to land.')
        end
    end

    -- Stymie — solo: also reduces target magic evasion briefly.
    local _stym = _RDM.useStymie
    _RDM.useStymie = function(player, target, ability)
        _stym(player, target, ability)
        if player:getPartySize() <= 2 and target and target:isMob() then
            target:addStatusEffect(xi.effect.MAGIC_EVASION_DOWN, 20, 0, 30)
            ss.flash(player, 'Solo Stymie: target MEVA down.')
        end
    end
end
