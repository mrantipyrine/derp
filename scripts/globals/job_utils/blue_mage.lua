-----------------------------------
-- Blue Mage Job Utilities
-----------------------------------
require('scripts/globals/utils')
-----------------------------------
xi = xi or {}
xi.job_utils = xi.job_utils or {}
xi.job_utils.blue_mage = xi.job_utils.blue_mage or {}
-----------------------------------

-----------------------------------
-- Ability Check Functions
-----------------------------------

xi.job_utils.blue_mage.checkAzureLore = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))

    return 0, 0
end

xi.job_utils.blue_mage.checkBurstAffinity = function(player, target, ability)
    return 0, 0
end

xi.job_utils.blue_mage.checkChainAffinity = function(player, target, ability)
    return 0, 0
end

xi.job_utils.blue_mage.checkDiffusion = function(player, target, ability)
    if player:hasStatusEffect(xi.effect.DIFFUSION) then
        return xi.msg.basic.EFFECT_ALREADY_ACTIVE, 0
    end

    return 0, 0
end

xi.job_utils.blue_mage.checkEfflux = function(player, target, ability)
    return 0, 0
end

xi.job_utils.blue_mage.checkUnbridledWisdom = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

xi.job_utils.blue_mage.checkUnbridledLearning = function(player, target, ability)
    return 0, 0
end

-----------------------------------
-- Ability Use Functions
-----------------------------------

xi.job_utils.blue_mage.useAzureLore = function(player, target, ability, action)
    player:addStatusEffect(xi.effect.AZURE_LORE, 1, 0, 30)
end

xi.job_utils.blue_mage.useBurstAffinity = function(player, target, ability, action)
    player:addStatusEffect(xi.effect.BURST_AFFINITY, 1, 0, 30)
    return xi.effect.BURST_AFFINITY
end

xi.job_utils.blue_mage.useChainAffinity = function(player, target, ability, action)
    player:addStatusEffect(xi.effect.CHAIN_AFFINITY, 1, 0, 30)
    return xi.effect.CHAIN_AFFINITY
end

xi.job_utils.blue_mage.useDiffusion = function(player, target, ability, action)
    player:addStatusEffect(xi.effect.DIFFUSION, 1, 0, 60)
    return xi.effect.DIFFUSION
end

xi.job_utils.blue_mage.useEfflux = function(player, target, ability, action)
    player:addStatusEffect(xi.effect.EFFLUX, 16, 1, 60)
end

xi.job_utils.blue_mage.useUnbridledWisdom = function(player, target, ability, action)
    target:addStatusEffect(xi.effect.UNBRIDLED_WISDOM, 16, 1, 30)
end

xi.job_utils.blue_mage.useUnbridledLearning = function(player, target, ability, action)
    target:addStatusEffect(xi.effect.UNBRIDLED_LEARNING, 16, 1, 60)
end

-- ══════════════════════════════════════════════════════════════
-- Solo Synergy — Blue Mage
-- ══════════════════════════════════════════════════════════════
-- Design fantasy: adaptive monster. Chain Affinity and Burst
-- Affinity deal more damage solo. Azure Lore is a burst window
-- with bonus proc chances. Efflux generates TP. Head Butt /
-- Disseverment stuns more reliably solo.
-- ══════════════════════════════════════════════════════════════
require('scripts/globals/solo_synergy')

do
    local ss   = xi.soloSynergy
    local _BLU = xi.job_utils.blue_mage

    -- Chain Affinity — solo: extended duration + momentum.
    local _ca = _BLU.useChainAffinity
    _BLU.useChainAffinity = function(player, target, ability, action)
        _ca(player, target, ability, action)
        if player:getPartySize() <= 2 then
            local eff = player:getStatusEffect(xi.effect.CHAIN_AFFINITY)
            if eff then eff:setDuration(eff:getDuration() + 15) end
            ss.addMomentum(player, 1)
            ss.flash(player, 'Solo Chain Affinity: +15s, momentum+1')
        end
    end

    -- Burst Affinity — solo: flag for spell hook to increase magic burst bonus.
    local _ba = _BLU.useBurstAffinity
    _BLU.useBurstAffinity = function(player, target, ability, action)
        _ba(player, target, ability, action)
        if player:getPartySize() <= 2 then
            player:setLocalVar('SS_BLU_BURST_SOLO', 1)
            ss.flash(player, 'Solo Burst Affinity: enhanced magic burst damage.')
        end
    end

    -- Azure Lore — solo: also temporarily increases all BLU spell damage.
    local _al = _BLU.useAzureLore
    _BLU.useAzureLore = function(player, target, ability, action)
        _al(player, target, ability, action)
        if player:getPartySize() <= 2 then
            player:addStatusEffect(xi.effect.INT_BOOST, math.floor(player:getMainLvl() / 5), 0, 30)
            ss.addMomentum(player, 2)
            ss.flash(player, 'Solo Azure Lore: INT burst + momentum+2')
        end
    end

    -- Efflux — solo: adds TP on top of the STR/attack boost.
    local _eff = _BLU.useEfflux
    _BLU.useEfflux = function(player, target, ability, action)
        _eff(player, target, ability, action)
        if player:getPartySize() <= 2 then
            local tp = math.random(200, 400)
            player:addTP(tp)
            ss.flash(player, string.format('Solo Efflux: TP+%d', tp))
        end
    end

    -- Diffusion — solo: auto-applies the strongest BLU buff to self.
    local _diff = _BLU.useDiffusion
    _BLU.useDiffusion = function(player, target, ability, action)
        _diff(player, target, ability, action)
        if player:getPartySize() <= 2 then
            -- Give self a Haste equivalent for solo blu "diffuse to self" feel
            player:addStatusEffect(xi.effect.HASTE, 10, 0, 60)
        end
    end
end
