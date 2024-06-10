local iconSize = 50
local edgeSize = 5
local edgeLine = 2

function HowLongSaxhleel:CreateUI()
    local name = "hlsgui"
    local windowManager = GetWindowManager()
    HowLongSaxhleel.gui = {}
    
    HowLongSaxhleel.gui.window = windowManager:CreateTopLevelWindow(name)
    HowLongSaxhleel.gui.window:SetClampedToScreen(true)
    HowLongSaxhleel.gui.window:SetMouseEnabled(true)
    HowLongSaxhleel.gui.window:SetMovable(true)
    HowLongSaxhleel.gui.window:ClearAnchors()
    HowLongSaxhleel.gui.window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, HowLongSaxhleel.variables.left, HowLongSaxhleel.variables.top)
    HowLongSaxhleel.gui.window:SetHidden(false)
    HowLongSaxhleel.gui.window:SetHandler("OnMoveStop", function()
        HowLongSaxhleel.variables.left = HowLongSaxhleel.gui.window:GetLeft()
        HowLongSaxhleel.variables.top = HowLongSaxhleel.gui.window:GetTop()
    end)

    HowLongSaxhleel.gui.primaryInd = {}
    HowLongSaxhleel.gui.primaryInd.ctrl = windowManager:CreateControl(name .. "PrimaryControl", HowLongSaxhleel.gui.window, CT_CONTROL)
    HowLongSaxhleel.gui.primaryInd.edge = windowManager:CreateControl(name .. "PrimaryEdge", HowLongSaxhleel.gui.primaryInd.ctrl, CT_BACKDROP)
    HowLongSaxhleel.gui.primaryInd.back = windowManager:CreateControl(name .. "PrimaryBackground", HowLongSaxhleel.gui.primaryInd.ctrl, CT_BACKDROP)
    HowLongSaxhleel.gui.primaryInd.icon = windowManager:CreateControl(name .. "PrimaryIcon", HowLongSaxhleel.gui.primaryInd.ctrl, CT_TEXTURE)
    HowLongSaxhleel.gui.primaryInd.label = windowManager:CreateControl(name .. "PrimaryIndicator", HowLongSaxhleel.gui.primaryInd.ctrl, CT_LABEL)

    HowLongSaxhleel.gui.frag = ZO_HUDFadeSceneFragment:New(HowLongSaxhleel.gui.window)

    HowLongSaxhleel.gui.window:SetDimensions(50, 50)
    local primary = HowLongSaxhleel.gui.primaryInd
    
    primary.ctrl:ClearAnchors()
    primary.ctrl:SetAnchor(CENTER, HowLongSaxhleel.gui.window, CENTER, 0, 0)
    primary.ctrl:SetDimensions(iconSize, iconSize)

    primary.edge:ClearAnchors()
    primary.edge:SetAnchor(CENTER, primary.ctrl, CENTER, 0, 0)
    primary.edge:SetDimensions(iconSize + 2 * (edgeSize + edgeLine), iconSize + 2 * (edgeSize + edgeLine))
    primary.edge:SetEdgeColor(0, 0, 0, 1)
    primary.edge:SetCenterColor(0, 0, 0, 0.3)
    primary.edge:SetEdgeTexture(nil, edgeLine, edgeLine, edgeLine)
    primary.edge:SetHidden(false)

    primary.back:ClearAnchors()
    primary.back:SetAnchor(CENTER, primary.ctrl, CENTER, 0, 0)
    primary.back:SetDimensions(iconSize, iconSize)
    primary.back:SetEdgeColor(0, 0, 0, 1)
    primary.back:SetCenterColor(0, 0, 0, 1)
    primary.back:SetEdgeTexture(nil, edgeLine, edgeLine, edgeLine)

    primary.icon:ClearAnchors()
    primary.icon:SetAnchor(CENTER, primary.ctrl, CENTER, 0, 0)
    primary.icon:SetDimensions(iconSize - 2 * edgeLine, iconSize - 2 * edgeLine)
    primary.icon:SetTexture(HowLongSaxhleel.variables.icon)
    primary.icon:SetAlpha(1)

    primary.label:ClearAnchors()
    primary.label:SetAnchor(CENTER, primary.ctrl, CENTER, 0, 0)
    primary.label:SetDimensions(iconSize, iconSize)
    primary.label:SetColor(1, 1, 1, 1)
    primary.label:SetFont("EsoUI/Common/Fonts/Univers57.otf" .. "|" .. math.floor(iconSize * 7 / 10) .. "|soft-shadow-thick")
    primary.label:SetVerticalAlignment(TEXT_ALIGN_CENTER)
    primary.label:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    primary.label:SetText("10")
    primary.label:SetHidden(false)
end

function HowLongSaxhleel:UpdateUI()
    local shouldBeHidden = false
    
    if HowLongSaxhleel.variables.isCombatOnly and not HowLongSaxhleel.isInCombat then shouldBeHidden = true end
    if not HowLongSaxhleel.isEquipped then shouldBeHidden = true end
    
    HowLongSaxhleel.gui.window:SetHidden(shouldBeHidden)
    
    local seconds = 0
    if HowLongSaxhleel.isEquipped then
        seconds = math.floor(HowLongSaxhleel.ultimatePoints / 15)
    end

    HowLongSaxhleel.gui.primaryInd.label:SetText(tostring(seconds))
    HowLongSaxhleel.gui.primaryInd.icon:SetTexture(HowLongSaxhleel.variables.icon)
end