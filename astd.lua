if not game:IsLoaded() then game.Loaded:Wait() end
if game.GameId ~= 1720936166 then return end
local benchmark_time = os.clock()

-- Helper Functions
local function Split(s, delimiter)
    local result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

local function StringToCFrame(input)
    return CFrame.new(unpack(game:GetService("HttpService"):JSONDecode("[" ..
                                                                           input ..
                                                                           "]")))
end

local function ShallowCopy(original)
    local copy = {}
    for key, value in pairs(original) do copy[key] = value end
    return copy
end

local function DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then v = DeepCopy(v) end
        copy[k] = v
    end
    return copy
end

local function TableLength(t)
    local n = 0

    for _ in pairs(t) do n = n + 1 end

    return n
end

local function TableConcat(t1, t2)
    for i = 1, #t2 do t1[#t1 + 1] = t2[i] end
    return t1
end

local function get_keys(t)
    local keys = {}
    for key, _ in pairs(t) do table.insert(keys, key) end
    return keys
end

local postfixes = {
    ["n"] = 10 ^ (-6),
    ["m"] = 10 ^ (-3),
    ["k"] = 10 ^ 3,
    ["M"] = 10 ^ 6,
    ["G"] = 10 ^ 9
}

local function convert(n)
    local postfix = n:sub(-1)
    if postfixes[postfix] then
        return tonumber(n:sub(1, -2)) * postfixes[postfix]
    elseif tonumber(n) then
        return tonumber(n)
    else
        error("invalid postfix")
    end
end

-- https://devforum.roblox.com/t/comparing-color-values/1017439/2
local function CompareColor3(base, toCompare)
    local base_colors = {base.R, base.G, base.B} -- table to hold the original color3s
    local comp_colors = {toCompare.R, toCompare.G, toCompare.B} -- table to 

    local verdict = {} -- table to hold whether other not each of them were the same

    for index, col in ipairs(comp_colors) do -- uses an "ipairs" loop instead of "pairs" loop because this is numerical
        if base_colors[index] == col then -- checks if the index of the base_colors table is the same
            table.insert(verdict, true) -- add 1 true value to the verdict table
        else
            table.insert(verdict, false) -- add 1 false value to the verdict table
        end
    end

    if table.find(verdict, false) then -- if one of them is false then it isn't the same
        return false -- returns false
    else
        return true -- returns true
    end
end

local version = "3.2"
local Settings
local Macros = {}

benchmark_time = os.clock()

local Rayfield = loadstring(game:HttpGet(
                                'https://raw.githubusercontent.com/KarmaPanda/Roblox/refs/heads/main/rayfield.lua'))()

local Window = Rayfield:CreateWindow({
    Name = string.format(
        "KarmaPanda's All Star Tower Defense Script (Version %s)", version),
    LoadingTitle = "All Star Tower Defense Script",
    LoadingSubtitle = "by KarmaPanda",
    LoadingVersion = string.format("Version %s", version),
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = true, Invite = "BrnQQGKbvE", RememberJoins = true},
    KeySystem = false
})

print("[KarmaPanda] Rayfield Loaded: " .. os.clock() - benchmark_time)
benchmark_time = os.clock()

if not isfolder("KarmaPanda") then makefolder("KarmaPanda") end

if not isfolder("KarmaPanda\\ASTD") then makefolder("KarmaPanda\\ASTD") end

if not isfolder("KarmaPanda\\ASTD\\Settings") then
    makefolder("KarmaPanda\\ASTD\\Settings")
end

local SettingsFile = "KarmaPanda\\ASTD\\Settings\\" ..
                         game.Players.LocalPlayer.UserId .. ".json"

local InfiniteMapTable = {
    ["-1"] = "Regular [1]",
    ["-1.7"] = "Regular [2]",
    ["-1.1"] = "Category",
    ["-1.3"] = "Air",
    ["-1.8"] = "Solo",
    ["-1.9"] = "Random Unit",
    ["-1.5"] = "Double Path",
    ["-97"] = "Gauntlet",
    ["-98"] = "Training",
    ["-99"] = "Farm"
}

local AdventureMapTable = {
    ["-13"] = "String Raid",
    ["-1003"] = "Sijin Raid",
    ["-1004"] = "Spirit Raid",
    ["-1111"] = "Marine HQ",
    ["-1112"] = "Kai Planet",
    ["-1113"] = "Hell",
    ["-1114"] = "Machi Planet",
    ["-1117"] = "Candy Raid",
    ["-1118"] = "Demon Mark Raid",
    ["-1121"] = "Soul Raid",
    ["-1122"] = "Sun Raid",
    ["-1125"] = "Meteor Raid",
    ["-1127"] = "Berserker Raid",
    ["-1128"] = "Venom Raid",
    ["-1129"] = "Dueled Raid",
    ["-1132"] = "Hunt On Blacksmith",
    ["-1133"] = "Mythical Freedom",
    ["-1134"] = "Bizare Prison",
    ["-1136"] = "Six Eyes Raid",
    ["-1142"] = "TOP1",
    ["-1143"] = "TOP2",
    ["-1144"] = "TOP3",
    ["-1145"] = "TOP4",
    ["-1146"] = "TOP5",
    ["-1147"] = "TOP6",
    ["-1155"] = "Demon Raid M2",
    ["-1156"] = "Divine Raid",
    ["-1450"] = "Random Boss Rush",
    ["-1451"] = "Random Boss Rush 2",
    ["-1506"] = "Path Raid",
    ["-1550"] = "Enuma Raid",
    ["-1168"] = "Demon Memory Raid",
    ["-1167"] = "Ocean Memory Raid",
    ["-1166"] = "Earth Tournament Memory Raid",
    ["-1165"] = "Purple Planet Raid",
    ["-1164"] = "Darkness Raid",
    ["-1163"] = "Malevolent Raid",
    ["-1162"] = "Crystal Cavern Raid"
}

local function GetMapsFromTable(T)
    local maps = {}
    for _, v in pairs(T) do table.insert(maps, v) end
    return maps
end

local DefaultSettings = {
    version = version,
    auto_buff = true,
    auto_buff_units = {
        ["Erwin"] = {
            ["Mode"] = "Box",
            ["Checks"] = {"attack"},
            ["Ability Type"] = "Normal",
            ["Time"] = 13
        },
        ["Merlin"] = {
            ["Mode"] = "Pair",
            ["Checks"] = {"range"},
            ["Ability Type"] = "Normal",
            ["Time"] = 30
        },
        ["Brook6"] = {
            ["Mode"] = "Box",
            ["Checks"] = {"attack", "range"},
            ["Ability Type"] = "Normal",
            ["Time"] = 13
        },
        ["Kisuke6"] = {
            ["Mode"] = "Pair",
            ["Checks"] = {"attack", "range"},
            ["Ability Type"] = "Multiple",
            ["Ability Name"] = "Buff Ability",
            ["Time"] = 13
        },
        ["Rayleigh"] = {
            ["Mode"] = "Box",
            ["Checks"] = {"attack"},
            ["Ability Type"] = "Normal",
            ["Time"] = 13
        },
        ["Six Eyes Gojo"] = {
            ["Mode"] = "Cycle",
            ["Checks"] = {},
            ["Ability Type"] = "Normal",
            ["Cycle Units"] = 7,
            ["Time"] = 10,
            ["Delay"] = 1
        },
        ["Merlin6"] = {
            ["Time"] = 13,
            ["Checks"] = {"attack", "range"},
            ["Mode"] = "Box",
            ["Ability Type"] = "Normal"
        },
        ["Gojo7"] = {
            ["Time"] = 9.5,
            ["Checks"] = {""},
            ["Mode"] = "Box",
            ["Delay"] = 0,
            ["Ability Type"] = "Normal"
        },
        ["Hoshino"] = {
            ["Time"] = 15,
            ["Checks"] = {""},
            ["Mode"] = "Spam",
            ["Delay"] = 0,
            ["Ability Type"] = "Normal"
        },
        ["Metal Cooler"] = {
            ["Time"] = 21,
            ["Checks"] = {""},
            ["Mode"] = "Spam",
            ["Delay"] = 0.5,
            ["Ability Type"] = "Normal"
        },
        ["Satorou Gojou"] = {
            ["Time"] = 10,
            ["Checks"] = {""},
            ["Mode"] = "Box",
            ["Delay"] = 0,
            ["Ability Type"] = "Normal"
        }
    },
    auto_vote_extreme = false,
    auto_2x = false,
    auto_3x = false,
    macro_profile = "Default Profile",
    macro_record = false,
    macro_playback = false,
    macro_record_time_offset = 0,
    macro_money_tracking = false,
    macro_playback_time_offset = 0,
    macro_magnitude = 1,
    macro_playback_search_attempts = 60,
    macro_playback_search_delay = 1,
    macro_summon = true,
    macro_sell = true,
    macro_upgrade = true,
    macro_ability = true,
    macro_auto_ability = true,
    macro_priority = true,
    macro_skipwave = true,
    macro_autoskipwave = true,
    macro_speedchange = true,
    macro_ability_blacklist = {
        "Erwin", "Merlin", "Brook6", "Kisuke6", "Rayleigh", "Merlin6", "Gojo7",
        "Hoshino", "Metal Cooler"
    },
    macro_timer_version = "Version 2",
    action_queue_remote_fire_delay = 0.25,
    action_queue_remote_on_fail = true,
    action_queue_remote_on_fail_delay = 1,
    action_queue_remote_on_fail_delay_loop = 0.5,
    auto_join_game = false,
    auto_join_tower = false,
    auto_join_delay = 5,
    auto_join_mode = "Infinite",
    auto_join_story_level = 1,
    auto_join_infinite_level = "-1.7",
    auto_join_trial_level = 1,
    auto_join_raid_level = 1,
    auto_join_challenge_level = 1,
    auto_join_bout_level = 1,
    auto_join_adventure_level = "-1133",
    auto_join_w3_level = 1,
    auto_evolve_exp = true,
    auto_skip_gui = true,
    webhook_url = "",
    webhook_discord_id = "",
    webhook_user_name = true,
    webhook_color = "FF8700",
    webhook_ping_user = false,
    webhook_end_game = false,
    webhook_exp_evolve = false,
    anti_afk = true,
    disable_3d_rendering = false,
    auto_execute = false,
    auto_battle = false,
    auto_battle_gems = 2700,
    fps_boost = false,
    auto_upgrade = false,
    auto_upgrade_money = 100,
    auto_upgrade_wave_stop = 100,
    auto_upgrade_sell = false,
    auto_upgrade_wave = 0,
    auto_upgrade_wave_sell = 100,
    anonymous_mode = true,
    anonymous_mode_name = "Anonymous"
}

if not pcall(function() readfile(SettingsFile) end) then
    writefile(SettingsFile,
              game:GetService("HttpService"):JSONEncode(DefaultSettings))
end

if not pcall(function()
    Settings = game:GetService("HttpService"):JSONDecode(readfile(SettingsFile))
end) then
    writefile(SettingsFile,
              game:GetService("HttpService"):JSONEncode(DefaultSettings))
    Settings = DefaultSettings
end

local IndividualMacroDefaultSettings = {
    ["Macro"] = {},
    ["Units"] = {},
    ["Map"] = {},
    ["Settings"] = {}
}

local MacroDefaultSettings = {
    ["Default Profile"] = DeepCopy(IndividualMacroDefaultSettings)
}

local folder_name = "KarmaPanda\\ASTD\\" .. game.Players.LocalPlayer.UserId

if not isfolder(folder_name) then makefolder(folder_name) end

if #listfiles(folder_name) == 0 then
    writefile(folder_name .. "\\" .. "Default Profile.json",
              game:GetService("HttpService"):JSONEncode(MacroDefaultSettings))
end

for _, file in pairs(listfiles(folder_name)) do
    if not pcall(function()
        local json_content = game:GetService("HttpService"):JSONDecode(readfile(
                                                                           file))

        for k, v in pairs(json_content) do
            if Macros[k] ~= nil then
                delfile(file)
            else
                Macros[k] = v
            end
        end
    end) then print("Error reading file: " .. file) end
end

if TableLength(Macros) == 0 then
    writefile(folder_name .. "\\" .. "Default Profile.json",
              game:GetService("HttpService"):JSONEncode(MacroDefaultSettings))
    Macros["Default Profile"] = DeepCopy(IndividualMacroDefaultSettings)
end

local MacroProfileList = {}

for i, _ in pairs(Macros) do table.insert(MacroProfileList, i) end

if Macros[Settings.macro_profile] == nil then
    Settings.macro_profile = MacroProfileList[#MacroProfileList]
end

function Save()
    writefile(SettingsFile, game:GetService("HttpService"):JSONEncode(Settings))

    for profile_name, macro_table in pairs(Macros) do
        local save_data = {}
        save_data[profile_name] = macro_table
        writefile(folder_name .. "\\" .. profile_name .. ".json",
                  game:GetService("HttpService"):JSONEncode(save_data))
    end
end

for k, v in pairs(DefaultSettings) do
    if Settings[k] == nil then Settings[k] = v end
end

Settings.version = version
Save()
print("[KarmaPanda] Filesystem Loaded: " .. os.clock() - benchmark_time)
benchmark_time = os.clock()

-- Game Helper Variables
local Player = game.Players.LocalPlayer
local GUI = Player.PlayerGui

-- Game Helper Functions
local function get_world()
    local worlds = {
        ["14657361824"] = -2, -- team event
        ["5552815761"] = -1, -- time chamber
        ["11574204578"] = 0,
        ["4996049426"] = 1,
        ["7785334488"] = 2
        -- ["11886211138"] = 3
    }
    return worlds[tostring(game.PlaceId)]
end

local function get_game_speed()
    return game:GetService("ReplicatedStorage").SpeedUP.Value
end

local function Delay(time, condition)
    local timeElapsed = 0
    local updates = 0.1 -- 100 ms checks

    while timeElapsed < time do
        if not condition then break end
        timeElapsed = timeElapsed + (updates * get_game_speed())
        task.wait(updates)
    end
end

local function get_units()
    local units = {}
    local T = game:GetService("Workspace").Unit:GetChildren()

    for k, v in pairs(T) do
        if v:FindFirstChild("Owner") ~= nil and tostring(v.Owner.Value) ==
            Player.Name then table.insert(units, v) end
    end

    return units
end

local CachedStats, OrbsV2Client, DataFolderClient

if get_world() ~= -1 and get_world() ~= -2 then
    CachedStats = require(Player.Backpack:WaitForChild("Framework")
                              :WaitForChild("CachedStats"))
    OrbsV2Client = require(game:GetService("ReplicatedStorage"):WaitForChild(
                               "Framework"):WaitForChild("OrbsV2Client"))
    DataFolderClient =
        require(game.ReplicatedStorage.Framework.DataFolderClient)
end

local function get_all_storage_items()
    local items = {}

    if get_world() ~= -1 and get_world() ~= -2 then
        local storageItems = game:GetService("ReplicatedStorage").StorageItems

        for _, item in pairs(storageItems:GetChildren()) do
            if item.Name ~= "Disc" then -- no package link smh
                table.insert(items, item.Name)
            end
        end
    end
    return items
end

local function get_all_units()
    local units = {}

    if get_world() ~= -1 and get_world() ~= -2 then
        for k, v in pairs(
                        game:GetService("ReplicatedStorage").Unit:GetChildren()) do
            if v.Name ~= "PackageLink" then
                table.insert(units, v.Name)
            end
        end
    end

    return units
end

local function get_stat(unit_name) return CachedStats.getstat(unit_name) end

local function get_unit_from_gui(unit_name)
    local UnitGUI = GUI:FindFirstChild("HUD"):FindFirstChild("BottomFrame")
                        :FindFirstChild("Unit")

    for _, v in pairs(UnitGUI:GetChildren()) do
        if v.ClassName == "Frame" then
            local u = v:FindFirstChild("Unit")
            if u.Value == unit_name then return v end
        end
    end

    return nil
end

local function get_summon_cost(unit_name)
    local cost = get_stat(unit_name)["Cost"]
    local discount = 0
    local unit = get_unit_from_gui(unit_name)

    if unit == nil then
        local orb = OrbsV2Client.GetAssignedOrbForUnit(unit_name)

        if orb ~= nil then
            local orb_stats = CachedStats.getOrbStat(orb)

            if orb_stats ~= nil then
                if orb_stats["InitialCost"] ~= nil then
                    discount = orb_stats["InitialCost"]
                end
                if orb_stats["InitialPercentageCost"] ~= nil then
                    cost = cost * orb_stats["InitialPercentageCost"]
                end
            end
        end

        return cost - discount
    else
        local image_label = unit:FindFirstChild("ImageLabel")

        if image_label ~= nil then
            local text_label = image_label:FindFirstChild("TextLabel")

            if text_label ~= nil then cost = convert(text_label.Text) end
        end

        return cost
    end
end

local function get_upgrade_cost(unit_name, level)
    local unit = get_stat(unit_name)

    if unit ~= nil then
        local upgrades = unit["Upgrade"]

        if upgrades[level] == nil then
            return 0
        else
            local cost = upgrades[level]["Cost"]
            local unit = get_unit_from_gui(unit_name)

            if unit ~= nil then
                local id = unit:FindFirstChild("ID")

                if id ~= nil then
                    local orb = OrbsV2Client.GetAssignedOrbForUnit(id.Value)
                    if orb ~= nil then
                        local orb_stats = CachedStats.getOrbStat(orb)

                        if orb_stats ~= nil then
                            if orb_stats["InitialPercentageCost"] ~= nil then
                                cost = cost * orb_stats["InitialPercentageCost"]
                            end
                        end
                    end
                end
            end

            return cost
        end
    else
        return 0 -- cannot find unit with get_stat
    end
end

local function get_max_upgrade_level(unit_name)
    return #get_stat(unit_name)["Upgrade"]
end

local function get_money() return Player:FindFirstChild("Money").Value end

local function get_wave()
    local WaveValue = game:GetService("ReplicatedStorage"):FindFirstChild(
                          "WaveValue")
    local wave = 0
    if WaveValue ~= nil then wave = WaveValue.Value end
    return wave
end

local function get_gems()
    if DataFolderClient ~= nil then
        return DataFolderClient.Get("Gems")
    else
        return nil
    end
end

local function get_gold()
    if DataFolderClient ~= nil then
        return DataFolderClient.Get("Gold")
    else
        return nil
    end
end

local function get_stardust()
    if DataFolderClient ~= nil then
        return DataFolderClient.Get("StardustStone")
    else
        return nil
    end
end

local function get_level()
    if DataFolderClient ~= nil then
        return DataFolderClient.Get("Level")
    else
        return nil
    end
end

local function get_battle_pass_tier()
    local bp_tier = "nil"

    pcall(function()
        bp_tier = GUI.TowerPassRewards.Main.Page.Main.Top.CurrentTierBox.Tier
                      .Text
    end)

    return bp_tier
end

local function is_lobby()
    if get_world() ~= -1 and get_world() ~= -2 then
        return game.ReplicatedStorage:FindFirstChild("Lobby").Value
    else
        return nil
    end
end

local function get_number_missions()
    if get_world() ~= -1 and get_world() ~= -2 then
        return #game.ReplicatedStorage.Remotes.Server:InvokeServer("Mission")
    else
        return 204
    end
end

local function get_game_status()
    local status = GUI.HUD:WaitForChild("MissionEnd"):WaitForChild("BG")
                       :WaitForChild("Status"):WaitForChild("Status")

    return status.Text
end

local function get_world_teleporter()
    if 1 == get_world() then
        return game:GetService("Workspace").Queue["W2 PERM"].World2.Script115
    elseif 2 == get_world() then
        return game:GetService("Workspace").Script115
    end
end

local function CheckAttackBuff(Units)
    pcall(function()
        for _, v in pairs(Units) do
            local buffs = v:FindFirstChild("Head"):FindFirstChild("EffectBBGUI")
            if buffs ~= nil then
                local attack_buff = buffs:FindFirstChild("Frame")
                                        :FindFirstChild("AttackImage")

                if not attack_buff.Visible then return false end
            else
                return false
            end
        end

        return true
    end)
end

local function CheckRangeBuff(Units)
    for _, v in pairs(Units) do
        local buffs = v:FindFirstChild("Head"):FindFirstChild("EffectBBGUI")
        if buffs ~= nil then
            local range_buff = buffs:FindFirstChild("Frame"):FindFirstChild(
                                   "RangeImage")

            if not range_buff.Visible then return false end
        else
            return false
        end
    end

    return true
end

local function CheckStun(unit)
    local buffs = unit:FindFirstChild("Head"):FindFirstChild("EffectBBGUI")
    if buffs ~= nil then
        local stun = buffs:FindFirstChild("Frame"):FindFirstChild("StunImage")

        if not stun.Visible then return false end
    else
        return false
    end

    return true
end

local function HideSummonGUI()
    while GUI:WaitForChild("HUD"):FindFirstChild("SUMMONGUI") ~= nil do
        local vim = game:GetService('VirtualInputManager')
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait()
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        task.wait(0.25)
    end
end

local StartTime = 30
local TimeOffset = 0

local function ElapsedTime()
    local wave = get_wave()

    if wave > 0 then
        if Settings.macro_timer_version == "Version 1" then
            return getrenv()["time"]() + TimeOffset
        elseif Settings.macro_timer_version == "Version 2" then
            return (getrenv()["time"]() - StartTime) + TimeOffset
        end
    end

    return 0
end

local function CalculateTimeOffset()
    task.spawn(function()
        repeat task.wait() until get_game_speed() ~= nil and get_wave() > 0

        StartTime = getrenv()["time"]()

        while true do
            if get_game_speed() > 1 then
                TimeOffset = TimeOffset + ((get_game_speed() - 1) * 0.015)
            end
            task.wait(0.015)
            -- print("Macro Calculated Time:", ElapsedTime())
            -- print("Macro Calculated Time w/o Offset:", ElapsedTime() - TimeOffset)
        end
    end)
end

local function SendWebhook(fields)
    local status, error_message = pcall(function()
        local request = request or http_request or (http and http.request) or
                            syn.request

        local content = {}

        if Settings.webhook_user_name then
            table.insert(content, {
                ["name"] = "Username",
                ["value"] = "||" .. Player.Name .. "||"
            })
        end

        content = TableConcat(content, fields)

        local ping_message = ""

        if Settings.webhook_discord_id ~= "" and Settings.webhook_ping_user then
            ping_message = "<@" .. Settings.webhook_discord_id .. ">"
        end

        request({
            Url = Settings.webhook_url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({
                ["content"] = ping_message,
                ["embeds"] = {
                    {
                        ["author"] = {
                            ["name"] = "KarmaPanda",
                            ["url"] = "https://discord.gg/BrnQQGKbvE",
                            ["icon_url"] = "https://avatars.githubusercontent.com/u/10904093?v=4"
                        },
                        ["title"] = "All Star Tower Defense",
                        ["url"] = "https://www.roblox.com/games/4996049426/",
                        ["type"] = "rich",
                        ["color"] = tonumber(Settings.webhook_color, 16),
                        ["fields"] = content
                    }
                }
            })
        })
    end)

    if not status then print("Webhook error:", error_message) end
end

-- https://www.lua.org/pil/11.4.html
Queue = {}
function Queue.new() return {first = 0, last = -1} end
function Queue.pushleft(list, value)
    local first = list.first - 1
    list.first = first
    list[first] = value
end
function Queue.pushright(list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end
function Queue.popleft(list)
    local first = list.first
    if first > list.last then error("list is empty") end
    local value = list[first]
    list[first] = nil -- to allow garbage collection
    list.first = first + 1
    return value
end
function Queue.popright(list)
    local last = list.last
    if list.first > last then error("list is empty") end
    local value = list[last]
    list[last] = nil -- to allow garbage collection
    list.last = last - 1
    return value
end
function Queue.length(list) return (list.last - list.first) + 1 end

-- Action Queue
local Action_Queue = Queue.new()
local Upgrade_Counter = 0

local function ActionQueueHelper()
    while task.wait() do
        if Queue.length(Action_Queue) > 0 then
            print("Actions in queue:", Queue.length(Action_Queue))
            local current = Queue.popleft(Action_Queue)
            local remote_method = current["Method"]
            local remote_args = current["Args"]
            print("Current Action", remote_method)
            for k, v in pairs(remote_args) do print(k, v) end
            if tostring(remote_method) == "Input" then
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                    unpack(remote_args))
            end
            if tostring(remote_method) == "Server" then
                game:GetService("ReplicatedStorage").Remotes.Server:InvokeServer(
                    unpack(remote_args))
            end
            task.wait(Settings.action_queue_remote_fire_delay)
            if remote_args[1] == "Upgrade" then
                Upgrade_Counter = Upgrade_Counter - 1
            end
        end
    end
end

local function StartActionQueue()
    local success, error_message = pcall(ActionQueueHelper)

    -- Rerun code if something breaks in the action queue.
    while not success do
        print("Error with action queue found: " .. error_message)
        success, error_message = pcall(ActionQueueHelper)
        task.wait()
    end
end

-- Action Queue Functions
local function AddToQueue(remote_method, remote_args)
    Queue.pushright(Action_Queue,
                    {["Method"] = remote_method, ["Args"] = remote_args})
end

local function SummonUnit(rotation, cframe, unit_name)
    local status, err = pcall(function()
        local function CheckUnitExist(unit)
            local owner = unit:FindFirstChild("Owner")
            local hrp = unit:FindFirstChild("HumanoidRootPart")

            if owner ~= nil and hrp ~= nil then
                local magnitude =
                    (cframe.Position - hrp.CFrame.Position).magnitude

                if tostring(owner.Value) == Player.Name and unit.Name ==
                    unit_name and magnitude <= Settings.macro_magnitude then
                    return true
                end
            end

            return false
        end

        if type(cframe) == "string" then cframe = StringToCFrame(cframe) end

        if Settings.macro_money_tracking then
            repeat task.wait() until get_money() >= get_summon_cost(unit_name)
        end

        local summoned = false
        local connection = game:GetService("Workspace").Unit.ChildAdded:Connect(
                               function(unit)
                if CheckUnitExist(unit) then summoned = true end
            end)

        AddToQueue(game:GetService("ReplicatedStorage").Remotes.Input, {
            [1] = "Summon",
            [2] = {
                ["Rotation"] = rotation,
                ["cframe"] = cframe,
                ["Unit"] = unit_name
            }
        })

        if Settings.action_queue_remote_on_fail then
            task.spawn(function()
                task.wait(Settings.action_queue_remote_on_fail_delay)
                while not summoned do
                    if Queue.length(Action_Queue) == 0 then
                        for _, unit in pairs(
                                           game:GetService("Workspace").Unit:GetChildren()) do
                            if CheckUnitExist(unit, cframe) then
                                summoned = true
                                break
                            end
                        end
                        if not summoned then
                            AddToQueue(
                                game:GetService("ReplicatedStorage").Remotes
                                    .Input, {
                                    [1] = "Summon",
                                    [2] = {
                                        ["Rotation"] = rotation,
                                        ["cframe"] = cframe,
                                        ["Unit"] = unit_name
                                    }
                                })
                        end
                    end
                    task.wait(Settings.action_queue_remote_on_fail_delay_loop)
                end
                connection:Disconnect()
            end)
        else
            connection:Disconnect()
        end
    end)

    if not status then print("Error on Summon Unit: " .. err) end
end

local function UpgradeUnit(unit, upgrade_level)
    local status, err = pcall(function()
        local unit_upgrade_level = unit:FindFirstChild("UpgradeTag")
        local unit_max_upgrade_level = get_max_upgrade_level(unit.Name)

        local function UnitIsUpgraded()
            if unit_upgrade_level.Value >= upgrade_level or
                unit_upgrade_level.Value >= unit_max_upgrade_level then
                return true
            else
                return false
            end
        end

        -- repeat task.wait() until Upgrade_Counter == 0

        -- if Settings.macro_money_tracking then
        local total_upgrade_cost = 0
        local total_upgrade_levels = upgrade_level - unit_upgrade_level.Value

        for i = unit_upgrade_level.Value + 1, upgrade_level do
            total_upgrade_cost = total_upgrade_cost +
                                     get_upgrade_cost(unit.Name, i)
        end

        repeat
            task.wait()
            print(string.format(
                      "Macro money tracking, current money %s. Upgrade cost %s.",
                      get_money(), total_upgrade_cost))
            if UnitIsUpgraded() then return end
        until get_money() >= total_upgrade_cost
        -- end

        local upgraded = false

        local connection = unit_upgrade_level:GetPropertyChangedSignal("Value")
                               :Connect(function()
                if UnitIsUpgraded() then upgraded = true end
            end)

        for i = unit_upgrade_level.Value + 1, upgrade_level do
            -- Upgrade_Counter = Upgrade_Counter + 1
            game:GetService("ReplicatedStorage").Remotes.Server:InvokeServer(
                "Upgrade", unit)
            -- AddToQueue(game:GetService("ReplicatedStorage").Remotes.Server, {[1] = "Upgrade", [2] = unit})
        end

        task.spawn(function()
            task.wait(1)
            while not upgraded do
                if Queue.length(Action_Queue) == 0 then
                    if UnitIsUpgraded() then break end
                    if not upgraded then
                        -- Upgrade_Counter = Upgrade_Counter + 1
                        game:GetService("ReplicatedStorage").Remotes.Server:InvokeServer(
                            "Upgrade", unit)
                    end
                end
                task.wait(1)
            end
            connection:Disconnect()
        end)

        --[[if Settings.action_queue_remote_on_fail then
            task.spawn(function()
                task.wait(Settings.action_queue_remote_on_fail_delay)
                while not upgraded do
                    if Queue.length(Action_Queue) == 0 then
                        if UnitIsUpgraded() then break end
                        if not upgraded then
                            Upgrade_Counter = Upgrade_Counter + 1
                            AddToQueue(
                                game:GetService("ReplicatedStorage").Remotes
                                    .Server, {[1] = "Upgrade", [2] = unit})
                        end
                    end
                    task.wait(Settings.action_queue_remote_on_fail_delay_loop)
                end
                connection:Disconnect()
            end)
        else
            connection:Disconnect()
        end]] --
    end)

    if not status then print("Error on Upgrade Unit: " .. err) end
end

local function UseAbilityUnit(unit, ability_string)
    task.spawn(function()
        local status, err = pcall(function()
            local special_move = unit:FindFirstChild("SpecialMove")
            local special_move_enabled =
                special_move:FindFirstChild("Special_Enabled2")

            repeat task.wait() until not CheckStun(unit) and
                not special_move_enabled.Value

            local ability_used = false
            local connection = special_move_enabled:GetPropertyChangedSignal(
                                   "Value")
                                   :Connect(function()
                    ability_used = true
                end)

            AddToQueue(game:GetService("ReplicatedStorage").Remotes.Input, {
                [1] = "UseSpecialMove",
                [2] = unit,
                [3] = ability_string
            })

            if Settings.action_queue_remote_on_fail then
                task.spawn(function()
                    task.wait(Settings.action_queue_remote_on_fail_delay)
                    while not ability_used do
                        if Queue.length(Action_Queue) == 0 then
                            if special_move_enabled.Value then
                                break
                            end
                            if not ability_used then
                                AddToQueue(
                                    game:GetService("ReplicatedStorage").Remotes
                                        .Input, {
                                        [1] = "UseSpecialMove",
                                        [2] = unit,
                                        [3] = ability_string
                                    })
                            end
                        end
                        task.wait(
                            Settings.action_queue_remote_on_fail_delay_loop)
                    end
                    connection:Disconnect()
                end)
            else
                connection:Disconnect()
            end
        end)

        if not status then print("Error on Use Unit Ability: " .. err) end
    end)
end

local function UseMultipleAbilitiesGUI(ability_name)
    task.spawn(function()
        local gui = GUI:WaitForChild("MultipleAbilities")
        for k, v in pairs(gui:WaitForChild("Frame"):GetChildren()) do
            if v.Name == "ImageButton" then
                local text = v:WaitForChild("TextLabel")
                if text.Text == ability_name then
                    firesignal(v.Activated)
                    break
                end
            end
        end
    end)
end

local function UseKilluaWishesGUI(ability_name)
    task.spawn(function()
        local gui = GUI:WaitForChild("KilluaWishes")
        local Options = gui:WaitForChild("TextBackground"):WaitForChild(
                            "OptionsContainer")
        for k, v in pairs(Options:GetChildren()) do
            if v.Name == "Option" then
                if v.Text == ability_name then
                    print("Attempting to activate!")
                    for k, v in pairs(getconnections(v)) do
                        print(k, v)
                    end
                    -- TODO: Fix firesignal MouseButton1Click
                    pcall(function()
                        firesignal(v.MouseButton1Click)
                    end)
                    gui:Destroy()
                    break
                end
            end
        end
    end)
end

local function UseMultipleAbilitiesUnit(unit, ability_string, ability_name)
    -- TODO: Add check to make sure that unit is leveled for ability
    UseAbilityUnit(unit, ability_string)
    UseMultipleAbilitiesGUI(ability_name)
end

local function ActivateAutoAbilityUnit(unit, ability_string, toggled)
    AddToQueue(game:GetService("ReplicatedStorage").Remotes.Input,
               {[1] = "AutoToggle", [2] = unit, [3] = toggled})
    UseAbilityUnit(unit, ability_string)
end

local function ChangePriorityUnit(unit)
    AddToQueue(game:GetService("ReplicatedStorage").Remotes.Input,
               {[1] = "ChangePriority", [2] = unit})
end

local function SellUnit(unit)
    AddToQueue(game:GetService("ReplicatedStorage").Remotes.Input,
               {[1] = "Sell", [2] = unit})
end

local function SkipWave(wave)
    task.spawn(function()
        -- TODO: Use FindFirstChild etc
        repeat task.wait() until GUI.HUD.NextWaveVote.Visible

        -- TODO: Add remote refiring
        while get_wave() == wave and GUI.HUD.NextWaveVote.Visible do
            AddToQueue(game:GetService("ReplicatedStorage").Remotes.Input,
                       {[1] = "VoteWaveConfirm"})
            task.wait(1)
        end
    end)
end

local function AutoSkipWaveToggle(wave, status)
    task.spawn(function()
        repeat task.wait() until get_wave() >= wave

        local CategoryName = GUI:WaitForChild("HUD"):WaitForChild("Setting")
                                 :WaitForChild("Page"):WaitForChild("Main")
                                 :WaitForChild("Scroll"):WaitForChild(
                                     "SettingV2"):WaitForChild("AutoSkip")
                                 :WaitForChild("Options"):WaitForChild("Toggle")
                                 :WaitForChild("CategoryName")

        if CategoryName.Text ~= status then
            AddToQueue(game:GetService("ReplicatedStorage").Remotes.Input,
                       {[1] = "AutoSkipWaves_CHANGE"})
        end
    end)
end

local record_connections = {}

-- TODO: pcall this
local function GetUnitIndex(unit)
    if Macros[Settings.macro_profile]["Units"][unit.Name] == nil then
        Macros[Settings.macro_profile]["Units"][unit.Name] = {}
    end

    local index = nil
    local exists = false

    for i, v in ipairs(Macros[Settings.macro_profile]["Units"][unit.Name]) do
        local hrp = unit:WaitForChild("HumanoidRootPart", 1)

        if hrp ~= nil then
            local magnitude = (StringToCFrame(v["Position"]).Position -
                                  hrp.CFrame.Position).magnitude

            if magnitude <= Settings.macro_magnitude then
                exists = true
                index = i
                break
            end
        end
    end

    if index == nil then
        -- TODO: Find new rotation variable if needed.
        local rotation = 0

        --[[if getrenv()["_G"] ~= nil then
            rotation = getrenv()["_G"].RotateUnitPlacementValue
        end

        if rotation == nil then rotation = 0 end]] --

        table.insert(Macros[Settings.macro_profile]["Units"][unit.Name], {
            ["Rotation"] = rotation,
            ["Position"] = tostring(unit.HumanoidRootPart.CFrame)
        })
        index = #Macros[Settings.macro_profile]["Units"][unit.Name]
    end

    return index
end

-- TODO: pcall this
local function GetUnitByTargetInfo(Target)
    local unit_name = Target["Name"]
    local index = Target["Index"]

    local unit_info = Macros[Settings.macro_profile]["Units"][unit_name][index]
    local rotation = unit_info["Rotation"] -- only used for summons
    local cframe = StringToCFrame(unit_info["Position"]) -- used for identifying unit

    local unit = nil

    for _, v in pairs(game:GetService("Workspace").Unit:GetChildren()) do
        local hrp = v:WaitForChild("HumanoidRootPart", 1)

        if hrp ~= nil then
            local magnitude = (cframe.Position - hrp.CFrame.Position).magnitude

            if magnitude <= Settings.macro_magnitude then
                unit = v
                break
            end
        end
    end

    return unit, cframe, rotation
end

local function MacroRecordElapsedTime()
    return ElapsedTime() + Settings.macro_record_time_offset
end

local CurrentStep = nil

local function InsertToMacro(action)
    table.insert(Macros[Settings.macro_profile]["Macro"], action)
    Save()
    if CurrentStep ~= nil then
        CurrentStep = CurrentStep + 1
    else
        CurrentStep = 1
    end
end

local function HookUpgrade(unit, index)
    local upgrade_level = unit:WaitForChild("UpgradeTag", 60)

    if upgrade_level ~= nil then
        return upgrade_level:GetPropertyChangedSignal("Value"):Connect(
                   function()
                if Settings.macro_record and Settings.macro_upgrade then
                    InsertToMacro({
                        ["Time"] = MacroRecordElapsedTime(),
                        ["Target"] = {["Name"] = unit.Name, ["Index"] = index},
                        ["Remote"] = {[1] = "Upgrade", [2] = "Target"},
                        ["Parameter"] = {["Level"] = upgrade_level.Value}
                    })
                end
            end)
    else
        return nil
    end
end

local function HookAbility(unit, index)
    local special_move = unit:WaitForChild("SpecialMove", 15)

    if special_move ~= nil then
        local ability_2 = special_move:WaitForChild("Special_Enabled2", 15)

        if ability_2 == nil then return nil end

        local ability_1 = special_move:WaitForChild("Special_Enabled", 1)
        local ability_string = ""

        if ability_1 ~= nil then
            local special_enabled_string =
                ability_1:WaitForChild("Special_Enabled_String", 1)

            if special_enabled_string ~= nil then
                ability_string = special_enabled_string.Value
            end
        end

        return ability_2.ChildAdded:Connect(function(c)
            local status, err = pcall(function()
                if special_move:GetAttribute("Auto") then return end

                if Settings.macro_record and Settings.macro_ability and
                    table.find(Settings.macro_ability_blacklist, unit.Name) ==
                    nil then
                    if c.Name == "SpecialStart" then
                        InsertToMacro({
                            ["Time"] = MacroRecordElapsedTime(),
                            ["Target"] = {
                                ["Name"] = unit.Name,
                                ["Index"] = index
                            },
                            ["Remote"] = {
                                [1] = "UseSpecialMove",
                                [2] = "Target",
                                [3] = ability_string
                            }
                        })
                    end
                end
            end)

            if not status then
                print("Error on use ability hook: " .. err)
            end
        end)
    end

    return nil
end

local function HookAutoAbility(unit, index)
    local special_move = unit:WaitForChild("SpecialMove", 15)

    if special_move ~= nil then
        local special_enabled = special_move:WaitForChild("Special_Enabled", 1)
        local ability_string = ""

        if special_enabled ~= nil then
            local special_enabled_string =
                special_enabled:WaitForChild("Special_Enabled_String", 1)

            if special_enabled_string ~= nil then
                ability_string = special_enabled_string.Value
            end
        end

        return special_move:GetAttributeChangedSignal("Auto"):Connect(function()
            if Settings.macro_record and Settings.macro_auto_ability then
                InsertToMacro({
                    ["Time"] = MacroRecordElapsedTime(),
                    ["Target"] = {["Name"] = unit.Name, ["Index"] = index},
                    ["Remote"] = {
                        [1] = "AutoToggle",
                        [2] = "Target",
                        [3] = special_move:GetAttribute("Auto")
                    },
                    ["Parameter"] = {["Ability String"] = ability_string}
                })
            end
        end)
    end

    return nil
end

--[[local function HookPriority(unit, index)
    local priority = unit:WaitForChild("PriorityAttack", 60)

    if priority ~= nil then
        return priority:GetPropertyChangedSignal("Value"):Connect(function()
            if Settings.macro_record and Settings.macro_priority then
                InsertToMacro({
                    ["Time"] = MacroRecordElapsedTime(),
                    ["Target"] = {["Name"] = unit.Name, ["Index"] = index},
                    ["Remote"] = {[1] = "ChangePriority", [2] = "Target"},
                    ["Parameter"] = {["Priority"] = priority.Value}
                })
            end
        end)
    end

    return nil
end]] --

local function HookNextWave()
    local HUD = GUI:WaitForChild("HUD", 15)

    if HUD ~= nil then
        local next_wave_gui = HUD:WaitForChild("NextWaveVote", 15)

        if next_wave_gui == nil then return nil end

        local yes_button = next_wave_gui:WaitForChild("YesButton", 15)

        if yes_button ~= nil then
            return yes_button.MouseButton1Click:Connect(function()
                if Settings.macro_record and Settings.macro_skipwave then
                    InsertToMacro({
                        ["Time"] = MacroRecordElapsedTime(),
                        ["Remote"] = {[1] = "VoteWaveConfirm"},
                        ["Parameter"] = {["Wave"] = get_wave()}
                    })
                end
            end)
        end
    end

    return nil
end

local function HookAutoSkipWave()
    local Toggle = GUI:WaitForChild("HUD"):WaitForChild("Setting"):WaitForChild(
                       "Page"):WaitForChild("Main"):WaitForChild("Scroll")
                       :WaitForChild("SettingV2"):WaitForChild("AutoSkip")
                       :WaitForChild("Options"):WaitForChild("Toggle")
    local CategoryName = Toggle:WaitForChild("CategoryName")
    local Button = Toggle:WaitForChild("TextButton")

    if Button ~= nil then
        return Button.MouseButton1Click:Connect(function()
            if Settings.macro_record and Settings.macro_autoskipwave then
                InsertToMacro({
                    ["Time"] = MacroRecordElapsedTime(),
                    ["Remote"] = {[1] = "AutoSkipWaves_CHANGE"},
                    ["Parameter"] = {
                        ["Wave"] = get_wave(),
                        ["Status"] = CategoryName.Text
                    }
                })
            end
        end)
    else
        return nil
    end
end

local function HookMultipleAbilitiesGUI()
    local function Hook(c)
        if c.Name == "MultipleAbilities" then
            local Frame = c:WaitForChild("Frame")

            repeat task.wait() until #Frame:GetChildren() > 1

            for k, v in pairs(Frame:GetChildren()) do
                if v.Name == "ImageButton" then
                    local connection = v.MouseButton1Click:Connect(function()
                        local text = v:WaitForChild("TextLabel")
                        if Settings.macro_record and Settings.macro_ability then
                            InsertToMacro({
                                ["Time"] = MacroRecordElapsedTime(),
                                ["Remote"] = {[1] = "MultipleAbilities"},
                                ["Parameter"] = {["Ability Name"] = text.Text}
                            })
                        end
                    end)
                end
            end
        end
        if c.Name == "KilluaWishes" then
            local Options = c:WaitForChild("TextBackground"):WaitForChild(
                                "OptionsContainer")
            for k, v in pairs(Options:GetChildren()) do
                if v.Name == "Option" then
                    local connection = v.MouseButton1Click:Connect(function()
                        if Settings.macro_record and Settings.macro_ability then
                            InsertToMacro({
                                ["Time"] = MacroRecordElapsedTime(),
                                ["Remote"] = {[1] = "KilluaWishes"},
                                ["Parameter"] = {["Ability Name"] = v.Text}
                            })
                        end
                    end)
                end
            end
        end
    end

    for _, v in pairs(GUI:GetChildren()) do
        Hook(v) -- ensures all previous multiple abilities guis are found
    end

    return GUI.ChildAdded:Connect(function(c) Hook(c) end)
end

local function HookSpeedChanges()
    return
        game:GetService("ReplicatedStorage"):WaitForChild("SpeedUP").Changed:Connect(
            function(v)
                if Settings.macro_record and Settings.macro_speedchange then
                    InsertToMacro({
                        ["Time"] = MacroRecordElapsedTime(),
                        ["Remote"] = {[1] = "SpeedChange"},
                        ["Parameter"] = {["Speed"] = v}
                    })
                end
            end)
end

local function AddHooks(unit, index)
    -- TODO: Print error message if one of the hooks are nil.
    table.insert(record_connections, HookUpgrade(unit, index))
    table.insert(record_connections, HookAbility(unit, index))
    table.insert(record_connections, HookAutoAbility(unit, index))
    -- table.insert(record_connections, HookPriority(unit, index))
end

-- Temporary fix for priority recording
local game_metatable = getrawmetatable(game)
local namecall_original = game_metatable.__namecall

setreadonly(game_metatable, false)

game_metatable.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local script = getcallingscript()

    local Args = {...}

    if Settings.macro_record and Settings.macro_priority then
        if Args ~= nil and #Args > 1 and
            (method == "FireServer" or method == "InvokeServer") then
            if Args[1] == "ChangePriority" then
                task.spawn(function()
                    InsertToMacro({
                        ["Time"] = MacroRecordElapsedTime(),
                        ["Target"] = {
                            ["Name"] = Args[2].Name,
                            ["Index"] = GetUnitIndex(Args[2])
                        },
                        ["Remote"] = {[1] = "ChangePriority", [2] = "Target"}
                        -- ["Parameter"] = {["Priority"] = nil}
                    })
                end)
            end
        end
    end

    return namecall_original(self, ...)
end)

function StartMacroRecord()
    if Macros[Settings.macro_profile]["Macro"] == nil then
        Macros[Settings.macro_profile]["Macro"] = {}
    end

    if Macros[Settings.macro_profile]["Settings"] == nil then
        Macros[Settings.macro_profile]["Settings"] = {}
    end

    if Macros[Settings.macro_profile]["Map"] == nil then
        Macros[Settings.macro_profile]["Map"] = {}
    end

    if Macros[Settings.macro_profile]["Units"] == nil then
        Macros[Settings.macro_profile]["Units"] = {}
    end

    if is_lobby() then return end

    local Units = game:GetService("Workspace"):WaitForChild("Unit")
    for _, unit in pairs(get_units()) do AddHooks(unit, GetUnitIndex(unit)) end
    print("Hooked Units In Workspace...")

    task.spawn(function()
        table.insert(record_connections, Units.ChildAdded:Connect(function(unit)
            local owner = unit:WaitForChild("Owner")

            if tostring(owner.Value) == Player.Name then
                local index = GetUnitIndex(unit)

                if Settings.macro_record and Settings.macro_summon then
                    InsertToMacro({
                        ["Time"] = MacroRecordElapsedTime(),
                        ["Target"] = {["Name"] = unit.Name, ["Index"] = index},
                        ["Remote"] = {[1] = "Summon", [2] = "Target"}
                    })
                end

                AddHooks(unit, index)
            end
        end))
        print("Hooked Unit Summoning...")
    end)

    task.spawn(function()
        table.insert(record_connections,
                     Units.ChildRemoved:Connect(function(unit)
            if Settings.macro_record and Settings.macro_sell then
                local owner = unit:WaitForChild("Owner")

                if tostring(owner.Value) == Player.Name then
                    local index = GetUnitIndex(unit)

                    InsertToMacro({
                        ["Time"] = MacroRecordElapsedTime(),
                        ["Target"] = {["Name"] = unit.Name, ["Index"] = index},
                        ["Remote"] = {[1] = "Sell", [2] = "Target"}
                    })

                    Save()
                end
            end
        end))
        print("Hooked Units Selling...")
    end)

    task.spawn(function()
        table.insert(record_connections, HookNextWave())
        print("Hooked Next Wave...")
    end)

    task.spawn(function()
        table.insert(record_connections, HookMultipleAbilitiesGUI())
        print("Hooked Multiple Abilities GUI...")
    end)

    task.spawn(function()
        table.insert(record_connections, HookAutoSkipWave())
        print("Hooked Auto Skip Wave...")
    end)

    task.spawn(function()
        table.insert(record_connections, HookSpeedChanges())
        print("Hooked Speed Changes...")
    end)

    Rayfield:Notify({
        Title = "Macro Recording",
        Content = "Started Macro Recording...",
        Duration = 6.5,
        Image = 4483362458
    })
end

function StopMacroRecord()
    for _, v in pairs(record_connections) do v:Disconnect() end
    record_connections = {}
    Rayfield:Notify({
        Title = "Macro Recording",
        Content = "Stopped Macro Recording...",
        Duration = 6.5,
        Image = 4483362458
    })
end

function StartMacroPlayback()
    if is_lobby() then return end

    table.sort(Macros[Settings.macro_profile]["Macro"],
               function(a, b) return a["Time"] < b["Time"] end)

    CurrentStep, _ = next(Macros[Settings.macro_profile]["Macro"], CurrentStep)

    while CurrentStep do
        local Current = Macros[Settings.macro_profile]["Macro"][CurrentStep]

        repeat task.wait() until ElapsedTime() +
            Settings.macro_playback_time_offset >= Current["Time"] or
            not Settings.macro_playback

        if not Settings.macro_playback then break end

        local Remote = Current["Remote"]

        if Current["Target"] == nil then
            if Remote[1] == "VoteWaveConfirm" then
                SkipWave(Current["Parameter"]["Wave"])
            elseif Remote[1] == "AutoSkipWaves_CHANGE" then
                AutoSkipWaveToggle(Current["Parameter"]["Wave"],
                                   Current["Parameter"]["Status"])
            elseif Remote[1] == "MultipleAbilities" then
                UseMultipleAbilitiesGUI(Current["Parameter"]["Ability Name"])
            elseif Remote[1] == "KilluaWishes" then
                UseKilluaWishesGUI(Current["Parameter"]["Ability Name"])
            elseif Remote[1] == "SpeedChange" then
                ChangeSpeed(Current["Parameter"]["Speed"])
            else
                print(string.format(
                          "Macro error! Invalid target found for remote %s at step %s",
                          Remote[1], CurrentStep))
            end
        else
            local unit, position, rotation =
                GetUnitByTargetInfo(Current["Target"])

            if unit == nil and position and rotation then
                if Remote[1] == "Summon" and Settings.macro_summon then
                    SummonUnit(rotation, position, Current["Target"]["Name"])
                else
                    local attempts = 0
                    repeat
                        task.wait(Settings.macro_playback_search_delay)
                        unit, position, rotation =
                            GetUnitByTargetInfo(Current["Target"])
                        print(string.format(
                                  "Macro is attempting to find the unit for %s. Increase magnitude if this continues to occur or check if unit is being summoned.",
                                  Remote[1]))
                        attempts = attempts + 1
                    until unit ~= nil or attempts >=
                        Settings.macro_playback_search_attempts or
                        not Settings.macro_playback

                    if attempts >= Settings.macro_playback_search_attempts then
                        print(string.format(
                                  "Macro skipped step %s for action %s, target %s, time %s. Please check if unit is being summoned correctly, or if it is a issue with macro playback.",
                                  CurrentStep, Remote[1],
                                  Current["Target"]["Name"], Current["Time"]))
                    end
                end
            end

            if unit ~= nil then
                if Remote[1] == "Upgrade" and Settings.macro_upgrade then
                    UpgradeUnit(unit, Current["Parameter"]["Level"])
                elseif Remote[1] == "UseSpecialMove" and Settings.macro_ability and
                    table.find(Settings.macro_ability_blacklist, unit.Name) ==
                    nil then
                    UseAbilityUnit(unit, Remote[3])
                elseif Remote[1] == "AutoToggle" and Settings.macro_auto_ability then
                    ActivateAutoAbilityUnit(unit,
                                            Current["Parameter"]["Ability String"],
                                            Remote[3])
                elseif Remote[1] == "ChangePriority" and Settings.macro_priority then
                    ChangePriorityUnit(unit)
                elseif Remote[1] == "Sell" and Settings.macro_sell then
                    SellUnit(unit)
                elseif Remote[1] == "Summon" then
                    print(
                        "Macro attempting to summon a unit that already exists!")
                else
                    print("Macro error! Remote %s is not a valid for ASTD.")
                end
            elseif unit ~= nil and Remote[1] ~= "Summon" then
                print(string.format(
                          "Macro error! Cannot find unit for remote %s at step %s",
                          Remote[1], CurrentStep))
            end
        end

        CurrentStep, _ = next(Macros[Settings.macro_profile]["Macro"],
                              CurrentStep)
        task.wait()
    end
end

function StopMacroPlayback() if is_lobby() then return end end

function AutoVoteExtreme()
    repeat task.wait() until GUI.HUD.ModeVoteFrame.Visible

    repeat
        game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack({
            [1] = "VoteGameMode",
            [2] = "Extreme"
        }))
        task.wait(1)
    until not GUI.HUD.ModeVoteFrame.Visible
end

function AutoBattle()
    repeat task.wait() until GUI.HUD.FastForward.Autoplay.Visible

    if get_gems() < Settings.auto_battle_gems then
        Settings.auto_battle = false
        Rayfield:Notify({
            Title = "You have no gems to run Auto Battle!",
            Content = "Auto battle paused until you have more gems!",
            Duration = 6.5,
            Image = 4483362458,
            Actions = {Ignore = {Name = "Okay!", Callback = function() end}}
        })
        return
    end

    local function pressKey(keyCode)
        game:GetService("VirtualInputManager"):SendKeyEvent(true, keyCode,
                                                            false, game)
        task.wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, keyCode,
                                                            false, game)
    end

    if GUI.HUD.FastForward.Autoplay.Visible and
        not GUI.HUD.ModeVoteFrame.Visible then
        pressKey(Enum.KeyCode.BackSlash)
        task.wait(0.5)
        pressKey(Enum.KeyCode.Right)
        task.wait(0.5)
        pressKey(Enum.KeyCode.Return)
        task.wait(0.5)
        pressKey(Enum.KeyCode.BackSlash)
    end

    repeat task.wait() until GUI.Notification:WaitForChild("Message").Visible or
        CompareColor3(GUI.HUD.FastForward.Autoplay.BackgroundColor3,
                      Color3.fromRGB(10, 230, 0))

    if not CompareColor3(GUI.HUD.FastForward.Autoplay.BackgroundColor3,
                         Color3.fromRGB(10, 230, 0)) then
        local autoplay_popup = GUI.Notification:WaitForChild("Message")
                                   :WaitForChild("Message"):WaitForChild("Main")

        if autoplay_popup.Text.Text == "Want to spend 20 gems on AutoPlay" then
            pressKey(Enum.KeyCode.BackSlash)
            task.wait(0.5)
            pressKey(Enum.KeyCode.Right)
            task.wait(0.5)
            pressKey(Enum.KeyCode.Right)
            task.wait(0.5)
            pressKey(Enum.KeyCode.Return)
            task.wait(0.5)
            pressKey(Enum.KeyCode.BackSlash)
        end
    end
end

local function ManualUpgrade() -- added for pc
    if GUI.HUD.UpgradeV2.Actions.Upgrade.Visible then
        firesignal(GUI.HUD.UpgradeV2.Actions.Upgrade.MouseButton1Click)
    end
end

local function ManualSell() -- added for pc
    if GUI.HUD.UpgradeV2.Actions.Sell.Visible then
        firesignal(GUI.HUD.UpgradeV2.Actions.Sell.MouseButton1Click)
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        ManualUpgrade()
    elseif input.KeyCode == Enum.KeyCode.Q then
        ManualSell()
    end
end)

function ChangeSpeed(speed)
    task.spawn(function()
        while get_game_speed() ~= tonumber(speed) do
            local args = {[1] = "SpeedChange", [2] = true}
            if get_game_speed() < tonumber(speed) then
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                    unpack(args))
            elseif get_game_speed() > tonumber(speed) then
                args[2] = false
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                    unpack(args))
            end
            task.wait(1)
        end
    end)
end

function AutoChangeSpeed()
    repeat task.wait(1) until get_game_speed() ~= nil

    while Settings.auto_2x or Settings.auto_3x do
        local args = {[1] = "SpeedChange", [2] = true}

        if (Settings.auto_3x and get_game_speed() < 3) or
            (Settings.auto_2x and get_game_speed() < 2) then
            game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                unpack(args))
        elseif (Settings.auto_2x and get_game_speed() > 2) then
            args[2] = false
            game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                unpack(args))
        end

        task.wait(1)
    end
end

function OnGameEnd()
    if not is_lobby() then
        local end_gui = GUI.HUD:WaitForChild("MissionEnd")

        repeat task.wait() until end_gui.Visible

        -- DO ANY GAME ENDING ACTIONS HERE
        if Settings.webhook_end_game then
            local webhook_args = {}
            local bg = end_gui:FindFirstChild("BG")

            if bg ~= nil then
                if bg:FindFirstChild("Times") ~= nil then
                    local GameTimeElapsed = Split(
                                                Split(bg:FindFirstChild("Times").Text,
                                                      '\n')[2], "seconds")[1]
                    local time_elapsed = tostring(
                                             math.round(tonumber(GameTimeElapsed)))

                    table.insert(webhook_args, {
                        ["name"] = "Game Time Elapsed",
                        ["value"] = ":timer: " .. time_elapsed,
                        ["inline"] = true
                    })
                end
            end

            table.insert(webhook_args, {
                ["name"] = "Macro Time Elapsed",
                ["value"] = ":timer: " .. tostring(math.round(ElapsedTime())),
                ["inline"] = true
            })

            table.insert(webhook_args, {
                ["name"] = "Macro Time Elapsed (1x)",
                ["value"] = ":timer: " ..
                    tostring(math.round(ElapsedTime() - TimeOffset)),
                ["inline"] = true
            })

            local GameStatus = get_game_status()
            local GameStatusEmoji = ""

            if GameStatus == "Success!" then
                GameStatusEmoji = ":green_square: "
            elseif GameStatus == "Failed!" then
                GameStatusEmoji = ":red_square: "
            end

            table.insert(webhook_args, {
                ["name"] = "Status",
                ["value"] = GameStatusEmoji .. get_game_status(),
                ["inline"] = true
            })

            table.insert(webhook_args, {
                ["name"] = "Waves",
                ["value"] = ":ocean: " .. get_wave(),
                ["inline"] = true
            })

            table.insert(webhook_args, {
                ["name"] = "Current Level",
                ["value"] = ":star2: " .. get_level(),
                ["inline"] = true
            })

            table.insert(webhook_args, {
                ["name"] = "Current Gems",
                ["value"] = ":gem: " .. get_gems(),
                ["inline"] = true
            })

            table.insert(webhook_args, {
                ["name"] = "Current Gold",
                ["value"] = ":coin: " .. get_gold(),
                ["inline"] = true
            })

            table.insert(webhook_args, {
                ["name"] = "Current Stardust",
                ["value"] = ":star: " .. get_stardust(),
                ["inline"] = true
            })

            table.insert(webhook_args, {
                ["name"] = "Battle Pass Tier",
                ["value"] = ":signal_strength: " .. get_battle_pass_tier(),
                ["inline"] = true
            })

            SendWebhook(webhook_args)
        end
    end
end

function webhookbanner()
    loadstring(game:HttpGet(
                   "https://raw.githubusercontent.com/Jeikaru/Roblox/main/astd-banner.lua"))()
end

function FpsBoost()
    loadstring(game:HttpGet(
                   "https://raw.githubusercontent.com/Jeikaru/Roblox/main/FpsBoost"))()
end

local linkport = ""
local linkport2 = ""

local function extractFileName(url)
    local nameWithParams = url:match("^.+/(.+)$")
    return nameWithParams:match("^[^?]+")
end

local function importMacro(url)
    local fileName = extractFileName(url)
    local savePath = folder_name .. "\\" .. fileName

    local success, response = pcall(function() return game:HttpGet(url) end)

    if success then
        writefile(savePath, response)

        local jsonData
        success, jsonData = pcall(function()
            return game:GetService("HttpService"):JSONDecode(response)
        end)

        if success then
            Rayfield:Notify({
                Title = "Macro Imported!",
                Content = "Macro Import Success!",
                Duration = 4,
                Image = 4483362458
            })
        else
            warn("Error parsing JSON: " .. jsonData)
        end
    else
        warn("Error downloading JSON: " .. response)
    end
end

local function importSettings(url)
    local fileName = extractFileName(url)
    local tempSavePath = "KarmaPanda\\ASTD\\Settings\\" .. fileName
    local success, response = pcall(function() return game:HttpGet(url) end)

    if success then
        writefile(tempSavePath, response)

        local success, jsonData = pcall(function()
            return game:GetService("HttpService"):JSONDecode(response)
        end)

        writefile(SettingsFile, response)
        delfile(tempSavePath) -- Delete the Settings.json file after userid.json is created

        if success then
            Rayfield:Notify({
                Title = "Settings Imported!",
                Content = "Settings Imported Rejoin to See the changes!",
                Duration = 4,
                Image = 4483362458
            })
        else
            warn("Error parsing JSON: " .. jsonData)
        end
    else
        warn("Error downloading JSON: " .. response)
    end
end

function AutoReplay()
    local end_gui = GUI.HUD:WaitForChild("MissionEnd")

    repeat task.wait() until end_gui.Visible

    local replay_button = end_gui:WaitForChild("BG"):WaitForChild("Actions")
                              :WaitForChild("Replay")
    local next_button = end_gui:WaitForChild("BG"):WaitForChild("Actions")
                            :WaitForChild("Next")

    while Settings.auto_replay do
        if Settings.auto_next_story and next_button.Visible then break end

        if replay_button.Visible then firesignal(replay_button.Activated) end
        task.wait(1)
    end
end

function AutoNextStory()
    local end_gui = GUI.HUD:WaitForChild("MissionEnd")

    repeat task.wait() until end_gui.Visible

    local next_button = end_gui:WaitForChild("BG"):WaitForChild("Actions")
                            :WaitForChild("Next")

    while Settings.auto_next_story do
        if next_button.Visible then firesignal(next_button.Activated) end
        task.wait(1)
    end
end

function AutoUpgrade()
    while true do
        while get_money() >= Settings.auto_upgrade_money and get_wave() >=
            Settings.auto_upgrade_wave and Settings.auto_upgrade and get_wave() <
            Settings.auto_upgrade_wave_stop do

            local units = get_units()
            local any_upgraded = false

            for _, unit in ipairs(units) do
                local unit_name = unit.Name
                if get_current_upgrade_level(unit) <
                    get_max_upgrade_level(unit_name) then
                    local args = {[1] = "Upgrade", [2] = unit}
                    game:GetService("ReplicatedStorage").Remotes.Server:InvokeServer(
                        unpack(args))
                    any_upgraded = true
                    wait(0.1)
                end
            end
            wait(1)
        end

        if get_wave() >= Settings.auto_upgrade_wave_stop then
            warn("Auto-upgrade stopped at wave", Settings.auto_upgrade_wave_stop)
            Settings.auto_upgrade = false
            break
        end

        wait(1)
    end
end

function AutoSell()
    local Wave = get_wave()

    local function units()
        local unitNames = {}
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name == "Unit" then
                local childNames = {}
                for _, unitChild in ipairs(child:GetChildren()) do
                    table.insert(childNames, unitChild.Name)
                end
                unitNames["unit"] = childNames
            end
        end
        return unitNames
    end

    local function SellUnit(unit)
        task.spawn(function()
            local has_sold = false
            local attempts = 0

            workspace.Unit.ChildRemoved:Connect(function(x)
                if unit == x then has_sold = true end
            end)
            repeat
                if not has_sold then
                    local args = {[1] = "Sell", [2] = unit}

                    game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                        unpack(args))
                    has_sold = true
                end
                attempts = attempts + 1
                task.wait(0.6)
            until has_sold or attempts >= 3
        end)
    end

    if get_wave() >= Settings.auto_upgrade_wave_sell then
        while Settings.auto_upgrade.auto_upgrade_sell do
            local unitList = units()["unit"]
            if unitList then
                for _, unitName in ipairs(unitList) do
                    local unit = workspace.Unit[unitName]
                    if unit then
                        SellUnit(unit)
                        task.wait(0.6)
                    end
                end
            else
                break
            end
            task.wait(1)
        end
    end
end

local function AutoBuffHelper(Units, unit, checks, ability_type, ability_name)
    for _, check in pairs(checks) do
        if check == "attack" then
            repeat task.wait() until not CheckAttackBuff(Units)
        elseif check == "range" then
            repeat task.wait() until not CheckRangeBuff(Units)
        end
    end

    if ability_type == "Multiple" then
        UseMultipleAbilitiesUnit(unit, "", ability_name)
    else
        UseAbilityUnit(unit, "")
    end
end

function AutoBuff()
    for k, v in pairs(Settings.auto_buff_units) do
        task.spawn(function()
            while Settings.auto_buff do
                local Units = {}

                for _, unit in pairs(get_units()) do
                    if unit.Name == k and unit:WaitForChild("SpecialMove").Value ~=
                        "" then table.insert(Units, unit) end
                end

                local checks = v["Checks"]
                local ability_type = v["Ability Type"]
                local ability_name = nil
                local time = v["Time"]

                if ability_type == "Multiple" then
                    ability_name = v["Ability Name"]
                end

                if v["Mode"] == "Box" then
                    local Units2 = {}

                    if #Units > 4 and #Units < 8 then
                        repeat
                            task.wait(1)
                            table.remove(Units, #Units)
                        until #Units == 4
                    end

                    if #Units == 8 then
                        for i = 1, 4 do
                            table.insert(Units2, Units[1])
                            table.remove(Units, 1)
                        end
                    end

                    if #Units == 4 or #Units2 == 4 then
                        for i = 1, 4 do
                            if not Settings.auto_buff or
                                Settings.auto_buff_units[k] == nil then
                                break
                            end
                            if #Units == 4 then
                                AutoBuffHelper(Units, Units[i], checks,
                                               ability_type, ability_name)
                            end
                            if #Units2 == 4 then
                                AutoBuffHelper(Units2, Units2[i], checks,
                                               ability_type, ability_name)
                            end
                            Delay(time, Settings.auto_buff and
                                      Settings.auto_buff_units[k] ~= nil)
                        end
                    end
                elseif v["Mode"] == "Pair" then
                    if #Units >= 2 then
                        for i, v in pairs(Units) do
                            if i % 2 ~= 0 then
                                AutoBuffHelper(Units, Units[i], checks,
                                               ability_type, ability_name)
                            end
                        end

                        Delay(time, Settings.auto_buff and
                                  Settings.auto_buff_units[k] ~= nil)

                        for i, v in pairs(Units) do
                            if i % 2 == 0 then
                                AutoBuffHelper(Units, Units[i], checks,
                                               ability_type, ability_name)
                            end
                        end

                        Delay(time, Settings.auto_buff and
                                  Settings.auto_buff_units[k] ~= nil)
                    end
                elseif v["Mode"] == "Spam" then
                    for i, unit in pairs(Units) do
                        AutoBuffHelper(Units, Units[i], checks, ability_type,
                                       ability_name)
                    end
                    Delay(time, Settings.auto_buff and
                              Settings.auto_buff_units[k] ~= nil)

                elseif v["Mode"] == "Cycle" then
                    local cycle_units = 8

                    if v["Cycle Units"] ~= nil then
                        cycle_units = v["Cycle Units"]
                    end

                    if #Units >= cycle_units then
                        for i, v in pairs(Units) do
                            if Settings.auto_buff and
                                Settings.auto_buff_units[k] ~= nil and #Units >=
                                cycle_units then
                                AutoBuffHelper(Units, Units[i], checks,
                                               ability_type, ability_name)
                            else
                                break
                            end
                            Delay(time,
                                  Settings.auto_buff and
                                      Settings.auto_buff_units[k] ~= nil and
                                      #Units >= cycle_units)
                        end
                    end
                end

                if v["Delay"] ~= nil then
                    Delay(v["Delay"], Settings.auto_buff)
                end

                task.wait()
            end
        end)
    end
end

local isEvolvingEXP = false

function AutoEvolveEXP()
    local function GetInventory()
        local units = game.ReplicatedStorage.Remotes.Server:InvokeServer("Data",
                                                                         "Units")
        return units
    end

    local function CountEXP()
        local inventory = GetInventory()
        local exp1 = 0
        local exp2 = 0
        local exp3 = 0
        local exp4 = 0

        for _, v in pairs(inventory) do
            if v.Name == "EXP IV" then exp4 = exp4 + 1 end

            if v.Name == "EXP III" then exp3 = exp3 + 1 end

            if v.Name == "EXP II" then exp2 = exp2 + 1 end

            if v.Name == "EXP I" then exp1 = exp1 + 1 end
        end

        return exp1, exp2, exp3, exp4
    end

    local function GetEXPUnitID(name)
        local inventory = GetInventory()

        for _, v in pairs(inventory) do
            if v.Name == name then return v.ID end
        end

        return nil
    end

    local function EvolveHelper(unit_name)
        local unit_id = GetEXPUnitID(unit_name)

        if unit_id ~= nil then
            local args = {[1] = "UpgradeUnit", [2] = unit_name, [3] = unit_id}
            game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                unpack(args))
            task.wait(0.25)
        end

        return CountEXP()
    end

    local exp1, exp2, exp3, exp4 = CountEXP()

    if exp3 >= 3 or exp2 >= 3 or exp1 >= 2 then
        isEvolvingEXP = true
        while exp3 >= 3 or exp2 >= 3 or exp1 >= 2 do
            if exp3 >= 3 then
                exp1, exp2, exp3, exp4 = EvolveHelper("EXP III")
            end

            if exp2 >= 3 then
                exp1, exp2, exp3, exp4 = EvolveHelper("EXP II")
            end

            if exp3 >= 3 or exp2 >= 3 then
                isEvolvingEXP = true
            elseif exp1 >= 2 then
                exp1, exp2, exp3, exp4 = EvolveHelper("EXP I")
            else
                break
            end
        end
        if Settings.webhook_exp_evolve then
            SendWebhook({
                {["name"] = "EXP IV", ["value"] = exp4, ["inline"] = true},
                {["name"] = "EXP III", ["value"] = exp3, ["inline"] = true},
                {["name"] = "EXP II", ["value"] = exp2, ["inline"] = true},
                {["name"] = "EXP I", ["value"] = exp1, ["inline"] = true}
            })
        end
    end

    HideSummonGUI()
    isEvolvingEXP = false
end

function AutoTower()
    local player = game:GetService("Players").LocalPlayer
    local towerteleporter = workspace.Queue.InteractionsV2:FindFirstChild(
                                "Script633")

    local function UseTeleporter(teleporter)
        if teleporter ~= nil then
            firetouchinterest(player.Character.HumanoidRootPart, teleporter, 0)
            task.wait()
            firetouchinterest(player.Character.HumanoidRootPart, teleporter, 1)
            task.wait(1)
        end
    end

    local function pressKey(keyCode)
        game:GetService("VirtualInputManager"):SendKeyEvent(true, keyCode,
                                                            false, game)
        task.wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, keyCode,
                                                            false, game)
    end

    UseTeleporter(towerteleporter)

    if player.PlayerGui.HUD.TowerLevelSelector.StoryModeChooser.StoryModeChooser
        .Visible then
        pressKey(Enum.KeyCode.BackSlash)
        task.wait(0.5)
        pressKey(Enum.KeyCode.Right)
        task.wait(0.5)
        pressKey(Enum.KeyCode.Return)
        task.wait(0.5)
        pressKey(Enum.KeyCode.BackSlash)

        game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack({
            [1] = towerteleporter.Name .. "Start"
        }))
    end
end

function AutoJoinGame()
    local function UseTeleporter(teleporter)
        if teleporter ~= nil then
            firetouchinterest(Player.Character.HumanoidRootPart, teleporter, 0)
            task.wait()
            firetouchinterest(Player.Character.HumanoidRootPart, teleporter, 1)
            task.wait(1)
        end
    end

    local function QuickStartTeleporter(teleporter)
        task.wait(1)
        Player.Character.HumanoidRootPart.CFrame =
            game:GetService("Workspace").SpawnLocation.CFrame
        task.wait(1)
        if teleporter ~= nil then
            game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                unpack({[1] = teleporter.Name .. "Start"}))
        end
    end

    if Settings.auto_evolve_exp then
        repeat task.wait() until not isEvolvingEXP or
            not Settings.auto_evolve_exp
    end

    if not Settings.auto_join_game then return end

    task.wait(Settings.auto_join_delay)

    local args = {}
    local teleporter = nil

    -- TODO: Add server hopper on teleport failed.
    if get_world() == 1 then
        -- TODO: Teleport to teleporter location if no teleporters loaded.
        local function FindTeleporter(Teleporters)
            local Found = false

            while not Found do
                for _, v in pairs(Teleporters) do
                    if v.ClassName == "Part" and
                        v.SurfaceGui.Frame.TextLabel.Text == "Empty" then
                        Found = true
                        return v
                    end
                end

                task.wait()
            end

            return nil
        end
        local function GetStoryTeleporters()
            local Teleporters = {}
            local TeleporterNames = {
                "Script170", "Script158", "Script395", "Script408", "Script523",
                "Script539", "Script573", "Script600", "Script624", "Script958"
            }

            for _, v in pairs(
                            game:GetService("Workspace").Queue.InteractionsV2:GetChildren()) do
                if table.find(TeleporterNames, v.Name) ~= nil then
                    table.insert(Teleporters, v)
                end
            end

            return Teleporters
        end
        local function GetInfiniteTeleporters()
            local Teleporters = {}
            local TeleporterNames = {
                "Script209", "Script222", "Script381", "Script405", "Script448",
                "Script58", "Script647", "Script716"
            }

            for _, v in pairs(
                            game:GetService("Workspace").Queue.InteractionsV2:GetChildren()) do
                if table.find(TeleporterNames, v.Name) ~= nil then
                    table.insert(Teleporters, v)
                end
            end

            return Teleporters
        end
        local function SetStoryMap(teleporter)
            if teleporter ~= nil then
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                    unpack({
                        [1] = teleporter.Name .. "Level",
                        [2] = tostring(Settings.auto_join_story_level),
                        [3] = false
                    }))
            end
        end
        local function SetInfiniteMap(teleporter)
            if teleporter ~= nil then
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                    unpack({
                        [1] = teleporter.Name .. "Level",
                        [2] = Settings.auto_join_infinite_level,
                        [3] = false
                    }))
            end
        end
        local function TeleportToWorld2()
            UseTeleporter(get_world_teleporter())
        end
        if Settings.auto_join_mode == "Story" then
            if Settings.auto_join_story_level > 120 then
                TeleportToWorld2()
                return
            end
            teleporter = FindTeleporter(GetStoryTeleporters())
            UseTeleporter(teleporter)
            SetStoryMap(teleporter)
        elseif Settings.auto_join_mode == "Infinite" then
            if InfiniteMapTable[Settings.auto_join_infinite_level] == "Gauntlet" or
                InfiniteMapTable[Settings.auto_join_infinite_level] ==
                "Training" then
                TeleportToWorld2()
                return
            end
            teleporter = FindTeleporter(GetInfiniteTeleporters())
            UseTeleporter(teleporter)
            SetInfiniteMap(teleporter)
        elseif Settings.auto_join_mode == "Adventure" then
            TeleportToWorld2()
            return
        elseif Settings.auto_join_mode == "Time Chamber" then
            UseTeleporter(game:GetService("Workspace").Queue.Interactions
                              .Script548)
        elseif Settings.auto_join_mode == "Team Event" then
            for _, v in pairs(game:GetService("Workspace").Queue:GetChildren()) do
                if v.Name == "Model" and v:FindFirstChild("PortalPart") ~= nil then
                    UseTeleporter(v:FindFirstChild("PortalPart"))
                    break
                end
            end
        elseif Settings.auto_join_mode == "Bakugan Event" then
            UseTeleporter(game:GetService("Workspace").Queue.BakuganEventArea
                              .Script412)
        end
        QuickStartTeleporter(teleporter)
    elseif get_world() == 2 then
        local function FindTeleporter(Teleporters, Mode)
            local Found = false

            while not Found do
                for _, v in pairs(Teleporters) do
                    if (Mode == nil or v.Name == Mode) and v.ClassName == "Part" and
                        v.SurfaceGui.Frame.TextLabel.Text == "Empty" then
                        Found = true
                        return v
                    end
                end

                task.wait()
            end

            return nil
        end
        local function SetStoryMap(teleporter)
            if teleporter ~= nil then
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                    unpack({
                        [1] = "StoryModeLevel",
                        [2] = tostring(Settings.auto_join_story_level),
                        [3] = true
                    }))
            end
        end
        local function SetInfiniteMap(teleporter)
            if teleporter ~= nil then
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                    unpack({
                        [1] = "InfiniteModeLevel",
                        [2] = Settings.auto_join_infinite_level,
                        [3] = false
                    }))
            end
        end
        local function SetAdventureMap(teleporter)
            if teleporter ~= nil then
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer(
                    unpack({
                        [1] = "AdventureModeLevel",
                        [2] = Settings.auto_join_adventure_level,
                        [3] = false
                    }))
            end
        end
        local function TeleportToWorld1()
            UseTeleporter(get_world_teleporter())
        end
        local teleporter = nil
        if Settings.auto_join_mode == "Story" then
            if Settings.auto_join_story_level < 121 then
                TeleportToWorld1()
                return
            end
            repeat task.wait() until #game:GetService("Workspace").Joinables:GetChildren() >
                0
            teleporter = FindTeleporter(
                             game:GetService("Workspace").Joinables:GetChildren(),
                             "StoryMode")
            UseTeleporter(teleporter)
            SetStoryMap(teleporter)
        elseif Settings.auto_join_mode == "Infinite" then
            if InfiniteMapTable[Settings.auto_join_infinite_level] == "Farm" then
                TeleportToWorld1()
                return
            end
            repeat task.wait() until #game:GetService("Workspace").Joinables:GetChildren() >
                0
            teleporter = FindTeleporter(
                             game:GetService("Workspace").Joinables:GetChildren(),
                             "InfiniteMode")
            UseTeleporter(teleporter)
            SetInfiniteMap(teleporter)
        elseif Settings.auto_join_mode == "Adventure" then
            repeat task.wait() until #game:GetService("Workspace").Joinables:GetChildren() >
                0
            teleporter = FindTeleporter(
                             game:GetService("Workspace").Joinables:GetChildren(),
                             "AdventureMode")
            UseTeleporter(teleporter)
            SetAdventureMap(teleporter)
        elseif Settings.auto_join_mode == "Time Chamber" then
            TeleportToWorld1()
            return
        elseif Settings.auto_join_mode == "Team Event" then
            TeleportToWorld1()
            return
        elseif Settings.auto_join_mode == "Bakugan Event" then
            TeleportToWorld1()
            return
        end
        QuickStartTeleporter(teleporter)
        --[[elseif get_world() == -2 then -- team event map (reaper's base)
        for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
            if v.Name == "Model" and v:FindFirstChild("Meshes/senkaimon2 (1)") ~=
                nil then
                Player.Character.HumanoidRootPart.CFrame = v:FindFirstChild(
                                                               "Meshes/senkaimon2 (1)").CFrame
                break
            end
        end]] --
    end
end

function AutoSkipGUI()
    local SummonGUI = GUI:WaitForChild("Summon")

    while Settings.auto_skip_gui do
        local status, err = pcall(function()
            -- TODO: Stop when other things are opened.
            if SummonGUI:FindFirstChild('Skip').Visible then
                game:GetService('VirtualUser'):ClickButton1(Vector2.new(
                                                                workspace.CurrentCamera
                                                                    .ViewportSize
                                                                    .X / 2,
                                                                workspace.CurrentCamera
                                                                    .ViewportSize
                                                                    .Y / 2))
            end
        end)

        if not status then print("Error on Auto Skip GUI: " .. err) end

        task.wait()
    end
end

local function AnonMode()
    local player = game.Players.LocalPlayer
    local userId = "p_" .. tostring(player.UserId)

    local success, err = pcall(function()
        local playerName = game:GetService("CoreGui").PlayerList
                               .PlayerListMaster.OffsetFrame.PlayerScrollList
                               .SizeOffsetFrame.ScrollingFrameContainer
                               .ScrollingFrameClippingFrame.ScollingFrame
                               .OffsetUndoFrame[userId].ChildrenFrame.NameFrame
                               .BGFrame.OverlayFrame.PlayerName.PlayerName

        playerName.Text = Settings.anonymous_mode_name
    end)

    if not success then warn("Failed to change name in leaderboard: " .. err) end

    if not success then warn("Failed to change name in leaderboard: " .. err) end

    local nameLabel = game:GetService("Workspace").Camera:WaitForChild(
                          Player.Name).Head:WaitForChild("NameLevelBBGUI")
                          :WaitForChild("NameFrame"):WaitForChild("TextLabel")
    nameLabel.Text = Settings.anonymous_mode_name
end

-- TODO: Change all task.spawns to coroutines for easier management on re-executes and prevent double execution of the same function.
if get_world() ~= -1 and get_world() ~= -2 then
    repeat task.wait() until not GUI:WaitForChild("LoadingScreen").Frame.Visible

    if not is_lobby() then
        CalculateTimeOffset()
        task.spawn(StartActionQueue)
        if Settings.auto_buff then task.spawn(AutoBuff) end
        if Settings.auto_vote_extreme then task.spawn(AutoVoteExtreme) end
        if Settings.auto_2x or Settings.auto_3x then
            task.spawn(AutoChangeSpeed)
        end
        if Settings.auto_battle then task.spawn(AutoBattle) end
        if Settings.auto_replay then task.spawn(AutoReplay) end
        if Settings.auto_next_story then task.spawn(AutoNextStory) end
        if Settings.macro_record then task.spawn(StartMacroRecord) end
        if Settings.macro_playback then task.spawn(StartMacroPlayback) end
        if Settings.auto_upgrade then task.spawn(AutoUpgrade) end
        if Settings.auto_upgrade_sell then task.spawn(AutoSell) end
        task.spawn(OnGameEnd)
    else
        if Settings.auto_evolve_exp then task.spawn(AutoEvolveEXP) end
        task.wait(1)
        if Settings.auto_join_game then task.spawn(AutoJoinGame) end
        if Settings.auto_join_tower then task.spawn(AutoTower) end
        task.spawn(webhookbanner)
    end

    if Settings.auto_skip_gui then task.spawn(AutoSkipGUI) end
    if Settings.FPSBoost then task.spawn(FpsBoost) end
    if Settings.anonymous_mode then task.spawn(AnonMode) end
end

if get_world() == -2 and Settings.auto_join_game then task.spawn(AutoJoinGame) end

-- Tasks that run regardless if its in lobby or in game.
task.spawn(function()
    if Settings.disable_3d_rendering then
        game:GetService("RunService"):Set3dRenderingEnabled(
            not Settings.disable_3d_rendering)
    end
    if Settings.anti_afk then
        for _, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
            v:Disable()
        end
    end
end)

print("[KarmaPanda] Functions Loaded: " .. os.clock() - benchmark_time)
benchmark_time = os.clock()

local function CreateHideButtonGUI()
    loadstring(game:HttpGet(
                   'https://raw.githubusercontent.com/Jeikaru/Roblox/main/HideGui'))()
end

local function CreateMiniGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = GUI

    local MiniFrame = Instance.new("Frame")
    MiniFrame.Size = UDim2.new(0, 150, 0, 30)
    MiniFrame.Position = UDim2.new(1, -150, 0, 0)
    MiniFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    MiniFrame.BorderSizePixel = 0
    MiniFrame.Active = true
    MiniFrame.Draggable = true
    MiniFrame.Parent = ScreenGui

    local miniLabel = Instance.new("TextLabel")
    miniLabel.Size = UDim2.new(1, 0, 1, 0)
    miniLabel.Position = UDim2.new(0, 0, 0, 0)
    miniLabel.BackgroundTransparency = 1
    miniLabel.Text = "Playback UI"
    miniLabel.Font = Enum.Font.SourceSansBold
    miniLabel.TextSize = 18
    miniLabel.TextColor3 = Color3.new(1, 1, 1)
    miniLabel.Parent = MiniFrame

    local miniArrowButton = Instance.new("TextButton")
    miniArrowButton.Size = UDim2.new(0, 20, 0, 20)
    miniArrowButton.Position = UDim2.new(1, -25, 0, 5)
    miniArrowButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    miniArrowButton.Text = "v"
    miniArrowButton.Font = Enum.Font.SourceSans
    miniArrowButton.TextSize = 14
    miniArrowButton.TextColor3 = Color3.new(1, 1, 1)
    miniArrowButton.Parent = MiniFrame

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 150, 0, 150)
    Frame.Position = UDim2.new(0, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Visible = false -- Initially hidden
    Frame.Parent = MiniFrame

    local borderThickness = 6

    local function createBorder(parent, color, size, position)
        local border = Instance.new("Frame")
        border.Size = size
        border.Position = position
        border.BackgroundColor3 = color
        border.BorderSizePixel = 0
        border.Parent = parent
    end

    createBorder(Frame, Color3.fromRGB(55, 55, 55),
                 UDim2.new(1, 0, 0, borderThickness), UDim2.new(0, 0, 0, 0))
    createBorder(Frame, Color3.fromRGB(55, 55, 55),
                 UDim2.new(1, 0, 0, borderThickness),
                 UDim2.new(0, 0, 1, -borderThickness))
    createBorder(Frame, Color3.fromRGB(55, 55, 55),
                 UDim2.new(0, borderThickness, 1, 0), UDim2.new(0, 0, 0, 0))
    createBorder(Frame, Color3.fromRGB(55, 55, 55),
                 UDim2.new(0, borderThickness, 1, 0),
                 UDim2.new(1, -borderThickness, 0, 0))

    local timerLabel = Instance.new("TextLabel")
    timerLabel.Size = UDim2.new(1, -borderThickness * 2, 0, 20)
    timerLabel.Position = UDim2.new(0, borderThickness, 0, borderThickness)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "Game Time: nil"
    timerLabel.Font = Enum.Font.SourceSans
    timerLabel.TextSize = 14
    timerLabel.TextColor3 = Color3.new(1, 1, 1)
    timerLabel.Parent = Frame

    local playbackLabel = Instance.new("TextLabel")
    playbackLabel.Size = UDim2.new(1, -borderThickness * 2, 1,
                                   -borderThickness * 3 - 20)
    playbackLabel.Position = UDim2.new(0, borderThickness, 0,
                                       borderThickness * 2 + 20)
    playbackLabel.BackgroundTransparency = 1
    playbackLabel.Text = "Loading..."
    playbackLabel.Font = Enum.Font.SourceSans
    playbackLabel.TextSize = 14
    playbackLabel.TextColor3 = Color3.new(1, 1, 1)
    playbackLabel.TextWrapped = true
    playbackLabel.TextYAlignment = Enum.TextYAlignment.Top
    playbackLabel.Parent = Frame

    local isOpen = false

    local function toggleGUI() -- fixed
        isOpen = not isOpen
        Frame.Visible = isOpen
        miniArrowButton.Text = isOpen and "^" or "v"
    end

    miniArrowButton.MouseButton1Click:Connect(toggleGUI)

    local lastUpdateTime = 0
    local updateInterval = 0.5

    local function Update()
        if not isOpen then return end

        local currentTime = tick()
        if currentTime - lastUpdateTime >= updateInterval then
            local elapsed = ElapsedTime()
            local mins = math.floor(elapsed / 60)
            local secs = elapsed % 60
            timerLabel.Text = string.format("Game Time: %d:%02d", mins, secs)

            if CurrentStep ~= nil then
                local MacroCurrentStep =
                    Macros[Settings.macro_profile]["Macro"][CurrentStep]

                if MacroCurrentStep then
                    local Target = MacroCurrentStep["Target"]
                    local TargetName = Target and Target["Name"] or "Unknown"
                    local TargetIndex = Target and Target["Index"] or "N/A"
                    local Time = MacroCurrentStep["Time"] or "N/A"
                    local Remote = MacroCurrentStep["Remote"] and
                                       MacroCurrentStep["Remote"][1] or "N/A"
                    local Parameters = MacroCurrentStep["Parameter"]

                    local parameterString = ""
                    if Parameters then
                        for k, v in pairs(Parameters) do
                            parameterString =
                                parameterString .. tostring(k) .. ": " ..
                                    tostring(v) .. "; "
                        end
                    end

                    playbackLabel.Text = string.format(
                                             "Current Step: %s\nTarget: %s[%s]\nTime: %s\nAction: %s\nParameters: %s",
                                             tostring(CurrentStep),
                                             tostring(TargetName),
                                             tostring(TargetIndex),
                                             tostring(Time), tostring(Remote),
                                             tostring(parameterString))
                end
            end
            lastUpdateTime = currentTime
        end
    end
    if Settings.macro_playback then
        game:GetService("RunService").Heartbeat:Connect(Update)
    end
end

function InitializeUI()
    local UnitList = get_all_units()

    local function MainSettings()
        local Main = Window:CreateTab("Main", 4483362458)
        local GameplayScriptsSection = Main:CreateSection("Gameplay Scripts")
        local AutoBuffToggle = Main:CreateToggle({
            Name = "Auto Unit Buffing",
            CurrentValue = Settings.auto_buff,
            Callback = function(value)
                Settings.auto_buff = value
                Save()
                if not is_lobby() and value then AutoBuff() end
            end,
            SectionParent = GameplayScriptsSection
        })
        local AutoUpgradeToggle = Main:CreateToggle({
            Name = "Auto Upgrade",
            CurrentValue = Settings.auto_upgrade,
            Callback = function(value)
                Settings.auto_upgrade = value
                Save()
                if not is_lobby() and value then AutoUpgrade() end
            end,
            SectionParent = GameplayScriptsSection
        })
        local AutoSellToggle = Main:CreateToggle({
            Name = "Auto Sell",
            CurrentValue = Settings.auto_upgrade_sell,
            Callback = function(value)
                Settings.auto_upgrade_sell = value
                Save()
                if not is_lobby() and value then AutoSell() end
            end,
            SectionParent = GameplayScriptsSection
        })
        local GUIScriptsSection = Main:CreateSection("GUI Scripts")
        local AutoVoteExtremeToggle = Main:CreateToggle({
            Name = "Auto Vote Extreme Mode",
            CurrentValue = Settings.auto_vote_extreme,
            Callback = function(value)
                Settings.auto_vote_extreme = value
                Save()
                if not is_lobby() and value then
                    AutoVoteExtreme()
                end
            end,
            SectionParent = GUIScriptsSection
        })
        local Auto2XToggle = Main:CreateToggle({
            Name = "Auto 2x Speedup",
            CurrentValue = Settings.auto_2x,
            Callback = function(value)
                Settings.auto_2x = value
                Save()

                if not is_lobby() and value then
                    AutoChangeSpeed()
                end
            end,
            SectionParent = GUIScriptsSection
        })
        local Auto3XToggle = Main:CreateToggle({
            Name = "Auto 3x Speedup",
            CurrentValue = Settings.auto_3x,
            Callback = function(value)
                Settings.auto_3x = value
                Save()

                if not is_lobby() and value then
                    AutoChangeSpeed()
                end
            end,
            SectionParent = GUIScriptsSection
        })
        local GameEndScriptsSection = Main:CreateSection("Game End Scripts")
        local AutoReplayToggle = Main:CreateToggle({
            Name = "Auto Replay",
            CurrentValue = Settings.auto_replay,
            SectionParent = GameEndScriptsSection,
            Callback = function(value)
                Settings.auto_replay = value
                Save()
                if not is_lobby() and value then AutoReplay() end
            end
        })
        local AutoNextStoryToggle = Main:CreateToggle({
            Name = "Auto Next Story",
            CurrentValue = Settings.auto_next_story,
            SectionParent = GameEndScriptsSection,
            Callback = function(value)
                Settings.auto_next_story = value
                Save()
                if not is_lobby() and value then AutoNextStory() end
            end
        })
        local AutoBattleToggle = Main:CreateToggle({
            Name = "Auto Battle",
            CurrentValue = Settings.auto_battle,
            SectionParent = GUIScriptsSection,
            Callback = function(value)
                Settings.auto_battle = value
                Save()
                if not is_lobby() and value then AutoBattle() end
            end
        })
    end

    local function MacroSettings()
        local Macro = Window:CreateTab("Macro", 4483362458)
        local MacrosSection = Macro:CreateSection("Macros")
        local MacroProfileDropdown = Macro:OldCreateDropdown({
            Name = "Selected Profile",
            Options = MacroProfileList,
            CurrentOption = Settings.macro_profile,
            Callback = function(value)
                Settings.macro_profile = value
                if Macros[Settings.macro_profile] == nil then
                    Macros[Settings.macro_profile] = {}
                end
                Save()
            end,
            SectionParent = MacrosSection
        })
        local MacroProfileInfo = Macro:CreateParagraph({
            Title = "Current Profile Info",
            Content = string.format("Waiting for information...\n"),
            SectionParent = MacrosSection
        })
        task.spawn(function()
            while MacroProfileInfo ~= nil do
                if Macros[Settings.macro_profile]["Macro"] ~= nil and
                    Macros[Settings.macro_profile]["Units"] ~= nil then
                    MacroProfileInfo:Set({
                        Title = "Current Profile Info",
                        Content = string.format("Total Steps: %s\nUnits: %s",
                                                tostring(
                                                    #Macros[Settings.macro_profile]["Macro"]),
                                                table.concat(
                                                    get_keys(
                                                        Macros[Settings.macro_profile]["Units"]),
                                                    ", "))
                    })
                end
                task.wait()
            end
        end)
        local ControlsSection = Macro:CreateSection("Controls")
        local RecordMacroToggle = Macro:CreateToggle({
            Name = "Record Macro",
            CurrentValue = Settings.macro_record,
            Callback = function(value)
                Settings.macro_record = value
                Save()

                if not is_lobby() then
                    if value then
                        StartMacroRecord()
                    else
                        StopMacroRecord()
                    end
                end
            end,
            SectionParent = ControlsSection
        })
        local PlaybackMacroToggle = Macro:CreateToggle({
            Name = "Playback Macro",
            CurrentValue = Settings.macro_playback,
            Callback = function(value)
                Settings.macro_playback = value
                Save()

                if not is_lobby() then
                    if value then
                        Rayfield:Notify({
                            Title = "Macro Playback",
                            Content = "Starting Macro Playback...",
                            Duration = 6.5,
                            Image = 4483362458
                        })
                        StartMacroPlayback()
                    else
                        Rayfield:Notify({
                            Title = "Macro Playback",
                            Content = "Stopping Macro Playback...",
                            Duration = 6.5,
                            Image = 4483362458
                        })
                        StopMacroPlayback()
                    end
                end
            end,
            SectionParent = ControlsSection
        })
        local MacroStatus = Macro:CreateParagraph({
            Title = "Status",
            Content = "Waiting for status...\n\n\n\n\n\n",
            SectionParent = ControlsSection
        })
        task.spawn(function()
            while MacroStatus ~= nil do
                if CurrentStep ~= nil then
                    local MacroCurrentStep =
                        Macros[Settings.macro_profile]["Macro"][CurrentStep]

                    if MacroCurrentStep ~= nil then
                        local Target = nil
                        local TargetName = nil
                        local TargetIndex = nil
                        local Time = MacroCurrentStep["Time"]
                        local Remote = nil
                        local Parameters = nil

                        if MacroCurrentStep["Target"] ~= nil then
                            Target = MacroCurrentStep["Target"]

                            if Target ~= nil then
                                TargetName = Target["Name"]
                                TargetIndex = Target["Index"]
                            end
                        end

                        if MacroCurrentStep["Remote"] ~= nil then
                            Remote = MacroCurrentStep["Remote"][1]
                        end

                        if MacroCurrentStep["Parameter"] ~= nil then
                            Parameters = ""
                            for k, v in pairs(MacroCurrentStep["Parameter"]) do
                                Parameters =
                                    Parameters .. tostring(k) .. ": " ..
                                        tostring(v) .. "; "
                            end
                        end

                        MacroStatus:Set({
                            Title = "Status",
                            Content = string.format(
                                "Current Step: %s\nTarget: %s[%s]\nTime: %s\nGame Elapsed Time: %s\nAction: %s\nParameters: %s",
                                tostring(CurrentStep), tostring(TargetName),
                                tostring(TargetIndex), tostring(Time),
                                tostring(ElapsedTime()), tostring(Remote),
                                tostring(Parameters))
                        })
                    else
                        MacroStatus:Set({
                            Title = "Status",
                            Content = string.format(
                                "Error at step %s!\nGame Elapsed Time: %s",
                                tostring(CurrentStep), tostring(ElapsedTime()))
                        })
                    end
                else
                    MacroStatus:Set({
                        Title = "Status",
                        Content = string.format(
                            "Idle...\nGame Elapsed Time: %s",
                            tostring(ElapsedTime()))
                    })
                end

                task.wait()
            end
        end)
        local PreviousStepButton = Macro:CreateButton({
            Name = "Previous Macro Step",
            Callback = function()
                if CurrentStep ~= nil and CurrentStep > 0 then
                    CurrentStep = CurrentStep - 1
                else
                    CurrentStep = 1
                end
            end,
            SectionParent = ControlsSection
        })
        local NextStepButton = Macro:CreateButton({
            Name = "Next Macro Step",
            Callback = function()
                if (CurrentStep == nil or CurrentStep < 0) and
                    #Macros[Settings.macro_profile]["Macro"] > 0 then
                    CurrentStep = 1
                elseif CurrentStep ~= nil and CurrentStep > 0 and CurrentStep <
                    #Macros[Settings.macro_profile]["Macro"] then
                    CurrentStep = CurrentStep + 1
                end
            end,
            SectionParent = ControlsSection
        })
        local ResetStepButton = Macro:CreateButton({
            Name = "Reset Macro Step",
            Callback = function()
                if CurrentStep ~= nil then CurrentStep = nil end
            end,
            SectionParent = ControlsSection
        })
        local ProfileManagementSection =
            Macro:CreateSection("Profile Management")
        local ProfileNameInput = ""
        Macro:CreateInput({
            Name = "New macro profile name",
            PlaceholderText = "Default Profile",
            RemoveTextAfterFocusLost = false,
            Callback = function(text) ProfileNameInput = text end,
            SectionParent = ProfileManagementSection
        })
        local CreateNewMacroProfileButton =
            Macro:CreateButton({
                Name = "Create new macro profile",
                Callback = function()
                    local profile_name = ProfileNameInput

                    if string.match(profile_name, '[^%w%s]') ~= nil then
                        Rayfield:Notify({
                            Title = "Macro",
                            Content = string.format(
                                "%s contains illegal characters!", profile_name),
                            Duration = 6.5,
                            Image = 4483362458
                        })
                    elseif Macros[profile_name] ~= nil then
                        Rayfield:Notify({
                            Title = "Macro",
                            Content = string.format("Macro %s already exists!",
                                                    profile_name),
                            Duration = 6.5,
                            Image = 4483362458
                        })
                    else
                        Macros[profile_name] = DeepCopy(
                                                   IndividualMacroDefaultSettings)
                        Settings.macro_profile = profile_name
                        Save()
                        table.insert(MacroProfileList, profile_name)
                        MacroProfileDropdown:Refresh(MacroProfileList,
                                                     Settings.macro_profile)
                        MacroProfileDropdown:Set(Settings.macro_profile)
                        Rayfield:Notify({
                            Title = "Macro",
                            Content = string.format("Created macro %s!",
                                                    profile_name),
                            Duration = 6.5,
                            Image = 4483362458
                        })
                    end
                end,
                SectionParent = ProfileManagementSection
            })
        Macro:CreateInput({
            Name = "Import Macro",
            PlaceholderText = "Place Link Here",
            RemoveTextAfterFocusLost = false,
            Callback = function(text) linkport = text end,
            SectionParent = ProfileManagementSection
        })
        Macro:CreateButton({
            Name = "Import Start",
            Callback = function() importMacro(linkport) end,
            SectionParent = ProfileManagementSection
        })
        local DeleteMacroProfileButton =
            Macro:CreateButton({
                Name = "Delete selected profile",
                Callback = function()
                    if #MacroProfileList == 1 then
                        Rayfield:Notify({
                            Title = "Macro",
                            Content = "Cannot remove last macro in list!",
                            Duration = 6.5,
                            Image = 4483362458
                        })
                        return
                    else
                        Rayfield:Notify({
                            Title = "Macro",
                            Content = "Are you sure you want to delete the current profile?",
                            Duration = 6.5,
                            Image = 4483362458,
                            Actions = {
                                Ignore = {
                                    Name = "Yes",
                                    Callback = function()
                                        local removed_profile_name =
                                            Settings.macro_profile
                                        delfile(
                                            folder_name .. "\\" ..
                                                Settings.macro_profile ..
                                                ".json")
                                        Macros[Settings.macro_profile] = nil
                                        table.remove(MacroProfileList,
                                                     table.find(
                                                         MacroProfileList,
                                                         removed_profile_name))
                                        for _, v in pairs(MacroProfileList) do
                                            if v ~= nil then
                                                Settings.macro_profile = v
                                                break
                                            end
                                        end
                                        Save()
                                        MacroProfileDropdown:Refresh(
                                            MacroProfileList,
                                            Settings.macro_profile)
                                        MacroProfileDropdown:Set(
                                            Settings.macro_profile)
                                        Rayfield:Notify({
                                            Title = "Macro",
                                            Content = string.format(
                                                "Successfully removed macro profile %s!",
                                                removed_profile_name),
                                            Duration = 6.5,
                                            Image = 4483362458
                                        })
                                    end
                                }
                            }
                        })
                    end
                end,
                SectionParent = ProfileManagementSection
            })
        Macro:CreateInput({
            Name = "Import Settings",
            PlaceholderText = "Place Link Here",
            RemoveTextAfterFocusLost = false,
            Callback = function(text) linkport2 = text end,
            SectionParent = ProfileManagementSection
        })
        Macro:CreateButton({
            Name = "Import Start",
            Callback = function() importSettings(linkport2) end,
            SectionParent = ProfileManagementSection
        })
        local ClearMacroProfileButton = Macro:CreateButton({
            Name = "Clear all macro data on selected profile",
            Callback = function()
                Rayfield:Notify({
                    Title = "Macro",
                    Content = "Are you sure you want to clear the current profile?",
                    Duration = 6.5,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Yes",
                            Callback = function()
                                Macros[Settings.macro_profile] = DeepCopy(
                                                                     IndividualMacroDefaultSettings)
                                CurrentStep = nil
                                Save()
                                Rayfield:Notify({
                                    Title = "Macro",
                                    Content = "Selected profile has been cleared.",
                                    Duration = 6.5,
                                    Image = 4483362458
                                })
                            end
                        }
                    }
                })
            end,
            SectionParent = ProfileManagementSection
        })
        local RecordingOptionsSection = Macro:CreateSection("Recording Options")
        Macro:CreateParagraph({
            Title = "Recording Options",
            Content = "These settings will affect any recorded macro and should not be changed unless you have any issues with macro recording. Check if you have any issues using playback offset first before playing with recording offset. This option, however, could be useful if you load in after the game already started.",
            SectionParent = RecordingOptionsSection
        })
        -- TODO: Convert all sliders to input or make sliders mobile friendly.
        --[[Macro:CreateInput({
            Name = "Time Offset",
            Info = "Positive time offset means that actions will performed earlier. Negative time offset means that actions will be performed later."
            CurrentValue = Settings.macro_record_time_offset,
            Callback = function(value)
                Settings.macro_record_time_offset = value
                Save()
            end
        })]] --
        Macro:CreateSlider({
            Name = "Time Offset",
            Range = {-10, 10},
            Increment = 0.1,
            CurrentValue = Settings.macro_record_time_offset,
            Callback = function(value)
                Settings.macro_record_time_offset = value
                Save()
            end,
            SectionParent = RecordingOptionsSection
        })
        local PlaybackOptionsSection = Macro:CreateSection("Playback Options")
        Macro:CreateParagraph({
            Title = "Playback Options",
            Content = "These settings will only apply during macro playback and will not affect any previously recorded macros. Changing time offset here can affect how a recorded macro is played back and fix issues with playing back macro recorded with a different offset.",
            SectionParent = PlaybackOptionsSection
        })
        Macro:CreateToggle({
            Name = "Money Tracking",
            Info = "Waits until you have enough $ before calling remote.",
            CurrentValue = Settings.macro_money_tracking,
            Callback = function(value)
                Settings.macro_money_tracking = value
                Save()
            end,
            SectionParent = PlaybackOptionsSection
        })
        Macro:CreateSlider({
            Name = "Time Offset",
            Range = {-10, 10},
            Increment = 0.1,
            CurrentValue = Settings.macro_playback_time_offset,
            Callback = function(value)
                Settings.macro_playback_time_offset = value
                Save()
            end,
            SectionParent = PlaybackOptionsSection
        })
        Macro:CreateSlider({
            Name = "Magnitude",
            Info = "Finds units with less than or equal magnitude to the slider.",
            Range = {0, 2},
            Increment = 0.01,
            CurrentValue = Settings.macro_magnitude,
            Callback = function(value)
                Settings.macro_magnitude = value
                Save()
            end,
            SectionParent = PlaybackOptionsSection
        })
        Macro:CreateSlider({
            Name = "Attempts before action skip",
            Info = "# of attempts finding unit within magnitude before skipping action.",
            Range = {0, 120},
            Increment = 1,
            CurrentValue = Settings.macro_playback_search_attempts,
            Callback = function(value)
                Settings.macro_playback_search_attempts = value
                Save()
            end,
            SectionParent = PlaybackOptionsSection
        })
        Macro:CreateSlider({
            Name = "Action skip search delay",
            Info = "Delay for the unit search loop.",
            Range = {0, 1},
            Increment = 0.01,
            CurrentValue = Settings.macro_playback_search_delay,
            Callback = function(value)
                Settings.macro_playback_search_delay = value
                Save()
            end,
            SectionParent = PlaybackOptionsSection
        })
        local MacroOptionsSection = Macro:CreateSection("Macro Options")
        Macro:CreateParagraph({
            Title = "Macro Options",
            Content = "You should leave all of these toggles on, otherwise your macro will not work properly. However, if you don't want certain actions being recorded or played back, you can toggle those options to disable that type of action.",
            SectionParent = MacroOptionsSection
        })
        Macro:OldCreateDropdown({
            Name = "Elapsed Time Mode",
            Options = {"Version 2", "Version 1"},
            CurrentOption = Settings.macro_timer_version,
            Callback = function(Option)
                Settings.macro_timer_version = Option
                Save()
            end,
            SectionParent = MacroOptionsSection
        })
        Macro:CreateToggle({
            Name = "Summon Unit",
            CurrentValue = Settings.macro_summon,
            Callback = function(value)
                Settings.macro_summon = value
                Save()
            end,
            SectionParent = MacroOptionsSection
        })
        Macro:CreateToggle({
            Name = "Sell Unit",
            CurrentValue = Settings.macro_sell,
            Callback = function(value)
                Settings.macro_sell = value
                Save()
            end,
            SectionParent = MacroOptionsSection
        })
        Macro:CreateToggle({
            Name = "Upgrade Unit",
            CurrentValue = Settings.macro_upgrade,
            Callback = function(value)
                Settings.macro_upgrade = value
                Save()
            end,
            SectionParent = MacroOptionsSection
        })
        Macro:CreateToggle({
            Name = "Change Unit Priority",
            CurrentValue = Settings.macro_priority,
            Callback = function(value)
                Settings.macro_priority = value
                Save()
            end,
            SectionParent = MacroOptionsSection
        })
        Macro:CreateToggle({
            Name = "Unit Ability",
            CurrentValue = Settings.macro_ability,
            Callback = function(value)
                Settings.macro_ability = value
                Save()
            end,
            SectionParent = MacroOptionsSection
        })
        Macro:CreateToggle({
            Name = "Unit Auto Ability",
            CurrentValue = Settings.macro_auto_ability,
            Callback = function(value)
                Settings.macro_auto_ability = value
                Save()
            end,
            SectionParent = MacroOptionsSection
        })
        Macro:CreateToggle({
            Name = "Skip Wave",
            CurrentValue = Settings.macro_skipwave,
            Callback = function(value)
                Settings.macro_skipwave = value
                Save()
            end,
            SectionParent = MacroOptionsSection
        })
        Macro:CreateToggle({
            Name = "Auto Skip Wave",
            CurrentValue = Settings.macro_autoskipwave,
            Callback = function(value)
                Settings.macro_autoskipwave = value
                Save()
            end,
            SectionParent = MacroOptionsSection
        })
        Macro:CreateToggle({
            Name = "Speed Change",
            CurrentValue = Settings.macro_speedchange,
            Callback = function(value)
                Settings.macro_speedchange = value
                Save()
            end,
            SectionParent = MacroOptionsSection
        })
        local AbilityBlacklistConfigurationSection =
            Macro:CreateSection("Ability Blacklist Configuration")
        Macro:CreateParagraph({
            Title = "Ability Blacklist",
            Content = "The ability blacklist allows you to filter out which characters you want to not have the macro record and/or playback. Usually this blacklist should contain all units that are being used in the auto unit buffing gameplay script.",
            SectionParent = AbilityBlacklistConfigurationSection
        })

        local AbilityBlacklistDropdown

        if #Settings.macro_ability_blacklist > 0 then
            AbilityBlacklistDropdown = Macro:OldCreateDropdown({
                Name = "Blacklisted Units",
                Options = Settings.macro_ability_blacklist,
                CurrentOption = Settings.macro_ability_blacklist[#Settings.macro_ability_blacklist],
                Callback = function(Option) end,
                SectionParent = AbilityBlacklistConfigurationSection
            })
        else
            AbilityBlacklistDropdown = Macro:OldCreateDropdown({
                Name = "Blacklisted Units",
                Options = {"None"},
                CurrentOption = "None",
                Callback = function(Option) end,
                SectionParent = AbilityBlacklistConfigurationSection
            })
        end

        local AbilityBlacklistUnitListDropdown =
            Macro:OldCreateDropdown({
                Name = "Unit List",
                Options = {"None"},
                CurrentOption = "None",
                Callback = function(Option) end,
                SectionParent = AbilityBlacklistConfigurationSection
            })

        if #UnitList > 0 then
            AbilityBlacklistUnitListDropdown:Refresh(UnitList, UnitList[1])
            AbilityBlacklistUnitListDropdown:Set(UnitList[1])
        end

        local AbilityBlacklistAdd = Macro:CreateButton({
            Name = "Add selected unit from unit list to ability blacklist",
            Callback = function()
                local v = AbilityBlacklistUnitListDropdown.CurrentOption
                if table.find(Settings.macro_ability_blacklist, v) == nil then
                    table.insert(Settings.macro_ability_blacklist, v)
                    Save()
                    AbilityBlacklistDropdown:Refresh(
                        Settings.macro_ability_blacklist, v)
                    AbilityBlacklistDropdown:Set(v)
                    Rayfield:Notify({
                        Title = "Ability Blacklist",
                        Content = string.format(
                            "Unit %s added to ability blacklist", v),
                        Duration = 6.5,
                        Image = 4483362458
                    })
                else
                    Rayfield:Notify({
                        Title = "Ability Blacklist",
                        Content = "Unit already exists in ability blacklist",
                        Duration = 6.5,
                        Image = 4483362458
                    })
                end
            end,
            SectionParent = AbilityBlacklistConfigurationSection
        })

        local AbilityBlacklistDelete = Macro:CreateButton({
            Name = "Delete selected blacklisted unit from ability blacklist",
            Callback = function()
                local v = AbilityBlacklistDropdown.CurrentOption
                local idx = table.find(Settings.macro_ability_blacklist, v)
                if idx ~= nil then
                    table.remove(Settings.macro_ability_blacklist, idx)
                    Save()
                    AbilityBlacklistDropdown:Refresh(
                        Settings.macro_ability_blacklist,
                        Settings.macro_ability_blacklist[#Settings.macro_ability_blacklist])
                    AbilityBlacklistDropdown:Set(
                        Settings.macro_ability_blacklist[#Settings.macro_ability_blacklist])
                    Rayfield:Notify({
                        Title = "Ability Blacklist",
                        Content = string.format(
                            "Unit %s removed from ability blacklist", v),
                        Duration = 6.5,
                        Image = 4483362458
                    })
                else
                    Rayfield:Notify({
                        Title = "Ability Blacklist",
                        Content = string.format(
                            "Unit %s does not exist in ability blacklist", v),
                        Duration = 6.5,
                        Image = 4483362458
                    })
                end
            end,
            SectionParent = AbilityBlacklistConfigurationSection
        })

        if not is_lobby() then
            local OffsetSettingsSection = Macro:CreateSection("Offset Settings")
            Macro:CreateParagraph({
                Title = "CAUTION",
                Content = "This is a experimental feature that allows you to shift all unit positions to their new locations if the map coordinates have changed due to an update. However, you need to have saved the previous spawn position to the macro profile before the game update for this to work. All changes are irreversible, so please use with caution.",
                SectionParent = OffsetSettingsSection
            })
            local SetMacroMapButton = Macro:CreateButton({
                Name = "Save current spawn position to selected macro profile",
                Callback = function()
                    Macros[Settings.macro_profile]["Map"] = {
                        ["SpawnLocation"] = tostring(
                            game:GetService("Workspace").SpawnLocation.CFrame)
                    }
                    Save()
                    Rayfield:Notify({
                        Title = "Macro",
                        Content = "Current map has been set to macro profile.",
                        Duration = 6.5,
                        Image = 4483362458
                    })
                end,
                SectionParent = OffsetSettingsSection
            })
            local SetMacroMapOffsetButton =
                Macro:CreateButton({
                    Name = "Update placement locations, if game shifted map positions.",
                    Callback = function()
                        if Macros[Settings.macro_profile]["Map"] ~= nil then
                            local SpawnLocation =
                                Macros[Settings.macro_profile]["Map"]["SpawnLocation"]

                            if SpawnLocation ~= nil then
                                local offset =
                                    game:GetService("Workspace").SpawnLocation
                                        .CFrame *
                                        StringToCFrame(SpawnLocation):Inverse()

                                for _, v in pairs(
                                                Macros[Settings.macro_profile]["Units"]) do
                                    v["Position"] = v["Position"] * offset
                                end
                            end
                        end

                        Macros[Settings.macro_profile]["Map"] = {
                            ["SpawnLocation"] = tostring(
                                game:GetService("Workspace").SpawnLocation
                                    .CFrame)
                        }
                        Save()
                    end,
                    SectionParent = OffsetSettingsSection
                })
        end
    end

    local function AdvancedSettings()
        local AdvancedSettingsTab = Window:CreateTab("Advanced Settings",
                                                     4483362458)
        local function AutoUnitBuffingSettings()
            local AutoUnitBuffingSection =
                AdvancedSettingsTab:CreateSection("Auto Unit Buffing Settings")
            AdvancedSettingsTab:CreateParagraph({
                Title = "Auto Unit Buffing Settings",
                Content = "These settings allow you to add and remove units that are used for the auto unit buffing gameplay script. In order for changes to take effect, you need to restart the auto unit buffing script after adding or removing the unit from the auto unit buffing.",
                SectionParent = AutoUnitBuffingSection
            })

            local AutoBuffUnitList = get_keys(Settings.auto_buff_units)
            local AutoBuffSelectedUnitInformation =
                AdvancedSettingsTab:CreateParagraph({
                    Title = "Selected Unit Information",
                    Content = "Waiting for selected unit...\n",
                    SectionParent = AutoUnitBuffingSection
                })

            local function AutoBuffDropdownCallback(value)
                if AutoBuffSelectedUnitInformation ~= nil and
                    Settings.auto_buff_units[value] ~= nil then
                    local content = ""

                    for k, v in pairs(Settings.auto_buff_units[value]) do
                        if type(v) == "table" then
                            content = content ..
                                          string.format("%s: %s\n", tostring(k),
                                                        table.concat(v, ", "))
                        else
                            content = content ..
                                          string.format("%s: %s\n", tostring(k),
                                                        tostring(v))
                        end
                    end

                    AutoBuffSelectedUnitInformation:Set({
                        Title = "Selected Unit Information",
                        Content = content
                    })
                end
            end

            local AutoBuffDropdown

            if #AutoBuffUnitList > 0 then
                AutoBuffDropdown = AdvancedSettingsTab:OldCreateDropdown({
                    Name = "Units",
                    Options = AutoBuffUnitList,
                    CurrentOption = AutoBuffUnitList[#AutoBuffUnitList],
                    Callback = AutoBuffDropdownCallback,
                    SectionParent = AutoUnitBuffingSection
                })
                AutoBuffSelectedUnitInformation:Set({
                    Title = "Selected Unit Information",
                    Content = string.format(
                        "Mode: %s\nChecks: %s\nAbility Type: %s\nAbility Name: %s\nTime: %s",
                        Settings.auto_buff_units[AutoBuffDropdown.CurrentOption]["Mode"],
                        table.concat(
                            Settings.auto_buff_units[AutoBuffDropdown.CurrentOption]["Checks"],
                            ", "),
                        Settings.auto_buff_units[AutoBuffDropdown.CurrentOption]["Ability Type"],
                        tostring(
                            Settings.auto_buff_units[AutoBuffDropdown.CurrentOption]["Ability Name"]),
                        tostring(
                            Settings.auto_buff_units[AutoBuffDropdown.CurrentOption]["Time"]))
                })
            else
                AutoBuffDropdown = AdvancedSettingsTab:OldCreateDropdown({
                    Name = "Units",
                    Options = {"None"},
                    CurrentOption = "None",
                    Callback = AutoBuffDropdownCallback,
                    SectionParent = AutoUnitBuffingSection
                })
            end

            local AutoBuffUnitListDropdown =
                AdvancedSettingsTab:OldCreateDropdown({
                    Name = "Unit List",
                    Options = {"None"},
                    CurrentOption = "None",
                    Callback = function(Option) end,
                    SectionParent = AutoUnitBuffingSection
                })
            if #UnitList > 0 then
                AutoBuffUnitListDropdown:Refresh(UnitList, UnitList[1])
                AutoBuffUnitListDropdown:Set(UnitList[1])
            end
            local AutoBuffModeDropdown =
                AdvancedSettingsTab:OldCreateDropdown({
                    Name = "Buffing Mode",
                    Options = {"Box", "Pair", "Cycle"},
                    CurrentOption = "Box",
                    Callback = function(Option) end,
                    SectionParent = AutoUnitBuffingSection
                })
            local AutoBuffChecks = AdvancedSettingsTab:CreateDropdown({
                Name = "Auto Buff Checks",
                Options = {"Attack Buff", "Range Buff", "Multiple Abilities"},
                CurrentOption = {"Attack Buff", "Range Buff"},
                MultiSelection = true,
                Callback = function(Option) end,
                SectionParent = AutoUnitBuffingSection
            })
            --[[local AutoBuffAttackBuffCheck =
                AdvancedSettingsTab:CreateToggle({
                    Name = "Attack Buff Check",
                    CurrentValue = true,
                    Callback = function(value) end
                })
            local AutoBuffRangeBuffCheck =
                AdvancedSettingsTab:CreateToggle({
                    Name = "Range Buff Check",
                    CurrentValue = true,
                    Callback = function(value) end
                })
            local AutoBuffMultipleAbilitiesCheck =
                AdvancedSettingsTab:CreateToggle({
                    Name = "Unit Has Multiple Abilities",
                    CurrentValue = false,
                    Callback = function(value) end
                })]] --
            local AutoBuffMultipleAbilitiesNameInput
            AdvancedSettingsTab:CreateInput({
                Name = "Multiple Abilities: Ability Name",
                Info = "Use this only if the unit you have has multiple abilities.",
                PlaceholderText = "Buff Ability",
                RemoveTextAfterFocusLost = false,
                Callback = function(text)
                    AutoBuffMultipleAbilitiesNameInput = text
                end,
                SectionParent = AutoUnitBuffingSection
            })
            local AutoBuffAbilityTime = 15
            AdvancedSettingsTab:CreateInput({
                Name = "Ability Time",
                Info = "Put the time (in seconds) it takes before buffing the next unit.",
                PlaceholderText = "15",
                NumbersOnly = true,
                RemoveTextAfterFocusLost = false,
                Callback = function(text)
                    AutoBuffAbilityTime = tonumber(text)
                end,
                SectionParent = AutoUnitBuffingSection
            })
            local CycleUnits = 8
            AdvancedSettingsTab:CreateSlider({
                Name = "Cycle Units",
                Info = "Minimum number of units before cycle mode.",
                Range = {1, 8},
                Increment = 1,
                CurrentValue = CycleUnits,
                Callback = function(value) CycleUnits = value end,
                SectionParent = AutoUnitBuffingSection
            })
            local AutoBuffDelay = 0
            AdvancedSettingsTab:CreateSlider({
                Name = "Post Loop Delay",
                Info = "Delay after loop is complete.",
                Range = {0, 60},
                Increment = 1,
                CurrentValue = AutoBuffDelay,
                Callback = function(value) AutoBuffDelay = value end,
                SectionParent = AutoUnitBuffingSection
            })
            local AutoBuffUnitAdd = AdvancedSettingsTab:CreateButton({
                Name = "Add selected unit from unit list to auto buff",
                Callback = function()
                    local v = AutoBuffUnitListDropdown.CurrentOption
                    if Settings.auto_buff_units[v] == nil then
                        local AbilityType = "Normal"
                        local AbilityName = nil

                        local Checks = {}
                        local ChecksGUI = AutoBuffChecks.CurrentOption

                        for _, v in pairs(ChecksGUI) do
                            if v == "Attack Buff" then
                                table.insert(Checks, "attack")
                            elseif v == "Range Buff" then
                                table.insert(Checks, "range")
                            elseif v == "Multiple Abilities" then
                                AbilityType = "Multiple"
                                AbilityName = AutoBuffMultipleAbilitiesNameInput
                            end
                        end

                        --[[
                        if AutoBuffAttackBuffCheck.CurrentValue then
                            table.insert(Checks, "attack")
                        end
                        if AutoBuffRangeBuffCheck.CurrentValue then
                            table.insert(Checks, "range")
                        end
                        if AutoBuffMultipleAbilitiesCheck.CurrentValue then
                            AbilityType = "Multiple"
                            AbilityName = AutoBuffMultipleAbilitiesNameInput
                        end]] --

                        local unit = {
                            ["Mode"] = AutoBuffModeDropdown.CurrentOption,
                            ["Checks"] = Checks,
                            ["Ability Type"] = AbilityType,
                            ["Ability Name"] = AbilityName,
                            ["Time"] = AutoBuffAbilityTime,
                            ["Cycle Units"] = CycleUnits,
                            ["Delay"] = AutoBuffDelay
                        }
                        Settings.auto_buff_units[v] = unit
                        Save()
                        AutoBuffDropdown:Add(v)
                        AutoBuffDropdown:Set(v)
                        Rayfield:Notify({
                            Title = "Auto Buff",
                            Content = string.format(
                                "Unit %s added to auto buff unit list", v),
                            Duration = 6.5,
                            Image = 4483362458
                        })
                    else
                        Rayfield:Notify({
                            Title = "Auto Buff",
                            Content = "Unit already exists in auto buff list",
                            Duration = 6.5,
                            Image = 4483362458
                        })
                    end
                end,
                SectionParent = AutoUnitBuffingSection
            })
            local AutoBuffUnitDelete = AdvancedSettingsTab:CreateButton({
                Name = "Delete selected auto buff unit from auto buff",
                Callback = function()
                    local v = AutoBuffDropdown.CurrentOption
                    if Settings.auto_buff_units[v] ~= nil then
                        Settings.auto_buff_units[v] = nil
                        Save()
                        AutoBuffDropdown:Remove(v)
                        Rayfield:Notify({
                            Title = "Auto Buff",
                            Content = string.format(
                                "Unit %s removed from auto buff list", v),
                            Duration = 6.5,
                            Image = 4483362458
                        })
                    else
                        Rayfield:Notify({
                            Title = "Auto Buff",
                            Content = string.format(
                                "Unit %s does not exist in auto buff list", v),
                            Duration = 6.5,
                            Image = 4483362458
                        })
                    end
                end,
                SectionParent = AutoUnitBuffingSection
            })
        end

        local function ActionQueueSettings()
            local ActionQueueSection = AdvancedSettingsTab:CreateSection(
                                           "Action Queue Settings")
            AdvancedSettingsTab:CreateParagraph({
                Title = "Action Queue",
                Content = "The action queue is used for all ingame functions in the script that calls remotes. This queue ensures that the action that is being called is executed successfully as the game has bugs where it doesn't call certain remotes due to lag or insufficient resources (cash/cooldown times).",
                SectionParent = ActionQueueSection
            })
            AdvancedSettingsTab:CreateSlider({
                Name = "Remote Action Delay",
                Info = "Delay after remote is fired.",
                Range = {0, 1},
                Increment = 0.01,
                CurrentValue = Settings.action_queue_remote_fire_delay,
                Callback = function(value)
                    Settings.action_queue_remote_fire_delay = value
                    Save()
                end,
                SectionParent = ActionQueueSection
            })
            local RemoteRefiringSection =
                AdvancedSettingsTab:CreateSection("Remote Refiring")
            AdvancedSettingsTab:CreateParagraph({
                Title = "What is remote refiring?",
                Content = "Remote refiring makes the script call the remote repeatedly until the unit successfully summons, upgrades, or uses their ability. The following parameter allows you to adjust how remote refiring works.",
                SectionParent = RemoteRefiringSection
            })
            AdvancedSettingsTab:CreateToggle({
                Name = "Refire Remote",
                CurrentValue = Settings.action_queue_remote_on_fail,
                Callback = function(value)
                    Settings.action_queue_remote_on_fail = value
                    Save()
                end,
                SectionParent = RemoteRefiringSection
            })
            AdvancedSettingsTab:CreateSlider({
                Name = "Pre Loop Delay",
                Info = "Delay after remote fired before activating remote refiring.",
                Range = {0, 1},
                Increment = 0.01,
                CurrentValue = Settings.action_queue_remote_on_fail_delay,
                Callback = function(value)
                    Settings.action_queue_remote_on_fail_delay = value
                    Save()
                end,
                SectionParent = RemoteRefiringSection
            })
            AdvancedSettingsTab:CreateSlider({
                Name = "Loop Delay",
                Info = "Delay while looping remote refiring.",
                Range = {0, 1},
                Increment = 0.01,
                CurrentValue = Settings.action_queue_remote_on_fail_delay_loop,
                Callback = function(value)
                    Settings.action_queue_remote_on_fail_delay = value
                    Save()
                end,
                SectionParent = RemoteRefiringSection
            })
        end

        local function AutomationSettings()
            local AutomationSection = AdvancedSettingsTab:CreateSection(
                                          "Automation")
            AdvancedSettingsTab:CreateParagraph({
                Title = "Automation",
                Content = "The automation is used to automatically upgrades your units, sell your units and turns on autobattle. where you can manually change the values you want",
                SectionParent = AutomationSection
            })
            AdvancedSettingsTab:CreateInput({
                Name = "Auto Battle Gems",
                Info = "Stops Auto-Battle function when its below the required gems",
                PlaceholderText = Settings.auto_battle_gems,
                RemoveTextAfterFocusLost = false,
                Callback = function(text)
                    Settings.auto_battle_gems = text
                    Save()
                end,
                SectionParent = AutomationSection
            })
            AdvancedSettingsTab:CreateInput({
                Name = "Auto Upgrade Money",
                Info = "Starts Auto Upgrade If Money is Above The Money Required",
                PlaceholderText = Settings.auto_upgrade_money,
                RemoveTextAfterFocusLost = false,
                Callback = function(text)
                    Settings.auto_upgrade_money = text
                    Save()
                end,
                SectionParent = AutomationSection
            })
            AdvancedSettingsTab:CreateInput({
                Name = "Auto Upgrade Wave",
                Info = "Starts Auto Upgrade If Wave is Exact and Above Required Value",
                PlaceholderText = Settings.auto_upgrade_wave,
                RemoveTextAfterFocusLost = false,
                Callback = function(text)
                    Settings.auto_upgrade_wave = text
                    Save()
                end,
                SectionParent = AutomationSection
            })
            AdvancedSettingsTab:CreateInput({
                Name = "Stop Auto Upgrade At Wave",
                Info = "Stops Auto Upgrade If Wave is Exact and Above Required Value",
                PlaceholderText = Settings.auto_upgrade_wave_stop,
                RemoveTextAfterFocusLost = false,
                Callback = function(text)
                    Settings.auto_upgrade_wave_stop = text
                    Save()
                end,
                SectionParent = AutomationSection
            })
            AdvancedSettingsTab:CreateInput({
                Name = "Auto Sell At Wave",
                Info = "Starts Auto Sell If Wave is Exact and Above Required Value",
                PlaceholderText = Settings.auto_upgrade_wave_sell,
                RemoveTextAfterFocusLost = false,
                Callback = function(text)
                    Settings.auto_upgrade_wave_sell = text
                    Save()
                end,
                SectionParent = AutomationSection
            })
        end

        AutoUnitBuffingSettings()
        ActionQueueSettings()
        AutomationSettings()
    end

    local function LobbySettings()
        local Lobby = Window:CreateTab("Lobby", 4483362458)
        local LobbyScriptsSection = Lobby:CreateSection("Lobby Scripts")
        Lobby:CreateToggle({
            Name = "Auto Join Game",
            Info = "Automatically joins teleporter with options defined below.",
            CurrentValue = Settings.auto_join_game,
            Callback = function(value)
                Settings.auto_join_game = value
                Save()

                if value and is_lobby() then
                    task.spawn(AutoJoinGame)
                end
            end,
            SectionParent = LobbyScriptsSection
        })
        Lobby:CreateToggle({
            Name = "Auto Join Tower",
            Info = "Automatically joins Tower to the Higest Level",
            CurrentValue = Settings.auto_join_tower,
            Callback = function(value)
                Settings.auto_join_tower = value
                Save()
                if value and is_lobby() then
                    task.spawn(AutoTower)
                end
            end,
            SectionParent = LobbyScriptsSection
        })
        Lobby:CreateToggle({
            Name = "Auto Evolve EXP",
            Info = "Automatically evolves exp units from inventory to EXP IV.",
            CurrentValue = Settings.auto_evolve_exp,
            Callback = function(value)
                Settings.auto_evolve_exp = value
                Save()

                if value and is_lobby() then
                    task.spawn(AutoEvolveEXP)
                end
            end,
            SectionParent = LobbyScriptsSection
        })
        Lobby:CreateToggle({
            Name = "Auto Click Popup",
            Info = "Automatically clicks popups on GUI when summoning or etc.",
            CurrentValue = Settings.auto_skip_gui,
            Callback = function(value)
                Settings.auto_skip_gui = value
                Save()

                if value then task.spawn(AutoSkipGUI) end
            end,
            SectionParent = LobbyScriptsSection
        })
        local AutoJoinSection = Lobby:CreateSection("Auto Join Settings")
        Lobby:CreateSlider({
            Name = "Delay",
            Info = "The script will wait for the set amount of seconds before joining teleporter.",
            Range = {0, 60},
            Increment = 1,
            CurrentValue = Settings.auto_join_delay,
            Callback = function(value)
                Settings.auto_join_delay = value
                Save()
            end,
            SectionParent = AutoJoinSection
        })
        Lobby:OldCreateDropdown({
            Name = "Mode",
            Options = {
                "Story", "Infinite", "Adventure", "Time Chamber", "Team Event",
                "Bakugan Event"
            },
            CurrentOption = Settings.auto_join_mode,
            Callback = function(value)
                Settings.auto_join_mode = value
                Save()
            end,
            SectionParent = AutoJoinSection
        })
        Lobby:CreateSlider({
            Name = "Story Level",
            Info = "Choose which level to do for story mode.",
            Range = {1, get_number_missions()},
            Increment = 1,
            CurrentValue = Settings.auto_join_story_level,
            Callback = function(value)
                Settings.auto_join_story_level = value
                Save()
            end,
            SectionParent = AutoJoinSection
        })
        if InfiniteMapTable[Settings.auto_join_infinite_level] == nil then
            Settings.auto_join_infinite_level = "-1"
            Save()
        end
        Lobby:OldCreateDropdown({
            Name = "Infinite Map Selection",
            Options = GetMapsFromTable(InfiniteMapTable),
            CurrentOption = InfiniteMapTable[Settings.auto_join_infinite_level],
            Callback = function(option)
                for k, v in pairs(InfiniteMapTable) do
                    if v == option then
                        Settings.auto_join_infinite_level = k
                        Save()
                        break
                    end
                end
            end,
            SectionParent = AutoJoinSection
        })
        if AdventureMapTable[Settings.auto_join_adventure_level] == nil then
            Settings.auto_join_adventure_level = "-1133"
            Save()
        end
        Lobby:OldCreateDropdown({
            Name = "Adventure Map Selection",
            Options = GetMapsFromTable(AdventureMapTable),
            CurrentOption = AdventureMapTable[Settings.auto_join_adventure_level],
            Callback = function(option)
                for k, v in pairs(AdventureMapTable) do
                    if v == option then
                        Settings.auto_join_adventure_level = k
                        Save()
                        break
                    end
                end
            end,
            SectionParent = AutoJoinSection
        })
    end

    local function WebhookSettings()
        local Webhook = Window:CreateTab("Webhooks", 4483362458)
        local SettingsSection = Webhook:CreateSection("Settings")
        Webhook:CreateInput({
            Name = "URL",
            Info = "Put your webhook url here",
            PlaceholderText = Settings.webhook_url,
            RemoveTextAfterFocusLost = false,
            Callback = function(text)
                Settings.webhook_url = text
                Save()
            end,
            SectionParent = SettingsSection
        })
        Webhook:CreateInput({
            Name = "Discord ID",
            Info = "Use developer mode and right click your profile to copy your id.",
            PlaceholderText = Settings.webhook_discord_id,
            RemoveTextAfterFocusLost = false,
            Callback = function(text)
                Settings.webhook_discord_id = text
                Save()
            end,
            SectionParent = SettingsSection
        })
        Webhook:CreateToggle({
            Name = "Ping User",
            Info = "Make sure to fill in your discord id before using this.",
            CurrentValue = Settings.webhook_ping_user,
            Callback = function(value)
                Settings.webhook_ping_user = value
                Save()
            end,
            SectionParent = SettingsSection
        })
        Webhook:CreateButton({
            Name = "Test Webhook",
            Callback = function()
                SendWebhook({
                    {
                        ["name"] = "Webhook Test",
                        ["value"] = "Webhook sent successfully!"
                    }
                })
            end,
            SectionParent = SettingsSection
        })
        Webhook:CreateColorPicker({
            Name = "Webhook color",
            Info = "Set the webhook color shown on the left side of the webhook.",
            Color = Color3.fromHex(Settings.webhook_color),
            Callback = function(value)
                Settings.webhook_color = value:ToHex()
                Save()
            end,
            SectionParent = SettingsSection
        })
        local TogglesSection = Webhook:CreateSection("Toggles")
        Webhook:CreateToggle({
            Name = "Send webhook on game end",
            Info = "When the game ends, a webhook will be sent.",
            CurrentValue = Settings.webhook_end_game,
            Callback = function(value)
                Settings.webhook_end_game = value
                Save()
            end,
            SectionParent = TogglesSection
        })
        Webhook:CreateToggle({
            Name = "Send webhook after exp evolve",
            Info = "When the auto EXP evolve is finished, a webhook will be sent.",
            CurrentValue = Settings.webhook_exp_evolve,
            Callback = function(value)
                Settings.webhook_exp_evolve = value
                Save()
            end,
            SectionParent = TogglesSection
        })
    end

    local function MiscellaneousSettings()
        local Miscellaneous = Window:CreateTab("Miscellaneous", 4483362458)
        local GameSettingsSection = Miscellaneous:CreateSection("Game Settings")

        Miscellaneous:CreateToggle({
            Name = "FPS Boost",
            CurrentValue = Settings.fps_boost,
            Callback = function(value)
                Settings.fps_boost = value
                Save()
            end,
            SectionParent = GameSettingsSection
        })
        Miscellaneous:CreateToggle({
            Name = "Anti-AFK",
            CurrentValue = Settings.anti_afk,
            Callback = function(value)
                Settings.anti_afk = value
                Save()
                for _, v in
                    pairs(getconnections(game.Players.LocalPlayer.Idled)) do
                    v:Disable()
                end
            end,
            SectionParent = GameSettingsSection
        })
        Miscellaneous:CreateToggle({
            Name = "Disable 3D Rendering",
            Info = "Disables 3D Rendering when enabled",
            CurrentValue = Settings.disable_3d_rendering,
            Callback = function(value)
                Settings.disable_3d_rendering = value
                Save()
                game:GetService("RunService"):Set3dRenderingEnabled(not value)
            end,
            SectionParent = GameSettingsSection
        })

        Miscellaneous:CreateToggle({
            Name = "Auto Execute",
            Info = "Auto executes script on next teleport.",
            CurrentValue = Settings.auto_execute,
            Callback = function(value)
                Settings.auto_execute = value
                Save()
                if value then library.AutoExecute() end
            end,
            SectionParent = GameSettingsSection
        })

        if get_world() ~= -1 and get_world() ~= -2 then
            Miscellaneous:CreateToggle({
                Name = "Anonymous Mode",
                Info = "Hides Your Name in Leaderboard (Client Sided).",
                CurrentValue = Settings.anonymous_mode,
                Callback = function(value)
                    Settings.anonymous_mode = value
                    Save()
                    if value then AnonMode() end
                end,
                SectionParent = GameSettingsSection
            })

            Miscellaneous:CreateInput({
                Name = "Change Name",
                Info = "Changes the name in leaderboard.",
                PlaceholderText = Settings.anonymous_mode_name,
                RemoveTextAfterFocusLost = false,
                Callback = function(text)
                    Settings.anonymous_mode_name = text
                    Save()
                    if Settings.anonymous_mode then
                        AnonMode()
                    end
                end,
                SectionParent = GameSettingsSection
            })

            local WorldTeleportsSection =
                Miscellaneous:CreateSection("World Teleports")

            local function UseWorldTeleporter(Teleporter)
                firetouchinterest(Player.Character.HumanoidRootPart, Teleporter,
                                  0)
                task.wait()
                firetouchinterest(Player.Character.HumanoidRootPart, Teleporter,
                                  1)
            end

            if get_world() == 1 then
                Miscellaneous:CreateButton({
                    Name = "Teleport to World 2",
                    Callback = function()
                        UseWorldTeleporter(get_world_teleporter())
                    end,
                    SectionParent = WorldTeleportsSection
                })
            elseif get_world() == 2 then
                Miscellaneous:CreateButton({
                    Name = "Teleport to World 1",
                    Callback = function()
                        UseWorldTeleporter(get_world_teleporter())
                    end,
                    SectionParent = WorldTeleportsSection
                })
            end
        end

        local ResetSection = Miscellaneous:CreateSection("Reset")
        -- TODO: Implement UI reload after settings are reset.
        Miscellaneous:CreateButton({
            Name = "Reset settings to default",
            Callback = function()
                Settings = DefaultSettings
                Save()
                Rayfield:Notify({
                    Title = "Reset",
                    Content = "Settings restored to default! UI Restarting in 2 seconds",
                    Duration = 6.5,
                    Image = 4483362458
                })
                task.wait(2)
                if isfile("KarmaPanda\\key.panda") then
                    library.LoadScript(readfile("KarmaPanda\\key.panda"))
                end
            end,
            SectionParent = ResetSection
        })
    end

    local function CreditsSettings()
        local Credits = Window:CreateTab("Credits", 4483362458)
        local CreditsSection = Credits:CreateSection("Credits")
        Credits:CreateParagraph({
            Title = "Made by KarmaPanda & Maintained by Jeikaru",
            Content = "Additional credits to shlex#9425 for the Rayfield UI library, as well as to Metas#7777 for the CustomField|ArrayField UI library. Thanks to all the supporters and donators of the script! Be sure to join our discord at https://discord.gg/BrnQQGKbvE to get the latest announcements and communicate with the community!",
            SectionParent = CreditsSection
        })
    end

    MainSettings()
    MacroSettings()
    LobbySettings()
    WebhookSettings()
    AdvancedSettings()
    MiscellaneousSettings()
    CreditsSettings()
    CreateMiniGUI()
    CreateHideButtonGUI()
end

InitializeUI()

print("[KarmaPanda] UI Loaded: " .. os.clock() - benchmark_time)
benchmark_time = os.clock()

if Settings.auto_execute then
    -- original authentication code has been removed.
    if not _G.auto_executed then
        _G.auto_executed = true

        loadstring(game:HttpGet(
                       "https://api.irisapp.ca/Scripts/IrisBetterCompat.lua"))()
        queue_on_teleport(loadstring(game:HttpGet(
                                         "https://raw.githubusercontent.com/KarmaPanda/Roblox/refs/heads/main/astd.lua"))())
        print("[KarmaPanda]: Queue on teleport for auto execute sucessful!")
    end
end
