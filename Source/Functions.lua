local addonName, addon = ...;
local P = "player";

local function isHealthOutsideThreshold()
    local threshold = SmartHideOptions["health"];
    if threshold then
        local hp = UnitHealth(P);
        local maxHP = UnitHealthMax(P);
        local pct = (hp / maxHP) * 100;
        return pct < threshold;
    else
        return false;
    end
end

local function isPowerOutsideThreshold()
    local threshold = SmartHideOptions["power"];
    if threshold then
        local power = UnitPower(P);
        local maxPower = UnitPowerMax(P);
        local pct = (power / maxPower) * 100;
        local powerId, powerType = UnitPowerType(P);
        local doesDecay = addon.decayPowerTypes[powerType];
        return (doesDecay and pct > threshold) or (not doesDecay and pct < threshold);
    else
        return false;
    end
end

local function isMouseOverPlayerFrame()
    local mouseover = SmartHideOptions["mouseover"] and true or false;
    if mouseover and PlayerFrame:IsMouseOver() then
        return true;
    else
        return false;
    end
end

local function showPlayerFrame()
    PlayerFrame:SetAlpha(1);
    if not PlayerFrame:IsMouseEnabled() then
        PlayerFrame:EnableMouse(true);
    end
end

local function hidePlayerFrame()
    local interactive = SmartHideOptions["interactive"] and true or false;
    if not InCombatLockdown() then
        PlayerFrame:EnableMouse(interactive);
    end
    PlayerFrame:SetAlpha(0);
end

local function shouldShowPlayerFrame()
    -- show player frame if player has a target
    if UnitExists("target") then return true; end

    -- show player frame if player is in combat
    if UnitAffectingCombat(P) then return true; end

    -- show player frame if player health is < 100%
    if isHealthOutsideThreshold() then return true; end

    -- show player frame if player power is < 100% (or > 0 if its a decaying power type, e.g. rage)
    if isPowerOutsideThreshold() then return true; end

    -- show player frame if it is moused over
    if isMouseOverPlayerFrame() then return true; end

    -- otherwise, hide the player frame
    return false;
end

local function reevaluateMouseoverTimer()

    local mouseover = SmartHideOptions["mouseover"] and true or false;

    if mouseover then -- We need a timer

        -- Create one if we don't have one already
        if not addon.mouseoverTimer then
            addon.mouseoverTimer = C_Timer.NewTicker(0.10, function()
                if shouldShowPlayerFrame() then
                    showPlayerFrame();
                else
                    hidePlayerFrame();
                end
            end)
        end

    elseif addon.mouseoverTimer then -- We don't need a timer but already have one - stop it

        addon.mouseoverTimer:Cancel()
        addon.mouseoverTimer = nil

    end
end

addon.togglePlayerFrame = function()
    if shouldShowPlayerFrame() then
        showPlayerFrame();
    else
        hidePlayerFrame();
    end

    reevaluateMouseoverTimer()
end
