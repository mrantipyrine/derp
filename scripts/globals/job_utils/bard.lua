-----------------------------------
-- Bard Job Utilities
-----------------------------------
xi = xi or {}
xi.job_utils = xi.job_utils or {}
xi.job_utils.bard = xi.job_utils.bard or {}

-----------------------------------
-- Ability Check Functions
-----------------------------------
xi.job_utils.bard.checkSoulVoice = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))

    return 0, 0
end

xi.job_utils.bard.checkClarionCall = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))

    return 0, 0
end

-----------------------------------
-- Ability Use Functions
-----------------------------------
xi.job_utils.bard.useSoulVoice = function(player, target, ability)
    player:addStatusEffect(xi.effect.SOUL_VOICE, 1, 0, 180)
end

xi.job_utils.bard.usePianissimo = function(player, target, ability)
    player:addStatusEffect(xi.effect.PIANISSIMO, 0, 0, 60)
end

xi.job_utils.bard.useNightingale = function(player, target, ability)
    player:addStatusEffect(xi.effect.NIGHTINGALE, 0, 0, 60)
end

xi.job_utils.bard.useTroubadour = function(player, target, ability)
    player:addStatusEffect(xi.effect.TROUBADOUR, 0, 0, 60)
end

xi.job_utils.bard.useTenuto = function(player, target, ability)
    -- TODO: Implement this ability
    player:addStatusEffect(xi.effect.TENUTO, 0, 0, 60)
end

xi.job_utils.bard.useMarcato = function(player, target, ability)
    player:addStatusEffect(xi.effect.MARCATO, 0, 0, 60)
end

xi.job_utils.bard.useClarionCall = function(player, target, ability)
    player:addStatusEffect(xi.effect.CLARION_CALL, 10, 0, 180)
end

-----------------------------------
-- Solo Synergy: Bard
-----------------------------------
do
    local ss  = xi.soloSynergy
    local BRD = xi.job_utils.bard

    -- Soul Voice: solo = also grants Regen + Refresh on self
    local _sv = BRD.useSoulVoice
    if _sv then
        BRD.useSoulVoice = function(player, target, ability, action)
            _sv(player, target, ability, action)
            if player:getPartySize() <= 2 then
                player:addStatusEffect(xi.effect.REGEN, ss.scaledPower(player, 3, 0.1), 3, 90)
                player:addStatusEffect(xi.effect.REFRESH, 2, 0, 90)
                ss.flash(player, 'Soul Voice: Regen+Refresh (solo bonus)\!')
            end
        end
    end

    -- Nightingale: solo = extend by 30s
    local _ng = BRD.useNightingale
    if _ng then
        BRD.useNightingale = function(player, target, ability, action)
            _ng(player, target, ability, action)
            if player:getPartySize() <= 2 then
                local eff = player:getStatusEffect(xi.effect.NIGHTINGALE)
                if eff then
                    eff:setDuration(eff:getDuration() + 30)
                end
            end
        end
    end

    -- Troubadour: solo = extend by 30s
    local _tr = BRD.useTroubadour
    if _tr then
        BRD.useTroubadour = function(player, target, ability, action)
            _tr(player, target, ability, action)
            if player:getPartySize() <= 2 then
                local eff = player:getStatusEffect(xi.effect.TROUBADOUR)
                if eff then
                    eff:setDuration(eff:getDuration() + 30)
                end
            end
        end
    end

    -- Marcato: solo = momentum+2 (songs hit harder, reward the solo bard)
    local _marc = BRD.useMarcato
    if _marc then
        BRD.useMarcato = function(player, target, ability, action)
            _marc(player, target, ability, action)
            if player:getPartySize() <= 2 then
                ss.addMomentum(player, 2)
                ss.flashMomentum(player)
            end
        end
    end

    -- Clarion Call: solo = extend duration by 30s
    local _cc = BRD.useClarionCall
    if _cc then
        BRD.useClarionCall = function(player, target, ability, action)
            _cc(player, target, ability, action)
            if player:getPartySize() <= 2 then
                local eff = player:getStatusEffect(xi.effect.CLARION_CALL)
                if eff then
                    eff:setDuration(eff:getDuration() + 30)
                end
            end
        end
    end

    -- Pianissimo: solo = momentum+1 (self-songs still count\!)
    local _pian = BRD.usePianissimo
    if _pian then
        BRD.usePianissimo = function(player, target, ability, action)
            _pian(player, target, ability, action)
            if player:getPartySize() <= 2 then
                ss.addMomentum(player, 1)
            end
        end
    end
end
