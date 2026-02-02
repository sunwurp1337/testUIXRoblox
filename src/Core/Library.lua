-- Core/Library.lua
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Theme = _G.Tronwurp.Theme

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "Tronwurp_ModernUI"
    
    -- Main Frame
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.BackgroundColor3 = Theme.Main
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Theme.Border
    Stroke.Thickness = 1.2
    
    -- Sidebar (Yan Menü)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Side
    Sidebar.BorderSizePixel = 0
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)
    
    local SideTitle = Instance.new("TextLabel", Sidebar)
    SideTitle.Size = UDim2.new(1, 0, 0, 50)
    SideTitle.Text = "TRONWURP <font color='#FF2828'>VIP</font>"
    SideTitle.RichText = true
    SideTitle.Font = Enum.Font.GothamBlack
    SideTitle.TextColor3 = Color3.fromRGB(255,255,255)
    SideTitle.TextSize = 16
    SideTitle.BackgroundTransparency = 1
    
    -- Container (İçerik Alanı)
    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 160, 0, 10)
    Container.Size = UDim2.new(1, -170, 1, -20)
    Container.BackgroundTransparency = 1
    
    -- Tab System Logic
    local Tabs = {}
    function Tabs:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        
        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 8)
        
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "  " .. name
        TabBtn.TextColor3 = Theme.TextDim
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do p.Visible = false end
            Page.Visible = true
        end)
        
        return Page
    end

    -- Draggable (Sürüklenebilir yap)
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    return Tabs
end

return Library
