-- [[ TRONWURP SELF-BACK KILLAURA - FIXED ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local ATTACK_SPEED = 1
local ATTACK_REMOTE = ReplicatedStorage:FindFirstChild("CharactersAttackRemote")
local lastAttackTime = 0

local function GetNearestTarget()
    local nearest = nil
    
    -- ÖNCELİK SIRASI: 1. Global Slider Değeri | 2. Varsayılan 50
    local shortestDistance = _G.KillauraRange
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= player.Character and obj:FindFirstChild("HumanoidRootPart") then
            local root = obj.HumanoidRootPart
            local distance = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
            
            -- Mesafe kontrolü
            if distance < shortestDistance then
                shortestDistance = distance
                nearest = root
            end
        end
    end
    return nearest
end

if _G.KillauraConnection then _G.KillauraConnection:Disconnect() end

_G.KillauraConnection = RunService.RenderStepped:Connect(function()
    if not _G.KillauraEnabled then 
        _G.KillauraConnection:Disconnect()
        _G.KillauraConnection = nil
        return 
    end

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = GetNearestTarget()
        
        if targetRoot then
            local followPos = targetRoot.CFrame * CFrame.new(0, 1, 7)
            player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(followPos.p, targetRoot.Position)
            
            if tick() - lastAttackTime >= ATTACK_SPEED then
                if ATTACK_REMOTE then
                    ATTACK_REMOTE:FireServer(targetRoot.Parent) 
                    lastAttackTime = tick()
                end
            end
        end
    end
end)