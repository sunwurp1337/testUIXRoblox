-- [[ TRONWURP SELF-BACK KILLAURA - OPTIMIZED ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Configuration
local ATTACK_SPEED = 0.25 
local ATTACK_REMOTE = ReplicatedStorage:FindFirstChild("CharactersAttackRemote")
local lastAttackTime = 0

-- 1. FIND NEAREST TARGET
local function GetNearestTarget()
    local nearest = nil
    -- RANGE artık dinamik: Main.lua'daki slider'dan gelen değeri okur, yoksa 50 kullanır.
    local shortestDistance = _G.KillauraRange or 50
    
    -- Optimized search
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= player.Character and obj:FindFirstChild("HumanoidRootPart") then
            local root = obj.HumanoidRootPart
            local distance = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearest = root
            end
        end
    end
    return nearest
end

-- 2. KILL AURA LOOP
local function StartAura()
    -- Global connection to allow easy disconnection
    if _G.KillauraConnection then _G.KillauraConnection:Disconnect() end

    _G.KillauraConnection = RunService.RenderStepped:Connect(function()
        -- Toggle kontrolü
        if not _G.KillauraEnabled then 
            if _G.KillauraConnection then
                _G.KillauraConnection:Disconnect()
                _G.KillauraConnection = nil
            end
            return 
        end

        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = GetNearestTarget()
            
            if targetRoot then
                -- POSITIONING: Behind the target
                local followPos = targetRoot.CFrame * CFrame.new(0, 1, 3)
                player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(followPos.p, targetRoot.Position)
                
                -- ATTACK TRIGGER
                if tick() - lastAttackTime >= ATTACK_SPEED then
                    if ATTACK_REMOTE then
                        ATTACK_REMOTE:FireServer(targetRoot.Parent) 
                        lastAttackTime = tick()
                    end
                end
            end
        end
    end)
end

-- Run logic
if _G.KillauraEnabled then
    StartAura()
end

-- Return cleanup function
return function()
    if _G.KillauraConnection then
        _G.KillauraConnection:Disconnect()
        _G.KillauraConnection = nil
    end
end