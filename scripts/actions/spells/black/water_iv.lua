-----------------------------------
-- Spell: Water IV
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell, customMultiplier)
    local day = VanadielDayOfTheWeek()
    local mainJob = caster:getMainJob()
    local multiplier = customMultiplier or 1

    -- Only apply special logic for BLM
    if mainJob == xi.job.BLM then
        -- 30% chance to refund MP cost
        if math.random(100) <= 30 then
            local mpCost = spell:getMPCost()
            local newMP = math.min(caster:getMP() + mpCost, caster:getMaxMP())
            caster:setMP(newMP)
        end

        -- Apply Ice Spikes bonus
        if caster:hasStatusEffect(xi.effect.AQUAVEIL) then
            multiplier = 10
        end

        -- Apply Iceday bonus (overrides Ice Spikes if both are present)
        if day == xi.day.WATERSDAY then
            multiplier = 20
        end

        -- Apply random multiplier (mutually exclusive)
        local roll = math.random(100)
        if roll <= 30 then
            multiplier = multiplier * 2  -- 30% chance
        elseif roll <= 55 then
            multiplier = multiplier * 1.5 -- next 20% chance (total 55%)
        end
    end

    return xi.spells.damage.useDamageSpell(caster, target, spell, multiplier)
end

return spellObject
