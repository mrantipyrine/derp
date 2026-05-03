-----------------------------------
-- Spell: Watera III
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    return xi.soloSynergy.castElementalResonanceSpell(caster, target, spell)
end

return spellObject
