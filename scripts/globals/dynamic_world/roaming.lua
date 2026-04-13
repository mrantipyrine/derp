-----------------------------------
-- Dynamic World: Roaming / Migration
-----------------------------------
-- Handles cross-zone movement for Nomad and Apex tier entities.
--
-- Migration uses despawn/respawn since zone lines aren't accessible
-- from Lua. When a nomad migrates:
--   1. It's marked as migrating and paths away from players
--   2. After a delay, it despawns from the source zone
--   3. A migration request is queued for the target zone
--   4. On the target zone's next tick, it spawns at a valid position
--
-- The 3D challenge: spawning at valid positions requires navmesh
-- awareness. We use existing mob positions (known-good) and validate
-- with zone:isNavigablePoint(x, y, z).
-----------------------------------

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.roaming = xi.dynamicWorld.roaming or {}

local roaming = xi.dynamicWorld.roaming

local function getSetting(key)
    local s = xi.settings.dynamicWorld
    return s and s[key]
end

-----------------------------------
-- Evaluate: check nomads in this zone for migration
-----------------------------------
roaming.evaluate = function(zone, zd, state)
    local migrationChance = getSetting('ROAM_MIGRATION_CHANCE') or 0.30

    for targid, entData in pairs(zd.entities) do
        -- Only nomads and apex can migrate
        if entData.tier == xi.dynamicWorld.tier.NOMAD or
           entData.tier == xi.dynamicWorld.tier.APEX then

            -- Don't migrate if in combat or already migrating
            if entData.entity and entData.entity:isAlive() and
               not entData.entity:isEngaged() and
               entData.entity:getLocalVar('DW_MIGRATING') ~= 1 then

                -- Roll for migration
                if math.random() < migrationChance then
                    roaming.migrateEntity(zone, zd, state, targid, entData)
                end
            end
        end
    end
end

-----------------------------------
-- Migrate an entity to a connected zone in its region
-----------------------------------
roaming.migrateEntity = function(zone, zd, state, targid, entData)
    local zoneId = zone:getID()
    local regionZones = xi.dynamicWorld.getRegionZones(zoneId)

    if #regionZones < 2 then
        return
    end

    -- Pick a random connected zone that isn't the current one and has capacity
    local candidates = {}
    for _, candidateId in ipairs(regionZones) do
        if candidateId ~= zoneId and state.eligibleZones[candidateId] then
            local candidateZd = state.zoneData[candidateId]
            local maxPerZone = getSetting('MAX_ENTITIES_PER_ZONE') or 15
            if not candidateZd or candidateZd.count < maxPerZone then
                table.insert(candidates, candidateId)
            end
        end
    end

    if #candidates == 0 then
        return
    end

    local targetZoneId = candidates[math.random(#candidates)]
    local template = xi.dynamicWorld.templates.get(entData.templateKey)
    if not template then
        return
    end

    local mob = entData.entity
    if not mob or not mob:isAlive() then
        return
    end

    -- Mark as migrating so it doesn't get re-evaluated
    mob:setLocalVar('DW_MIGRATING', 1)

    -- Announce departure to nearby players
    if getSetting('ROAM_ANNOUNCE') then
        local players = zone:getPlayers()
        if players then
            for _, player in pairs(players) do
                local dist = player:checkDistance(mob) or 9999
                if dist < 50 then
                    player:printToPlayer(
                        string.format('[Dynamic World] %s is leaving the area...', template.packetName),
                        xi.msg.channel.SYSTEM_3
                    )
                end
            end
        end
    end

    -- Path the mob in a random direction before despawning (visual flair)
    local moveX = mob:getXPos() + (math.random() * 30 - 15)
    local moveZ = mob:getZPos() + (math.random() * 30 - 15)
    mob:pathTo(moveX, mob:getYPos(), moveZ)

    -- After 20 seconds, execute the migration
    mob:timer(20000, function(mobArg)
        if mobArg and mobArg:isAlive() and not mobArg:isEngaged() then
            roaming.executeMigration(zone, zd, state, targid, entData, targetZoneId, template)
        else
            -- Migration interrupted (combat or death)
            if mobArg then
                mobArg:setLocalVar('DW_MIGRATING', 0)
            end
        end
    end)
end

-----------------------------------
-- Execute the actual migration (despawn + queue respawn)
-----------------------------------
roaming.executeMigration = function(sourceZone, sourceZd, state, sourceTargid, entData, targetZoneId, template)
    local mob = entData.entity

    -- Despawn from source zone
    if mob and mob:isAlive() then
        mob:setHP(0)
    end

    -- Source tracking cleanup is handled by the DESPAWN listener

    -- Ensure target zone data exists
    local targetZd = state.zoneData[targetZoneId]
    if not targetZd then
        targetZd = {
            entities = {}, count = 0, lastTick = 0, lastRoamCheck = 0,
            pendingSpawns = 0, pendingMigrations = {},
        }
        state.zoneData[targetZoneId] = targetZd
    end

    -- Queue the migration for the target zone
    targetZd.pendingMigrations = targetZd.pendingMigrations or {}
    table.insert(targetZd.pendingMigrations, {
        templateKey = entData.templateKey,
        tier        = entData.tier,
        sourceZone  = sourceZone:getID(),
    })

    printf('[DynamicWorld] %s migrating from zone %d to zone %d',
        template.packetName, sourceZone:getID(), targetZoneId)
end

-----------------------------------
-- Process pending migrations for a zone.
-- Called from the module tick with the zone object obtained via GetZone().
-----------------------------------
roaming.processPendingMigrations = function(zone, zd, state)
    if not zd.pendingMigrations or #zd.pendingMigrations == 0 then
        return
    end

    local maxPerZone = getSetting('MAX_ENTITIES_PER_ZONE') or 15
    local processed = 0

    while #zd.pendingMigrations > 0 and zd.count < maxPerZone do
        local migration = table.remove(zd.pendingMigrations, 1)

        -- Spawn the migrated entity using the standard spawner
        local entity = xi.dynamicWorld.spawner.spawnEntity(zone, zd, state, migration.tier)
        if entity then
            processed = processed + 1

            -- Announce arrival
            if getSetting('ROAM_ANNOUNCE') then
                local template = xi.dynamicWorld.templates.get(migration.templateKey)
                local name = template and template.packetName or 'Something'
                local players = zone:getPlayers()
                if players then
                    for _, player in pairs(players) do
                        player:printToPlayer(
                            string.format('[Dynamic World] %s has arrived from a distant land!', name),
                            xi.msg.channel.SYSTEM_3
                        )
                    end
                end
            end
        end
    end

    return processed
end
