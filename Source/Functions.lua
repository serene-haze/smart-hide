local addonName, addon = ...;
local P = "player";

--TODO: Get names for all "detached power" frames
local additionalFrames = {
    EssentialCooldownViewer,
    UtilityCooldownViewer,
    WarlockPowerFrame,
    RuneFrame
}

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

-- UnitHealthPercent is now a secret value so we have to use this method to turn it into an alpha
local function getAlphaForHealthThreshold()
    local threshold = SmartHideOptions["health"];
    if threshold then
        local curve = C_CurveUtil.CreateCurve();
        local scaledThreshold = threshold / 100;
        curve:AddPoint((scaledThreshold - 0.0000001), 1); -- 0.0000001 is the smallest subtracted value that results in different points at every threshold
        curve:AddPoint( scaledThreshold, 0);
        return UnitHealthPercent(P, false, curve);
    else
        return false;
    end
end

-- local function isPowerOutsideThreshold()
--     local threshold = SmartHideOptions["power"];
--     if threshold then
--         local power = UnitPower(P);
--         local maxPower = UnitPowerMax(P);
--         local pct = (power / maxPower) * 100;
--         local powerId, powerType = UnitPowerType(P);
--         local doesDecay = addon.decayPowerTypes[powerType];
--         return (doesDecay and pct > threshold) or (not doesDecay and pct < threshold);
--     else
--         return false;
--     end
-- end

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

local function setFrameParameters(frames, alpha, interactiveEvenWhenHidden)

    for _, frame in ipairs(frames) do
        if frame then
            frame:SetAlpha(alpha);

            if interactiveEvenWhenHidden then
                frame:EnableMouse(true);
            elseif issecretvalue(alpha) then -- EnableMouse does not accept secret values - better to have a click-through frame than an interactable blank space?
                frame:EnableMouse(false);    -- If mouseover mode is enabled for this frame, it will be clickable while the mouse is over it as that provides a non-secret visibility
            else
                frame:EnableMouse(alpha > 0);
            end
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

local function getPlayerFrameSpecificAlpha()

    -- show if player power is < 100% (or > 0 if its a decaying power type, e.g. rage)
    --if isPowerOutsideThreshold() then return 1; end

    -- show if it is moused over
    if isMouseOverFrame(PlayerFrame) then return 1; end

    -- this alpha is secret
    return getAlphaForHealthThreshold();

end

local function getPetFrameSpecificAlpha()

    -- show if it is moused over
    if isMouseOverFrame(PetFrame) then return 1; end

    -- otherwise, hide
    return 0;

 end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

local function startMouseoverTimer()
    -- Create one if we don't have one already
    if not addon.mouseoverTimer then
        addon.mouseoverTimer = C_Timer.NewTicker(0.10, function()
            addon.reevaluateShownFrames();
        end)
    end
end

local function stopMouseoverTimer()
    -- We don't need a timer but already have one - stop it
    if addon.mouseoverTimer then
        addon.mouseoverTimer:Cancel();
        addon.mouseoverTimer = nil;
    end
end

addon.reevaluateShownFrames = function()

    -- We can't change some frame settings (notably the mouse status of the player frame)
    -- during the combat lockdown, but since we always show all frames during combat, we
    -- might as well disable *all* condition checking in combat so as not to waste cycles.
    -- The PLAYER_REGEN_DISABLED event just *before* the lockdown starts will serve to get
    -- all the frames into combat state and the PLAYER_REGEN_ENABLED event just *after* the
    -- lockdown is lifted will get them into whatever state they should be in out of combat.
    --
    if InCombatLockdown() then
        return
    end

    local interactiveEvenWhenHidden = SmartHideOptions["interactive"] and true or false;

    if shouldShowAllFrames() then

        setFrameParameters({PlayerFrame}, 1, interactiveEvenWhenHidden);
        setFrameParameters({PetFrame}, 1, interactiveEvenWhenHidden);
        setFrameParameters(additionalFrames, 1, interactiveEvenWhenHidden);

        stopMouseoverTimer();

    else

        setFrameParameters({PlayerFrame}, getPlayerFrameSpecificAlpha(), interactiveEvenWhenHidden);
        setFrameParameters({PetFrame},    getPetFrameSpecificAlpha(), interactiveEvenWhenHidden);
        setFrameParameters(additionalFrames, 0, interactiveEvenWhenHidden);

        local mouseover = SmartHideOptions["mouseover"] and true or false;
        if mouseover then
            startMouseoverTimer();
        else
            stopMouseoverTimer();
        end

    end
end
