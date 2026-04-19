-----------------------------------
-- Spell: Klimaform
-- Increases magic accuracy for spells of the same element as current weather
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    if target:addStatusEffect(xi.effect.KLIMAFORM, 1, 0, 180) then
        spell:setMsg(xi.msg.basic.MAGIC_GAIN_EFFECT)
        if xi.soloSynergy then
            xi.soloSynergy.applyBlackSelfBuffSynergy(caster, target, spell, xi.effect.KLIMAFORM)
        end
    else
        spell:setMsg(xi.msg.basic.MAGIC_NO_EFFECT)
    end

    return xi.effect.KLIMAFORM
end

return spellObject
