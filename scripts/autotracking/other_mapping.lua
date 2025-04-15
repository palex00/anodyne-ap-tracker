MAP_TOGGLE = {
    [true]  = 1,
    [false] = 0
}
MAP_TOGGLE_REVERSE = {
    [true]  = 0,
    [false] = 1
}
MAP_NUMBER = {
    [0]  = 0,
    [1]  = 1,
    [2]  = 2,
    [3]  = 3,
    [4]  = 4,
    [5]  = 5,
    [6]  = 6,
    [7]  = 7,
    [8]  = 8,
    [9]  = 9,
    [10] = 10,
    [11] = 11,
    [12] = 12,
    [13] = 13,
    [14] = 14,
    [15] = 15,
    [16] = 16,
    [17] = 17,
    [18] = 18,
    [19] = 19,
    [20] = 20,
    [21] = 21,
    [22] = 22,
    [23] = 23,
    [24] = 24,
    [25] = 25,
    [26] = 26,
    [27] = 27,
    [28] = 28,
    [29] = 29,
    [30] = 30,
    [31] = 31,
    [32] = 32,
    [33] = 33,
    [34] = 34,
    [35] = 35,
    [36] = 36,
    [37] = 37,
    [38] = 38,
    [39] = 39,
    [40] = 40,
    [41] = 41,
    [42] = 42,
    [43] = 43,
    [44] = 44,
    [45] = 45,
    [46] = 46,
    [47] = 47,
    [48] = 48,
    [49] = 49
}
MAP_KEY = {
    ["vanilla"] = 0,
    ["unlocked"] = 1,
    ["shuffled"] = 2,
    ["key_ring"] = 3
}

CARDS = {"Card(Edward)","Card(Annoyer)","Card(Seer)","Card(Shieldy)","Card(Slime)","Card(PewLaser)","Card(Suburbian)","Card(Watcher)","Card(Silverfish)","Card(GasGuy)","Card(Mitra)","Card(Miao)","Card(Windmill)","Card(Mushroom)","Card(Dog)","Card(Rock)","Card(Fisherman)","Card(Walker)","Card(Mover)","Card(Slasher)","Card(Rogue)","Card(Chaser)","Card(FirePillar)","Card(Contorts)","Card(Lion)","Card(ArthurandJaviera)","Card(Frog)","Card(Person)","Card(Wall)","Card(BlueCubeKing)","Card(OrangeCubeKing)","Card(DustMaid)","Card(Dasher)","Card(BurstPlant)","Card(Manager)","Card(Sage)","Card(Young)","Card(CarvedRock)","Card(CityMan)","Card(Intra)","Card(Torch)","Card(TriangleNPC)","Card(Killer)","Card(Goldman)","Card(Broom)","Card(Rank)","Card(Follower)","Card(RockCreature)","Card(Null)"}

OPTION_MAPPING = {
-- toggle converts true to 1, false to 0
-- toggle_reverse converts true to 0, false to 1
-- number doesn't convert stuff. 
--  {slotdata="", codes={""}, type=""},
    {slotdata="vanilla_red_cave", codes={"opt_redcave"}, type="MAP_TOGGLE"},
    {slotdata="vanilla_health_cicadas", codes={"opt_cicada"}, type="MAP_TOGGLE_REVERSE"},
    {slotdata="randomize_color_puzzle", codes={"opt_puzzle"}, type="MAP_TOGGLE_REVERSE"},
    {slotdata="split_windmill", codes={"opt_windmill"}, type="MAP_TOGGLE"},
    {slotdata="forest_bunny_chest", codes={"opt_bunny"}, type="MAP_TOGGLE"},
    {slotdata="nexus_gate_shuffle", codes={"opt_nexus"}, type="MAP_NUMBER"},
    {slotdata="victory_condition", codes={"opt_goal"}, type="MAP_NUMBER"},
    {slotdata="shuffle_big_gates", codes={"opt_bigkey"}, type="MAP_NUMBER"},
    {slotdata="dustsanity", codes={"opt_dustsanity"}, type="MAP_TOGGLE"},
    {slotdata="postgame_mode", codes={"opt_postgame"}, type="MAP_NUMBER"},
    {slotdata="small_keys", codes={"opt_smallkey"}, type="MAP_KEY"}
}

LAYOUT_MAPPING = {
    "opt_smallkey",
    "opt_bigkey",
    "opt_redcave",
    "opt_windmill",
    "opt_postgame"
}

NEXUS_MAPPING = {
    ["Apartment floor 1"] = "apartment",
    ["Beach"] = "beach",
    ["Bedroom exit"] = "templeoftheseeingone",
    ["Blue"] = "blue",
    ["Cell"] = "cell",
    ["Circus"] = "circus",
    ["Cliff"] = "cliffs",
    ["Crowd exit"] = "mountaincavern",
    ["Fields"] = "fields",
    ["Forest"] = "deepforest",
    ["Go bottom"] = "go",
    ["Happy"] = "happy",
    ["Hotel floor 4"] = "hotel",
    ["Overworld"] = "overworld",
    ["Red Cave exit"] = "redcave",
    ["Red Sea"] = "redsea",
    ["Suburb"] = "youngtown",
    ["Space"] = "space",
    ["Terminal"] = "terminal",
    ["Windmill entrance"] = "windmill"
}

EVENT_MAPPING = {
    -- Bosses
    "Defeated_Seer",
    "Defeated_Wall",
    "Defeated_Rogue",
    "Defeated_Manager",
    "Defeated_Watcher",
    "Defeated_Servants",
    "Defeated_Sage",
    "Defeated_Briar",
    
    -- Tentacles
    "Tentacle_CL",
    "Tentacle_CR",
    "Tentacle_L",
    "Tentacle_R",
    
    -- Big Keys
    "Green_Key",
    "Red_Key",
    "Blue_Key",
    
    -- Misc
    "Opened_Windmill",
}

BOSSES = {
    "Defeated_Seer",
    "Defeated_Wall",
    "Defeated_Rogue",
    "Defeated_Manager",
    "Defeated_Watcher",
    "Defeated_Servants",
    "Defeated_Sage",
    "Defeated_Briar",
}

TENTACLES = {
    "Tentacle_CL",
    "Tentacle_CR",
    "Tentacle_L",
    "Tentacle_R",
}