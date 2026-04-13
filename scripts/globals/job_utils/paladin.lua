-----------------------------------
-- Paladin Job Utilities
-----------------------------------
xi = xi or {}
xi.job_utils = xi.job_utils or {}
xi.job_utils.paladin = xi.job_utils.paladin or {}

-----------------------------------
-- Ability Check Functions
-----------------------------------
xi.job_utils.paladin.checkCover = function(player, target, ability)
    if
        target == nil or
        target:getID() == player:getID() or
        not target:isPC()
    then
        return xi.msg.basic.CANNOT_PERFORM_TARG, 0
    else
        return 0, 0
    end
end

xi.job_utils.paladin.checkIntervene = function(player, target, ability)
    if player:getShieldSize() == 0 then
        return xi.msg.basic.REQUIRES_SHIELD, 0
    else
        ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))

        return 0, 0
    end
end

xi.job_utils.paladin.checkInvincible = function(player, target, ability)
    local jpValue = player:getJobPointLevel(xi.jp.INVINCIBLE_EFFECT)

    ability:setVE(ability:getVE() + 100 * jpValue)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))

    return 0, 0
end

xi.job_utils.paladin.checkSepulcher = function(player, target, ability)
    if target:isUndead() then
        return 0, 0
    else
        return xi.msg.basic.CANNOT_ON_THAT_TARG, 0
    end
end

xi.job_utils.paladin.checkShieldBash = function(player, target, ability)
    if player:getShieldSize() == 0 then
        return xi.msg.basic.REQUIRES_SHIELD, 0
    else
        return 0, 0
    end
end

-----------------------------------
-- Ability Use Functions
-----------------------------------
xi.job_utils.paladin.useChivalry = function(player, target, ability)
    local merits = player:getMerit(xi.merit.CHIVALRY) - 5
    local tp     = target:getTP()
    local base   = 0.05 + (player:getMod(xi.mod.ENHANCES_CHIVALRY) / 100)
    -- MP gained = (TP * 0.05) + (0.0015 * TP * MND) * Merits
    local amount = (tp * base) + (0.0015 * tp * target:getStat(xi.mod.MND)) * ((100 + merits) / 100)

    target:setTP(0)

    return target:addMP(amount)
end

xi.job_utils.paladin.useCover = function(player, target, ability)
    local baseDuration = 15
    local bonusTime    = utils.clamp(math.floor((player:getStat(xi.mod.VIT) + player:getStat(xi.mod.MND) - target:getStat(xi.mod.VIT) * 2) / 4), 0, 15)
    local jpValue      = player:getJobPointLevel(xi.jp.COVER_DURATION)
    local duration     = baseDuration + bonusTime + player:getMerit(xi.merit.COVER_EFFECT_LENGTH) + player:getMod(xi.mod.COVER_DURATION) + jpValue

    player:addStatusEffect(xi.effect.COVER, player:getMod(xi.mod.COVER_TO_MP), 0, duration)
    player:setLocalVar('COVER_ABILITY_TARGET', target:getID())
    ability:setMsg(xi.msg.basic.COVER_SUCCESS)
end

xi.job_utils.paladin.useDivineEmblem = function(player, target, ability)
    -- Divine Magic bonus damage handled in globals/magic.lua
    local power = 50 + player:getMod(xi.mod.ENHANCES_DIVINE_EMBLEM) -- 50% increase to enmity

    player:addStatusEffect(xi.effect.DIVINE_EMBLEM, power, 0, 60)
end

xi.job_utils.paladin.useFealty = function(player, target, ability)
    local merits    = player:getMerit(xi.merit.FEALTY) - 5
    local enhFealty = (player:getMerit(xi.merit.FEALTY) / 5) * player:getMod(xi.mod.ENHANCES_FEALTY)
    local duration  = 60 + merits + enhFealty

    player:addStatusEffect(xi.effect.FEALTY, 1, 0, duration)
end

xi.job_utils.paladin.useHolyCircle = function(player, target, ability)
    -- TODO:
    -- Create Bonus vs Ecosystem handling
    -- https://www.bg-wiki.com/ffxi/Holy_Circle
    -- Main (PLD) job gives a unique 15% damage bonus against undead, 15% damage resistance from undead, and likely +15% Undead Killer.
    -- When subbed, gives 5% of these bonuses.
    local duration = 180 + player:getMod(xi.mod.HOLY_CIRCLE_DURATION)
    local power    = 15

    if player:getMainJob() ~= xi.job.PLD then
        power = 5
    end

    power = power + player:getMod(xi.mod.HOLY_CIRCLE_POTENCY)

    target:addStatusEffect(xi.effect.HOLY_CIRCLE, power, 0, duration)
end

xi.job_utils.paladin.useIntervene = function(player, target, ability)
    -- TODO: Retail testing to determine damage
    local shieldSize = player:getShieldSize()
    local jpValue    = 1 + (player:getJobPointLevel(xi.jp.INTERVENE_EFFECT) / 100)
    local damage     = math.floor(player:getMainLvl() * 3.36)

    if shieldSize == 2 then
        damage = 13 + damage
    elseif shieldSize == 3 then
        damage = 40 + damage
    elseif shieldSize == 4 then
        damage = 67 + damage
    end

    damage = damage * jpValue

    target:addStatusEffect(xi.effect.INTERVENE, 1, 0, 30)

    return damage
end

xi.job_utils.paladin.useInvincible = function(player, target, ability)
    player:addStatusEffect(xi.effect.INVINCIBLE, 1, 0, 30)
end

xi.job_utils.paladin.useMajesty = function(player, target, ability)
    player:addStatusEffect(xi.effect.MAJESTY, 25, 0, 180)
end

xi.job_utils.paladin.usePalisade = function(player, target, ability)
    local jpValue = player:getJobPointLevel(xi.jp.PALISADE_EFFECT)
    local power   = 30 + jpValue

    player:addStatusEffect(xi.effect.PALISADE, power, 0, 60)
end

xi.job_utils.paladin.useRampart = function(player, target, ability)
    local duration = 30 + player:getMod(xi.mod.RAMPART_DURATION)

    target:addStatusEffect(xi.effect.RAMPART, 2500, 0, duration)
end

xi.job_utils.paladin.useSentinel = function(player, target, ability)
    -- Whether feet have to be equipped before using ability, or if they can be swapped in
    -- is disputed.  Source used: http://wiki.bluegartr.com/bg/Sentinel
    local power       = (90 + player:getMod(xi.mod.SENTINEL_EFFECT)) * 100
    local guardian    = player:getMerit(xi.merit.GUARDIAN)
    local enhGuardian = player:getMod(xi.mod.ENHANCES_GUARDIAN) * (guardian / 19)
    local jpValue     = player:getJobPointLevel(xi.jp.SENTINEL_EFFECT)
    local duration    = 30 + enhGuardian

    -- Sent as positive power because UINTs, man.
    player:addStatusEffect(xi.effect.SENTINEL, power, 3, duration, 0, guardian + jpValue)
end

xi.job_utils.paladin.useSepulcher = function(player, target, ability)
    local power    = 20
    local jpValue  = player:getJobPointLevel(xi.jp.SEPULCHER_DURATION)
    local duration = 180 + jpValue

    target:addStatusEffect(xi.effect.SEPULCHER, power, 0, duration)
end

xi.job_utils.paladin.useShieldBash = function(player, target, ability)
    local shieldSize = player:getShieldSize()
    local jpValue    = player:getJobPointLevel(xi.jp.SHIELD_BASH_EFFECT)
    local damage     = math.floor(player:getMainLvl() * 0.273)
    local chance     = 90

    if shieldSize == 2 then
        damage = 13 + damage
    elseif shieldSize == 3 then
        damage = 40 + damage
    elseif shieldSize == 4 then
        damage = 67 + damage
    end

    -- Main job factors
    if player:getMainJob() ~= xi.job.PLD then
        damage = math.floor(damage / 2.5)
        chance = 60
    else
        damage = math.floor(damage)
    end

    damage = damage + player:getMod(xi.mod.SHIELD_BASH) + (jpValue * 10)

    -- Calculate stun proc chance
    chance = chance + (player:getMainLvl() - target:getMainLvl()) * 5

    if math.random(1, 100) <= chance then
        target:addStatusEffect(xi.effect.STUN, 1, 0, 6)
    end

    -- Randomize damage
    local randomizer = 1 + (math.random(1, 5) / 100)

    damage = damage * randomizer
    damage = utils.stoneskin(target, damage)

    target:takeDamage(damage, player, xi.attackType.PHYSICAL, xi.damageType.BLUNT)
    target:updateEnmityFromDamage(player, damage)
    ability:setMsg(xi.msg.basic.JA_DAMAGE)

    return damage
end

-- ══════════════════════════════════════════════════════════════
-- Solo Synergy — Paladin
-- ══════════════════════════════════════════════════════════════
-- Design fantasy: immovable guardian. Sentinel and Rampart
-- make solo tanking feel powerful. Invincible lasts longer.
-- Cover fortifies self when there's no one to protect.
-- Chivalry returns MP based on damage absorbed.
-- ══════════════════════════════════════════════════════════════
require('scripts/globals/solo_synergy')

do
    local ss   = xi.soloSynergy
    local _PLD = xi.job_utils.paladin

    -- Sentinel — solo: extended duration + Regen during the shield window.
    local _sent = _PLD.useSentinel
    if _sent then
        _PLD.useSentinel = function(player, target, ability)
            _sent(player, target, ability)
            if player:getPartySize() <= 2 then
                local regenPow = math.floor(player:getMainLvl() / 8) + 4
                player:addStatusEffect(xi.effect.REGEN, regenPow, 3, 30)
                -- Extend Sentinel by 15s for solo
                local eff = player:getStatusEffect(xi.effect.SENTINEL)
                if eff then eff:setDuration(eff:getDuration() + 15) end
                ss.flash(player, string.format('Solo Sentinel: +15s, Regen+%d', regenPow))
            end
        end
    end

    -- Invincible — solo: lasts 10s longer.
    local _inv = _PLD.useInvincible
    if _inv then
        _PLD.useInvincible = function(player, target, ability)
            _inv(player, target, ability)
            if player:getPartySize() <= 2 then
                local eff = player:getStatusEffect(xi.effect.INVINCIBLE)
                if eff then eff:setDuration(eff:getDuration() + 10) end
                ss.flash(player, 'Solo Invincible: +10s')
            end
        end
    end

    -- Cover — when solo (no ally to cover), grants a short DEF surge to self.
    local _cover = _PLD.useCover
    if _cover then
        _PLD.useCover = function(player, target, ability)
            _cover(player, target, ability)
            if player:getPartySize() <= 1 then
                local defBonus = math.floor(player:getMainLvl() / 4) + 15
                player:addStatusEffect(xi.effect.DEF_BONUS, defBonus, 0, 15)
                ss.flash(player, string.format('Solo Cover: self-fortify DEF+%d (15s)', defBonus))
            end
        end
    end

    -- Shield Bash — solo: also applies an ACC debuff to target.
    local _sb = _PLD.useShieldBash
    if _sb then
        _PLD.useShieldBash = function(player, target, ability)
            _sb(player, target, ability)
            if player:getPartySize() <= 2 and target and target:isMob() then
                target:addStatusEffect(xi.effect.ACCURACY_DOWN, 20, 0, 20)
                ss.flash(player, 'Solo Shield Bash: ACC Down on target.')
            end
        end
    end

    -- Chivalry — solo: scales MP return with how hurt you are (bloodbath synergy).
    local _chiv = _PLD.useChivalry
    if _chiv then
        _PLD.useChivalry = function(player, target, ability)
            _chiv(player, target, ability)
            if player:getPartySize() <= 2 then
                local bloodMult = ss.getBloodbathMult(player)
                local mpBonus   = math.floor(player:getMaxMP() * 0.05 * bloodMult)
                ss.restoreMP(player, mpBonus)
                ss.flash(player, string.format('Solo Chivalry: MP+%d (bloodbath x%.1f)', mpBonus, bloodMult))
            end
        end
    end

    -- Holy Circle — solo: also grants a short ATK bonus vs undead (divine wrath).
    local _hc = _PLD.useHolyCircle
    if _hc then
        _PLD.useHolyCircle = function(player, target, ability)
            _hc(player, target, ability)
            if player:getPartySize() <= 2 then
                player:addStatusEffect(xi.effect.ATT_BOOST, 15, 0, 180)
            end
        end
    end

    -- Rampart — add momentum on use (fortifying the line).
    local _ramp = _PLD.useRampart
    if _ramp then
        _PLD.useRampart = function(player, target, ability)
            _ramp(player, target, ability)
            ss.addMomentum(player, 1)
        end
    end
end
