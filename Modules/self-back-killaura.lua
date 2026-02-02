-- [[ TRONWURP SELF-BACK KILLAURA - OPTIMIZED ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local ATTACK_SPEED = 0.25 -- Hızı düzelttim (Hızlı vuruş için)
local ATTACK_REMOTE = ReplicatedStorage:FindFirstChild("CharactersAttackRemote")
local lastAttackTime = 0

local function GetNearestTarget()
    local nearest = nil
    local shortestDistance = _G.KillauraRange or 50
    
    -- OPTİMİZASYON: GetDescendants yerine sadece GetChildren veya Players kullanıyoruz
    -- Eğer düşmanlar oyuncuysa 'Players:GetPlayers()' kullanmak en hızlısıdır.
    -- Eğer NPC ise workspace içindeki modelleri tarıyoruz:
    for _, obj in pairs(workspace:GetChildren()) do 
        if obj:IsA("Model") and obj ~= player.Character then
            local root = obj:FindFirstChild("HumanoidRootPart")
            local hum = obj:FindFirstChildOfClass("Humanoid")
            
            -- Canı 0'dan büyükse ve RootPart varsa kontrol et
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

-- RenderStepped yerine Heartbeat daha stabildir (FPS dropu engeller)
_G.KillauraConnection = RunService.Heartbeat:Connect(function()
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
            -- 15 studs arkası (Ekran titremesini önlemek için yumuşatılmış mesafe)
            local followPos = targetRoot.CFrame * CFrame.new(0, 1, 15)
            char.HumanoidRootPart.CFrame = CFrame.lookAt(followPos.Position, targetRoot.Position)
            
            if tick() - lastAttackTime >= ATTACK_SPEED then
                if ATTACK_REMOTE then
                    ATTACK_REMOTE:FireServer(targetRoot.Parent) 
                    lastAttackTime = tick()
                end
            end
        end
    end
end)