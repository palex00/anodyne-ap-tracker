CARDS = {"Card(Edward)","Card(Annoyer)","Card(Seer)","Card(Shieldy)","Card(Slime)","Card(PewLaser)","Card(Suburbian)","Card(Watcher)","Card(Silverfish)","Card(GasGuy)","Card(Mitra)","Card(Miao)","Card(Windmill)","Card(Mushroom)","Card(Dog)","Card(Rock)","Card(Fisherman)","Card(Walker)","Card(Mover)","Card(Slasher)","Card(Rogue)","Card(Chaser)","Card(FirePillar)","Card(Contorts)","Card(Lion)","Card(ArthurandJaviera)","Card(Frog)","Card(Person)","Card(Wall)","Card(BlueCubeKing)","Card(OrangeCubeKing)","Card(DustMaid)","Card(Dasher)","Card(BurstPlant)","Card(Manager)","Card(Sage)","Card(Young)","Card(CarvedRock)","Card(CityMan)","Card(Intra)","Card(Torch)","Card(TriangleNPC)","Card(Killer)","Card(Goldman)","Card(Broom)","Card(Rank)","Card(Follower)","Card(RockCreature)","Card(Null)"}

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
    return Tracker:FindObjectForCode("nexus_" .. STRING).Active == false and  Tracker:FindObjectForCode("opt_nexus").CurrentStage ~=0
end

function pad_access(STRING)
    return Tracker:FindObjectForCode("nexus_" .. STRING).Active or has("NexusGate(" .. STRING .. ")")
end

function postgame_visibility()
	return Tracker:FindObjectForCode("opt_postgame").CurrentStage ~= 0
end

function post_swap()
	return (Tracker:FindObjectForCode("opt_postgame").CurrentStage == 1 and has("Swap") and has("Briar"))
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

function endgameaccess()
    local count = 0
	local count = Tracker:FindObjectForCode("cards").AcquiredCount
    local endgamereq = Tracker:FindObjectForCode('opt_endgamecardreq').AcquiredCount
    return count >= endgamereq
end

function smallkey(WHERE,AMOUNT)
    AMOUNT = tonumber(AMOUNT)
    local count = Tracker:ProviderCountForCode("SmallKey("..WHERE..")")

	return Tracker:FindObjectForCode("opt_smallkey").CurrentStage == 1
	or count >= AMOUNT
end

function redkey()
	return has("RedKey") or Tracker:FindObjectForCode("opt_bigkey").CurrentStage == 1
end

function bluekey()
	return has("BlueKey") or Tracker:FindObjectForCode("opt_bigkey").CurrentStage == 1
end

function greenkey()
	return has("GreenKey") or Tracker:FindObjectForCode("opt_bigkey").CurrentStage == 1
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
   return (has("statues") and has("opt_windmill_vanilla")) or has("TempleoftheSeeingOneStatue")
end

function RedCaveStatue()
   return (has("statues") and has("opt_windmill_vanilla")) or has("RedCaveStatue")
end

function MountainCavernStatue()
   return (has("statues") and has("opt_windmill_vanilla")) or has("MountainCavernStatue")
end
