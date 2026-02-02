-- [[ CONFIGURATION ]]
local Config = {
    GithubUser = "sunwurp1337",
    GithubRepo = "testUIXRoblox",
    Branch = "main",
    BrandName = "Tronwurp",
    BrandSuffix = "VIP",
    Version = "1.1.0"
}

local baseUrl = "https://raw.githubusercontent.com/" .. Config.GithubUser .. "/" .. Config.GithubRepo .. "/" .. Config.Branch .. "/"

-- [[ UI LIBRARY LOAD ]]
local success, Fluent = pcall(function()
    return loadstring(game:HttpGet(baseUrl .. "Core/library.lua"))()
end)

if not success then return end

-- [[ WINDOW SETUP ]]
local Window = Fluent:CreateWindow({
    Title = Config.BrandName .. (Config.BrandSuffix ~= "" and " <font color='rgb(255, 0, 0)'>" .. Config.BrandSuffix .. "</font>" or ""),
    SubTitle = "v" .. Config.Version .. " | by " .. Config.GithubUser,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Home = Window:AddTab({ Title = "Home", Icon = "home" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

--- [[ HOME SECTION ]] ---
local Player = game.Players.LocalPlayer
local startTime = os.time()

Tabs.Home:AddParagraph({
    Title = "Player Profile",
    Content = "Username: " .. Player.Name .. "\nRank: " .. Config.BrandSuffix .. "\nStatus: Online"
})

local PlayTimeParagraph = Tabs.Home:AddParagraph({
    Title = "Session Stats",
    Content = "Playing Time: 00:00:00"
})

task.spawn(function()
    while task.wait(1) do
        local seconds = os.time() - startTime
        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60
        PlayTimeParagraph:SetDesc("Playing Time: " .. string.format("%02d:%02d:%02d", hours, minutes, secs))
    end
end)

-- COMBAT: KILLAURA
local KillauraToggle = Tabs.Combat:AddToggle("Killaura", {
    Title = "Self-Back Killaura",
    Description = "Teleports behind nearest target and attacks.",
    Default = false,
    Callback = function(Value)
        _G.KillauraEnabled = Value
        
        if Value then
            -- Modülü her seferinde temiz bir şekilde çağır
            task.spawn(function()
                loadstring(game:HttpGet(baseUrl .. "Modules/self-back-killaura.lua"))()
            end)
            Fluent:Notify({Title = "Killaura", Content = "Activated!", Duration = 2})
        else
            -- Bağlantıyı koparmak için modül içindeki kontrolü tetikle
            Fluent:Notify({Title = "Killaura", Content = "Deactivated!", Duration = 2})
        end
    end
})

Tabs.Combat:AddKeybind("KillauraKeybind", {
    Title = "Killaura Hotkey",
    Mode = "Toggle",
    Default = "G",
    Callback = function()
        KillauraToggle:SetValue(not KillauraToggle.Value)
    end
})

-- Menzil Ayarı (Range Slider)
Tabs.Combat:AddSlider("KillauraRange", {
    Title = "Killaura Range",
    Description = "Adjust target detection distance.",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        _G.KillauraRange = Value
    end
})

--- [[ VISUALS: HUNTER VISION ]] ---
Tabs.Visuals:AddToggle("HunterVision", {
    Title = "Hunter Vision",
    Description = "ESP and invisibility detection.",
    Default = false,
    Callback = function(Value)
        _G.HunterVisionEnabled = Value
        if Value then
            loadstring(game:HttpGet(baseUrl .. "Modules/hunter-vision.lua"))()
        end
    end
})

--- [[ SETTINGS: EVENT LOGGER ]] ---
Tabs.Settings:AddToggle("EventLogger", {
    Title = "Event Logger",
    Description = "Logs remote events to console.",
    Default = false,
    Callback = function(Value)
        _G.EventLoggerEnabled = Value
        if Value then
            if not _G.LoggerConnections then
                loadstring(game:HttpGet(baseUrl .. "Modules/event-logger.lua"))()
            end
        else
            if _G.StopEventLogger then _G.StopEventLogger() end
        end
    end
})

Window:SelectTab(1)