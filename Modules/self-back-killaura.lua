-- [[ TRONWURP SELF-BACK KILLAURA - NO HEALTH CHECK ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local ATTACK_SPEED = 0.25 
local ATTACK_REMOTE = ReplicatedStorage:FindFirstChild("CharactersAttackRemote")
local lastAttackTime = 0

local function GetNearestTarget()
    local nearest = nil
    local shortestDistance = _G.KillauraRange or 50
    
    -- Can kontrolü tamamen kaldırıldı. 
    -- Sadece HumanoidRootPart'ı olan her modeli hedefler.
    for _, obj in pairs(workspace:GetChildren()) do 
        if obj:IsA("Model") and obj ~= player.Character then
            local root = obj:FindFirstChild("HumanoidRootPart")
            
            if root then
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

_G.KillauraConnection = RunService.Heartbeat:Connect(function()
    -- Global kontrol kapalıysa bağlantıyı kes
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
            -- Pozisyonlama (15 stud arkası)
            local followPos = targetRoot.CFrame * CFrame.new(0, 1, 15)
            char.HumanoidRootPart.CFrame = CFrame.lookAt(followPos.Position, targetRoot.Position)
            
            -- Saldırı Tetikleme
            if tick() - lastAttackTime >= ATTACK_SPEED then
                if ATTACK_REMOTE then
                    -- Hedef modelin kendisini gönderir
                    ATTACK_REMOTE:FireServer(targetRoot.Parent) 
                    lastAttackTime = tick()
                end
            end
        end
    end
end)