-- [[ CONFIGURATION ]]
local Config = {
    GithubUser = "sunwurp1337",
    GithubRepo = "testUIXRoblox",
    Branch = "main",
    BrandName = "Tronwurp",
    BrandSuffix = "VIP", -- If empty, it won't show
    Version = "1.0.4"
}

-- Dynamic URL Generator
local baseUrl = "https://raw.githubusercontent.com/" .. Config.GithubUser .. "/" .. Config.GithubRepo .. "/" .. Config.Branch .. "/"

-- Branding Logic (Kırmızı Suffix)
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

-- [[ TABS AND FEATURES ]]
local Tabs = {
    -- İstediğin Tab Değişiklikleri Buradadır:
    Home = Window:AddTab({ Title = "Home", Icon = "home" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Home Tab İçeriği
Tabs.Home:AddParagraph({
    Title = "System Status: Active",
    Content = "Files successfully pulled from " .. Config.GithubUser .. "'s repository."
})

-- Örnek: WalkSpeed Feature (Artık Home tabında)
Tabs.Home:AddSlider("WS", {
    Title = "Walk Speed",
    Description = "Adjust your character's movement speed.",
    Default = 16,
    Min = 16,
    Max = 300,
    Rounding = 1,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

-- Notification
Fluent:Notify({
    Title = Config.BrandName .. " Loaded!",
    Content = "The script is ready to use.",
    Duration = 3
})

Window:SelectTab(1)