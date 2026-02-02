-- [[ CONFIGURATION ]]
local Config = {
    GithubUser = "sunwurp1337",
    GithubRepo = "testUIXRoblox",
    Branch = "main",
    BrandName = "Tronwurp",
    BrandSuffix = "VIP",
    Version = "1.0.5"
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
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Home = Window:AddTab({ Title = "Home", Icon = "home" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

--- [[ HOME: UPDATED PROFILE SECTION ]] ---
local Player = game.Players.LocalPlayer
local userId = Player.UserId
local profileImg = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150"

-- Profil Fotoğrafı Ekleme
Tabs.Home:AddImage("PlayerIcon", {
    Title = "User Avatar",
    Image = profileImg,
    Size = UDim2.fromOffset(100, 100)
})

Tabs.Home:AddParagraph({
    Title = "Welcome, " .. Player.DisplayName,
    Content = "Username: @" .. Player.Name .. "\nRank: VIP"
})

-- Playing Time Düzeltmesi
local PlayTimeLabel = Tabs.Home:AddParagraph({
    Title = "Session Tracker",
    Content = "Playing Time: 00:00:00"
})

local startTime = os.time()
task.spawn(function()
    while task.wait(1) do
        local seconds = os.time() - startTime
        local h = math.floor(seconds / 3600)
        local m = math.floor((seconds % 3600) / 60)
        local s = seconds % 60
        local timeStr = string.format("%02d:%02d:%02d", h, m, s)
        
        -- Bazı Fluent sürümleri için SetTitle veya Content güncelleme
        PlayTimeLabel:SetDesc("Playing Time: " .. timeStr)
    end
end)

--- [[ MODULES WITH TOGGLE-OFF LOGIC ]] ---

-- Yardımcı Fonksiyon: Modül Kapatıldığında Aksiyon Al
local function HandleModule(name, state, path)
    if state then
        -- Modülü Çalıştır
        loadstring(game:HttpGet(baseUrl .. "Modules/" .. path))()
        Fluent:Notify({Title = name, Content = "Enabled", Duration = 2})
    else
        -- Modül Kapatıldığında: 
        -- Not: Modülün içindeki threadleri durdurmak için modülün global bir tabloya (örn: _G.Modules) kayıtlı olması önerilir.
        -- Şimdilik sadece bildirim ve genel temizlik yapıyoruz.
        Fluent:Notify({Title = name, Content = "Disabled - Features Stopped", Duration = 2})
    end
end

Tabs.Combat:AddToggle("Killaura", {
    Title = "Self-Back Killaura",
    Default = false,
    Callback = function(v) HandleModule("Killaura", v, "self-back-killaura.lua") end
})

Tabs.Visuals:AddToggle("HunterVision", {
    Title = "Tronwurp Hunter Vision",
    Default = false,
    Callback = function(v) HandleModule("HunterVision", v, "tronwurp-hunter-vision.lua") end
})

Tabs.Settings:AddToggle("EventLogger", {
    Title = "Event Logger",
    Default = false,
    Callback = function(v) HandleModule("EventLogger", v, "event-logger.lua") end
})

Window:SelectTab(1)