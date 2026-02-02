-- Init.lua
_G.Tronwurp = {
    User = "sunwurp1337",
    Repo = "testUIXRoblox",
    Branch = "main",
    Flags = {}, -- Ayarları burada tutacağız
    Theme = { -- Merkezi Tema Yönetimi
        Main = Color3.fromRGB(15, 15, 18),
        Side = Color3.fromRGB(20, 20, 24),
        Accent = Color3.fromRGB(255, 40, 40),
        Text = Color3.fromRGB(240, 240, 240),
        TextDim = Color3.fromRGB(160, 160, 170),
        Border = Color3.fromRGB(35, 35, 40)
    }
}

_G.Tronwurp.BaseURL = string.format("https://raw.githubusercontent.com/%s/%s/%s/src/", _G.Tronwurp.User, _G.Tronwurp.Repo, _G.Tronwurp.Branch)

local function Import(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(_G.Tronwurp.BaseURL .. path .. ".lua"))()
    end)
    return success and result or nil
end

local Manifest = Import("Core/Manifest")
if Manifest then
    -- Core dosyaları yükle ve _G.Tronwurp içine kaydet
    for _, mod in ipairs(Manifest.Modules.Core) do
        _G.Tronwurp[mod] = Import("Core/" .. mod)
    end
    -- Özellikleri yükle
    for _, mod in ipairs(Manifest.Modules.Features) do
        Import("Modules/" .. mod)
    end
    print("🚀 " .. Manifest.Metadata.Name .. " Modern UI Yuklendi!")
end
