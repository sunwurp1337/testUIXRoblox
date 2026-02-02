-- [[ TRONWURP SELF-BACK - COS ULTIMATE ALGORITHM ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local CurrentTarget = nil

-- 1. HEDEF BULMA (CoS Karakter Yapısına Göre Optimize Edildi)
task.spawn(function()
    while true do
        if _G.KillauraEnabled then
            local nearest = nil
            local shortestDistance = _G.KillauraRange or 100
            local myChar = player.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

            if myRoot then
                -- CoS karakterleri genellikle workspace içinde 'Live' veya belirli klasörlerde toplanır.
                -- GetDescendants yerine daha geniş kapsamlı ama kontrollü bir tarama yapıyoruz.
                for _, v in pairs(workspace:GetDescendants()) do
                    -- CoS yaratıklarını ayırt etmek için: Model olmalı + Humanoid içermeli + Bizim karakterimiz olmamalı
                    if v:IsA("Model") and v ~= myChar and v:FindFirstChildOfClass("Humanoid") then
                        local targetRoot = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                        
                        if targetRoot then
                            local distance = (myRoot.Position - targetRoot.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearest = targetRoot
                            end
                        end
                    end
                    
                    -- Her 250 objede bir milisaniyelik ara ver (Kasmayı %100 keser)
                    if _ % 250 == 0 then task.wait() end
                end
            end
            CurrentTarget = nearest
        else
            CurrentTarget = nil
        end
        task.wait(0.3) -- Tarama sıklığı (FPS dostu)
    end
end)

-- 2. IŞINLANMA DÖNGÜSÜ
if _G.KillauraConnection then _G.KillauraConnection:Disconnect() end

_G.KillauraConnection = RunService.Heartbeat:Connect(function()
    -- Kapatma kontrolü
    if not _G.KillauraEnabled then 
        if _G.KillauraConnection then
            _G.KillauraConnection:Disconnect()
            _G.KillauraConnection = nil
        end
        return 
    end

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and CurrentTarget then
        -- CoS yaratıkları devasa olabildiği için takip mesafesini ve yüksekliğini artırdık
        -- 0: Yatay, 8: Yükseklik, 25: Arka mesafe (Sıkışmayı önler)
        local followPos = CurrentTarget.CFrame * CFrame.new(0, 8, 25)
        player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(followPos.Position, CurrentTarget.Position)
    end
end)