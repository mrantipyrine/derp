xi = xi or {}
xi.solo_modifications = xi.solo_modifications or {}
-- Define power values for each level range
-- Balanced for use with xi.soloSynergy (Momentum/Surge system)
local levelPowerTable = {
    { level = 65, protect = 150, shell = 2200, regen = 10, regain = 3, en = 100, refresh = 3, phalanx = 3, stat = 8, lvl75 = { regain = 5, en = 120, refresh = 4, phalanx = 4, stat = 10 } },
    { level = 50, protect = 120, shell = 1500, regen = 8, regain = 2, en = 80, refresh = 3, phalanx = 3, stat = 7 },
    { level = 35, protect = 90, shell = 900, regen = 6, regain = 2, en = 60, refresh = 2, phalanx = 2, stat = 5 },
    { level = 20, protect = 60, shell = 500, regen = 4, regain = 1, en = 40, refresh = 2, phalanx = 2, stat = 3 },
    { level = 0, protect = 20, shell = 25, regen = 2, regain = 0, en = 20, refresh = 1, phalanx = 1, stat = 2 }
}

local function addEffect(player, effect, power, tick, duration)
    if power and power > 0 then
        player:addStatusEffect(effect, power, tick or 0, duration or 0)
    end
end

local function addPetEffect(player, effect, power, tick, duration)
    local pet = player:getPet()
    if pet and power and power > 0 then
        pet:addStatusEffect(effect, power, tick or 0, duration or 0)
    end
end

local function addPrimaryStats(player, statPower, effects)
    for _, effect in ipairs(effects) do
        addEffect(player, effect, statPower)
    end
end

-- Job-specific buff functions
xi.solo_modifications.applyWHM = function(player, enPower, refreshPower, statPower)
    player:addStatusEffect(xi.effect.ENLIGHT, enPower, 0, 0)
    addEffect(player, xi.effect.REFRESH, refreshPower)
    addPrimaryStats(player, statPower, { xi.effect.MND_BOOST, xi.effect.CHR_BOOST })
end
xi.solo_modifications.applyBLM = function(player, refreshPower, statPower)
    addEffect(player, xi.effect.REFRESH, refreshPower)
    addPrimaryStats(player, statPower, { xi.effect.INT_BOOST, xi.effect.MND_BOOST })
end
xi.solo_modifications.applyRDM = function(player, refreshPower, enPower, statPower)
    local elements = { xi.effect.ENFIRE, xi.effect.ENBLIZZARD, xi.effect.ENAERO, xi.effect.ENSTONE, xi.effect.ENTHUNDER, xi.effect.ENWATER }
    local randomElement = elements[math.random(1, #elements)]
    player:addStatusEffect(randomElement, enPower, 0, 0)
    addEffect(player, xi.effect.REFRESH, refreshPower)
    addPrimaryStats(player, statPower, { xi.effect.INT_BOOST, xi.effect.MND_BOOST, xi.effect.DEX_BOOST })
end
xi.solo_modifications.applySMN = function(player, refreshPower, statPower)
    addEffect(player, xi.effect.REFRESH, refreshPower)
    addPrimaryStats(player, statPower, { xi.effect.INT_BOOST, xi.effect.MND_BOOST })
    addPetEffect(player, xi.effect.REGEN, math.floor(statPower / 2), 3)
    addPetEffect(player, xi.effect.HASTE, 50 + statPower * 2) -- Balanced Pet Haste
end
xi.solo_modifications.applyBRD = function(player, refreshPower, statPower)
    addEffect(player, xi.effect.REFRESH, math.max(1, math.floor(refreshPower / 2)))
    addPrimaryStats(player, statPower, { xi.effect.CHR_BOOST, xi.effect.MND_BOOST })
end
xi.solo_modifications.applyBST = function(player, statPower)
    addPrimaryStats(player, statPower, { xi.effect.CHR_BOOST, xi.effect.STR_BOOST })
    addPetEffect(player, xi.effect.REGEN, math.max(2, math.floor(statPower / 2)), 3)
    addPetEffect(player, xi.effect.HASTE, 50 + statPower * 2)
end
xi.solo_modifications.applyNIN = function(player, statPower)
    addPrimaryStats(player, statPower, { xi.effect.DEX_BOOST, xi.effect.AGI_BOOST })
    addEffect(player, xi.effect.HASTE, 15 + statPower * 1.5) -- Approx 30% Haste at cap
end
xi.solo_modifications.applySAM = function(player, statPower)
    addPrimaryStats(player, statPower, { xi.effect.STR_BOOST, xi.effect.DEX_BOOST })
end
xi.solo_modifications.applyMNK = function(player, statPower)
    addPrimaryStats(player, statPower, { xi.effect.STR_BOOST, xi.effect.VIT_BOOST })
end
xi.solo_modifications.applyWAR = function(player, phalanxPower, statPower)
    addPrimaryStats(player, statPower, { xi.effect.STR_BOOST, xi.effect.VIT_BOOST })
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
        addEffect(player, xi.effect.HASTE, 15 + statPower * 1.5)
    end
    local subID = player:getEquipID(xi.slot.SUB)
    if subID > 0 then
        player:addStatusEffect(xi.effect.PHALANX, phalanxPower, 0, 0)
    end
end
xi.solo_modifications.applyTHF = function(player, statPower)
    addPrimaryStats(player, statPower, { xi.effect.DEX_BOOST, xi.effect.AGI_BOOST })
end
xi.solo_modifications.applyPLD = function(player, enPower, phalanxPower, statPower)
    player:addStatusEffect(xi.effect.ENLIGHT, enPower, 0, 0)
    addPrimaryStats(player, statPower, { xi.effect.VIT_BOOST, xi.effect.MND_BOOST })
    local subID = player:getEquipID(xi.slot.SUB)
    if subID > 0 then
        player:addStatusEffect(xi.effect.PHALANX, phalanxPower, 0, 0)
    end
end
xi.solo_modifications.applyDRK = function(player, enPower, statPower)
    player:addStatusEffect(xi.effect.ENDARK, enPower, 0, 0)
    addPrimaryStats(player, statPower, { xi.effect.STR_BOOST, xi.effect.DEX_BOOST })
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
        addEffect(player, xi.effect.HASTE, 15 + statPower * 1.5)
    end
end
xi.solo_modifications.applyDRG = function(player, statPower)
    addPrimaryStats(player, statPower, { xi.effect.STR_BOOST, xi.effect.DEX_BOOST })
    addPetEffect(player, xi.effect.REGEN, math.max(2, math.floor(statPower / 2)), 3)
    addPetEffect(player, xi.effect.HASTE, 50 + statPower * 2)
    local mainSkill = player:getWeaponSkillType(xi.slot.MAIN)
    if mainSkill == xi.skill.POLEARM then
        addEffect(player, xi.effect.HASTE, 15 + statPower * 1.5)
    end
end
xi.solo_modifications.applyRNG = function(player, statPower)
    addPrimaryStats(player, statPower, { xi.effect.DEX_BOOST, xi.effect.AGI_BOOST })
    player:addStatusEffect(xi.effect.DOUBLE_SHOT, 10 + statPower, 0, 0)
end
-- Apply buffs for a player
xi.solo_modifications.applyBuffs = function(player)
    if not player or not player:getMainJob() or not player:getMainLvl() then return end
    local mainJob = player:getMainJob()
    local playerLevel = player:getMainLvl()
    local protectPower, shellPower, regenPower, regainPower, enPower, refreshPower, phalanxPower, statPower
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
            statPower = powerData.lvl75 and playerLevel == 75 and powerData.lvl75.stat or powerData.stat
            break
        end
    end
    -- Remove all job-specific and stat boost effects
    local effectsToRemove = {
        xi.effect.VIT_BOOST, xi.effect.STR_BOOST, xi.effect.DEX_BOOST, xi.effect.AGI_BOOST, xi.effect.CHR_BOOST,
        xi.effect.MND_BOOST, xi.effect.INT_BOOST,
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
        if isTwoHanded and mainJob == xi.job.SAM then
            effectiveRegain = effectiveRegain + math.max(5, math.floor(statPower / 2))
        elseif isTwoHanded then
            effectiveRegain = effectiveRegain + 2
        end
        addEffect(player, xi.effect.REGAIN, effectiveRegain)
    end
    -- Apply job-specific buffs
    if mainJob == xi.job.WHM then
        xi.solo_modifications.applyWHM(player, enPower, refreshPower, statPower)
    elseif mainJob == xi.job.BLM then
        xi.solo_modifications.applyBLM(player, refreshPower, statPower)
    elseif mainJob == xi.job.RDM then
        xi.solo_modifications.applyRDM(player, refreshPower, enPower, statPower)
    elseif mainJob == xi.job.SMN then
        xi.solo_modifications.applySMN(player, refreshPower, statPower)
    elseif mainJob == xi.job.BRD then
        xi.solo_modifications.applyBRD(player, refreshPower, statPower)
    elseif mainJob == xi.job.BST then
        xi.solo_modifications.applyBST(player, statPower)
    elseif mainJob == xi.job.NIN then
        xi.solo_modifications.applyNIN(player, statPower)
    elseif mainJob == xi.job.SAM then
        xi.solo_modifications.applySAM(player, statPower)
    elseif mainJob == xi.job.MNK then
        xi.solo_modifications.applyMNK(player, statPower)
    elseif mainJob == xi.job.WAR then
        xi.solo_modifications.applyWAR(player, phalanxPower, statPower)
    elseif mainJob == xi.job.THF then
        xi.solo_modifications.applyTHF(player, statPower)
    elseif mainJob == xi.job.PLD then
        xi.solo_modifications.applyPLD(player, enPower, phalanxPower, statPower)
    elseif mainJob == xi.job.DRK then
        xi.solo_modifications.applyDRK(player, enPower, statPower)
    elseif mainJob == xi.job.DRG then
        xi.solo_modifications.applyDRG(player, statPower)
    elseif mainJob == xi.job.RNG then
        xi.solo_modifications.applyRNG(player, statPower)
    end
end
