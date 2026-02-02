-- [[ TRONWURP SELF-BACK KILLAURA - FIXED ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local ATTACK_SPEED = 0.25 
local ATTACK_REMOTE = ReplicatedStorage:FindFirstChild("CharactersAttackRemote")
local lastAttackTime = 0

-- Eski bağlantı varsa kopar (Çakışmayı önler)
if _G.KillauraConnection then 
    _G.KillauraConnection:Disconnect() 
    _G.KillauraConnection = nil
end

local function GetNearestTarget()
    local nearest = nil
    local shortestDistance = _G.KillauraRange or 50
    
    -- Performans için sadece Workspace içindeki karakterleri kontrol et
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= player.Character and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("Humanoid") then
            if obj.Humanoid.Health > 0 then
                local root = obj.HumanoidRootPart
                local distance = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearest = root
                end
            end
        end
    end
    return nearest
end

-- DÖNGÜ BAŞLATMA
_G.KillauraConnection = RunService.Heartbeat:Connect(function()
    -- Global kontrol kapalıysa döngüyü tamamen durdur
    if not _G.KillauraEnabled then 
        if _G.KillauraConnection then
            _G.KillauraConnection:Disconnect()
            _G.KillauraConnection = nil
        end
        return 
    end

    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = GetNearestTarget()
        
        if targetRoot then
            -- Pozisyonlama (Arkasına bakacak şekilde)
            local followPos = targetRoot.CFrame * CFrame.new(0, 1, 4) -- Mesafeyi 4 yaparak iç içe girmeyi önledim
            character.HumanoidRootPart.CFrame = CFrame.lookAt(followPos.Position, targetRoot.Position)
            
            -- Saldırı
            if tick() - lastAttackTime >= ATTACK_SPEED then
                if ATTACK_REMOTE then
                    ATTACK_REMOTE:FireServer(targetRoot.Parent) 
                    lastAttackTime = tick()
                end
            end
        end
    end
end)

print("Tronwurp Killaura: Engine Started")