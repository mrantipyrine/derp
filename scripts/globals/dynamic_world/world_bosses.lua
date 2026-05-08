-----------------------------------
-- Dynamic World: World Bosses
-----------------------------------
-- Public event bosses that can be attacked by everyone in the zone.
-- Rewards are distributed per participant instead of through normal claim loot.
-----------------------------------

require('scripts/globals/npc_util')
require('scripts/enum/claim_type')
require('scripts/enum/mob_mod')

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.worldBosses = xi.dynamicWorld.worldBosses or {}

local wb = xi.dynamicWorld.worldBosses

wb.db = wb.db or {}
wb.alive = wb.alive or {}
wb.participants = wb.participants or {}

local function normalizeKey(value)
    if type(value) ~= 'string' then
        return nil
    end

    local normalized = value:lower()
    normalized = normalized:gsub('[^%w]+', '_')
    normalized = normalized:gsub('^_+', '')
    normalized = normalized:gsub('_+$', '')
    return normalized
end

local function getCooldownVar(key, config)
    local source = config and config.cooldownKey or key
    return 'DW_WB_' .. string.upper(normalizeKey(source) or '')
end

local function getSourcePlayer(entity)
    if not entity then
        return nil
    end

    if entity.isPC and entity:isPC() then
        return entity
    end

    if entity.getMaster then
        local master = entity:getMaster()
        if master and master.isPC and master:isPC() then
            return master
        end
    end

    return nil
end

local function getScaleBand(config, level)
    for index, band in ipairs(config.scaleBands or {}) do
        if level <= band.maxLevel then
            return index, band
        end
    end

    return nil, nil
end

local function clearAppliedScale(mob)
    local prevAtt  = mob:getLocalVar('DW_WB_PREV_ATT')
    local prevAcc  = mob:getLocalVar('DW_WB_PREV_ACC')
    local prevMatt = mob:getLocalVar('DW_WB_PREV_MATT')

    if prevAtt ~= 0 then
        mob:delMod(xi.mod.ATT, prevAtt)
        mob:setLocalVar('DW_WB_PREV_ATT', 0)
    end

    if prevAcc ~= 0 then
        mob:delMod(xi.mod.ACC, prevAcc)
        mob:setLocalVar('DW_WB_PREV_ACC', 0)
    end

    if prevMatt ~= 0 then
        mob:delMod(xi.mod.MATT, prevMatt)
        mob:setLocalVar('DW_WB_PREV_MATT', 0)
    end

    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, 100)
    mob:setLocalVar('DW_WB_SCALE_IDX', 0)
    mob:setLocalVar('DW_WB_SCALE_TARGET', 0)
end

local function applyBossMods(mob, config)
    local mods = config.bossMods or {}

    if (mods.att or 0) ~= 0 then mob:addMod(xi.mod.ATT, mods.att) end
    if (mods.acc or 0) ~= 0 then mob:addMod(xi.mod.ACC, mods.acc) end
    if (mods.def or 0) ~= 0 then mob:addMod(xi.mod.DEF, mods.def) end
    if (mods.eva or 0) ~= 0 then mob:addMod(xi.mod.EVA, mods.eva) end
    if (mods.macc or 0) ~= 0 then mob:addMod(xi.mod.MACC, mods.macc) end
    if (mods.matt or 0) ~= 0 then mob:addMod(xi.mod.MATT, mods.matt) end
    if (mods.meva or 0) ~= 0 then mob:addMod(xi.mod.MEVA, mods.meva) end
    if (mods.fastCast or 0) ~= 0 then mob:addMod(xi.mod.FASTCAST, mods.fastCast) end
    if (mods.regain or 0) ~= 0 then mob:addMod(xi.mod.REGAIN, mods.regain) end
    if (mods.storeTp or 0) ~= 0 then mob:addMod(xi.mod.STORETP, mods.storeTp) end
    if (mods.refresh or 0) ~= 0 then mob:addMod(xi.mod.REFRESH, mods.refresh) end
    if (mods.refreshDown or 0) ~= 0 then mob:addMod(xi.mod.REFRESH_DOWN, mods.refreshDown) end
end

local function applyBossHealth(mob, config)
    local hpMultiplier = config.hpMultiplier or 1
    if hpMultiplier <= 1 then
        return
    end

    local baseHp = mob:getMaxHP()
    if baseHp <= 0 then
        return
    end

    local scaledHp = math.floor(baseHp * hpMultiplier)
    if scaledHp <= baseHp then
        return
    end

    mob:setMaxHP(scaledHp)
    mob:setHP(scaledHp)
end

local function applyScaleForTarget(mob, target, config)
    local scaleTarget = getSourcePlayer(target) or target
    if not scaleTarget or not scaleTarget.getMainLvl then
        clearAppliedScale(mob)
        return
    end

    local scaleTargetId = scaleTarget:getID()
    local scaleLevel = scaleTarget:getMainLvl()
    local bandIdx, band = getScaleBand(config, scaleLevel)
    if not band then
        clearAppliedScale(mob)
        return
    end

    if mob:getLocalVar('DW_WB_SCALE_IDX') == bandIdx and mob:getLocalVar('DW_WB_SCALE_TARGET') == scaleTargetId then
        return
    end

    clearAppliedScale(mob)

    local attMod = band.attMod or 0
    local accMod = band.accMod or 0
    local mattMod = band.mattMod or 0

    if attMod ~= 0 then
        mob:addMod(xi.mod.ATT, attMod)
        mob:setLocalVar('DW_WB_PREV_ATT', attMod)
    end

    if accMod ~= 0 then
        mob:addMod(xi.mod.ACC, accMod)
        mob:setLocalVar('DW_WB_PREV_ACC', accMod)
    end

    if mattMod ~= 0 then
        mob:addMod(xi.mod.MATT, mattMod)
        mob:setLocalVar('DW_WB_PREV_MATT', mattMod)
    end

    mob:setMobMod(xi.mobMod.BASE_DAMAGE_MULTIPLIER, band.baseDamageMultiplier or 100)
    mob:setLocalVar('DW_WB_SCALE_IDX', bandIdx)
    mob:setLocalVar('DW_WB_SCALE_TARGET', scaleTargetId)
end

local function markParticipant(key, mob, attacker)
    local player = getSourcePlayer(attacker)
    if not player or not player.getZoneID or player:getZoneID() ~= mob:getZoneID() then
        return
    end

    local id = player:getID()
    local participants = wb.participants[key]
    if not participants then
        participants = {}
        wb.participants[key] = participants
    end

    participants[id] =
    {
        name = player:getName(),
        taggedAt = os.time(),
    }
end

local function awardParticipantLoot(config, player)
    local awarded = {}

    for _, entry in ipairs(config.loot or {}) do
        if math.random(1000) <= (entry.rate or 0) and npcUtil.giveItem(player, entry.itemId, { silent = false }) then
            awarded[#awarded + 1] = entry.itemId
        end
    end

    if #awarded > 0 then
        player:printToPlayer(
            string.format('[World Boss] %s rewarded you for taking part in %s.', player:getName(), config.packetName),
            xi.msg.channel.SYSTEM_3
        )
    else
        player:printToPlayer(
            string.format('[World Boss] You helped defeat %s, but received no drop this time.', config.packetName),
            xi.msg.channel.SYSTEM_3
        )
    end
end

local function resolveParticipantPlayers(zone, key)
    local participants = wb.participants[key] or {}
    local players = zone:getPlayers() or {}
    local resolved = {}

    for _, player in pairs(players) do
        if player and player.isPC and player:isPC() and participants[player:getID()] then
            resolved[#resolved + 1] = player
        end
    end

    return resolved
end

local function buildGodEmperorConfig(zoneId, pos, groupRef)
    return {
        name = 'God Emperor',
        packetName = 'God Emperor',
        cooldownKey = 'god_emperor_altepa',
        modelId = 2029,
        groupRef = groupRef,
        zone = zoneId,
        pos = pos,
        level = { 255, 255 },
        speed = 40,
        modelSize = 255,
        modelHitboxSize = 10.0,
        roamDistance = 120,
        roamCool = 1,
        fightMagicCool = 12,
        hpMultiplier = 3000,
        autoSpawn = true,
        autoSpawnChance = 20,
        autoSpawnInterval = 600,
        cooldown = 24 * 3600,
        duration = 6 * 3600,
        loot =
        {
            { itemId = 20532, rate = 280 }, -- Worm Feelers
            { itemId = 20533, rate = 90  }, -- Worm Feelers +1
            { itemId = 27717, rate = 140 }, -- Worm Masque
        },
        bossMods =
        {
            att = 650,
            acc = 450,
            def = 500,
            eva = 250,
            macc = 300,
            matt = 300,
            meva = 250,
            fastCast = 35,
            regain = 250,
            storeTp = 80,
            refresh = 80,
            refreshDown = 25,
        },
        scaleBands =
        {
            { maxLevel = 20, baseDamageMultiplier = 45, attMod = -90, accMod = -45, mattMod = -35 },
            { maxLevel = 40, baseDamageMultiplier = 65, attMod = -60, accMod = -25, mattMod = -20 },
            { maxLevel = 60, baseDamageMultiplier = 82, attMod = -30, accMod = -10, mattMod = -10 },
            { maxLevel = 75, baseDamageMultiplier = 100, attMod = 0, accMod = 0, mattMod = 0 },
            { maxLevel = 99, baseDamageMultiplier = 118, attMod = 20, accMod = 10, mattMod = 15 },
        },
        spawnMsg = '[Dynamic World] The Altepa sands rupture. God Emperor erupts from below!',
        despawnMsg = '[Dynamic World] God Emperor burrows back beneath the Altepa sands.',
        deathMsg = '[Dynamic World] God Emperor collapses, shaking the Altepa dunes.',
    }
end

local function buildShowcaseBossConfig(key, zoneId, pos, groupRef, options)
    options = options or {}

    local packetName = options.packetName or options.name

    return {
        name = options.name,
        packetName = packetName,
        cooldownKey = key,
        groupRef = groupRef,
        zone = zoneId,
        pos = pos,
        level = options.level or { 99, 99 },
        speed = options.speed or 40,
        modelSize = options.modelSize or 32,
        modelHitboxSize = options.modelHitboxSize or 1.5,
        roamDistance = options.roamDistance or 50,
        roamCool = options.roamCool or 3,
        fightMagicCool = options.fightMagicCool or 20,
        hpMultiplier = options.hpMultiplier or 40,
        autoSpawn = false,
        cooldown = options.cooldown or 300,
        duration = options.duration or 1800,
        loot = options.loot or {},
        bossMods = options.bossMods or {
            att = 120,
            acc = 120,
            def = 120,
            eva = 80,
            macc = 80,
            matt = 80,
            meva = 80,
            regain = 50,
        },
        scaleBands = options.scaleBands or {
            { maxLevel = 20, baseDamageMultiplier = 55, attMod = -40, accMod = -30, mattMod = -25 },
            { maxLevel = 40, baseDamageMultiplier = 75, attMod = -20, accMod = -15, mattMod = -10 },
            { maxLevel = 60, baseDamageMultiplier = 90, attMod = -10, accMod = -5, mattMod = -5 },
            { maxLevel = 75, baseDamageMultiplier = 100, attMod = 0, accMod = 0, mattMod = 0 },
            { maxLevel = 99, baseDamageMultiplier = 112, attMod = 15, accMod = 10, mattMod = 10 },
        },
        spawnMsg = options.spawnMsg or string.format('[Dynamic World] %s appears.', packetName),
        despawnMsg = options.despawnMsg or string.format('[Dynamic World] %s disappears.', packetName),
        deathMsg = options.deathMsg or string.format('[Dynamic World] %s has been defeated.', packetName),
    }
end

wb.db.god_emperor = buildGodEmperorConfig(
    xi.zone.EASTERN_ALTEPA_DESERT,
    { x = 366.0, y = 0.0, z = 296.0, rot = 127 },
    { groupId = 6, groupZoneId = xi.zone.EASTERN_ALTEPA_DESERT }
)

wb.db.god_emperor_west = buildGodEmperorConfig(
    xi.zone.WESTERN_ALTEPA_DESERT,
    { x = -460.0, y = 6.0, z = 307.0, rot = 127 },
    { groupId = 3, groupZoneId = xi.zone.WESTERN_ALTEPA_DESERT }
)

wb.db.placeholder_spider_alpha = buildShowcaseBossConfig(
    'placeholder_spider_alpha',
    xi.zone.CRAWLERS_NEST,
    { x = -162.0, y = -0.2, z = 293.0, rot = 96 },
    { groupId = 6, groupZoneId = 52 },
    {
        name = 'Placeholder Spider Alpha',
        packetName = 'Big Spider',
        modelSize = 255,
        modelHitboxSize = 12.0,
        hpMultiplier = 90,
        spawnMsg = '[Dynamic World] A huge placeholder spider unfolds from the dark.',
        deathMsg = '[Dynamic World] The huge placeholder spider crumples into a heap.',
    }
)

wb.db.placeholder_skeleton_colossus = buildShowcaseBossConfig(
    'placeholder_skeleton_colossus',
    xi.zone.MAZE_OF_SHAKHRAMI,
    { x = 218.0, y = -24.0, z = -101.0, rot = 127 },
    { groupId = 24, groupZoneId = 2 },
    {
        name = 'Placeholder Skeleton Colossus',
        packetName = 'Big Skeleton',
        modelSize = 255,
        modelHitboxSize = 10.0,
        hpMultiplier = 75,
        spawnMsg = '[Dynamic World] A colossal placeholder skeleton rattles into view.',
        deathMsg = '[Dynamic World] The colossal placeholder skeleton collapses into bones.',
    }
)

wb.db.placeholder_skeleton_pebble = buildShowcaseBossConfig(
    'placeholder_skeleton_pebble',
    xi.zone.EAST_RONFAURE,
    { x = -133.0, y = -1.0, z = 115.0, rot = 64 },
    { groupId = 25, groupZoneId = 2 },
    {
        name = 'Placeholder Skeleton Pebble',
        packetName = 'Tiny Skeleton',
        modelSize = 12,
        modelHitboxSize = 0.7,
        hpMultiplier = 8,
        spawnMsg = '[Dynamic World] A comically tiny placeholder skeleton clatters out of the grass.',
        deathMsg = '[Dynamic World] The tiny placeholder skeleton falls apart dramatically.',
    }
)

wb.db.placeholder_crab_titan = buildShowcaseBossConfig(
    'placeholder_crab_titan',
    xi.zone.QUFIM_ISLAND,
    { x = -250.0, y = -19.0, z = 299.0, rot = 127 },
    { groupId = 2, groupZoneId = 2 },
    {
        name = 'Placeholder Crab Titan',
        packetName = 'Giant Crab',
        modelSize = 255,
        modelHitboxSize = 13.0,
        hpMultiplier = 110,
        spawnMsg = '[Dynamic World] An absurdly large placeholder crab scuttles into the open.',
        deathMsg = '[Dynamic World] The giant placeholder crab finally stops skittering.',
    }
)

wb.db.placeholder_behemoth_crumb = buildShowcaseBossConfig(
    'placeholder_behemoth_crumb',
    xi.zone.BEHEMOTHS_DOMINION,
    { x = -242.0, y = -19.8, z = 49.0, rot = 127 },
    { groupId = 9, groupZoneId = xi.zone.BEHEMOTHS_DOMINION },
    {
        name = 'Placeholder Behemoth Crumb',
        packetName = 'Tiny Behemoth',
        modelSize = 14,
        modelHitboxSize = 0.9,
        hpMultiplier = 12,
        spawnMsg = '[Dynamic World] A comically tiny placeholder behemoth stomps in with misplaced confidence.',
        deathMsg = '[Dynamic World] The tiny placeholder behemoth topples over with surprising dignity.',
    }
)

wb.resolveKey = function(query)
    if not query then
        return nil
    end

    if wb.db[query] then
        return query
    end

    local normalized = normalizeKey(query)
    if not normalized then
        return nil
    end

    for key, config in pairs(wb.db) do
        if normalizeKey(key) == normalized or normalizeKey(config.name) == normalized or normalizeKey(config.packetName) == normalized then
            return key
        end
    end

    return nil
end

wb.init = function()
    wb.alive = {}
    wb.participants = {}
    wb.lastAutoCheck = {}
end

wb.isReady = function(key)
    local config = wb.db[key]
    if not config then
        return false
    end

    local lastSpawn = GetServerVariable(getCooldownVar(key, config)) or 0
    return os.time() >= lastSpawn + (config.cooldown or 0)
end

wb.forceSpawn = function(query, player)
    local key = wb.resolveKey(query)
    local config = wb.db[key]
    if not config then
        return false, 'Unknown world boss: ' .. tostring(query)
    end

    local zone = player and player:getZone() or GetZone(config.zone)
    if not zone then
        return false, 'Could not resolve zone for world boss.'
    end

    if zone:getID() ~= config.zone then
        return false, string.format('%s can only be spawned in zone %d.', config.packetName, config.zone)
    end

    local alive = wb.alive[key]
    if alive and alive:isAlive() then
        return false, string.format('%s is already active.', config.packetName)
    end

    local entityTable =
    {
        objtype = xi.objType.MOB,
        name = config.name:gsub(' ', '_'),
        packetName = config.packetName,
        x = config.pos.x,
        y = config.pos.y,
        z = config.pos.z,
        rotation = config.pos.rot,
        groupId = config.groupRef.groupId,
        groupZoneId = config.groupRef.groupZoneId,
        minLevel = config.level[1],
        maxLevel = config.level[2],
        speed = config.speed,
        modelSize = config.modelSize,
        modelHitboxSize = config.modelHitboxSize,
        releaseIdOnDisappear = true,
        specialSpawnAnimation = false,
        isAggro = true,
        onMobSpawn = function(mob)
            wb.alive[key] = mob
            wb.participants[key] = {}
            if config.modelId and config.modelId > 0 then
                mob:setModelId(config.modelId)
            end
            mob:renameEntity(config.packetName)
            applyBossMods(mob, config)
            applyBossHealth(mob, config)
            mob:setRoamFlags(xi.roamFlag.NONE)
            mob:setMobMod(xi.mobMod.ROAM_DISTANCE, config.roamDistance or 20)
            mob:setMobMod(xi.mobMod.ROAM_COOL, config.roamCool or 8)
            mob:setMobMod(xi.mobMod.ROAM_TURNS, 6)
            mob:setMobMod(xi.mobMod.ROAM_RATE, 10)
            mob:setMobMod(xi.mobMod.MAGIC_COOL, config.roamMagicCool or 600)
            mob:setMobMod(xi.mobMod.CHECK_AS_NM, 1)
            mob:setMobMod(xi.mobMod.NO_LINK, 1)
            mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.NON_EXCLUSIVE)
            mob:setLocalVar('DW_WB_KEY_HASH', 0)
            mob:addListener('TAKE_DAMAGE', 'DW_WB_TAG_' .. key, function(target, amount, attacker)
                if amount and amount > 0 then
                    markParticipant(key, target, attacker)
                end
            end)
            mob:timer((config.duration or 1200) * 1000, function(mobArg)
                if mobArg and mobArg:isAlive() then
                    local z = mobArg:getZone()
                    if z then
                        xi.dynamicWorld.announceZone(z, config.despawnMsg)
                    end
                    wb.alive[key] = nil
                    wb.participants[key] = nil
                    clearAppliedScale(mobArg)
                    mobArg:setStatus(xi.status.DISAPPEAR)
                end
            end)
        end,
        onMobEngage = function(mob, target)
            mob:setMobMod(xi.mobMod.MAGIC_COOL, config.fightMagicCool or 12)
            applyScaleForTarget(mob, target, config)
        end,
        onMobFight = function(mob, target)
            applyScaleForTarget(mob, target, config)
        end,
        onMobSpellChoose = function(mob, target, spell)
            if not mob:isEngaged() or not target or not target:isAlive() then
                return 0
            end

            local options =
            {
                xi.magic.spell.STONE_IV,
                xi.magic.spell.STONEGA_III,
                xi.magic.spell.QUAKE,
                xi.magic.spell.RASP,
                xi.magic.spell.BIND,
            }

            return options[math.random(1, #options)], target
        end,
        onMobDisengage = function(mob)
            mob:setMobMod(xi.mobMod.MAGIC_COOL, config.roamMagicCool or 600)
            clearAppliedScale(mob)
        end,
        onMobDeath = function(mob, killer, optParams)
            local zoneArg = mob:getZone()
            SetServerVariable(getCooldownVar(key, config), os.time())
            clearAppliedScale(mob)
            wb.alive[key] = nil

            if zoneArg then
                xi.dynamicWorld.announceZone(zoneArg, config.deathMsg)
                for _, participant in ipairs(resolveParticipantPlayers(zoneArg, key)) do
                    awardParticipantLoot(config, participant)
                end
            end

            wb.participants[key] = nil
        end,
        onMobDespawn = function(mob)
            clearAppliedScale(mob)
            wb.alive[key] = nil
            wb.participants[key] = nil
        end,
    }

    local mob = zone:insertDynamicEntity(entityTable)
    if not mob then
        return false, string.format('Failed to create %s.', config.packetName)
    end

    mob:setSpawn(config.pos.x, config.pos.y, config.pos.z, config.pos.rot)
    mob:spawn()
    SetServerVariable(getCooldownVar(key, config), os.time())
    xi.dynamicWorld.announceZone(zone, config.spawnMsg)

    return true, string.format('%s spawned in zone %d.', config.packetName, config.zone)
end

wb.getStatus = function()
    local out = {}
    local now = os.time()

    for key, config in pairs(wb.db) do
        local alive = wb.alive[key]
        local lastSpawn = GetServerVariable(getCooldownVar(key, config)) or 0
        local readyAt = lastSpawn + (config.cooldown or 0)
        out[#out + 1] =
        {
            key = key,
            name = config.packetName,
            alive = alive and alive:isAlive() or false,
            ready = now >= readyAt,
            timeLeft = math.max(0, readyAt - now),
        }
    end

    table.sort(out, function(a, b)
        return a.name < b.name
    end)

    return out
end

wb.tick = function(zone)
    local now = os.time()

    for key, config in pairs(wb.db) do
        if config.autoSpawn and zone:getID() == config.zone and wb.isReady(key) then
            local alive = wb.alive[key]
            if not alive or not alive:isAlive() then
                wb.lastAutoCheck = wb.lastAutoCheck or {}
                local timerKey = string.format('%s:%u', key, zone:getID())
                local interval = config.autoSpawnInterval or 600
                local lastCheck = wb.lastAutoCheck[timerKey] or 0

                if now - lastCheck >= interval then
                    wb.lastAutoCheck[timerKey] = now

                    local players = zone:getPlayers() or {}
                    if next(players) and math.random(1000) <= (config.autoSpawnChance or 0) then
                        wb.forceSpawn(key, players[1])
                    end
                end
            end
        end
    end
end

return wb
