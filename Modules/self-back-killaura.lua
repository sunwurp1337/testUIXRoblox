-- [[ TRONWURP SELF-BACK KILLAURA - LAG FIXED ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local ATTACK_SPEED = 0.25 -- Tekrar seri vuruş için 0.25 yapıldı
local ATTACK_REMOTE = ReplicatedStorage:FindFirstChild("CharactersAttackRemote")
local lastAttackTime = 0

local function GetNearestTarget()
    local nearest = nil
    local shortestDistance = _G.KillauraRange or 50
    
    -- LAG ÇÖZÜMÜ: GetDescendants yerine sadece karakterleri tara
    -- Genellikle canlılar workspace içindeki bir klasörde veya direkt workspace'tedir.
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= player.Character then
            local root = obj:FindFirstChild("HumanoidRootPart")
            local hum = obj:FindFirstChildOfClass("Humanoid")
            
            -- Sadece canlı ve HRP'si olanları kontrol et
            if root and hum and hum.Health > 0 then
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

if _G.KillauraConnection then _G.KillauraConnection:Disconnect() end

_G.KillauraConnection = RunService.RenderStepped:Connect(function()
    -- UI Kapanınca veya Toggle kapanınca durması için
    if not _G.KillauraEnabled then 
        if _G.KillauraConnection then
            _G.KillauraConnection:Disconnect()
            _G.KillauraConnection = nil
        end
        return 
    end

    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local targetRoot = GetNearestTarget()
        
        if targetRoot then
            -- Pozisyonlama (15 stud arkaya ışınlar)
            local followPos = targetRoot.CFrame * CFrame.new(0, 1, 15)
            char.HumanoidRootPart.CFrame = CFrame.lookAt(followPos.Position, targetRoot.Position)
            
            -- Saldırı
            if os.clock() - lastAttackTime >= ATTACK_SPEED then
                if ATTACK_REMOTE then
                    ATTACK_REMOTE:FireServer(targetRoot.Parent) 
                    lastAttackTime = os.clock()
                end
            end
        end
    end
end)