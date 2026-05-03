-----------------------------------
xi = xi or {}
xi.combat = xi.combat or {}
xi.combat.damage = xi.combat.damage or {}
-----------------------------------

-----------------------------------
-- Physical damage multipliers
-----------------------------------

-----------------------------------
-- Magical damage multipliers
-----------------------------------

xi.combat.damage.magicalElementSDT = function(target, element)
    local mod = xi.combat.element.getElementalSDTModifier(element)

    if mod == 0 then
        return 1
    end

    return (1000 + target:getMod(mod)) / 1000
end


-- Compatibility layer for older scripts that still call the generic
-- damage-adjustment helper. This branch no longer defines it.
xi.combat.damage.calculateDamageAdjustment = function(target, isPhysical, isMagical, isRanged, isBreath)
    if isMagical then
        return 1
    end

    if isBreath then
        return 1
    end

    if isPhysical or isRanged then
        return 1
    end

    return 1
end

-----------------------------------
-- All damage multipliers
-----------------------------------
xi.combat.damage.scarletDeliriumMultiplier = function(actor)
    -- Scarlet delirium are 2 different status effects. SCARLET_DELIRIUM_1 is the one that boosts power.
    if not actor:hasStatusEffect(xi.effect.SCARLET_DELIRIUM_1) then
        return 1
    end

    local scarletDeliriumMultiplier = 1 + actor:getStatusEffect(xi.effect.SCARLET_DELIRIUM_1):getPower() / 100

    return scarletDeliriumMultiplier
end
