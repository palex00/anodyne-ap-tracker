function get_slot_options(slot_data)

    if slot_data["vanilla_red_cave"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_redcave')
		local setting = slot_data["vanilla_red_cave"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	end

    if slot_data["vanilla_health_cicadas"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_cicada')
		local setting = slot_data["vanilla_health_cicadas"]
		if setting == true then
			obj.CurrentStage = 0
		else
			obj.CurrentStage = 1
		end
	end
	
    if slot_data["randomize_color_puzzle"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_puzzle')
		local setting = slot_data["randomize_color_puzzle"]
		if setting == true then
			obj.CurrentStage = 0
		else
			obj.CurrentStage = 1
		end
	end

    if slot_data["split_windmill"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_windmill')
		local setting = slot_data["split_windmill"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	end

    if slot_data["forest_bunny_chest"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_bunny')
		local setting = slot_data["forest_bunny_chest"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	end

    if slot_data["endgame_card_requirement"] ~= nil then
		Tracker:FindObjectForCode('opt_endgamecardreq').AcquiredCount = slot_data["endgame_card_requirement"]
	end

    if slot_data["nexus_gate_shuffle"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_nexus")
		local stage = slot_data["nexus_gate_shuffle"]
		if stage >= 2 then
			stage = 2
		end
		if obj then
			obj.CurrentStage = stage
		end
	end

    if slot_data["victory_condition"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_goal')
		local setting = slot_data["victory_condition"]
		if setting == 1 then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	end

    if slot_data["shuffle_big_gates"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_bigkey")
		local stage = slot_data["shuffle_big_gates"]
		if stage >= 2 then
			stage = 2
		end
		if obj then
			obj.CurrentStage = stage
		end
	end
	
    if slot_data["shuffle_small_keys"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_smallkey")
		local stage = slot_data["shuffle_small_keys"]
		if stage >= 2 then
			stage = 2
		end
		if obj then
			obj.CurrentStage = stage
		end
	end
	
    if slot_data["unlock_gates"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_smallkey")
		local stage = slot_data["unlock_gates"]
		if stage == true then
			obj.CurrentStage = 1
		end
		if stage == false then
			obj.CurrentStage = 2
		end
	end

    if slot_data["postgame_mode"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_postgame")
		local stage = slot_data["postgame_mode"]
		if stage >= 3 then
			stage = 3
		end
		if obj then
			obj.CurrentStage = stage
		end
	end
	
if slot_data["nexus_gates_unlocked"] ~= nil then
    local nexus_gates_mapping = {
        ["Apartment floor 1"] = "nexus_apartment",
        ["Beach"] = "nexus_beach",
        ["Bedroom exit"] = "nexus_templeoftheseeingone",
        ["Blue"] = "nexus_blue",
        ["Cell"] = "nexus_cell",
        ["Circus"] = "nexus_circus",
        ["Cliff"] = "nexus_cliffs",
        ["Crowd exit"] = "nexus_mountaincavern",
        ["Fields"] = "nexus_fields",
        ["Forest"] = "nexus_deepforest",
        ["Go bottom"] = "nexus_go",
        ["Happy"] = "nexus_happy",
        ["Hotel floor 4"] = "nexus_hotel",
        ["Overworld"] = "nexus_overworld",
        ["Red Cave exit"] = "nexus_redcave",
        ["Red Sea"] = "nexus_redsea",
        ["Suburb"] = "nexus_youngtown",
        ["Space"] = "nexus_space",
        ["Terminal"] = "nexus_terminal",
        ["Windmill entrance"] = "nexus_windmill"
    }

    for _, key in ipairs(slot_data["nexus_gates_unlocked"]) do
        local obj_code = nexus_gates_mapping[key]
        if obj_code then
            local obj = Tracker:FindObjectForCode(obj_code)
            if obj then
                obj.Active = true
            end
        end
    end
end

if slot_data["nexus_gates_unlocked"] ~= nil then
    local nexus_gates_mapping = {
        ["Apartment floor 1"] = "NexusGate(apartment)",
        ["Beach"] = "NexusGate(beach)",
        ["Bedroom exit"] = "NexusGate(templeoftheseeingone)",
        ["Blue"] = "NexusGate(blue)",
        ["Cell"] = "NexusGate(cell)",
        ["Circus"] = "NexusGate(circus)",
        ["Cliff"] = "NexusGate(cliffs)",
        ["Crowd exit"] = "NexusGate(mountaincavern)",
        ["Fields"] = "NexusGate(fields)",
        ["Forest"] = "NexusGate(deepforest)",
        ["Go bottom"] = "NexusGate(go)",
        ["Happy"] = "NexusGate(happy)",
        ["Hotel floor 4"] = "NexusGate(hotel)",
        ["Overworld"] = "NexusGate(overworld)",
        ["Red Cave exit"] = "NexusGate(redcave)",
        ["Red Sea"] = "NexusGate(redsea)",
        ["Suburb"] = "NexusGate(youngtown)",
        ["Space"] = "NexusGate(space)",
        ["Terminal"] = "NexusGate(terminal)",
        ["Windmill entrance"] = "NexusGate(windmill)"
    }

    for _, key in ipairs(slot_data["nexus_gates_unlocked"]) do
        local obj_code = nexus_gates_mapping[key]
        if obj_code then
            local obj = Tracker:FindObjectForCode(obj_code)
            if obj then
                obj.Active = true
            end
        end
    end
end

end
