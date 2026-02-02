-- FULL STACK REMOTE LOGLAYICI (HEM GELEN HEM GİDEN)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. GELENİ İZLE (Server -> Client)
for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") then
        remote.OnClientEvent:Connect(function(...)
            print("📩 [GELEN - SERVER'DAN]: " .. remote.Name, "Veri:", ...)
        end)
    end
end

-- 2. GİDENİ İZLE (Client -> Server)
-- Kendi scriptlerinde FireServer yaptığında bunu loglamak için 
-- bir global fonksiyon tanımlayabilirsin (Test amaçlı)
_G.SafeFireServer = function(remote, ...)
    print("📤 [GİDEN - SUNUCUYA]: " .. remote.Name, "Veri:", ...)
    remote:FireServer(...)
end

-- Kullanırken: Remote:FireServer(...) yerine _G.SafeFireServer(Remote, ...) kullanırsın.