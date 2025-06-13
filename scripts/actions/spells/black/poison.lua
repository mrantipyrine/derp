-----------------------------------
-- Spell: Poison
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    local duration = 120
    local mainJob = caster:getMainJob()
    local equippedHead = caster:getEquipID(xi.slot.HEAD)

    -- Check if Fungus Hat is equipped...
    -- Afterall a fungus hat should spread disease not just give resistance
    if equippedHead == 12485 then
        dotdmg = (mainJob == xi.job.BLM and 20) or (mainJob == xi.job.RDM and 15) or return nil
        target:addStatusEffect(xi.effect.BIO, dotdmg, 3, duration, 0, 20, 3)
    end

    return xi.spells.enfeebling.useEnfeeblingSpell(caster, target, spell)
end

return spellObject
