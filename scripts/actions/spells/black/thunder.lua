-----------------------------------
-- Spell: Thunder
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    local main = caster:getMainJob()
    local sub = caster:getSubJob()
    local level = caster:getMainLvl()
    local duration = 360 
    local power = (level >= 50 and level * 4 or level * 2) or math.floor(level / 2) 

    -- RDM gets nice EN spell buff
    if main == xi.job.RDM or sub == xi.job.RDM then
        caster:addStatusEffect(xi.effect.ENTHUNDER, power, 3, duration)
    end 
    
    if (main == xi.job.RDM or main == xi.job.BLM or main == xi.job.WHM) or (sub == xi.job.RDM or sub == xi.job.BLM or sub == xi.job.WHM) then 
        caster:addStatusEffect(xi.effect.SHOCK_SPIKES, power, 3, duration)
    end

    -- Double DMG for BLM 
    if main == xi.job.BLM and math.random() <= 0.30 then
       xi.spells.damage.useDamageSpell(caster, target, spell)
       xi.spells.damage.useDamageSpell(caster, target, spell)
    end 

    return xi.spells.damage.useDamageSpell(caster, target, spell)
end

return spellObject