-- [[ CONFIGURATION ]]
local Config = {
    GithubUser = "sunwurp1337",
    GithubRepo = "testUIXRoblox",
    Branch = "main",
    BrandName = "Tronwurp",
    BrandSuffix = "VIP",
    Version = "1.0.5" -- Versiyon güncellendi
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

--- [[ HOME: PROFILE & PLAYING TIME ]] ---
local Player = game.Players.LocalPlayer
local startTime = os.time()

Tabs.Home:AddParagraph({
    Title = "Player Profile",
    Content = "Username: " .. Player.Name .. "\nRank: " .. Config.BrandSuffix .. "\nStatus: Online"
})

-- Playing Time Düzeltmesi
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
        local displayTime = string.format("%02d:%02d:%02d", hours, minutes, secs)
        
        -- Fluent kütüphanesinde paragraf güncelleme genellikle SetTitle veya SetDesc ile yapılır.
        -- Eğer SetDesc çalışmazsa kütüphaneye göre 'Content' alanı güncellenir.
        PlayTimeParagraph:SetDesc("Playing Time: " .. displayTime)
    end
end)

--- [[ MODULES LOGIC ]] ---
-- Modülleri kapatmak için kullanılan tablo
local RunningModules = {}

local function HandleModule(name, url, state)
    if state then
        -- Modülü başlat
        local scriptRaw = game:HttpGet(url)
        local func, err = loadstring(scriptRaw)
        if func then
            RunningModules[name] = func() -- Modülün durdurma fonksiyonu döndürdüğünü varsayar
            Fluent:Notify({Title = name, Content = "Activated", Duration = 2})
        else
            warn("Module Error: " .. err)
        end
    else
        -- Modülü kapatma mantığı
        -- Not: Modül dosyanızın içinde bir 'stop' mekanizması yoksa karakteri resetlemek en temiz yoldur.
        Fluent:Notify({Title = name, Content = "Deactivated. Some effects may require reset.", Duration = 3})
        RunningModules[name] = nil
        
        -- Eğer modül killaura veya ESP ise karakteri temizlemek gerekebilir:
        if name == "Killaura" or name == "Hunter Vision" then
             -- Buraya modüle özel kapatma kodları (örn: ESP:Destroy()) eklenmelidir.
        end
    end
end

-- COMBAT
Tabs.Combat:AddToggle("Killaura", {
    Title = "Self-Back Killaura",
    Default = false,
    Callback = function(Value)
        HandleModule("Killaura", baseUrl .. "Modules/self-back-killaura.lua", Value)
    end
})

-- VISUALS
Tabs.Visuals:AddToggle("HunterVision", {
    Title = "Tronwurp Hunter Vision",
    Default = false,
    Callback = function(Value)
        HandleModule("Hunter Vision", baseUrl .. "Modules/tronwurp-hunter-vision.lua", Value)
    end
})

-- SETTINGS
Tabs.Settings:AddToggle("EventLogger", {
    Title = "Event Logger",
    Default = false,
    Callback = function(Value)
        HandleModule("Event Logger", baseUrl .. "Modules/event-logger.lua", Value)
    end
})

Window:SelectTab(1)