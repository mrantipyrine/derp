-----------------------------------
-- Ability: Cover
-- Job: Paladin
-- Intercepts attacks aimed at a party member.
-- Solo bonus: brief DEF boost to self so the intercept doesn't kill you.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.paladin.checkCover(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    xi.job_utils.paladin.useCover(player, target, ability)

    local lvl   = player:getMainLvl()
    local isPLD = player:getMainJob() == xi.job.PLD

    local defBonus = isPLD and math.floor(lvl * 0.25) or math.floor(lvl * 0.12)

    player:addMod(xi.mod.DEF, defBonus)
    player:timer(35000, function(p)
        p:delMod(xi.mod.DEF, defBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Cover', string.format('DEF +%d (35s)', defBonus))
    end
end

return abilityObject
