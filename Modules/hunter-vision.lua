-- [[ TRONWURP BATTLE EYE - CORE ESP ENGINE ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Configuration (Main script üzerinden _G.HunterVisionEnabled ile kontrol edilir)
local FIXED_DISTANCE = 3000
local COL_ESP_VIS = Color3.fromRGB(80, 180, 255)   -- Light Blue
local COL_NAME_VIS = Color3.fromRGB(180, 100, 255) -- Light Purple
local COL_ESP_HID = Color3.fromRGB(255, 0, 0)      -- Red
local COL_TAG_HID = Color3.fromRGB(255, 80, 80)    -- Light Red
local COL_NAME_HID = Color3.fromRGB(255, 180, 50)  -- Light Orange
local COL_DIST = Color3.fromRGB(230, 230, 235)

local function toRgbStr(color)
    return string.format("rgb(%d,%d,%d)", math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255))
end

-- --- 1. CLEANUP FUNCTION ---
local function CleanESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            if p.Character:FindFirstChild("HunterHL") then p.Character.HunterHL:Destroy() end
            if p.Character:FindFirstChild("HunterTag") then p.Character.HunterTag:Destroy() end
            for _, part in pairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") and part:FindFirstChild("GhostModeTag") then
                    part.Transparency = 1
                    part.GhostModeTag:Destroy()
                end
            end
        end
    end
end

-- --- 2. TAG CREATION ---
local function CreateDynamicTag(char)
    local bill = Instance.new("BillboardGui", char)
    bill.Name = "HunterTag"
    bill.Size = UDim2.new(0, 200, 0, 50)
    bill.AlwaysOnTop = true
    bill.ExtentsOffset = Vector3.new(0, 0.5, 0)
    
    local bg = Instance.new("Frame", bill)
    bg.Name = "Container"
    bg.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    bg.BackgroundTransparency = 0.5
    bg.AutomaticSize = Enum.AutomaticSize.XY
    bg.AnchorPoint = Vector2.new(0.5, 1)
    bg.Position = UDim2.new(0.5, 0, 1, 0)
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)
    
    local label = Instance.new("TextLabel", bg)
    label.Name = "InfoText"
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.RichText = true
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UIPadding", bg).PaddingLeft = UDim.new(0, 8)
    
    return bill
end

-- --- 3. MAIN LOOP ---
task.spawn(function()
    while task.wait(0.1) do
        -- Main.lua'daki Toggle kapalıysa veya modül durdurulduysa
        if not _G.HunterVisionEnabled then 
            CleanESP()
            break 
        end

        local myChar = player.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then continue end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local char = p.Character
                local dist = (myChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude

                if dist <= FIXED_DISTANCE then
                    -- Detection Logic (Ghost/Invis check)
                    local isHidden = false
                    local checkParts = {char:FindFirstChild("Head"), char:FindFirstChild("Torso"), char:FindFirstChild("UpperTorso")}
                    for _, part in pairs(checkParts) do
                        if part and part.Transparency > 0.7 then isHidden = true break end
                    end

                    -- Ghost Mode Re-render (Görünmezleri görünür yapma)
                    if isHidden then
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") and part.Transparency > 0.7 then
                                part.Transparency = 0.5
                                if not part:FindFirstChild("GhostModeTag") then
                                    Instance.new("BoolValue", part).Name = "GhostModeTag"
                                end
                            end
                        end
                    end

                    local hlColor = isHidden and COL_ESP_HID or COL_ESP_VIS
                    local nmColor = isHidden and COL_NAME_HID or COL_NAME_VIS

                    -- Highlight Apply
                    local hl = char:FindFirstChild("HunterHL") or Instance.new("Highlight", char)
                    hl.Name = "HunterHL"
                    hl.FillColor = hlColor
                    hl.OutlineColor = hlColor
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Enabled = true

                    -- Tag Apply
                    local tag = char:FindFirstChild("HunterTag") or CreateDynamicTag(char)
                    tag.Enabled = true
                    
                    local hiddenPrefix = isHidden and string.format("<font color='%s'>[HIDDEN] </font>", toRgbStr(COL_TAG_HID)) or ""
                    local nameText = string.format("<font color='%s'>%s</font>", toRgbStr(nmColor), p.Name)
                    local distText = string.format("<font color='%s'>[%dm]</font>", toRgbStr(COL_DIST), math.floor(dist))

                    tag.Container.InfoText.Text = hiddenPrefix .. nameText .. " " .. distText
                else
                    if char:FindFirstChild("HunterHL") then char.HunterHL.Enabled = false end
                    if char:FindFirstChild("HunterTag") then char.HunterTag.Enabled = false end
                end
            end
        end
    end
end)

return CleanESP