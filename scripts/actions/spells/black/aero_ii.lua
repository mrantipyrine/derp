-----------------------------------
-- Spell: Aero II
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    local main = caster:getMainJob()
    local sub = caster:getSubJob()
    local buff = caster:hasStatusEffect(xi.effect.BLINK)
    local random = math.random()

    -- 30% increased chance to triple cast if player has Shock Spikes. 
    -- This makes rotations fun
    -- Extend this with items 
    if buff then
        -- maybe if X item is equipped then X chance to quad cast 
        -- maybe if elemental resistance is > X then quad cast chance
        if main == xi.job.BLM then
            if random <= 0.30 then
                xi.spells.damage.useDamageSpell(caster, target, spell)
            end
        elseif random <= 0.10 then
            xi.spells.damage.useDamageSpell(caster, target, spell)
            xi.spells.damage.useDamageSpell(caster, target, spell)
        end
    end

    return xi.spells.damage.useDamageSpell(caster, target, spell)
end

return spellObject
