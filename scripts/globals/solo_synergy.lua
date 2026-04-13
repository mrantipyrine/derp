-----------------------------------
-- Solo Synergy System
-- scripts/globals/solo_synergy.lua
-----------------------------------
-- A runtime engine that makes solo and small-party play feel great
-- at every level range, from Ronfaure to end-game.
--
-- Systems provided:
--   Party Bonus      — fewer players = stronger abilities / spells
--   Bloodbath        — low HP triggers damage/proc bonuses
--   Momentum         — kill streaks build stacks, stacks fuel bursts
--   Proc Engine      — standard helper for status-effect procs
--   Day/Weather      — element bonuses that stack (not override)
--   Combo Window     — WS chains reward follow-up WSs
--   Feedback         — concise in-chat ">[system]" messages
--
-- How to use in job_utils or individual script files:
--   require('scripts/globals/solo_synergy')
--   local ss = xi.soloSynergy
--   local bonus = ss.getPartyBonus(player)
--   ss.tryProc(target, 20, xi.effect.PARALYSIS, 10, 30)
--   ss.flash(player, 'Momentum surge!')
-----------------------------------

xi = xi or {}
xi.soloSynergy = xi.soloSynergy or {}

local ss = xi.soloSynergy

-----------------------------------
-- Constants
-----------------------------------
local MAX_MOMENTUM   = 10
local COMBO_WINDOW   = 10    -- seconds
local MSG_CHANNEL    = xi.msg.channel.SYSTEM_3

-----------------------------------
-- Party Size Bonus
-- Returns a damage/effect multiplier based on party size.
-- Solo play gets the biggest boost to compensate for no support.
-----------------------------------
ss.getPartyBonus = function(player)
    local size = player:getPartySize()
    if     size <= 1 then return 1.40   -- solo:  +40%
    elseif size == 2 then return 1.20   -- duo:   +20%
    elseif size == 3 then return 1.10   -- trio:  +10%
    else                  return 1.00   -- 4+:    standard
    end
end

-- Returns an additive potency bonus (0–40) for status effects / heals.
ss.getPartyPotencyBonus = function(player)
    local size = player:getPartySize()
    if     size <= 1 then return 40
    elseif size == 2 then return 20
    elseif size == 3 then return 10
    else                  return 0
    end
end

-----------------------------------
-- Bloodbath — low HP fuels power
-- Returns a damage multiplier (1.0 – 1.35) based on HP%.
-----------------------------------
ss.getBloodbathMult = function(player)
    local pct = player:getHP() / math.max(1, player:getMaxHP())
    if     pct <= 0.25 then return 1.35   -- danger zone: +35%
    elseif pct <= 0.50 then return 1.20   -- wounded:     +20%
    elseif pct <= 0.75 then return 1.10   -- hurt:        +10%
    else                    return 1.00
    end
end

-- True if the player is in bloodbath state (≤50% HP).
ss.isBloodbath = function(player)
    return (player:getHP() / math.max(1, player:getMaxHP())) <= 0.50
end

-----------------------------------
-- Momentum — kill-streak stacks
-- Stored as a player local variable SS_MOMENTUM (0–10).
-- Use addMomentum() on kill, getMomentum() to query.
-- Stack bonuses: each stack = +2% damage, proc chance, etc.
-- At MAX_MOMENTUM (10): "Surge" state (bigger burst).
-----------------------------------
ss.getMomentum = function(player)
    return player:getLocalVar('SS_MOMENTUM') or 0
end

ss.addMomentum = function(player, amount)
    local cur = ss.getMomentum(player)
    local new = math.min(cur + (amount or 1), MAX_MOMENTUM)
    player:setLocalVar('SS_MOMENTUM', new)
    return new
end

ss.spendMomentum = function(player, amount)
    local cur = ss.getMomentum(player)
    local spent = math.min(cur, amount or cur)
    player:setLocalVar('SS_MOMENTUM', cur - spent)
    return spent
end

ss.resetMomentum = function(player)
    player:setLocalVar('SS_MOMENTUM', 0)
end

-- Returns the multiplier granted by current momentum (1.0 – 1.20).
ss.getMomentumMult = function(player)
    return 1.0 + (ss.getMomentum(player) * 0.02)
end

-- Returns true if player is in Surge state (max momentum).
ss.isSurge = function(player)
    return ss.getMomentum(player) >= MAX_MOMENTUM
end

-----------------------------------
-- Feedback — short chat messages
-----------------------------------
ss.flash = function(player, msg)
    if player and player:isPC() then
        player:printToPlayer('>' .. msg, MSG_CHANNEL)
    end
end

ss.flashMomentum = function(player)
    local m = ss.getMomentum(player)
    if m >= MAX_MOMENTUM then
        ss.flash(player, 'SURGE! [10/10] Maximum momentum!')
    elseif m >= 7 then
        ss.flash(player, string.format('Momentum [%d/10] — building fast!', m))
    elseif m >= 4 then
        ss.flash(player, string.format('Momentum [%d/10]', m))
    end
end

-----------------------------------
-- Proc Engine
-- Rolls a chance to apply a status effect to the target.
-- Returns true if proc fired.
-----------------------------------
ss.tryProc = function(target, chance, effect, power, duration, tick)
    if not target or not target:isAlive() then return false end
    if math.random(100) <= chance then
        target:addStatusEffect(effect, power or 10, tick or 0, duration or 30)
        return true
    end
    return false
end

-- Convenience procs for common elements.
ss.tryParalyze = function(target, chance, level)
    return ss.tryProc(target, chance, xi.effect.PARALYSIS, math.floor((level or 30) / 5) + 5, 30)
end

ss.tryBlind = function(target, chance, level)
    return ss.tryProc(target, chance, xi.effect.BLINDNESS, math.floor((level or 30) / 4) + 8, 30)
end

ss.trySlow = function(target, chance, level)
    return ss.tryProc(target, chance, xi.effect.SLOW, math.floor((level or 30) / 3) + 10, 45)
end

ss.tryStun = function(target, chance)
    return ss.tryProc(target, chance, xi.effect.STUN, 1, 5)
end

ss.tryPoison = function(target, chance, level)
    local dmg = math.floor((level or 30) / 10) + 3
    return ss.tryProc(target, chance, xi.effect.POISON, dmg, 60, 3)
end

-----------------------------------
-- Day / Weather element bonus
-- Returns a multiplier that STACKS with existing damage
-- (additive: returned value multiplied against result).
-----------------------------------
local ELEMENT_DAYS = {
    [xi.element.FIRE]      = xi.day.FIRESDAY,
    [xi.element.ICE]       = xi.day.ICEDAY,
    [xi.element.WIND]      = xi.day.WINDSDAY,
    [xi.element.EARTH]     = xi.day.EARTHSDAY,
    [xi.element.THUNDER]   = xi.day.LIGHTNINGSDAY,
    [xi.element.WATER]     = xi.day.WATERSDAY,
    [xi.element.LIGHT]     = xi.day.LIGHTSDAY,
    [xi.element.DARK]      = xi.day.DARKSDAY,
}

ss.getElementDayBonus = function(element)
    local today = VanadielDayOfTheWeek()
    if ELEMENT_DAYS[element] == today then
        return 1.25   -- matching day: +25% (stacks, not override)
    end
    return 1.0
end

-- Opposite element on its day gives a small penalty (5% only, not severe).
ss.getElementDayPenalty = function(element)
    -- Not currently used — reserved for future "hard mode" toggle
    return 1.0
end

-----------------------------------
-- Combo Window — WS chains
-- After a WS, a 10s window opens for a follow-up bonus.
-- Compatible WSs (same or adjacent element) get +30% damage.
-----------------------------------
ss.openComboWindow = function(player, wsElement)
    player:setLocalVar('SS_COMBO_ELEMENT', wsElement or 0)
    player:setLocalVar('SS_COMBO_TIME',    os.time())
end

ss.getComboBonus = function(player, wsElement)
    local t    = player:getLocalVar('SS_COMBO_TIME') or 0
    local elem = player:getLocalVar('SS_COMBO_ELEMENT') or 0
    if os.time() - t <= COMBO_WINDOW and elem > 0 then
        -- Same element: +30%. Different element: +15% (SC potential).
        if elem == (wsElement or 0) then
            return 1.30
        else
            return 1.15
        end
    end
    return 1.0
end

ss.closeComboWindow = function(player)
    player:setLocalVar('SS_COMBO_TIME', 0)
end

-----------------------------------
-- Stack helper — per-player named counters
-- Used by Boost stacks, Berserk rage, etc.
-----------------------------------
ss.getStacks = function(player, key)
    return player:getLocalVar('SS_STK_' .. key) or 0
end

ss.addStacks = function(player, key, amount, max)
    local cur = ss.getStacks(player, key)
    local new = math.min(cur + (amount or 1), max or 5)
    player:setLocalVar('SS_STK_' .. key, new)
    return new
end

ss.spendStacks = function(player, key, amount)
    local cur = ss.getStacks(player, key)
    local spent = math.min(cur, amount or cur)
    player:setLocalVar('SS_STK_' .. key, cur - spent)
    return spent
end

ss.resetStacks = function(player, key)
    player:setLocalVar('SS_STK_' .. key, 0)
end

-----------------------------------
-- HP Restore helper — safe setHP wrapper.
-----------------------------------
ss.restoreHP = function(player, amount)
    if amount <= 0 then return end
    player:setHP(math.min(player:getHP() + amount, player:getMaxHP()))
end

ss.restoreHPPct = function(player, pct)
    local lost = player:getMaxHP() - player:getHP()
    ss.restoreHP(player, math.floor(lost * pct))
end

ss.restoreMP = function(player, amount)
    if amount <= 0 then return end
    player:setMP(math.min(player:getMP() + amount, player:getMaxMP()))
end

ss.restoreMPPct = function(player, pct)
    local lost = player:getMaxMP() - player:getMP()
    ss.restoreMP(player, math.floor(lost * pct))
end

-----------------------------------
-- Level-scaled helpers
-----------------------------------
-- Returns a power value appropriate for the player's level.
-- Useful for proc potency, heal amounts, status effect power.
ss.scaledPower = function(player, base, perLevel)
    return math.floor(base + (player:getMainLvl() * (perLevel or 0.5)))
end

-- Returns the combined solo bonus (party + bloodbath + momentum).
-- Used when a single multiplier is needed for a skill/spell.
ss.getCombinedMult = function(player)
    return ss.getPartyBonus(player)
         * ss.getBloodbathMult(player)
         * ss.getMomentumMult(player)
end

-----------------------------------
-- On-kill hook — call from onMobDeath if wired up, or from WS handlers.
-- Increments momentum, opens a short combo window.
-----------------------------------
ss.onKill = function(player, mob)
    if not player or not player:isPC() then return end
    local new = ss.addMomentum(player, 1)
    ss.flashMomentum(player)
    -- Small TP trickle on kills for solo sustain
    if player:getPartySize() <= 2 then
        player:addTP(math.random(50, 150))
    end
end

-----------------------------------
-- Surge burst helper — used by abilities when momentum is maxed.
-- Fires a burst of effects and resets momentum to half.
-----------------------------------
ss.triggerSurge = function(player, surgeEffects)
    ss.flash(player, 'SURGE TRIGGERED! Momentum resets to 5.')
    ss.resetMomentum(player)
    ss.addMomentum(player, 5)  -- half back immediately
    -- Apply any passed surge effects
    if surgeEffects then
        for _, e in ipairs(surgeEffects) do
            player:addStatusEffect(e.effect, e.power or 10, 0, e.duration or 30)
        end
    end
end

-----------------------------------
-- Sub-job synergy table
-- Returns a list of stat/effect bonuses for specific sub-job combos.
-- Called by abilities that want to check sub-job interactions.
-----------------------------------
ss.getSubJobBonus = function(player, subJob)
    local lv  = player:getMainLvl()
    local mod = math.floor(lv / 10)
    local bonuses = {
        [xi.job.WAR] = { { effect = xi.effect.WARCRY,    power = mod * 2, duration = 30 } },
        [xi.job.MNK] = { { effect = xi.effect.STR_BOOST, power = mod,     duration = 60 } },
        [xi.job.THF] = { { effect = xi.effect.DEX_BOOST, power = mod,     duration = 60 } },
        [xi.job.RDM] = { { effect = xi.effect.REFRESH,   power = 2,       duration = 90 } },
        [xi.job.WHM] = { { effect = xi.effect.REGEN,     power = mod,     duration = 60 } },
        [xi.job.BLM] = { { effect = xi.effect.INT_BOOST, power = mod,     duration = 60 } },
        [xi.job.NIN] = { { effect = xi.effect.HASTE,     power = 10,      duration = 45 } },
        [xi.job.DRG] = { { effect = xi.effect.VIT_BOOST, power = mod,     duration = 60 } },
        [xi.job.DRK] = { { effect = xi.effect.ATT_BOOST, power = mod * 3, duration = 30 } },
        [xi.job.PLD] = { { effect = xi.effect.DEF_BONUS, power = mod * 2, duration = 45 } },
        [xi.job.SAM] = { { effect = xi.effect.REGAIN,    power = 10,      duration = 60 } },
        [xi.job.BRD] = { { effect = xi.effect.MND_BOOST, power = mod,     duration = 60 } },
        [xi.job.COR] = { { effect = xi.effect.LUCK,      power = 10,      duration = 60 } },
        [xi.job.DNC] = { { effect = xi.effect.AGI_BOOST, power = mod,     duration = 60 } },
    }
    return bonuses[subJob] or {}
end

ss.applySubJobBonus = function(player)
    local sub = player:getSubJob()
    for _, b in ipairs(ss.getSubJobBonus(player, sub)) do
        player:addStatusEffect(b.effect, b.power, 0, b.duration)
    end
end

print('[SoloSynergy] Loaded.')
