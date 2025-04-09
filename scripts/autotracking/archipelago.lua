-- this is an example/ default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via thier ids
-- it will also load the AP slot data in the global SLOT_DATA, keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might

ScriptHost:LoadScript("scripts/autotracking/slot_options.lua")
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = {}
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print("Contents of slot_data:")
        for key, value in pairs(slot_data) do
            print(key, value)
        end
    end

    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
	-- reset settings
	local reset_codes = {
		"opt_smallkey", "opt_cicada", "opt_bigkey", "opt_redcave", "opt_windmill", 
		"opt_nexus", "opt_goal", "opt_endgamecardreq", "opt_postgame", "opt_bunny",
		"nexus_apartment", "nexus_beach", "nexus_templeoftheseeingone", "nexus_blue", 
		"nexus_cell", "nexus_circus", "nexus_cliffs", "nexus_mountaincavern", 
		"nexus_fields", "nexus_deepforest", "nexus_go", "nexus_happy", "nexus_hotel", 
		"nexus_overworld", "nexus_redcave", "nexus_redsea", "nexus_youngtown", 
		"nexus_space", "nexus_terminal", "nexus_windmill", "statues"
	}
	
	for _, code in ipairs(reset_codes) do
		local obj = Tracker:FindObjectForCode(code)
		if obj then
			obj.Active = false
			if code == "opt_endgamecardreq" then
				obj.AcquiredCount = 0
			end
		end
	end

    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            --    print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            --    print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}
    get_slot_options(slot_data)
end

function swapareatoggle()
    if post_swap() == true and not Tracker:FindObjectForCode('swaptoggle').Active then
        Tracker:FindObjectForCode('swapareas').CurrentStage = 1
        Tracker:FindObjectForCode('swaptoggle').Active = true
		ScriptHost:RemoveWatchForCode("SwapableAreas", "*")
    end
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)

    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
        return
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive_toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
    -- track local items via snes interface
    if is_local then
        if LOCAL_ITEMS[v[1]] then
            LOCAL_ITEMS[v[1]] = LOCAL_ITEMS[v[1]] + 1
        else
            LOCAL_ITEMS[v[1]] = 1
        end
    else
        if GLOBAL_ITEMS[v[1]] then
            GLOBAL_ITEMS[v[1]] = GLOBAL_ITEMS[v[1]] + 1
        else
            GLOBAL_ITEMS[v[1]] = 1
        end
    end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end
    if not AUTOTRACKER_ENABLE_LOCATION_TRACKING then
        return
    end
    local v = LOCATION_MAPPING[location_id]
    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v[1] then
        return
    end
	for _, w in ipairs(v) do
		local obj = Tracker:FindObjectForCode(w)
		if obj then
			if w:sub(1, 1) == "@" then
				obj.AvailableChestCount = obj.AvailableChestCount - 1
			elseif obj.Type == "progressive" then
				obj.CurrentStage = obj.CurrentStage + 1
			else
				obj.Active = true
			end
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onLocation: could not find object for code %s", v[1]))
		end
	end
end


-- add AP callbacks
Archipelago:AddClearHandler("clear handler", onClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
    Archipelago:AddItemHandler("item handler", onItem)
end
if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
    Archipelago:AddLocationHandler("location handler", onLocation)
end


-- Auto Tabbing
function onBounce(json)
    local data = json["data"]
    if data then
        if data["type"] == "MapUpdate" then
            updateMap(data["mapName"], data["mapIndex"])
        end
    end
end

local currentCode

function updateMap(mapName, mapIndex)
    local tabName

    -- Convert mapName to corresponding tab name
    if mapName == "NEXUS" then
        tabName = "Overview"
    elseif mapName == "REDSEA" then
        tabName = "RED SEA"
    elseif mapName == "REDCAVE" then
        tabName = "RED CAVE"
    elseif mapName == "CLIFF" then
        tabName = "CLIFFS"
    else
        -- Handle unexpected mapNames or set a default tab name if needed
        tabName = mapName
    end
  
    local newCode = mapName .. "-" .. mapIndex
    local currentObject = currentCode and Tracker:FindObjectForCode(currentCode)
    local newObject = Tracker:FindObjectForCode(newCode)

    -- Deactivate the previously enabled code if it exists and is active
    if currentObject and currentObject.Active then
        currentObject.Active = false
    end
		
    if has("tracking_enabled") then

        -- Activate the new code if it exists
        if newObject then
            newObject.Active = true
        end
        
        -- Update the currently enabled code
        currentCode = newCode

-- Activate the tab based on conditions
if tabName == "Overview" then
    Tracker:UiHint("ActivateTab", tabName)

elseif tabName == "DEBUG" or tabName == "BLANK" or tabName == "DRAWER" then
    Tracker:UiHint("ActivateTab", "Post-Game")
    Tracker:UiHint("ActivateTab", tabName)

elseif tabName == "BEACH" or tabName == "CELL" or tabName == "FIELDS" or tabName == "GO" or 
       tabName == "HOTEL" or tabName == "OVERWORLD" or tabName == "RED SEA" or 
       tabName == "SPACE" or tabName == "STREET" or tabName == "TEMPLE" or 
       tabName == "TOWN" or tabName == "WINDMILL" then

    if Tracker:FindObjectForCode('swapareas').CurrentStage == 1 then
        Tracker:UiHint("ActivateTab", "The Land (Broomed)")
    else
        Tracker:UiHint("ActivateTab", "The Land")
    end
    
    Tracker:UiHint("ActivateTab", tabName)

else
    -- Default behavior: Activate "The Land" and then the tab
    Tracker:UiHint("ActivateTab", "The Land")
    Tracker:UiHint("ActivateTab", tabName)
end


    end
end

function toggle_keys(code)
    if has("opt_smallkey_unlocked") then
        Tracker:AddLayouts("layouts/items_nokey.json")
    elseif has("opt_smallkey_vanilla") or has("opt_smallkey_shuffle") then
        Tracker:AddLayouts("layouts/items_key.json")
    elseif has("opt_smallkey_keyring") then
        Tracker:AddLayouts("layouts/items_keyring.json")
    end
end



Archipelago:AddBouncedHandler("bounce handler", onBounce)
