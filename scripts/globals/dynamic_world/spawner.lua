-----------------------------------
-- Dynamic World: Spawner
-----------------------------------
-- Manages entity lifecycle: spawn budget, placement, cleanup.
-- Called from the main tick in dynamic_world.lua.
-----------------------------------

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.spawner = xi.dynamicWorld.spawner or {}

local spawner = xi.dynamicWorld.spawner

-----------------------------------
-- Settings helpers
-----------------------------------
local function getSetting(key)
    local s = xi.settings.dynamicworld
    return s and s[key]
end

-----------------------------------
-- Pick a random groupRef from a template.
-- Templates can define a single 'groupRef' or a 'groupRefs' array for
-- visual variety (different mob_groups rows = different models/sizes).
-- At spawn time we pick one at random, giving each entity a different look.
--
-- To add size variants for a template, query your DB:
--   SELECT groupid, zoneid, name FROM mob_groups
--   WHERE name LIKE '%Rabbit%' ORDER BY name;
-- Then populate groupRefs with the rows that represent small/medium/large
-- or different visual versions of that mob family.
-----------------------------------
local function pickGroupRef(template)
    local refs = template.groupRefs
    if refs and #refs > 0 then
        return refs[math.random(#refs)]
    end
    return template.groupRef
end

-----------------------------------
-- Evaluate: decide whether to spawn new entities in a zone
-----------------------------------
spawner.evaluate = function(zone, zd, state)
    local maxPerZone = getSetting('MAX_ENTITIES_PER_ZONE') or 15
    local globalCap  = getSetting('GLOBAL_ENTITY_CAP') or 500
    local batchSize  = getSetting('MAX_SPAWN_BATCH_SIZE') or 3

    -- Cleanup dead entities first
    spawner.cleanup(zone, zd, state)

    -- Check caps
    if state.globalCount >= globalCap then
        return
    end

    if zd.count >= maxPerZone then
        return
    end

    -- Despawn entities in empty zones
    local players = zone:getPlayers()
    local playerCount = 0
    if players then
        for _ in pairs(players) do
            playerCount = playerCount + 1
        end
    end

    if playerCount == 0 then
        local despawnTime = getSetting('DESPAWN_EMPTY_ZONE_TIME') or 600
        -- Don't spawn in empty zones, and gradually despawn existing ones
        for targid, entData in pairs(zd.entities) do
            if os.time() - entData.spawnTime > despawnTime then
                spawner.despawnEntity(zone, zd, state, targid)
            end
        end
        return
    end

    -- Calculate desired entity count based on player presence
    -- More players = more spawns (up to cap)
    local desiredCount = math.min(
        math.floor(3 + playerCount * 1.5),
        maxPerZone
    )

    local toSpawn = math.min(desiredCount - zd.count, batchSize, globalCap - state.globalCount)

    if toSpawn <= 0 then
        return
    end

    -- Roll tiers and spawn
    for i = 1, toSpawn do
        local tier = spawner.rollTier()
        spawner.spawnEntity(zone, zd, state, tier)
    end
end

-----------------------------------
-- Roll a tier based on configured weights
-----------------------------------
spawner.rollTier = function()
    local weights = {
        getSetting('TIER_WEIGHT_WANDERER') or 55,
        getSetting('TIER_WEIGHT_NOMAD') or 20,
        getSetting('TIER_WEIGHT_ELITE') or 15,
        getSetting('TIER_WEIGHT_APEX') or 10,
    }

    return xi.dynamicWorld.weightedRandom(weights)
end

-----------------------------------
-- Spawn a single entity of given tier in a zone
-----------------------------------
spawner.spawnEntity = function(zone, zd, state, tier)
    local zoneId = zone:getID()
    local regionName = state.zoneToRegion[zoneId]

    -- Get valid templates for this tier + region
    local candidates = xi.dynamicWorld.templates.getForTierAndRegion(tier, regionName)
    if #candidates == 0 then
        -- Fallback: try without region filter
        candidates = xi.dynamicWorld.templates.getForTierAndRegion(tier, nil)
    end

    if #candidates == 0 then
        return nil
    end

    -- Pick random template
    local chosen = candidates[math.random(#candidates)]
    local template = chosen.template
    local templateKey = chosen.key

    -- Get spawn position from existing mobs in the zone
    local pos = xi.dynamicWorld.getRandomSpawnPoint(zone)
    if not pos then
        return nil
    end

    -- Calculate level based on zone level range + template offset
    local levelRange = xi.dynamicWorld.getZoneLevelRange(zoneId)
    local minLevel = math.max(1, levelRange[1] + (template.levelOffset[1] or 0))
    local maxLevel = math.max(minLevel, levelRange[2] + (template.levelOffset[2] or 0))

    -- Cap at 99
    minLevel = math.min(minLevel, 99)
    maxLevel = math.min(maxLevel, 99)

    -- Pick a random visual variant for this spawn
    local chosenRef = pickGroupRef(template)

    -- Build the entity table
    local entityTable = {
        objtype     = xi.objType.MOB,
        name        = template.name:gsub(' ', '_'),
        packetName  = template.packetName,
        x           = pos.x,
        y           = pos.y,
        z           = pos.z,
        rotation    = pos.rot,
        groupId     = chosenRef.groupId,
        groupZoneId = chosenRef.groupZoneId,
        minLevel    = minLevel,
        maxLevel    = maxLevel,
        releaseIdOnDisappear = true,
        specialSpawnAnimation = true,
    }

    -- Determine if this entity is overleveled for the zone
    -- Overleveled entities are NOT aggressive unless attacked
    local isOverleveled = minLevel > levelRange[2]

    -- Apply behavior callbacks
    local behaviorSet = xi.dynamicWorld.behaviors.get(template.behavior)
    if behaviorSet then
        if behaviorSet.onMobSpawn then
            entityTable.onMobSpawn = function(mob)
                -- Tag the mob with dynamic world metadata
                mob:setLocalVar('DW_TIER', tier)
                mob:setLocalVar('DW_TEMPLATE', 0) -- Can't store strings, use numeric hash
                mob:setLocalVar('DW_SPAWN_TIME', os.time())

                -- If overleveled for the zone, disable aggro
                -- These mobs are peaceful unless attacked (like high-level NMs wandering through)
                if isOverleveled then
                    mob:setMobMod(xi.mobMod.NO_AGGRO, 1)
                    mob:setMobMod(xi.mobMod.NO_LINK, 1)
                end

                -- Call behavior-specific spawn logic
                behaviorSet.onMobSpawn(mob, template, tier)
            end
        end

        if behaviorSet.onMobRoam then
            entityTable.onMobRoam = function(mob)
                behaviorSet.onMobRoam(mob, template, tier)
            end
        end

        if behaviorSet.onMobEngaged then
            entityTable.onMobEngaged = function(mob, target)
                behaviorSet.onMobEngaged(mob, target, template, tier)

                -- Trigger item synergies on engage
                if getSetting('SYNERGIES_ENABLED') and target then
                    xi.dynamicWorld.synergies.onDynamicEngage(mob, target, template, tier)
                end
            end
        end

        if behaviorSet.onMobDeath then
            entityTable.onMobDeath = function(mob, player, optParams)
                behaviorSet.onMobDeath(mob, player, optParams, template, tier)
            end
        end

        if behaviorSet.onMobDespawn then
            entityTable.onMobDespawn = function(mob)
                behaviorSet.onMobDespawn(mob, template, tier)
            end
        end
    end

    -- Spawn it
    local entity = zone:insertDynamicEntity(entityTable)
    if not entity then
        return nil
    end

    -- Activate the mob
    entity:setSpawn(pos.x, pos.y, pos.z, pos.rot)
    entity:spawn()

    -- Track in our state
    local targid = entity:getTargID()
    zd.entities[targid] = {
        entity       = entity,
        templateKey  = templateKey,
        tier         = tier,
        spawnTime    = os.time(),
        zoneId       = zoneId,
        minLevel     = minLevel,
        maxLevel     = maxLevel,
    }
    zd.count = zd.count + 1
    state.globalCount = state.globalCount + 1

    -- Add death listener for tracking
    entity:addListener('DEATH', 'DW_DEATH_' .. targid, function(mob, killer)
        spawner.onEntityDeath(mob, killer, zd, state, template, tier, targid)
    end)

    -- Add despawn listener for cleanup
    entity:addListener('DESPAWN', 'DW_DESPAWN_' .. targid, function(mob)
        spawner.onEntityDespawn(mob, zd, state, targid)
    end)

    -- Add weapon skill listener (fires when mob TAKES a WS)
    entity:addListener('WEAPONSKILL_TAKE', 'DW_WS_TAKE_' .. targid, function(target, user, wsid)
        if getSetting('SYNERGIES_ENABLED') and user then
            xi.dynamicWorld.synergies.onDynamicWeaponSkill(user, target, template, tier, wsid)
        end
    end)

    -- Add spell take listener (fires when mob is targeted by a spell)
    entity:addListener('MAGIC_TAKE', 'DW_SPELL_TAKE_' .. targid, function(target, caster, spell)
        if getSetting('SYNERGIES_ENABLED') and caster then
            local spellId = spell and spell:getID() or 0
            xi.dynamicWorld.synergies.onDynamicSpellCast(caster, target, template, tier, spellId)
        end
    end)

    -- Add ability take listener (fires when mob is targeted by a job ability)
    entity:addListener('ABILITY_TAKE', 'DW_ABILITY_TAKE_' .. targid, function(target, user, ability, action)
        if getSetting('SYNERGIES_ENABLED') and user then
            local abilityId = ability and ability:getID() or 0
            xi.dynamicWorld.synergies.onDynamicAbility(user, target, template, tier, abilityId)
        end
    end)

    -- Announce elite+ spawns
    if tier >= xi.dynamicWorld.tier.ELITE then
        local tierName = xi.dynamicWorld.tierName[tier] or 'Unknown'
        local passiveNote = isOverleveled and ' (Passive - will not attack unless provoked)' or ''
        local players = zone:getPlayers()
        if players then
            for _, player in pairs(players) do
                player:printToPlayer(
                    string.format('[Dynamic World] A %s has appeared: %s!%s', tierName, template.packetName, passiveNote),
                    xi.msg.channel.SYSTEM_3
                )
            end
        end
    end

    return entity
end

-----------------------------------
-- REVENGE SPAWN SYSTEM
-----------------------------------
-- When a dynamic entity dies, there's a chance its stronger
-- relative shows up to avenge it. Each generation is tougher,
-- has better loot, and a sillier name.
--
-- Generation 0 = original mob
-- Generation 1 = "X Jr." (spawn chance: 25%)
-- Generation 2 = "X Sr." (spawn chance: 20%)
-- Generation 3 = "Big X" (spawn chance: 15%)
-- Generation 4 = "X the Elder" (spawn chance: 10%)
-- Generation 5 = "King X" / "Legendary X" (spawn chance: 5%, final form)
-----------------------------------

-- Name prefixes/suffixes by generation
spawner.revengeNames =
{
    [1] = {
        format   = 'suffix',
        suffixes = { 'Jr.', 'the Second', 'II', 'the Younger' },
    },
    [2] = {
        format   = 'suffix',
        suffixes = { 'Sr.', 'the Third', 'III', 'the Elder' },
    },
    [3] = {
        format   = 'prefix',
        prefixes = { 'Big', 'Mean', 'Angry', 'Mad' },
    },
    [4] = {
        format   = 'suffix',
        suffixes = { 'the Ancient', 'the Patriarch', 'the Matriarch', 'the Undying' },
    },
    [5] = {
        format   = 'prefix',
        prefixes = { 'King', 'Legendary', 'Immortal', 'Mythic' },
    },
}

-- Spawn chance per generation (out of 100)
spawner.revengeChance =
{
    [1] = 25,
    [2] = 20,
    [3] = 15,
    [4] = 10,
    [5] = 5,
}

-- Stat scaling per generation
spawner.revengeScaling =
{
    [1] = { levelBonus = 2,  hpMult = 1.3, expMult = 1.5  },
    [2] = { levelBonus = 4,  hpMult = 1.6, expMult = 2.0  },
    [3] = { levelBonus = 6,  hpMult = 2.0, expMult = 3.0  },
    [4] = { levelBonus = 8,  hpMult = 2.5, expMult = 4.0  },
    [5] = { levelBonus = 10, hpMult = 3.5, expMult = 6.0  },
}

-- Loot table upgrades per generation
spawner.revengeLootUpgrade =
{
    [1] = nil,                      -- Same loot table
    [2] = nil,                      -- Same loot table, higher rate
    [3] = 'elite_predator',         -- Bumps to elite loot
    [4] = 'elite_arcane',           -- Better elite loot
    [5] = 'apex_dragon',            -- Apex-tier loot for the final form
}

-- Generate revenge name from base name
spawner.getRevengeName = function(baseName, generation)
    local nameData = spawner.revengeNames[generation]
    if not nameData then
        return baseName
    end

    -- Strip any previous revenge suffixes/prefixes to keep names clean
    -- (In case of edge cases, but normally we build from the original base)

    if nameData.format == 'suffix' then
        local suffix = nameData.suffixes[math.random(#nameData.suffixes)]
        return baseName .. ' ' .. suffix
    elseif nameData.format == 'prefix' then
        local prefix = nameData.prefixes[math.random(#nameData.prefixes)]
        return prefix .. ' ' .. baseName
    end

    return baseName
end

-- Attempt to spawn a revenge entity after a dynamic mob dies
spawner.tryRevengeSpawn = function(mob, killer, zd, state, template, tier, generation)
    -- Check if revenge spawns are enabled
    local revengeEnabled = getSetting('REVENGE_SPAWNS_ENABLED')
    if revengeEnabled == false then
        return
    end

    -- Calculate next generation
    local nextGen = (generation or 0) + 1
    local maxGen = getSetting('REVENGE_MAX_GENERATION') or 5

    if nextGen > maxGen then
        return -- Already at final form, no more revenge spawns
    end

    -- Roll for revenge spawn
    local chance = spawner.revengeChance[nextGen] or 0
    local chanceMultiplier = getSetting('REVENGE_CHANCE_MULTIPLIER') or 1.0
    chance = math.floor(chance * chanceMultiplier)

    if math.random(100) > chance then
        return -- Failed the roll
    end

    -- Check zone capacity
    local maxPerZone = getSetting('MAX_ENTITIES_PER_ZONE') or 15
    if zd.count >= maxPerZone then
        return -- Zone is full
    end

    -- Get scaling for this generation
    local scaling = spawner.revengeScaling[nextGen] or { levelBonus = 2, hpMult = 1.3, expMult = 1.5 }

    -- Get the zone and spawn position (near where the parent died)
    local zone = mob:getZone()
    if not zone then
        return
    end

    local zoneId = zone:getID()
    local deathX = mob:getXPos()
    local deathY = mob:getYPos()
    local deathZ = mob:getZPos()

    -- Generate the revenge name
    local baseName = template.packetName
    -- If this was already a revenge mob, use the original base name
    local originalBase = mob:getLocalVar('DW_REVENGE_BASE_NAME_LEN')
    if originalBase and originalBase > 0 then
        -- We stored the original base name length; extract it
        baseName = template.packetName
    end

    local revengeName = spawner.getRevengeName(baseName, nextGen)

    -- Limit packet name to 24 chars (FFXI packet limitation)
    if #revengeName > 24 then
        revengeName = revengeName:sub(1, 24)
    end

    -- Calculate revenge level
    local levelRange = xi.dynamicWorld.getZoneLevelRange(zoneId)
    local parentLevel = mob:getMainLvl() or levelRange[2]
    local revengeMinLevel = math.min(99, parentLevel + scaling.levelBonus)
    local revengeMaxLevel = math.min(99, parentLevel + scaling.levelBonus + 2)

    -- Determine if overleveled for zone (for aggro purposes)
    local isOverleveled = revengeMinLevel > levelRange[2]

    -- Revenge mobs pick a random visual variant too
    local revengeRef = pickGroupRef(template)

    -- Build the entity
    local entityTable = {
        objtype     = xi.objType.MOB,
        name        = revengeName:gsub(' ', '_'),
        packetName  = revengeName,
        x           = deathX,
        y           = deathY,
        z           = deathZ,
        rotation    = math.random(0, 255),
        groupId     = revengeRef.groupId,
        groupZoneId = revengeRef.groupZoneId,
        minLevel    = revengeMinLevel,
        maxLevel    = revengeMaxLevel,
        releaseIdOnDisappear = true,
        specialSpawnAnimation = true,
    }

    -- Build a modified template for the revenge mob
    local revengeTemplate = {}
    for k, v in pairs(template) do
        revengeTemplate[k] = v
    end
    revengeTemplate.packetName = revengeName
    revengeTemplate.expMultiplier = (template.expMultiplier or 1.0) * scaling.expMult

    -- Override loot table if generation warrants it
    local lootUpgrade = spawner.revengeLootUpgrade[nextGen]
    if lootUpgrade then
        revengeTemplate.lootTable = lootUpgrade
    end

    -- Apply behavior callbacks
    local behaviorSet = xi.dynamicWorld.behaviors.get(template.behavior)
    if behaviorSet then
        if behaviorSet.onMobSpawn then
            entityTable.onMobSpawn = function(revMob)
                revMob:setLocalVar('DW_TIER', tier)
                revMob:setLocalVar('DW_SPAWN_TIME', os.time())
                revMob:setLocalVar('DW_REVENGE_GEN', nextGen)
                revMob:setLocalVar('DW_REVENGE_BASE_NAME_LEN', #baseName)

                -- Overleveled revenge mobs are also passive
                if isOverleveled then
                    revMob:setMobMod(xi.mobMod.NO_AGGRO, 1)
                    revMob:setMobMod(xi.mobMod.NO_LINK, 1)
                end

                -- Apply HP scaling
                local baseHP = revMob:getMaxHP()
                local bonusHP = math.floor(baseHP * (scaling.hpMult - 1.0))
                revMob:addHP(bonusHP)
                revMob:setHP(revMob:getMaxHP() + bonusHP)

                -- Call behavior-specific spawn logic
                behaviorSet.onMobSpawn(revMob, revengeTemplate, tier)
            end
        end

        if behaviorSet.onMobRoam then
            entityTable.onMobRoam = function(revMob)
                behaviorSet.onMobRoam(revMob, revengeTemplate, tier)
            end
        end

        if behaviorSet.onMobEngaged then
            entityTable.onMobEngaged = function(revMob, target)
                behaviorSet.onMobEngaged(revMob, target, revengeTemplate, tier)
                if getSetting('SYNERGIES_ENABLED') and target then
                    xi.dynamicWorld.synergies.onDynamicEngage(revMob, target, revengeTemplate, tier)
                end
            end
        end

        if behaviorSet.onMobDeath then
            entityTable.onMobDeath = function(revMob, player, optParams)
                behaviorSet.onMobDeath(revMob, player, optParams, revengeTemplate, tier)
            end
        end

        if behaviorSet.onMobDespawn then
            entityTable.onMobDespawn = function(revMob)
                behaviorSet.onMobDespawn(revMob, revengeTemplate, tier)
            end
        end
    end

    -- Delay the revenge spawn by 3-8 seconds for dramatic effect
    local spawnDelay = math.random(3000, 8000)

    mob:timer(spawnDelay, function(deadMob)
        -- Re-check zone capacity (might have changed during delay)
        if zd.count >= maxPerZone then
            return
        end

        local revengeEntity = zone:insertDynamicEntity(entityTable)
        if not revengeEntity then
            return
        end

        revengeEntity:setSpawn(deathX, deathY, deathZ, math.random(0, 255))
        revengeEntity:spawn()

        -- Track
        local revTargid = revengeEntity:getTargID()
        local templateKey = template.name:gsub(' ', '_') .. '_revenge_' .. nextGen
        zd.entities[revTargid] = {
            entity       = revengeEntity,
            templateKey  = templateKey,
            tier         = tier,
            spawnTime    = os.time(),
            zoneId       = zoneId,
            minLevel     = revengeMinLevel,
            maxLevel     = revengeMaxLevel,
            revengeGen   = nextGen,
        }
        zd.count = zd.count + 1
        state.globalCount = state.globalCount + 1

        -- Death listener (passes generation so chain continues)
        revengeEntity:addListener('DEATH', 'DW_DEATH_' .. revTargid, function(rMob, rKiller)
            spawner.onEntityDeath(rMob, rKiller, zd, state, revengeTemplate, tier, revTargid, nextGen)
        end)

        -- Despawn listener
        revengeEntity:addListener('DESPAWN', 'DW_DESPAWN_' .. revTargid, function(rMob)
            spawner.onEntityDespawn(rMob, zd, state, revTargid)
        end)

        -- WS/Spell/Ability synergy listeners
        revengeEntity:addListener('WEAPONSKILL_TAKE', 'DW_WS_TAKE_' .. revTargid, function(target, user, wsid)
            if getSetting('SYNERGIES_ENABLED') and user then
                xi.dynamicWorld.synergies.onDynamicWeaponSkill(user, target, revengeTemplate, tier, wsid)
            end
        end)

        revengeEntity:addListener('MAGIC_TAKE', 'DW_SPELL_TAKE_' .. revTargid, function(target, caster, spell)
            if getSetting('SYNERGIES_ENABLED') and caster then
                local spellId = spell and spell:getID() or 0
                xi.dynamicWorld.synergies.onDynamicSpellCast(caster, target, revengeTemplate, tier, spellId)
            end
        end)

        revengeEntity:addListener('ABILITY_TAKE', 'DW_ABILITY_TAKE_' .. revTargid, function(target, user, ability, action)
            if getSetting('SYNERGIES_ENABLED') and user then
                local abilityId = ability and ability:getID() or 0
                xi.dynamicWorld.synergies.onDynamicAbility(user, target, revengeTemplate, tier, abilityId)
            end
        end)

        -- Announce the revenge spawn
        local genNames = { 'relative', 'elder', 'champion', 'patriarch', 'legend' }
        local genName = genNames[nextGen] or 'kin'

        local players = zone:getPlayers()
        if players then
            for _, player in pairs(players) do
                player:printToPlayer(
                    string.format(
                        '[Dynamic World] You\'ve angered %s\'s %s! %s appears seeking revenge!',
                        baseName, genName, revengeName
                    ),
                    xi.msg.channel.SYSTEM_3
                )
            end
        end
    end)
end

-----------------------------------
-- Entity Death Handler
-----------------------------------
spawner.onEntityDeath = function(mob, killer, zd, state, template, tier, targid, revengeGeneration)
    if killer == nil then
        return
    end

    -- Award bonus EXP
    local tierMultipliers = {
        [xi.dynamicWorld.tier.WANDERER] = getSetting('EXP_MULTIPLIER_WANDERER') or 1.5,
        [xi.dynamicWorld.tier.NOMAD]    = getSetting('EXP_MULTIPLIER_NOMAD') or 2.0,
        [xi.dynamicWorld.tier.ELITE]    = getSetting('EXP_MULTIPLIER_ELITE') or 3.0,
        [xi.dynamicWorld.tier.APEX]     = getSetting('EXP_MULTIPLIER_APEX') or 5.0,
    }

    local expMult = (tierMultipliers[tier] or 1.0) * (template.expMultiplier or 1.0)

    -- Get chain bonus
    local chainBonus = xi.dynamicWorld.getChainBonus(killer)
    expMult = expMult * (1.0 + chainBonus)

    -- Calculate bonus EXP based on mob level (getBaseExp doesn't exist in Lua)
    -- Use level-scaled formula: base = mobLevel * 10, scaled by tier
    local mobLevel = mob:getMainLvl() or 1
    local baseExp = mobLevel * 12
    local bonusExp = math.floor(baseExp * (expMult - 1.0))

    if bonusExp > 0 then
        -- Award to party if applicable
        local party = killer:getParty()
        if party then
            for _, member in pairs(party) do
                if member:getZoneID() == mob:getZoneID() then
                    local distance = member:checkDistance(mob) or 9999
                    if distance < 50 then
                        member:addExp(bonusExp)
                        member:printToPlayer(
                            string.format('[Dynamic World] Bonus EXP: +%d', bonusExp),
                            xi.msg.channel.SYSTEM_3
                        )
                    end
                end
            end
        else
            killer:addExp(bonusExp)
            killer:printToPlayer(
                string.format('[Dynamic World] Bonus EXP: +%d', bonusExp),
                xi.msg.channel.SYSTEM_3
            )
        end
    end

    -- Record chain
    xi.dynamicWorld.recordKill(killer, mob, tier)

    -- Award loot
    if getSetting('LOOT_ENABLED') then
        xi.dynamicWorld.loot.award(mob, killer, template, tier)
    end

    -- Trigger synergies
    if getSetting('SYNERGIES_ENABLED') then
        xi.dynamicWorld.synergies.onDynamicKill(mob, killer, template, tier)
    end

    -- Try to spawn a revenge entity
    spawner.tryRevengeSpawn(mob, killer, zd, state, template, tier, revengeGeneration)
end

-----------------------------------
-- Entity Despawn Handler (cleanup tracking)
-----------------------------------
spawner.onEntityDespawn = function(mob, zd, state, targid)
    if zd.entities[targid] then
        zd.entities[targid] = nil
        zd.count = math.max(0, zd.count - 1)
        state.globalCount = math.max(0, state.globalCount - 1)
    end
end

-----------------------------------
-- Despawn a specific entity
-----------------------------------
spawner.despawnEntity = function(zone, zd, state, targid)
    local entData = zd.entities[targid]
    if not entData or not entData.entity then
        return
    end

    if entData.entity:isAlive() then
        entData.entity:setHP(0)
    end
    -- Cleanup is handled by the DESPAWN listener
end

-----------------------------------
-- Cleanup: remove dead/missing entities from tracking
-----------------------------------
spawner.cleanup = function(zone, zd, state)
    local toRemove = {}
    for targid, entData in pairs(zd.entities) do
        if not entData.entity or not entData.entity:isAlive() then
            table.insert(toRemove, targid)
        end
    end

    for _, targid in ipairs(toRemove) do
        if zd.entities[targid] then
            zd.entities[targid] = nil
            zd.count = math.max(0, zd.count - 1)
            state.globalCount = math.max(0, state.globalCount - 1)
        end
    end
end
