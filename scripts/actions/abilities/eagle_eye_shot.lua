-----------------------------------
-- Ability: Eagle Eye Shot
-- Job: Ranger
-- Delivers a devastating ranged attack.
-- Solo bonus: STR + TP after the shot — the kill sets up the chain.
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    local ranged = player:getStorageItem(0, 0, xi.slot.RANGED)
    local ammo   = player:getStorageItem(0, 0, xi.slot.AMMO)

    if ranged and ranged:isType(xi.itemType.WEAPON) then
        local skilltype = ranged:getSkillType()
        if
            skilltype == xi.skill.ARCHERY or
            skilltype == xi.skill.MARKSMANSHIP or
            skilltype == xi.skill.THROWING
        then
            if ammo and (ammo:isType(xi.itemType.WEAPON) or skilltype == xi.skill.THROWING) then
                ability:setRecast(math.max(0, ability:getRecast() - player:getMod(xi.mod.ONE_HOUR_RECAST) * 60))
                return 0, 0
            end
        end
    end

    return xi.msg.basic.NO_RANGED_WEAPON, 0
end

abilityObject.onUseAbility = function(player, target, ability, action)
    if player:getWeaponSkillType(xi.slot.RANGED) == xi.skill.MARKSMANSHIP then
        action:setAnimation(target:getID(), action:getAnimation(target:getID()) + 1)
    end

    local params = {}
    params.numHits    = 1
    local tp          = 1000
    params.ftpMod     = { 5.0, 5.0, 5.0 }
    params.critVaries = { 0.0, 0.0, 0.0 }
    params.str_wsc = 0; params.dex_wsc = 0; params.vit_wsc = 0
    params.agi_wsc = 0; params.int_wsc = 0; params.mnd_wsc = 0; params.chr_wsc = 0
    params.enmityMult = 0.5

    local jpValue = player:getJobPointLevel(xi.jp.EAGLE_EYE_SHOT_EFFECT)
    player:addMod(xi.mod.ALL_WSDMG_ALL_HITS, jpValue * 3)

    local damage, _, tpHits, extraHits = xi.weaponskills.doRangedWeaponskill(player, target, 0, params, tp, action, true)

    if tpHits + extraHits > 0 then
        action:messageID(target:getID(), xi.msg.basic.JA_DAMAGE)
        action:speceffect(target:getID(), 32)
    else
        action:messageID(target:getID(), xi.msg.basic.JA_MISS_2)
        action:speceffect(target:getID(), 0)
    end

    -- Post-shot bonus
    local lvl   = player:getMainLvl()
    local isRNG = player:getMainJob() == xi.job.RNG

    local strBonus = isRNG and math.floor(lvl * 0.18) or math.floor(lvl * 0.09)
    local tpGain   = isRNG and math.random(300, 500) or math.random(100, 200)

    player:addMod(xi.mod.STR, strBonus)
    player:addTP(tpGain)
    player:timer(30000, function(p)
        p:delMod(xi.mod.STR, strBonus)
    end)

    if xi.soloSynergy then
        xi.soloSynergy.flashBuff(player, 'Eagle Eye Shot', string.format('STR +%d  TP +%d', strBonus, tpGain))
    end

    return damage
end

return abilityObject
