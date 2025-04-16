function has(item, amount)
    local count = Tracker:ProviderCountForCode(item)
    amount = tonumber(amount)
    if not amount then
        return count > 0
    else
        return count >= amount
    end
end


function cards(AMOUNT)
    AMOUNT = tonumber(AMOUNT)
    local req = AMOUNT
    local count = 0
	local count = Tracker:FindObjectForCode("cards").AcquiredCount
    return count >= req
end


function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end


function pad_location(STRING)
    if STRING == "happy" or STRING == "blue" or STRING == "go" then
        if has("opt_nexus_nopost") then
            return false
        end
    end
    return Tracker:FindObjectForCode("nexus_" .. STRING).Active == false and Tracker:FindObjectForCode("opt_nexus").CurrentStage ~= 0
end


function check_nexus_gates()
    if has("opt_nexus_vanilla") then
        for _, code in pairs(NEXUS_MAPPING) do
            Tracker:FindObjectForCode("NexusGate(" .. code .. ")").CurrentStage = 0
        end
    else
        for _, code in pairs(NEXUS_MAPPING) do
            if code == "blue" or code == "happy" or code == "go" then
                if has("opt_nexus_nopost") then
                    Tracker:FindObjectForCode("NexusGate(happy)").CurrentStage = 0
                    Tracker:FindObjectForCode("NexusGate(blue)").CurrentStage = 0
                    Tracker:FindObjectForCode("NexusGate(go)").CurrentStage = 0
                    goto continue
                end
            end
    
            local result = Tracker:FindObjectForCode("nexus_" .. code).Active
            if result == true then
                Tracker:FindObjectForCode("NexusGate(" .. code .. ")").CurrentStage = 1
            else
                Tracker:FindObjectForCode("NexusGate(" .. code .. ")").CurrentStage = 2
            end
    
            ::continue::
        end
    end
end


function pad_access(STRING)
    print(Tracker:FindObjectForCode("NexusGate(" .. STRING .. ")").Active)
    return Tracker:FindObjectForCode("nexus_" .. STRING).Active or Tracker:FindObjectForCode("NexusGate(" .. STRING .. ")").Active
end


function postgame_visibility()
	return Tracker:FindObjectForCode("opt_postgame").CurrentStage ~= 0
end


function post_swap()
	return (Tracker:FindObjectForCode("opt_postgame").CurrentStage == 1 and has("Swap") and has("Defeated_Briar"))
	or (Tracker:FindObjectForCode("opt_postgame").CurrentStage == 2 and has("Swap"))
	or (Tracker:FindObjectForCode("opt_postgame").CurrentStage == 3 and Tracker:FindObjectForCode("ProgressiveSwap").CurrentStage == 2)
end


function pre_swap()
    return has("Swap") or has("ProgressiveSwap")
end


function jump()
	return has("JumpShoes")
end


function combat()
	return has("Broom") or has("Widen") or has("Extend")
end


function smallkey(WHERE,AMOUNT)
    AMOUNT = tonumber(AMOUNT)
    local count = Tracker:ProviderCountForCode("SmallKey("..WHERE..")")

	return Tracker:FindObjectForCode("opt_smallkey").CurrentStage == 1
	or count >= AMOUNT
	or (Tracker:FindObjectForCode("opt_smallkey").CurrentStage == 3 and has("keyring("..WHERE..")"))
end


function redkey()
	return has("Red_Key") or Tracker:FindObjectForCode("opt_bigkey").CurrentStage == 1
end


function bluekey()
	return has("Blue_Key") or Tracker:FindObjectForCode("opt_bigkey").CurrentStage == 1
end


function greenkey()
	return has("Green_Key") or Tracker:FindObjectForCode("opt_bigkey").CurrentStage == 1
end


function templebossaccess()
    if (Tracker:FindObjectForCode("opt_nexus").CurrentStage ~=0 or has("nexus_templeoftheseeingone") or has("nexus_youngtown") or has("nexus_apartment")) then
		return smallkey("templeoftheseeingone", 3)
	else
		return smallkey("templeoftheseeingone", 2)
	end
end


function scoutable()
    return AccessibilityLevel.Inspect
end


function dummy()
	return false
end


function TempleoftheSeeingOneStatue()
   return (has("Opened_Windmill") and has("opt_windmill_vanilla")) or has("TempleoftheSeeingOneStatue")
end


function RedCaveStatue()
   return (has("Opened_Windmill") and has("opt_windmill_vanilla")) or has("RedCaveStatue")
end


function MountainCavernStatue()
   return (has("Opened_Windmill") and has("opt_windmill_vanilla")) or has("MountainCavernStatue")
end


function gate(which)
    -- Retrieve the gate code and its current stage
    local gateCode = "gate_" .. which
    local gateObject = Tracker:FindObjectForCode(gateCode)
    
    if not gateObject then
        return false  -- Return false if the gate object is not found
    end

    local stage = gateObject.CurrentStage
    local countCode = "count_" .. which
    local countValue = Tracker:FindObjectForCode(countCode).AcquiredCount
    local isGreenKey = greenkey
    local isRedKey = redkey
    local isBlueKey = bluekey
    local defeated_bosses = 0

    -- Check the conditions based on the stage
    if stage == 0 then
        return true
    elseif stage == 1 then
        return Tracker:FindObjectForCode("cards").AcquiredCount >= countValue
    elseif stage == 2 then
        return isGreenKey
    elseif stage == 3 then
        return isRedKey
    elseif stage == 4 then
        return isBlueKey
    elseif stage == 5 then
        for _, code in ipairs(BOSSES) do
            local obj = Tracker:FindObjectForCode(code)
            if obj.Active then
                defeated_bosses = defeated_bosses + 1
            end
        end
        return defeated_bosses >= countValue
    else
        return false  -- Return false if the stage is not recognized
    end
end


function hiddenpath()
    if Tracker:FindObjectForCode("opt_hiddenpaths_on").Active or post_swap then
        return AccessibilityLevel.Normal
    elseif Tracker:FindObjectForCode("opt_hiddenpaths_off").Active then
        return AccessibilityLevel.SequenceBreak
    end
    return AccessibilityLevel.None  -- Default return if neither option is active
end


function redcave(amount)
    amount = tonumber(amount)
    local struck_tentacles = 0
    if has("opt_redcave_shuffle") then
        return amount <= Tracker:FindObjectForCode("ProgressiveRedCave").AcquiredCount
    elseif has("opt_redcave_vanilla") then
        for _, code in ipairs(TENTACLES) do
            local obj = Tracker:FindObjectForCode(code)
            if obj.Active then
                struck_tentacles = struck_tentacles + 1
            end
        end
    end
    
    if amount <= 2 then
        return struck_tentacles >= amount
    elseif amount == 3 then
        if struck_tentacles == 4 then
            return true
        end
    end
end