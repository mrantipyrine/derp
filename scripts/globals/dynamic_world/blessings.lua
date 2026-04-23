-----------------------------------
-- Dynamic World: Regional Blessings
-----------------------------------
-- Blessings are earned by killing dedicated dynamic "buff mobs".
-- They last until the player zones and occupy one of three slots:
-- offense, defense, utility.
-----------------------------------

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.blessings = xi.dynamicWorld.blessings or {}

local blessings = xi.dynamicWorld.blessings

local SLOT_VARS =
{
    offense = 'DW_BLESSING_OFFENSE',
    defense = 'DW_BLESSING_DEFENSE',
    utility = 'DW_BLESSING_UTILITY',
}

local blessingDb =
{
    [1] =
    {
        key      = 'mandragora_cheer',
        name     = 'Mandragora Cheer',
        category = 'defense',
        mods     =
        {
            { mod = xi.mod.DEF,     power = 20 },
            { mod = xi.mod.REGEN,   power = 4 },
            { mod = xi.mod.MND,     power = 5 },
        },
        message  = 'Mandragora Cheer settles over you.',
    },
    [2] =
    {
        key      = 'carapace_coat',
        name     = 'Carapace Coat',
        category = 'defense',
        mods     =
        {
            { mod = xi.mod.MDEF,     power = 16 },
            { mod = xi.mod.PHALANX,  power = 3 },
            { mod = xi.mod.VIT,      power = 6 },
        },
        message  = 'A hard shell of warding surrounds you.',
    },
    [3] =
    {
        key      = 'hare_hustle',
        name     = 'Hare Hustle',
        category = 'offense',
        mods     =
        {
            { mod = xi.mod.REGAIN,   power = 15 },
            { mod = xi.mod.DEX,      power = 6 },
            { mod = xi.mod.AGI,      power = 6 },
            { mod = xi.mod.EVA,      power = 8 },
        },
        message  = 'Hare Hustle kicks your blood into motion.',
    },
    [4] =
    {
        key      = 'bee_frenzy',
        name     = 'Bee Frenzy',
        category = 'offense',
        mods     =
        {
            { mod = xi.mod.HASTE_MAGIC, power = 125 },
            { mod = xi.mod.ACC,         power = 10 },
            { mod = xi.mod.DEX,         power = 5 },
            { mod = xi.mod.AGI,         power = 4 },
        },
        message  = 'Bee Frenzy sharpens your strikes.',
    },
    [5] =
    {
        key      = 'bird_breeze',
        name     = 'Bird Breeze',
        category = 'utility',
        mods     =
        {
            { mod = xi.mod.HASTE_MAGIC, power = 150 },
            { mod = xi.mod.EVA,         power = 12 },
            { mod = xi.mod.AGI,         power = 6 },
            { mod = xi.mod.CHR,         power = 4 },
        },
        message  = 'Bird Breeze lightens your steps.',
    },
    [6] =
    {
        key      = 'worm_whisper',
        name     = 'Worm Whisper',
        category = 'utility',
        mods     =
        {
            { mod = xi.mod.REFRESH,   power = 2 },
            { mod = xi.mod.MACC,      power = 10 },
            { mod = xi.mod.INT,       power = 6 },
            { mod = xi.mod.MND,       power = 4 },
        },
        message  = 'Worm Whisper settles into your thoughts.',
    },
    [7] =
    {
        key      = 'coeurl_instinct',
        name     = 'Coeurl Instinct',
        category = 'offense',
        mods     =
        {
            { mod = xi.mod.ATT,         power = 18 },
            { mod = xi.mod.ACC,         power = 12 },
            { mod = xi.mod.CRITHITRATE, power = 5 },
            { mod = xi.mod.AGI,         power = 4 },
        },
        message  = 'Coeurl Instinct makes every opening look fatal.',
    },
    [8] =
    {
        key      = 'treant_vigor',
        name     = 'Treant Vigor',
        category = 'defense',
        mods     =
        {
            { mod = xi.mod.HP,      power = 60 },
            { mod = xi.mod.REGEN,   power = 4 },
            { mod = xi.mod.VIT,     power = 5 },
            { mod = xi.mod.MND,     power = 3 },
        },
        message  = 'Treant Vigor roots you in stubborn life.',
    },
    [9] =
    {
        key      = 'funguar_visions',
        name     = 'Funguar Visions',
        category = 'utility',
        mods     =
        {
            { mod = xi.mod.REFRESH, power = 1 },
            { mod = xi.mod.MATT,    power = 12 },
            { mod = xi.mod.MACC,    power = 12 },
            { mod = xi.mod.INT,     power = 5 },
        },
        message  = 'Funguar Visions flood your mind with ugly brilliance.',
    },
}

local managedMods = {}
for _, blessing in pairs(blessingDb) do
    for _, modData in ipairs(blessing.mods) do
        managedMods[modData.mod] = true
    end
end

local function iterManagedMods()
    local mods = {}
    for modId, _ in pairs(managedMods) do
        mods[#mods + 1] = modId
    end
    return mods
end

local function resolveRecipients(killer, sourceMob, range)
    local recipients = {}
    local owner = killer

    if owner and owner.getMaster then
        local master = owner:getMaster()
        if master and master.isPC and master:isPC() then
            owner = master
        end
    end

    if not owner or not owner.isPC or not owner:isPC() then
        return recipients
    end

    local party = owner:getParty()
    if party then
        for _, member in pairs(party) do
            if member:isPC() and member:getZoneID() == sourceMob:getZoneID() then
                local distance = member:checkDistance(sourceMob) or 9999
                if distance <= range then
                    recipients[#recipients + 1] = member
                end
            end
        end
    else
        recipients[#recipients + 1] = owner
    end

    return recipients
end

local function addBlessingMod(player, modData)
    player:addMod(modData.mod, modData.power)
end

local function applyActiveBlessings(player)
    for _, slotVar in pairs(SLOT_VARS) do
        local blessingId = player:getLocalVar(slotVar)
        local blessing = blessingDb[blessingId]
        if blessing then
            for _, modData in ipairs(blessing.mods) do
                addBlessingMod(player, modData)
            end
        end
    end
end

blessings.get = function(id)
    return blessingDb[id]
end

blessings.clearEffects = function(player)
    for _, modId in ipairs(iterManagedMods()) do
        for _, slotVar in pairs(SLOT_VARS) do
            local blessing = blessingDb[player:getLocalVar(slotVar)]
            if blessing then
                for _, modData in ipairs(blessing.mods) do
                    if modData.mod == modId then
                        player:delMod(modId, modData.power)
                    end
                end
            end
        end
    end
end

blessings.apply = function(player)
    blessings.clearEffects(player)
    applyActiveBlessings(player)
end

blessings.clearAll = function(player)
    blessings.clearEffects(player)
    for _, slotVar in pairs(SLOT_VARS) do
        player:setLocalVar(slotVar, 0)
    end
end

blessings.onZoneIn = function(player)
    blessings.clearAll(player)
end

blessings.grant = function(player, blessingId)
    local blessing = blessingDb[blessingId]
    if not blessing then
        return
    end

    local slotVar = SLOT_VARS[blessing.category]
    if not slotVar then
        return
    end

    blessings.clearEffects(player)
    player:setLocalVar(slotVar, blessingId)
    applyActiveBlessings(player)

    player:printToPlayer(
        string.format('[Dynamic World] %s %s (%s, until you zone).', blessing.name, blessing.message, blessing.category),
        xi.msg.channel.SYSTEM_3
    )
end

blessings.onBlessingMobDeath = function(mob, killer, template)
    local blessingId = template and template.blessingId or 0
    local blessing = blessingDb[blessingId]
    if not blessing then
        return
    end

    local range = (xi.settings.dynamicworld and xi.settings.dynamicworld.BLESSING_GRANT_RANGE) or 50
    local recipients = resolveRecipients(killer, mob, range)

    for _, player in ipairs(recipients) do
        blessings.grant(player, blessingId)
    end

    local zone = mob:getZone()
    if zone then
        local grid = xi.dynamicWorld.posToGrid(mob:getXPos(), mob:getZPos(), zone:getID())
        xi.dynamicWorld.announceNearby(
            zone,
            mob,
            60,
            string.format('[Dynamic World] %s releases %s near %s.', template.packetName, blessing.name, grid)
        )
    end
end
