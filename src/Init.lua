-- Init.lua

-- 1. Global Bilgileri Tanımla
_G.Tronwurp = {
    User = "sunwurp1337",
    Repo = "testUIXRoblox",
    Branch = "main",
    Flags = {}, -- Özellik durumlarını (Aimbot = true vb.) saklamak için
}

-- 2. Base URL Oluştur (Tüm modüller bunu kullanacak)
_G.Tronwurp.BaseURL = string.format(
    "https://raw.githubusercontent.com/%s/%s/%s/src/",
    _G.Tronwurp.User, 
    _G.Tronwurp.Repo, 
    _G.Tronwurp.Branch
)

-- 3. Modül Yükleme Yardımcısı
local function Import(path)
    local url = _G.Tronwurp.BaseURL .. path .. ".lua"
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success and result then
        return result
    else
        warn("⚠️ Tronwurp: Modul yuklenemedi -> " .. path .. "\nHata: " .. tostring(result))
        return nil
    end
end

-- 4. Manifest'i Yükle ve Diğer Modülleri Başlat
local Manifest = Import("Core/Manifest")

if Manifest then
    -- Core Modülleri Yükle (Library vb.)
    for _, moduleName in ipairs(Manifest.Modules.Core) do
        _G.Tronwurp[moduleName] = Import("Core/" .. moduleName)
    end

    -- Feature Modüllerini Yükle (Visuals, Combat vb.)
    for _, moduleName in ipairs(Manifest.Modules.Features) do
        Import("Modules/" .. moduleName)
    end
    
    print("✅ " .. Manifest.Metadata.Name .. " v" .. Manifest.Metadata.Version .. " yuklendi!")
end
