-----------------------------------
-- Spell: Stone 
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell, customMultiplier)
    local mainJob = caster:getMainJob()
    local subJob = caster:getSubJob()
    local mainLevel = caster:getMainLvl()
    local day = VanadielDayOfTheWeek()
    local multi = customMultiplier or 1

    -- Set duration (3 minutes = 180 seconds)
    local duration = 180
    
    -- Calculate Enstone and Stoneskin power based on level and job
    local enstonePower, stoneskinPower
    if mainJob == xi.job.RDM then
        -- Main RDM: higher power (level / 6, rounded down)
        enstonePower = math.floor(mainLevel / 3)
        stoneskinPower = math.floor(mainLevel) * 10
    elseif subJob == xi.job.RDM then
        -- Sub RDM: lower power (level / 8, rounded down)
        enstonePower = math.floor(mainLevel / 5)
        stoneskinPower = math.floor(mainLevel) * 5
    elseif mainJob == xi.job.BLM or mainJob == xi.job.WHM then
        -- Main BLM/WHM: Stoneskin only (level / 6, rounded down)
        stoneskinPower = math.floor(mainLevel) * 15
    elseif subJob == xi.job.BLM or subJob == xi.job.WHM then
        -- Sub BLM/WHM: Stoneskin only (level / 8, rounded down)
        stoneskinPower = math.floor(mainLevel) * 10
    end
    
    -- Apply Enstone for RDM (main or sub)
    if mainJob == xi.job.RDM or subJob == xi.job.RDM then
        caster:addStatusEffect(xi.effect.ENSTONE, enstonePower, 3, duration, 0, 10, 1)
    end
    
    -- Apply Stoneskin for RDM, BLM, WHM (main or sub)
    if mainJob == xi.job.RDM or mainJob == xi.job.BLM or mainJob == xi.job.WHM or
       subJob == xi.job.RDM or subJob == xi.job.BLM or subJob == xi.job.WHM then
        caster:addStatusEffect(xi.effect.STONESKIN, stoneskinPower, 3, duration, 0, 10, 1)
    end
    
    -- Only apply special logic for BLM
    if mainJob == xi.job.BLM then
        -- 30% chance to refund MP cost
        if math.random(100) <= 30 then
            local mpCost = spell:getMPCost()
            local newMP = math.min(caster:getMP() + mpCost, caster:getMaxMP())
            caster:setMP(newMP)
        end

        -- Apply Ice Spikes bonus
        if caster:hasStatusEffect(xi.effect.STONESKIN) then
            multiplier = 10
        end

        -- Apply Iceday bonus (overrides Ice Spikes if both are present)
        if day == xi.day.EARTHSDAY then
            multiplier = 30 
        end

        -- Apply random multiplier (mutually exclusive)
        local roll = math.random(100)
        if roll <= 5 then
            multiplier = multiplier * 2  -- 5% chance
        elseif roll <= 25 then
            multiplier = multiplier * 1.5 -- next 20% chance (total 25%)
        end
    end

    -- Apply the damage spell and return its result
    return xi.spells.damage.useDamageSpell(caster, target, spell, multiplier)
end

return spellObject