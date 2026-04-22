-----------------------------------
-- !iteminfo [slot]
-- Shows stats for the item equipped in the given slot, or lists all
-- equipped custom items (ID >= 30000) if no slot is given.
--
-- Usage:
--   !iteminfo           -- list all custom gear you're wearing
--   !iteminfo head      -- show stats for your head slot item
--   !iteminfo 30531     -- show stats for a specific item ID
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 0,   -- available to all players
    parameters = 's'
}

-- Slot name -> xi.slot index
local SLOT_NAMES =
{
    main   = 0,  sub    = 1,  range  = 2,  ranged = 2,
    ammo   = 3,  head   = 4,  body   = 5,  hands  = 6,
    legs   = 7,  feet   = 8,  neck   = 9,  waist  = 10,
    ear1   = 11, ear2   = 12, ring1  = 13, ring2  = 14,
    back   = 15,
}

local SLOT_LABELS =
{
    [0]  = 'Main',   [1]  = 'Sub',    [2]  = 'Ranged',
    [3]  = 'Ammo',   [4]  = 'Head',   [5]  = 'Body',
    [6]  = 'Hands',  [7]  = 'Legs',   [8]  = 'Feet',
    [9]  = 'Neck',   [10] = 'Waist',  [11] = 'Ear1',
    [12] = 'Ear2',   [13] = 'Ring1',  [14] = 'Ring2',
    [15] = 'Back',
}

-- mod ID -> display label
local MOD_LABELS =
{
    [1]   = 'DEF',
    [2]   = 'HP',
    [5]   = 'MP',
    [8]   = 'STR',
    [9]   = 'DEX',
    [10]  = 'VIT',
    [11]  = 'AGI',
    [12]  = 'INT',
    [13]  = 'MND',
    [14]  = 'CHR',
    [23]  = 'Attack',
    [25]  = 'Accuracy',
    [27]  = 'Enmity',
    [28]  = 'Magic Atk.',
    [29]  = 'Magic Def.',
    [30]  = 'Magic Acc.',
    [68]  = 'Evasion',
    [161] = 'Physical damage taken',
    [288] = 'Double Attack',
    [384] = 'Haste',
}

-- Ordered list so stats always print in a consistent order
local MOD_ORDER = { 1, 2, 5, 8, 9, 10, 11, 12, 13, 14, 23, 25, 68, 28, 30, 29, 27, 161, 288, 384 }

local function printItemStats(player, item, slotLabel)
    if item == nil then
        player:printToPlayer(string.format('[%s] Empty', slotLabel))
        return
    end

    local itemID   = item:getID()
    local itemName = item:getName()
    local reqLvl   = item:getReqLvl()

    -- Build stat string
    local stats = {}
    for _, modID in ipairs(MOD_ORDER) do
        local val = item:getMod(modID)
        if val ~= nil and val ~= 0 then
            local label = MOD_LABELS[modID] or ('Mod#' .. modID)
            if modID == 161 then
                table.insert(stats, string.format('%s %+.0f%%', label, val / 100))
            elseif modID == 288 then
                table.insert(stats, string.format('%s +%d%%', label, val))
            elseif modID == 384 then
                -- Haste is stored as tenths of a percent (e.g. 40 = 4%)
                table.insert(stats, string.format('%s +%d%%', label, val / 10))
            elseif val > 0 then
                table.insert(stats, string.format('%s +%d', label, val))
            else
                table.insert(stats, string.format('%s %d', label, val))
            end
        end
    end

    if #stats == 0 then
        player:printToPlayer(string.format('[%s] %s (ID:%d Lv.%d) — No stat bonuses', slotLabel, itemName, itemID, reqLvl))
    else
        player:printToPlayer(string.format('[%s] %s (ID:%d Lv.%d)', slotLabel, itemName, itemID, reqLvl))
        player:printToPlayer(string.format('  Stats: %s', table.concat(stats, '  ')))
    end
end

commandObj.onTrigger = function(player, arg)

    -- Case 1: specific item ID passed (e.g. !iteminfo 30531)
    local numArg = tonumber(arg)
    if numArg ~= nil then
        -- Search all slots for this item ID
        for slotIdx = 0, 15 do
            local item = player:getEquippedItem(slotIdx)
            if item ~= nil and item:getID() == numArg then
                printItemStats(player, item, SLOT_LABELS[slotIdx] or tostring(slotIdx))
                return
            end
        end
        player:printToPlayer(string.format('Item ID %d is not currently equipped.', numArg))
        return
    end

    -- Case 2: slot name passed (e.g. !iteminfo head)
    if arg ~= nil and arg ~= '' then
        local slotIdx = SLOT_NAMES[string.lower(arg)]
        if slotIdx == nil then
            player:printToPlayer('Unknown slot. Use: main sub range ammo head body hands legs feet neck waist ear1 ear2 ring1 ring2 back')
            return
        end
        local item = player:getEquippedItem(slotIdx)
        if item == nil then
            player:printToPlayer(string.format('[%s] Nothing equipped.', SLOT_LABELS[slotIdx]))
        else
            printItemStats(player, item, SLOT_LABELS[slotIdx])
        end
        return
    end

    -- Case 3: no arg — list all custom items currently equipped (ID >= 30000)
    local found = false
    player:printToPlayer('=== Custom Item Stats ===')
    for slotIdx = 0, 15 do
        local item = player:getEquippedItem(slotIdx)
        if item ~= nil and item:getID() >= 30000 then
            printItemStats(player, item, SLOT_LABELS[slotIdx] or tostring(slotIdx))
            found = true
        end
    end

    if not found then
        player:printToPlayer('You have no custom items equipped.')
        player:printToPlayer('Tip: !iteminfo <slot> works for any item, not just custom ones.')
    end
end

return commandObj
