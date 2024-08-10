
            local variant = Tracker.ActiveVariantUID

Tracker:AddItems("items/items.json")
Tracker:AddItems("items/locationobjects.json")
Tracker:AddItems("items/options.json")


-- Logic
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Maps
if Tracker.ActiveVariantUID == "maps-u" then
    Tracker:AddMaps("maps/maps-u.json")  
else
    Tracker:AddMaps("maps/maps.json")  
end  


-- Layout
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tabs.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/tracker.json")

-- Locations
Tracker:AddLocations("locations/Regions.json")
Tracker:AddLocations("locations/Anodyne.json")
Tracker:AddLocations("locations/Submaps.json")
Tracker:AddLocations("locations/PositionAuto.json")

-- AutoTracking for Poptracker
if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/autotracking.lua")

end
