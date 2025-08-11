local addonName, addon = ...;

SLASH_SMARTHIDE1 = "/smarthide";

function SlashCmdList.SMARTHIDE(msg, editBox)
    local command, value = strsplit(" ", msg);
    value = value and string.gsub(string.lower(value), "%s+", "") or nil;

    -- set interactive mode
    if command == "interactive" then
        if value == "on" then
            SmartHideOptions["interactive"] = true;
            print("Set interactive mode to |cff9ed4ffON");
        elseif value == "off" then
            SmartHideOptions["interactive"] = false;
            print("Set interactive mode to |cff9ed4ffOFF");
        end
    -- set target mode
    elseif command == "target" then
        if value == "on" then
            SmartHideOptions["target"] = true;
            print("Set target mode to |cff9ed4ffON");
        elseif value == "off" then
            SmartHideOptions["target"] = false;
            print("Set target mode to |cff9ed4ffOFF");
        end
    -- set ctrl modifier mode
    elseif command == "group" then
        if value == "on" then
            SmartHideOptions["group"] = true;
            print("Set group mode to |cff9ed4ffON");
        elseif value == "off" then
            SmartHideOptions["group"] = false;
            print("Set group mode to |cff9ed4ffOFF");
        end
    -- set ctrl modifier mode
    elseif command == "ctrl" then
        if value == "on" then
            SmartHideOptions["ctrl"] = true;
            print("Set ctrl modifier mode to |cff9ed4ffON");
        elseif value == "off" then
            SmartHideOptions["ctrl"] = false;
            print("Set ctrl modifier mode to |cff9ed4ffOFF");
        end
    -- set mouseover mode
    elseif command == "mouseover" then
        if value == "on" then
            SmartHideOptions["mouseover"] = true;
            print("Set mouseover mode to |cff9ed4ffON");
        elseif value == "off" then
            SmartHideOptions["mouseover"] = false;
            print("Set mouseover mode to |cff9ed4ffOFF");
        end
    -- set health threshold
    elseif command == "health" then
        if value == "off" then
            SmartHideOptions["health"] = false;
            print("Show on player health threshold set to |cff9ed4ffOFF");
        else
            value = tonumber(value);
            if value and value >= 0 and value <= 100 then
                SmartHideOptions["health"] = value;
                print("Set player frame to show when player health is below |cff9ed4ff" .. tostring(value) .. "%");
            end
        end
    -- set power threshold
    elseif command == "power" then
        if value == "off" then
            SmartHideOptions["power"] = false;
            print("Show on player power threshold set to |cff9ed4ffOFF");
        else
            value = tonumber(value);
            if value and value >= 0 and value <= 100 then
                SmartHideOptions["power"] = value;
                print("Set player frame to show when player power is below (or above for rage-like types) |cff9ed4ff" .. tostring(value) .. "%");
            end
        end
    -- display current setting values
    elseif command == "settings" then
        print("Player Frame Smart Hide settings:");
        print("Interactive mode: |cff9ed4ff" .. (SmartHideOptions["interactive"] and "ON" or "OFF"));
        print("Target mode: |cff9ed4ff" .. (SmartHideOptions["target"] and "ON" or "OFF"));
        print("Group mode: |cff9ed4ff" .. (SmartHideOptions["group"] and "ON" or "OFF"));
        print("Ctrl modifier mode: |cff9ed4ff" .. (SmartHideOptions["ctrl"] and "ON" or "OFF"));
        print("Mouseover mode: |cff9ed4ff" .. (SmartHideOptions["mouseover"] and "ON" or "OFF"));
        print("Health threshold: |cff9ed4ff" .. (SmartHideOptions["health"] and tostring(SmartHideOptions["health"]) .. "%" or "OFF"));
        print("Power threshold: |cff9ed4ff" .. (SmartHideOptions["power"] and tostring(SmartHideOptions["power"]) .. "%" or "OFF"));
    -- show help text
    else
        print(addon.helpText);
    end

    -- trigger toggle frame logic to make sure new settings are applied
    addon.toggleFrames();
end
