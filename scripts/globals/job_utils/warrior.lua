-----------------------------------
-- Warrior Job Utilities
-----------------------------------
xi = xi or {}
xi.job_utils = xi.job_utils or {}
xi.job_utils.warrior = xi.job_utils.warrior or {}

-----------------------------------
-- Ability Check Functions
-----------------------------------
xi.job_utils.warrior.checkBrazenRush = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

xi.job_utils.warrior.checkMightyStrikes = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

xi.job_utils.warrior.checkTomahawk = function(player, target, ability)
    local ammoID = player:getEquipID(xi.slot.AMMO)

    if ammoID == xi.item.THROWING_TOMAHAWK then
        return 0, 0
    else
        return xi.msg.basic.CANNOT_PERFORM, 0
    end
end

-----------------------------------
-- Ability Use Functions
-----------------------------------
xi.job_utils.warrior.useAggressor = function(player, target, ability)
    local merits = player:getMerit(xi.merit.AGGRESSIVE_AIM)

    player:addStatusEffect(xi.effect.AGGRESSOR, merits, 0, 180 + player:getMod(xi.mod.AGGRESSOR_DURATION))
end

xi.job_utils.warrior.useBerserk = function(player, target, ability)
    player:addStatusEffect(xi.effect.BERSERK, 25 + player:getMod(xi.mod.BERSERK_POTENCY), 0, 180 + player:getMod(xi.mod.BERSERK_DURATION))
end

xi.job_utils.warrior.useBloodRage = function(player, target, ability)
    local power    = 20 + player:getJobPointLevel(xi.jp.BLOOD_RAGE_EFFECT)
    local duration = 30 + player:getMod(xi.mod.ENHANCES_BLOOD_RAGE)

    target:addStatusEffect(xi.effect.BLOOD_RAGE, power, 0, duration)

    if player:getID() ~= target:getID() then
        ability:setMsg(xi.msg.basic.JA_GAIN_EFFECT)
    end

    return xi.effect.BLOOD_RAGE
end

xi.job_utils.warrior.useBrazenRush = function(player, target, ability)
    player:addStatusEffect(xi.effect.BRAZEN_RUSH, 100, 3, 30)
end

xi.job_utils.warrior.useDefender = function(player, target, ability)
    player:addStatusEffect(xi.effect.DEFENDER, 1, 0, 180 + player:getMod(xi.mod.DEFENDER_DURATION))
end

xi.job_utils.warrior.useMightyStrikes = function(player, target, ability)
    player:addStatusEffect(xi.effect.MIGHTY_STRIKES, 1, 0, 45)
end

xi.job_utils.warrior.useRestraint = function(player, target, ability)
    player:addStatusEffect(xi.effect.RESTRAINT, 0, 0, 300)
end

xi.job_utils.warrior.useRetaliation = function(player, target, ability)
    player:addStatusEffect(xi.effect.RETALIATION, 1, 0, 180)
end

xi.job_utils.warrior.useTomahawk = function(player, target, ability)
    local merits   = player:getMerit(xi.merit.TOMAHAWK) - 15
    local duration = 30 + merits

    target:addStatusEffectEx(xi.effect.TOMAHAWK, 0, 25, 3, duration, 0, 0, 0)
    player:removeAmmo()
end

xi.job_utils.warrior.useWarcry = function(player, target, ability)
    local merit    = player:getMerit(xi.merit.SAVAGERY)
    local warLevel = utils.getActiveJobLevel(player, xi.job.WAR)
    local power    = (math.floor((warLevel / 4) + 4.75) / 256) * 100
    local duration = 30

    duration = duration + player:getMod(xi.mod.WARCRY_DURATION)

    target:addStatusEffect(xi.effect.WARCRY, power, 0, duration, 0, merit)

    if player:getID() ~= target:getID() then
        ability:setMsg(xi.msg.basic.JA_ATK_ENHANCED)
    end

    return xi.effect.WARCRY
end

xi.job_utils.warrior.useWarriorsCharge = function(player, target, ability)
    local merits = player:getMerit(xi.merit.WARRIORS_CHARGE)

    player:addStatusEffect(xi.effect.WARRIORS_CHARGE, merits - 5, 0, 60)
end

-- ══════════════════════════════════════════════════════════════
-- Solo Synergy — Warrior
-- ══════════════════════════════════════════════════════════════
-- Design fantasy: a rage-engine that builds toward Frenzy.
-- Berserk stacks charge up. Mighty Strikes/Warcry spend stacks
-- for bigger bursts. Works great solo and in small groups.
-- ══════════════════════════════════════════════════════════════
require('scripts/globals/solo_synergy')

do
    local ss = xi.soloSynergy
    local _WAR = xi.job_utils.warrior

    -- Berserk — each use stacks Rage (up to 5).
    -- At 5 stacks: Frenzy burst (Triple Attack + Crit Damage window).
    local _berserk = _WAR.useBerserk
    _WAR.useBerserk = function(player, target, ability)
        _berserk(player, target, ability)
        local rage = ss.addStacks(player, 'WAR_RAGE', 1, 5)
        local party = ss.getPartyPotencyBonus(player)
        -- Scale ATT extra bonus with rage stacks and party size
        local extra = math.floor(rage * 5 + party * 0.3)
        player:addMod(xi.mod.ATT, extra)
        if rage >= 5 then
            -- Frenzy: short window of guaranteed Triple Attack + crit power
            player:addStatusEffect(xi.effect.TRIPLE_ATTACK, 25, 0, 15)
            player:addStatusEffect(xi.effect.CRIT_DEF_BONUS, 20, 0, 15)
            ss.resetStacks(player, 'WAR_RAGE')
            ss.flash(player, 'FRENZY! Triple Attack burst (15s). Rage reset.')
        else
            ss.flash(player, string.format('Rage [%d/5] — ATK+%d', rage, extra))
        end
    end

    -- Aggressor — solo gives a flat ACC bonus on top of normal effect.
    local _aggressor = _WAR.useAggressor
    _WAR.useAggressor = function(player, target, ability)
        _aggressor(player, target, ability)
        if player:getPartySize() <= 2 then
            local bonus = math.floor(player:getMainLvl() / 3) + ss.getPartyPotencyBonus(player)
            player:addMod(xi.mod.ACC, bonus)
            ss.flash(player, string.format('Solo Aggressor: ACC+%d', bonus))
        end
    end

    -- Defender — while active solo, grants a small Regen.
    local _defender = _WAR.useDefender
    _WAR.useDefender = function(player, target, ability)
        _defender(player, target, ability)
        if player:getPartySize() <= 2 then
            local regen = math.floor(player:getMainLvl() / 12) + 2
            player:addStatusEffect(xi.effect.REGEN, regen, 3, 180)
            ss.flash(player, string.format('Solo Defender: Regen+%d', regen))
        end
    end

    -- Warcry — solo: momentum +2, boosted ATT bonus persists longer.
    local _warcry = _WAR.useWarcry
    _WAR.useWarcry = function(player, target, ability)
        _warcry(player, target, ability)
        if player:getPartySize() <= 2 then
            local m = ss.addMomentum(player, 2)
            ss.flashMomentum(player)
            if ss.isSurge(player) then
                ss.triggerSurge(player, {
                    { effect = xi.effect.MIGHTY_STRIKES, power = 1, duration = 10 },
                })
            end
        end
    end

    -- Mighty Strikes — spends all Rage stacks, each giving +3s duration.
    local _mighty = _WAR.useMightyStrikes
    _WAR.useMightyStrikes = function(player, target, ability)
        _mighty(player, target, ability)
        local rage  = ss.spendStacks(player, 'WAR_RAGE')
        local bonus = rage * 3
        if bonus > 0 then
            -- extend the Mighty Strikes effect
            local eff = player:getStatusEffect(xi.effect.MIGHTY_STRIKES)
            if eff then eff:setDuration(eff:getDuration() + bonus) end
            ss.flash(player, string.format('Rage consumed! Mighty Strikes +%ds', bonus))
        end
        ss.addMomentum(player, 3)
    end

    -- Retaliation — bloodbath bonus: more aggressive counter repost damage.
    local _retal = _WAR.useRetaliation
    _WAR.useRetaliation = function(player, target, ability)
        _retal(player, target, ability)
        if ss.isBloodbath(player) then
            player:addStatusEffect(xi.effect.COUNTER_BOOST, 15, 0, 180)
            ss.flash(player, 'Bloodbath! Counter damage surges.')
        end
    end
end
