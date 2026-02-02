-- [[ REMOTE EVENT LOGGER - OPTIMIZED ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modülün birden fazla kez çalışmasını engellemek için kontrol
if _G.LoggerConnections then
    for _, conn in pairs(_G.LoggerConnections) do
        if conn then conn:Disconnect() end
    end
    _G.LoggerConnections = {}
end

_G.LoggerConnections = {}

local function StartLogging()
    -- 1. MONITOR INCOMING (Server -> Client)
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local connection = remote.OnClientEvent:Connect(function(...)
                if _G.EventLoggerEnabled then
                    print("📩 [INCOMING]: " .. remote.Name)
                    print("Data:", ...)
                end
            end)
            table.insert(_G.LoggerConnections, connection)
        end
    end

    -- 2. MONITOR OUTGOING (Hooking)
    _G.SafeFireServer = function(remote, ...)
        if _G.EventLoggerEnabled then
            print("📤 [OUTGOING]: " .. remote.Name)
            print("Data:", ...)
        end
        remote:FireServer(...)
    end
end

-- İlk çalıştırma
StartLogging()

-- Kapatma fonksiyonu
_G.StopEventLogger = function()
    _G.EventLoggerEnabled = false
    if _G.LoggerConnections then
        for _, conn in pairs(_G.LoggerConnections) do
            if conn then conn:Disconnect() end
        end
        _G.LoggerConnections = nil
    end
    _G.SafeFireServer = nil
    print("🚫 [EVENT LOGGER]: All connections disconnected.")
end