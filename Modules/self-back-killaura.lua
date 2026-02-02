-- [[ TRONWURP SELF-BACK KILLAURA - ULTIMATE PERFORMANCE ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local ATTACK_SPEED = 1
local ATTACK_REMOTE = ReplicatedStorage:FindFirstChild("CharactersAttackRemote")
local lastAttackTime = 0
local CurrentTarget = nil

-- 1. HEDEF BULMA (Saniyede sadece birkaç kez çalışır - Kasmayı önleyen kısım)
task.spawn(function()
    while task.wait(0.2) do -- 0.2 saniyede bir tarama yap (Yeterince hızlıdır)
        if not _G.KillauraEnabled then CurrentTarget = nil continue end
        
        local nearest = nil
        local shortestDistance = _G.KillauraRange or 50
        
        -- Sadece workspace altındaki ana modelleri tara
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
        CurrentTarget = nearest
    end
end)

-- 2. TAKİP VE SALDIRI DÖNGÜSÜ (Her karede çalışır - Akıcılık sağlar)
if _G.KillauraConnection then _G.KillauraConnection:Disconnect() end

_G.KillauraConnection = RunService.RenderStepped:Connect(function()
    if not _G.KillauraEnabled then 
        _G.KillauraConnection:Disconnect()
        _G.KillauraConnection = nil
        return 
    end

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and CurrentTarget then
        -- Pozisyonlama
        local followPos = CurrentTarget.CFrame * CFrame.new(0, 1, 15)
        player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(followPos.p, CurrentTarget.Position)
        
        -- Saldırı
        if tick() - lastAttackTime >= ATTACK_SPEED then
            if ATTACK_REMOTE then
                ATTACK_REMOTE:FireServer(CurrentTarget.Parent) 
                lastAttackTime = tick()
            end
        end
    end
end)