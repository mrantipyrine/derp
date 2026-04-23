-----------------------------------
-- GM Command: !dynworld
-----------------------------------
-- Usage:
--   !dynworld status           - Show system status
--   !dynworld spawn [tier] [n] - Force spawn N entities of tier in current zone
--   !dynworld clear            - Despawn all dynamic entities in current zone
--   !dynworld start            - Start the system
--   !dynworld stop             - Stop the system (no new spawns)
--   !dynworld info             - Show entities in current zone
--   !dynworld synergies        - List all item synergies
--   !dynworld chain            - Show your chain info
--
-- Tier values: 1=Wanderer, 2=Nomad, 3=Elite, 4=Apex, 5=Power King
-----------------------------------
require('scripts/globals/dynamic_world')
-----------------------------------

---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 3,
    parameters = 's',
}

local function printErr(player, msg)
    player:printToPlayer(msg, xi.msg.channel.SYSTEM_3)
end

local skirmishFactions =
{
    goblin =
    {
        packetName = 'Goblin Raider',
        groupRefs =
        {
            { groupId = 23, groupZoneId = 4 },
            { groupId = 25, groupZoneId = 4 },
            { groupId = 27, groupZoneId = 4 },
        },
    },
    orc =
    {
        packetName = 'Orc Raider',
        groupRefs =
        {
            { groupId = 14, groupZoneId = 2 },
            { groupId = 15, groupZoneId = 2 },
            { groupId = 21, groupZoneId = 2 },
        },
    },
    quadav =
    {
        packetName = 'Quadav Raider',
        groupRefs =
        {
            { groupId = 76, groupZoneId = 37 },
            { groupId = 77, groupZoneId = 37 },
            { groupId = 78, groupZoneId = 37 },
        },
    },
    yagudo =
    {
        packetName = 'Yagudo Raider',
        groupRefs =
        {
            { groupId = 82, groupZoneId = 37 },
            { groupId = 83, groupZoneId = 37 },
            { groupId = 84, groupZoneId = 37 },
        },
    },
}

local function pickGroupRef(refs)
    return refs[math.random(#refs)]
end

local function buildSkirmishOffsets(count, baseAngle, distance)
    local offsets = {}
    local spacing = 2.2
    local lateralStart = -((count - 1) * spacing) * 0.5

    for i = 1, count do
        local lateral = lateralStart + ((i - 1) * spacing)
        offsets[#offsets + 1] =
        {
            x = math.cos(baseAngle) * distance + math.cos(baseAngle + math.pi / 2) * lateral,
            z = math.sin(baseAngle) * distance + math.sin(baseAngle + math.pi / 2) * lateral,
        }
    end

    return offsets
end

local function trackSkirmishEntity(zoneId, entity, packetName, faction, minLevel, maxLevel)
    local state = xi.dynamicWorld.state
    local zd = state.zoneData[zoneId]
    if not zd then
        return
    end

    local targid = entity:getTargID()
    zd.entities[targid] =
    {
        entity = entity,
        templateKey = 'skirmish_' .. faction,
        tier = 0,
        spawnTime = os.time(),
        zoneId = zoneId,
        minLevel = minLevel,
        maxLevel = maxLevel,
        isSkirmish = true,
        packetName = packetName,
        faction = faction,
    }
    zd.count = zd.count + 1
    state.globalCount = state.globalCount + 1

    entity:addListener('DESPAWN', 'DW_SKIRMISH_DESPAWN_' .. targid, function(mob)
        xi.dynamicWorld.spawner.onEntityDespawn(mob, zd, state, targid)
    end)
end

local function countLiving(pack)
    local living = 0
    for _, mob in ipairs(pack) do
        if mob and mob:isAlive() then
            living = living + 1
        end
    end
    return living
end

local function retireSkirmishPack(pack, factionKey)
    local faction = skirmishFactions[factionKey]
    for _, mob in ipairs(pack) do
        if mob and mob:isAlive() then
            mob:disengage()
            mob:setMobMod(xi.mobMod.NO_AGGRO, 1)
            mob:setMobMod(xi.mobMod.NO_LINK, 1)
            mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 18)
            mob:setMobMod(xi.mobMod.ROAM_COOL, 5)
            mob:spawn(12)
        end
    end

    local anchor = pack[1]
    if anchor and anchor:isAlive() then
        xi.dynamicWorld.announceNearby(
            anchor:getZone(),
            anchor,
            80,
            string.format('[Dynamic World] %s scatter after the skirmish.', faction and faction.packetName or factionKey)
        )
    end
end

local function spawnSkirmishMob(zone, factionKey, pos, minLevel, maxLevel, allegiance)
    local faction = skirmishFactions[factionKey]
    if not faction then
        return nil
    end

    local chosenRef = pickGroupRef(faction.groupRefs)
    local entity = zone:insertDynamicEntity({
        objtype = xi.objType.MOB,
        allegiance = allegiance or xi.allegiance.MOB,
        name = faction.packetName:gsub(' ', '_'),
        packetName = faction.packetName,
        x = pos.x,
        y = pos.y,
        z = pos.z,
        rotation = pos.rot,
        groupId = chosenRef.groupId,
        groupZoneId = chosenRef.groupZoneId,
        minLevel = minLevel,
        maxLevel = maxLevel,
        releaseIdOnDisappear = true,
        specialSpawnAnimation = true,
        onMobSpawn = function(mob)
            mob:renameEntity(faction.packetName)
            mob:setMobMod(xi.mobMod.NO_DROPS, 1)
            mob:setMobMod(xi.mobMod.EXP_BONUS, -100)
            mob:setMobMod(xi.mobMod.GIL_BONUS, -100)
            mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.NON_EXCLUSIVE)
            mob:setMobMod(xi.mobMod.NO_LINK, 1)
            mob:setMobMod(xi.mobMod.NO_AGGRO, 1)
            mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 5)
            mob:setMobMod(xi.mobMod.ROAM_COOL, 8)
            mob:addMod(xi.mod.ATT, 10)
            mob:addMod(xi.mod.DEF, 10)
            mob:addMod(xi.mod.ACC, 10)
        end,
    })

    if not entity then
        return nil
    end

    entity:setSpawn(pos.x, pos.y, pos.z, pos.rot)
    entity:spawn()
    trackSkirmishEntity(zone:getID(), entity, faction.packetName, factionKey, minLevel, maxLevel)

    return entity
end

local function rescueGoblin(goblin, orc, rescuer)
    if not goblin or not goblin:isAlive() or not orc or not orc:isAlive() then
        return
    end

    if orc:getLocalVar('DW_SKIRMISH_RESCUED') == 1 or goblin:getLocalVar('DW_SKIRMISH_RESCUED') == 1 then
        return
    end

    orc:setLocalVar('DW_SKIRMISH_RESCUED', 1)
    goblin:setLocalVar('DW_SKIRMISH_RESCUED', 1)
    goblin:setUntargetable(true)
    goblin:setIsAggroable(false)
    goblin:setAllegiance(xi.allegiance.PLAYER)
    goblin:setMobMod(xi.mobMod.NO_AGGRO, 1)
    goblin:setMobMod(xi.mobMod.NO_LINK, 1)
    goblin:addMod(xi.mod.ATT, 20)
    goblin:addMod(xi.mod.ACC, 15)

    if goblin.addBaseEnmity then
        goblin:addBaseEnmity(orc)
    end
    goblin:addEnmity(orc, 120, 120)
    goblin:updateEnmity(orc)
    orc:addEnmity(goblin, 120, 120)
    orc:updateEnmity(goblin)

    local zone = goblin:getZone()
    if zone then
        xi.dynamicWorld.announceNearby(
            zone,
            goblin,
            80,
            string.format('[Dynamic World] %s rallies to %s after your strike!',
                goblin:getName(), rescuer and rescuer:getName() or 'your side')
        )
    end
end

local function attachRescueHook(orc, goblin)
    if not orc or not goblin then
        return
    end

    local listenerId = 'DW_SKIRMISH_RESCUE_' .. orc:getTargID()
    orc:addListener('TAKE_DAMAGE', listenerId, function(target, amount, attacker)
        if amount <= 0 or not attacker or not attacker.isPC or not attacker:isPC() then
            return
        end

        rescueGoblin(goblin, target, attacker)
    end)
end

local function startSkirmish(packA, packB)
    if #packA == 0 or #packB == 0 then
        return
    end

    local function seedBattle(sourcePack, targetPack)
        for i, mob in ipairs(sourcePack) do
            if mob and mob:isAlive() then
                local target = targetPack[((i - 1) % #targetPack) + 1]
                if target and target:isAlive() then
                    if mob.addBaseEnmity then
                        mob:addBaseEnmity(target)
                    end
                    mob:addEnmity(target, 60, 60)
                    mob:updateEnmity(target)
                end
            end
        end
    end

    seedBattle(packA, packB)
    seedBattle(packB, packA)
end

local function reinforceSkirmish(packA, packB, pulsesLeft)
    if pulsesLeft <= 0 then
        return
    end

    startSkirmish(packA, packB)

    local anchor = packA[1] or packB[1]
    if anchor and anchor.timer then
        anchor:timer(1500, function()
            reinforceSkirmish(packA, packB, pulsesLeft - 1)
        end)
    end
end

local function monitorSkirmish(packA, packB, factionA, factionB)
    local livingA = countLiving(packA)
    local livingB = countLiving(packB)

    if livingA == 0 and livingB == 0 then
        return
    end

    if livingA == 0 then
        if factionB == 'goblin' then
            retireSkirmishPack(packB, factionB)
        end
        return
    end

    if livingB == 0 then
        if factionA == 'goblin' then
            retireSkirmishPack(packA, factionA)
        end
        return
    end

    local anchor = packA[1] or packB[1]
    if anchor and anchor.timer then
        anchor:timer(3000, function()
            monitorSkirmish(packA, packB, factionA, factionB)
        end)
    end
end

local function showHelp(player)
    player:printToPlayer('[DynWorld] Commands: status, spawn [tier] [count], clear, start, stop, info, synergies, chain, rares, rare [key], skirmish [left] [right] [count]', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('[DynWorld] Tiers: 1=Wanderer, 2=Nomad, 3=Elite, 4=Apex, 5=Power King', xi.msg.channel.SYSTEM_3)
end

local function cmdStatus(player)
    local status = xi.dynamicWorld.getStatus()
    player:printToPlayer(string.format('[DynWorld] Running: %s | Total: %d | Zones: %d',
        tostring(status.running), status.globalCount, status.activeZones), xi.msg.channel.SYSTEM_3)
    player:printToPlayer(string.format('[DynWorld] Wanderers: %d | Nomads: %d | Elites: %d | Apex: %d | Power Kings: %d',
        status.wanderers, status.nomads, status.elites, status.apex, status.powerKings), xi.msg.channel.SYSTEM_3)

    -- Diagnostics
    local state  = xi.dynamicWorld.state
    local cfg    = xi.settings.dynamicworld
    player:printToPlayer(string.format('[DynWorld] Diag: initialized=%s | eligibleZones=%d | settings=%s | ENABLED=%s',
        tostring(state and state.initialized),
        state and xi.dynamicWorld.countKeys(state.eligibleZones) or 0,
        tostring(cfg ~= nil),
        tostring(cfg and cfg.ENABLED)), xi.msg.channel.SYSTEM_3)
end

local function cmdSpawn(player, tier, count)
    tier = math.max(1, math.min(5, tier))
    count = math.max(1, math.min(20, count))

    local zone = player:getZone()
    if not zone then
        printErr(player, '[DynWorld] Error: Could not get zone.')
        return
    end

    if not xi.dynamicWorld.state.initialized then
        xi.dynamicWorld.init()
    end

    local spawned = xi.dynamicWorld.forceSpawn(zone, tier, count)
    local tierName = xi.dynamicWorld.tierName[tier] or 'Unknown'
    player:printToPlayer(string.format('[DynWorld] Spawned %d/%d %s entities in zone %d.',
        spawned, count, tierName, zone:getID()), xi.msg.channel.SYSTEM_3)
end

local function cmdClear(player)
    local zone = player:getZone()
    if not zone then
        printErr(player, '[DynWorld] Error: Could not get zone.')
        return
    end

    local cleared = xi.dynamicWorld.clearZone(zone)
    player:printToPlayer(string.format('[DynWorld] Cleared %d dynamic world entities from zone %d.',
        cleared, zone:getID()), xi.msg.channel.SYSTEM_3)
end

local function cmdStart(player)
    xi.dynamicWorld.start()
    player:printToPlayer('[DynWorld] System started.', xi.msg.channel.SYSTEM_3)
end

local function cmdStop(player)
    xi.dynamicWorld.stop()
    player:printToPlayer('[DynWorld] System stopped. Existing entities remain.', xi.msg.channel.SYSTEM_3)
end

local function cmdInfo(player)
    local zone = player:getZone()
    if not zone then
        return
    end

    local zoneId = zone:getID()
    local state = xi.dynamicWorld.state
    local zd = state.zoneData[zoneId]

    if not zd or zd.count == 0 then
        player:printToPlayer(string.format('[DynWorld] No dynamic world entities in zone %d.', zoneId),
            xi.msg.channel.SYSTEM_3)
        return
    end

    player:printToPlayer(string.format('[DynWorld] Zone %d: %d entities', zoneId, zd.count),
        xi.msg.channel.SYSTEM_3)

    local count = 0
    for targid, entData in pairs(zd.entities) do
        if count >= 10 then
            player:printToPlayer('[DynWorld] ... (showing first 10)', xi.msg.channel.SYSTEM_3)
            break
        end

        local template = xi.dynamicWorld.templates.get(entData.templateKey)
        local name = template and template.packetName or 'Unknown'
        local tierName = xi.dynamicWorld.tierName[entData.tier] or '?'
        local alive = (entData.entity and entData.entity:isAlive()) and 'Alive' or 'Dead'

        -- Get current position if entity is alive
        local posStr = ''
        if entData.entity and entData.entity:isAlive() then
            local x = entData.entity:getXPos()
            local y = entData.entity:getYPos()
            local z = entData.entity:getZPos()
            if x and y and z then
                local grid = xi.dynamicWorld.posToGrid(x, z, zoneId)
                posStr = string.format(' @ %s (%.1f, %.1f, %.1f)', grid, x, y, z)
            end
        end

        player:printToPlayer(string.format('  [%s] %s (Lv%d-%d) [%s]%s',
            tierName, name, entData.minLevel or 0, entData.maxLevel or 0, alive, posStr),
            xi.msg.channel.SYSTEM_3)
        count = count + 1
    end
end

local function cmdSynergies(player)
    local synergyList = xi.dynamicWorld.synergies.list()
    player:printToPlayer(string.format('[DynWorld] %d synergies registered:', #synergyList),
        xi.msg.channel.SYSTEM_3)
    for _, s in ipairs(synergyList) do
        local comboStr = s.isCombo and ' [COMBO]' or ''
        player:printToPlayer(string.format('  %s (%s)%s - %s',
            s.name, s.type, comboStr, s.description), xi.msg.channel.SYSTEM_3)
    end
end

local function cmdChain(player)
    local charId = player:getID()
    local chain = xi.dynamicWorld.state.playerChains[charId]
    if not chain then
        player:printToPlayer('[DynWorld] No active hunt chain.', xi.msg.channel.SYSTEM_3)
        return
    end

    local elapsed = os.time() - chain.lastKill
    local window = (xi.settings.dynamicworld and xi.settings.dynamicworld.CHAIN_WINDOW) or 180
    local remaining = window - elapsed
    local bonus = math.min(
        chain.count * ((xi.settings.dynamicworld and xi.settings.dynamicworld.CHAIN_BONUS_PER_KILL) or 0.15),
        (xi.settings.dynamicworld and xi.settings.dynamicworld.CHAIN_BONUS_MAX) or 2.0
    )

    player:printToPlayer(string.format('[DynWorld] Chain: x%d | Bonus: +%d%% EXP | Time left: %ds',
        chain.count, math.floor(bonus * 100), math.max(0, remaining)), xi.msg.channel.SYSTEM_3)
end

local function cmdSkirmish(player, leftKey, rightKey, count)
    local zone = player:getZone()
    if not zone then
        printErr(player, '[DynWorld] Error: Could not get zone.')
        return
    end

    if not xi.dynamicWorld.state.initialized then
        xi.dynamicWorld.init()
    end

    local zoneId = zone:getID()
    if not xi.dynamicWorld.state.eligibleZones[zoneId] then
        printErr(player, string.format('[DynWorld] Zone %d is not enabled for dynamic-world skirmishes.', zoneId))
        return
    end

    leftKey = string.lower(leftKey or 'goblin')
    rightKey = string.lower(rightKey or 'orc')
    count = math.max(1, math.min(6, tonumber(count) or 3))

    if not skirmishFactions[leftKey] then
        printErr(player, string.format('[DynWorld] Unknown skirmish faction: %s', tostring(leftKey)))
        return
    end

    if not skirmishFactions[rightKey] then
        printErr(player, string.format('[DynWorld] Unknown skirmish faction: %s', tostring(rightKey)))
        return
    end

    if leftKey == rightKey then
        printErr(player, '[DynWorld] Skirmish factions must be different.')
        return
    end

    local minLevel, maxLevel = xi.dynamicWorld.getDynamicLevelRange(
        zoneId,
        xi.dynamicWorld.tier.ELITE,
        nil,
        99,
        { keepInsideZone = true }
    )

    local px = player:getXPos()
    local py = player:getYPos()
    local pz = player:getZPos()
    local baseAngle = math.random() * math.pi * 2
    local leftOffsets = buildSkirmishOffsets(count, baseAngle, 10)
    local rightOffsets = buildSkirmishOffsets(count, baseAngle + math.pi, 10)
    local leftPack = {}
    local rightPack = {}

    for i = 1, count do
        local leftPos =
        {
            x = px + leftOffsets[i].x,
            y = py,
            z = pz + leftOffsets[i].z,
            rot = math.random(0, 255),
        }
        local rightPos =
        {
            x = px + rightOffsets[i].x,
            y = py,
            z = pz + rightOffsets[i].z,
            rot = math.random(0, 255),
        }

        local leftMob = spawnSkirmishMob(zone, leftKey, leftPos, minLevel, maxLevel, xi.allegiance.PLAYER)
        local rightMob = spawnSkirmishMob(zone, rightKey, rightPos, minLevel, maxLevel, xi.allegiance.MOB)
        if leftMob then
            leftPack[#leftPack + 1] = leftMob
        end
        if rightMob then
            rightPack[#rightPack + 1] = rightMob
        end
        if leftMob and rightMob and leftKey == 'goblin' then
            attachRescueHook(rightMob, leftMob)
        elseif leftMob and rightMob and rightKey == 'goblin' then
            attachRescueHook(leftMob, rightMob)
        end
    end

    if #leftPack == 0 or #rightPack == 0 then
        printErr(player, '[DynWorld] Failed to spawn one or both skirmish packs.')
        return
    end

    leftPack[1]:timer(1000, function()
        reinforceSkirmish(leftPack, rightPack, 4)
    end)
    leftPack[1]:timer(4000, function()
        monitorSkirmish(leftPack, rightPack, leftKey, rightKey)
    end)

    player:printToPlayer(
        string.format('[DynWorld] Skirmish started: %s vs %s (%d per side) at Lv%d-%d.',
            leftKey, rightKey, math.min(#leftPack, #rightPack), minLevel, maxLevel),
        xi.msg.channel.SYSTEM_3
    )
end

local function cmdTest(player)
    local p = function(msg) player:printToPlayer('[DWTest] ' .. msg, xi.msg.channel.SYSTEM_3) end
    local zone   = player:getZone()
    local zoneId = zone:getID()
    local state  = xi.dynamicWorld.state

    p(string.format('Zone: %d | initialized: %s | running: %s',
        zoneId, tostring(state.initialized), tostring(state.running)))

    -- Step 1: ensure init
    if not state.initialized then
        xi.dynamicWorld.init()
        p('Called init(). initialized now: ' .. tostring(state.initialized))
    end

    -- Step 2: region lookup
    local region = state.zoneToRegion[zoneId]
    p('Region: ' .. tostring(region))

    -- Step 3: template candidates for tier 1
    local candidates = xi.dynamicWorld.templates.getForTierAndRegion(1, region)
    p(string.format('Tier-1 candidates for region "%s": %d', tostring(region), #candidates))
    if #candidates == 0 then
        candidates = xi.dynamicWorld.templates.getForTierAndRegion(1, nil)
        p('Fallback (no region): ' .. #candidates .. ' candidates')
    end
    if #candidates == 0 then
        p('FAIL: no templates available at all for tier 1')
        return
    end

    local chosen   = candidates[1]
    local template = chosen.template
    p('Template: ' .. template.name)

    -- Step 4: spawn point
    local pos = xi.dynamicWorld.getRandomSpawnPoint(zone, player)
    if not pos then
        p('FAIL: getRandomSpawnPoint returned nil')
        return
    end
    p(string.format('SpawnPoint: %.1f, %.1f, %.1f', pos.x, pos.y, pos.z))

    -- Step 5: groupRef
    local refs = template.groupRefs
    local ref  = refs and refs[1] or template.groupRef
    if not ref then
        p('FAIL: no groupRef on template')
        return
    end
    p(string.format('GroupRef: groupId=%d groupZoneId=%d', ref.groupId, ref.groupZoneId))

    -- Step 6: level range
    local lr  = xi.dynamicWorld.getZoneLevelRange(zoneId)
    local min = math.max(1, lr[1] + (template.levelOffset[1] or 0))
    local max = math.max(min, lr[2] + (template.levelOffset[2] or 0))
    p(string.format('Levels: %d-%d', min, max))

    -- Step 7: insertDynamicEntity
    local entityTable = {
        objtype     = xi.objType.MOB,
        name        = template.name:gsub(' ', '_') .. '_TEST',
        packetName  = template.packetName,
        x           = pos.x,
        y           = pos.y,
        z           = pos.z,
        rotation    = pos.rot,
        groupId     = ref.groupId,
        groupZoneId = ref.groupZoneId,
        minLevel    = min,
        maxLevel    = max,
        releaseIdOnDisappear  = true,
        specialSpawnAnimation = true,
    }

    local ok, entity = pcall(function() return zone:insertDynamicEntity(entityTable) end)
    if not ok then
        p('FAIL: insertDynamicEntity threw error: ' .. tostring(entity))
        return
    end
    if not entity then
        p('FAIL: insertDynamicEntity returned nil')
        return
    end
    p('insertDynamicEntity OK. targID: ' .. tostring(entity:getTargID()))

    -- Step 8: setSpawn + spawn
    local ok2, err2 = pcall(function()
        entity:setSpawn(pos.x, pos.y, pos.z, pos.rot)
        entity:spawn()
    end)
    if not ok2 then
        p('FAIL: spawn() threw error: ' .. tostring(err2))
        return
    end
    p('spawn() OK. isSpawned: ' .. tostring(entity:isSpawned()))
    p('SUCCESS - check your surroundings for ' .. template.packetName)
end

commandObj.onTrigger = function(player, args)
    if not args or args == '' then
        showHelp(player)
        return
    end

    local parts = {}
    for word in args:gmatch('%S+') do
        table.insert(parts, word)
    end

    local subcommand = parts[1]:lower()

    if subcommand == 'status' then
        cmdStatus(player)
    elseif subcommand == 'spawn' then
        local tier = tonumber(parts[2]) or 1
        local count = tonumber(parts[3]) or 1
        cmdSpawn(player, tier, count)
    elseif subcommand == 'clear' then
        cmdClear(player)
    elseif subcommand == 'start' then
        cmdStart(player)
    elseif subcommand == 'stop' then
        cmdStop(player)
    elseif subcommand == 'info' then
        cmdInfo(player)
    elseif subcommand == 'init' then
        local p = function(msg) player:printToPlayer('[DWInit] ' .. msg, xi.msg.channel.SYSTEM_3) end
        local s = xi.settings.dynamicworld
        p('settings=' .. tostring(s ~= nil) .. ' ENABLED=' .. tostring(s and s.ENABLED))
        local ok, err = pcall(xi.dynamicWorld.init)
        if ok then
            local st = xi.dynamicWorld.state
            p('OK | initialized=' .. tostring(st.initialized) .. ' zones=' .. xi.dynamicWorld.countKeys(st.eligibleZones))
        else
            p('ERROR: ' .. tostring(err))
        end
    elseif subcommand == 'test' then
        cmdTest(player)
    elseif subcommand == 'synergies' then
        cmdSynergies(player)
    elseif subcommand == 'chain' then
        cmdChain(player)
    elseif subcommand == 'rares' then
        -- List all named rares and their status
        local list = xi.dynamicWorld.namedRares.getStatus()
        player:printToPlayer(string.format('[DynWorld] Named Rares (%d total):', #list), xi.msg.channel.SYSTEM_3)
        for _, entry in ipairs(list) do
            local stateStr
            if entry.alive then
                stateStr = 'ALIVE'
            elseif entry.ready then
                stateStr = 'READY TO SPAWN'
            else
                local mins = math.floor(entry.timeLeft / 60)
                local hrs  = math.floor(mins / 60)
                mins = mins % 60
                stateStr = string.format('%dh%02dm', hrs, mins)
            end
            player:printToPlayer(string.format('  %-25s key=%s [%s]', entry.name, entry.key, stateStr), xi.msg.channel.SYSTEM_3)
        end
    elseif subcommand == 'rare' then
        -- Force-spawn a specific named rare by key
        local key = table.concat(parts, ' ', 2)
        if not key or key == '' then
            printErr(player, '[DynWorld] Usage: !dynworld rare <key>  (use !dynworld rares to see keys)')
            return
        end
        local ok, msg = xi.dynamicWorld.namedRares.forceSpawn(key, player)
        player:printToPlayer('[DynWorld] ' .. msg, xi.msg.channel.SYSTEM_3)
    elseif subcommand == 'skirmish' then
        cmdSkirmish(player, parts[2], parts[3], parts[4])
    else
        showHelp(player)
    end
end

return commandObj
