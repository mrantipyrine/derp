-----------------------------------
-- Spell: Thunder II
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    local mainJob = caster:getMainJob()
    local subJob = caster:getSubJob()
    local hasBuff = caster:hasStatusEffect(xi.effect.BLAZE_SPIKES)
    local randomValue = math.random()

    -- 30% increased chance to triple cast if player has Shock Spikes. 
    -- This makes rotations fun
    -- Extend this with items 
    if hasBuff then
        -- maybe if X item is equipped then X chance to quad cast 
        -- maybe if elemental resistance is > X then quad cast chance
        if mainJob == xi.job.BLM then
            if randomValue <= 0.30 then
                xi.spells.damage.useDamageSpell(caster, target, spell)
                xi.spells.damage.useDamageSpell(caster, target, spell)
            end
        elseif randomValue <= 0.10 then
            xi.spells.damage.useDamageSpell(caster, target, spell)
        end
    end

    return xi.spells.damage.useDamageSpell(caster, target, spell)
end

return spellObject
