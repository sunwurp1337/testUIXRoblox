-- [[ TRONWURP SELF-BACK KILLAURA - ULTRA OPTIMIZED ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local ATTACK_SPEED = 1
local ATTACK_REMOTE = ReplicatedStorage:FindFirstChild("CharactersAttackRemote")
local lastAttackTime = 0
local lastSearchTime = 0
local targetRoot = nil -- Hedefi bir değişkende tutuyoruz

-- 1. HEDEF BULMA (Sadece belirli aralıklarla çalışır)
local function GetNearestTarget()
    local nearest = nil
    local shortestDistance = _G.KillauraRange or 50
    
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

_G.KillauraConnection = RunService.RenderStepped:Connect(function()
    if not _G.KillauraEnabled then 
        _G.KillauraConnection:Disconnect()
        _G.KillauraConnection = nil
        targetRoot = nil
        return 
    end

    -- 2. OPTİMİZASYON: Her karede değil, 0.1 saniyede bir hedef ara
    if tick() - lastSearchTime >= 0.1 then
        targetRoot = GetNearestTarget()
        lastSearchTime = tick()
    end

    -- 3. IŞINLANMA (Işınlanma pürüzsüz olması için her karede çalışır)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and targetRoot then
        -- Hedef hala hayatta mı veya mevcut mu kontrolü (Opsiyonel ama önerilir)
        if targetRoot.Parent then
            local followPos = targetRoot.CFrame * CFrame.new(0, 1, 15)
            player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(followPos.p, targetRoot.Position)
            
            -- SALDIRI
            if tick() - lastAttackTime >= ATTACK_SPEED then
                if ATTACK_REMOTE then
                    ATTACK_REMOTE:FireServer(targetRoot.Parent) 
                    lastAttackTime = tick()
                end
            end
        else
            targetRoot = nil
        end
    end
end)