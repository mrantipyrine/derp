-----------------------------------
-- Dynamic World Module
-----------------------------------
-- Hooks the Dynamic World system into the server lifecycle.
-- Uses GetZone(zoneId) to obtain zone objects directly, driving
-- spawn evaluation and roaming from onTimeServerTick.
-----------------------------------
require('modules/module_utils')
require('scripts/globals/dynamic_world')
-----------------------------------

local m = Module:new('dynamic-world')

-----------------------------------
-- Hook: Server Start
-----------------------------------
m:addOverride('xi.server.onServerStart', function()
    super()

    if xi.settings.dynamicworld and xi.settings.dynamicworld.ENABLED then
        xi.dynamicWorld.init()
        printf('[DynamicWorld Module] System initialized on server start.')
    else
        printf('[DynamicWorld Module] System is disabled in settings.')
    end
end)

-----------------------------------
-- Hook: Time Server Tick
-- This is the main driver. Uses GetZone(zoneId) to get zone objects
-- and run spawn/roam evaluation for each eligible zone.
-----------------------------------
m:addOverride('xi.server.onTimeServerTick', function()
    super()

    if not xi.dynamicWorld.state or not xi.dynamicWorld.state.running then
        return
    end

    local state = xi.dynamicWorld.state

    for zoneId, _ in pairs(state.eligibleZones) do
        local zone = GetZone(zoneId)
        if zone then
            -- Run the main zone tick (handles spawn eval + roam checks)
            xi.dynamicWorld.onZoneTick(zone)

            -- Process any pending migrations into this zone
            local zd = state.zoneData[zoneId]
            if zd and zd.pendingMigrations and #zd.pendingMigrations > 0 then
                xi.dynamicWorld.roaming.processPendingMigrations(zone, zd, state)
            end
        end
    end
end)

return m
