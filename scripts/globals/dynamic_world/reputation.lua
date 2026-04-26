xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.reputation = xi.dynamicWorld.reputation or {}

local rep = xi.dynamicWorld.reputation

local trackedFactions =
{
    goblin = true,
    orc    = true,
    quadav = true,
    yagudo = true,
}

local factionVars =
{
    goblin = 'DW_HATE_GOBLIN',
    orc    = 'DW_HATE_ORC',
    quadav = 'DW_HATE_QUADAV',
    yagudo = 'DW_HATE_YAGUDO',
}

local familyAliases =
{
    beastmen_goblin = 'goblin',
    beastmen_orc    = 'orc',
}

local function normalizeFaction(faction)
    if not faction then
        return nil
    end

    faction = string.lower(tostring(faction))
    return familyAliases[faction] or faction
end

local function resolvePlayer(killer)
    if not killer then
        return nil
    end

    if killer.isPC and killer:isPC() then
        return killer
    end

    if killer.getMaster then
        local master = killer:getMaster()
        if master and master.isPC and master:isPC() then
            return master
        end
    end

    return nil
end

rep.resolvePlayer = resolvePlayer

rep.isTrackedFaction = function(faction)
    faction = normalizeFaction(faction)
    return faction and trackedFactions[faction] or false
end

rep.getFactionVar = function(faction)
    faction = normalizeFaction(faction)
    return faction and factionVars[faction] or nil
end

rep.getFactionHate = function(player, faction)
    local varName = rep.getFactionVar(faction)
    if not player or not varName then
        return 0
    end

    return player:getCharVar(varName)
end

rep.addFactionHate = function(player, faction, amount)
    local varName = rep.getFactionVar(faction)
    if not player or not varName then
        return 0
    end

    local current = player:getCharVar(varName)
    local newValue = math.max(0, math.min(1000, current + (amount or 1)))
    player:setCharVar(varName, newValue)

    return newValue
end

rep.getAllFactionHate = function(player)
    local data = {}
    for faction, _ in pairs(trackedFactions) do
        data[faction] = rep.getFactionHate(player, faction)
    end
    return data
end

rep.inferFactionFromTemplate = function(template)
    if not template then
        return nil
    end

    local faction = normalizeFaction(template.faction or template.family)
    if rep.isTrackedFaction(faction) then
        return faction
    end

    local haystacks =
    {
        template.name,
        template.packetName,
        template.description,
        template.lootTable,
        template.behavior,
    }

    for _, value in ipairs(haystacks) do
        local text = value and string.lower(tostring(value)) or ''
        if text:find('goblin', 1, true) then
            return 'goblin'
        elseif text:find('orc', 1, true) then
            return 'orc'
        elseif text:find('quadav', 1, true) then
            return 'quadav'
        elseif text:find('yagudo', 1, true) then
            return 'yagudo'
        end
    end

    return nil
end

rep.onFactionKill = function(killer, faction, amount)
    local player = resolvePlayer(killer)
    faction = normalizeFaction(faction)
    if not player or not rep.isTrackedFaction(faction) then
        return nil, nil
    end

    local newValue = rep.addFactionHate(player, faction, amount or 1)
    return player, newValue
end

rep.onDynamicKill = function(killer, template, tier)
    local faction = rep.inferFactionFromTemplate(template)
    if not faction then
        return nil, nil, nil
    end

    local amountByTier =
    {
        [xi.dynamicWorld.tier.WANDERER] = 1,
        [xi.dynamicWorld.tier.NOMAD] = 2,
        [xi.dynamicWorld.tier.ELITE] = 3,
        [xi.dynamicWorld.tier.APEX] = 5,
        [xi.dynamicWorld.tier.POWER_KING] = 7,
    }

    local player, newValue = rep.onFactionKill(killer, faction, amountByTier[tier] or 1)
    return player, faction, newValue
end

rep.onNamedRareKill = function(killer, config, tier)
    local faction = normalizeFaction(config and (config.family or config.faction))
    if not rep.isTrackedFaction(faction) then
        return nil, nil, nil
    end

    local player, newValue = rep.onFactionKill(killer, faction, math.max(4, tier or 3))
    return player, faction, newValue
end
