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
-- Tier values: 1=Wanderer, 2=Nomad, 3=Elite, 4=Apex
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

local function showHelp(player)
    player:printToPlayer('[DynWorld] Commands: status, spawn [tier] [count], clear, start, stop, info, synergies, chain', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('[DynWorld] Tiers: 1=Wanderer, 2=Nomad, 3=Elite, 4=Apex', xi.msg.channel.SYSTEM_3)
end

local function cmdStatus(player)
    local status = xi.dynamicWorld.getStatus()
    player:printToPlayer(string.format('[DynWorld] Running: %s | Total: %d | Zones: %d',
        tostring(status.running), status.globalCount, status.activeZones), xi.msg.channel.SYSTEM_3)
    player:printToPlayer(string.format('[DynWorld] Wanderers: %d | Nomads: %d | Elites: %d | Apex: %d',
        status.wanderers, status.nomads, status.elites, status.apex), xi.msg.channel.SYSTEM_3)
end

local function cmdSpawn(player, tier, count)
    tier = math.max(1, math.min(4, tier))
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
        player:printToPlayer(string.format('  [%s] %s (Lv%d-%d) [%s]',
            tierName, name, entData.minLevel or 0, entData.maxLevel or 0, alive), xi.msg.channel.SYSTEM_3)
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
    elseif subcommand == 'synergies' then
        cmdSynergies(player)
    elseif subcommand == 'chain' then
        cmdChain(player)
    else
        showHelp(player)
    end
end

return commandObj
