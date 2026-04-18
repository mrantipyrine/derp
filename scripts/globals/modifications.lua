-- Initialize solo modifications namespace
xi = xi or {}
xi.modifications = xi.modifications or {}

-- Define power values for each level range
local levelPowerTable = {
    { level = 65, protect = 150, shell = 2800, regen = 60, regain = 45, en = 120, refresh = 0, lvl75 = { regain = 50, en = 140, refresh = 15 } },
    { level = 50, protect = 120, shell = 2500, regen = 25, regain = 40, en = 80, refresh = 12 },
    { level = 35, protect = 90, shell = 2000, regen = 20, regain = 35, en = 60, refresh = 9 },
    { level = 20, protect = 60, shell = 1800, regen = 10, regain = 30, en = 40, refresh = 6 },
    { level = 0, protect = 20, shell = 25, regen = 5, regain = 20, en = 20, refresh = 4 }
}

-- Job-specific buff functions
xi.modifications.applyWHM = function(player, enPower, refreshPower)
    player:addStatusEffect(xi.effect.ENLIGHT, enPower, 0, 0)
    player:addStatusEffect(xi.effect.MND_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.INT_BOOST, math.floor(player:getMainLvl() / 2), 0, 0)
    if refreshPower > 0 then
        player:addStatusEffect(xi.effect.REFRESH, refreshPower, 0, 0)
    end
end

xi.modifications.applyBLM = function(player, refreshPower)
    if refreshPower > 0 then
        player:addStatusEffect(xi.effect.REFRESH, refreshPower, 0, 0)
    end
    player:addStatusEffect(xi.effect.INT_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.MND_BOOST, math.floor(player:getMainLvl() / 2), 0, 0)
end

xi.modifications.applyRDM = function(player, refreshPower, enPower)
    local elements = { xi.effect.ENFIRE, xi.effect.ENBLIZZARD, xi.effect.ENAERO, xi.effect.ENSTONE, xi.effect.ENTHUNDER, xi.effect.ENWATER }
    local randomElement = elements[math.random(1, #elements)]
    player:addStatusEffect(randomElement, enPower, 0, 0)
    player:addStatusEffect(xi.effect.INT_BOOST, math.floor(player:getMainLvl() / 1.5), 0, 0)
    player:addStatusEffect(xi.effect.MND_BOOST, math.floor(player:getMainLvl() / 1.5), 0, 0)
    if refreshPower > 0 then
        player:addStatusEffect(xi.effect.REFRESH, refreshPower, 0, 0)
    end
end

xi.modifications.applySMN = function(player, refreshPower)
    player:addStatusEffect(xi.effect.INT_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.MND_BOOST, math.floor(player:getMainLvl() / 1.5), 0, 0)
    if refreshPower > 0 then
        player:addStatusEffect(xi.effect.REFRESH, refreshPower, 0, 0)
    end
    -- 75 Era Buff: Massive Perpetuation reduction for solo/small group
    player:addMod(xi.mod.AVATAR_PERPETUATION, -15)
end

xi.modifications.applyBRD = function(player, refreshPower)
    player:addStatusEffect(xi.effect.CHR_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.MND_BOOST, math.floor(player:getMainLvl() / 1.5), 0, 0)
    if refreshPower > 0 then
        player:addStatusEffect(xi.effect.REFRESH, refreshPower, 0, 0)
    end
end

xi.modifications.applyBST = function(player)
    player:addStatusEffect(xi.effect.STR_BOOST, math.floor(player:getMainLvl() / 2), 0, 0)
    player:addStatusEffect(xi.effect.CHR_BOOST, player:getMainLvl(), 0, 0)
end

xi.modifications.applyNIN = function(player)
    player:addStatusEffect(xi.effect.AGI_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.DEX_BOOST, math.floor(player:getMainLvl() / 2), 0, 0)
end

xi.modifications.applySAM = function(player)
    player:addStatusEffect(xi.effect.STR_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.DEX_BOOST, math.floor(player:getMainLvl() / 2), 0, 0)
end

xi.modifications.applyMNK = function(player)
    player:addStatusEffect(xi.effect.VIT_BOOST, math.floor(player:getMainLvl() / 2), 0, 0)
    player:addStatusEffect(xi.effect.STR_BOOST, player:getMainLvl(), 0, 0)
end

xi.modifications.applyWAR = function(player)
    player:addStatusEffect(xi.effect.STR_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.VIT_BOOST, math.floor(player:getMainLvl() / 2), 0, 0)
end

xi.modifications.applyTHF = function(player)
    player:addStatusEffect(xi.effect.DEX_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.AGI_BOOST, math.floor(player:getMainLvl() / 1.25), 0, 0)
end

xi.modifications.applyPLD = function(player, enPower)
    player:addStatusEffect(xi.effect.ENLIGHT, enPower, 0, 0)
    player:addStatusEffect(xi.effect.VIT_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.STR_BOOST, math.floor(player:getMainLvl() / 2), 0, 0)
end

xi.modifications.applyDRK = function(player, enPower)
    player:addStatusEffect(xi.effect.ENDARK, enPower, 0, 0)
    player:addStatusEffect(xi.effect.STR_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.DEX_BOOST, math.floor(player:getMainLvl() / 2), 0, 0)
end

xi.modifications.applyDRG = function(player)
    player:addStatusEffect(xi.effect.STR_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.DEX_BOOST, math.floor(player:getMainLvl() / 1.25), 0, 0)
end

xi.modifications.applyRNG = function(player)
    player:addStatusEffect(xi.effect.DOUBLE_SHOT, 0, 0, 0)
    player:addStatusEffect(xi.effect.AGI_BOOST, player:getMainLvl(), 0, 0)
    player:addStatusEffect(xi.effect.DEX_BOOST, math.floor(player:getMainLvl() / 0.75), 0, 0)
end

-- Apply buffs for a player
xi.modifications.applyBuffs = function(player)
    if not player or not player:getMainJob() or not player:getMainLvl() then return end

    local mainJob = player:getMainJob()
    local playerLevel = player:getMainLvl()
    local protectPower, shellPower, regenPower, regainPower, enPower, refreshPower

    -- Set power values from levelPowerTable
    for _, powerData in ipairs(levelPowerTable) do
        if playerLevel >= powerData.level then
            protectPower = powerData.protect
            shellPower = powerData.shell
            regenPower = powerData.regen
            regainPower = powerData.lvl75 and playerLevel == 75 and powerData.lvl75.regain or powerData.regain
            enPower = powerData.lvl75 and playerLevel == 75 and powerData.lvl75.en or powerData.en
            refreshPower = powerData.lvl75 and playerLevel == 75 and powerData.lvl75.refresh or powerData.refresh
            break
        end
    end

    -- Remove all job-specific and stat boost effects
    local effectsToRemove = {
        xi.effect.VIT_BOOST, xi.effect.STR_BOOST, xi.effect.DEX_BOOST, xi.effect.AGI_BOOST, xi.effect.CHR_BOOST,
        xi.effect.MND_BOOST, xi.effect.INT_BOOST, xi.effect.ENLIGHT, xi.effect.ENDARK, xi.effect.DOUBLE_SHOT,
        xi.effect.REFRESH, xi.effect.ENFIRE, xi.effect.ENBLIZZARD, xi.effect.ENAERO, xi.effect.ENSTONE,
        xi.effect.ENTHUNDER, xi.effect.ENWATER, xi.effect.REGAIN, xi.effect.PROTECT, xi.effect.SHELL, xi.effect.REGEN
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

    -- Apply buffs
    if not isMage then
        player:addStatusEffect(xi.effect.REGAIN, regainPower, 0, 0)
    end
    -- Global buffs
    player:addStatusEffect(xi.effect.PROTECT, protectPower, 0, 0)
    player:addStatusEffect(xi.effect.SHELL, shellPower, 0, 0)
    player:addStatusEffect(xi.effect.REGEN, regenPower, 0, 0)

        -- Apply job-specific buffs
        if mainJob == xi.job.WHM then
            xi.modifications.applyWHM(player, enPower, refreshPower)
        elseif mainJob == xi.job.BLM then
            xi.modifications.applyBLM(player, refreshPower)
        elseif mainJob == xi.job.RDM then
            xi.modifications.applyRDM(player, refreshPower, enPower)
        elseif mainJob == xi.job.SMN then
            xi.modifications.applySMN(player, refreshPower)
        elseif mainJob == xi.job.BRD then
            xi.modifications.applyBRD(player, refreshPower)
        elseif mainJob == xi.job.BST then
            xi.modifications.applyBST(player)
        elseif mainJob == xi.job.NIN then
            xi.modifications.applyNIN(player)
        elseif mainJob == xi.job.SAM then
            xi.modifications.applySAM(player)
        elseif mainJob == xi.job.MNK then
            xi.modifications.applyMNK(player)
        elseif mainJob == xi.job.WAR then
            xi.modifications.applyWAR(player)
        elseif mainJob == xi.job.THF then
            xi.modifications.applyTHF(player)
        elseif mainJob == xi.job.PLD then
            xi.modifications.applyPLD(player, enPower)
        elseif mainJob == xi.job.DRK then
            xi.modifications.applyDRK(player, enPower)
        elseif mainJob == xi.job.DRG then
            xi.modifications.applyDRG(player)
        elseif mainJob == xi.job.RNG then
            xi.modifications.applyRNG(player)
        end
    end
