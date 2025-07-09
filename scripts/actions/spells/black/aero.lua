-----------------------------------
-- Aero
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
    local multiplier = customMultiplier or 1
    local duration = 180 -- 3 minutes

    -- Calculate Enaero and Blink power
    local enaeroPower, blinkPower = 0, 0
    if mainJob == xi.job.RDM then
        enaeroPower = math.floor(mainLevel / 6)
        blinkPower = enaeroPower * 10
    elseif subJob == xi.job.RDM then
        enaeroPower = math.floor(mainLevel / 8)
        blinkPower = enaeroPower * 10
    elseif mainJob == xi.job.BLM or mainJob == xi.job.WHM then
        blinkPower = math.floor(mainLevel / 6) * 10
    elseif subJob == xi.job.BLM or subJob == xi.job.WHM then
        blinkPower = math.floor(mainLevel / 8) * 10
    end

    -- Apply Enaero for RDM (main or sub)
    if enaeroPower > 0 then
        caster:addStatusEffect(xi.effect.ENAERO, enaeroPower, 3, duration, 0, 10, 1)
    end

    -- Apply Blink for RDM, BLM, WHM (main or sub)
    if blinkPower > 0 then
        caster:addStatusEffect(xi.effect.BLINK, blinkPower, 3, duration, 0, 10, 1)
    end

    -- Special logic for BLM main job
    if mainJob == xi.job.BLM then
        -- 30% chance to refund MP cost
        if math.random(100) <= 30 then
            local mpCost = spell:getMPCost()
            local newMP = math.min(caster:getMP() + mpCost, caster:getMaxMP())
            caster:setMP(newMP)
        end

        -- Apply multipliers
        if caster:hasStatusEffect(xi.effect.BLINK) then
            multiplier = 10
        end
        if day == xi.day.WINDSDAY then
            multiplier = 30
        end

        -- Random multiplier (mutually exclusive)
        local roll = math.random(100)
        if roll <= 5 then
            multiplier = multiplier * 2      -- 5% chance
        elseif roll <= 25 then
            multiplier = multiplier * 1.5    -- next 20% chance
        end
    end

    return xi.spells.damage.useDamageSpell(caster, target, spell, multiplier)
end

return spellObject
