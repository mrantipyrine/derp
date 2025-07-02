-----------------------------------
-- Spell: Poison
-- Applies a Poison effect with enhanced damage when wearing Fungus Hat, restoring HP to the caster per tick.
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
    local equippedHead = caster:getEquipID(xi.slot.HEAD)
    
    -- Set duration (3 minutes = 180 seconds)
    local duration = 180
    
    -- Check for Fungus Hat (ID 12485)
    if equippedHead == 12485 then
        local poisonPower
        if mainJob == xi.job.BLM or mainJob == xi.job.RDM then
            -- Main BLM/RDM: higher power (level / 6, rounded down)
            poisonPower = math.floor(mainLevel / 6)
        elseif subJob == xi.job.BLM or subJob == xi.job.RDM then
            -- Sub BLM/RDM: lower power (level / 8, rounded down)
            poisonPower = math.floor(mainLevel / 8)
        end
        
        if poisonPower then
            -- Apply Poison effect to target (mimicking Poison II)
            target:addStatusEffect(xi.effect.POISON, poisonPower, 3, duration, 0, 10, 1)
            -- Apply custom HP drain effect to caster to restore HP per tick
            caster:addStatusEffect(xi.effect.CUSTOM_HP_DRAIN, poisonPower, 3, duration, 0, 10, 1)
        end
    end
    
    -- Apply the base Poison spell and return its result
    return xi.spells.enfeebling.useEnfeeblingSpell(caster, target, spell)
end

return spellObject