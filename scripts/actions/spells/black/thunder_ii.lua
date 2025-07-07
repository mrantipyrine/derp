-----------------------------------
-- Spell: Stonera
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)

    local day = VanadielDayOfTheWeek()

    if main == xi.job.BLM then
        if caster:hasStatusEffect(xi.effect.SHOCK_SPIKES) then
            -- Check if today is Earthsday and apply triple damage for BLM with 30% chance
            if day == xi.day.LIGHTNINGDAY and mainJob == xi.job.BLM and math.random() <= 0.55 then
                xi.spells.damage.useDamageSpell(caster, target, spell)
                xi.spells.damage.useDamageSpell(caster, target, spell)
                xi.spells.damage.useDamageSpell(caster, target, spell)
                xi.spells.damage.useDamageSpell(caster, target, spell)
            -- Otherwise, apply double damage for BLM with 30% chance
            elseif mainJob == xi.job.BLM and math.random() <= 0.35 then
                xi.spells.damage.useDamageSpell(caster, target, spell)
                xi.spells.damage.useDamageSpell(caster, target, spell)
                xi.spells.damage.useDamageSpell(caster, target, spell)
            end
        end
    end

    -- 30% chance to refund MP cost
    if math.random() <= 0.30 then
        local mpCost = spell:getMPCost()
        caster:setMP(caster:getMP() + mpCost)
    end
    
    return xi.spells.damage.useDamageSpell(caster, target, spell)
end

return spellObject
