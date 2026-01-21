local addonName, addon = ...;

addon.defaults = {
    ["options"] = {
        ["interactive"] = false,
        ["health"] = 100,
        --["power"] = false,
        ["target"] = true,
        ["group"] = false,
        ["ctrl"] = false,
        ["mouseover"] = false
    }
};

addon.helpText = [[
Player Frame Smart Hide commands:
|cffeab517/smarthide help|r - Displays this list of commands
|cffeab517/smarthide settings|r - Displays the currently set option values
|cffeab517/smarthide interactive on|off|r |cffadadad(default: off)|r - Toggle player frame interactivity when hidden.
|cffeab517/smarthide health 1-100|off|r |cffadadad(default: 100)|r - The player health % below which the player frame will be shown.
|cffeab517/smarthide target on|off|r |cffadadad(default: on)|r - Show the player frame when the player has a target.
|cffeab517/smarthide group on|off|r |cffadadad(default: off)|r - Show the player frame when in a group.
|cffeab517/smarthide ctrl on|off|r |cffadadad(default: off)|r - Show the player frame when ctrl is held down.
|cffeab517/smarthide mouseover on|off|r |cffadadad(default: off)|r - Show the player frame on mouseover.]];
-- |cffeab517/smarthide power 0-100|off|r |cffadadad(default: off)|r - The player power % below which (or above for rage-like power types) the player frame will be shown.

-- https://wow.gamepedia.com/PowerType
-- addon.decayPowerTypes = {
--     ["RAGE"] = true,
--     ["COMBO_POINTS"] = true,
--     ["RUNIC_POWER"] = true,
--     ["SOUL_SHARDS"] = true,
--     ["LUNAR_POWER"] = true,
--     ["HOLY_POWER"] = true,
--     ["MAELSTROM"] = true,
--     ["CHI"] = true,
--     ["INSANITY"] = true,
--     ["ARCANE_CHARGES"] = true,
--     ["FURY"] = true,
--     ["PAIN"] = true
-- };
