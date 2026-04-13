-- spell_factory.lua
-- A spell-agnostic factory for creating spell objects with customizable behavior.
local spellFactory = {}

-- Calculates power for enhancement and buff effects based on job and level.
-- @param mainJob: Caster's main job (e.g., xi.job.RDM).
-- @param subJob: Caster's sub job.
-- @param mainLevel: Caster's main job level.
-- @param params: Table containing power calculation parameters.
-- @return enhancePower, buffPower: Calculated powers for enhancement and buff effects.
-- Applies status effects to the caster based on job and parameters.
-- @param caster: The spell caster.
-- @param mainJob: Caster's main job.
-- @param subJob: Caster's sub job.
-- @param enhancePower: Power for the enhancement effect.
-- @param buffPower: Power for the buff effect.
-- @param params: Table containing effect and duration parameters.
local function applyStatusEffects(caster, mainJob, subJob, enhancePower, buffPower, params)
    local duration = params.duration or 180

    -- Apply enhancement effect (e.g., ENFIRE, ENSTONE) for RDM.
    if (mainJob == xi.job.RDM or subJob == xi.job.RDM) then
        if enhancePower > 0 and params.enhanceEffect then
            caster:addStatusEffect(params.enhanceEffect, enhancePower, 3, duration, 0, 10, 1)
        end
        if (params.secondaryPower or 0) > 0 and params.secondaryEffect then
            caster:addStatusEffect(params.secondaryEffect, params.secondaryPower, 3, duration, 0, 10, 1)
        end
    end

    -- Apply buff effect (e.g., BLAZE_SPIKES) for RDM, BLM, or WHM.
    if (mainJob == xi.job.RDM or mainJob == xi.job.BLM or mainJob == xi.job.WHM or
        subJob == xi.job.RDM or subJob == xi.job.BLM or subJob == xi.job.WHM) and
        buffPower > 0 and params.buffEffect then
        caster:addStatusEffect(params.buffEffect, buffPower, 3, duration, 0, 10, 1)
    end
end

-- Applies BLM-specific logic (MP refund, buff/day bonuses, random multipliers).
-- @param caster: The spell caster.
-- @param spell: The spell being cast.
-- @param day: Current game day (e.g., xi.day.FIRESDAY).
-- @param params: Table containing BLM-specific parameters.
-- @return multiplier: Final damage multiplier.
local function applyBLMSpecialLogic(caster, spell, day, params)
    local multiplier = params.multiplier or 1

    if caster:getMainJob() ~= xi.job.BLM then
        return multiplier
    end

    -- MP refund chance.
    if params.mpRefundChance and math.random(100) <= params.mpRefundChance then
        local mpCost = spell:getMPCost()
        caster:setMP(math.min(caster:getMP() + mpCost, caster:getMaxMP()))
    end

    -- Buff effect multiplier (e.g., for BLAZE_SPIKES).
    if params.buffEffect and caster:hasStatusEffect(params.buffEffect) and params.buffMultiplier then
        multiplier = params.buffMultiplier
    end

    -- Day-based multiplier.
    if params.bonusDay and day == params.bonusDay and params.dayBonusMultiplier then
        multiplier = params.dayBonusMultiplier
    end

    -- Random multiplier.
    local roll = math.random(100)
    if params.randomHighChance and roll <= params.randomHighChance then
        multiplier = multiplier * (params.randomHighMultiplier or 1)
    elseif params.randomMidChance and roll <= params.randomMidChance then
        multiplier = multiplier * (params.randomMidMultiplier or 1)
    end

    return multiplier
end

-- Creates a spell object with customizable behavior.
-- @param params: Table of spell parameters (e.g., duration, effects, multipliers).
-- @return spellObject: Object with onMagicCastingCheck and onSpellCast methods.
function spellFactory.createSpell(params)
    local spellObject = {}

    -- Checks if the spell can be cast (default: no restrictions).
    spellObject.onMagicCastingCheck = function(caster, target, spell)
        return 0
    end

    -- Handles spell casting logic, including power calculations, effects, and damage.
    spellObject.onSpellCast = function(caster, target, spell, customMultiplier)
        local mainJob = caster:getMainJob()
        local subJob = caster:getSubJob()
        local mainLevel = caster:getMainLvl()
        local day = VanadielDayOfTheWeek()
        local multiplier = customMultiplier or params.multiplier or 1

        -- Calculate power for enhancement and buff effects.
        local enhancePower, buffPower = calculatePower(mainJob, subJob, mainLevel, params)

        -- Apply status effects if specified.
        applyStatusEffects(caster, mainJob, subJob, enhancePower, buffPower, params)

        -- Apply BLM-specific multipliers.
        multiplier = applyBLMSpecialLogic(caster, spell, day, params)

        -- Execute the damage spell with the final multiplier.
        return xi.spells.damage.useDamageSpell(caster, target, spell, multiplier)
    end

    return spellObject
end

return spellFactory