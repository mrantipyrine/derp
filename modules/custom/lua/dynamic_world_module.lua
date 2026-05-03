-----------------------------------
-- Dynamic World Module
-----------------------------------
require('modules/module_utils')
require('settings/dynamic_world')
require('scripts/globals/dynamic_world')
-----------------------------------

local m = Module:new('dynamic-world')

m:addOverride('xi.server.onServerStart', function()
    super()
    xi.dynamicWorld.init()
    printf('[DynamicWorld Module] System initialized on server start.')
end)

m:addOverride('xi.server.onTimeServerTick', function()
    super()

    if xi.dynamicWorld.state and not xi.dynamicWorld.state.initialized then
        xi.dynamicWorld.init()
    end

    if not xi.dynamicWorld.state or not xi.dynamicWorld.state.running then
        return
    end

    local state = xi.dynamicWorld.state

    for zoneId, _ in pairs(state.eligibleZones) do
        local zone = GetZone(zoneId)
        if zone then
            xi.dynamicWorld.onZoneTick(zone)

            local zd = state.zoneData[zoneId]
            if zd and zd.pendingMigrations and #zd.pendingMigrations > 0 then
                xi.dynamicWorld.roaming.processPendingMigrations(zone, zd, state)
            end
        end
    end
end)

return m
