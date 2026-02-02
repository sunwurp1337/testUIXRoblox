-- [[ TRONWURP SELF-BACK KILLAURA - TELEPORT ONLY ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Hedef değişkeni
local CurrentTarget = nil

-- 1. HEDEF BULMA DÖNGÜSÜ (Performans için optimize edildi)
task.spawn(function()
    while true do
        if _G.KillauraEnabled then
            local nearest = nil
            local shortestDistance = _G.KillauraRange or 50
            
            -- Mesafe içinde hedef arama
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
        else
            CurrentTarget = nil
        end
        task.wait(0.1) -- Saniyede 10 kez tarama yapar (Hem hızlı hem kasmaz)
    end
end)

-- 2. TAKİP DÖNGÜSÜ (Işınlanma)
if _G.KillauraConnection then _G.KillauraConnection:Disconnect() end

_G.KillauraConnection = RunService.RenderStepped:Connect(function()
    -- Eğer killaura kapalıysa bağlantıyı kes
    if not _G.KillauraEnabled then 
        if _G.KillauraConnection then
            _G.KillauraConnection:Disconnect()
            _G.KillauraConnection = nil
        end
        return 
    end

    -- Karakter ve Hedef kontrolü
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and CurrentTarget then
        -- Hedefin hala menzil içinde olup olmadığını anlık kontrol et
        local currentDist = (player.Character.HumanoidRootPart.Position - CurrentTarget.Position).Magnitude
        
        if currentDist <= (_G.KillauraRange or 50) + 20 then -- 20 stud tolerans payı
            -- Sadece Işınlanma (Vuruş/Remote kısmı kaldırıldı)
            local followPos = CurrentTarget.CFrame * CFrame.new(0, 1, 15)
            player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(followPos.p, CurrentTarget.Position)
        else
            -- Menzilden çıktıysa hedefi bırak
            CurrentTarget = nil
        end
    end
end)