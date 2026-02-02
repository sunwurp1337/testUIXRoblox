-- [[ TRONWURP SELF-BACK - CREATURES OF SONARIA EDITION ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Hedef değişkeni
local CurrentTarget = nil

-- 1. HEDEF BULMA (CoS için Derin Tarama ama Optimize)
task.spawn(function()
    while true do
        if _G.KillauraEnabled then
            local nearest = nil
            local shortestDistance = _G.KillauraRange or 50
            local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position

            if myPos then
                -- CoS'da yaratıklar genellikle workspace içinde "Models" veya oyuncu isimli klasörlerdedir
                -- Bu döngü workspace altındaki tüm modellere bakar ama derinlere inmez (FPS korur)
                for _, obj in pairs(workspace:GetDescendants()) do
                    -- Sadece Model olan ve senin karakterin olmayan objelere bak
                    if obj:IsA("Model") and obj ~= player.Character and obj:FindFirstChild("Humanoid") then
                        local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                        
                        if root then
                            local distance = (myPos - root.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearest = root
                            end
                        end
                    end
                    -- Her 100 objede bir bekleme yaparak kasmayı önler (Wait bypass)
                    if _ % 100 == 0 then task.wait() end 
                end
            end
            CurrentTarget = nearest
        else
            CurrentTarget = nil
        end
        task.wait(0.5) -- Tarama hızını optimize ettik
    end
end)

-- 2. TAKİP DÖNGÜSÜ (Işınlanma)
if _G.KillauraConnection then _G.KillauraConnection:Disconnect() end

_G.KillauraConnection = RunService.Heartbeat:Connect(function()
    -- UI Kapandıysa veya Toggle kapandıysa dur
    if not _G.KillauraEnabled then 
        if _G.KillauraConnection then
            _G.KillauraConnection:Disconnect()
            _G.KillauraConnection = nil
        end
        return 
    end

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and CurrentTarget then
        -- Pozisyonlama (15 stud arkası)
        -- CoS yaratıkları büyük olduğu için arkaya gitme mesafesini 15 studs tutuyoruz
        local followPos = CurrentTarget.CFrame * CFrame.new(0, 5, 20) -- Biraz yukarda ve arkada (Sıkışmamak için)
        player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(followPos.Position, CurrentTarget.Position)
    end
end)