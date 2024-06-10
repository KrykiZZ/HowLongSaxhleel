local saxhleelSetIds = {
    585, -- Saxhleel
    589, -- Perfected Saxhleel
}

local twoHandedWeaponTypes = { 
    WEAPONTYPE_FIRE_STAFF, --12
    WEAPONTYPE_FROST_STAFF,  --13
    WEAPONTYPE_LIGHTNING_STAFF, --15
    WEAPONTYPE_HEALING_STAFF, --9
    WEAPONTYPE_BOW, --8
    WEAPONTYPE_TWO_HANDED_AXE, --5
    WEAPONTYPE_TWO_HANDED_HAMMER, --6
    WEAPONTYPE_TWO_HANDED_SWORD, --4
}

local armorSlots = {
    EQUIP_SLOT_HEAD,        --0
    EQUIP_SLOT_NECK,        --1
    EQUIP_SLOT_CHEST,       --2
    EQUIP_SLOT_SHOULDERS,   --3
    EQUIP_SLOT_WAIST,       --6
    EQUIP_SLOT_LEGS,        --8
    EQUIP_SLOT_FEET,        --9
    EQUIP_SLOT_RING1,       --11
    EQUIP_SLOT_RING2,       --12
    EQUIP_SLOT_HAND,        --16
}

local weaponSlots = {
    [HOTBAR_CATEGORY_PRIMARY] = {
        EQUIP_SLOT_MAIN_HAND,   --4
        EQUIP_SLOT_OFF_HAND,    --5
    },
    [HOTBAR_CATEGORY_BACKUP] = {
        EQUIP_SLOT_BACKUP_MAIN, --20
        EQUIP_SLOT_BACKUP_OFF   --21
    }
}

local function TableContains(table, item)
    for key, value in ipairs(table) do
        if value == item then
            return true
        end
    end

    return false
end

local function GetSetIdBySlotId(slotId)
    local _, _, _, _, _, setId = GetItemLinkSetInfo(GetItemLink(BAG_WORN, slotId))
    return setId
end

function HowLongSaxhleel:IsEquipmentSlot(slotIndex)
    if TableContains(armorSlots, slotIndex) then 
        return true
    elseif TableContains(weaponSlots, slotIndex) then
        return true
    else
        return false
    end
end

function HowLongSaxhleel:GetEquippedPiecesCount(activeHotbar)
    if activeHotbar == nil then activeHotbar = HowLongSaxhleel.activeHotbar end
    local pieces = 0

    -- Armor
    for _, slot in ipairs(armorSlots) do
        local setId = GetSetIdBySlotId(slot)
        if TableContains(saxhleelSetIds, setId) then
            pieces = pieces + 1
        end 
    end
    -- Weapons
    for _, slot in ipairs(weaponSlots[activeHotbar]) do
        local setId = GetSetIdBySlotId(slot)
        if TableContains(saxhleelSetIds, setId) then
            if TableContains(twoHandedWeaponTypes, GetItemWeaponType(BAG_WORN, slot)) then
                pieces = pieces + 2
            else
                pieces = pieces + 1
            end
        end 
    end

    return pieces
end