local addonName, addon = ...;
local P = "player";

local additionalFrames = {
    WarlockPowerFrame --TODO: Get names for all "detached power" frames
}

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

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

local function isMouseOverFrame(frame)
    local mouseover = SmartHideOptions["mouseover"] and true or false;
    if frame and mouseover and frame:IsMouseOver() then
        return true;
    else
        return false;
    end
end

local function hasTarget()
    local target = SmartHideOptions["target"] and true or false;
    if target and UnitExists("target") then
        return true;
    else
        return false;
    end
end

local function isInGroup()
    local group = SmartHideOptions["group"] and true or false;
    if group and IsInGroup() then
        return true;
    else
        return false;
    end
end

local function isCtrlHeld()
    local ctrl = SmartHideOptions["ctrl"] and true or false;
    if ctrl and IsControlKeyDown() then
        return true;
    else
        return false;
    end
end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

local function showFrames(frames)
    for _, frame in ipairs(frames) do
        if frame then
            frame:SetAlpha(1);

            if not frame:IsMouseEnabled() then
                frame:EnableMouse(true);
            end
        end
    end
end

local function hideFrames(frames)
    local interactive = SmartHideOptions["interactive"] and true or false;

    for _, frame in ipairs(frames) do
        if frame then
            if not InCombatLockdown() then
                frame:EnableMouse(interactive);
            end

            frame:SetAlpha(0);
        end
    end
end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

local function shouldShowAllFrames()

    -- show if ctrl is held
    if isCtrlHeld() then return true; end

    -- show if in group
    if isInGroup() then return true; end

    -- show if player has a target
    if hasTarget() then return true; end

    -- show if player is in combat
    if UnitAffectingCombat(P) then return true; end

    -- otherwise, hide
    return false;

end

local function shouldShowPlayerFrame()

    -- show if player health is < 100%
    if isHealthOutsideThreshold() then return true; end

    -- show if player power is < 100% (or > 0 if its a decaying power type, e.g. rage)
    if isPowerOutsideThreshold() then return true; end

    -- show if it is moused over
    if isMouseOverFrame(PlayerFrame) then return true; end

    -- otherwise, hide
    return false;

end

local function shouldShowPetFrame()

    -- show if it is moused over
    if isMouseOverFrame(PetFrame) then return true; end

    -- otherwise, hide
    return false;

 end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

local function reevaluateShownFrames()

    if shouldShowAllFrames() then

        showFrames({PlayerFrame});
        showFrames({PetFrame});
        showFrames(additionalFrames);

    else

        if shouldShowPlayerFrame() then
            showFrames({PlayerFrame});
        else
            hideFrames({PlayerFrame});
        end

        if shouldShowPetFrame() then
            showFrames({PetFrame});
        else
            hideFrames({PetFrame});
        end

        hideFrames(additionalFrames);

    end
end

local function reevaluateMouseoverTimer()

    local mouseover = SmartHideOptions["mouseover"] and true or false;

    if mouseover then -- We need a timer

        -- Create one if we don't have one already
        if not addon.mouseoverTimer then
            addon.mouseoverTimer = C_Timer.NewTicker(0.10, function()
                reevaluateShownFrames()
            end)
        end

    elseif addon.mouseoverTimer then -- We don't need a timer but already have one - stop it

        addon.mouseoverTimer:Cancel()
        addon.mouseoverTimer = nil

    end
end

addon.toggleFrames = function()
    reevaluateShownFrames()
    reevaluateMouseoverTimer()
end
