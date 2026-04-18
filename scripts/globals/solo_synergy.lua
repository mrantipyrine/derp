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
        ss.flash(player, string.format('Momentum [%d/10] ~ building fast!', m))
    elseif m >= 4 then
        ss.flash(player, string.format('Momentum [%d/10]', m))
    end
end

-- Announce a non-retail buff gained from a JA. Yellow, short, informative.
-- Usage: ss.flashBuff(player, 'Aggressor', 'DA +15%  ATT +22')
ss.flashBuff = function(player, abilityName, buffSummary)
    if not player or not player:isPC() then return end
    local msg = string.format('[%s] %s', abilityName, buffSummary)
    player:printToPlayer(msg, xi.msg.channel.SYSTEM_3)
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
-- Magic Synergy System
-----------------------------------

local ELEMENT_PRIMER_VARS = {
    [xi.element.FIRE]    = 'SS_PRI_FIRE',
    [xi.element.ICE]     = 'SS_PRI_ICE',
    [xi.element.WIND]    = 'SS_PRI_WIND',
    [xi.element.EARTH]   = 'SS_PRI_EARTH',
    [xi.element.THUNDER] = 'SS_PRI_THUNDER',
    [xi.element.WATER]   = 'SS_PRI_WATER',
}

-- Returns a multiplier based on active primers on the target.
-- Certain elements "react" to others for double damage.
ss.getMagicComboMultiplier = function(caster, target, spell)
    if not target then return 1.0 end
    local element = spell:getElement()
    local multiplier = 1.0

    -- Combo Rules (Reacting Element -> Required Primer)
    local combos = {
        [xi.element.THUNDER] = xi.element.WATER,   -- Water + Thunder = Conductive Burst
        [xi.element.WIND]    = xi.element.FIRE,    -- Fire + Wind = Firestorm
        [xi.element.EARTH]   = xi.element.ICE,     -- Ice + Earth = Shatter
        [xi.element.WATER]   = xi.element.THUNDER, -- Thunder + Water = Electrolysis
        [xi.element.ICE]     = xi.element.WIND,    -- Wind + Ice = Blizzard
        [xi.element.FIRE]    = xi.element.EARTH,   -- Earth + Fire = Magma
    }

    local requiredPrimer = combos[element]
    if requiredPrimer then
        local varName = ELEMENT_PRIMER_VARS[requiredPrimer]
        if target:getLocalVar(varName) == 1 then
            multiplier = 2.0 -- Double damage!
            target:setLocalVar(varName, 0) -- Consume primer
            ss.flash(caster, 'ELEMENTAL COMBO! Double damage!')
        end
    end

    return multiplier
end

-- Applies elemental primers or secondary effects after damage lands.
ss.applyMagicSynergy = function(caster, target, spell, damage)
    if not target or not target:isAlive() then return end
    local element = spell:getElement()
    local lv      = caster:getMainLvl()
    local mainJob = caster:getMainJob()

    -- 1. Apply Job-Specific Perks (Globalized from your original logic)
    if mainJob == xi.job.BLM then
        -- 30% MP Refund
        if math.random(100) <= 30 then
            local mpCost = spell:getMPCost()
            ss.restoreMP(caster, mpCost)
            ss.flash(caster, 'Magic Mastery! MP refunded.')
        end

        -- Auto-Spikes for high-tier mages
        local spikes = {
            [xi.element.THUNDER] = xi.effect.SHOCK_SPIKES,
            [xi.element.ICE]     = xi.effect.ICE_SPIKES,
            [xi.element.FIRE]    = xi.effect.BLAZE_SPIKES,
        }
        if spikes[element] and not caster:hasStatusEffect(spikes[element]) then
            local power = math.floor(lv / 6) * 10
            caster:addStatusEffect(spikes[element], power, 3, 180)
        end
    end

    -- 2. Apply Elemental Primers (100% chance on damaging spells for solo/small groups)
    local primerVar = ELEMENT_PRIMER_VARS[element]
    if primerVar then
        target:setLocalVar(primerVar, 1)
        -- Primers expire after 15 seconds if not used
        target:timer(15000, function(t)
            t:setLocalVar(primerVar, 0)
        end)
    end

    -- 3. Element-Specific Identity Effects
    local baseChance = 20 + ss.getPartyPotencyBonus(caster)

    if element == xi.element.THUNDER then
        ss.tryParalyze(target, baseChance, lv)
    elseif element == xi.element.ICE then
        ss.tryProc(target, baseChance, xi.effect.WEIGHT, 30, 30) -- Frozen: weight/slow
    elseif element == xi.element.FIRE then
        -- Ignite: target takes more physical damage (handled via a temporary local var check in physical code later)
        target:setLocalVar('SS_IGNITED', 1)
        target:timer(15000, function(t) t:setLocalVar('SS_IGNITED', 0) end)
    elseif element == xi.element.WATER then
        -- Saturate: Recover MP based on damage
        local mpGain = math.max(1, math.floor(damage * 0.05))
        ss.restoreMP(caster, mpGain)
    elseif element == xi.element.LIGHT then
        -- Hallowed: Heal caster based on damage
        local hpGain = math.max(1, math.floor(damage * 0.10))
        ss.restoreHP(caster, hpGain)
    elseif element == xi.element.DARK then
        -- Corrupt: Drain TP
        local tpGain = math.random(10, 50)
        caster:addTP(tpGain)
    end
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
-- Reactive Synergy (JA <-> WS)
-----------------------------------

-- Called when an ability is used to "prime" the next weaponskill.
ss.onAbilityUse = function(player, target, ability)
    if not player or not player:isPC() then return end
    
    local abilityId = ability:getID()
    player:setLocalVar('SS_LAST_JA', abilityId)
    player:setLocalVar('SS_JA_PRIMER_TIME', os.time())
    
    -- 1. If "Flowing Spirit" is active from a big WS, try to double the JA effect
    -- (This works by adding extra mods if the JA is standard, or setting a flag for job_utils)
    if player:getLocalVar('SS_FLOW_ACTIVE') == 1 then
        player:setLocalVar('SS_FLOW_ACTIVE', 0)
        ss.flash(player, 'SPIRIT BURST! Ability power doubled.')
        -- We return 2.0 to tell the caller to double the power if it supports it
        return 2.0
    end

    -- 2. If in Surge state, give a massive boost to the primer
    if ss.isSurge(player) then
        player:setLocalVar('SS_SURGE_PRIMER', 1)
        ss.flash(player, 'SURGE! Next Weaponskill will be devastating.')
    end
    
    return 1.0
end

-- Called by weaponskills.lua to see if any JA bonus applies.
-- Returns a multiplier (1.0+) and a message.
ss.getWSAbilityBonus = function(player)
    local lastJa    = player:getLocalVar('SS_LAST_JA') or 0
    local primerTime = player:getLocalVar('SS_JA_PRIMER_TIME') or 0
    local isSurge   = player:getLocalVar('SS_SURGE_PRIMER') == 1
    
    -- Primers only last 20 seconds
    if os.time() - primerTime > 20 then
        return 1.0
    end
    
    local multiplier = 1.0
    
    -- Specific JA -> WS synergies
    -- (You can add any ability IDs here)
    if lastJa == 1 then -- Berserk
        multiplier = multiplier + 0.15 -- +15% damage
    elseif lastJa == 2 then -- Warcry
        multiplier = multiplier + 0.10 -- +10% damage
    elseif lastJa == 5 then -- Aggressor
        multiplier = multiplier + 0.05 -- +5% damage, but we'll assume it hits harder
    end
    
    -- Global Surge bonus (50% extra damage)
    if isSurge then
        multiplier = multiplier + 0.50
        player:setLocalVar('SS_SURGE_PRIMER', 0)
        ss.resetMomentum(player)
    end
    
    -- Clean up primer after use
    player:setLocalVar('SS_JA_PRIMER_TIME', 0)
    
    return multiplier
end

-- Called after a WS lands.
-- Big hits reduce JA recasts for solo/small groups.
ss.onWeaponskillHit = function(player, target, damage)
    if not player or not player:isPC() then return end
    if player:getPartySize() > 3 then return end
    
    -- Threshold for "Cooling Flow": hit for 20% of your own Max HP
    local threshold = player:getMaxHP() * 0.2
    if damage >= threshold then
        -- Reduce all JA recasts by 3-5 seconds
        -- Note: core usually handles recast reduction, but we can flash a message
        -- and use player:setLocalVar('SS_FLOW_ACTIVE', 1) for the next JA.
        player:setLocalVar('SS_FLOW_ACTIVE', 1)
        ss.flash(player, 'Flowing Spirit! Next Job Ability power doubled.')
    end
end

-- Called by weaponskills.lua to empower the player's pet.
-- Supports BST Jug Pets, PUP Automatons, and DRG Wyverns.
ss.empowerPet = function(master, damage)
    if not master or not master:isPC() then return end
    
    local pet = master:getPet()
    if not pet or not pet:isAlive() then return end
    
    local lv = master:getMainLvl()
    local mainJob = master:getMainJob()
    
    -- 1. Global Pet Bonus: +250 TP on Master WS
    pet:addTP(250)
    
    -- 2. Job-Specific Pet Empowerment
    if mainJob == xi.job.BST then
        -- Beastial Surge: Attack and Haste
        pet:addStatusEffect(xi.effect.ATTACK_BOOST, 20, 0, 15)
        pet:addStatusEffect(xi.effect.HASTE, 150, 0, 15)
        
        -- If master has Flowing Spirit active, reset a Ready charge (Recast ID 102)
        if master:getLocalVar('SS_FLOW_ACTIVE') == 1 then
            master:addRecast(xi.recast.ABILITY, 102, -10)
            ss.flash(master, 'BESTIAL FRENZY! Pet empowered, Ready charge up.')
        else
            ss.flash(master, 'Coordinated Assault! Pet TP +250.')
        end
        
    elseif mainJob == xi.job.DRG then
        -- Wyvern's Fury: Wyvern gains Attack and Accuracy boost
        pet:addStatusEffect(xi.effect.ATTACK_BOOST, 30, 0, 15)
        pet:addStatusEffect(xi.effect.ACCURACY_BOOST, 20, 0, 15)

        -- Wyvern's Breath: Wyvern heals the master for 5% of WS damage
        local heal = math.floor(damage * 0.05)
        if heal > 0 then
            ss.restoreHP(master, heal)
            ss.flash(master, string.format('Wyvern Bond! Attack up and healed for %d.', heal))
        end
        
    elseif mainJob == xi.job.PUP then
        -- Automaton Overdrive: Instantly remove 1 Burden from all elements
        -- Note: core often handles burden via setLocalVar or internal methods.
        -- We'll give the automaton a short Haste/Store TP boost instead.
        pet:addStatusEffect(xi.effect.HASTE, 200, 0, 20)
        pet:addStatusEffect(xi.effect.STORE_TP, 25, 0, 20)
        ss.flash(master, 'Clockwork Surge! Automaton Haste Up.')
    end
end

-- Called by Cure spells to grant a defensive shield.
ss.applyCureSynergy = function(caster, target, amount)
    if not caster or not caster:isPC() then return end
    if amount <= 0 then return end
    if caster:getPartySize() > 3 then return end

    -- Divine Shield: Short stoneskin based on cure amount
    local shieldPower = math.floor(amount * 0.20)
    if shieldPower > 0 then
        -- We use a local var to track the shield since overwriting core Stoneskin is risky
        local currentShield = target:getLocalVar('SS_DIVINE_SHIELD')
        target:setLocalVar('SS_DIVINE_SHIELD', math.max(currentShield, shieldPower))
        
        -- The shield expires in 15 seconds
        target:timer(15000, function(t)
            t:setLocalVar('SS_DIVINE_SHIELD', 0)
        end)
        
        ss.flash(caster, string.format('Divine Shield! +%d protective aura.', shieldPower))
    end
end

-- Handles non-damaging White Magic synergy (Bar-spells, etc)
ss.applyWhiteSynergy = function(caster, target, spell)
    if not caster or not caster:isPC() then return end
    local spellEffect = spell:getSpellGroup() -- We'll check the specific effect ID
    local element = spell:getElement()
    
    -- Bar-Element Synergy: Next physical hit deals bonus elemental damage
    if element >= xi.element.FIRE and element <= xi.element.WATER then
        -- Check if it's a bar-element spell
        local id = spell:getID()
        if id >= 60 and id <= 71 then -- Barfire to Barwatera
            target:setLocalVar('SS_BAR_ELEMENT', element)
            target:setLocalVar('SS_BAR_POWER', caster:getMainLvl())
            ss.flash(caster, 'Elemental Ward! Physical attacks infused.')
        end
    end
end

-- Returns bonus elemental damage if a Bar-spell primer is active.
ss.getElementalWardBonus = function(player)
    local element = player:getLocalVar('SS_BAR_ELEMENT')
    if element > 0 then
        local power = player:getLocalVar('SS_BAR_POWER') or 0
        -- Consumes on next WS for a big burst of elemental damage
        player:setLocalVar('SS_BAR_ELEMENT', 0)
        return element, math.floor(power * 2.5) -- Scaled bonus
    end
    return 0, 0
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
