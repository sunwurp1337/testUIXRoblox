-- [[ REMOTE EVENT LOGGER MODULE ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogConnections = {}

-- Global kontrol değişkeni (Main script tarafından yönetilir)
_G.EventLoggerEnabled = true

local function StartLogging()
    -- 1. MONITOR INCOMING (Server -> Client)
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local connection = remote.OnClientEvent:Connect(function(...)
                if _G.EventLoggerEnabled then
                    print("📩 [INCOMING - FROM SERVER]: " .. remote.Name)
                    print("Data:", ...)
                end
            end)
            table.insert(LogConnections, connection)
        end
    end

    -- 2. MONITOR OUTGOING (Client -> Server - Hooking)
    -- This function allows you to log manual fires
    _G.SafeFireServer = function(remote, ...)
        if _G.EventLoggerEnabled then
            print("📤 [OUTGOING - TO SERVER]: " .. remote.Name)
            print("Data:", ...)
        end
        remote:FireServer(...)
    end
end

local function StopLogging()
    _G.EventLoggerEnabled = false
    -- Disconnect all active events to save memory
    for _, conn in pairs(LogConnections) do
        if conn then conn:Disconnect() end
    end
    LogConnections = {}
    _G.SafeFireServer = nil
    print("🚫 [EVENT LOGGER]: Module completely disabled and cleaned.")
end

-- Toggle Mantığı
if _G.EventLoggerEnabled then
    StartLogging()
else
    StopLogging()
end

-- Gerekirse manuel kapatma için fonksiyon döndür
return {
    Stop = StopLogging
}