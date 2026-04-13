-- Fire
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
    -- Calculate Blaze Spikes power
    local effectPower = 0
    local magicJobs = {
        [xi.job.RDM] = true,
        [xi.job.BLM] = true,
        [xi.job.WHM] = true
    }
    if magicJobs[mainJob] then
        effectPower = math.floor(mainLevel / 6) * 10
    elseif magicJobs[subJob] then
        effectPower = math.floor(mainLevel / 8) * 10
    end
    -- Apply Blaze Spikes for RDM, BLM, WHM (main or sub)
    if effectPower > 0 then
        caster:addStatusEffect(xi.effect.BLAZE_SPIKES, effectPower, 3, duration, 0, 10, 1)
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
        if caster:hasStatusEffect(xi.effect.BLAZE_SPIKES) then
            multiplier = 2
        end
        if day == xi.day.FIRESDAY then
            multiplier = 5
        end
        -- Random multiplier (mutually exclusive)
        local roll = math.random(100)
        if roll <= 5 then
            multiplier = multiplier * 2 -- 5% chance
        elseif roll <= 25 then
            multiplier = multiplier * 1.5 -- next 20% chance
        end
    end
    return xi.spells.damage.useDamageSpell(caster, target, spell, multiplier)
end
return spellObject