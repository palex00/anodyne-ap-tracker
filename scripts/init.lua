Tracker.AllowDeferredLogicUpdate = true
local variant = Tracker.ActiveVariantUID

-- Load Mappings
ScriptHost:LoadScript("scripts/autotracking/other_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

-- Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/locationobjects.json")
Tracker:AddItems("items/options.json")
Tracker:AddItems("items/gates.json")

-- Logic
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Maps
Tracker:AddMaps("maps/maps.json")

-- Layout
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/gates.json")
Tracker:AddLayouts("layouts/items_core.json")
Tracker:AddLayouts("layouts/items_settings.json")
Tracker:AddLayouts("layouts/items_key_all.json")
Tracker:AddLayouts("layouts/items_other_all.json")
Tracker:AddLayouts("layouts/tabs.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/tracker.json")

-- Locations
Tracker:AddLocations("locations/Regions.json")
Tracker:AddLocations("locations/Anodyne.json")
Tracker:AddLocations("locations/Submaps.json")
Tracker:AddLocations("locations/PositionAuto.json")
Tracker:AddLocations("locations/Dust.json")

-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")

-- Watch Codes
ScriptHost:AddWatchForCode("SwapableAreas", "Defeated_Briar", swapareatoggle)
ScriptHost:AddWatchForCode("SwapableAreas", "Swap", swapareatoggle)
ScriptHost:AddWatchForCode("SwapableAreas", "ProgressiveSwap", swapareatoggle)
ScriptHost:AddWatchForCode("check_nexus_gates", "opt_nexus", check_nexus_gates)

for _, code in ipairs(LAYOUT_MAPPING) do
    ScriptHost:AddWatchForCode(code, code, toggle_item_grid)
end

for _, code in pairs(NEXUS_MAPPING) do
    ScriptHost:AddWatchForCode("nexus_" .. code, "nexus_" .. code, check_nexus_gates)
end