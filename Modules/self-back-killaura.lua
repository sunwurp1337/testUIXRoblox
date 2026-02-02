local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- AYARLAR
local KILLAURA_AKTIF = false
local MENZIL = 50
local VURUS_HIZI = 0.25 -- Sunucu debounce'una takılmamak için 0.25 (saniyede 4 vuruş) idealdir
local ATTACK_REMOTE = ReplicatedStorage:FindFirstChild("CharactersAttackRemote")

local sonVurusZamani = 0

-- 1. EN YAKIN HEDEFI BULMA
function enYakinDinozoruBul()
    local enYakin = nil
    local enKisaMesafe = MENZIL
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= player.Character and obj:FindFirstChild("HumanoidRootPart") then
            local root = obj.HumanoidRootPart
            local mesafe = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if mesafe < enKisaMesafe then
                enKisaMesafe = mesafe
                enYakin = root
            end
        end
    end
    return enYakin
end

-- 2. ANA TAKİP VE MESAFELİ VURUŞ DÖNGÜSÜ
RunService.RenderStepped:Connect(function()
    if KILLAURA_AKTIF and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hedefRoot = enYakinDinozoruBul()
        
        if hedefRoot then
            -- ARKA MESAFE AYARI
            -- CFrame.new(0, 1, 3) -> 0: Yatay sapma, 1: Yükseklik, 3: Arkaya doğru mesafe
            -- Değeri (3), dinozorun büyüklüğüne göre 4 veya 5 yapabilirsin.
            local takipPozisyonu = hedefRoot.CFrame * CFrame.new(0, 1, 3)
            
            -- Karakteri hedefin arkasına, hedefe bakacak şekilde konumlandırır
            player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(takipPozisyonu.p, hedefRoot.Position)
            
            -- SALDIRI TETİKLEME
            if tick() - sonVurusZamani >= VURUS_HIZI then
                if ATTACK_REMOTE then
                    -- Önemli: Sunucu hedefi parametre olarak bekliyor olabilir
                    ATTACK_REMOTE:FireServer(hedefRoot.Parent) 
                    sonVurusZamani = tick()
                end
            end
        end
    end
end)

-- "N" tuşu ile aç/kapat
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.N then
        KILLAURA_AKTIF = not KILLAURA_AKTIF
        print("--- Menzilli Aura Durumu: " .. tostring(KILLAURA_AKTIF) .. " ---")
    end
end)