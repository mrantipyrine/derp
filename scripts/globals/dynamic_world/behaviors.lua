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

local function notifyKillerOrNearby(mob, player, msg)
    if player then
        player:printToPlayer(msg, xi.msg.channel.SYSTEM_3)
        return
    end

    xi.dynamicWorld.announceNearby(mob:getZone(), mob, 50, msg)
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

-- Blessing keeper: light roaming mob that exists to grant a regional blessing.
behaviorDb.blessing_keeper =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 6)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 18)
        mob:setMobMod(xi.mobMod.NO_LINK, 1)
        mob:setMobMod(xi.mobMod.NO_AGGRO, 1)
        mob:addMod(xi.mod.DEF, 10)
        mob:addMod(xi.mod.MDEF, 10)
    end,

    onMobRoam = function(mob, template, tier)
        pulseAura(mob, string.format('[Dynamic World] %s wanders nearby. Hunt it for a regional blessing.', template.packetName), 35)
    end,

    onMobEngaged = function(mob, target, template, tier)
        if target and target:isPC() then
            target:printToPlayer(
                string.format('[Dynamic World] %s carries a blessing. Finish it before someone else does.', template.packetName),
                xi.msg.channel.SYSTEM_3
            )
        end
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        notifyKillerOrNearby(mob, player, string.format('[Dynamic World] %s releases a regional blessing.', template.packetName))
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
        if target:isPC() then
            target:printToPlayer(
                '[Dynamic World] The Treasure Goblin squeals in panic!',
                xi.msg.channel.SYSTEM_3
            )
        end
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        notifyKillerOrNearby(mob, player, '[Dynamic World] The Treasure Goblin bursts open, scattering treasure!')
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
        notifyKillerOrNearby(mob, player, '[Dynamic World] The merchant falls... their wares scatter to the wind.')
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

            if target:isPC() then
                target:printToPlayer(
                    string.format('[Dynamic World] %s calls for reinforcements!', template.packetName),
                    xi.msg.channel.SYSTEM_3
                )
            end
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
        xi.dynamicWorld.announceZone(mob:getZone(),
            string.format('[Dynamic World] %s has been engaged! The ground trembles!',
                template.packetName)
        )

        -- Spawn initial minions
        if getSetting('APEX_MINION_SPAWN_ON_ENGAGE') then
            behaviors.spawnApexMinions(mob, target, template, 2)
        end
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(),
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
        xi.dynamicWorld.announceZone(mob:getZone(),
            string.format('[Dynamic World] %s tears open a rift to the void!', template.packetName)
        )
        behaviors.spawnApexMinions(mob, target, template, 3)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(),
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
        xi.dynamicWorld.announceZone(mob:getZone(),
            string.format('[Dynamic World] %s roars: "You dare challenge a KING?!"', template.packetName)
        )
        behaviors.spawnApexMinions(mob, target, template, 4)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(),
            '[Dynamic World] The Ancient King falls! His crown clatters to the ground.'
        )
    end,
}

local function spawnDudeCompanion(parent, target, templateKey, levelPenalty)
    local zone = parent:getZone()
    if not zone then
        return nil
    end

    local template = xi.dynamicWorld.templates.get(templateKey)
    if not template then
        return nil
    end

    local groupRef = pickGroupRef(template)
    if not groupRef then
        return nil
    end

    local parentLevel = parent:getMainLvl() or 125
    local levelCap = template.levelCap or parentLevel
    local level = math.min(levelCap, math.max(100, parentLevel - (levelPenalty or 0)))
    local offsetX = math.random(-6, 6)
    local offsetZ = math.random(-6, 6)
    local behaviorSet = behaviorDb[template.behavior]

    local companion = zone:insertDynamicEntity({
        objtype = xi.objType.MOB,
        name = template.name:gsub(' ', '_'),
        packetName = template.packetName,
        x = parent:getXPos() + offsetX,
        y = parent:getYPos(),
        z = parent:getZPos() + offsetZ,
        rotation = math.random(0, 255),
        groupId = groupRef.groupId,
        groupZoneId = groupRef.groupZoneId,
        minLevel = level,
        maxLevel = level,
        releaseIdOnDisappear = true,
        specialSpawnAnimation = true,
        onMobSpawn = function(mob)
            mob:setLocalVar('DW_TIER', xi.dynamicWorld.tier.POWER_KING)
            mob:setLocalVar('DW_SPAWN_TIME', os.time())
            mob:renameEntity(template.packetName)
            if behaviorSet and behaviorSet.onMobSpawn then
                behaviorSet.onMobSpawn(mob, template, xi.dynamicWorld.tier.POWER_KING)
            end
        end,
        onMobRoam = function(mob)
            if behaviorSet and behaviorSet.onMobRoam then
                behaviorSet.onMobRoam(mob, template, xi.dynamicWorld.tier.POWER_KING)
            end
        end,
        onMobEngaged = function(mob, engagedTarget)
            if behaviorSet and behaviorSet.onMobEngaged then
                behaviorSet.onMobEngaged(mob, engagedTarget, template, xi.dynamicWorld.tier.POWER_KING)
            end
        end,
        onMobDeath = function(mob, player, optParams)
            if behaviorSet and behaviorSet.onMobDeath then
                behaviorSet.onMobDeath(mob, player, optParams, template, xi.dynamicWorld.tier.POWER_KING)
            end

            if player and getSetting('LOOT_ENABLED') then
                xi.dynamicWorld.loot.award(mob, player, template, xi.dynamicWorld.tier.POWER_KING)
            end
        end,
    })

    if companion then
        companion:setSpawn(parent:getXPos() + offsetX, parent:getYPos(), parent:getZPos() + offsetZ, math.random(0, 255))
        companion:spawn()
        if target then
            companion:updateEnmity(target)
        end
    end

    return companion
end

-----------------------------------
-- POWER KING BEHAVIORS
-----------------------------------

behaviorDb.power_king_dragon =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 18)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 6)
        mob:setMobMod(xi.mobMod.SIGHT_RANGE, 35)
        mob:addMod(xi.mod.ATT, 260)
        mob:addMod(xi.mod.DEF, 220)
        mob:addMod(xi.mod.ACC, 160)
        mob:addMod(xi.mod.EVA, 80)
        mob:addMod(xi.mod.MATT, 160)
        mob:addMod(xi.mod.MDEF, 140)
        mob:addMod(xi.mod.DOUBLE_ATTACK, 35)
        mob:addMod(xi.mod.HP, 25000)
        mob:setLocalVar('DW_AURA_LAST_TICK', 0)
        mob:setLocalVar('DW_POWER_KING_ADDS', 0)

        mob:timer(4000, function(m)
            if m and m:isAlive() then
                behaviors.spawnApexMinions(m, nil, template, 5)
            end
        end)
    end,

    onMobRoam = function(mob, template, tier)
        pulseAura(mob, '[Dynamic World] A Power King bends the dungeon around you! (EXP +25%)', 65)
    end,

    onMobEngaged = function(mob, target, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(),
            string.format('[Dynamic World] %s wakes up angry. This is a level 100+ Power King!', template.packetName)
        )
        behaviors.spawnApexMinions(mob, target, template, 5)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(),
            string.format('[Dynamic World] %s has been destroyed! The dungeon goes quiet.', template.packetName)
        )
    end,
}

behaviorDb.power_king_demon =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 10)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 12)
        mob:setMobMod(xi.mobMod.SIGHT_RANGE, 30)
        mob:addMod(xi.mod.ATT, 180)
        mob:addMod(xi.mod.DEF, 170)
        mob:addMod(xi.mod.ACC, 140)
        mob:addMod(xi.mod.MATT, 260)
        mob:addMod(xi.mod.MDEF, 180)
        mob:addMod(xi.mod.DOUBLE_ATTACK, 20)
        mob:addMod(xi.mod.HP, 22000)
        mob:setLocalVar('DW_AURA_LAST_TICK', 0)
        mob:setLocalVar('DW_SUMMON_COUNT', 0)
    end,

    onMobRoam = function(mob, template, tier)
        local summonCount = mob:getLocalVar('DW_SUMMON_COUNT')
        if summonCount < 5 then
            local now = os.time()
            local lastSummon = mob:getLocalVar('DW_LAST_SUMMON')
            if now - lastSummon > 90 then
                mob:setLocalVar('DW_LAST_SUMMON', now)
                mob:setLocalVar('DW_SUMMON_COUNT', summonCount + 1)
                behaviors.spawnApexMinions(mob, nil, template, 2)
            end
        end

        pulseAura(mob, '[Dynamic World] A Power King floods the dungeon with dark force! (EXP +25%)', 65)
    end,

    onMobEngaged = function(mob, target, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(),
            string.format('[Dynamic World] %s opens every gate at once. Bring friends.', template.packetName)
        )
        behaviors.spawnApexMinions(mob, target, template, 5)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(),
            string.format('[Dynamic World] %s is sealed. For now.', template.packetName)
        )
    end,
}

behaviorDb.power_king_monarch =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 25)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 5)
        mob:addMod(xi.mod.ATT, 220)
        mob:addMod(xi.mod.DEF, 300)
        mob:addMod(xi.mod.ACC, 140)
        mob:addMod(xi.mod.MDEF, 180)
        mob:addMod(xi.mod.DOUBLE_ATTACK, 30)
        mob:addMod(xi.mod.HP, 30000)
        mob:setLocalVar('DW_AURA_LAST_TICK', 0)

        mob:timer(5000, function(m)
            if m and m:isAlive() then
                behaviors.spawnApexMinions(m, nil, template, 5)
            end
        end)
    end,

    onMobRoam = function(mob, template, tier)
        pulseAura(mob, '[Dynamic World] A Power King claims this dungeon! (EXP +25%)', 65)
    end,

    onMobEngaged = function(mob, target, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(),
            string.format('[Dynamic World] %s accepts your challenge and calls the court.', template.packetName)
        )
        behaviors.spawnApexMinions(mob, target, template, 5)
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(),
            string.format('[Dynamic World] %s falls. The crown is up for grabs.', template.packetName)
        )
    end,
}

local function applyDudeKingMods(mob, stats)
    mob:setMobMod(xi.mobMod.CHECK_AS_NM, 1)
    mob:setMobMod(xi.mobMod.NO_DESPAWN, 1)
    mob:setMobMod(xi.mobMod.ALLI_HATE, stats.allianceHate or 35)
    mob:setMobMod(xi.mobMod.MULTI_HIT, stats.multiHit)
    mob:setMobMod(xi.mobMod.TP_USE_CHANCE, stats.tpUse)
    mob:setMobMod(xi.mobMod.WEAPON_BONUS, stats.weaponBonus)

    mob:addMod(xi.mod.HP, stats.hp)
    mob:addMod(xi.mod.ATT, stats.attack)
    mob:addMod(xi.mod.DEF, stats.defense)
    mob:addMod(xi.mod.ACC, stats.accuracy)
    mob:addMod(xi.mod.EVA, stats.evasion)
    mob:addMod(xi.mod.MATT, stats.magicAttack)
    mob:addMod(xi.mod.MDEF, stats.magicDefense)
    mob:addMod(xi.mod.DOUBLE_ATTACK, stats.doubleAttack)
    mob:addMod(xi.mod.TRIPLE_ATTACK, stats.tripleAttack)
    mob:addMod(xi.mod.DMG, stats.damageTaken)
    mob:addMod(xi.mod.DMGPHYS, stats.physicalTaken)
    mob:addMod(xi.mod.DMGMAGIC, stats.magicTaken)
    mob:addMod(xi.mod.DMGRANGE, stats.rangedTaken)
    mob:addMod(xi.mod.REGAIN, stats.regain)
    mob:addMod(xi.mod.REGEN, stats.regen)
    mob:addMod(xi.mod.STORETP, stats.storeTp)
    mob:addMod(xi.mod.CRITHITRATE, stats.critRate)

    mob:setLocalVar('DW_AURA_LAST_TICK', 0)
end

local function triggerDudePhase(mob, template, threshold, minionCount, message)
    local phaseKey = string.format('DW_DUDE_PHASE_%u', threshold)
    if mob:getHPP() <= threshold and mob:getLocalVar(phaseKey) == 0 then
        mob:setLocalVar(phaseKey, 1)
        xi.dynamicWorld.announceZone(mob:getZone(), message)
        behaviors.spawnApexMinions(mob, nil, template, minionCount)
    end
end

local function startDudePhaseWatcher(mob, template, phases)
    mob:timer(5000, function(m)
        if not m or not m:isAlive() then
            return
        end

        for _, phase in ipairs(phases) do
            triggerDudePhase(m, template, phase.threshold, phase.minions, phase.message)
        end

        startDudePhaseWatcher(m, template, phases)
    end)
end

behaviorDb.dude_dragon =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 6)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 14)
        mob:setMobMod(xi.mobMod.SIGHT_RANGE, 35)
        applyDudeKingMods(mob, {
            hp            = 85000,
            attack        = 650,
            defense       = 480,
            accuracy      = 360,
            evasion       = 220,
            magicAttack   = 300,
            magicDefense  = 320,
            doubleAttack  = 70,
            tripleAttack  = 35,
            damageTaken   = -1500,
            physicalTaken = -2500,
            magicTaken    = -1500,
            rangedTaken   = -1500,
            regain        = 120,
            regen         = 150,
            storeTp       = 50,
            critRate      = 25,
            multiHit      = 4,
            tpUse         = 90,
            weaponBonus   = 450,
            allianceHate  = 35,
        })
        startDudePhaseWatcher(mob, template, {
            { threshold = 50, minions = 2, message = '[Dynamic World] Dude calls in a tiny amount of unacceptable help.' },
        })
    end,

    onMobRoam = function(mob, template, tier)
        pulseAura(mob, '[Dynamic World] Dude is somehow tiny and terrifying. (EXP +25%)', 65)
        triggerDudePhase(mob, template, 50, 2, '[Dynamic World] Dude calls in a tiny amount of unacceptable help.')
    end,

    onMobEngaged = function(mob, target, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(), '[Dynamic World] Dude says: sup.')
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(), '[Dynamic World] Dude has been humbled.')
    end,
}

behaviorDb.dude_bro_dragon =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 8)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 12)
        mob:setMobMod(xi.mobMod.SIGHT_RANGE, 35)
        mob:setMobMod(xi.mobMod.GA_CHANCE, 50)
        mob:setMobMod(xi.mobMod.MAGIC_COOL, 12)
        mob:setMobMod(xi.mobMod.SEVERE_SPELL_CHANCE, 20)
        applyDudeKingMods(mob, {
            hp            = 110000,
            attack        = 720,
            defense       = 540,
            accuracy      = 390,
            evasion       = 240,
            magicAttack   = 420,
            magicDefense  = 380,
            doubleAttack  = 75,
            tripleAttack  = 40,
            damageTaken   = -2000,
            physicalTaken = -3000,
            magicTaken    = -2000,
            rangedTaken   = -2000,
            regain        = 150,
            regen         = 220,
            storeTp       = 65,
            critRate      = 30,
            multiHit      = 5,
            tpUse         = 95,
            weaponBonus   = 600,
            allianceHate  = 45,
        })
        startDudePhaseWatcher(mob, template, {
            { threshold = 66, minions = 2, message = '[Dynamic World] Dude Bro makes this everyone else\'s problem.' },
            { threshold = 33, minions = 3, message = '[Dynamic World] Dude Bro escalates for no defensible reason.' },
        })
    end,

    onMobRoam = function(mob, template, tier)
        pulseAura(mob, '[Dynamic World] Dude Bro is making the whole dungeon worse. (EXP +25%)', 65)
        triggerDudePhase(mob, template, 66, 2, '[Dynamic World] Dude Bro makes this everyone else\'s problem.')
        triggerDudePhase(mob, template, 33, 3, '[Dynamic World] Dude Bro escalates for no defensible reason.')
    end,

    onMobEngaged = function(mob, target, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(), '[Dynamic World] Dude Bro brought bad ideas.')
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(), '[Dynamic World] Dude Bro is no longer broing out.')
    end,
}

behaviorDb.sir_dude_dragon =
{
    onMobSpawn = function(mob, template, tier)
        mob:setRoamFlags(xi.roamFlag.NONE)
        mob:setMobMod(xi.mobMod.ROAM_COOL, 20)
        mob:setMobMod(xi.mobMod.ROAM_DISTANCE, 4)
        mob:setMobMod(xi.mobMod.SIGHT_RANGE, 45)
        mob:setMobMod(xi.mobMod.GA_CHANCE, 75)
        mob:setMobMod(xi.mobMod.SEVERE_SPELL_CHANCE, 50)
        mob:setMobMod(xi.mobMod.MAGIC_COOL, 8)
        applyDudeKingMods(mob, {
            hp            = 180000,
            attack        = 950,
            defense       = 800,
            accuracy      = 500,
            evasion       = 300,
            magicAttack   = 650,
            magicDefense  = 550,
            doubleAttack  = 90,
            tripleAttack  = 55,
            damageTaken   = -2500,
            physicalTaken = -3500,
            magicTaken    = -2500,
            rangedTaken   = -2500,
            regain        = 220,
            regen         = 400,
            storeTp       = 100,
            critRate      = 40,
            multiHit      = 7,
            tpUse         = 100,
            weaponBonus   = 900,
            allianceHate  = 60,
        })
        mob:setLocalVar('DW_DUDES_SPAWNED', 0)
        startDudePhaseWatcher(mob, template, {
            { threshold = 75, minions = 3, message = '[Dynamic World] Sir Dude asks the dungeon to stop holding back.' },
            { threshold = 50, minions = 4, message = '[Dynamic World] Sir Dude enters the bad half of the fight.' },
            { threshold = 25, minions = 5, message = '[Dynamic World] Sir Dude is now personally offended.' },
        })

        mob:timer(1000, function(m)
            if m and m:isAlive() and m:getLocalVar('DW_DUDES_SPAWNED') == 0 then
                m:setLocalVar('DW_DUDES_SPAWNED', 1)
                spawnDudeCompanion(m, nil, 'dude', 3)
                spawnDudeCompanion(m, nil, 'dude_bro', 1)
                xi.dynamicWorld.announceZone(m:getZone(), '[Dynamic World] Dude, Dude Bro, and Sir Dude have entered the dungeon.')
            end
        end)
    end,

    onMobRoam = function(mob, template, tier)
        pulseAura(mob, '[Dynamic World] Sir Dude owns this place. (EXP +25%)', 80)
        triggerDudePhase(mob, template, 75, 3, '[Dynamic World] Sir Dude asks the dungeon to stop holding back.')
        triggerDudePhase(mob, template, 50, 4, '[Dynamic World] Sir Dude enters the bad half of the fight.')
        triggerDudePhase(mob, template, 25, 5, '[Dynamic World] Sir Dude is now personally offended.')
    end,

    onMobEngaged = function(mob, target, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(), '[Dynamic World] Sir Dude has accepted your extremely poor decision.')
        if mob:getLocalVar('DW_DUDES_SPAWNED') == 0 then
            mob:setLocalVar('DW_DUDES_SPAWNED', 1)
            spawnDudeCompanion(mob, target, 'dude', 3)
            spawnDudeCompanion(mob, target, 'dude_bro', 1)
        end
    end,

    onMobDeath = function(mob, player, optParams, template, tier)
        xi.dynamicWorld.announceZone(mob:getZone(), '[Dynamic World] Sir Dude has fallen. The King of Kings is dead.')
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
                addMob:renameEntity(minionTemplate.packetName)
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
