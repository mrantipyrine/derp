-----------------------------------
-- Dynamic World: Behaviors
-----------------------------------
-- Defines AI behavior sets for each entity archetype.
-- Each behavior set is a table of callbacks:
--   onMobSpawn, onMobRoam, onMobEngaged, onMobDeath, onMobDespawn
--
-- Behaviors determine how entities move, fight, and interact.
-----------------------------------

require('scripts/enum/mob_mod')

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.behaviors = xi.dynamicWorld.behaviors or {}

local behaviors = xi.dynamicWorld.behaviors
local behaviorDb = {}

local function getSetting(key)
    local s = xi.settings.dynamicworld
    return s and s[key]
end

-- Pick a random groupRef from a template (supports groupRefs array or single groupRef).
local function pickGroupRef(template)
    local refs = template.groupRefs
    if refs and #refs > 0 then
        return refs[math.random(#refs)]
    end
    return template.groupRef
end

-- Reusable aura pulse: notifies nearby players at an interval
local function pulseAura(mob, msg, rangeOverride)
    local now = os.time()
    local lastTick = mob:getLocalVar('DW_AURA_LAST_TICK')
    local interval = getSetting('APEX_AURA_TICK_INTERVAL') or 10

    if now - lastTick < interval then
        return
    end

    mob:setLocalVar('DW_AURA_LAST_TICK', now)
    local range = rangeOverride or (getSetting('APEX_AURA_RANGE') or 50)
    xi.dynamicWorld.announceNearby(mob:getZone(), mob, range, msg)
end

-----------------------------------
-- Behavior Registry
-----------------------------------
behaviors.get = function(name)
    return behaviorDb[name]
end

-----------------------------------
-- WANDERER BEHAVIORS
-----------------------------------

-- Standard wanderer: roams slowly, nothing fancy
behaviorDb.wanderer_standard =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 15)     -- Slow roam
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 8)   -- Short wander radius
    end,

    onMobRoam = function(mob, template, tier)
        -- Standard roaming, nothing special
    end,

    onMobEngaged = function(mob, target, template, tier)
        -- Standard combat
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        -- Loot/EXP handled by spawner
    end,
}

-- Aggressive wanderer: roams faster, larger aggro range
behaviorDb.wanderer_aggressive =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 8)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 12)
        mob:setMobMod(xi.mobMod.SIGHT_RANGE, 20)    -- Larger sight aggro
    end,

    onMobRoam = function(mob, template, tier)
        -- Nothing extra
    end,

    onMobEngaged = function(mob, target, template, tier)
        -- Slight stat boost when engaged
        mob:addMod(xi.mod.ATT, 15)
        mob:addMod(xi.mod.DEF, 10)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        -- Standard
    end,
}

-----------------------------------
-- NOMAD BEHAVIORS
-----------------------------------

-- Nomad predator: aggressive, patrols large area
behaviorDb.nomad_predator =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 5)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 20)  -- Wide patrol
        mob:setMobMod(xi.mobMod.SIGHT_RANGE, 18)
        mob:setMobMod(xi.mobMod.NO_LINK, 1)    -- Solo predator, no links
        -- Stat boost
        mob:addMod(xi.mod.ATT, 25)
        mob:addMod(xi.mod.DEF, 20)
        mob:addMod(xi.mod.ACC, 15)
    end,

    onMobRoam = function(mob, template, tier)
        -- Check if migrating
        if mob:getLocalVar('DW_MIGRATING') == 1 then
            -- Path toward a random direction aggressively
            local x = mob:getXPos() + (math.random() * 40 - 20)
            local z = mob:getZPos() + (math.random() * 40 - 20)
            mob:pathTo(x, mob:getYPos(), z)
        end
    end,

    onMobEngaged = function(mob, target, template, tier)
        -- Nomad predators get a damage bonus
        mob:addMod(xi.mod.ATT, 30)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        -- Standard
    end,
}

-- Ghost nomad: magic-focused, phases in and out
behaviorDb.nomad_ghost =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 10)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 15)
        -- Magic-focused stats
        mob:addMod(xi.mod.MATT, 30)
        mob:addMod(xi.mod.MDEF, 30)
        mob:addMod(xi.mod.INT, 15)
        mob:addMod(xi.mod.MND, 15)
        -- Lower physical stats
        mob:addMod(xi.mod.DEF, -10)
    end,

    onMobRoam = function(mob, template, tier)
        -- Periodically become untargetable briefly (phase effect)
        local lastPhase = mob:getLocalVar('DW_LAST_PHASE')
        local now = os.time()
        if now - lastPhase > 60 then
            mob:setLocalVar('DW_LAST_PHASE', now)
            -- Brief invisibility animation
            mob:setAnimationSub(1)
            mob:timer(3000, function(m)
                if m and m:isAlive() then
                    m:setAnimationSub(0)
                end
            end)
        end
    end,

    onMobEngaged = function(mob, target, template, tier)
        mob:addMod(xi.mod.MATT, 20)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        -- Standard
    end,
}

-- Treasure Goblin: runs away, drops amazing loot
behaviorDb.treasure_goblin =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 3)       -- Very active
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 25)  -- Wide roam
        -- Fast but weak
        mob:addMod(xi.mod.EVA, 50)
        mob:addMod(xi.mod.AGI, 30)
        mob:addMod(xi.mod.ATT, -30)
        mob:addMod(xi.mod.DEF, -20)
        -- Set flee timer
        mob:setLocalVar('DW_FLEE_TIME', os.time() + 120) -- Despawns after 2 minutes
    end,

    onMobRoam = function(mob, template, tier)
        -- Check flee timer
        local fleeTime = mob:getLocalVar('DW_FLEE_TIME')
        if fleeTime > 0 and os.time() >= fleeTime then
            -- Goblin escaped!
            xi.dynamicWorld.announceNearby(mob:getZone(), mob, 50,
                '[Dynamic World] The Treasure Goblin escaped with its loot!'
            )
            mob:setHP(0)
            return
        end

        -- Run away from nearest player
        local zone = mob:getZone()
        local players = zone and zone:getPlayers()
        if players then
            local nearestDist = 999
            local nearestPlayer = nil
            for _, player in pairs(players) do
                local dist = xi.dynamicWorld.safeDistance(mob, player)
                if dist < nearestDist then
                    nearestDist = dist
                    nearestPlayer = player
                end
            end

            if nearestPlayer and nearestDist < 30 then
                -- Run in opposite direction
                local dx = mob:getXPos() - nearestPlayer:getXPos()
                local dz = mob:getZPos() - nearestPlayer:getZPos()
                local len = math.sqrt(dx * dx + dz * dz)
                if len > 0 then
                    dx = dx / len * 15
                    dz = dz / len * 15
                    mob:pathTo(mob:getXPos() + dx, mob:getYPos(), mob:getZPos() + dz)
                end
            end
        end
    end,

    onMobEngaged = function(mob, target, template, tier)
        -- Goblin panics! Tries to flee
        mob:addMod(xi.mod.EVA, 30)

        -- Announce
        target:printToPlayer(
            '[Dynamic World] The Treasure Goblin squeals in panic!',
            xi.msg.channel.SYSTEM_3
        )
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        player:printToPlayer(
            '[Dynamic World] The Treasure Goblin bursts open, scattering treasure!',
            xi.msg.channel.SYSTEM_3
        )
    end,
}

-- Merchant NPC: placeholder for future implementation
behaviorDb.nomad_merchant =
{
    onMobSpawn = function(mob, template, tier)
        -- Merchant behavior - non-hostile
        mob:setMobMod(xi.mobMod.NO_MOVE, 0)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 8)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 20)
    end,

    onMobRoam = function(mob, template, tier)
        -- Slow patrol
    end,

    onMobEngaged = function(mob, target, template, tier)
        -- Don't fight back
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        -- Sad message
        player:printToPlayer(
            '[Dynamic World] The merchant falls... their wares scatter to the wind.',
            xi.msg.channel.SYSTEM_3
        )
    end,
}

-----------------------------------
-- ELITE BEHAVIORS
-----------------------------------

-- Elite hunter: powerful single target
behaviorDb.elite_hunter =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 6)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 18)
        mob:setMobMod(xi.mobMod.SIGHT_RANGE, 25)
        -- Significant stat boost
        mob:addMod(xi.mod.ATT, 50)
        mob:addMod(xi.mod.DEF, 40)
        mob:addMod(xi.mod.ACC, 30)
        mob:addMod(xi.mod.EVA, 20)
        mob:addMod(xi.mod.DOUBLE_ATTACK, 15)
    end,

    onMobRoam = function(mob, template, tier)
        -- Nothing special
    end,

    onMobEngaged = function(mob, target, template, tier)
        -- Rage: gets stronger the longer the fight
        mob:addMod(xi.mod.ATT, 20)
        mob:setLocalVar('DW_ENGAGE_TIME', os.time())

        -- Set a rage timer
        mob:timer(30000, function(m)
            if m and m:isAlive() and m:isEngaged() then
                m:addMod(xi.mod.ATT, 30)
                m:addMod(xi.mod.DOUBLE_ATTACK, 10)

                xi.dynamicWorld.announceNearby(m:getZone(), m, 30,
                    string.format('[Dynamic World] %s is enraged!', template.packetName)
                )
            end
        end)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        -- Standard
    end,
}

-- Elite commander: summons reinforcements
behaviorDb.elite_commander =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 10)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 12)
        mob:addMod(xi.mod.ATT, 35)
        mob:addMod(xi.mod.DEF, 50)
        mob:addMod(xi.mod.ACC, 20)
        mob:setLocalVar('DW_ADDS_SPAWNED', 0)
    end,

    onMobEngaged = function(mob, target, template, tier)
        -- Spawn 1-2 wanderer adds on engage
        local zone = mob:getZone()
        if zone and mob:getLocalVar('DW_ADDS_SPAWNED') == 0 then
            mob:setLocalVar('DW_ADDS_SPAWNED', 1)
            local addCount = math.random(1, 2)
            for i = 1, addCount do
                local addRef = pickGroupRef(template)  -- one pick per add, consistent pair
                local addEntity = zone:insertDynamicEntity({
                    objtype = xi.objType.MOB,
                    name = 'Rallied_Grunt',
                    packetName = 'Rallied Grunt',
                    x = mob:getXPos() + math.random(-3, 3),
                    y = mob:getYPos(),
                    z = mob:getZPos() + math.random(-3, 3),
                    rotation = mob:getRotPos(),
                    groupId = addRef.groupId,
                    groupZoneId = addRef.groupZoneId,
                    minLevel = math.max(1, mob:getMainLvl() - 5),
                    maxLevel = mob:getMainLvl() - 2,
                    releaseIdOnDisappear = true,
                    specialSpawnAnimation = true,
                    onMobSpawn = function(addMob)
                        addMob:addMod(xi.mod.ATT, 15)
                        addMob:addMod(xi.mod.DEF, 15)
                    end,
                })
                if addEntity then
                    addEntity:setSpawn(
                        mob:getXPos() + math.random(-3, 3),
                        mob:getYPos(),
                        mob:getZPos() + math.random(-3, 3),
                        mob:getRotPos()
                    )
                    addEntity:spawn()
                    addEntity:updateEnmity(target)
                end
            end

            target:printToPlayer(
                string.format('[Dynamic World] %s calls for reinforcements!', template.packetName),
                xi.msg.channel.SYSTEM_3
            )
        end
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        -- Standard
    end,
}

-- Elite tank: very durable, slow
behaviorDb.elite_tank =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 20)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 6)
        -- Tank stats
        mob:addMod(xi.mod.DEF, 80)
        mob:addMod(xi.mod.VIT, 30)
        mob:addMod(xi.mod.ATT, 20)
        mob:addMod(xi.mod.MDEF, 40)
        -- Slow but hard hitting
        mob:addMod(xi.mod.DELAY, 200)
    end,

    onMobEngaged = function(mob, target, template, tier)
        mob:addMod(xi.mod.STONESKIN, 500)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        -- Standard
    end,
}

-- Elite elemental: magic damage, grants aura buff
behaviorDb.elite_elemental =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 12)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 10)
        mob:addMod(xi.mod.MATT, 60)
        mob:addMod(xi.mod.MDEF, 50)
        mob:addMod(xi.mod.INT, 25)
        mob:addMod(xi.mod.DEF, -20)
        mob:setLocalVar('DW_AURA_LAST_TICK', 0)
    end,

    onMobRoam = function(mob, template, tier)
        pulseAura(mob,
            '[Dynamic World] You feel energized by the elemental surge! (EXP +15%)',
            (getSetting('APEX_AURA_RANGE') or 50) * 0.5
        )
    end,

    onMobEngaged = function(mob, target, template, tier)
        mob:addMod(xi.mod.MATT, 30)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        -- Standard
    end,
}

-----------------------------------
-- APEX BEHAVIORS
-----------------------------------

-- Apex dragon: massive boss, spawns minions at HP thresholds
behaviorDb.apex_dragon =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 15)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 10)
        mob:setMobMod(xi.mobMod.SIGHT_RANGE, 30)
        -- Boss stats
        mob:addMod(xi.mod.ATT, 100)
        mob:addMod(xi.mod.DEF, 80)
        mob:addMod(xi.mod.ACC, 50)
        mob:addMod(xi.mod.EVA, 30)
        mob:addMod(xi.mod.MATT, 50)
        mob:addMod(xi.mod.MDEF, 50)
        mob:addMod(xi.mod.DOUBLE_ATTACK, 20)
        mob:addMod(xi.mod.HP, 5000)
        mob:setLocalVar('DW_75_SPAWNED', 0)
        mob:setLocalVar('DW_50_SPAWNED', 0)
        mob:setLocalVar('DW_25_SPAWNED', 0)
        mob:setLocalVar('DW_AURA_LAST_TICK', 0)
    end,

    onMobRoam = function(mob, template, tier)
        pulseAura(mob, '[Dynamic World] The Void Wyrm\'s presence empowers you! (EXP +25%)')
    end,

    onMobEngaged = function(mob, target, template, tier)
        announceZone(mob:getZone(),
            string.format('[Dynamic World] %s has been engaged! The ground trembles!',
                template.packetName)
        )

        -- Spawn initial minions
        if getSetting('APEX_MINION_SPAWN_ON_ENGAGE') then
            behaviors.spawnApexMinions(mob, target, template, 2)
        end
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        announceZone(mob:getZone(),
            string.format('[Dynamic World] %s has been defeated! The world breathes easier.',
                template.packetName)
        )
    end,
}

-- Apex demon: summons shades from the void
behaviorDb.apex_demon =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 12)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 12)
        mob:setMobMod(xi.mobMod.SIGHT_RANGE, 25)
        mob:addMod(xi.mod.ATT, 80)
        mob:addMod(xi.mod.DEF, 70)
        mob:addMod(xi.mod.MATT, 80)
        mob:addMod(xi.mod.MDEF, 60)
        mob:addMod(xi.mod.ACC, 40)
        mob:addMod(xi.mod.HP, 8000)
        mob:addMod(xi.mod.DOUBLE_ATTACK, 15)
        mob:setLocalVar('DW_SUMMON_COUNT', 0)
        mob:setLocalVar('DW_AURA_LAST_TICK', 0)
    end,

    onMobRoam = function(mob, template, tier)
        -- Periodically summon shade minions while roaming
        local summonCount = mob:getLocalVar('DW_SUMMON_COUNT')
        if summonCount < 3 then
            local now = os.time()
            local lastSummon = mob:getLocalVar('DW_LAST_SUMMON')
            if now - lastSummon > 120 then
                mob:setLocalVar('DW_LAST_SUMMON', now)
                mob:setLocalVar('DW_SUMMON_COUNT', summonCount + 1)
                -- Spawn a shade near the demon
                behaviors.spawnApexMinions(mob, nil, template, 1)
            end
        end

        -- Apex aura
        pulseAura(mob, '[Dynamic World] Dark energy radiates from the Abyssal Tyrant! (EXP +25%)')
    end,

    onMobEngaged = function(mob, target, template, tier)
        announceZone(mob:getZone(),
            string.format('[Dynamic World] %s tears open a rift to the void!', template.packetName)
        )
        behaviors.spawnApexMinions(mob, target, template, 3)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        announceZone(mob:getZone(),
            string.format('[Dynamic World] %s collapses into the rift! Silence returns.', template.packetName)
        )
    end,
}

-- Apex king: commands an army
behaviorDb.apex_king =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 20)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 8)
        mob:addMod(xi.mod.ATT, 90)
        mob:addMod(xi.mod.DEF, 100)
        mob:addMod(xi.mod.ACC, 50)
        mob:addMod(xi.mod.EVA, 30)
        mob:addMod(xi.mod.HP, 10000)
        mob:addMod(xi.mod.DOUBLE_ATTACK, 25)
        mob:addMod(xi.mod.MDEF, 40)
        mob:setLocalVar('DW_ARMY_WAVES', 0)
        mob:setLocalVar('DW_AURA_LAST_TICK', 0)

        -- Immediately spawn a retinue
        mob:timer(5000, function(m)
            if m and m:isAlive() then
                behaviors.spawnApexMinions(m, nil, template, 3)
            end
        end)
    end,

    onMobRoam = function(mob, template, tier)
        pulseAura(mob, '[Dynamic World] The Ancient King\'s presence commands respect! (EXP +25%)')
    end,

    onMobEngaged = function(mob, target, template, tier)
        announceZone(mob:getZone(),
            string.format('[Dynamic World] %s roars: "You dare challenge a KING?!"', template.packetName)
        )
        behaviors.spawnApexMinions(mob, target, template, 4)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        announceZone(mob:getZone(),
            '[Dynamic World] The Ancient King falls! His crown clatters to the ground.'
        )
    end,
}

-----------------------------------
-- HELPER: Spawn Apex Minions
-----------------------------------
behaviors.spawnApexMinions = function(mob, target, template, count)
    local zone = mob:getZone()
    if not zone then
        return
    end

    local minCount = getSetting('APEX_MINION_MIN') or 2
    local maxCount = getSetting('APEX_MINION_MAX') or 5
    count = math.min(count or minCount, maxCount)

    -- Determine minion template
    local minionKey = template.minionTemplate or 'empowered_hare'
    local minionTemplate = xi.dynamicWorld.templates.get(minionKey)
    if not minionTemplate then
        return
    end

    for i = 1, count do
        local offsetX = math.random(-5, 5)
        local offsetZ = math.random(-5, 5)

        local groupRef = pickGroupRef(minionTemplate)
        if not groupRef then
            break
        end

        local minion = zone:insertDynamicEntity({
            objtype = xi.objType.MOB,
            name = minionTemplate.name:gsub(' ', '_'),
            packetName = minionTemplate.packetName,
            x = mob:getXPos() + offsetX,
            y = mob:getYPos(),
            z = mob:getZPos() + offsetZ,
            rotation = math.random(0, 255),
            groupId = groupRef.groupId,
            groupZoneId = groupRef.groupZoneId,
            minLevel = math.max(1, mob:getMainLvl() - 10),
            maxLevel = math.max(1, mob:getMainLvl() - 5),
            releaseIdOnDisappear = true,
            specialSpawnAnimation = true,
            onMobSpawn = function(addMob)
                addMob:addMod(xi.mod.ATT, 20)
                addMob:addMod(xi.mod.DEF, 15)
            end,
        })

        if minion then
            minion:setSpawn(
                mob:getXPos() + offsetX,
                mob:getYPos(),
                mob:getZPos() + offsetZ,
                math.random(0, 255)
            )
            minion:spawn()

            -- Engage the target if one exists
            if target then
                minion:updateEnmity(target)
            end
        end
    end
end
