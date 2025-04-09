Tracker.AllowDeferredLogicUpdate = true
local variant = Tracker.ActiveVariantUID

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
Tracker:AddLayouts("layouts/items_key.json")
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
ScriptHost:AddWatchForCode("SwapableAreas", "*", swapareatoggle)
ScriptHost:AddWatchForCode("KeymodeWatch", "opt_smallkey", toggle_keys)