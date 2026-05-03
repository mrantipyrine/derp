-----------------------------------
-- Dynamic World: Item/Ability Synergies
-----------------------------------
-- Makes "boring" gear fun by adding proc effects, stat synergies,
-- and special interactions that activate during dynamic world combat.
--
-- NEW: Also augments weapon skills, spells, and job abilities
-- based on equipped items. A Leaping Boots wearer gets extra kicks
-- on their weapon skills; a Mist Silk Cape wearer's Cure spells
-- leave a regen trail; etc.
--
-- Follows existing patterns in the codebase:
--   - Equipment checks: getEquipID(xi.slot.X)
--   - Listener-based procs: addListener('ATTACK', ...)
--   - Status effects: addStatusEffect(...)
--   - Mod system: addMod(xi.mod.X, value)
--
-- Synergy types:
--   on_kill     - Fires when player kills a dynamic world mob
--   on_engage   - Fires when player engages a dynamic world mob
--   passive     - Fires on zone-in to zones with dynamic entities
--   on_ws       - Augments weapon skills during dynamic world combat
--   on_spell    - Augments spells during dynamic world combat
--   on_ability  - Augments job abilities during dynamic world combat
--
-- Synergies are checked on:
--   1. Dynamic world mob kill (onDynamicKill)
--   2. Dynamic world mob engage (onDynamicEngage)
--   3. Player zone-in to zone with dynamic entities (onZoneIn)
--   4. Weapon skill use on dynamic entities (onDynamicWeaponSkill)
--   5. Spell cast on/near dynamic entities (onDynamicSpellCast)
--   6. Job ability use near dynamic entities (onDynamicAbility)
-----------------------------------

xi = xi or {}
xi.dynamicWorld = xi.dynamicWorld or {}
xi.dynamicWorld.tier = xi.dynamicWorld.tier or {
    WANDERER   = 1,
    NOMAD      = 2,
    ELITE      = 3,
    APEX       = 4,
    POWER_KING = 5,
}
xi.dynamicWorld.tierName = xi.dynamicWorld.tierName or {
    [1] = 'Wanderer',
    [2] = 'Nomad',
    [3] = 'Elite',
    [4] = 'Apex',
    [5] = 'Power King',
}
xi.dynamicWorld.synergies = xi.dynamicWorld.synergies or {}

local synergies = xi.dynamicWorld.synergies

-----------------------------------
-- Synergy Definitions
-- Each synergy:
--   itemId    - Equipment item ID to check
--   slot      - Equipment slot to check (xi.slot.X)
--   name      - Display name
--   type      - 'on_kill', 'on_engage', 'on_hit', 'passive',
--               'on_ws', 'on_spell', 'on_ability'
--   condition - Optional function(player, mob, template, tier) -> bool
--   effect    - function(player, mob, template, tier) that applies the synergy
--   description - What it does (for GM display)
-----------------------------------

synergies.db = {}
local db = synergies.db

-----------------------------------
-- WEAPON SYNERGIES
-----------------------------------

-- Bronze Sword: "Beginner's Fury" - Bronze weapons get a massive crit buff
db.beginners_fury =
{
    itemId      = 16535,    -- Bronze Sword
    slot        = xi.slot.MAIN,
    name        = 'Beginner\'s Fury',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.BOOST, 30, 0, 300)
        player:printToPlayer(
            '[Synergy: Beginner\'s Fury] Your humble blade burns with determination! (Crit +30%)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Bronze Sword gains massive crit rate boost vs dynamic world mobs.',
}

-- Deathbringer (16637): "Soul Harvest" - Drains HP on every kill, stacking
db.soul_harvest =
{
    itemId      = 16637,    -- Deathbringer (Lv5 Rare, DEF-6 ATT+8)
    slot        = xi.slot.MAIN,
    name        = 'Soul Harvest',
    type        = 'on_kill',
    effect      = function(player, mob, template, tier)
        local drain = 50 + (tier * 75)
        player:addHP(drain)
        player:addStatusEffect(xi.effect.DRAIN_DAZE, 5, 0, 60)
        player:printToPlayer(
            string.format('[Synergy: Soul Harvest] Deathbringer drinks deep! (HP +%d, Drain aura 60s)', drain),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Deathbringer drains HP on dynamic kills, gains drain aura.',
}

-- Orcish Axe (16656): "Orcish Fury" - Berserk effect on engage, scaling with tier
db.orcish_fury =
{
    itemId      = 16656,    -- Orcish Axe (Lv5 R/Ex, STR+2 INT-1 MND-1 CHR-1)
    slot        = xi.slot.MAIN,
    name        = 'Orcish Fury',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        local attBonus = 20 + (tier * 15)
        player:addStatusEffect(xi.effect.BERSERK, attBonus, 0, 180)
        player:printToPlayer(
            string.format('[Synergy: Orcish Fury] The orc-forged blade hungers for battle! (ATT +%d, 3 min)', attBonus),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Orcish Axe grants Berserk vs dynamic mobs.',
}

-- Caduceus (17058): "Hermes\' Gift" - Massive Haste + Refresh on engage
db.hermes_gift =
{
    itemId      = 17058,    -- Caduceus (Lv1 R/Ex, mod_134:1 - fishing skill)
    slot        = xi.slot.MAIN,
    name        = 'Hermes\' Gift',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.HASTE, 15, 0, 180)
        player:addStatusEffect(xi.effect.REFRESH, 3, 3, 180)
        player:printToPlayer(
            '[Synergy: Hermes\' Gift] The caduceus channels divine swiftness! (Haste + Refresh 3 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Caduceus grants Haste and Refresh vs dynamic mobs.',
}

-- Treat Staff (17566): "Sugar Rush" - Party-wide TP bonus on kill
db.sugar_rush =
{
    itemId      = 17566,    -- Treat Staff (Lv1 R/Ex, HP+5 MP+5)
    slot        = xi.slot.MAIN,
    name        = 'Sugar Rush',
    type        = 'on_kill',
    effect      = function(player, mob, template, tier)
        local tpBonus = 100 + (tier * 50)
        local party = player:getParty()
        if party then
            for _, member in pairs(party) do
                if member:getZoneID() == player:getZoneID() then
                    local dist = member:checkDistance(player) or 9999
                    if dist < 30 then
                        member:addTP(tpBonus)
                    end
                end
            end
        else
            player:addTP(tpBonus)
        end
        player:printToPlayer(
            string.format('[Synergy: Sugar Rush] Sweet energy surges through your party! (TP +%d)', tpBonus),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Treat Staff grants party TP on dynamic kills.',
}

-- Fencing Degen (16829): "Riposte Master" - Counter rate + counter damage on engage
db.riposte_master =
{
    itemId      = 16829,    -- Fencing Degen (Lv41 R/Ex, MP+10 INT+1 MND+1)
    slot        = xi.slot.MAIN,
    name        = 'Riposte Master',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.COUNTER, 25)
        player:addMod(xi.mod.ACC, 20)
        player:printToPlayer(
            '[Synergy: Riposte Master] Your fencer\'s instinct sharpens! (Counter +25%, ACC +20)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Fencing Degen grants Counter and Accuracy vs dynamic mobs.',
}

-- Raven Scythe (16798): "Reaper's Tithe" - Bonus dark damage + Aspir on kill
db.reapers_tithe =
{
    itemId      = 16798,    -- Raven Scythe (Lv43 R/Ex, STR+2 INT+2)
    slot        = xi.slot.MAIN,
    name        = 'Reaper\'s Tithe',
    type        = 'on_kill',
    effect      = function(player, mob, template, tier)
        local mpDrain = 30 + (tier * 20)
        player:addMP(mpDrain)
        player:addStatusEffect(xi.effect.ENDARK, 15, 0, 120)
        player:printToPlayer(
            string.format('[Synergy: Reaper\'s Tithe] Dark energy flows into you! (MP +%d, Endark 2 min)', mpDrain),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Raven Scythe drains MP and grants Endark on dynamic kills.',
}

-- Arondight (16945): "Knight's Oath" - Fire/Water shield that reflects damage
db.knights_oath =
{
    itemId      = 16945,    -- Arondight (Lv62 R/Ex, Fire DEF+7 Water DEF+7)
    slot        = xi.slot.MAIN,
    name        = 'Knight\'s Oath',
    type        = 'on_engage',
    condition   = function(player, mob, template, tier)
        return tier >= xi.dynamicWorld.tier.ELITE
    end,
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.BLAZE_SPIKES, 30, 0, 300)
        player:addStatusEffect(xi.effect.AQUAVEIL, 1, 0, 300)
        player:printToPlayer(
            '[Synergy: Knight\'s Oath] Arondight blazes with elemental fury! (Blaze Spikes + Aquaveil 5 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Arondight grants Blaze Spikes and Aquaveil vs elite+ dynamic mobs.',
}

-- Mythril Knife: "Treasure Sense" - Bonus loot from treasure goblins
db.treasure_sense =
{
    itemId      = 16512,    -- Mythril Knife
    slot        = xi.slot.MAIN,
    name        = 'Treasure Sense',
    type        = 'on_kill',
    condition   = function(player, mob, template, tier)
        return template.behavior == 'treasure_goblin'
    end,
    effect      = function(player, mob, template, tier)
        local bonusGil = math.random(2000, 10000)
        player:addGil(bonusGil)
        player:printToPlayer(
            string.format('[Synergy: Treasure Sense] Your knife pries open a hidden pouch! (+%d gil)', bonusGil),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Mythril Knife doubles treasure goblin rewards.',
}

-----------------------------------
-- HEAD SYNERGIES
-----------------------------------

-- Ahriman Cap (10446): "Evil Eye" - Gaze attack paralyzes dynamic mobs on engage
db.evil_eye =
{
    itemId      = 10446,    -- Ahriman Cap (Lv1 R/Ex, Dark DEF+5)
    slot        = xi.slot.HEAD,
    name        = 'Evil Eye',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        mob:addStatusEffect(xi.effect.PARALYSIS, 15, 0, 30)
        player:printToPlayer(
            '[Synergy: Evil Eye] Your ahriman gaze freezes the enemy! (Paralyze 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Ahriman Cap paralyzes dynamic mobs on engage.',
}

-- Shaded Spectacles (13945): "Analyst" - See mob weaknesses, gain MACC
db.analyst =
{
    itemId      = 13945,    -- Shaded Spectacles (Lv1 R/Ex, DEF+1 Light DEF+1)
    slot        = xi.slot.HEAD,
    name        = 'Analyst',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.MACC, 30)
        player:addMod(xi.mod.MATT, 15)
        player:printToPlayer(
            string.format('[Synergy: Analyst] You analyze %s\'s weaknesses! (MACC +30, MATT +15)',
                template.packetName),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Shaded Spectacles grant MACC and MATT vs dynamic mobs.',
}

-- Pumpkin Head (13916): "Harvest Moon" - AoE fear on engage (Terrorize nearby mobs)
db.harvest_moon =
{
    itemId      = 13916,    -- Pumpkin Head (Lv1 R/Ex, MATT-1)
    slot        = xi.slot.HEAD,
    name        = 'Harvest Moon',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        mob:addStatusEffect(xi.effect.TERROR, 1, 0, 10)
        player:addMod(xi.mod.MATT, 25)
        player:printToPlayer(
            '[Synergy: Harvest Moon] The pumpkin\'s grin terrorizes your foe! (Terror 10s, MATT +25)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Pumpkin Head terrorizes dynamic mobs briefly and boosts MATT.',
}

-- Precision Bandana (11493): "Marksman's Focus" - Huge ACC + RACC buff
db.marksmans_focus =
{
    itemId      = 11493,    -- Precision Bandana (Lv25 Rare, DEF+8 ACC+3)
    slot        = xi.slot.HEAD,
    name        = 'Marksman\'s Focus',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.ACC, 30)
        player:addMod(xi.mod.RACC, 30)
        player:addMod(xi.mod.CRITHITRATE, 10)
        player:printToPlayer(
            '[Synergy: Marksman\'s Focus] Perfect concentration! (ACC +30, RACC +30, Crit +10%)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Precision Bandana massively boosts accuracy and crit vs dynamic mobs.',
}

-- Voyager Sallet (15184): "Explorer's Intuition" - Detect tier and get stat buffs
db.explorers_intuition =
{
    itemId      = 15184,    -- Voyager Sallet (Lv41 R/Ex, STR+3 DEX+4)
    slot        = xi.slot.HEAD,
    name        = 'Explorer\'s Intuition',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        local bonus = 5 * tier
        player:addMod(xi.mod.STR, bonus)
        player:addMod(xi.mod.DEX, bonus)
        player:addMod(xi.mod.AGI, bonus)
        player:printToPlayer(
            string.format('[Synergy: Explorer\'s Intuition] You read the enemy perfectly! (STR/DEX/AGI +%d)', bonus),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Voyager Sallet grants scaling stat buffs based on dynamic mob tier.',
}

-- Leather Bandana: "Scout's Instinct" - Detect elite+ spawns at range
db.scouts_instinct =
{
    itemId      = 12498,    -- Leather Bandana
    slot        = xi.slot.HEAD,
    name        = 'Scout\'s Instinct',
    type        = 'passive',
    effect      = function(player, mob, template, tier)
        if tier >= xi.dynamicWorld.tier.ELITE then
            player:printToPlayer(
                string.format('[Synergy: Scout\'s Instinct] You sense something powerful nearby: %s!',
                    template.packetName),
                xi.msg.channel.SYSTEM_3
            )
        end
    end,
    description = 'Leather Bandana alerts you when elite+ entities are in the zone.',
}

-- Fungus Hat (12485): "Spore Cloud" - Poison + Bio on engage
db.spore_cloud =
{
    itemId      = 12485,    -- Fungus Hat
    slot        = xi.slot.HEAD,
    name        = 'Spore Cloud',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        mob:addStatusEffect(xi.effect.POISON, 10, 3, 120)
        mob:addStatusEffect(xi.effect.BIO, 8, 3, 120)
        player:printToPlayer(
            '[Synergy: Spore Cloud] Toxic spores erupt from your hat! (Poison + Bio on target)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Fungus Hat inflicts Poison + Bio on dynamic mobs when engaged.',
}

-----------------------------------
-- BODY SYNERGIES
-----------------------------------

-- Chocobo Shirt (10293): "Chocobo Dash" - Movement speed + Flee effect on engage
db.chocobo_dash =
{
    itemId      = 10293,    -- Chocobo Shirt (Lv1 R/Ex, DEF+2)
    slot        = xi.slot.BODY,
    name        = 'Chocobo Dash',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.FLEE, 25, 0, 60)
        player:addMod(xi.mod.EVA, 30)
        player:printToPlayer(
            '[Synergy: Chocobo Dash] Kweh! Chocobo speed surges through you! (Flee + EVA +30, 60s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Chocobo Shirt grants Flee and Evasion vs dynamic mobs.',
}

-- Scale Mail: "Ironscale" - Stoneskin vs elites
db.ironscale =
{
    itemId      = 12601,    -- Scale Mail
    slot        = xi.slot.BODY,
    name        = 'Ironscale',
    type        = 'on_engage',
    condition   = function(player, mob, template, tier)
        return tier >= xi.dynamicWorld.tier.ELITE
    end,
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.STONESKIN, 200, 0, 120)
        player:printToPlayer(
            '[Synergy: Ironscale] Your armor hardens against the powerful foe! (Stoneskin 200)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Scale Mail grants Stoneskin when engaging elite+ dynamic mobs.',
}

-- Moogle Suit (10250): "Moogle Magic" - Lucky drops + Reraise
db.moogle_magic =
{
    itemId      = 10250,    -- Moogle Suit (Lv1 R/Ex, DEF+1)
    slot        = xi.slot.BODY,
    name        = 'Moogle Magic',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.RERAISE, 1, 0, 600)
        player:printToPlayer(
            '[Synergy: Moogle Magic] Kupo! The moogle spirit protects you! (Reraise I, 10 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Moogle Suit grants Reraise I vs dynamic mobs.',
}

-----------------------------------
-- HANDS SYNERGIES
-----------------------------------

-- Dream Mittens (10382): "Dreamweaver" - Sleep resist + MP regen
db.dreamweaver =
{
    itemId      = 10382,    -- Dream Mittens (Lv1 R/Ex, DEF+1)
    slot        = xi.slot.HANDS,
    name        = 'Dreamweaver',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.REFRESH, 5, 3, 300)
        player:addMod(xi.mod.MEVA, 20)
        player:printToPlayer(
            '[Synergy: Dreamweaver] Dreams fuel your magic! (Refresh +5, MEVA +20, 5 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Dream Mittens grant Refresh and Magic Evasion vs dynamic mobs.',
}

-- Carpenter's Gloves (14830): "Nature's Grip" - Earth damage proc on hit
db.natures_grip =
{
    itemId      = 14830,    -- Carpenter's Gloves (Lv1 R/Ex, DEF+2 Earth DEF+1)
    slot        = xi.slot.HANDS,
    name        = 'Nature\'s Grip',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.ENSTONE, 20, 0, 300)
        player:addMod(xi.mod.ATT, 15)
        player:printToPlayer(
            '[Synergy: Nature\'s Grip] Earth energy infuses your strikes! (Enstone + ATT +15, 5 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Carpenter\'s Gloves grant Enstone and Attack vs dynamic mobs.',
}

-- Smithy's Mitts (14831): "Forge Strike" - Fire damage + Double Attack
db.forge_strike =
{
    itemId      = 14831,    -- Smithy's Mitts (Lv1 R/Ex, DEF+3 Fire DEF+1)
    slot        = xi.slot.HANDS,
    name        = 'Forge Strike',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.ENFIRE, 25, 0, 300)
        player:addMod(xi.mod.DOUBLE_ATTACK, 10)
        player:printToPlayer(
            '[Synergy: Forge Strike] Forge-hardened fists blaze! (Enfire + DA +10%, 5 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Smithy\'s Mitts grant Enfire and Double Attack vs dynamic mobs.',
}

-- Iron Ram Mufflers (15005): "Iron Wall" - Massive DEF + Phalanx
db.iron_wall =
{
    itemId      = 15005,    -- Iron Ram Mufflers (Lv45 Rare, DEF+9 ACC+3)
    slot        = xi.slot.HANDS,
    name        = 'Iron Wall',
    type        = 'on_engage',
    condition   = function(player, mob, template, tier)
        return tier >= xi.dynamicWorld.tier.ELITE
    end,
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.DEF, 50)
        player:addStatusEffect(xi.effect.PHALANX, 20, 0, 180)
        player:printToPlayer(
            '[Synergy: Iron Wall] The Iron Rams stand firm! (DEF +50, Phalanx 3 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Iron Ram Mufflers grant DEF and Phalanx vs elite+ dynamic mobs.',
}

-----------------------------------
-- LEGS SYNERGIES
-----------------------------------

-- Bone Subligar: "Skeletor's Blessing" - DEF+50 and Regen vs undead
db.skeletors_blessing =
{
    itemId      = 14258,    -- Bone Subligar
    slot        = xi.slot.LEGS,
    name        = 'Skeletor\'s Blessing',
    type        = 'on_engage',
    condition   = function(player, mob, template, tier)
        return template.behavior == 'nomad_ghost'
    end,
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.DEF, 50)
        player:addStatusEffect(xi.effect.REGEN, 10, 3, 300)
        player:printToPlayer(
            '[Synergy: Skeletor\'s Blessing] The undead recognize their own! (DEF+50, Regen)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Bone Subligar grants massive DEF and Regen vs undead dynamic mobs.',
}

-- Herder's Subligar (16368): "Beast Tamer" - Charm-like pacify + ATT steal
db.beast_tamer =
{
    itemId      = 16368,    -- Herder's Subligar (Lv25 R/Ex, DEF+8)
    slot        = xi.slot.LEGS,
    name        = 'Beast Tamer',
    type        = 'on_engage',
    condition   = function(player, mob, template, tier)
        return tier <= xi.dynamicWorld.tier.NOMAD
    end,
    effect      = function(player, mob, template, tier)
        mob:addStatusEffect(xi.effect.SLOW, 25, 0, 60)
        player:addMod(xi.mod.ATT, 30)
        player:printToPlayer(
            '[Synergy: Beast Tamer] You assert dominance! (Target Slow, you gain ATT +30)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Herder\'s Subligar slows wanderers/nomads and steals their attack.',
}

-----------------------------------
-- FEET SYNERGIES
-----------------------------------

-- Leaping Boots (13014): "Acrobatic Strike" - Triple Attack + Kick attacks
db.acrobatic_strike =
{
    itemId      = 13014,    -- Leaping Boots (Lv7 Rare, DEF+3 DEX+3 AGI+3)
    slot        = xi.slot.FEET,
    name        = 'Acrobatic Strike',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.TRIPLE_ATTACK, 8)
        player:addMod(xi.mod.KICK_ATTACK_RATE, 15)
        player:addMod(xi.mod.EVA, 20)
        player:printToPlayer(
            '[Synergy: Acrobatic Strike] Your feet become weapons! (TA +8%, Kick +15%, EVA +20)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Leaping Boots grant Triple Attack, Kick attacks, and Evasion vs dynamic mobs.',
}

-- Bounding Boots (15351): "Spring Assault" - Same as Leaping Boots but stronger (R/Ex version)
db.spring_assault =
{
    itemId      = 15351,    -- Bounding Boots (Lv7 R/Ex, DEF+3 DEX+3 AGI+3)
    slot        = xi.slot.FEET,
    name        = 'Spring Assault',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.TRIPLE_ATTACK, 12)
        player:addMod(xi.mod.KICK_ATTACK_RATE, 20)
        player:addMod(xi.mod.EVA, 25)
        player:addMod(xi.mod.AGI, 10)
        player:printToPlayer(
            '[Synergy: Spring Assault] Boundless energy in every leap! (TA +12%, Kick +20%, EVA +25, AGI +10)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Bounding Boots grant enhanced Triple Attack and agility vs dynamic mobs.',
}

-- Iron Ram Sollerets (15749): "Unstoppable March" - Movement + Stoneskin
db.unstoppable_march =
{
    itemId      = 15749,    -- Iron Ram Sollerets (Lv45 Rare, DEF+8 AGI+2)
    slot        = xi.slot.FEET,
    name        = 'Unstoppable March',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.STONESKIN, 150, 0, 180)
        player:addMod(xi.mod.SUBTLE_BLOW, 20)
        player:printToPlayer(
            '[Synergy: Unstoppable March] The Iron Rams march forward! (Stoneskin 150, Subtle Blow +20)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Iron Ram Sollerets grant Stoneskin and Subtle Blow vs dynamic mobs.',
}

-- Rambler's Gaiters (11401): "Wanderlust" - Bonus EXP + movement speed aura
db.wanderlust =
{
    itemId      = 11401,    -- Rambler's Gaiters (Lv25 R/Ex, DEF+5 INT+2 EVA+5)
    slot        = xi.slot.FEET,
    name        = 'Wanderlust',
    type        = 'on_kill',
    effect      = function(player, mob, template, tier)
        local bonusExp = 25 * tier
        player:addExp(bonusExp)
        player:printToPlayer(
            string.format('[Synergy: Wanderlust] The road rewards the wanderer! (Bonus EXP +%d)', bonusExp),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Rambler\'s Gaiters grant bonus EXP from dynamic kills.',
}

-----------------------------------
-- NECK SYNERGIES
-----------------------------------

-- Rabbit Charm (13112): "Lucky Rabbit" - Bonus EXP from wanderers
db.lucky_rabbit =
{
    itemId      = 13112,    -- Rabbit Charm (Lv7 Rare, DEF+1 DEX+1 AGI+1)
    slot        = xi.slot.NECK,
    name        = 'Lucky Rabbit',
    type        = 'on_kill',
    condition   = function(player, mob, template, tier)
        return tier == xi.dynamicWorld.tier.WANDERER
    end,
    effect      = function(player, mob, template, tier)
        local bonusExp = math.random(50, 200)
        player:addExp(bonusExp)
        player:printToPlayer(
            string.format('[Synergy: Lucky Rabbit] The charm glows! (+%d bonus EXP)', bonusExp),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Rabbit Charm grants bonus EXP from wanderer kills.',
}

-- Silver Name Tag (13116): "Guardian Angel" - Auto-Protect + Shell
db.guardian_angel =
{
    itemId      = 13116,    -- Silver Name Tag (Lv7 Rare, Water DEF+5)
    slot        = xi.slot.NECK,
    name        = 'Guardian Angel',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.PROTECT, 50, 0, 300)
        player:addStatusEffect(xi.effect.SHELL, 1, 0, 300)
        player:printToPlayer(
            '[Synergy: Guardian Angel] Your faithful companion watches over you! (Protect + Shell 5 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Silver Name Tag grants Protect and Shell vs dynamic mobs.',
}

-- Sand Charm (13095): "Desert Veil" - Massive elemental defense vs dynamic mobs
db.desert_veil =
{
    itemId      = 13095,    -- Sand Charm (Lv27 R/Ex, Ice DEF+5 Earth DEF+5 Dark DEF+5)
    slot        = xi.slot.NECK,
    name        = 'Desert Veil',
    type        = 'on_engage',
    condition   = function(player, mob, template, tier)
        return tier >= xi.dynamicWorld.tier.NOMAD
    end,
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.BARFIRE, 50, 0, 300)
        player:addStatusEffect(xi.effect.BARBLIZZARD, 50, 0, 300)
        player:addStatusEffect(xi.effect.BARTHUNDER, 50, 0, 300)
        player:printToPlayer(
            '[Synergy: Desert Veil] Sand swirls to shield you from the elements! (Barfire/ice/thunder 5 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Sand Charm grants elemental bars vs nomad+ dynamic mobs.',
}

-- Spirit Torque (13129): "Spirit Link" - Huge Refresh + Fast Cast
db.spirit_link =
{
    itemId      = 13129,    -- Spirit Torque (Lv38 Rare, MP+10 EVA+5)
    slot        = xi.slot.NECK,
    name        = 'Spirit Link',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.REFRESH, 5, 3, 300)
        player:addMod(xi.mod.FASTCAST, 15)
        player:printToPlayer(
            '[Synergy: Spirit Link] Spiritual energy pours in! (Refresh +5, Fast Cast +15%, 5 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Spirit Torque grants Refresh and Fast Cast vs dynamic mobs.',
}

-- Auditory Torque (13178): "Sonic Boom" - AoE slow on engage
db.sonic_boom =
{
    itemId      = 13178,    -- Auditory Torque (Lv47 R/Ex, DEF+5)
    slot        = xi.slot.NECK,
    name        = 'Sonic Boom',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        mob:addStatusEffect(xi.effect.SLOW, 20, 0, 60)
        mob:addStatusEffect(xi.effect.SILENCE, 1, 0, 30)
        player:printToPlayer(
            '[Synergy: Sonic Boom] A piercing sound stuns your foe! (Slow + Silence)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Auditory Torque inflicts Slow and Silence on dynamic mobs.',
}

-- Ranger's Necklace (13117): "Dead Shot" - Massive RATT/RACC + Store TP for ranged
db.dead_shot =
{
    itemId      = 13117,    -- Ranger's Necklace (Lv14 Rare, RATT+5 RACC+5)
    slot        = xi.slot.NECK,
    name        = 'Dead Shot',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.RATT, 25)
        player:addMod(xi.mod.RACC, 25)
        player:addMod(xi.mod.STORETP, 10)
        player:printToPlayer(
            '[Synergy: Dead Shot] Your aim is true! (RATT +25, RACC +25, Store TP +10)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Ranger\'s Necklace massively boosts ranged stats vs dynamic mobs.',
}

-----------------------------------
-- WAIST SYNERGIES
-----------------------------------

-- Red Sash (15455): "Crimson Sorcery" - MATT + Magic Burst bonus
db.crimson_sorcery =
{
    itemId      = 15455,    -- Red Sash (Lv1 R/Ex, MATT+1)
    slot        = xi.slot.WAIST,
    name        = 'Crimson Sorcery',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.MATT, 30)
        player:addMod(xi.mod.MAGIC_BURST_BONUS_CAPPED, 10)
        player:printToPlayer(
            '[Synergy: Crimson Sorcery] Crimson energy amplifies your magic! (MATT +30, MB +10%)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Red Sash massively boosts magic attack and burst damage vs dynamic mobs.',
}

-- Key Ring Belt (15880): "Lockpicker" - Bonus loot chance + Treasure Hunter effect
db.lockpicker =
{
    itemId      = 15880,    -- Key Ring Belt (Lv20 R/Ex, DEF+2 DEX+1)
    slot        = xi.slot.WAIST,
    name        = 'Lockpicker',
    type        = 'on_kill',
    effect      = function(player, mob, template, tier)
        -- Extra gil + bonus item roll
        local bonusGil = math.random(500, 2000) * tier
        player:addGil(bonusGil)
        player:printToPlayer(
            string.format('[Synergy: Lockpicker] You find a hidden cache! (+%d gil)', bonusGil),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Key Ring Belt finds bonus gil from dynamic kills.',
}

-- Storm Belt (15882): "Tempest Aura" - STR/VIT scaling + Enblizzard
db.tempest_aura =
{
    itemId      = 15882,    -- Storm Belt (Lv50 R/Ex, DEF+4 STR+4 VIT+4)
    slot        = xi.slot.WAIST,
    name        = 'Tempest Aura',
    type        = 'on_engage',
    condition   = function(player, mob, template, tier)
        return tier >= xi.dynamicWorld.tier.ELITE
    end,
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.ENBLIZZARD, 25, 0, 300)
        player:addMod(xi.mod.STR, 15)
        player:addMod(xi.mod.VIT, 15)
        player:printToPlayer(
            '[Synergy: Tempest Aura] The storm rages within! (Enblizzard + STR/VIT +15)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Storm Belt grants Enblizzard and stat boosts vs elite+ dynamic mobs.',
}

-- Tilt Belt (15286): "Berserker's Edge" - ATT + ACC but lose EVA
db.berserkers_edge =
{
    itemId      = 15286,    -- Tilt Belt (Lv40 Rare, DEF+3 ACC+5 EVA-5)
    slot        = xi.slot.WAIST,
    name        = 'Berserker\'s Edge',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.ATT, 40)
        player:addMod(xi.mod.ACC, 25)
        player:addMod(xi.mod.DOUBLE_ATTACK, 8)
        player:printToPlayer(
            '[Synergy: Berserker\'s Edge] All-out attack! (ATT +40, ACC +25, DA +8%)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Tilt Belt grants massive attack bonuses vs dynamic mobs.',
}

-----------------------------------
-- BACK SYNERGIES
-----------------------------------

-- Mist Silk Cape (13607): "Mist Veil" - Regen + Light defense aura
db.mist_veil =
{
    itemId      = 13607,    -- Mist Silk Cape (Lv10 Rare, DEF+3 MND+1 Light DEF+3)
    slot        = xi.slot.BACK,
    name        = 'Mist Veil',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.REGEN, 10, 3, 300)
        player:addMod(xi.mod.CURE_POTENCY, 15)
        player:printToPlayer(
            '[Synergy: Mist Veil] Healing mist surrounds you! (Regen +10, Cure Potency +15%)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Mist Silk Cape grants Regen and enhanced healing vs dynamic mobs.',
}

-- Night Cape (13576): "Shadow Cloak" - Evasion + Subtle Blow
db.shadow_cloak =
{
    itemId      = 13576,    -- Night Cape (Lv21 Rare, DEF+3 Dark DEF+3 EVA+3)
    slot        = xi.slot.BACK,
    name        = 'Shadow Cloak',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.EVA, 30)
        player:addMod(xi.mod.SUBTLE_BLOW, 25)
        player:addStatusEffect(xi.effect.BLINK, 3, 0, 120)
        player:printToPlayer(
            '[Synergy: Shadow Cloak] Shadows wrap around you! (EVA +30, Subtle Blow +25, Blink)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Night Cape grants Evasion, Subtle Blow, and Blink vs dynamic mobs.',
}

-- Variable Mantle (13680): "Adaptive Shield" - Gains resist to mob's element
db.adaptive_shield =
{
    itemId      = 13680,    -- Variable Mantle (Lv20 R/Ex, DEF+3)
    slot        = xi.slot.BACK,
    name        = 'Adaptive Shield',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.MDEF, 20)
        player:addMod(xi.mod.MEVA, 25)
        player:addStatusEffect(xi.effect.SHELL, 2, 0, 300)
        player:printToPlayer(
            '[Synergy: Adaptive Shield] Your cloak shifts to ward off magic! (MDEF +20, MEVA +25, Shell)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Variable Mantle grants magic defense vs dynamic mobs.',
}

-- Drover's Mantle (16243): "Beast Whisperer" - Pet/BST bonus + charm proc
db.beast_whisperer =
{
    itemId      = 16243,    -- Drover's Mantle (Lv1 R/Ex, DEF+1)
    slot        = xi.slot.BACK,
    name        = 'Beast Whisperer',
    type        = 'on_engage',
    condition   = function(player, mob, template, tier)
        return tier <= xi.dynamicWorld.tier.NOMAD
    end,
    effect      = function(player, mob, template, tier)
        mob:addStatusEffect(xi.effect.SLOW, 30, 0, 45)
        mob:addStatusEffect(xi.effect.DEFENSE_DOWN, 20, 0, 60)
        player:printToPlayer(
            '[Synergy: Beast Whisperer] You calm the beast! (Target: Slow + DEF Down)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Drover\'s Mantle debuffs wanderer/nomad dynamic mobs.',
}

-----------------------------------
-- EAR SYNERGIES
-----------------------------------

-- Optical Earring (14803): "Tactical Scan" - See mob HP% + gain ACC
db.tactical_scan =
{
    itemId      = 14803,    -- Optical Earring (Lv10 R/Ex, DEF+1 ATT-2 ACC+1)
    slot        = xi.slot.EAR1,
    name        = 'Tactical Scan',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.ACC, 20)
        player:addMod(xi.mod.RACC, 20)
        player:printToPlayer(
            string.format('[Synergy: Tactical Scan] Target analyzed: %s (Tier %d). ACC/RACC +20!',
                template.packetName, tier),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Optical Earring reveals mob info and boosts accuracy vs dynamic mobs.',
}

-- Moldavite Earring (14724): "Meteor Shard" - Huge MACC + Magic Damage
db.meteor_shard =
{
    itemId      = 14724,    -- Moldavite Earring (Lv47 R/Ex, MACC+5)
    slot        = xi.slot.EAR1,
    name        = 'Meteor Shard',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.MACC, 25)
        player:addMod(xi.mod.MAGIC_DAMAGE, 20)
        player:printToPlayer(
            '[Synergy: Meteor Shard] Celestial energy amplifies your spells! (MACC +25, Magic DMG +20)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Moldavite Earring boosts MACC and Magic Damage vs dynamic mobs.',
}

-- Giant's Earring (11043): "Titan's Might" - HP + STR scaling with tier
db.titans_might =
{
    itemId      = 11043,    -- Giant's Earring (Lv30 Rare, HP+10 STR+1)
    slot        = xi.slot.EAR1,
    name        = 'Titan\'s Might',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        local hpBonus = 100 * tier
        local strBonus = 5 * tier
        player:addMod(xi.mod.HP, hpBonus)
        player:addMod(xi.mod.STR, strBonus)
        player:printToPlayer(
            string.format('[Synergy: Titan\'s Might] Giant strength surges! (HP +%d, STR +%d)', hpBonus, strBonus),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Giant\'s Earring grants massive HP and STR scaling with tier.',
}

-----------------------------------
-- RING SYNERGIES
-----------------------------------

-- San d'Orian Ring (13495): "Royal Guard" - Protect + VIT buff
db.royal_guard =
{
    itemId      = 13495,    -- San d'Orian Ring (Lv1 R/Ex, DEF+2 STR+1 MND+1)
    slot        = xi.slot.RING1,
    name        = 'Royal Guard',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.VIT, 15)
        player:addMod(xi.mod.DEF, 25)
        player:addStatusEffect(xi.effect.PROTECT, 40, 0, 300)
        player:printToPlayer(
            '[Synergy: Royal Guard] For San d\'Oria! (VIT +15, DEF +25, Protect 5 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'San d\'Orian Ring grants defensive buffs vs dynamic mobs.',
}

-- Bastokan Ring (13497): "Republic Might" - HP + Counter
db.republic_might =
{
    itemId      = 13497,    -- Bastokan Ring (Lv1 R/Ex, HP+3 DEX+1 VIT+1)
    slot        = xi.slot.RING1,
    name        = 'Republic Might',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.HP, 100)
        player:addMod(xi.mod.COUNTER, 15)
        player:addMod(xi.mod.DEX, 10)
        player:printToPlayer(
            '[Synergy: Republic Might] Bastok stands strong! (HP +100, Counter +15%, DEX +10)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Bastokan Ring grants HP and Counter vs dynamic mobs.',
}

-- Windurstian Ring (13496): "Federation Wisdom" - MP + INT + Refresh
db.federation_wisdom =
{
    itemId      = 13496,    -- Windurstian Ring (Lv1 R/Ex, MP+3 AGI+1 INT+1)
    slot        = xi.slot.RING1,
    name        = 'Federation Wisdom',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.MP, 100)
        player:addMod(xi.mod.INT, 10)
        player:addStatusEffect(xi.effect.REFRESH, 3, 3, 300)
        player:printToPlayer(
            '[Synergy: Federation Wisdom] Windurst\'s ancient wisdom flows! (MP +100, INT +10, Refresh)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Windurstian Ring grants MP and magic buffs vs dynamic mobs.',
}

-- Assailant's Ring (14676): "Savage Blow" - ATT + Store TP
db.savage_blow =
{
    itemId      = 14676,    -- Assailant's Ring (Lv42 Rare, ATT+5)
    slot        = xi.slot.RING1,
    name        = 'Savage Blow',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.ATT, 30)
        player:addMod(xi.mod.STORETP, 10)
        player:addMod(xi.mod.DOUBLE_ATTACK, 5)
        player:printToPlayer(
            '[Synergy: Savage Blow] Unbridled aggression! (ATT +30, Store TP +10, DA +5%)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Assailant\'s Ring grants attack power and TP generation vs dynamic mobs.',
}

-- Mermaid's Ring (14626): "Tidal Surge" - Water damage + MATT
db.tidal_surge =
{
    itemId      = 14626,    -- Mermaid's Ring (Lv43 Rare, Water DEF+3 MATT+2)
    slot        = xi.slot.RING1,
    name        = 'Tidal Surge',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.ENWATER, 20, 0, 300)
        player:addMod(xi.mod.MATT, 20)
        player:addMod(xi.mod.WATER_MAB, 15)
        player:printToPlayer(
            '[Synergy: Tidal Surge] Ocean power infuses your attacks! (Enwater + MATT +20, Water MAB +15)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Mermaid\'s Ring grants water damage and magic attack vs dynamic mobs.',
}

-- Saintly Ring: "Divine Retribution" - AoE party heal on apex kill
db.divine_retribution =
{
    itemId      = 13546,    -- Saintly Ring
    slot        = xi.slot.RING1,
    name        = 'Divine Retribution',
    type        = 'on_kill',
    condition   = function(player, mob, template, tier)
        return tier >= xi.dynamicWorld.tier.APEX
    end,
    effect      = function(player, mob, template, tier)
        local party = player:getParty()
        if party then
            for _, member in pairs(party) do
                if member:getZoneID() == player:getZoneID() then
                    local dist = member:checkDistance(player) or 9999
                    if dist < 30 then
                        member:addHP(500)
                        member:addMP(200)
                    end
                end
            end
        else
            player:addHP(500)
            player:addMP(200)
        end
        player:printToPlayer(
            '[Synergy: Divine Retribution] Holy light erupts, restoring your party! (HP+500, MP+200)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Saintly Ring heals party on apex mob kill.',
}

-- Fire Ring (13560): "Inferno Ring" - Fire damage burst on kill
db.inferno_ring =
{
    itemId      = 13560,    -- Fire Ring (Lv65 R/Ex, DEF+2)
    slot        = xi.slot.RING1,
    name        = 'Inferno Ring',
    type        = 'on_kill',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.ENFIRE, 30, 0, 120)
        player:addMod(xi.mod.FIRE_MAB, 20)
        player:printToPlayer(
            '[Synergy: Inferno Ring] Flames erupt from the fallen! (Enfire + Fire MAB +20, 2 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Fire Ring grants fire damage aura on dynamic kills.',
}

-- Ice Ring (13561): "Glacial Ring" - Ice defense + Blizzard affinity
db.glacial_ring =
{
    itemId      = 13561,    -- Ice Ring (Lv65 R/Ex, DEF+2)
    slot        = xi.slot.RING1,
    name        = 'Glacial Ring',
    type        = 'on_kill',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.ENBLIZZARD, 30, 0, 120)
        player:addMod(xi.mod.ICE_MAB, 20)
        player:printToPlayer(
            '[Synergy: Glacial Ring] Frost spreads from the fallen! (Enblizzard + Ice MAB +20, 2 min)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Ice Ring grants ice damage aura on dynamic kills.',
}

-----------------------------------
-- SHIELD SYNERGIES
-----------------------------------

-- Aspis: "Phalanx Formation" - Damage taken -20%
db.phalanx_formation =
{
    itemId      = 12291,    -- Aspis
    slot        = xi.slot.SUB,
    name        = 'Phalanx Formation',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.DMG, -20)
        player:printToPlayer(
            '[Synergy: Phalanx Formation] You brace behind your shield! (DMG taken -20%)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Aspis reduces damage taken by 20% vs dynamic world mobs.',
}

-- Mandraguard (10807): "Mandragora's Cheer" - Regen + Party HP boost
db.mandragora_cheer =
{
    itemId      = 10807,    -- Mandraguard (Lv1 R/Ex, DEF+1 CHR+1)
    slot        = xi.slot.SUB,
    name        = 'Mandragora\'s Cheer',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.REGEN, 8, 3, 300)
        player:addMod(xi.mod.CHR, 20)
        player:printToPlayer(
            '[Synergy: Mandragora\'s Cheer] The mandragora spirit cheers you on! (Regen +8, CHR +20)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Mandraguard grants Regen and CHR vs dynamic mobs.',
}

-- Chocobo Shield (10811): "Chocobo Guard" - Auto-Blink + Evasion
db.chocobo_guard =
{
    itemId      = 10811,    -- Chocobo Shield (Lv1 R/Ex, DEF+1)
    slot        = xi.slot.SUB,
    name        = 'Chocobo Guard',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.BLINK, 3, 0, 120)
        player:addMod(xi.mod.EVA, 15)
        player:printToPlayer(
            '[Synergy: Chocobo Guard] Kweh! The chocobo dodges for you! (Blink + EVA +15)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Chocobo Shield grants Blink and Evasion vs dynamic mobs.',
}

-----------------------------------
-- RANGED SYNERGIES
-----------------------------------

-- Firefly (19221): "Firefly Beacon" - Passive: detect all dynamic entities in zone
db.firefly_beacon =
{
    itemId      = 19221,    -- Firefly (Lv5 R/Ex, AGI+1)
    slot        = xi.slot.RANGED,
    name        = 'Firefly Beacon',
    type        = 'passive',
    effect      = function(player, mob, template, tier)
        player:printToPlayer(
            string.format('[Synergy: Firefly Beacon] The firefly reveals: %s (%s tier) in this zone!',
                template.packetName, xi.dynamicWorld.tierName[tier] or 'Unknown'),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Firefly reveals all dynamic entities in the zone.',
}

-- Oliphant (17843): "War Horn" - Party ATT/ACC buff on engage
db.war_horn =
{
    itemId      = 17843,    -- Oliphant (Lv40 Rare, ATT+3 ACC+3)
    slot        = xi.slot.RANGED,
    name        = 'War Horn',
    type        = 'on_engage',
    effect      = function(player, mob, template, tier)
        local party = player:getParty()
        if party then
            for _, member in pairs(party) do
                if member:getZoneID() == player:getZoneID() then
                    local dist = member:checkDistance(player) or 9999
                    if dist < 30 then
                        member:addMod(xi.mod.ATT, 20)
                        member:addMod(xi.mod.ACC, 15)
                    end
                end
            end
        else
            player:addMod(xi.mod.ATT, 20)
            player:addMod(xi.mod.ACC, 15)
        end
        player:printToPlayer(
            '[Synergy: War Horn] The horn rallies your allies! (Party ATT +20, ACC +15)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Oliphant buffs party attack and accuracy vs dynamic mobs.',
}

-----------------------------------
-- COMBINATION SYNERGIES
-----------------------------------

-- Full Bronze Set: "Copper Courage"
db.copper_courage =
{
    name        = 'Copper Courage',
    type        = 'on_engage',
    isCombo     = true,
    comboCheck  = function(player)
        local bronzeItems = {
            16535, -- Bronze Sword
            12480, -- Bronze Cap
            12608, -- Bronze Harness
            12736, -- Bronze Mittens
            12864, -- Bronze Leggings
            12352, -- Bronze Subligar
        }
        local count = 0
        for _, itemId in ipairs(bronzeItems) do
            if player:hasEquipped(itemId) then
                count = count + 1
            end
        end
        return count >= 3
    end,
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.BOOST, 15, 0, 300)
        player:addMod(xi.mod.ATT, 40)
        player:addMod(xi.mod.DEF, 40)
        player:addMod(xi.mod.ACC, 20)
        player:printToPlayer(
            '[Synergy: Copper Courage] Your full bronze set resonates with power! (ATT+40, DEF+40, ACC+20)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Wearing 3+ Bronze pieces grants massive stat boosts vs dynamic mobs.',
}

-- Elemental Harmony: Staff + matching ring
db.elemental_harmony =
{
    name        = 'Elemental Harmony',
    type        = 'on_engage',
    isCombo     = true,
    comboCheck  = function(player)
        local staffIds = { 17041, 17042, 17043, 17044, 17045, 17046, 17047, 17048 }
        for _, id in ipairs(staffIds) do
            if player:hasEquipped(id) then
                return true
            end
        end
        return false
    end,
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.MATT, 30)
        player:addMod(xi.mod.MACC, 20)
        player:addStatusEffect(xi.effect.REFRESH, 3, 3, 300)
        player:printToPlayer(
            '[Synergy: Elemental Harmony] Your staff channels the elements! (MATT+30, MACC+20, Refresh)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Elemental Staff + Ring grants enhanced magic stats vs dynamic mobs.',
}

-- Nation Set: Wearing nation ring + nation gear combo
db.patriot =
{
    name        = 'Patriot',
    type        = 'on_engage',
    isCombo     = true,
    comboCheck  = function(player)
        -- Has a nation ring AND a nation-themed body or cape
        return player:hasEquipped(13495) or player:hasEquipped(13496) or player:hasEquipped(13497)
    end,
    effect      = function(player, mob, template, tier)
        player:addStatusEffect(xi.effect.REGEN, 5, 3, 300)
        player:addStatusEffect(xi.effect.REFRESH, 2, 3, 300)
        player:addMod(xi.mod.HP, 50)
        player:addMod(xi.mod.MP, 30)
        player:printToPlayer(
            '[Synergy: Patriot] National pride empowers you! (Regen, Refresh, HP +50, MP +30)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Wearing a nation ring grants Regen + Refresh vs dynamic mobs.',
}

-- Crafter's Insight: Any crafting gloves + crafting ring
db.crafters_insight =
{
    name        = 'Crafter\'s Insight',
    type        = 'on_engage',
    isCombo     = true,
    comboCheck  = function(player)
        local craftGloves = { 14830, 14831, 14832, 15043, 15044, 15045, 15046, 15047, 15048, 15049 }
        local craftRings  = { 15819, 15820, 15821, 15822, 15823, 15824, 15825, 15826 }
        local hasGloves = false
        local hasRing = false
        for _, id in ipairs(craftGloves) do
            if player:hasEquipped(id) then hasGloves = true break end
        end
        for _, id in ipairs(craftRings) do
            if player:hasEquipped(id) then hasRing = true break end
        end
        return hasGloves and hasRing
    end,
    effect      = function(player, mob, template, tier)
        -- Crafters deal more damage and find better loot
        player:addMod(xi.mod.ATT, 25)
        player:addMod(xi.mod.MATT, 25)
        player:addMod(xi.mod.ACC, 20)
        player:addMod(xi.mod.MACC, 20)
        player:printToPlayer(
            '[Synergy: Crafter\'s Insight] Your artisan expertise reveals combat secrets! (ATT/MATT +25, ACC/MACC +20)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Crafting Gloves + Crafting Ring grants offensive bonuses vs dynamic mobs.',
}

-----------------------------------
-- CHAIN SYNERGIES
-----------------------------------

db.chain_hunter =
{
    name        = 'Chain Hunter',
    type        = 'on_kill',
    isCombo     = true,
    comboCheck  = function(player)
        local chain = xi.dynamicWorld.state.playerChains[player:getID()]
        return chain and chain.count >= 5
    end,
    effect      = function(player, mob, template, tier)
        local chain = xi.dynamicWorld.state.playerChains[player:getID()]
        if chain and chain.count >= 10 then
            player:addStatusEffect(xi.effect.REGEN, 15, 3, 600)
            player:addStatusEffect(xi.effect.REFRESH, 5, 3, 600)
            player:printToPlayer(
                '[Synergy: Chain Hunter] Your hunt frenzy peaks! (Regen + Refresh for 10 min)',
                xi.msg.channel.SYSTEM_3
            )
        elseif chain and chain.count >= 5 then
            player:addStatusEffect(xi.effect.REGEN, 8, 3, 300)
            player:printToPlayer(
                '[Synergy: Chain Hunter] The thrill of the hunt invigorates you! (Regen for 5 min)',
                xi.msg.channel.SYSTEM_3
            )
        end
    end,
    description = 'Reaching 5+ chain grants Regen. 10+ chain adds Refresh.',
}

-----------------------------------
-- WEAPON SKILL AUGMENTS
-- These fire when the player uses a weapon skill on a dynamic entity.
-- They modify WS damage, add effects, or grant follow-up bonuses.
-----------------------------------

db.ws_leaping_boots =
{
    itemId      = 13014,    -- Leaping Boots
    slot        = xi.slot.FEET,
    name        = 'Airborne Assault',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        -- All weapon skills gain bonus TP return
        player:addTP(50)
        -- 25% chance to stun the target
        if math.random(100) <= 25 then
            mob:addStatusEffect(xi.effect.STUN, 1, 0, 4)
            player:printToPlayer(
                '[Synergy: Airborne Assault] Your leaping strike stuns the foe! (+50 TP, Stun)',
                xi.msg.channel.SYSTEM_3
            )
        else
            player:printToPlayer(
                '[Synergy: Airborne Assault] Extra momentum from your leap! (+50 TP)',
                xi.msg.channel.SYSTEM_3
            )
        end
    end,
    description = 'Leaping Boots: weapon skills gain +50 TP return and 25% stun chance.',
}

db.ws_deathbringer =
{
    itemId      = 16637,    -- Deathbringer
    slot        = xi.slot.MAIN,
    name        = 'Death\'s Embrace',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        -- Drain HP equal to 10% of damage dealt (approximated)
        local drain = 50 + (tier * 30)
        player:addHP(drain)
        mob:addStatusEffect(xi.effect.BIO, 15, 3, 30)
        player:printToPlayer(
            string.format('[Synergy: Death\'s Embrace] The blade drinks! (HP +%d, Bio on target)', drain),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Deathbringer: weapon skills drain HP and inflict Bio.',
}

db.ws_precision_bandana =
{
    itemId      = 11493,    -- Precision Bandana
    slot        = xi.slot.HEAD,
    name        = 'Precision Strike',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        -- WS gains guaranteed crit on next attack round
        player:addStatusEffect(xi.effect.BOOST, 50, 0, 15)
        player:printToPlayer(
            '[Synergy: Precision Strike] Perfect aim! (Guaranteed crit for 15s after WS)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Precision Bandana: weapon skills grant a crit buff afterward.',
}

db.ws_storm_belt =
{
    itemId      = 15882,    -- Storm Belt
    slot        = xi.slot.WAIST,
    name        = 'Thunder Slash',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        -- Add lightning damage to WS
        mob:addStatusEffect(xi.effect.SHOCK, 15, 3, 30)
        player:addTP(30)
        player:printToPlayer(
            '[Synergy: Thunder Slash] Lightning arcs from your strike! (Shock on target, +30 TP)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Storm Belt: weapon skills deal shock damage and return TP.',
}

db.ws_tilt_belt =
{
    itemId      = 15286,    -- Tilt Belt
    slot        = xi.slot.WAIST,
    name        = 'Reckless Cleave',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        -- All-out: deal extra damage but lower DEF briefly
        mob:addStatusEffect(xi.effect.DEFENSE_DOWN, 25, 0, 30)
        player:printToPlayer(
            '[Synergy: Reckless Cleave] Devastating follow-through! (Target DEF Down 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Tilt Belt: weapon skills inflict Defense Down on target.',
}

db.ws_arondight =
{
    itemId      = 16945,    -- Arondight
    slot        = xi.slot.MAIN,
    name        = 'Holy Blade',
    type        = 'on_ws',
    condition   = function(player, mob, template, tier)
        return tier >= xi.dynamicWorld.tier.ELITE
    end,
    effect      = function(player, mob, template, tier, wsid)
        -- WS deals bonus holy damage vs elites+
        player:addHP(100)
        player:addMP(50)
        player:printToPlayer(
            '[Synergy: Holy Blade] Arondight burns with holy light! (HP +100, MP +50 on WS)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Arondight: weapon skills restore HP/MP vs elite+ dynamic mobs.',
}

db.ws_oliphant =
{
    itemId      = 17843,    -- Oliphant
    slot        = xi.slot.RANGED,
    name        = 'Battle Cry',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        -- Party TP regen after WS
        local party = player:getParty()
        if party then
            for _, member in pairs(party) do
                if member:getZoneID() == player:getZoneID() then
                    local dist = member:checkDistance(player) or 9999
                    if dist < 30 then
                        member:addTP(30)
                    end
                end
            end
        end
        player:printToPlayer(
            '[Synergy: Battle Cry] Your war cry invigorates allies! (Party TP +30)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Oliphant: weapon skills grant TP to nearby party members.',
}

-----------------------------------
-- SPELL AUGMENTS
-- These fire when the player casts a spell on/near a dynamic entity.
-- They can boost spell damage, add secondary effects, or grant buffs.
-----------------------------------

db.spell_mist_silk_cape =
{
    itemId      = 13607,    -- Mist Silk Cape
    slot        = xi.slot.BACK,
    name        = 'Mist Healer',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Cure spells are IDs 1-6
        return spellId and spellId >= 1 and spellId <= 6
    end,
    effect      = function(player, mob, template, tier, spellId)
        -- Cure spells also grant Regen to target
        player:addStatusEffect(xi.effect.REGEN, 8, 3, 60)
        player:printToPlayer(
            '[Synergy: Mist Healer] Healing mist lingers! (Regen after Cure, 60s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Mist Silk Cape: Cure spells grant Regen in dynamic world combat.',
}

db.spell_red_sash =
{
    itemId      = 15455,    -- Red Sash
    slot        = xi.slot.WAIST,
    name        = 'Crimson Burst',
    type        = 'on_spell',
    effect      = function(player, mob, template, tier, spellId)
        -- All offensive spells get bonus magic damage
        player:addMod(xi.mod.MAGIC_DAMAGE, 15)
        -- Remove after a short delay (one-shot boost)
        player:timer(5000, function(p)
            p:delMod(xi.mod.MAGIC_DAMAGE, 15)
        end)
        player:printToPlayer(
            '[Synergy: Crimson Burst] Crimson energy surges into your spell! (Magic DMG +15 this cast)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Red Sash: spells deal bonus magic damage vs dynamic mobs.',
}

db.spell_moldavite =
{
    itemId      = 14724,    -- Moldavite Earring
    slot        = xi.slot.EAR1,
    name        = 'Celestial Focus',
    type        = 'on_spell',
    effect      = function(player, mob, template, tier, spellId)
        -- 20% chance of free MP (simulated by returning MP)
        if math.random(100) <= 20 then
            player:addMP(math.random(20, 50))
            player:printToPlayer(
                '[Synergy: Celestial Focus] The meteorite shard absorbs ambient magic! (MP refund)',
                xi.msg.channel.SYSTEM_3
            )
        end
    end,
    description = 'Moldavite Earring: 20% chance to refund MP on spells vs dynamic mobs.',
}

db.spell_spirit_torque =
{
    itemId      = 13129,    -- Spirit Torque
    slot        = xi.slot.NECK,
    name        = 'Spiritual Cascade',
    type        = 'on_spell',
    effect      = function(player, mob, template, tier, spellId)
        -- All spells grant a small TP bonus (encourages hybrid play)
        player:addTP(20)
        player:printToPlayer(
            '[Synergy: Spiritual Cascade] Casting fuels your combat spirit! (+20 TP)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Spirit Torque: spells grant TP vs dynamic mobs (hybrid bonus).',
}

db.spell_federation_wisdom =
{
    itemId      = 13496,    -- Windurstian Ring
    slot        = xi.slot.RING1,
    name        = 'Star Sibyl\'s Blessing',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Enfeebling spells (rough range, includes common debuffs)
        return spellId and spellId >= 230 and spellId <= 280
    end,
    effect      = function(player, mob, template, tier, spellId)
        -- Enfeebling spells also apply magic defense down
        mob:addStatusEffect(xi.effect.MAGIC_DEF_DOWN, 15, 0, 60)
        player:printToPlayer(
            '[Synergy: Star Sibyl\'s Blessing] Your debuff pierces deeper! (MDEF Down on target)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Windurstian Ring: enfeebling spells also apply Magic DEF Down.',
}

db.spell_pumpkin_head =
{
    itemId      = 13916,    -- Pumpkin Head
    slot        = xi.slot.HEAD,
    name        = 'Trick or Treat',
    type        = 'on_spell',
    effect      = function(player, mob, template, tier, spellId)
        -- Random bonus: either big damage boost or MP recovery
        if math.random(100) <= 50 then
            player:addMod(xi.mod.MATT, 30)
            player:timer(5000, function(p)
                p:delMod(xi.mod.MATT, 30)
            end)
            player:printToPlayer(
                '[Synergy: Trick or Treat] Trick! Spell power surges! (MATT +30 this cast)',
                xi.msg.channel.SYSTEM_3
            )
        else
            player:addMP(math.random(30, 80))
            player:printToPlayer(
                '[Synergy: Trick or Treat] Treat! MP candy! (MP restored)',
                xi.msg.channel.SYSTEM_3
            )
        end
    end,
    description = 'Pumpkin Head: spells randomly get a damage boost or MP refund.',
}

-----------------------------------
-- JOB ABILITY AUGMENTS
-- These fire when the player uses a job ability near a dynamic entity.
-- They enhance the ability's effect or add secondary bonuses.
-----------------------------------

db.ability_chocobo_shirt =
{
    itemId      = 10293,    -- Chocobo Shirt
    slot        = xi.slot.BODY,
    name        = 'Chocobo Sprint',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        -- Any defensive ability also grants Flee
        player:addStatusEffect(xi.effect.FLEE, 25, 0, 30)
        player:printToPlayer(
            '[Synergy: Chocobo Sprint] Kweh! Quick getaway ready! (Flee 30s after ability)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Chocobo Shirt: job abilities grant brief Flee effect.',
}

db.ability_moogle_suit =
{
    itemId      = 10250,    -- Moogle Suit
    slot        = xi.slot.BODY,
    name        = 'Moogle\'s Blessing',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        -- Abilities also restore a small amount of HP/MP
        player:addHP(50)
        player:addMP(25)
        player:printToPlayer(
            '[Synergy: Moogle\'s Blessing] Kupo! The moogle spirit refreshes you! (HP +50, MP +25)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Moogle Suit: job abilities restore HP and MP.',
}

db.ability_bastokan_ring =
{
    itemId      = 13497,    -- Bastokan Ring
    slot        = xi.slot.RING1,
    name        = 'Republic Discipline',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        -- Abilities grant Store TP buff
        player:addMod(xi.mod.STORETP, 10)
        player:timer(30000, function(p)
            p:delMod(xi.mod.STORETP, 10)
        end)
        player:printToPlayer(
            '[Synergy: Republic Discipline] Bastokan training kicks in! (Store TP +10 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Bastokan Ring: job abilities grant Store TP buff.',
}

db.ability_sandorian_ring =
{
    itemId      = 13495,    -- San d'Orian Ring
    slot        = xi.slot.RING1,
    name        = 'Royal Command',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        -- Abilities grant party defense
        local party = player:getParty()
        if party then
            for _, member in pairs(party) do
                if member:getZoneID() == player:getZoneID() then
                    local dist = member:checkDistance(player) or 9999
                    if dist < 20 then
                        member:addMod(xi.mod.DEF, 10)
                        member:timer(30000, function(m)
                            m:delMod(xi.mod.DEF, 10)
                        end)
                    end
                end
            end
        end
        player:printToPlayer(
            '[Synergy: Royal Command] The king\'s guard rallies! (Party DEF +10 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'San d\'Orian Ring: job abilities grant party DEF boost.',
}

db.ability_iron_ram_mufflers =
{
    itemId      = 15005,    -- Iron Ram Mufflers
    slot        = xi.slot.HANDS,
    name        = 'Iron Discipline',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        -- Abilities grant Enmity+ (tank support)
        player:addMod(xi.mod.ENMITY, 10)
        player:addStatusEffect(xi.effect.PHALANX, 15, 0, 30)
        player:timer(30000, function(p)
            p:delMod(xi.mod.ENMITY, 10)
        end)
        player:printToPlayer(
            '[Synergy: Iron Discipline] Hold the line! (Enmity +10, Phalanx 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Iron Ram Mufflers: abilities grant Enmity and Phalanx.',
}

db.ability_night_cape =
{
    itemId      = 13576,    -- Night Cape
    slot        = xi.slot.BACK,
    name        = 'Shadow Step',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        -- Abilities grant brief shadow images
        player:addStatusEffect(xi.effect.BLINK, 2, 0, 30)
        player:addMod(xi.mod.EVA, 15)
        player:timer(30000, function(p)
            p:delMod(xi.mod.EVA, 15)
        end)
        player:printToPlayer(
            '[Synergy: Shadow Step] You melt into shadow! (Blink + EVA +15 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Night Cape: abilities grant shadow images and evasion.',
}

-----------------------------------
-- EXTENDED WEAPON SKILL AUGMENTS
-- Solo-friendly: heal on WS, TP sustain, defensive procs
-----------------------------------

-- Peacock Charm: "Peacock's Precision" - WS gains guaranteed accuracy window + crit
db.ws_peacock_charm =
{
    itemId      = 13108,    -- Peacock Charm (Lv33 Rare, ACC+10)
    slot        = xi.slot.NECK,
    name        = 'Peacock\'s Precision',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addMod(xi.mod.ACC, 50)
        player:addMod(xi.mod.CRITHITRATE, 15)
        player:timer(8000, function(p)
            p:delMod(xi.mod.ACC, 50)
            p:delMod(xi.mod.CRITHITRATE, 15)
        end)
        player:printToPlayer(
            '[Synergy: Peacock\'s Precision] Flawless form! (ACC +50, Crit +15% for 8s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Peacock Charm: WS grants a brief window of perfect accuracy and crit.',
}

-- Speed Belt: "Afterimage" - WS grants brief haste + shadows
db.ws_speed_belt =
{
    itemId      = 15291,    -- Speed Belt (Lv50 Rare, Haste+6%)
    slot        = xi.slot.WAIST,
    name        = 'Afterimage',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addStatusEffect(xi.effect.HASTE, 15, 0, 20)
        player:addStatusEffect(xi.effect.BLINK, 2, 0, 20)
        player:printToPlayer(
            '[Synergy: Afterimage] You move so fast you leave shadows! (Haste + Blink 20s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Speed Belt: WS grants brief Haste and shadow images.',
}

-- Jelly Ring: "Gelatinous Ward" - WS grants damage reduction
db.ws_jelly_ring =
{
    itemId      = 13542,    -- Jelly Ring (Lv40 Rare, Phys dmg -5%)
    slot        = xi.slot.RING1,
    name        = 'Gelatinous Ward',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addStatusEffect(xi.effect.STONESKIN, 100 + (tier * 50), 0, 30)
        player:printToPlayer(
            string.format('[Synergy: Gelatinous Ward] A jelly-like barrier absorbs damage! (Stoneskin %d, 30s)', 100 + (tier * 50)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Jelly Ring: WS grants Stoneskin scaling with mob tier.',
}

-- Amemet Mantle: "Predator's Frenzy" - WS drains HP (solo sustain)
db.ws_amemet_mantle =
{
    itemId      = 13690,    -- Amemet Mantle (Lv50 Rare, ATT+15 EVA-10)
    slot        = xi.slot.BACK,
    name        = 'Predator\'s Frenzy',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        local drain = 75 + (tier * 40)
        player:addHP(drain)
        player:addMod(xi.mod.ATT, 15)
        player:timer(15000, function(p)
            p:delMod(xi.mod.ATT, 15)
        end)
        player:printToPlayer(
            string.format('[Synergy: Predator\'s Frenzy] The hunt sustains you! (HP +%d, ATT +15 for 15s)', drain),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Amemet Mantle: WS drains HP and grants ATT buff (solo sustain).',
}

-- Serket Ring: "Scorpion Strike" - WS gains STR scaling + poison proc
db.ws_serket_ring =
{
    itemId      = 13573,    -- Serket Ring (Lv60 Rare, STR+5)
    slot        = xi.slot.RING1,
    name        = 'Scorpion Strike',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        mob:addStatusEffect(xi.effect.POISON, 15 + (tier * 5), 3, 60)
        mob:addStatusEffect(xi.effect.DEFENSE_DOWN, 15, 0, 30)
        player:printToPlayer(
            '[Synergy: Scorpion Strike] Venomous follow-through! (Poison + DEF Down on target)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Serket Ring: WS inflicts Poison and Defense Down.',
}

-- Ethereal Earring: "Ethereal Resonance" - WS restores HP and MP (key solo sustain)
db.ws_ethereal_earring =
{
    itemId      = 15965,    -- Ethereal Earring (Lv72 R/Ex, HP+15)
    slot        = xi.slot.EAR1,
    name        = 'Ethereal Resonance',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        local hpRestore = 40 + (tier * 25)
        local mpRestore = 20 + (tier * 15)
        player:addHP(hpRestore)
        player:addMP(mpRestore)
        player:printToPlayer(
            string.format('[Synergy: Ethereal Resonance] Ethereal energy flows back! (HP +%d, MP +%d)', hpRestore, mpRestore),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Ethereal Earring: WS restores HP and MP (hybrid sustain).',
}

-- Fenian Ring: "Heroic Momentum" - WS grants Regain (TP over time)
db.ws_fenian_ring =
{
    itemId      = 15831,    -- Fenian Ring (Lv70 R/Ex, DEX+5 AGI+5)
    slot        = xi.slot.RING1,
    name        = 'Heroic Momentum',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addStatusEffect(xi.effect.REGAIN, 15, 3, 30)
        player:printToPlayer(
            '[Synergy: Heroic Momentum] Battle momentum builds! (Regain +15 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Fenian Ring: WS grants Regain effect for faster TP.',
}

-- Suppanomimi: "Twin Fangs" - WS has chance for double strike
db.ws_suppanomimi =
{
    itemId      = 14739,    -- Suppanomimi (Lv70 R/Ex, Dual Wield+5)
    slot        = xi.slot.EAR1,
    name        = 'Twin Fangs',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        -- Grant brief double/triple attack window after WS
        player:addMod(xi.mod.DOUBLE_ATTACK, 20)
        player:addMod(xi.mod.TRIPLE_ATTACK, 5)
        player:timer(10000, function(p)
            p:delMod(xi.mod.DOUBLE_ATTACK, 20)
            p:delMod(xi.mod.TRIPLE_ATTACK, 5)
        end)
        player:printToPlayer(
            '[Synergy: Twin Fangs] Your strikes multiply! (DA +20%, TA +5% for 10s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Suppanomimi: WS grants multi-attack window afterward.',
}

-- Emperor Hairpin: "Imperial Dodge" - WS grants evasion burst
db.ws_emperor_hairpin =
{
    itemId      = 12486,    -- Emperor Hairpin (Lv24 Rare, DEX+3 AGI+3 CHR+3)
    slot        = xi.slot.HEAD,
    name        = 'Imperial Dodge',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addMod(xi.mod.EVA, 40)
        player:addMod(xi.mod.AGI, 10)
        player:timer(15000, function(p)
            p:delMod(xi.mod.EVA, 40)
            p:delMod(xi.mod.AGI, 10)
        end)
        player:printToPlayer(
            '[Synergy: Imperial Dodge] Regal grace! (EVA +40, AGI +10 for 15s after WS)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Emperor Hairpin: WS grants evasion and agility burst.',
}

-- Bomb Ring: "Detonation" - WS has % chance for fire AoE burst
db.ws_bomb_ring =
{
    itemId      = 13551,    -- Bomb Ring (Lv10 Rare, Fire DEF+5)
    slot        = xi.slot.RING1,
    name        = 'Detonation',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        if math.random(100) <= 30 then
            mob:addStatusEffect(xi.effect.BURN, 20, 3, 30)
            mob:addStatusEffect(xi.effect.STUN, 1, 0, 3)
            player:printToPlayer(
                '[Synergy: Detonation] BOOM! Explosive follow-up! (Burn + Stun on target)',
                xi.msg.channel.SYSTEM_3
            )
        else
            player:addTP(20)
            player:printToPlayer(
                '[Synergy: Detonation] The ring smolders... (+20 TP)',
                xi.msg.channel.SYSTEM_3
            )
        end
    end,
    description = 'Bomb Ring: WS has 30% chance for fire explosion (Burn + Stun).',
}

-- Astral Ring: "Astral Conduit" - Magic WS restores MP
db.ws_astral_ring =
{
    itemId      = 13579,    -- Astral Ring (Lv10 Rare, MP+25)
    slot        = xi.slot.RING1,
    name        = 'Astral Conduit',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        local mpReturn = 30 + (tier * 15)
        player:addMP(mpReturn)
        player:addStatusEffect(xi.effect.REFRESH, 3, 3, 20)
        player:printToPlayer(
            string.format('[Synergy: Astral Conduit] Cosmic energy returns! (MP +%d, Refresh 20s)', mpReturn),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Astral Ring: WS restores MP and grants brief Refresh (mage WS sustain).',
}

-- Life Belt: "Vital Strike" - WS grants accuracy + Regen (solo sustain)
db.ws_life_belt =
{
    itemId      = 15289,    -- Life Belt (Lv40 Rare, ACC+10)
    slot        = xi.slot.WAIST,
    name        = 'Vital Strike',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addStatusEffect(xi.effect.REGEN, 5 + tier * 2, 3, 30)
        player:addTP(25)
        player:printToPlayer(
            string.format('[Synergy: Vital Strike] Life energy flows! (Regen +%d for 30s, +25 TP)', 5 + tier * 2),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Life Belt: WS grants Regen and TP return (solo sustain).',
}

-- Sniper's Ring: "Bullseye" - Ranged WS bonus RATT + guaranteed crit
db.ws_snipers_ring =
{
    itemId      = 13555,    -- Sniper's Ring (Lv40 Rare, RACC+5)
    slot        = xi.slot.RING1,
    name        = 'Bullseye',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addMod(xi.mod.RATT, 30)
        player:addMod(xi.mod.RACC, 30)
        player:timer(10000, function(p)
            p:delMod(xi.mod.RATT, 30)
            p:delMod(xi.mod.RACC, 30)
        end)
        player:printToPlayer(
            '[Synergy: Bullseye] Perfect shot lined up! (RATT +30, RACC +30 for 10s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Sniper\'s Ring: WS grants massive ranged stat burst.',
}

-- Serket Shield: "Scorpion Guard" - WS grants shield effect
db.ws_serket_shield =
{
    itemId      = 12348,    -- Serket Shield (Lv49 R/Ex, DEF+12)
    slot        = xi.slot.SUB,
    name        = 'Scorpion Guard',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addStatusEffect(xi.effect.PHALANX, 15, 0, 30)
        player:addStatusEffect(xi.effect.PROTECT, 40, 0, 30)
        player:printToPlayer(
            '[Synergy: Scorpion Guard] Your shield pulses with defensive energy! (Phalanx + Protect 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Serket Shield: WS grants Phalanx and Protect (tank sustain).',
}

-- Archer's Ring: "Steady Aim" - WS grants Store TP + Subtle Blow
db.ws_archers_ring =
{
    itemId      = 13553,    -- Archer's Ring (Lv14 Rare, RACC+2 RATT+2)
    slot        = xi.slot.RING1,
    name        = 'Steady Aim',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addMod(xi.mod.STORETP, 15)
        player:addMod(xi.mod.SUBTLE_BLOW, 15)
        player:timer(30000, function(p)
            p:delMod(xi.mod.STORETP, 15)
            p:delMod(xi.mod.SUBTLE_BLOW, 15)
        end)
        player:printToPlayer(
            '[Synergy: Steady Aim] Focused combat stance! (Store TP +15, Subtle Blow +15 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Archer\'s Ring: WS grants Store TP and Subtle Blow.',
}

-- Iron Ram Sollerets: "Earthshaker" - WS grants Stoneskin + Def
db.ws_iron_ram_sollerets =
{
    itemId      = 15749,    -- Iron Ram Sollerets
    slot        = xi.slot.FEET,
    name        = 'Earthshaker',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addStatusEffect(xi.effect.STONESKIN, 80 + (tier * 30), 0, 30)
        player:printToPlayer(
            string.format('[Synergy: Earthshaker] The earth shields you! (Stoneskin %d)', 80 + (tier * 30)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Iron Ram Sollerets: WS grants Stoneskin.',
}

-- Variable Mantle: "Shifting Ward" - WS grants Shell + MEVA
db.ws_variable_mantle =
{
    itemId      = 13680,    -- Variable Mantle
    slot        = xi.slot.BACK,
    name        = 'Shifting Ward',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addStatusEffect(xi.effect.SHELL, 2, 0, 30)
        player:addMod(xi.mod.MEVA, 20)
        player:timer(30000, function(p)
            p:delMod(xi.mod.MEVA, 20)
        end)
        player:printToPlayer(
            '[Synergy: Shifting Ward] Your cloak deflects magic! (Shell + MEVA +20 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Variable Mantle: WS grants Shell and Magic Evasion.',
}

-- Caduceus: "Mercury\'s Rush" - WS grants party-wide Refresh
db.ws_caduceus =
{
    itemId      = 17058,    -- Caduceus
    slot        = xi.slot.MAIN,
    name        = 'Mercury\'s Rush',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        local party = player:getParty()
        if party then
            for _, member in pairs(party) do
                if member:getZoneID() == player:getZoneID() then
                    local dist = member:checkDistance(player) or 9999
                    if dist < 30 then
                        member:addStatusEffect(xi.effect.REFRESH, 2, 3, 30)
                    end
                end
            end
        else
            player:addStatusEffect(xi.effect.REFRESH, 3, 3, 30)
        end
        player:printToPlayer(
            '[Synergy: Mercury\'s Rush] Divine winds refresh your party! (Refresh 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Caduceus: WS grants party Refresh.',
}

-- Raven Scythe: "Soul Reaper" - WS drains MP and grants Endark burst
db.ws_raven_scythe =
{
    itemId      = 16798,    -- Raven Scythe
    slot        = xi.slot.MAIN,
    name        = 'Soul Reaper',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        local mpDrain = 25 + (tier * 15)
        player:addMP(mpDrain)
        player:addStatusEffect(xi.effect.ENDARK, 20, 0, 30)
        player:printToPlayer(
            string.format('[Synergy: Soul Reaper] Dark energy consumed! (MP +%d, Endark 30s)', mpDrain),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Raven Scythe: WS drains MP and grants Endark.',
}

-- Fencing Degen: "Riposte Window" - WS grants counter + parry chance
db.ws_fencing_degen =
{
    itemId      = 16829,    -- Fencing Degen
    slot        = xi.slot.MAIN,
    name        = 'Riposte Window',
    type        = 'on_ws',
    effect      = function(player, mob, template, tier, wsid)
        player:addMod(xi.mod.COUNTER, 20)
        player:timer(15000, function(p)
            p:delMod(xi.mod.COUNTER, 20)
        end)
        player:printToPlayer(
            '[Synergy: Riposte Window] En garde! (Counter +20% for 15s after WS)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Fencing Degen: WS grants counter window.',
}

-----------------------------------
-- EXTENDED SPELL AUGMENTS
-- Solo-friendly: MP sustain, self-healing, hybrid play
-----------------------------------

-- Giant's Earring: "Giant's Vitality" - Cure spells heal extra
db.spell_giants_earring =
{
    itemId      = 11043,    -- Giant's Earring
    slot        = xi.slot.EAR1,
    name        = 'Giant\'s Vitality',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        return spellId and spellId >= 1 and spellId <= 6
    end,
    effect      = function(player, mob, template, tier, spellId)
        local bonusHeal = 50 + (tier * 25)
        player:addHP(bonusHeal)
        player:printToPlayer(
            string.format('[Synergy: Giant\'s Vitality] Your cure surges with giant strength! (Bonus HP +%d)', bonusHeal),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Giant\'s Earring: Cure spells heal extra in dynamic world combat.',
}

-- Sand Charm: "Desert Ward" - Bar spells also grant Stoneskin
db.spell_sand_charm =
{
    itemId      = 13095,    -- Sand Charm
    slot        = xi.slot.NECK,
    name        = 'Desert Ward',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Barspells: Barfire(60), Barblizzard(61), Baraero(62), Barstone(63), Barthunder(64), Barwater(65)
        return spellId and spellId >= 60 and spellId <= 65
    end,
    effect      = function(player, mob, template, tier, spellId)
        player:addStatusEffect(xi.effect.STONESKIN, 100, 0, 120)
        player:printToPlayer(
            '[Synergy: Desert Ward] Sand hardens into armor! (Stoneskin 100 when casting Bar spell)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Sand Charm: Bar spells also grant Stoneskin.',
}

-- Night Cape: "Dark Siphon" - Dark magic drains extra + grants shadows
db.spell_night_cape =
{
    itemId      = 13576,    -- Night Cape
    slot        = xi.slot.BACK,
    name        = 'Dark Siphon',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Drain(245), Aspir(247), Bio(230), Bio II(231)
        return spellId and (spellId == 245 or spellId == 247 or spellId == 230 or spellId == 231)
    end,
    effect      = function(player, mob, template, tier, spellId)
        player:addStatusEffect(xi.effect.BLINK, 2, 0, 30)
        local mpReturn = 15 + (tier * 10)
        player:addMP(mpReturn)
        player:printToPlayer(
            string.format('[Synergy: Dark Siphon] Shadows coalesce from the darkness! (Blink + MP +%d)', mpReturn),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Night Cape: Dark magic grants shadow images and bonus MP.',
}

-- Shaded Spectacles: "Analytical Debuff" - Enfeebling spells hit harder
db.spell_shaded_spectacles =
{
    itemId      = 13945,    -- Shaded Spectacles
    slot        = xi.slot.HEAD,
    name        = 'Analytical Debuff',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Common enfeebles: Dia(23), Dia II(24), Slow(56), Paralyze(58), Silence(59), Gravity(216), Bind(258)
        return spellId and ((spellId >= 23 and spellId <= 24) or spellId == 56 or spellId == 58
            or spellId == 59 or spellId == 216 or spellId == 258)
    end,
    effect      = function(player, mob, template, tier, spellId)
        -- Also apply magic defense down
        mob:addStatusEffect(xi.effect.MAGIC_DEF_DOWN, 10, 0, 60)
        player:addMod(xi.mod.MACC, 15)
        player:timer(10000, function(p)
            p:delMod(xi.mod.MACC, 15)
        end)
        player:printToPlayer(
            '[Synergy: Analytical Debuff] Weakness identified! (MDEF Down on target, MACC +15 for 10s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Shaded Spectacles: Enfeebling spells also lower Magic DEF and boost MACC.',
}

-- Fire Ring: "Inferno Cascade" - Fire spells deal bonus damage + Burn
db.spell_fire_ring =
{
    itemId      = 13560,    -- Fire Ring
    slot        = xi.slot.RING1,
    name        = 'Inferno Cascade',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Fire(144), Fire II(145), Fire III(146), Fire IV(147), Firaga(174), Firaga II(175), Firaga III(176), Flare(204)
        return spellId and ((spellId >= 144 and spellId <= 147) or (spellId >= 174 and spellId <= 176) or spellId == 204)
    end,
    effect      = function(player, mob, template, tier, spellId)
        mob:addStatusEffect(xi.effect.BURN, 15, 3, 30)
        player:addMod(xi.mod.FIRE_MAB, 25)
        player:timer(8000, function(p)
            p:delMod(xi.mod.FIRE_MAB, 25)
        end)
        player:printToPlayer(
            '[Synergy: Inferno Cascade] Flames intensify! (Burn on target, Fire MAB +25 this cast)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Fire Ring: Fire spells inflict Burn and gain bonus Fire MAB.',
}

-- Ice Ring: "Glacial Cascade" - Ice spells + Paralyze
db.spell_ice_ring =
{
    itemId      = 13561,    -- Ice Ring
    slot        = xi.slot.RING1,
    name        = 'Glacial Cascade',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Blizzard(149), II(150), III(151), IV(152), Blizzaga(179), II(180), III(181), Freeze(206)
        return spellId and ((spellId >= 149 and spellId <= 152) or (spellId >= 179 and spellId <= 181) or spellId == 206)
    end,
    effect      = function(player, mob, template, tier, spellId)
        if math.random(100) <= 40 then
            mob:addStatusEffect(xi.effect.PARALYSIS, 15, 0, 30)
        end
        player:addMod(xi.mod.ICE_MAB, 25)
        player:timer(8000, function(p)
            p:delMod(xi.mod.ICE_MAB, 25)
        end)
        player:printToPlayer(
            '[Synergy: Glacial Cascade] Bitter cold bites! (40% Paralyze, Ice MAB +25 this cast)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Ice Ring: Ice spells may Paralyze and gain bonus Ice MAB.',
}

-- Mermaid's Ring: "Tidal Cascade" - Water spells + Slow
db.spell_mermaids_ring =
{
    itemId      = 14626,    -- Mermaid's Ring
    slot        = xi.slot.RING1,
    name        = 'Tidal Cascade',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Water(169), II(170), III(171), IV(172), Waterga(199), II(200), III(201), Flood(209)
        return spellId and ((spellId >= 169 and spellId <= 172) or (spellId >= 199 and spellId <= 201) or spellId == 209)
    end,
    effect      = function(player, mob, template, tier, spellId)
        mob:addStatusEffect(xi.effect.SLOW, 15, 0, 30)
        player:addMod(xi.mod.WATER_MAB, 25)
        player:timer(8000, function(p)
            p:delMod(xi.mod.WATER_MAB, 25)
        end)
        player:printToPlayer(
            '[Synergy: Tidal Cascade] Waves crash over your foe! (Slow on target, Water MAB +25)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Mermaid\'s Ring: Water spells inflict Slow and gain Water MAB.',
}

-- Silver Name Tag: "Guardian Cure" - Protect/Shell spells also grant Regen
db.spell_silver_name_tag =
{
    itemId      = 13116,    -- Silver Name Tag
    slot        = xi.slot.NECK,
    name        = 'Guardian Cure',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Protect(43-47), Shell(48-52)
        return spellId and ((spellId >= 43 and spellId <= 47) or (spellId >= 48 and spellId <= 52))
    end,
    effect      = function(player, mob, template, tier, spellId)
        player:addStatusEffect(xi.effect.REGEN, 5, 3, 180)
        player:printToPlayer(
            '[Synergy: Guardian Cure] Your guardian spirit adds healing! (Regen for 3 min after Protect/Shell)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Silver Name Tag: Protect/Shell spells also grant Regen.',
}

-- Optical Earring: "Tactical Casting" - Elemental spells gain MACC burst
db.spell_optical_earring =
{
    itemId      = 14803,    -- Optical Earring
    slot        = xi.slot.EAR1,
    name        = 'Tactical Casting',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- All tier 1-4 elemental nukes (144-172)
        return spellId and spellId >= 144 and spellId <= 172
    end,
    effect      = function(player, mob, template, tier, spellId)
        player:addMod(xi.mod.MACC, 25)
        player:addMod(xi.mod.MAGIC_DAMAGE, 10)
        player:timer(8000, function(p)
            p:delMod(xi.mod.MACC, 25)
            p:delMod(xi.mod.MAGIC_DAMAGE, 10)
        end)
        player:printToPlayer(
            '[Synergy: Tactical Casting] Target lock confirmed! (MACC +25, Magic DMG +10 this cast)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Optical Earring: Elemental nukes gain MACC and Magic Damage.',
}

-- Auditory Torque: "Resonant Voice" - Songs/BRD spells grant extra TP
db.spell_auditory_torque =
{
    itemId      = 13178,    -- Auditory Torque
    slot        = xi.slot.NECK,
    name        = 'Resonant Voice',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- BRD songs roughly 394-449
        return spellId and spellId >= 394 and spellId <= 449
    end,
    effect      = function(player, mob, template, tier, spellId)
        player:addTP(40)
        player:addMP(20)
        player:printToPlayer(
            '[Synergy: Resonant Voice] Your song echoes with power! (+40 TP, +20 MP)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Auditory Torque: Songs grant TP and MP in dynamic world.',
}

-- Voyager Sallet: "Explorer\'s Insight" - Enhancing spells grant bonus stats
db.spell_voyager_sallet =
{
    itemId      = 15184,    -- Voyager Sallet
    slot        = xi.slot.HEAD,
    name        = 'Explorer\'s Insight',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Haste(57), Refresh(109), Regen(108,110)
        return spellId and (spellId == 57 or spellId == 108 or spellId == 109 or spellId == 110)
    end,
    effect      = function(player, mob, template, tier, spellId)
        local bonus = 3 * tier
        player:addMod(xi.mod.STR, bonus)
        player:addMod(xi.mod.DEX, bonus)
        player:addMod(xi.mod.VIT, bonus)
        player:timer(60000, function(p)
            p:delMod(xi.mod.STR, bonus)
            p:delMod(xi.mod.DEX, bonus)
            p:delMod(xi.mod.VIT, bonus)
        end)
        player:printToPlayer(
            string.format('[Synergy: Explorer\'s Insight] Enhancing magic amplified! (STR/DEX/VIT +%d for 60s)', bonus),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Voyager Sallet: Enhancing spells grant bonus stats.',
}

-- Aspis: "Blessed Aegis" - Cure spells also grant Stoneskin
db.spell_aspis =
{
    itemId      = 12291,    -- Aspis
    slot        = xi.slot.SUB,
    name        = 'Blessed Aegis',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        return spellId and spellId >= 1 and spellId <= 6
    end,
    effect      = function(player, mob, template, tier, spellId)
        player:addStatusEffect(xi.effect.STONESKIN, 50 + (tier * 25), 0, 60)
        player:printToPlayer(
            string.format('[Synergy: Blessed Aegis] Your shield channels healing! (Stoneskin %d on Cure)', 50 + (tier * 25)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Aspis: Cure spells also grant Stoneskin (paladin sustain).',
}

-- Assailant's Ring: "Arcane Assault" - Offensive spells grant Store TP
db.spell_assailants_ring =
{
    itemId      = 14676,    -- Assailant's Ring
    slot        = xi.slot.RING1,
    name        = 'Arcane Assault',
    type        = 'on_spell',
    effect      = function(player, mob, template, tier, spellId)
        player:addTP(15)
        player:addMod(xi.mod.STORETP, 5)
        player:timer(15000, function(p)
            p:delMod(xi.mod.STORETP, 5)
        end)
        player:printToPlayer(
            '[Synergy: Arcane Assault] Combat magic fuels your blade! (+15 TP, Store TP +5 for 15s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Assailant\'s Ring: Spells grant TP and Store TP (hybrid play).',
}

-- Saintly Ring: "Sacred Light" - Divine magic bonus heal + smite
db.spell_saintly_ring =
{
    itemId      = 13546,    -- Saintly Ring
    slot        = xi.slot.RING1,
    name        = 'Sacred Light',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Banish(28-33), Holy(21), Cure(1-6)
        return spellId and ((spellId >= 28 and spellId <= 33) or spellId == 21 or (spellId >= 1 and spellId <= 6))
    end,
    effect      = function(player, mob, template, tier, spellId)
        player:addHP(30 + (tier * 20))
        player:addStatusEffect(xi.effect.REGEN, 3, 3, 60)
        player:printToPlayer(
            string.format('[Synergy: Sacred Light] Divine grace heals you! (HP +%d, Regen 60s)', 30 + (tier * 20)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Saintly Ring: Divine/Cure spells also heal the caster.',
}

-- Dream Mittens: "Dreamcatcher" - Sleep/Repose spells also debuff the target
db.spell_dream_mittens =
{
    itemId      = 10382,    -- Dream Mittens
    slot        = xi.slot.HANDS,
    name        = 'Dreamcatcher',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Sleep(253), Sleep II(259), Repose(16)
        return spellId and (spellId == 253 or spellId == 259 or spellId == 16)
    end,
    effect      = function(player, mob, template, tier, spellId)
        mob:addStatusEffect(xi.effect.DEFENSE_DOWN, 20, 0, 60)
        mob:addStatusEffect(xi.effect.MAGIC_DEF_DOWN, 15, 0, 60)
        player:addMP(30)
        player:printToPlayer(
            '[Synergy: Dreamcatcher] Dreams weaken the foe! (DEF/MDEF Down + MP +30)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Dream Mittens: Sleep spells debuff target and refund MP.',
}

-- Ranger's Necklace: "Phantom Arrow" - Ninjutsu gains bonus damage
db.spell_rangers_necklace =
{
    itemId      = 13117,    -- Ranger's Necklace
    slot        = xi.slot.NECK,
    name        = 'Phantom Arrow',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        -- Ninjutsu elemental: Katon(320), Hyoton(321), Huton(322), Doton(323), Raiton(324), Suiton(325)
        -- Ni versions: 326-331
        -- San versions: 332-337 (if they exist)
        return spellId and spellId >= 320 and spellId <= 337
    end,
    effect      = function(player, mob, template, tier, spellId)
        player:addMod(xi.mod.MAGIC_DAMAGE, 20)
        player:addTP(25)
        player:timer(5000, function(p)
            p:delMod(xi.mod.MAGIC_DAMAGE, 20)
        end)
        player:printToPlayer(
            '[Synergy: Phantom Arrow] Ninja magic strikes true! (Magic DMG +20 this cast, +25 TP)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Ranger\'s Necklace: Ninjutsu deals bonus damage and grants TP.',
}

-- Mandraguard: "Mandragora Healing" - Cure spells grant Regen to caster
db.spell_mandraguard =
{
    itemId      = 10807,    -- Mandraguard
    slot        = xi.slot.SUB,
    name        = 'Mandragora Healing',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        return spellId and spellId >= 1 and spellId <= 6
    end,
    effect      = function(player, mob, template, tier, spellId)
        player:addStatusEffect(xi.effect.REGEN, 5, 3, 120)
        player:addMod(xi.mod.CURE_POTENCY, 10)
        player:timer(30000, function(p)
            p:delMod(xi.mod.CURE_POTENCY, 10)
        end)
        player:printToPlayer(
            '[Synergy: Mandragora Healing] The mandragora spirit helps you heal! (Regen + Cure Potency +10% for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Mandraguard: Cure spells grant Regen and Cure Potency boost.',
}

-- Bomb Ring: "Flare Catalyst" - Fire spells have chance to Stun
db.spell_bomb_ring =
{
    itemId      = 13551,    -- Bomb Ring
    slot        = xi.slot.RING1,
    name        = 'Flare Catalyst',
    type        = 'on_spell',
    condition   = function(player, mob, template, tier, spellId)
        return spellId and ((spellId >= 144 and spellId <= 147) or (spellId >= 174 and spellId <= 176) or spellId == 204)
    end,
    effect      = function(player, mob, template, tier, spellId)
        if math.random(100) <= 25 then
            mob:addStatusEffect(xi.effect.STUN, 1, 0, 4)
            player:printToPlayer(
                '[Synergy: Flare Catalyst] The explosion stuns your foe! (Stun 4s)',
                xi.msg.channel.SYSTEM_3
            )
        else
            player:addTP(15)
            player:printToPlayer(
                '[Synergy: Flare Catalyst] Fire energy crackles! (+15 TP)',
                xi.msg.channel.SYSTEM_3
            )
        end
    end,
    description = 'Bomb Ring: Fire spells have 25% chance to Stun.',
}

-- Ethereal Earring: "Ethereal Cast" - All spells restore small HP
db.spell_ethereal_earring =
{
    itemId      = 15965,    -- Ethereal Earring
    slot        = xi.slot.EAR1,
    name        = 'Ethereal Cast',
    type        = 'on_spell',
    effect      = function(player, mob, template, tier, spellId)
        local hpRestore = 15 + (tier * 10)
        player:addHP(hpRestore)
        player:printToPlayer(
            string.format('[Synergy: Ethereal Cast] Ethereal energy sustains you! (HP +%d on cast)', hpRestore),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Ethereal Earring: All spells restore small HP (mage sustain).',
}

-----------------------------------
-- EXTENDED JOB ABILITY AUGMENTS
-- Solo-friendly: defensive on 2hrs, sustain on common JAs,
-- scaling with tier to keep things interesting but not trivial
-----------------------------------

-- Peacock Charm: "Eagle Eye" - Sharpshot/Barrage enhanced
db.ability_peacock_charm =
{
    itemId      = 13108,    -- Peacock Charm
    slot        = xi.slot.NECK,
    name        = 'Eagle Eye',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addMod(xi.mod.RACC, 30)
        player:addMod(xi.mod.RATT, 20)
        player:timer(30000, function(p)
            p:delMod(xi.mod.RACC, 30)
            p:delMod(xi.mod.RATT, 20)
        end)
        player:printToPlayer(
            '[Synergy: Eagle Eye] Perfect vision! (RACC +30, RATT +20 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Peacock Charm: Abilities grant ranged attack boost.',
}

-- Speed Belt: "Quick Draw" - Abilities grant brief Haste
db.ability_speed_belt =
{
    itemId      = 15291,    -- Speed Belt
    slot        = xi.slot.WAIST,
    name        = 'Quick Draw',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addStatusEffect(xi.effect.HASTE, 15, 0, 30)
        player:printToPlayer(
            '[Synergy: Quick Draw] Lightning reflexes! (Haste 30s after ability)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Speed Belt: Abilities grant brief Haste.',
}

-- Amemet Mantle: "Predator's Instinct" - Provoke/engage abilities grant ATT + Regen
db.ability_amemet_mantle =
{
    itemId      = 13690,    -- Amemet Mantle
    slot        = xi.slot.BACK,
    name        = 'Predator\'s Instinct',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addMod(xi.mod.ATT, 20)
        player:addStatusEffect(xi.effect.REGEN, 5, 3, 30)
        player:timer(30000, function(p)
            p:delMod(xi.mod.ATT, 20)
        end)
        player:printToPlayer(
            '[Synergy: Predator\'s Instinct] The predator strikes! (ATT +20, Regen for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Amemet Mantle: Abilities grant ATT and Regen (melee sustain).',
}

-- Jelly Ring: "Gelatinous Reflex" - Defensive abilities grant Stoneskin
db.ability_jelly_ring =
{
    itemId      = 13542,    -- Jelly Ring
    slot        = xi.slot.RING1,
    name        = 'Gelatinous Reflex',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addStatusEffect(xi.effect.STONESKIN, 100 + (tier * 30), 0, 60)
        player:printToPlayer(
            string.format('[Synergy: Gelatinous Reflex] Jelly armor forms! (Stoneskin %d, 60s)', 100 + (tier * 30)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Jelly Ring: Abilities grant Stoneskin scaling with tier.',
}

-- Fenian Ring: "Heroic Resolve" - Abilities grant Regain + TP
db.ability_fenian_ring =
{
    itemId      = 15831,    -- Fenian Ring
    slot        = xi.slot.RING1,
    name        = 'Heroic Resolve',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addTP(50)
        player:addStatusEffect(xi.effect.REGAIN, 10, 3, 30)
        player:printToPlayer(
            '[Synergy: Heroic Resolve] Battle spirit surges! (+50 TP, Regain 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Fenian Ring: Abilities grant TP and Regain (TP sustain).',
}

-- Ethereal Earring: "Ethereal Recovery" - 2hr abilities restore HP/MP fully
db.ability_ethereal_earring =
{
    itemId      = 15965,    -- Ethereal Earring
    slot        = xi.slot.EAR1,
    name        = 'Ethereal Recovery',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        -- Significant HP/MP restore on any ability
        local hpRestore = 75 + (tier * 30)
        local mpRestore = 30 + (tier * 15)
        player:addHP(hpRestore)
        player:addMP(mpRestore)
        player:printToPlayer(
            string.format('[Synergy: Ethereal Recovery] Ethereal energy restores you! (HP +%d, MP +%d)', hpRestore, mpRestore),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Ethereal Earring: Abilities restore HP and MP.',
}

-- Astral Ring: "Astral Pulse" - Abilities grant Refresh
db.ability_astral_ring =
{
    itemId      = 13579,    -- Astral Ring
    slot        = xi.slot.RING1,
    name        = 'Astral Pulse',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addStatusEffect(xi.effect.REFRESH, 4, 3, 45)
        player:addMP(25)
        player:printToPlayer(
            '[Synergy: Astral Pulse] Cosmic energy replenishes! (Refresh for 45s, MP +25)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Astral Ring: Abilities grant Refresh and MP (mage sustain).',
}

-- Suppanomimi: "Dual Technique" - Abilities grant Dual Wield + multi-attack window
db.ability_suppanomimi =
{
    itemId      = 14739,    -- Suppanomimi
    slot        = xi.slot.EAR1,
    name        = 'Dual Technique',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addMod(xi.mod.DUAL_WIELD, 10)
        player:addMod(xi.mod.DOUBLE_ATTACK, 10)
        player:timer(30000, function(p)
            p:delMod(xi.mod.DUAL_WIELD, 10)
            p:delMod(xi.mod.DOUBLE_ATTACK, 10)
        end)
        player:printToPlayer(
            '[Synergy: Dual Technique] Twin-blade mastery! (Dual Wield +10, DA +10% for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Suppanomimi: Abilities grant Dual Wield and Double Attack.',
}

-- Giant's Earring: "Titan's Roar" - Abilities grant HP + STR burst
db.ability_giants_earring =
{
    itemId      = 11043,    -- Giant's Earring
    slot        = xi.slot.EAR1,
    name        = 'Titan\'s Roar',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        local hpBonus = 50 * tier
        player:addMod(xi.mod.HP, hpBonus)
        player:addMod(xi.mod.STR, 10)
        player:timer(30000, function(p)
            p:delMod(xi.mod.HP, hpBonus)
            p:delMod(xi.mod.STR, 10)
        end)
        player:printToPlayer(
            string.format('[Synergy: Titan\'s Roar] Giant power surges! (HP +%d, STR +10 for 30s)', hpBonus),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Giant\'s Earring: Abilities grant HP and STR burst.',
}

-- Emperor Hairpin: "Imperial Authority" - Abilities grant EVA + Blink
db.ability_emperor_hairpin =
{
    itemId      = 12486,    -- Emperor Hairpin
    slot        = xi.slot.HEAD,
    name        = 'Imperial Authority',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addStatusEffect(xi.effect.BLINK, 2, 0, 30)
        player:addMod(xi.mod.EVA, 25)
        player:timer(30000, function(p)
            p:delMod(xi.mod.EVA, 25)
        end)
        player:printToPlayer(
            '[Synergy: Imperial Authority] Royal grace protects you! (Blink + EVA +25 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Emperor Hairpin: Abilities grant Blink and Evasion.',
}

-- Bomb Ring: "Explosive Temper" - Abilities have % chance to AoE damage nearby mob
db.ability_bomb_ring =
{
    itemId      = 13551,    -- Bomb Ring
    slot        = xi.slot.RING1,
    name        = 'Explosive Temper',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        if math.random(100) <= 35 then
            mob:addStatusEffect(xi.effect.BURN, 20, 3, 30)
            mob:addStatusEffect(xi.effect.STUN, 1, 0, 3)
            player:printToPlayer(
                '[Synergy: Explosive Temper] KABOOM! (Burn + Stun on target)',
                xi.msg.channel.SYSTEM_3
            )
        else
            player:addTP(20)
            player:printToPlayer(
                '[Synergy: Explosive Temper] The ring heats up... (+20 TP)',
                xi.msg.channel.SYSTEM_3
            )
        end
    end,
    description = 'Bomb Ring: Abilities have 35% chance for fire explosion.',
}

-- Life Belt: "Vital Focus" - Abilities grant ACC + Regen (solo melee)
db.ability_life_belt =
{
    itemId      = 15289,    -- Life Belt
    slot        = xi.slot.WAIST,
    name        = 'Vital Focus',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addMod(xi.mod.ACC, 20)
        player:addStatusEffect(xi.effect.REGEN, 5, 3, 30)
        player:timer(30000, function(p)
            p:delMod(xi.mod.ACC, 20)
        end)
        player:printToPlayer(
            '[Synergy: Vital Focus] Focused determination! (ACC +20, Regen for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Life Belt: Abilities grant ACC and Regen.',
}

-- Serket Ring: "Scorpion Venom" - Abilities apply poison to mob
db.ability_serket_ring =
{
    itemId      = 13573,    -- Serket Ring
    slot        = xi.slot.RING1,
    name        = 'Scorpion Venom',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        mob:addStatusEffect(xi.effect.POISON, 10 + (tier * 5), 3, 60)
        player:addMod(xi.mod.STR, 8)
        player:timer(30000, function(p)
            p:delMod(xi.mod.STR, 8)
        end)
        player:printToPlayer(
            '[Synergy: Scorpion Venom] Venom courses! (Poison on target, STR +8 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Serket Ring: Abilities apply Poison and grant STR.',
}

-- Sand Charm: "Desert Fortitude" - Abilities grant elemental resistance
db.ability_sand_charm =
{
    itemId      = 13095,    -- Sand Charm
    slot        = xi.slot.NECK,
    name        = 'Desert Fortitude',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addMod(xi.mod.MDEF, 15)
        player:addMod(xi.mod.MEVA, 20)
        player:timer(30000, function(p)
            p:delMod(xi.mod.MDEF, 15)
            p:delMod(xi.mod.MEVA, 20)
        end)
        player:printToPlayer(
            '[Synergy: Desert Fortitude] Sand shields your spirit! (MDEF +15, MEVA +20 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Sand Charm: Abilities grant magic defense.',
}

-- Moldavite Earring: "Meteor Charge" - Abilities grant MATT burst
db.ability_moldavite =
{
    itemId      = 14724,    -- Moldavite Earring
    slot        = xi.slot.EAR1,
    name        = 'Meteor Charge',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addMod(xi.mod.MATT, 20)
        player:addMod(xi.mod.MACC, 15)
        player:timer(30000, function(p)
            p:delMod(xi.mod.MATT, 20)
            p:delMod(xi.mod.MACC, 15)
        end)
        player:printToPlayer(
            '[Synergy: Meteor Charge] Celestial power builds! (MATT +20, MACC +15 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Moldavite Earring: Abilities grant MATT and MACC burst.',
}

-- Sniper's Ring: "Steady Shot" - Abilities grant RACC + Store TP
db.ability_snipers_ring =
{
    itemId      = 13555,    -- Sniper's Ring
    slot        = xi.slot.RING1,
    name        = 'Steady Shot',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addMod(xi.mod.RACC, 20)
        player:addMod(xi.mod.STORETP, 10)
        player:timer(30000, function(p)
            p:delMod(xi.mod.RACC, 20)
            p:delMod(xi.mod.STORETP, 10)
        end)
        player:printToPlayer(
            '[Synergy: Steady Shot] Dialed in! (RACC +20, Store TP +10 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Sniper\'s Ring: Abilities grant RACC and Store TP.',
}

-- Leaping Boots: "Acrobatic Maneuver" - Abilities grant TA + Kick attacks
db.ability_leaping_boots =
{
    itemId      = 13014,    -- Leaping Boots
    slot        = xi.slot.FEET,
    name        = 'Acrobatic Maneuver',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addMod(xi.mod.TRIPLE_ATTACK, 5)
        player:addMod(xi.mod.KICK_ATTACK_RATE, 10)
        player:timer(30000, function(p)
            p:delMod(xi.mod.TRIPLE_ATTACK, 5)
            p:delMod(xi.mod.KICK_ATTACK_RATE, 10)
        end)
        player:printToPlayer(
            '[Synergy: Acrobatic Maneuver] Flips and kicks! (TA +5%, Kick +10% for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Leaping Boots: Abilities grant Triple Attack and Kick attacks.',
}

-- Windurstian Ring: "Star Sibyl\'s Grace" - Abilities grant Refresh + MP
db.ability_windurstian_ring =
{
    itemId      = 13496,    -- Windurstian Ring
    slot        = xi.slot.RING1,
    name        = 'Star Sibyl\'s Grace',
    type        = 'on_ability',
    effect      = function(player, mob, template, tier, abilityId)
        player:addStatusEffect(xi.effect.REFRESH, 3, 3, 45)
        player:addMP(30)
        player:printToPlayer(
            '[Synergy: Star Sibyl\'s Grace] Windurst\'s blessing! (Refresh 45s, MP +30)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Windurstian Ring: Abilities grant Refresh and MP.',
}

-----------------------------------
-- BEASTMASTER PET SYNERGIES
-- BST pets become powerful companions for dynamic world content
-----------------------------------

-- "Beast Bond" - BST with pet out gets massive pet buffs on engage
db.combo_beast_bond =
{
    name        = 'Beast Bond',
    type        = 'on_engage',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.BST and player:hasPet()
    end,
    effect      = function(player, mob, template, tier)
        -- Buff the pet significantly
        player:addPetMod(xi.mod.PET_ATK_DEF, 30 + (tier * 10))
        player:addPetMod(xi.mod.PET_ACC_EVA, 25 + (tier * 8))
        player:addPetMod(xi.mod.PET_ATTR_BONUS, 10 + (tier * 5))
        -- Master gets regen for sustain
        player:addStatusEffect(xi.effect.REGEN, 5 + tier * 2, 3, 300)
        player:printToPlayer(
            string.format('[Synergy: Beast Bond] Your pet surges with power! (Pet ATK/DEF +%d, ACC/EVA +%d, Regen)',
                30 + (tier * 10), 25 + (tier * 8)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'BST with pet: massive pet stat buffs and master Regen on engage.',
}

-- "Beast Fury" - BST pet gets TP bonus when master uses WS
db.combo_beast_fury_ws =
{
    name        = 'Beast Fury',
    type        = 'on_ws',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.BST and player:hasPet()
    end,
    effect      = function(player, mob, template, tier, wsid)
        player:addPetMod(xi.mod.PET_TP_BONUS, 200)
        player:timer(10000, function(p)
            p:delPetMod(xi.mod.PET_TP_BONUS, 200)
        end)
        -- Heal pet on WS
        local pet = player:getPet()
        if pet then
            pet:addHP(100 + (tier * 50))
        end
        player:addHP(50 + (tier * 20))
        player:printToPlayer(
            string.format('[Synergy: Beast Fury] Your beast mirrors your ferocity! (Pet TP +200, Pet healed %d)', 100 + (tier * 50)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'BST: WS grants pet TP bonus and heals both master and pet.',
}

-- "Beast Synergy" - BST abilities empower the pet further
db.combo_beast_ability =
{
    name        = 'Beast Synergy',
    type        = 'on_ability',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.BST and player:hasPet()
    end,
    effect      = function(player, mob, template, tier, abilityId)
        -- Pet gets big ATK burst
        player:addPetMod(xi.mod.PET_ATK_DEF, 25)
        player:timer(30000, function(p)
            p:delPetMod(xi.mod.PET_ATK_DEF, 25)
        end)
        -- Master gets Store TP to cycle faster
        player:addMod(xi.mod.STORETP, 10)
        player:timer(30000, function(p)
            p:delMod(xi.mod.STORETP, 10)
        end)
        player:printToPlayer(
            '[Synergy: Beast Synergy] You and your pet fight as one! (Pet ATK +25, Store TP +10 for 30s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'BST: Abilities empower pet ATK and grant master Store TP.',
}

-- "Beast Harvest" - BST pet kills grant extra rewards
db.combo_beast_harvest =
{
    name        = 'Beast Harvest',
    type        = 'on_kill',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.BST and player:hasPet()
    end,
    effect      = function(player, mob, template, tier)
        -- Heal pet fully on kill
        local pet = player:getPet()
        if pet then
            pet:addHP(pet:getMaxHP())
        end
        -- Master gets TP + HP
        player:addTP(100)
        player:addHP(75 + (tier * 30))
        player:printToPlayer(
            string.format('[Synergy: Beast Harvest] Your beast feasts! (Pet fully healed, you gain TP +100, HP +%d)', 75 + (tier * 30)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'BST: Kills fully heal pet and restore master HP/TP.',
}

-- "Beast Spell" - BST casting buffs also enhance pet
db.combo_beast_spell =
{
    name        = 'Beast Spell',
    type        = 'on_spell',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.BST and player:hasPet()
    end,
    effect      = function(player, mob, template, tier, spellId)
        -- Any spell cast near dynamic mob also buffs pet
        player:addPetMod(xi.mod.PET_MAB_MDB, 10)
        player:timer(30000, function(p)
            p:delPetMod(xi.mod.PET_MAB_MDB, 10)
        end)
        local pet = player:getPet()
        if pet then
            pet:addHP(30 + (tier * 10))
        end
        player:printToPlayer(
            '[Synergy: Beast Spell] Magic invigorates your companion! (Pet MAB/MDB +10, Pet healed)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'BST: Spells buff pet magic stats and heal the pet.',
}

-- Drover's Mantle + BST: "Pack Leader" - Enhanced pet command
db.ws_drovers_mantle_bst =
{
    itemId      = 16243,    -- Drover's Mantle
    slot        = xi.slot.BACK,
    name        = 'Pack Leader',
    type        = 'on_ws',
    condition   = function(player, mob, template, tier)
        return player:getMainJob() == xi.job.BST and player:hasPet()
    end,
    effect      = function(player, mob, template, tier, wsid)
        -- Extra pet power on master WS
        player:addPetMod(xi.mod.PET_ATK_DEF, 20)
        player:addPetMod(xi.mod.PET_ACC_EVA, 15)
        player:timer(15000, function(p)
            p:delPetMod(xi.mod.PET_ATK_DEF, 20)
            p:delPetMod(xi.mod.PET_ACC_EVA, 15)
        end)
        player:printToPlayer(
            '[Synergy: Pack Leader] Your mantle rallies the pack! (Pet ATK/DEF +20, ACC/EVA +15 for 15s)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Drover\'s Mantle + BST: WS boosts pet offensively.',
}

-----------------------------------
-- SUMMONER AVATAR SYNERGIES
-- Avatars become devastating forces in dynamic world content
-----------------------------------

-- "Astral Bond" - SMN with avatar out gets avatar buffs + reduced perp
db.combo_astral_bond =
{
    name        = 'Astral Bond',
    type        = 'on_engage',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.SMN and player:hasPet()
    end,
    effect      = function(player, mob, template, tier)
        -- Massive avatar buffs
        player:addPetMod(xi.mod.PET_MAB_MDB, 30 + (tier * 12))
        player:addPetMod(xi.mod.PET_MACC_MEVA, 25 + (tier * 10))
        player:addPetMod(xi.mod.PET_ATK_DEF, 20 + (tier * 8))
        -- Reduce perpetuation cost
        player:addMod(xi.mod.PERPETUATION_REDUCTION, 3)
        -- Refresh for MP sustain
        player:addStatusEffect(xi.effect.REFRESH, 4 + tier, 3, 300)
        player:printToPlayer(
            string.format('[Synergy: Astral Bond] Your avatar radiates power! (Avatar MAB +%d, Perp -3, Refresh)',
                30 + (tier * 12)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'SMN with avatar: massive avatar magic buffs, reduced perpetuation, Refresh.',
}

-- "Astral Fury" - Avatar gets TP burst on master spell cast
db.combo_astral_fury_spell =
{
    name        = 'Astral Fury',
    type        = 'on_spell',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.SMN and player:hasPet()
    end,
    effect      = function(player, mob, template, tier, spellId)
        -- Avatar gets massive TP for blood pacts
        player:addPetMod(xi.mod.PET_TP_BONUS, 300)
        player:timer(8000, function(p)
            p:delPetMod(xi.mod.PET_TP_BONUS, 300)
        end)
        -- MP sustain
        player:addMP(15 + (tier * 8))
        player:printToPlayer(
            string.format('[Synergy: Astral Fury] Your spell empowers your avatar! (Avatar TP +300, MP +%d)', 15 + (tier * 8)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'SMN: Spells grant avatar TP bonus and restore master MP.',
}

-- "Astral Rage" - Blood Pacts (abilities) deal extra and restore MP
db.combo_astral_rage_ability =
{
    name        = 'Astral Rage',
    type        = 'on_ability',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.SMN and player:hasPet()
    end,
    effect      = function(player, mob, template, tier, abilityId)
        -- Avatar gets MAB burst for the blood pact
        player:addPetMod(xi.mod.PET_MAB_MDB, 30)
        player:addPetMod(xi.mod.PET_ATK_DEF, 20)
        player:timer(15000, function(p)
            p:delPetMod(xi.mod.PET_MAB_MDB, 30)
            p:delPetMod(xi.mod.PET_ATK_DEF, 20)
        end)
        -- MP recovery for sustain
        player:addMP(40 + (tier * 15))
        player:addStatusEffect(xi.effect.REFRESH, 3, 3, 30)
        player:printToPlayer(
            string.format('[Synergy: Astral Rage] Blood pact amplified! (Avatar MAB +30, ATK +20, MP +%d)', 40 + (tier * 15)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'SMN: Abilities boost avatar damage and restore MP.',
}

-- "Astral Harvest" - Avatar kills grant free perpetuation and full TP
db.combo_astral_harvest =
{
    name        = 'Astral Harvest',
    type        = 'on_kill',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.SMN and player:hasPet()
    end,
    effect      = function(player, mob, template, tier)
        -- Major MP restore + refresh
        local mpRestore = 100 + (tier * 40)
        player:addMP(mpRestore)
        player:addStatusEffect(xi.effect.REFRESH, 5, 3, 60)
        -- Perpetuation reduction
        player:addMod(xi.mod.PERPETUATION_REDUCTION, 5)
        player:timer(60000, function(p)
            p:delMod(xi.mod.PERPETUATION_REDUCTION, 5)
        end)
        player:printToPlayer(
            string.format('[Synergy: Astral Harvest] Astral energy floods in! (MP +%d, Refresh 60s, Perp -5)', mpRestore),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'SMN: Kills grant massive MP, Refresh, and reduced perpetuation.',
}

-- "Astral Strike" - SMN WS boosts avatar too
db.combo_astral_strike_ws =
{
    name        = 'Astral Strike',
    type        = 'on_ws',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.SMN and player:hasPet()
    end,
    effect      = function(player, mob, template, tier, wsid)
        -- Avatar gets power burst
        player:addPetMod(xi.mod.PET_MAB_MDB, 20)
        player:addPetMod(xi.mod.PET_ATK_DEF, 15)
        player:timer(15000, function(p)
            p:delPetMod(xi.mod.PET_MAB_MDB, 20)
            p:delPetMod(xi.mod.PET_ATK_DEF, 15)
        end)
        -- MP on WS
        player:addMP(30 + (tier * 10))
        player:printToPlayer(
            string.format('[Synergy: Astral Strike] Your avatar echoes your strike! (Avatar MAB +20, ATK +15, MP +%d)', 30 + (tier * 10)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'SMN: WS empowers avatar and restores MP.',
}

-- Astral Ring + SMN: "Cosmic Conduit" - Extra perp reduction + avatar power
db.ability_astral_ring_smn =
{
    itemId      = 13579,    -- Astral Ring
    slot        = xi.slot.RING1,
    name        = 'Cosmic Conduit',
    type        = 'on_engage',
    condition   = function(player, mob, template, tier)
        return player:getMainJob() == xi.job.SMN and player:hasPet()
    end,
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.PERPETUATION_REDUCTION, 5)
        player:addPetMod(xi.mod.PET_MAB_MDB, 20)
        player:addPetMod(xi.mod.PET_MACC_MEVA, 15)
        player:addStatusEffect(xi.effect.REFRESH, 5, 3, 300)
        player:printToPlayer(
            '[Synergy: Cosmic Conduit] The Astral Ring channels cosmic energy! (Perp -5, Avatar MAB +20, Refresh +5)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Astral Ring + SMN: Major perpetuation reduction and avatar power.',
}

-----------------------------------
-- DRAGOON WYVERN SYNERGIES
-- Wyverns become fearsome battle partners in dynamic world
-----------------------------------

-- "Dragon Bond" - DRG with wyvern out gets wyvern + self buffs
db.combo_dragon_bond =
{
    name        = 'Dragon Bond',
    type        = 'on_engage',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.DRG and player:hasPet()
    end,
    effect      = function(player, mob, template, tier)
        -- Wyvern gets huge stat boost
        player:addPetMod(xi.mod.PET_ATK_DEF, 35 + (tier * 12))
        player:addPetMod(xi.mod.PET_ACC_EVA, 25 + (tier * 10))
        player:addPetMod(xi.mod.PET_ATTR_BONUS, 10 + (tier * 5))
        -- Master gets Jump-related bonuses
        player:addMod(xi.mod.ATT, 15)
        player:addMod(xi.mod.ACC, 15)
        player:addStatusEffect(xi.effect.REGEN, 5 + tier * 2, 3, 300)
        player:printToPlayer(
            string.format('[Synergy: Dragon Bond] Your wyvern roars with power! (Wyvern ATK/DEF +%d, Master ATT/ACC +15, Regen)',
                35 + (tier * 12)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'DRG with wyvern: massive wyvern buffs, master ATT/ACC, and Regen.',
}

-- "Dragon Dive" - DRG WS empowers wyvern and grants TP back
db.combo_dragon_dive_ws =
{
    name        = 'Dragon Dive',
    type        = 'on_ws',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.DRG and player:hasPet()
    end,
    effect      = function(player, mob, template, tier, wsid)
        -- Wyvern gets TP burst
        player:addPetMod(xi.mod.PET_TP_BONUS, 250)
        player:addPetMod(xi.mod.PET_ATK_DEF, 20)
        player:timer(10000, function(p)
            p:delPetMod(xi.mod.PET_TP_BONUS, 250)
            p:delPetMod(xi.mod.PET_ATK_DEF, 20)
        end)
        -- Heal wyvern and master on WS
        local pet = player:getPet()
        if pet then
            pet:addHP(80 + (tier * 40))
        end
        player:addHP(60 + (tier * 25))
        player:addTP(30)
        player:printToPlayer(
            string.format('[Synergy: Dragon Dive] You and your wyvern strike as one! (Wyvern TP +250, both healed)'),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'DRG: WS boosts wyvern TP and heals both.',
}

-- "Dragon Spirit" - DRG abilities enhance wyvern + grant jumps power
db.combo_dragon_spirit_ability =
{
    name        = 'Dragon Spirit',
    type        = 'on_ability',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.DRG and player:hasPet()
    end,
    effect      = function(player, mob, template, tier, abilityId)
        -- Wyvern power burst
        player:addPetMod(xi.mod.PET_ATK_DEF, 30)
        player:addPetMod(xi.mod.PET_ACC_EVA, 20)
        player:timer(30000, function(p)
            p:delPetMod(xi.mod.PET_ATK_DEF, 30)
            p:delPetMod(xi.mod.PET_ACC_EVA, 20)
        end)
        -- Heal wyvern on ability use
        local pet = player:getPet()
        if pet then
            pet:addHP(100 + (tier * 30))
        end
        -- Master gets STR + ATT for the ability
        player:addMod(xi.mod.STR, 10)
        player:addMod(xi.mod.ATT, 15)
        player:timer(30000, function(p)
            p:delMod(xi.mod.STR, 10)
            p:delMod(xi.mod.ATT, 15)
        end)
        player:printToPlayer(
            '[Synergy: Dragon Spirit] The dragon spirit empowers you both! (Wyvern ATK +30, Master STR +10, ATT +15)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'DRG: Abilities empower wyvern and grant master offensive buffs.',
}

-- "Dragon Harvest" - DRG kills heal wyvern and grant Regain
db.combo_dragon_harvest =
{
    name        = 'Dragon Harvest',
    type        = 'on_kill',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.DRG and player:hasPet()
    end,
    effect      = function(player, mob, template, tier)
        -- Full heal wyvern on kill
        local pet = player:getPet()
        if pet then
            pet:addHP(pet:getMaxHP())
        end
        -- Master gets TP + Regain
        player:addTP(100)
        player:addHP(80 + (tier * 30))
        player:addStatusEffect(xi.effect.REGAIN, 15, 3, 30)
        player:printToPlayer(
            string.format('[Synergy: Dragon Harvest] Victory invigorates dragon and rider! (Wyvern full heal, TP +100, HP +%d, Regain)', 80 + (tier * 30)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'DRG: Kills fully heal wyvern and grant master TP + Regain.',
}

-- "Dragon Spell" - DRG casting also empowers wyvern breath
db.combo_dragon_spell =
{
    name        = 'Dragon Spell',
    type        = 'on_spell',
    isCombo     = true,
    comboCheck  = function(player)
        return player:getMainJob() == xi.job.DRG and player:hasPet()
    end,
    effect      = function(player, mob, template, tier, spellId)
        -- Wyvern MAB/MDB boost for breath attacks
        player:addPetMod(xi.mod.PET_MAB_MDB, 20)
        player:timer(30000, function(p)
            p:delPetMod(xi.mod.PET_MAB_MDB, 20)
        end)
        -- Heal wyvern
        local pet = player:getPet()
        if pet then
            pet:addHP(50 + (tier * 15))
        end
        player:printToPlayer(
            '[Synergy: Dragon Spell] Your magic fuels your wyvern\'s breath! (Wyvern MAB +20, Wyvern healed)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'DRG: Spells boost wyvern magic power and heal the wyvern.',
}

-----------------------------------
-- PET JOB COMBO SYNERGIES (cross-class)
-- Any pet job fighting in dynamic world gets baseline bonuses
-----------------------------------

-- "Pet Master" - Any player with a pet gets bonuses (BST/SMN/DRG/PUP)
db.combo_pet_master =
{
    name        = 'Pet Master',
    type        = 'on_engage',
    isCombo     = true,
    comboCheck  = function(player)
        return player:hasPet()
    end,
    effect      = function(player, mob, template, tier)
        -- Baseline pet buffs for anyone with a pet
        player:addPetMod(xi.mod.PET_ATK_DEF, 15)
        player:addPetMod(xi.mod.PET_ACC_EVA, 10)
        player:printToPlayer(
            '[Synergy: Pet Master] Your companion is empowered! (Pet ATK/DEF +15, ACC/EVA +10)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Any player with a pet: baseline pet stat buffs on engage.',
}

-- "Pet Protector" - Pet owner kills heal the pet
db.combo_pet_protector =
{
    name        = 'Pet Protector',
    type        = 'on_kill',
    isCombo     = true,
    comboCheck  = function(player)
        return player:hasPet()
    end,
    effect      = function(player, mob, template, tier)
        local pet = player:getPet()
        if pet then
            local heal = 50 + (tier * 25)
            pet:addHP(heal)
            player:printToPlayer(
                string.format('[Synergy: Pet Protector] Your companion recovers! (Pet HP +%d)', heal),
                xi.msg.channel.SYSTEM_3
            )
        end
    end,
    description = 'Any player with a pet: kills heal the pet.',
}

-----------------------------------
-- SOLO-FOCUSED COMBO SYNERGIES
-- These reward players who gear specifically for dynamic world
-----------------------------------

-- "Lone Wolf" - Solo player (no party) gets stat bonuses
db.combo_lone_wolf =
{
    name        = 'Lone Wolf',
    type        = 'on_engage',
    isCombo     = true,
    comboCheck  = function(player)
        local party = player:getParty()
        return not party or #party <= 1
    end,
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.ATT, 20)
        player:addMod(xi.mod.DEF, 20)
        player:addMod(xi.mod.EVA, 15)
        player:addStatusEffect(xi.effect.REGEN, 5, 3, 300)
        player:addStatusEffect(xi.effect.REFRESH, 2, 3, 300)
        player:printToPlayer(
            '[Synergy: Lone Wolf] Fighting alone sharpens your senses! (ATT/DEF +20, EVA +15, Regen, Refresh)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Solo players (no party) gain ATT, DEF, EVA, Regen, and Refresh vs dynamic mobs.',
}

-- "Lone Wolf WS" - Solo player WS heals
db.combo_lone_wolf_ws =
{
    name        = 'Lone Wolf Strike',
    type        = 'on_ws',
    isCombo     = true,
    comboCheck  = function(player)
        local party = player:getParty()
        return not party or #party <= 1
    end,
    effect      = function(player, mob, template, tier, wsid)
        local drain = 30 + (tier * 20)
        player:addHP(drain)
        player:addTP(20)
        player:printToPlayer(
            string.format('[Synergy: Lone Wolf Strike] Self-reliance! (HP +%d, TP +20 on WS)', drain),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Solo players: weapon skills heal and grant bonus TP.',
}

-- "Lone Wolf Cast" - Solo player spells restore HP
db.combo_lone_wolf_spell =
{
    name        = 'Lone Wolf Cast',
    type        = 'on_spell',
    isCombo     = true,
    comboCheck  = function(player)
        local party = player:getParty()
        return not party or #party <= 1
    end,
    effect      = function(player, mob, template, tier, spellId)
        player:addHP(20 + (tier * 10))
        player:printToPlayer(
            string.format('[Synergy: Lone Wolf Cast] Solo magic sustains! (HP +%d on cast)', 20 + (tier * 10)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Solo players: spells restore small HP (mage sustain).',
}

-- "Lone Wolf Ability" - Solo player abilities grant defensive buffs
db.combo_lone_wolf_ability =
{
    name        = 'Lone Wolf Ability',
    type        = 'on_ability',
    isCombo     = true,
    comboCheck  = function(player)
        local party = player:getParty()
        return not party or #party <= 1
    end,
    effect      = function(player, mob, template, tier, abilityId)
        player:addHP(40 + (tier * 15))
        player:addStatusEffect(xi.effect.STONESKIN, 50, 0, 30)
        player:printToPlayer(
            string.format('[Synergy: Lone Wolf Ability] Self-sufficient! (HP +%d, Stoneskin 50 for 30s)', 40 + (tier * 15)),
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Solo players: abilities restore HP and grant Stoneskin.',
}

-- "Apex Hunter" - Fighting apex mobs grants major buffs
db.combo_apex_hunter =
{
    name        = 'Apex Hunter',
    type        = 'on_engage',
    isCombo     = true,
    comboCheck  = function(player)
        -- Always check; condition handles tier
        return true
    end,
    condition   = function(player, mob, template, tier)
        return tier >= xi.dynamicWorld.tier.APEX
    end,
    effect      = function(player, mob, template, tier)
        player:addMod(xi.mod.ATT, 30)
        player:addMod(xi.mod.DEF, 30)
        player:addMod(xi.mod.MATT, 20)
        player:addMod(xi.mod.MDEF, 20)
        player:addStatusEffect(xi.effect.REGEN, 10, 3, 300)
        player:addStatusEffect(xi.effect.REFRESH, 3, 3, 300)
        player:addStatusEffect(xi.effect.RERAISE, 1, 0, 600)
        player:printToPlayer(
            '[Synergy: Apex Hunter] The ultimate prey demands your best! (Major stat buffs, Regen, Refresh, Reraise)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Fighting Apex mobs grants major stat buffs, Regen, Refresh, and Reraise.',
}

-- "Revenge Fighter" - Fighting revenge spawn mobs gives scaling bonuses
db.combo_revenge_fighter =
{
    name        = 'Revenge Fighter',
    type        = 'on_ws',
    isCombo     = true,
    comboCheck  = function(player)
        return true
    end,
    condition   = function(player, mob, template, tier)
        -- Revenge mobs have modified names with Jr/Sr/Big/Patriarch/Legendary
        local name = mob:getName() or ''
        return string.find(name, 'Jr%.') or string.find(name, 'Sr%.') or
               string.find(name, 'Big ') or string.find(name, 'Patriarch') or
               string.find(name, 'Legendary')
    end,
    effect      = function(player, mob, template, tier, wsid)
        player:addHP(50)
        player:addTP(30)
        player:addMP(20)
        player:printToPlayer(
            '[Synergy: Revenge Fighter] Vengeance fuels you! (HP +50, TP +30, MP +20 on WS)',
            xi.msg.channel.SYSTEM_3
        )
    end,
    description = 'Fighting revenge spawns: WS restores HP, TP, and MP.',
}

-----------------------------------
-- Synergy Evaluation Functions
-----------------------------------

-- Called when a player kills a dynamic world mob
synergies.onDynamicKill = function(mob, player, template, tier)
    if not xi.settings.dynamicworld.SYNERGIES_ENABLED then
        return
    end

    for key, synergy in pairs(db) do
        if synergy.type == 'on_kill' then
            local active = false

            if synergy.isCombo then
                active = synergy.comboCheck and synergy.comboCheck(player)
            elseif synergy.itemId and synergy.slot then
                active = player:getEquipID(synergy.slot) == synergy.itemId
            end

            if active then
                if not synergy.condition or synergy.condition(player, mob, template, tier) then
                    synergy.effect(player, mob, template, tier)
                end
            end
        end
    end
end

-- Called when a player engages a dynamic world mob
synergies.onDynamicEngage = function(mob, player, template, tier)
    if not xi.settings.dynamicworld.SYNERGIES_ENABLED then
        return
    end

    local activeSynergies = {}

    for key, synergy in pairs(db) do
        if synergy.type == 'on_engage' then
            local active = false

            if synergy.isCombo then
                active = synergy.comboCheck and synergy.comboCheck(player)
            elseif synergy.itemId and synergy.slot then
                active = player:getEquipID(synergy.slot) == synergy.itemId
            end

            if active then
                if not synergy.condition or synergy.condition(player, mob, template, tier) then
                    synergy.effect(player, mob, template, tier)
                    table.insert(activeSynergies, key)
                end
            end
        end
    end

    return activeSynergies
end

-- Called when player enters a zone with dynamic entities (passive synergies)
synergies.onZoneIn = function(player, zoneId)
    if not xi.settings.dynamicworld.SYNERGIES_ENABLED then
        return
    end

    local state = xi.dynamicWorld.state
    local zd = state.zoneData[zoneId]
    if not zd then
        return
    end

    for key, synergy in pairs(db) do
        if synergy.type == 'passive' then
            local active = false

            if synergy.isCombo then
                active = synergy.comboCheck and synergy.comboCheck(player)
            elseif synergy.itemId and synergy.slot then
                active = player:getEquipID(synergy.slot) == synergy.itemId
            end

            if active then
                for _, entData in pairs(zd.entities) do
                    local tmpl = xi.dynamicWorld.templates.get(entData.templateKey)
                    if tmpl then
                        if not synergy.condition or synergy.condition(player, nil, tmpl, entData.tier) then
                            synergy.effect(player, nil, tmpl, entData.tier)
                        end
                    end
                end
            end
        end
    end
end

-- Called when a player uses a weapon skill on a dynamic world mob
synergies.onDynamicWeaponSkill = function(player, mob, template, tier, wsid)
    if not xi.settings.dynamicworld.SYNERGIES_ENABLED then
        return
    end

    for key, synergy in pairs(db) do
        if synergy.type == 'on_ws' then
            local active = false

            if synergy.isCombo then
                active = synergy.comboCheck and synergy.comboCheck(player)
            elseif synergy.itemId and synergy.slot then
                active = player:getEquipID(synergy.slot) == synergy.itemId
            end

            if active then
                if not synergy.condition or synergy.condition(player, mob, template, tier) then
                    synergy.effect(player, mob, template, tier, wsid)
                end
            end
        end
    end
end

-- Called when a player casts a spell on/near a dynamic world mob
synergies.onDynamicSpellCast = function(player, mob, template, tier, spellId)
    if not xi.settings.dynamicworld.SYNERGIES_ENABLED then
        return
    end

    for key, synergy in pairs(db) do
        if synergy.type == 'on_spell' then
            local active = false

            if synergy.isCombo then
                active = synergy.comboCheck and synergy.comboCheck(player)
            elseif synergy.itemId and synergy.slot then
                active = player:getEquipID(synergy.slot) == synergy.itemId
            end

            if active then
                if not synergy.condition or synergy.condition(player, mob, template, tier, spellId) then
                    synergy.effect(player, mob, template, tier, spellId)
                end
            end
        end
    end
end

-- Called when a player uses a job ability near a dynamic world mob
synergies.onDynamicAbility = function(player, mob, template, tier, abilityId)
    if not xi.settings.dynamicworld.SYNERGIES_ENABLED then
        return
    end

    for key, synergy in pairs(db) do
        if synergy.type == 'on_ability' then
            local active = false

            if synergy.isCombo then
                active = synergy.comboCheck and synergy.comboCheck(player)
            elseif synergy.itemId and synergy.slot then
                active = player:getEquipID(synergy.slot) == synergy.itemId
            end

            if active then
                if not synergy.condition or synergy.condition(player, mob, template, tier) then
                    synergy.effect(player, mob, template, tier, abilityId)
                end
            end
        end
    end
end

-- List all synergies (for GM display)
synergies.list = function()
    local results = {}
    for key, synergy in pairs(db) do
        table.insert(results, {
            key         = key,
            name        = synergy.name,
            type        = synergy.type,
            isCombo     = synergy.isCombo or false,
            description = synergy.description,
        })
    end
    return results
end
