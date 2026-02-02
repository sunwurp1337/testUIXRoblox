-- [[ TRONWURP GOD MODE - FULL BYPASS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

_G.GodModeEnabled = true

-- 1. NETWORKING BYPASS (Sunucu Hasar Paketlerini Reddetme)
-- getnamecallmethod kullanarak oyundan giden tüm hasar bildirimlerini susturuyoruz.
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.GodModeEnabled and not checkcaller() then
        -- Yaygın hasar remote isimleri (Bunları buldukça listeye ekle)
        local blacklist = {"Damage", "TakeDamage", "Hit", "Burn", "Poison", "Explosion", "Kill"}
        
        for _, name in pairs(blacklist) do
            if self.Name:find(name) and (method == "FireServer" or method == "InvokeServer") then
                return nil -- Paketi sunucuya hiç gönderme
            end
        end
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- 2. CORE PROTECTION LOOP
local function ProtectCharacter()
    if _G.GodModeLoop then _G.GodModeLoop:Disconnect() end

    _G.GodModeLoop = RunService.Heartbeat:Connect(function()
        if not _G.GodModeEnabled then 
            _G.GodModeLoop:Disconnect()
            return 
        end

        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                -- State Lockdown: Ölümü reddet
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                
                -- Görsel ve mantıksal canı full tut
                if hum.Health < hum.MaxHealth and hum.Health > 0 then
                    hum.Health = hum.MaxHealth
                end

                -- Eğer can 0 olursa karakteri ayakta tutmaya çalış
                if hum:GetState() == Enum.HumanoidStateType.Dead then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
        end
    end)
end

-- Karakter her doğduğunda korumayı yenile
player.CharacterAdded:Connect(function()
    task.wait(1)
    ProtectCharacter()
end)

ProtectCharacter()