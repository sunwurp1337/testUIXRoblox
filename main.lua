-- [[ CONFIGURATION ]]
local Config = {
    GithubUser = "sunwurp1337",
    GithubRepo = "testUIXRoblox",
    Branch = "main",
    Version = "1.0.4"
}

-- Dinamik URL Oluşturucu
local baseUrl = "https://raw.githubusercontent.com/" .. Config.GithubUser .. "/" .. Config.GithubRepo .. "/" .. Config.Branch .. "/"

-- [[ UI LIBRARY LOAD (Kendi Repondan Çekiliyor) ]]
local success, Fluent = pcall(function()
    -- Artık Core/library.lua'dan çekiyor
    return loadstring(game:HttpGet(baseUrl .. "Core/library.lua"))()
end)

if not success then
    warn("Kritik Hata: UI Kütüphanesi " .. Config.GithubRepo .. "/Core/library.lua yolunda bulunamadı!")
    return
end

-- [[ WINDOW SETUP ]]
local Window = Fluent:CreateWindow({
    Title = Config.GithubRepo .. " Premium",
    SubTitle = "v" .. Config.Version .. " | by " .. Config.GithubUser,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- [[ SEKMELER VE ÖZELLİKLER ]]
local Tabs = {
    Main = Window:AddTab({ Title = "Ana Menü", Icon = "home" })
}

Tabs.Main:AddParagraph({
    Title = "Sistem Durumu: Aktif",
    Content = "Dosyalar " .. Config.GithubUser .. " reposundan başarıyla çekildi."
})

-- Örnek Fonksiyon
Tabs.Main:AddSlider("WS", {
    Title = "Karakter Hızı",
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

-- Bildirim
Fluent:Notify({
    Title = "Yüklendi!",
    Content = Config.GithubRepo .. " kullanıma hazır.",
    Duration = 3
})

Window:SelectTab(1)