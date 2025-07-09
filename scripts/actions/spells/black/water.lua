-----------------------------------
-- Water
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

    -- Calculate Enwater and Aquaveil power
    local enwaterPower, aquaveilPower = 0, 0
    if mainJob == xi.job.RDM then
        enwaterPower = math.floor(mainLevel / 6)
        aquaveilPower = enwaterPower * 10
    elseif subJob == xi.job.RDM then
        enwaterPower = math.floor(mainLevel / 8)
        aquaveilPower = enwaterPower * 10
    elseif mainJob == xi.job.BLM or mainJob == xi.job.WHM then
        aquaveilPower = math.floor(mainLevel / 6) * 10
    elseif subJob == xi.job.BLM or subJob == xi.job.WHM then
        aquaveilPower = math.floor(mainLevel / 8) * 10
    end

    -- Apply Enwater for RDM (main or sub)
    if enwaterPower > 0 then
        caster:addStatusEffect(xi.effect.ENWATER, enwaterPower, 3, duration, 0, 10, 1)
    end

    -- Apply Ice Spikes for RDM, BLM, WHM (main or sub)
    if aquaveilPower > 0 then
        caster:addStatusEffect(xi.effect.AQUAVEIL, aquaveilPower, 3, duration, 0, 10, 1)
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
        if caster:hasStatusEffect(xi.effect.AQUAVEIL) then
            multiplier = 10
        end
        if day == xi.day.LIGHTNINGDAY then
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
