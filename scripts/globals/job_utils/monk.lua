-----------------------------------
-- Monk Job Utilities
-----------------------------------
xi = xi or {}
xi.job_utils = xi.job_utils or {}
xi.job_utils.monk = xi.job_utils.monk or {}

local chakraStatusEffects =
{
    POISON       = 0, -- Removed by default
    BLINDNESS    = 0, -- Removed by default
    PARALYSIS    = 1,
    DISEASE      = 2,
    PLAGUE       = 4,
}

-----------------------------------
-- Ability Check Functions
-----------------------------------
xi.job_utils.monk.checkHundredFists = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

xi.job_utils.monk.checkInnerStrength = function(player, target, ability)
    ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
    return 0, 0
end

-----------------------------------
-- Ability Use Functions
-----------------------------------
xi.job_utils.monk.useBoost = function(player, target, ability)
    local power = 12.5 + (0.10 * player:getMod(xi.mod.BOOST_EFFECT))

    if player:hasStatusEffect(xi.effect.BOOST) then
        local effect = player:getStatusEffect(xi.effect.BOOST)
        effect:setPower(effect:getPower() + power)
        player:addMod(xi.mod.ATTP, power)
    else
        player:addStatusEffect(xi.effect.BOOST, power, 0, 180)
    end
end

-- TODO: add Melee Gloves +2 aug
xi.job_utils.monk.useChakra = function(player, target, ability)
    local chakraRemoval = player:getMod(xi.mod.CHAKRA_REMOVAL)

    for k, v in pairs(chakraStatusEffects) do
        if bit.band(chakraRemoval, v) == v then
            player:delStatusEffect(xi.effect[k])
        end
    end

    -- see https://www.bg-wiki.com/ffxi/Chakra
    local monkLevel         = utils.getActiveJobLevel(player, xi.job.MNK)
    local jpModifier        = target:getJobPointLevel(xi.jp.CHAKRA_EFFECT) -- NOTE: Level is the modified value, so 10 per point spent
    local hpModifier        = ((monkLevel + 1) * 0.2 / 100) * player:getMaxHP()
    local chakraMultiplier  = 1 + player:getMod(xi.mod.CHAKRA_MULT) / 100
    local maxRecoveryAmount = (player:getStat(xi.mod.VIT) * 2 + hpModifier) * chakraMultiplier + jpModifier
    local recoveryAmount    = math.min(player:getMaxHP() - player:getHP(), maxRecoveryAmount)

    player:setHP(player:getHP() + recoveryAmount)

    local merits = player:getMerit(xi.merit.INVIGORATE)
    if merits > 0 then
        if player:hasStatusEffect(xi.effect.REGEN) then
            player:delStatusEffect(xi.effect.REGEN)
        end

        player:addStatusEffect(xi.effect.REGEN, 10, 0, merits, 0, 0, 1)
    end

    return recoveryAmount
end

xi.job_utils.monk.useChiBlast = function(player, target, ability)
    local boost = player:getStatusEffect(xi.effect.BOOST)
    local multiplier = 1.0
    if boost ~= nil then
        multiplier = (boost:getPower() / 100) * 4 -- power is the raw % atk boost
    end

    local dmg = math.floor(player:getStat(xi.mod.MND) * (0.5 + (math.random() / 2))) * multiplier

    dmg = xi.ability.adjustDamage(dmg, player, ability, target, xi.attackType.BREATH, nil, xi.mobskills.shadowBehavior.IGNORE_SHADOWS)
    target:takeDamage(dmg, player, xi.attackType.BREATH, xi.damageType.ELEMENTAL)
    target:updateClaim(player)
    player:delStatusEffect(xi.effect.BOOST)

    return dmg
end

xi.job_utils.monk.useCounterstance = function(player, target, ability)
    local power = 45 + player:getMod(xi.mod.COUNTERSTANCE_EFFECT)

    target:delStatusEffect(xi.effect.COUNTERSTANCE) --if not found this will do nothing
    target:addStatusEffect(xi.effect.COUNTERSTANCE, power, 0, 300)
end

xi.job_utils.monk.useDodge = function(player, target, ability)
    player:addStatusEffect(xi.effect.DODGE, 0, 0, 30)
end

xi.job_utils.monk.useFocus = function(player, target, ability)
    player:addStatusEffect(xi.effect.FOCUS, 0, 0, 30)
end

xi.job_utils.monk.useFootwork = function(player, target, ability)
    local kickDmg = 20 + player:getWeaponDmg()
    local kickAttPercent = 25 + player:getMod(xi.mod.FOOTWORK_ATT_BONUS)

    player:addStatusEffect(xi.effect.FOOTWORK, kickDmg, 0, 60, 0, kickAttPercent)
end

xi.job_utils.monk.useFormlessStrikes = function(player, target, ability)
    player:addStatusEffect(xi.effect.FORMLESS_STRIKES, 1, 0, 180)
end

xi.job_utils.monk.useHundredFists = function(player, target, ability)
    player:addStatusEffect(xi.effect.HUNDRED_FISTS, 1, 0, 45)
end

-- TODO: Support Tantra Cyclas + 1 (does not give critical hit damage)
-- Probably will be exceptionally jank, very low priority
xi.job_utils.monk.impetusMissListener = function(attacker, victim, attack)
    local effect = attacker:getStatusEffect(xi.effect.IMPETUS)

    if effect then
        local mainPower = effect:getPower()    -- Stores Attack & Critical Hit Rate bonuses
        local subPower  = effect:getSubPower() -- Stores Critical Hit Damage & Accuracy bonuses

        if mainPower > 0 then
            attacker:delMod(xi.mod.ATT, mainPower * 2)
            attacker:delMod(xi.mod.CRITHITRATE, mainPower)

            effect:setPower(0)
        end

        if subPower > 0 then
            attacker:delMod(xi.mod.ACC, subPower * 2)
            attacker:delMod(xi.mod.CRIT_DMG_INCREASE, subPower)

            effect:setSubPower(0)
        end
    end
end

-- TODO: Support Tantra Cyclas + 1 (does not give critical hit damage)
-- Probably will be exceptionally jank, very low priority
xi.job_utils.monk.impetusHitListener = function(attacker, victim, attack)
    local effect = attacker:getStatusEffect(xi.effect.IMPETUS)

    if effect then
        local mainPower = effect:getPower()    -- Stores Attack & Critical Hit Rate bonuses
        local subPower  = effect:getSubPower() -- Stores Critical Hit Damage & Accuracy bonuses

        if mainPower < 50 then
            attacker:addMod(xi.mod.ATT, 2)
            attacker:addMod(xi.mod.CRITHITRATE, 1)

            effect:setPower(mainPower + 1)
        end

        if attacker:getMod(xi.mod.AUGMENTS_IMPETUS) > 0 and subPower < 50 then
            attacker:addMod(xi.mod.ACC, 2)
            attacker:addMod(xi.mod.CRIT_DMG_INCREASE, 1)

            effect:setSubPower(subPower + 1)
        end
    end
end

xi.job_utils.monk.useImpetus = function(player, target, ability)
    player:addStatusEffect(xi.effect.IMPETUS, 0, 0, 180)
end

xi.job_utils.monk.useInnerStrength = function(player, target, ability)
    player:addStatusEffect(xi.effect.INNER_STRENGTH, 2, 0, 30)
end

xi.job_utils.monk.useMantra = function(player, target, ability)
    local merits = player:getMerit(xi.merit.MANTRA)

    target:delStatusEffect(xi.effect.MAX_HP_BOOST) -- TODO: confirm which versions of HP boost mantra can overwrite
    target:addStatusEffect(xi.effect.MAX_HP_BOOST, merits, 0, 180)

    return 0 -- xi.effect.MANTRA -- TODO: implement xi.effect.MANTRA
end

xi.job_utils.monk.usePerfectCounter = function(player, target, ability)
    player:addStatusEffect(xi.effect.PERFECT_COUNTER, 2, 0, 30)
end

-- ══════════════════════════════════════════════════════════════
-- Solo Synergy — Monk
-- ══════════════════════════════════════════════════════════════
-- Design fantasy: patient ki-builder. Boost stacks compound.
-- At 5 stacks Chi Blast detonates everything. Hundred Fists
-- keeps you alive solo via micro-heals on each hit.
-- ══════════════════════════════════════════════════════════════
require('scripts/globals/solo_synergy')

do
    local ss  = xi.soloSynergy
    local _MNK = xi.job_utils.monk

    -- Boost — stacks tracked via SS_STK_MNK_BOOST (max 5).
    -- Each stack adds party-scaled STR on top of the base Boost effect.
    local _boost = _MNK.useBoost
    _MNK.useBoost = function(player, target, ability)
        _boost(player, target, ability)
        local stacks  = ss.addStacks(player, 'MNK_BOOST', 1, 5)
        local party   = ss.getPartyPotencyBonus(player)
        local strGain = math.floor(3 * stacks + party * 0.2)
        player:addStatusEffect(xi.effect.STR_BOOST, strGain, 0, 180)
        -- TP trickle for solo (Monks lack TP generation tools)
        if player:getPartySize() <= 2 then
            player:addTP(math.random(80, 180) * stacks)
        end
        if stacks >= 5 then
            ss.flash(player, 'Ki MAXED [5/5] — Chi Blast will detonate!')
        else
            ss.flash(player, string.format('Ki [%d/5] STR+%d', stacks, strGain))
        end
    end

    -- Chakra — heals scale with current ki stacks.
    local _chakra = _MNK.useChakra
    _MNK.useChakra = function(player, target, ability)
        local result   = _chakra(player, target, ability)
        local stacks   = ss.getStacks(player, 'MNK_BOOST')
        local party    = ss.getPartyBonus(player)
        -- Extra HP recovery proportional to ki + bloodbath bonus
        local extra    = math.floor((stacks * 0.05 + 0.02) * player:getMaxHP() * party)
        extra = math.min(extra, player:getMaxHP() - player:getHP())
        if extra > 0 then
            ss.restoreHP(player, extra)
            ss.flash(player, string.format('Ki Chakra: +%d extra HP (Ki %d/5)', extra, stacks))
        end
        return result
    end

    -- Chi Blast — consume ALL ki stacks for a multiplier bonus.
    local _chi = _MNK.useChiBlast
    _MNK.useChiBlast = function(player, target, ability)
        local stacks = ss.spendStacks(player, 'MNK_BOOST')
        if stacks >= 5 then
            -- Max ki detonation: inject a temporary MND boost before the blast
            local mndSurge = math.floor(player:getMainLvl() / 3)
            player:addMod(xi.mod.MND, mndSurge)
            local result = _chi(player, target, ability)
            player:delMod(xi.mod.MND, mndSurge)
            ss.flash(player, 'DETONATION! Full ki released!')
            ss.addMomentum(player, 3)
            return result
        else
            -- Partial ki — still a bonus but smaller
            if stacks > 0 then
                local mndBonus = math.floor(player:getMainLvl() / 6) * stacks
                player:addMod(xi.mod.MND, mndBonus)
                local result = _chi(player, target, ability)
                player:delMod(xi.mod.MND, mndBonus)
                return result
            end
        end
        return _chi(player, target, ability)
    end

    -- Hundred Fists — solo: each hit regenerates a tiny amount of HP.
    -- Implemented as a strong Regen that simulates life-on-hit.
    local _hf = _MNK.useHundredFists
    _MNK.useHundredFists = function(player, target, ability)
        _hf(player, target, ability)
        if player:getPartySize() <= 2 then
            local regenPow = math.floor(player:getMainLvl() / 8) + 5
            player:addStatusEffect(xi.effect.REGEN, regenPow, 3, 45)
            ss.flash(player, string.format('Solo: Life-on-hit Regen+%d during Hundred Fists', regenPow))
        end
        ss.addMomentum(player, 2)
        ss.resetStacks(player, 'MNK_BOOST')  -- 1HB resets ki naturally
    end

    -- Focus — when solo, also grants Haste (swift meditation).
    local _focus = _MNK.useFocus
    _MNK.useFocus = function(player, target, ability)
        _focus(player, target, ability)
        if player:getPartySize() <= 2 then
            player:addStatusEffect(xi.effect.HASTE, 10, 0, 30)
        end
    end

    -- Inner Strength — surge bonus when at max ki.
    local _is = _MNK.useInnerStrength
    _MNK.useInnerStrength = function(player, target, ability)
        _is(player, target, ability)
        local stacks = ss.getStacks(player, 'MNK_BOOST')
        if stacks >= 5 then
            ss.triggerSurge(player)
            ss.flash(player, 'Inner Strength + full ki = Surge!')
        end
    end
end
