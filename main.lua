-- [[ CONFIGURATION ]]
local Config = {
    GithubUser = "sunwurp1337",
    GithubRepo = "testUIXRoblox",
    Branch = "main",
    BrandName = "Tronwurp",
    BrandSuffix = "VIP",
    Version = "1.0.4"
}

-- Dynamic URL Generator
local baseUrl = "https://raw.githubusercontent.com/" .. Config.GithubUser .. "/" .. Config.GithubRepo .. "/" .. Config.Branch .. "/"

-- Branding Logic
local TitleString = Config.BrandName
if Config.BrandSuffix and Config.BrandSuffix ~= "" then
    TitleString = Config.BrandName .. " <font color='rgb(255, 0, 0)'>" .. Config.BrandSuffix .. "</font>"
end

-- [[ UI LIBRARY LOAD ]]
local success, Fluent = pcall(function()
    return loadstring(game:HttpGet(baseUrl .. "Core/library.lua"))()
end)

if not success then
    warn("Critical Error: UI Library not found at " .. Config.GithubRepo .. "/Core/library.lua")
    return
end

-- [[ WINDOW SETUP ]]
local Window = Fluent:CreateWindow({
    Title = TitleString,
    SubTitle = "v" .. Config.Version .. " | by " .. Config.GithubUser,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- [[ TABS ]]
local Tabs = {
    Home = Window:AddTab({ Title = "Home", Icon = "home" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

--- [[ HOME: PROFILE SECTION ]] ---
local Player = game.Players.LocalPlayer
local userId = Player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size100x100
local content, isReady = game.Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

local startTime = os.time()

-- Profil Bilgileri
Tabs.Home:AddParagraph({
    Title = "Player Profile",
    Content = string.format(
        "Username: %s\nRank: VIP\nStatus: Online",
        Player.Name
    )
})

-- Oynama Süresi (Dinamik güncelleme için paragrafı değişkene atıyoruz)
local PlayTimeLabel = Tabs.Home:AddParagraph({
    Title = "Session Stats",
    Content = "Playing Time: 00:00:00"
})

-- Oynama süresini arka planda güncelleyen döngü
task.spawn(function()
    while task.wait(1) do
        local seconds = os.time() - startTime
        local minutes = math.floor(seconds / 60)
        local hours = math.floor(minutes / 60)
        local displayTime = string.format("%02d:%02d:%02d", hours % 24, minutes % 60, seconds % 60)
        PlayTimeLabel:SetDesc("Playing Time: " + displayTime)
    end
end)

--- [[ MODULES INTEGRATION ]] ---

-- COMBAT: Self Back Killaura
Tabs.Combat:AddToggle("Killaura", {
    Title = "Self-Back Killaura",
    Default = false,
    Callback = function(Value)
        if Value then
            loadstring(game:HttpGet(baseUrl .. "Modules/self-back-killaura.lua"))()
        end
    end
})

-- VISUALS: Hunter Vision
Tabs.Visuals:AddToggle("HunterVision", {
    Title = "Hunter Vision",
    Default = false,
    Callback = function(Value)
        if Value then
            loadstring(game:HttpGet(baseUrl .. "Modules/tronwurp-hunter-vision.lua"))()
        end
    end
})

-- SETTINGS: Event Logger
Tabs.Settings:AddToggle("EventLogger", {
    Title = "Event Logger",
    Default = false,
    Callback = function(Value)
        if Value then
            loadstring(game:HttpGet(baseUrl .. "Modules/event-logger.lua"))()
        end
    end
})

-- Notification
Fluent:Notify({
    Title = Config.BrandName .. " Loaded!",
    Content = "Welcome back, " .. Player.Name,
    Duration = 5
})

Window:SelectTab(1)