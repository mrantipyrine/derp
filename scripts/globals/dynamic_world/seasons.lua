-----------------------------------
-- Dynamic World: Seasonal Events
-----------------------------------
-- Tracks faction dominance per region and escalates through:
--   CALM -> SKIRMISH -> CONFLICT -> INVASION -> SIEGE -> AFTERMATH -> CALM
--
-- Seasons rotate the globally ascendant faction, which gains faster
-- dominance buildup. Goblins are chaotic — active in every region.
--
-- Persistence (server variables):
--   DW_SEASON_F          - current season faction id (1-4)
--   DW_SEASON_T          - unix timestamp of season start
--   DW_RST_<r>           - region state       (0-5)
--   DW_RFA_<r>           - region faction id  (0-4)
--   DW_RDO_<r>           - region dominance   (0-1000)
--   DW_RTI_<r>           - region state entry timestamp
--   DW_RCD_<r>           - field commander alive (0/1)
--   DW_RWL_<r>           - warlord alive (0/1)
-----------------------------------

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.seasons = xi.dynamicWorld.seasons or {}

local seasons = xi.dynamicWorld.seasons

-----------------------------------
-- State enum
-----------------------------------
local STATE =
{
    CALM      = 0,
    SKIRMISH  = 1,
    CONFLICT  = 2,
    INVASION  = 3,
    SIEGE     = 4,
    AFTERMATH = 5,
}

local STATE_NAME =
{
    [0] = 'Calm',
    [1] = 'Skirmish',
    [2] = 'Conflict',
    [3] = 'Invasion',
    [4] = 'Siege',
    [5] = 'Aftermath',
}

-----------------------------------
-- Faction enum
-----------------------------------
local FACTION =
{
    goblin = 1,
    orc    = 2,
    quadav = 3,
    yagudo = 4,
}

local FACTION_NAME =
{
    [1] = 'Goblin',
    [2] = 'Orc',
    [3] = 'Quadav',
    [4] = 'Yagudo',
}

-- Season rotation: Orc -> Quadav -> Yagudo -> Goblin -> Orc ...
-- Goblin is last so there's a stretch of territorial seasons first.
local SEASON_ROTATION = { 2, 3, 4, 1 }

-----------------------------------
-- Regions that participate in the seasonal conflict system.
-- Expansion regions are excluded; this is the original-nations beastman war.
-----------------------------------
local SEASON_REGIONS =
{
    { name = 'ronfaure',     index = 1, homeFaction = FACTION.orc,    primaryZone = 100 },
    { name = 'gustaberg',    index = 2, homeFaction = FACTION.quadav,  primaryZone = 106 },
    { name = 'sarutabaruta', index = 3, homeFaction = FACTION.yagudo,  primaryZone = 115 },
    { name = 'midlands',     index = 4, homeFaction = nil,             primaryZone = 103 },
}

-- Which regions each faction may operate in.
-- Goblins are opportunists — everywhere.
local FACTION_ALLOWED_REGIONS =
{
    [FACTION.goblin] = { 1, 2, 3, 4 },
    [FACTION.orc]    = { 1, 4 },
    [FACTION.quadav]  = { 2, 4 },
    [FACTION.yagudo]  = { 3, 4 },
}

-----------------------------------
-- Dominance thresholds
-----------------------------------
local DOM =
{
    SKIRMISH_FLOOR  = 100,  -- below this, decay back to CALM
    CONFLICT_ENTER  = 400,
    INVASION_ENTER  = 700,
    SIEGE_ENTER     = 900,
}

-- Dominance deltas from events
local DELTA =
{
    SKIRMISH_WIN     =  50,
    COMMANDER_KILL   = -150,
    WANDERER_KILL    =  -1,
    NOMAD_KILL       =  -2,
    ELITE_KILL       =  -5,
    APEX_KILL        = -10,
    DECAY_HOUR       =  -3,   -- passive per-hour drain
    SEASON_MULT      = 1.5,   -- ascendant faction bonus on skirmish wins
}

-- How long (seconds) each state is allowed before auto-escalation
local TIMEOUT =
{
    [STATE.CONFLICT]  = 2 * 3600,
    [STATE.INVASION]  = 1 * 3600,
    [STATE.SIEGE]     =     30 * 60,
    [STATE.AFTERMATH] = 4 * 3600,
}

local DEFAULT_SEASON_DURATION = 7 * 24 * 3600   -- one real week
local SEASON_TICK_INTERVAL    = 60               -- evaluate state machine once per minute
local DECAY_TICK_INTERVAL     = 3600             -- apply dominance decay once per hour

-----------------------------------
-- Commander / Warlord data
-----------------------------------
-----------------------------------
-- Faction model IDs for imposing visual variants
-----------------------------------
-- modelid values decoded from mob_pools.sql binary blobs (bytes 2-3 LE).
-- COMMANDER: largest "elite officer" variant for the faction.
-- WARLORD:   the biggest model in the faction's lineage — visually distinct
--            and noticeably larger than standard field troops.
--
-- Goblin commander  → Goblin_Warlord      (501)  – bulkier than standard goblin
-- Goblin warlord    → Goblinsavior_Heronox (508) – the heftiest goblin model
-- Orc commander     → Orcish_Warchief     (635)  – armored chief variant
-- Orc warlord       → Orcish_Overlord    (1011)  – visually the largest orc model
-- Quadav commander  → Greater_Quadav      (647)  – bigger shell, more imposing
-- Quadav warlord    → Greater_Quadav      (647)  – same (largest available)
-- Yagudo commander  → Yagudo_High_Priest  (606)  – robed elder variant
-- Yagudo warlord    → Tzee_Xicu_the_Manifest (781) – the Yagudo demigod model
-----------------------------------
local FACTION_MODEL =
{
    commander =
    {
        [FACTION.goblin] = 501,
        [FACTION.orc]    = 635,
        [FACTION.quadav]  = 647,
        [FACTION.yagudo]  = 606,
    },
    warlord =
    {
        [FACTION.goblin] = 508,
        [FACTION.orc]    = 1011,
        [FACTION.quadav]  = 647,
        [FACTION.yagudo]  = 781,
    },
}

local COMMANDER =
{
    [FACTION.goblin] =
    {
        name        = 'Sneakpeddler Grixnik',
        packetName  = 'Sneakpeddler',
        groupId     = 23,
        groupZoneId = 4,
        levelMin    = 50,
        levelMax    = 60,
        message     = 'Grixnik barks orders in three languages simultaneously.',
    },
    [FACTION.orc] =
    {
        name        = 'Battlemaster Vorruk',
        packetName  = 'Battlemaster',
        groupId     = 14,
        groupZoneId = 2,
        levelMin    = 50,
        levelMax    = 60,
        message     = 'Vorruk plants a banner and roars for blood.',
    },
    [FACTION.quadav] =
    {
        name        = 'Shell-General Nazzuk',
        packetName  = 'Shell-General',
        groupId     = 76,
        groupZoneId = 37,
        levelMin    = 50,
        levelMax    = 60,
        message     = 'Nazzuk raises its shell in silent, absolute command.',
    },
    [FACTION.yagudo] =
    {
        name        = 'High Talon Chizuru',
        packetName  = 'High Talon',
        groupId     = 82,
        groupZoneId = 37,
        levelMin    = 50,
        levelMax    = 60,
        message     = 'Chizuru fans its wings once. The flock tightens.',
    },
}

local WARLORD =
{
    [FACTION.goblin] =
    {
        name        = 'Plunderlord Baxnol',
        packetName  = 'Plunderlord',
        groupId     = 27,
        groupZoneId = 4,
        levelMin    = 72,
        levelMax    = 75,
        message     = 'Baxnol crashes in dragging a sack of stolen banners.',
    },
    [FACTION.orc] =
    {
        name        = 'Warlord Grakthal the Crusher',
        packetName  = 'Warlord Grakthal',
        groupId     = 21,
        groupZoneId = 2,
        levelMin    = 72,
        levelMax    = 75,
        message     = 'The ground shakes before Grakthal arrives.',
    },
    [FACTION.quadav] =
    {
        name        = 'Grand Marshal Kazzulk',
        packetName  = 'Grand Marshal',
        groupId     = 78,
        groupZoneId = 37,
        levelMin    = 72,
        levelMax    = 75,
        message     = 'Kazzulk emerges from the earth itself, silent and massive.',
    },
    [FACTION.yagudo] =
    {
        name        = 'Supreme Talon Jirikawa',
        packetName  = 'Supreme Talon',
        groupId     = 84,
        groupZoneId = 37,
        levelMin    = 72,
        levelMax    = 75,
        message     = 'Jirikawa descends on an updraft and regards the field with cold eyes.',
    },
}

-----------------------------------
-- Region lookup tables
-----------------------------------
local regionByIndex = {}
local regionByName  = {}
for _, r in ipairs(SEASON_REGIONS) do
    regionByIndex[r.index] = r
    regionByName[r.name]   = r
end

local function getRegionForZone(zoneId)
    local state      = xi.dynamicWorld.state
    local regionName = state.zoneToRegion and state.zoneToRegion[zoneId]
    return regionName and regionByName[regionName] or nil
end

-----------------------------------
-- Server variable helpers
-----------------------------------
local function rsv(regionIndex, suffix)
    return string.format('DW_R%s_%d', suffix, regionIndex)
end

local function getRegionState(ri)     return GetServerVariable(rsv(ri, 'ST'))  or STATE.CALM end
local function getRegionFaction(ri)   return GetServerVariable(rsv(ri, 'FA'))  or 0          end
local function getRegionDominance(ri) return GetServerVariable(rsv(ri, 'DO'))  or 0          end
local function getRegionStateTime(ri) return GetServerVariable(rsv(ri, 'TI'))  or os.time()  end
local function isCommanderAlive(ri)   return (GetServerVariable(rsv(ri, 'CD')) or 0) == 1   end
local function isWarlordAlive(ri)     return (GetServerVariable(rsv(ri, 'WL')) or 0) == 1   end

local function setRegionState(ri, state)
    SetServerVariable(rsv(ri, 'ST'), state)
    SetServerVariable(rsv(ri, 'TI'), os.time())
end

local function setRegionFaction(ri, fid)    SetServerVariable(rsv(ri, 'FA'), fid or 0)  end
local function setCommanderAlive(ri, alive) SetServerVariable(rsv(ri, 'CD'), alive and 1 or 0) end
local function setWarlordAlive(ri, alive)   SetServerVariable(rsv(ri, 'WL'), alive and 1 or 0) end

local function setRegionDominance(ri, val)
    val = math.max(0, math.min(1000, math.floor(val)))
    SetServerVariable(rsv(ri, 'DO'), val)
    return val
end

local function addDominance(ri, delta)
    return setRegionDominance(ri, getRegionDominance(ri) + delta)
end

local function getSeasonFaction() return GetServerVariable('DW_SEASON_F') or 0 end
local function getSeasonStart()   return GetServerVariable('DW_SEASON_T') or os.time() end

local function setSeasonFaction(fid)
    SetServerVariable('DW_SEASON_F', fid)
    SetServerVariable('DW_SEASON_T', os.time())
end

-----------------------------------
-- Server-wide announcement
-- Iterates all eligible zones and prints to every online player.
-----------------------------------
local function announceServer(msg)
    local zoneList = xi.dynamicWorld.getEligibleZoneList()
    local seen     = {}
    for _, zoneId in ipairs(zoneList) do
        local zone = GetZone(zoneId)
        if zone then
            local players = zone:getPlayers()
            if players then
                for _, player in pairs(players) do
                    local pid = player:getID()
                    if not seen[pid] then
                        seen[pid] = true
                        player:printToPlayer(msg, xi.msg.channel.SYSTEM_3)
                    end
                end
            end
        end
    end
end

-----------------------------------
-- Commander spawn
-----------------------------------
local function spawnCommander(region, factionId)
    if isCommanderAlive(region.index) then return end

    local data = COMMANDER[factionId]
    if not data then return end

    local zone = GetZone(region.primaryZone)
    if not zone then return end

    local pos = xi.dynamicWorld.getRandomSpawnPoint(zone)
    if not pos then return end

    local ri = region.index

    local cmdModel = FACTION_MODEL.commander[factionId]

    local entity = zone:insertDynamicEntity(
    {
        objtype              = xi.objType.MOB,
        name                 = data.name:gsub('[%s%-]', '_'),
        packetName           = data.packetName,
        x                    = pos.x,
        y                    = pos.y,
        z                    = pos.z,
        rotation             = pos.rot,
        groupId              = data.groupId,
        groupZoneId          = data.groupZoneId,
        minLevel             = data.levelMin,
        maxLevel             = data.levelMax,
        look                 = cmdModel,
        releaseIdOnDisappear = true,
        specialSpawnAnimation = true,

        onMobSpawn = function(mob)
            mob:setLocalVar('DW_IS_COMMANDER', 1)
            mob:setLocalVar('DW_SEASON_REGION',  ri)
            mob:setLocalVar('DW_SEASON_FACTION', factionId)
            mob:setMobMod(xi.mobMod.CHECK_AS_NM,   1)
            mob:setMobMod(xi.mobMod.SIGHT_RANGE,   22)
            mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 15)
            mob:setMobMod(xi.mobMod.ROAM_COOL,     6)
            mob:addMod(xi.mod.ATT, 40)
            mob:addMod(xi.mod.DEF, 35)
            mob:addMod(xi.mod.ACC, 20)
            mob:addMod(xi.mod.HP,  500)
            mob:renameEntity(data.packetName)
        end,

        onMobEngaged = function(mob, target)
            if target and target.isPC and target:isPC() then
                target:printToPlayer(
                    string.format('[Dynamic World] %s', data.message),
                    xi.msg.channel.SYSTEM_3
                )
            end
        end,

        onMobDeath = function(mob, killer, optParams)
            setCommanderAlive(ri, false)

            local newDom = addDominance(ri, DELTA.COMMANDER_KILL)

            xi.dynamicWorld.announceZone(
                zone,
                string.format('[Dynamic World] %s has been defeated. The %s advance is pushed back. (Dominance: %d)',
                    data.name, FACTION_NAME[factionId], newDom)
            )
        end,
    })

    if not entity then return end

    entity:setSpawn(pos.x, pos.y, pos.z, pos.rot)
    entity:spawn()
    setCommanderAlive(ri, true)

    xi.dynamicWorld.announceZone(
        zone,
        string.format('[Dynamic World] Conflict: %s leads the %s advance into %s. Defeat them to halt the escalation.',
            data.name, FACTION_NAME[factionId], region.name)
    )
end

-----------------------------------
-- Warlord spawn
-----------------------------------
local function spawnWarlord(region, factionId)
    if isWarlordAlive(region.index) then return end

    local data = WARLORD[factionId]
    if not data then return end

    local zone = GetZone(region.primaryZone)
    if not zone then return end

    local pos = xi.dynamicWorld.getRandomSpawnPoint(zone)
    if not pos then return end

    local ri          = region.index
    local siegeWindow = TIMEOUT[STATE.SIEGE] or (30 * 60)
    local wlModel     = FACTION_MODEL.warlord[factionId]

    local entity = zone:insertDynamicEntity(
    {
        objtype              = xi.objType.MOB,
        name                 = data.name:gsub('[%s%-]', '_'),
        packetName           = data.packetName,
        x                    = pos.x,
        y                    = pos.y,
        z                    = pos.z,
        rotation             = pos.rot,
        groupId              = data.groupId,
        groupZoneId          = data.groupZoneId,
        minLevel             = data.levelMin,
        maxLevel             = data.levelMax,
        look                 = wlModel,
        releaseIdOnDisappear = true,
        specialSpawnAnimation = true,

        onMobSpawn = function(mob)
            mob:setLocalVar('DW_IS_WARLORD',     1)
            mob:setLocalVar('DW_SEASON_REGION',  ri)
            mob:setLocalVar('DW_SEASON_FACTION', factionId)
            mob:setMobMod(xi.mobMod.CHECK_AS_NM,   1)
            mob:setMobMod(xi.mobMod.SIGHT_RANGE,   30)
            mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 20)
            mob:setMobMod(xi.mobMod.ROAM_COOL,     4)
            mob:setMobMod(xi.mobMod.NO_LINK,       1)
            mob:addMod(xi.mod.ATT,        80)
            mob:addMod(xi.mod.DEF,        70)
            mob:addMod(xi.mod.ACC,        35)
            mob:addMod(xi.mod.HP,        2000)
            mob:addMod(xi.mod.CRITHITRATE, 10)
            mob:renameEntity(data.packetName)

            -- Auto-retreat if window expires without a kill
            mob:timer(siegeWindow * 1000, function(warlordMob)
                if warlordMob and warlordMob:isAlive() then
                    setWarlordAlive(ri, false)
                    seasons.onWarlordRetreat(region, factionId)
                    warlordMob:despawn()
                end
            end)
        end,

        onMobEngaged = function(mob, target)
            if target and target.isPC and target:isPC() then
                xi.dynamicWorld.announceZone(
                    zone,
                    string.format('[Dynamic World] %s', data.message)
                )
            end
        end,

        onMobDeath = function(mob, killer, optParams)
            setWarlordAlive(ri, false)
            seasons.onWarlordKilled(region, factionId, killer)
        end,
    })

    if not entity then return end

    entity:setSpawn(pos.x, pos.y, pos.z, pos.rot)
    entity:spawn()
    setWarlordAlive(ri, true)

    announceServer(string.format(
        '[Dynamic World] SIEGE — %s has arrived in %s! The %s advance cannot be stopped. You have %d minutes.',
        data.name, region.name, FACTION_NAME[factionId], math.floor(siegeWindow / 60)
    ))
end

-----------------------------------
-- Warlord outcomes
-----------------------------------

seasons.onWarlordKilled = function(region, factionId, killer)
    setRegionState(region.index, STATE.AFTERMATH)
    setRegionDominance(region.index, 0)

    local wData = WARLORD[factionId]
    announceServer(string.format(
        '[Dynamic World] Victory! %s is dead. The %s have been driven from %s. A period of calm follows.',
        wData and wData.name or 'The Warlord',
        FACTION_NAME[factionId],
        region.name
    ))
end

seasons.onWarlordRetreat = function(region, factionId)
    setRegionState(region.index, STATE.AFTERMATH)
    setRegionDominance(region.index, 200)  -- Faction still holds some ground

    local wData = WARLORD[factionId]
    announceServer(string.format(
        '[Dynamic World] %s withdraws from %s — but the %s hold the field. Their forces remain emboldened.',
        wData and wData.name or 'The Warlord',
        region.name,
        FACTION_NAME[factionId]
    ))
end

-----------------------------------
-- State transitions
-----------------------------------

local function toSkirmish(region, factionId)
    setRegionState(region.index, STATE.SKIRMISH)
    setRegionFaction(region.index, factionId)
    -- No announcement — just a visible shift in spawn composition
    printf('[DynamicWorld] %s enters SKIRMISH (%s)', region.name, FACTION_NAME[factionId] or '?')
end

local function toConflict(region, factionId)
    setRegionState(region.index, STATE.CONFLICT)
    setCommanderAlive(region.index, false)
    spawnCommander(region, factionId)
    printf('[DynamicWorld] %s enters CONFLICT (%s)', region.name, FACTION_NAME[factionId] or '?')
end

local function toInvasion(region, factionId)
    setRegionState(region.index, STATE.INVASION)
    announceServer(string.format(
        '[Dynamic World] INVASION — The %s pour into %s! All zones in the region swarm with their forces.',
        FACTION_NAME[factionId], region.name
    ))
    printf('[DynamicWorld] %s enters INVASION (%s)', region.name, FACTION_NAME[factionId] or '?')
end

local function toSiege(region, factionId)
    setRegionState(region.index, STATE.SIEGE)
    setWarlordAlive(region.index, false)
    spawnWarlord(region, factionId)
    printf('[DynamicWorld] %s enters SIEGE (%s)', region.name, FACTION_NAME[factionId] or '?')
end

local function toCalm(region)
    setRegionState(region.index, STATE.CALM)
    setRegionFaction(region.index, 0)
    setRegionDominance(region.index, 0)
    setCommanderAlive(region.index, false)
    setWarlordAlive(region.index, false)
    printf('[DynamicWorld] %s returns to CALM', region.name)
end

-----------------------------------
-- Evaluate one region's state machine
-----------------------------------
local function evaluateRegion(region, now)
    local ri        = region.index
    local state     = getRegionState(ri)
    local factionId = getRegionFaction(ri)
    local dom       = getRegionDominance(ri)
    local elapsed   = now - getRegionStateTime(ri)

    if state == STATE.CALM then
        return  -- transitions out of CALM are driven by skirmish wins

    elseif state == STATE.SKIRMISH then
        if dom < DOM.SKIRMISH_FLOOR then
            toCalm(region)
        elseif dom >= DOM.CONFLICT_ENTER then
            toConflict(region, factionId)
        end

    elseif state == STATE.CONFLICT then
        if dom >= DOM.INVASION_ENTER then
            toInvasion(region, factionId)
        elseif elapsed >= TIMEOUT[STATE.CONFLICT] then
            -- Uncontested — force escalation
            toInvasion(region, factionId)
        elseif dom < DOM.CONFLICT_ENTER then
            -- Player pushback was effective
            setRegionState(ri, STATE.SKIRMISH)
            xi.dynamicWorld.announceZone(
                GetZone(region.primaryZone),
                string.format('[Dynamic World] The %s advance in %s has been checked. The conflict simmers back down.',
                    FACTION_NAME[factionId], region.name)
            )
        end

    elseif state == STATE.INVASION then
        if dom >= DOM.SIEGE_ENTER then
            toSiege(region, factionId)
        elseif elapsed >= TIMEOUT[STATE.INVASION] then
            toSiege(region, factionId)
        elseif dom < DOM.CONFLICT_ENTER then
            setRegionState(ri, STATE.CONFLICT)
            announceServer(string.format(
                '[Dynamic World] The %s invasion of %s is being repelled! They are falling back.',
                FACTION_NAME[factionId], region.name
            ))
        end

    elseif state == STATE.SIEGE then
        -- Resolution is handled by the warlord entity's own timer.
        -- This is a safety net for stale state after a server restart.
        if not isWarlordAlive(ri) and elapsed > 120 then
            setRegionState(ri, STATE.AFTERMATH)
            setRegionDominance(ri, 0)
            printf('[DynamicWorld] %s SIEGE resolved by safety fallback', region.name)
        end

    elseif state == STATE.AFTERMATH then
        if elapsed >= TIMEOUT[STATE.AFTERMATH] then
            toCalm(region)
        end
    end
end

-----------------------------------
-- Dominance decay (once per hour)
-----------------------------------
local function applyDecay(now)
    local dwState   = xi.dynamicWorld.state
    local lastDecay = dwState.lastSeasonDecayTick or 0

    if now - lastDecay < DECAY_TICK_INTERVAL then return end
    dwState.lastSeasonDecayTick = now

    for _, region in ipairs(SEASON_REGIONS) do
        local s = getRegionState(region.index)
        if s ~= STATE.CALM and s ~= STATE.AFTERMATH then
            addDominance(region.index, DELTA.DECAY_HOUR)
        end
    end
end

-----------------------------------
-- Season rotation
-----------------------------------
local function nextSeasonFaction(currentFid)
    for i, fid in ipairs(SEASON_ROTATION) do
        if fid == currentFid then
            return SEASON_ROTATION[(i % #SEASON_ROTATION) + 1]
        end
    end
    return SEASON_ROTATION[1]
end

local function evaluateSeason(now)
    local current = getSeasonFaction()

    if current == 0 then
        local first = SEASON_ROTATION[1]
        setSeasonFaction(first)
        printf('[DynamicWorld] Season initialized: %s', FACTION_NAME[first])
        return
    end

    local settings = xi.settings.dynamicworld
    local duration  = (settings and settings.SEASON_DURATION) or DEFAULT_SEASON_DURATION

    if now - getSeasonStart() >= duration then
        local next = nextSeasonFaction(current)
        setSeasonFaction(next)
        announceServer(string.format(
            '[Dynamic World] Season Change: The %s season ends. The %s rise.',
            FACTION_NAME[current], FACTION_NAME[next]
        ))
        printf('[DynamicWorld] Season: %s -> %s', FACTION_NAME[current], FACTION_NAME[next])
    end
end

-----------------------------------
-- Main tick (called from dynamic_world.onZoneTick, rate-limited internally)
-----------------------------------
seasons.tick = function()
    local dwState = xi.dynamicWorld.state
    if not dwState or not dwState.running then return end

    local now     = os.time()
    local lastTick = dwState.lastSeasonTick or 0
    if now - lastTick < SEASON_TICK_INTERVAL then return end
    dwState.lastSeasonTick = now

    evaluateSeason(now)
    applyDecay(now)

    for _, region in ipairs(SEASON_REGIONS) do
        evaluateRegion(region, now)
    end
end

-----------------------------------
-- Public hook: called when a skirmish concludes
-- winnerFactionKey / loserFactionKey are the string keys ('goblin', 'orc', etc.)
-----------------------------------
seasons.onSkirmishResult = function(zone, winnerFactionKey, loserFactionKey)
    if not zone or not winnerFactionKey or winnerFactionKey == 'draw' then return end

    local zoneId    = zone:getID()
    local region    = getRegionForZone(zoneId)
    if not region then return end

    local winnerFid = FACTION[string.lower(tostring(winnerFactionKey))]
    if not winnerFid then return end

    -- Check faction is allowed in this region
    local allowed   = false
    local allowedRi = FACTION_ALLOWED_REGIONS[winnerFid]
    if allowedRi then
        for _, ri in ipairs(allowedRi) do
            if ri == region.index then allowed = true; break end
        end
    end
    if not allowed then return end

    local currentState  = getRegionState(region.index)
    local currentFaction = getRegionFaction(region.index)

    -- A different faction winning resets dominance for this region
    if currentFaction ~= 0 and currentFaction ~= winnerFid then
        setRegionDominance(region.index, 0)
    end
    setRegionFaction(region.index, winnerFid)

    -- Calculate dominance gain with possible season bonus
    local delta = DELTA.SKIRMISH_WIN
    if getSeasonFaction() == winnerFid then
        delta = math.floor(delta * DELTA.SEASON_MULT)
    end

    local newDom = addDominance(region.index, delta)
    printf('[DynamicWorld] Skirmish: %s wins in %s (dominance %d)', FACTION_NAME[winnerFid], region.name, newDom)

    -- Enter SKIRMISH state if currently CALM
    if currentState == STATE.CALM then
        toSkirmish(region, winnerFid)
    end
end

-----------------------------------
-- Public hook: called when a player kills a faction mob
-- factionId is the numeric faction id (use seasons.FACTION to look up)
-----------------------------------
seasons.onPlayerKillFaction = function(player, factionId, tier)
    if not player or not factionId or factionId == 0 then return end

    local zoneId = player:getZoneID()
    local region = getRegionForZone(zoneId)
    if not region then return end

    -- Only reduce dominance if this faction is the active aggressor
    if getRegionFaction(region.index) ~= factionId then return end

    local s = getRegionState(region.index)
    if s == STATE.CALM or s == STATE.AFTERMATH then return end

    local tierDelta =
    {
        [xi.dynamicWorld.tier.WANDERER]   = DELTA.WANDERER_KILL,
        [xi.dynamicWorld.tier.NOMAD]      = DELTA.NOMAD_KILL,
        [xi.dynamicWorld.tier.ELITE]      = DELTA.ELITE_KILL,
        [xi.dynamicWorld.tier.APEX]       = DELTA.APEX_KILL,
        [xi.dynamicWorld.tier.POWER_KING] = DELTA.APEX_KILL,
    }
    addDominance(region.index, tierDelta[tier] or DELTA.WANDERER_KILL)
end

-----------------------------------
-- Utility: infer numeric faction id from a template (for the kill hook)
-----------------------------------
seasons.factionIdFromTemplate = function(template)
    if not template then return nil end
    local key = template.faction and string.lower(template.faction)
    return key and FACTION[key] or nil
end

-----------------------------------
-- GM / status API
-----------------------------------

seasons.getStatus = function()
    local now     = os.time()
    local current = getSeasonFaction()
    local start   = getSeasonStart()
    local settings = xi.settings.dynamicworld
    local duration = (settings and settings.SEASON_DURATION) or DEFAULT_SEASON_DURATION
    local remaining = math.max(0, (start + duration) - now)

    local regionStatus = {}
    for _, r in ipairs(SEASON_REGIONS) do
        regionStatus[r.name] =
        {
            state     = STATE_NAME[getRegionState(r.index)]   or 'Unknown',
            faction   = FACTION_NAME[getRegionFaction(r.index)] or 'None',
            dominance = getRegionDominance(r.index),
            commander = isCommanderAlive(r.index),
            warlord   = isWarlordAlive(r.index),
        }
    end

    return
    {
        season          = FACTION_NAME[current] or 'Unknown',
        seasonRemaining = remaining,
        regions         = regionStatus,
    }
end

seasons.advanceSeason = function()
    local next = nextSeasonFaction(getSeasonFaction())
    setSeasonFaction(next)
    announceServer(string.format('[Dynamic World] Season advanced by GM. The %s season begins.', FACTION_NAME[next]))
    return next
end

seasons.setDominance = function(regionName, value)
    local r = regionByName[regionName]
    if not r then return false, 'unknown region' end
    setRegionDominance(r.index, value)
    return true
end

seasons.forceState = function(regionName, stateName)
    local r = regionByName[regionName]
    if not r then return false, 'unknown region' end
    for id, name in pairs(STATE_NAME) do
        if string.lower(name) == string.lower(stateName) then
            setRegionState(r.index, id)
            return true
        end
    end
    return false, 'unknown state'
end

-----------------------------------
-- Init: called once on server start.
-- Cleans up stale alive-flags so commanders/warlords respawn cleanly.
-----------------------------------
seasons.init = function()
    for _, r in ipairs(SEASON_REGIONS) do
        local s = getRegionState(r.index)
        -- If server restarted mid-conflict the entity is gone — clear the flag.
        if s == STATE.CONFLICT then setCommanderAlive(r.index, false) end
        if s == STATE.SIEGE    then setWarlordAlive(r.index,   false) end
    end
    printf('[DynamicWorld] Seasons initialized.')
end

-- Expose enums for external use
seasons.STATE        = STATE
seasons.STATE_NAME   = STATE_NAME
seasons.FACTION      = FACTION
seasons.FACTION_NAME = FACTION_NAME
seasons.REGIONS      = SEASON_REGIONS
