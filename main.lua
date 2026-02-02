-- [[ CONFIGURATION ]]
local Config = {
    GithubUser = "sunwurp1337",
    GithubRepo = "testUIXRoblox",
    Branch = "main",
    Version = "1.0.3"
}

-- [[ UI LIBRARY LOAD (Fluent) ]]
local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success then
    warn("UI Library yuklenemedi! İnternet baglantinizi kontrol edin.")
    return
end

local Window = Fluent:CreateWindow({
    Title = Config.GithubRepo .. " | " .. Config.Version,
    SubTitle = "by " .. Config.GithubUser,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Sekmeler
local Tabs = {
    Main = Window:AddTab({ Title = "Ana Menü", Icon = "home" })
}

Tabs.Main:AddParagraph({
    Title = "Sistem Aktif",
    Content = "Kullanıcı: " .. Config.GithubUser .. "\nRepo: " .. Config.GithubRepo
})

-- Örnek bir hız artırıcı
Tabs.Main:AddSlider("WS", {
    Title = "Yürüme Hızı",
    Default = 16,
    Min = 16,
    Max = 250,
    Rounding = 1,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

Fluent:Notify({
    Title = "SunWurp UI",
    Content = "Script başarıyla yüklendi!",
    Duration = 5
})