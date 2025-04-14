CUR_INDEX = -1
SLOT_DATA = {}
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}
PLAYER_ID = -1
TEAM_NUMBER = 0

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
    
    PLAYER_ID = Archipelago.PlayerNumber or -1
    TEAM_NUMBER = Archipelago.TeamNumber or 0
    SLOT_DATA = slot_data
    CUR_INDEX = -1


    -- 1. Reset Nexus Gates
    for _, mapped_nexus in pairs(NEXUS_MAPPING) do
        Tracker:FindObjectForCode("nexus_" .. mapped_nexus).Active = false
        Tracker:FindObjectForCode("nexus_" .. mapped_nexus).CurrentStage = 0
    end
    
    
    -- 2. Temporarily removes Watch Codes to prevent mass-updating
    for _, code in ipairs(LAYOUT_MAPPING) do
        ScriptHost:RemoveWatchForCode(code, code)
    end
    
    for _, code in pairs(NEXUS_MAPPING) do
        ScriptHost:RemoveWatchForCode("nexus_" .. code, "nexus_" .. code)
    end
    
    
    -- 3. Reset Options & Process them
    for _, option in ipairs(OPTION_MAPPING) do
        local value = slot_data[option.slotdata]
    
        for _, code in ipairs(option.codes) do
            local obj = Tracker:FindObjectForCode(code)
            if obj ~= nil then
                -- Reset stage
                obj.CurrentStage = 0
    
                -- Apply new stage if value is not nil and type mapping exists
                local mapping_table = _G[option.type]
                if value ~= nil and mapping_table and mapping_table[value] ~= nil then
                    obj.CurrentStage = mapping_table[value]
                end
            end
        end
    end

    
    -- 4. Process Gates
    local keysToProcess = {
        "overworld_gauntlet_gate",
        "terminal_endgame_gate",
        "cell_gate",
        "beach_gauntlet_gate",
        "windmill_top_gate",
        "windmill_entrance_gate",
        "overworld_fields_gate",
        "windmill_middle_gate",
        "blank_postgame_gate",
        "suburb_gate",
        "nexus_north_final_gate",
        "fields_terminal_gate"
    }
    
    -- Iterate over the specified keys
    for _, key in ipairs(keysToProcess) do
        local value = slot_data[key]
    
        -- Check if the key exists in slot_data
        if value ~= nil then
            -- Ensure value is a string for matching
            local valueStr = tostring(value)
    
            -- Remove "_gate" from the key and concatenate the parts
            local codeName = key:gsub("_gate", ""):gsub("_", "")
            local consumableCode = "count_" .. codeName
            local gateCode = "gate_" .. codeName
    
            -- Define valid values for processing
            local validValues = {
                ["unlocked"] = 0,
                ["cards_"] = 1,  -- Default value for cards, will be updated with the number
                ["green_key"] = 2,
                ["red_key"] = 3,
                ["blue_key"] = 4,
                ["bosses_"] = 5  -- Default value for bosses, will be updated with the number
            }
    
            -- Check if the value is valid
            local baseValue, stage
    
            -- Handle cases with numbers (cards_XX, bosses_XX)
            if valueStr:match("cards_") or valueStr:match("bosses_") then
                local number = valueStr:match("%d+$")
                baseValue = valueStr:match("cards_") and "cards_" or "bosses_"
                stage = validValues[baseValue] -- Base value without number
                if number ~= nil then
                    Tracker:FindObjectForCode(consumableCode).AcquiredCount = tonumber(number)
                end
            else
                baseValue = valueStr
                stage = validValues[baseValue]
            end
    
            -- Update the gate code stage if the base value is valid
            if stage ~= nil then
                Tracker:FindObjectForCode(gateCode).CurrentStage = stage
            else
                error("Invalid value for " .. key .. ": " .. valueStr)
            end
        end
    end
    
    
    -- 5. Reset Items & Process Them
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


    -- 6. Reset Locations & Process them
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
    
    
    -- 7. Set Stages for Nexus Gates
    for _, key in ipairs(slot_data["nexus_gates_unlocked"]) do
        local mapped_nexus = NEXUS_MAPPING[key]
        if mapped_nexus then
            if mapped_nexus == "blue" or mapped_nexus == "happy" or mapped_nexus == "go" then
                if not has("opt_nexus_nopost") then
                    local nexus_obj = Tracker:FindObjectForCode("nexus_" .. mapped_nexus)
                    nexus_obj.Active = true
    
                    local gate_obj = Tracker:FindObjectForCode("NexusGate(" .. mapped_nexus .. ")")
                    gate_obj.Active = true
                    gate_obj.CurrentStage = 1
                end
            else
                local nexus_obj = Tracker:FindObjectForCode("nexus_" .. mapped_nexus)
                nexus_obj.Active = true
    
                local gate_obj = Tracker:FindObjectForCode("NexusGate(" .. mapped_nexus .. ")")
                gate_obj.Active = true
                gate_obj.CurrentStage = 1
            end
        end
    end
    
    for _, entry in pairs(NEXUS_MAPPING) do
        if pad_location(entry) == true then
            Tracker:FindObjectForCode("NexusGate(" .. entry .. ")").CurrentStage = 2
        end
    end
    
    
    -- 8. Re-adds the watch codes
    for _, code in ipairs(LAYOUT_MAPPING) do
        ScriptHost:AddWatchForCode(code, code, toggle_item_grid)
    end
    
    for _, code in pairs(NEXUS_MAPPING) do
        ScriptHost:AddWatchForCode("nexus_" .. code, "nexus_" .. code, check_nexus_gates)
    end
    
    
    EVENT_ID = "Slot:" .. PLAYER_ID .. ":EventArray"
    Archipelago:Get({EVENT_ID})
    Archipelago:SetNotify({EVENT_ID})
end

function swapareatoggle()
    if post_swap() == true and not Tracker:FindObjectForCode('swaptoggle').Active then
        Tracker:FindObjectForCode('swapareas').CurrentStage = 1
        Tracker:FindObjectForCode('swaptoggle').Active = true
		ScriptHost:RemoveWatchForCode("SwapableAreas", "Defeated_Briar")
		ScriptHost:RemoveWatchForCode("SwapableAreas", "Swap")
		ScriptHost:RemoveWatchForCode("SwapableAreas", "ProgressiveSwap")
    end
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)

    --if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
    --    print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    --end
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
    --if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
    --    print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    --end
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
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
    --if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
    --    print(string.format("called onLocation: %s, %s", location_id, location_name))
    --end
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

function toggle_item_grid()
    local smallkey = has("opt_smallkey_vanilla") or has("opt_smallkey_shuffle")
    local bigkey = has("opt_bigkey_vanilla") or has("opt_bigkey_shuffle")
    local rings = has("opt_smallkey_keyring")
    
    if smallkey and bigkey and not rings then
        Tracker:AddLayouts("layouts/items_key_all.json")
    elseif smallkey and not bigkey and not rings then
        Tracker:AddLayouts("layouts/items_key_nobig_small.json")
    elseif bigkey and not smallkey and not rings then
        Tracker:AddLayouts("layouts/items_key_big_none.json")
    elseif bigkey and not smallkey and rings then
        Tracker:AddLayouts("layouts/items_key_big_rings.json")
    elseif not bigkey and not smallkey and rings then
        Tracker:AddLayouts("layouts/items_key_nobig_rings.json")
    elseif not bigkey and not smallkey and not rings then
        Tracker:AddLayouts("layouts/items_key_nobig_none.json")
    end
    
    local redcave = has("opt_redcave_shuffle")
    local statues = has("opt_windmill_off")
    local progswap = has("opt_postgame_progressive")
    
    if redcave and statues and progswap then
        Tracker:AddLayouts("layouts/items_other_all_progswap.json")
    elseif redcave and statues and not progswap then
        Tracker:AddLayouts("layouts/items_other_all.json")
    elseif not redcave and statues and progswap then
        Tracker:AddLayouts("layouts/items_other_nocave_progswap.json")
    elseif not redcave and statues and not progswap then
        Tracker:AddLayouts("layouts/items_other_nocave_swap.json")
    elseif not redcave and not statues and progswap then
        Tracker:AddLayouts("layouts/items_other_nostat_nocave_progswap.json")
    elseif not redcave and not statues and not progswap then
        Tracker:AddLayouts("layouts/items_other_nostat_nocave_swap.json")
    elseif redcave and not statues and progswap then
        Tracker:AddLayouts("layouts/items_other_nostat_progswap.json")
    elseif redcave and not statues and not progswap then
        Tracker:AddLayouts("layouts/items_other_nostat_swap.json")
    end
end

function onNotify(key, value, old_value)
    if key == EVENT_ID then
        updateEvents(value)
    end
end

function onNotifyLaunch(key, value)
    if key == EVENT_ID and value ~= nil then
        updateEvents(value)
    end
end

function updateEvents(value)
    -- Reset all mapped event codes
    for _, code in ipairs(EVENT_MAPPING) do
        if (code == "Blue_Key" or code == "Red_Key" or code == "Green_Key") and not has("opt_bigkey_vanilla") then
           goto continue
        end
           
        Tracker:FindObjectForCode(code).Active = false
        
        ::continue::
    end

    -- Set events based on value
    for _, v in ipairs(value) do
        print("Event is: "..v)
        if type(v) == "string" and v:sub(1, 5) == "Nexus" then
            local stripped = v:sub(6)  -- Remove "Nexus" prefix
            if not stripped == "Street" then
                local mapped_value = NEXUS_MAPPING[stripped]  -- Find corresponding mapped value
                local gate_obj = Tracker:FindObjectForCode("NexusGate(" .. mapped_value .. ")")
                gate_obj.Active = true
            end
        else
            local obj = Tracker:FindObjectForCode(v)
            obj.Active = true
        end
    end
end


Archipelago:AddBouncedHandler("bounce handler", onBounce)
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)