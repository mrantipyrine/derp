xi = xi or {}
xi.solo_modifications = xi.solo_modifications or {}
-- Define power values for each level range
local levelPowerTable = {
    { level = 65, protect = 150, shell = 2800, regen = 13, regain = 35, en = 120, refresh = 0, phalanx = 3, lvl75 = { regain = 40, en = 140, refresh = 15, phalanx = 4 } },
    { level = 50, protect = 120, shell = 2500, regen = 9, regain = 30, en = 80, refresh = 12, phalanx = 3 },
    { level = 35, protect = 90, shell = 2000, regen = 7, regain = 25, en = 60, refresh = 9, phalanx = 2 },
    { level = 20, protect = 60, shell = 1800, regen = 4, regain = 20, en = 40, refresh = 6, phalanx = 2 },
    { level = 0, protect = 20, shell = 25, regen = 2, regain = 15, en = 20, refresh = 4, phalanx = 1 }
}
-- Job-specific buff functions
xi.solo_modifications.applyWHM = function(player, enPower, refreshPower)
    player:addStatusEffect(xi.effect.ENLIGHT, enPower, 0, 0)
    if refreshPower > 0 then
        player:addStatusEffect(xi.effect.REFRESH, refreshPower, 0, 0)
    end
end
xi.solo_modifications.applyBLM = function(player, refreshPower)
    if refreshPower > 0 then
        player:addStatusEffect(xi.effect.REFRESH, refreshPower, 0, 0)
    end
end
xi.solo_modifications.applyRDM = function(player, refreshPower, enPower)
    local elements = { xi.effect.ENFIRE, xi.effect.ENBLIZZARD, xi.effect.ENAERO, xi.effect.ENSTONE, xi.effect.ENTHUNDER, xi.effect.ENWATER }
    local randomElement = elements[math.random(1, #elements)]
    player:addStatusEffect(randomElement, enPower, 0, 0)
    if refreshPower > 0 then
        player:addStatusEffect(xi.effect.REFRESH, refreshPower, 0, 0)
    end
end
xi.solo_modifications.applySMN = function(player, refreshPower)
    if refreshPower > 0 then
        player:addStatusEffect(xi.effect.REFRESH, refreshPower, 0, 0)
    end
end
xi.solo_modifications.applyBRD = function(player, refreshPower)
    if refreshPower > 0 then
        player:addStatusEffect(xi.effect.REFRESH, refreshPower, 0, 0)
    end
end
xi.solo_modifications.applyBST = function(player)
end
xi.solo_modifications.applyNIN = function(player)
end
xi.solo_modifications.applySAM = function(player)
    local mainSkill = player:getWeaponSkillType(xi.slot.MAIN)
    if mainSkill == xi.skill.GREAT_KATANA then
        player:addStatusEffect(xi.effect.HASTE, 100, 0, 0)
    end
end
xi.solo_modifications.applyMNK = function(player)
end
xi.solo_modifications.applyWAR = function(player, phalanxPower)
    local mainSkill = player:getWeaponSkillType(xi.slot.MAIN)
    local twoHandedSkills = { xi.skill.GREAT_SWORD, xi.skill.GREAT_AXE, xi.skill.POLEARM, xi.skill.STAFF }
    local isTwoHanded = false
    for _, skill in ipairs(twoHandedSkills) do
        if mainSkill == skill then
            isTwoHanded = true
            break
        end
    end
    if isTwoHanded then
        player:addStatusEffect(xi.effect.HASTE, 100, 0, 0)
    end
    local subID = player:getEquipID(xi.slot.SUB)
    if subID > 0 then
        player:addStatusEffect(xi.effect.PHALANX, phalanxPower, 0, 0)
    end
end
xi.solo_modifications.applyTHF = function(player)
end
xi.solo_modifications.applyPLD = function(player, enPower, phalanxPower)
    player:addStatusEffect(xi.effect.ENLIGHT, enPower, 0, 0)
    local subID = player:getEquipID(xi.slot.SUB)
    if subID > 0 then
        player:addStatusEffect(xi.effect.PHALANX, phalanxPower, 0, 0)
    end
end
xi.solo_modifications.applyDRK = function(player, enPower)
    player:addStatusEffect(xi.effect.ENDARK, enPower, 0, 0)
    local mainSkill = player:getWeaponSkillType(xi.slot.MAIN)
    local twoHandedSkills = { xi.skill.GREAT_SWORD, xi.skill.GREAT_AXE, xi.skill.SCYTHE }
    local isTwoHanded = false
    for _, skill in ipairs(twoHandedSkills) do
        if mainSkill == skill then
            isTwoHanded = true
            break
        end
    end
    if isTwoHanded then
        player:addStatusEffect(xi.effect.HASTE, 100, 0, 0)
    end
end
xi.solo_modifications.applyDRG = function(player)
    local mainSkill = player:getWeaponSkillType(xi.slot.MAIN)
    if mainSkill == xi.skill.POLEARM then
        player:addStatusEffect(xi.effect.HASTE, 100, 0, 0)
    end
end
xi.solo_modifications.applyRNG = function(player)
    player:addStatusEffect(xi.effect.DOUBLE_SHOT, 0, 0, 0)
end
-- Apply buffs for a player
xi.solo_modifications.applyBuffs = function(player)
    if not player or not player:getMainJob() or not player:getMainLvl() then return end
    local mainJob = player:getMainJob()
    local playerLevel = player:getMainLvl()
    local protectPower, shellPower, regenPower, regainPower, enPower, refreshPower, phalanxPower
    -- Set power values from levelPowerTable
    for _, powerData in ipairs(levelPowerTable) do
        if playerLevel >= powerData.level then
            protectPower = powerData.protect
            shellPower = powerData.shell
            regenPower = powerData.regen
            regainPower = powerData.lvl75 and playerLevel == 75 and powerData.lvl75.regain or powerData.regain
            enPower = powerData.lvl75 and playerLevel == 75 and powerData.lvl75.en or powerData.en
            refreshPower = powerData.lvl75 and playerLevel == 75 and powerData.lvl75.refresh or powerData.refresh
            phalanxPower = powerData.lvl75 and playerLevel == 75 and powerData.lvl75.phalanx or powerData.phalanx
            break
        end
    end
    -- Remove all job-specific and stat boost effects
    local effectsToRemove = {
        xi.effect.ENLIGHT, xi.effect.ENDARK, xi.effect.DOUBLE_SHOT,
        xi.effect.REFRESH, xi.effect.ENFIRE, xi.effect.ENBLIZZARD, xi.effect.ENAERO, xi.effect.ENSTONE,
        xi.effect.ENTHUNDER, xi.effect.ENWATER, xi.effect.REGAIN, xi.effect.PROTECT, xi.effect.SHELL, xi.effect.REGEN,
        xi.effect.HASTE, xi.effect.PHALANX
    }
    for _, effect in ipairs(effectsToRemove) do
        if player:hasStatusEffect(effect) then
            player:delStatusEffect(effect)
        end
    end
    -- Handle excluded jobs for REGAIN
    local mageClass = { xi.job.BLM, xi.job.SMN }
    local isMage = false
    for _, job in ipairs(mageClass) do
        if mainJob == job then isMage = true break end
    end
    -- Global buffs
    player:addStatusEffect(xi.effect.PROTECT, protectPower, 0, 0)
    player:addStatusEffect(xi.effect.SHELL, shellPower, 0, 0)
    player:addStatusEffect(xi.effect.REGEN, regenPower, 0, 0)
    -- Apply regain with adjustment if applicable
    if not isMage then
        local effectiveRegain = regainPower
        local mainSkill = player:getWeaponSkillType(xi.slot.MAIN)
        local twoHandedSkills = {
            xi.skill.GREAT_SWORD,
            xi.skill.GREAT_AXE,
            xi.skill.POLEARM,
            xi.skill.STAFF,
            xi.skill.SCYTHE,
            xi.skill.GREAT_KATANA
        }
        local isTwoHanded = false
        for _, skill in ipairs(twoHandedSkills) do
            if mainSkill == skill then
                isTwoHanded = true
                break
            end
        end
        if isTwoHanded and mainJob ~= xi.job.SAM then
            effectiveRegain = math.floor(effectiveRegain * 1.25)
        end
        player:addStatusEffect(xi.effect.REGAIN, effectiveRegain, 0, 0)
    end
    -- Apply job-specific buffs
    if mainJob == xi.job.WHM then
        xi.solo_modifications.applyWHM(player, enPower, refreshPower)
    elseif mainJob == xi.job.BLM then
        xi.solo_modifications.applyBLM(player, refreshPower)
    elseif mainJob == xi.job.RDM then
        xi.solo_modifications.applyRDM(player, refreshPower, enPower)
    elseif mainJob == xi.job.SMN then
        xi.solo_modifications.applySMN(player, refreshPower)
    elseif mainJob == xi.job.BRD then
        xi.solo_modifications.applyBRD(player, refreshPower)
    elseif mainJob == xi.job.BST then
        xi.solo_modifications.applyBST(player)
    elseif mainJob == xi.job.NIN then
        xi.solo_modifications.applyNIN(player)
    elseif mainJob == xi.job.SAM then
        xi.solo_modifications.applySAM(player)
    elseif mainJob == xi.job.MNK then
        xi.solo_modifications.applyMNK(player)
    elseif mainJob == xi.job.WAR then
        xi.solo_modifications.applyWAR(player, phalanxPower)
    elseif mainJob == xi.job.THF then
        xi.solo_modifications.applyTHF(player)
    elseif mainJob == xi.job.PLD then
        xi.solo_modifications.applyPLD(player, enPower, phalanxPower)
    elseif mainJob == xi.job.DRK then
        xi.solo_modifications.applyDRK(player, enPower)
    elseif mainJob == xi.job.DRG then
        xi.solo_modifications.applyDRG(player)
    elseif mainJob == xi.job.RNG then
        xi.solo_modifications.applyRNG(player)
    end
end