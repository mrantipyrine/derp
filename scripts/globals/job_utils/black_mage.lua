-----------------------------------
-- Black Mage Job Utilities
-----------------------------------
require('scripts/globals/utils')
-----------------------------------
xi = xi or {}
xi.job_utils = xi.job_utils or {}
xi.job_utils.black_mage = xi.job_utils.black_mage or {}

-----------------------------------
-- Ability Check Functions
-----------------------------------
xi.job_utils.black_mage.checkManafont = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

xi.job_utils.black_mage.checkSubtleSorcery = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

-----------------------------------
-- Ability Use Functions
-----------------------------------
xi.job_utils.black_mage.useCascade = function(player, target, ability)
    player:addStatusEffect(xi.effect.CASCADE, 1, 0, 60)
end

xi.job_utils.black_mage.useElementalSeal = function(player, target, ability)
    player:addStatusEffect(xi.effect.ELEMENTAL_SEAL, 1, 0, 60)
end

xi.job_utils.black_mage.useEnmityDouse = function(player, target, ability)
    if target:isMob() then
        target:setCE(player, 1)
        target:setVE(player, 0)
    end
end

xi.job_utils.black_mage.useManafont = function(player, target, ability)
    player:addStatusEffect(xi.effect.MANAFONT, 1, 0, 60)
end

xi.job_utils.black_mage.useManaWall = function(player, target, ability)
    player:addStatusEffect(xi.effect.MANA_WALL, 1, 0, 300)
end

xi.job_utils.black_mage.useManawell = function(player, target, ability)
    target:addStatusEffect(xi.effect.MANAWELL, 1, 0, 60)
end

xi.job_utils.black_mage.useSubtleSorcery = function(player, target, ability)
    player:addStatusEffect(xi.effect.SUBTLE_SORCERY, 1, 0, 60)
end

-- ══════════════════════════════════════════════════════════════
-- Solo Synergy — Black Mage
-- ══════════════════════════════════════════════════════════════
-- Design fantasy: arcane architect. Elemental Seal hits far
-- harder solo. Manafont also restores party-adjacent MP. 
-- Cascade makes the next SC do bonus burst damage.
-- Mana Wall creates a longer solo safety window.
-- ══════════════════════════════════════════════════════════════
require('scripts/globals/solo_synergy')

do
    local ss   = xi.soloSynergy
    local _BLM = xi.job_utils.black_mage

    -- Elemental Seal — solo: flag for damage_spell.lua to amplify next nuke.
    local _es = _BLM.useElementalSeal
    _BLM.useElementalSeal = function(player, target, ability)
        _es(player, target, ability)
        if player:getPartySize() <= 2 then
            player:setLocalVar('SS_BLM_SEAL_SOLO', 1)
            ss.flash(player, 'Solo Elemental Seal: next nuke deals 2x.')
        end
    end

    -- Manafont — solo: on activation, also restores 20% of max MP immediately.
    local _mf = _BLM.useManafont
    _BLM.useManafont = function(player, target, ability)
        _mf(player, target, ability)
        if player:getPartySize() <= 2 then
            ss.restoreMPPct(player, 0.20)
            ss.flash(player, 'Solo Manafont: MP+20% burst')
        end
    end

    -- Mana Wall — solo: extended duration (mages need longer solo safety).
    local _mw = _BLM.useManaWall
    _BLM.useManaWall = function(player, target, ability)
        _mw(player, target, ability)
        if player:getPartySize() <= 2 then
            local eff = player:getStatusEffect(xi.effect.MANA_WALL)
            if eff then eff:setDuration(eff:getDuration() + 60) end
            ss.flash(player, 'Solo Mana Wall: +60s')
        end
    end

    -- Cascade — solo: next magic burst also deals bonus damage.
    local _cas = _BLM.useCascade
    _BLM.useCascade = function(player, target, ability)
        _cas(player, target, ability)
        if player:getPartySize() <= 2 then
            player:setLocalVar('SS_BLM_CASCADE_BONUS', 1)
            ss.flash(player, 'Solo Cascade: next magic burst deals bonus damage.')
        end
    end

    -- Subtle Sorcery — solo: also grants a short Refresh.
    local _ss2 = _BLM.useSubtleSorcery
    _BLM.useSubtleSorcery = function(player, target, ability)
        _ss2(player, target, ability)
        if player:getPartySize() <= 2 then
            local r = math.floor(player:getMainLvl() / 15) + 2
            player:addStatusEffect(xi.effect.REFRESH, r, 3, 60)
            ss.flash(player, string.format('Solo Subtle Sorcery: Refresh+%d', r))
        end
    end
end
