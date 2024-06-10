-- AddOn information.
HowLongSaxhleel = HowLongSaxhleel or {}
HowLongSaxhleel.name = "HowLongSaxhleel"
HowLongSaxhleel.version = "1.0.1"

-- Settings.
HowLongSaxhleel.variables = nil
HowLongSaxhleel.variablesPath = "HowLongSaxhleel_Data"
HowLongSaxhleel.variablesVersion = 1
HowLongSaxhleel.defaults = {
    ["top"] = 600,
    ["left"] = 600,
    ["icon"] = GetItemLinkIcon("|H0:item:173875:362:50:0:0:0:0:0:0:0:0:0:0:0:2048:122:0:0:0:10000:0|h|h"),
    ["isCombatOnly"] = false,
}

-- Runtime data.
HowLongSaxhleel.activeHotbar = nil
HowLongSaxhleel.isEquipped = false
HowLongSaxhleel.ultimatePoints = 0
HowLongSaxhleel.isInCombat = false

local LAM = LibAddonMenu2

function HowLongSaxhleel.OnPowerUpdate(eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax)
    if powerType ~= POWERTYPE_ULTIMATE then return end

    HowLongSaxhleel.ultimatePoints = powerValue
    HowLongSaxhleel:UpdateUI()
end

function HowLongSaxhleel.OnActionSlotsActiveHotbarUpdated(event, isHotbarChanged, shouldUpdateAbilityAssignments, activeHotbar)
    if not isHotbarChanged then return end
    if HowLongSaxhleel.activeHotbar == activeHotbar then return end

    HowLongSaxhleel.activeHotbar    = activeHotbar
    HowLongSaxhleel.isEquipped      = HowLongSaxhleel:GetEquippedPiecesCount(activeHotbar) >= 5
    
    HowLongSaxhleel:UpdateUI()
end

function HowLongSaxhleel.OnInventorySingleSlotUpdate(_, bagId, slotIndex, _, _, _, _, _, _, _, _)
    if bagId ~= BAG_WORN then return end

    HowLongSaxhleel.isEquipped = HowLongSaxhleel:GetEquippedPiecesCount() >= 5
    HowLongSaxhleel:UpdateUI()
end

function HowLongSaxhleel.OnPlayerCombatState(event, combatState)
    HowLongSaxhleel.isInCombat = combatState
    HowLongSaxhleel:UpdateUI()
end

function HowLongSaxhleel:InitializeAddonMenu()
    local panelName = HowLongSaxhleel.name .. "Settings"
    local panel = LAM:RegisterAddonPanel(panelName, {
        type = "panel",
        name = HowLongSaxhleel.name,
        author = "|c8E4DFF@KrykiZZ|r [PC/EU]",
        version = HowLongSaxhleel.version,
        
        website = "https://www.esoui.com/downloads/info3891-HowLongSaxhleel.html",
        feedback = "https://www.esoui.com/portal.php?uid=75826&a=bugreport",
        translation = "https://www.esoui.com/portal.php?uid=75826"
    })
    
    local choices = {}
    for id=173859, 173878 do 
        local icon = GetItemLinkIcon("|H0:item:" .. tostring(id) .. ":362:50:0:0:0:0:0:0:0:0:0:0:0:2048:122:0:0:0:0:0|h|h")
        table.insert(choices, icon)
    end

    LAM:RegisterOptionControls(panelName, {
        {
            type = "checkbox",
            name = SI_CK_SETTINGS_ONLY_IN_COMBAT,
            default = false,
            width = "half",
            getFunc = function() return HowLongSaxhleel.variables.isCombatOnly end,
            setFunc = function(value) 
                HowLongSaxhleel.variables.isCombatOnly = value
                HowLongSaxhleel:UpdateUI()
            end
        },
        {
            type = "iconpicker",
            name = SI_CK_SETTINGS_ICON,
            iconSize = 50,
            default = GetItemLinkIcon("|H0:item:173875:362:50:0:0:0:0:0:0:0:0:0:0:0:2048:122:0:0:0:10000:0|h|h"),
            choices = choices,
            width = "half",
            getFunc = function() return HowLongSaxhleel.variables.icon end,
            setFunc = function(value) 
                HowLongSaxhleel.variables.icon = value
                HowLongSaxhleel:UpdateUI()
            end
        }
    })
end

function HowLongSaxhleel:Initialize()
    -- Create saved variables.
    HowLongSaxhleel.variables = ZO_SavedVars:NewAccountWide(HowLongSaxhleel.variablesPath, HowLongSaxhleel.variablesVersion, nil, HowLongSaxhleel.defaults)

    HowLongSaxhleel:InitializeAddonMenu()

    -- Set initial values.
    HowLongSaxhleel.ultimatePoints, _, _    = GetUnitPower("player", POWERTYPE_ULTIMATE)
    HowLongSaxhleel.activeHotbar            = GetActiveHotbarCategory()
    HowLongSaxhleel.isInCombat              = IsUnitInCombat("player")
    HowLongSaxhleel.isEquipped              = HowLongSaxhleel:GetEquippedPiecesCount(HowLongSaxhleel.hotbarCategory) >= 5

    -- Draw UI.
    HowLongSaxhleel:CreateUI()
    HowLongSaxhleel:UpdateUI()

    HUD_UI_SCENE:AddFragment(HowLongSaxhleel.gui.frag)
    HUD_SCENE:AddFragment(HowLongSaxhleel.gui.frag)

    -- Subscribe to events.
    EVENT_MANAGER:RegisterForEvent(HowLongSaxhleel.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE,        HowLongSaxhleel.OnInventorySingleSlotUpdate)
    EVENT_MANAGER:RegisterForEvent(HowLongSaxhleel.name, EVENT_ACTION_SLOTS_ACTIVE_HOTBAR_UPDATED,  HowLongSaxhleel.OnActionSlotsActiveHotbarUpdated)
    EVENT_MANAGER:RegisterForEvent(HowLongSaxhleel.name, EVENT_POWER_UPDATE,                        HowLongSaxhleel.OnPowerUpdate)
    EVENT_MANAGER:RegisterForEvent(HowLongSaxhleel.name, EVENT_PLAYER_COMBAT_STATE,                 HowLongSaxhleel.OnPlayerCombatState)
end

function HowLongSaxhleel.OnAddonLoaded(event, addonName)
	if addonName ~= HowLongSaxhleel.name then return end

    EVENT_MANAGER:UnregisterForEvent(HowLongSaxhleel.name, EVENT_ADD_ON_LOADED)
	HowLongSaxhleel:Initialize()
end

EVENT_MANAGER:RegisterForEvent(HowLongSaxhleel.name, EVENT_ADD_ON_LOADED, HowLongSaxhleel.OnAddonLoaded)