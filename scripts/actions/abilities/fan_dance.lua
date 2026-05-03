-----------------------------------
-- Ability: Fan Dance
-- Job: Dancer
-- Physical damage reduction + high enmity. Samba disabled.
-- Solo bonus: DEF boost — the dancer becomes an iron wall.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    player:addStatusEffect(xi.effect.FAN_DANCE, 9000, 0, 300)

    local lvl   = player:getMainLvl()
    local isDNC = player:getMainJob() == xi.job.DNC
    local defBonus = isDNC and math.floor(lvl * 0.22) or math.floor(lvl * 0.11)

    player:addMod(xi.mod.DEF, defBonus)
    player:timer(300000, function(p) p:delMod(xi.mod.DEF, defBonus) end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Fan Dance', string.format('DEF +%d', defBonus))
    end
end

return abilityObject
