-----------------------------------
-- Thunder
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

    -- Calculate Enthunder and Shock Spikes power
    local enthunderPower, shockspikesPower = 0, 0
    if mainJob == xi.job.RDM then
        enthunderPower = math.floor(mainLevel / 6)
        shockspikesPower = enthunderPower * 10
    elseif subJob == xi.job.RDM then
        enthunderPower = math.floor(mainLevel / 8)
        shockspikesPower = enthunderPower * 10
    elseif mainJob == xi.job.BLM or mainJob == xi.job.WHM then
        shockspikesPower = math.floor(mainLevel / 6) * 10
    elseif subJob == xi.job.BLM or subJob == xi.job.WHM then
        shockspikesPower = math.floor(mainLevel / 8) * 10
    end

    -- Apply Enthunder for RDM (main or sub)
    if enthunderPower > 0 then
        caster:addStatusEffect(xi.effect.ENTHUNDER, enthunderPower, 3, duration, 0, 10, 1)
    end

    -- Apply Shock Spikes for RDM, BLM, WHM (main or sub)
    if shockspikesPower > 0 then
        caster:addStatusEffect(xi.effect.SHOCK_SPIKES, shockspikesPower, 3, duration, 0, 10, 1)
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
        if caster:hasStatusEffect(xi.effect.SHOCK_SPIKES) then
            multiplier = 2
        end
        if day == xi.day.LIGHTNINGDAY then
            multiplier = 5
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
