-- [[ TRONWURP GOD MODE TESTER - OPTIMIZED ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Global kontrol (Main.lua'dan yönetilir)
_G.GodModeEnabled = _G.GodModeEnabled or false

local function SecureGodMode()
    if _G.GodModeConnection then _G.GodModeConnection:Disconnect() end

    _G.GodModeConnection = RunService.Heartbeat:Connect(function()
        if not _G.GodModeEnabled then 
            if _G.GodModeConnection then
                _G.GodModeConnection:Disconnect()
                _G.GodModeConnection = nil
            end
            return 
        end

        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            -- 1. Client-Side Bypass: Canı sürekli yenile
            if humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end

            -- 2. State Protection: Ölüme düşmeyi engelle
            if humanoid:GetState() == Enum.HumanoidStateType.Dead then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end)
end

-- 3. ANTI-DAMAGE (HRP Lokal Kilitleme)
-- Bazı oyunlarda hasar almamak için karakterin Hitbox'ını anlık olarak kaydırmak işe yarar.
-- Ama en temiz yöntem Remote'u bloklamaktır (Event Logger ile bulduğun Remote'u buraya ekleyebilirsin).

if _G.GodModeEnabled then
    SecureGodMode()
    print("🛡️ [GOD MODE]: Active")
end