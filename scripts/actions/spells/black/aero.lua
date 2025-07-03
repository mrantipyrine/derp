-----------------------------------
-- Spell: Stone (or custom elemental spell)
-- Applies Enstone and Stoneskin effects based on job, with a chance for double damage for BLM and MP refund.
-- Obtained: Varies by job
-- Recast Time: Varies
-- Duration: 3:00
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    local mainJob = caster:getMainJob()
    local subJob = caster:getSubJob()
    local mainLevel = caster:getMainLvl()
    
    -- Set duration (3 minutes = 180 seconds)
    local duration = 180
    local day = VanadielDayOfTheWeek()

    -- Calculate Enstone and Stoneskin power based on level and job
    local enstonePower, stoneskinPower
    if mainJob == xi.job.RDM then
        -- Main RDM: higher power (level / 6, rounded down)
        enstonePower = math.floor(mainLevel / 6)
        stoneskinPower = math.floor(mainLevel / 6) * 10
    elseif subJob == xi.job.RDM then
        -- Sub RDM: lower power (level / 8, rounded down)
        enstonePower = math.floor(mainLevel / 8)
        stoneskinPower = math.floor(mainLevel / 8) * 10
    elseif mainJob == xi.job.BLM or mainJob == xi.job.WHM then
        -- Main BLM/WHM: Stoneskin only (level / 6, rounded down)
        stoneskinPower = math.floor(mainLevel / 6) * 10
    elseif subJob == xi.job.BLM or subJob == xi.job.WHM then
        -- Sub BLM/WHM: Stoneskin only (level / 8, rounded down)
        stoneskinPower = math.floor(mainLevel / 8) * 10
    end
    
    -- Apply Enstone for RDM (main or sub)
    if mainJob == xi.job.RDM or subJob == xi.job.RDM then
        caster:addStatusEffect(xi.effect.ENAERO, enstonePower, 3, duration, 0, 10, 1)
    end
    
    -- Apply Stoneskin for RDM, BLM, WHM (main or sub)
    if mainJob == xi.job.RDM or mainJob == xi.job.BLM or mainJob == xi.job.WHM or
       subJob == xi.job.RDM or subJob == xi.job.BLM or subJob == xi.job.WHM then
        caster:addStatusEffect(xi.effect.BLINK, stoneskinPower, 3, duration, 0, 10, 1)
    end
    
    -- 30% chance to refund MP cost
    if math.random() <= 0.30 then
        local mpCost = spell:getMPCost()
        caster:setMP(caster:getMP() + mpCost)
    end
    
    -- Check if today is Earthsday and apply triple damage for BLM with 30% chance
if day == xi.day.WINDSDAY and mainJob == xi.job.BLM and math.random() <= 0.40 then
        xi.spells.damage.useDamageSpell(caster, target, spell)
        xi.spells.damage.useDamageSpell(caster, target, spell)
        xi.spells.damage.useDamageSpell(caster, target, spell)
    -- Otherwise, apply double damage for BLM with 30% chance
    elseif mainJob == xi.job.BLM and math.random() <= 0.30 then
        xi.spells.damage.useDamageSpell(caster, target, spell)
        xi.spells.damage.useDamageSpell(caster, target, spell)
    end
    -- Apply the damage spell and return its result
    return xi.spells.damage.useDamageSpell(caster, target, spell)
end

return spellObject