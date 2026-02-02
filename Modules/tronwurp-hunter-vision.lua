--[[
    TRONWURP VIP - BATTLE EYE
    UI Modernized (Features untouched)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- Configuration
local ESP_ENABLED = false
local FIXED_DISTANCE = 3000
local BG_DARK = Color3.fromRGB(12, 12, 14)

-- --- COLOR PALETTE ---
-- Visible (Normal)
local COL_ESP_VIS = Color3.fromRGB(80, 180, 255)   -- Light Blue
local COL_NAME_VIS = Color3.fromRGB(180, 100, 255) -- Light Purple

-- Hidden (Invisible)
local COL_ESP_HID = Color3.fromRGB(255, 0, 0)      -- Red
local COL_TAG_HID = Color3.fromRGB(255, 80, 80)    -- Light Red ([HIDDEN])
local COL_NAME_HID = Color3.fromRGB(255, 180, 50)  -- Light Orange (Name)

local COL_DIST = Color3.fromRGB(230, 230, 230)     -- White
local ACCENT_COLOR = Color3.fromRGB(255, 40, 40)   -- UI Red

-- Modern UI Extras
local UI_PANEL = Color3.fromRGB(16, 16, 20)
local UI_PANEL_2 = Color3.fromRGB(20, 20, 26)
local UI_STROKE = Color3.fromRGB(55, 55, 70)
local UI_TEXT_DIM = Color3.fromRGB(160, 160, 175)

local IsUnloaded = false

local function toRgbStr(color)
	return string.format("rgb(%d,%d,%d)", math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255))
end

local function tween(obj, info, props)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

-- --- 1. UI SETUP ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Tronwurp_BattleEye"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = pGui

-- Small helper to build "soft shadow" without external assets
local function makeSoftShadow(parent, corner)
	local sh = Instance.new("Frame")
	sh.Name = "SoftShadow"
	sh.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	sh.BackgroundTransparency = 0.45
	sh.BorderSizePixel = 0
	sh.Size = UDim2.new(1, 26, 1, 26)
	sh.Position = UDim2.new(0, -13, 0, -13)
	sh.ZIndex = 0
	sh.Parent = parent

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, corner or 18)
	c.Parent = sh

	-- "Glow rim" accent
	local glow = Instance.new("UIStroke")
	glow.Color = ACCENT_COLOR
	glow.Thickness = 2
	glow.Transparency = 0.82
	glow.Parent = sh

	local g = Instance.new("UIGradient")
	g.Rotation = 90
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 10, 10)),
	})
	g.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.05),
		NumberSequenceKeypoint.new(1, 0.35),
	})
	g.Parent = sh

	return sh
end

-- --- 2. INTRO ---
local introFrame = Instance.new("Frame")
introFrame.Name = "IntroOverlay"
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
introFrame.BackgroundTransparency = 0
introFrame.ZIndex = 100
introFrame.Parent = screenGui

local introVignette = Instance.new("Frame")
introVignette.Name = "Vignette"
introVignette.Size = UDim2.new(1, 0, 1, 0)
introVignette.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
introVignette.BackgroundTransparency = 0.25
introVignette.ZIndex = 100
introVignette.Parent = introFrame
local introGrad = Instance.new("UIGradient")
introGrad.Rotation = 45
introGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 10)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
introGrad.Parent = introVignette

local introLabel = Instance.new("TextLabel")
introLabel.Text = ""
introLabel.Size = UDim2.new(1, 0, 0, 90)
introLabel.Position = UDim2.new(0, 0, 0.44, 0)
introLabel.BackgroundTransparency = 1
introLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
introLabel.Font = Enum.Font.GothamBlack
introLabel.TextSize = 44
introLabel.ZIndex = 101
introLabel.Parent = introFrame

local introSub = Instance.new("TextLabel")
introSub.Text = "HUNTER VISION INTERFACE"
introSub.Size = UDim2.new(1, 0, 0, 40)
introSub.Position = UDim2.new(0, 0, 0.51, 0)
introSub.BackgroundTransparency = 1
introSub.TextColor3 = Color3.fromRGB(160, 160, 175)
introSub.Font = Enum.Font.GothamMedium
introSub.TextSize = 14
introSub.ZIndex = 101
introSub.Parent = introFrame

task.spawn(function()
	wait(0.15)

	wait(0.4)
	local txt = "TRONWURP BATTLE EYE"
	for i = 1, #txt do
		introLabel.Text = string.sub(txt, 1, i)
		task.wait(0.04)
	end

	wait(0.65)
	tween(introLabel, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
	tween(introSub, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
	tween(introFrame, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
	tween(introVignette, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})

	wait(0.7)
	introFrame.Visible = false
end)

-- --- 3. MAIN GUI ---
local rootFrame = Instance.new("Frame")
rootFrame.Name = "RootContainer"
rootFrame.Size = UDim2.new(0, 600, 0, 360)
rootFrame.Position = UDim2.new(0.5, -300, 0.5, -180)
rootFrame.BackgroundTransparency = 1
rootFrame.Visible = false
rootFrame.Parent = screenGui

-- Scale (keeps it crisp on different resolutions)
local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = rootFrame

makeSoftShadow(rootFrame, 18)

local mainBg = Instance.new("Frame")
mainBg.Name = "Main"
mainBg.Size = UDim2.new(1, 0, 1, 0)
mainBg.BackgroundColor3 = UI_PANEL
mainBg.ClipsDescendants = true
mainBg.ZIndex = 2
mainBg.Parent = rootFrame
local mainCorner = Instance.new("UICorner", mainBg)
mainCorner.CornerRadius = UDim.new(0, 14)

local bgGrad = Instance.new("UIGradient")
bgGrad.Rotation = 35
bgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, UI_PANEL_2),
	ColorSequenceKeypoint.new(1, BG_DARK),
})
bgGrad.Parent = mainBg

local bgStroke = Instance.new("UIStroke")
bgStroke.Color = UI_STROKE
bgStroke.Thickness = 1
bgStroke.Transparency = 0.35
bgStroke.Parent = mainBg

-- "Top shine" strip
local shine = Instance.new("Frame")
shine.Name = "Shine"
shine.Size = UDim2.new(1, 0, 0, 2)
shine.Position = UDim2.new(0, 0, 0, 0)
shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shine.BackgroundTransparency = 0.92
shine.ZIndex = 3
shine.Parent = mainBg
local shineGrad = Instance.new("UIGradient")
shineGrad.Rotation = 0
shineGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, ACCENT_COLOR),
})
shineGrad.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.88),
	NumberSequenceKeypoint.new(1, 0.95),
})
shineGrad.Parent = shine

local topBar = Instance.new("Frame", mainBg)
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 54)
topBar.BackgroundTransparency = 1
topBar.ZIndex = 3

-- Topbar background (glass-ish)
local topGlass = Instance.new("Frame", topBar)
topGlass.Name = "Glass"
topGlass.Size = UDim2.new(1, -16, 1, -10)
topGlass.Position = UDim2.new(0, 8, 0, 6)
topGlass.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
topGlass.BackgroundTransparency = 0.15
topGlass.ZIndex = 3
local tgCorner = Instance.new("UICorner", topGlass)
tgCorner.CornerRadius = UDim.new(0, 12)
local tgStroke = Instance.new("UIStroke", topGlass)
tgStroke.Color = Color3.fromRGB(70, 70, 90)
tgStroke.Thickness = 1
tgStroke.Transparency = 0.65
local tgGrad = Instance.new("UIGradient", topGlass)
tgGrad.Rotation = 90
tgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 32)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 18)),
})
tgGrad.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.05),
	NumberSequenceKeypoint.new(1, 0.18),
})

local title = Instance.new("TextLabel", topBar)
title.Name = "Title"
title.Text = "  TRONWURP <font color='#FF2828'>VIP</font>  •  BATTLE EYE"
title.RichText = true
title.Size = UDim2.new(1, -140, 1, 0)
title.Position = UDim2.new(0, 18, 0, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 15
title.TextColor3 = Color3.fromRGB(245, 245, 250)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.ZIndex = 4

local subtitle = Instance.new("TextLabel", topBar)
subtitle.Name = "Subtitle"
subtitle.Text = "Hunter Vision Panel"
subtitle.Size = UDim2.new(1, -140, 1, 0)
subtitle.Position = UDim2.new(0, 22, 0, 16)
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 12
subtitle.TextColor3 = UI_TEXT_DIM
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.BackgroundTransparency = 1
subtitle.ZIndex = 4

-- Sidebar
local sideBar = Instance.new("Frame", mainBg)
sideBar.Name = "SideBar"
sideBar.Size = UDim2.new(0, 175, 1, -54)
sideBar.Position = UDim2.new(0, 0, 0, 54)
sideBar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
sideBar.BorderSizePixel = 0
sideBar.ZIndex = 3
local sbGrad = Instance.new("UIGradient", sideBar)
sbGrad.Rotation = 90
sbGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 24)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 15)),
})
sbGrad.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.06),
	NumberSequenceKeypoint.new(1, 0.15),
})

local sideDiv = Instance.new("Frame", sideBar)
sideDiv.Name = "Divider"
sideDiv.Size = UDim2.new(0, 1, 1, 0)
sideDiv.Position = UDim2.new(1, -1, 0, 0)
sideDiv.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
sideDiv.BackgroundTransparency = 0.55
sideDiv.BorderSizePixel = 0

local sidePad = Instance.new("UIPadding", sideBar)
sidePad.PaddingTop = UDim.new(0, 12)

local content = Instance.new("Frame", mainBg)
content.Name = "Content"
content.Size = UDim2.new(1, -175, 1, -54)
content.Position = UDim2.new(0, 175, 0, 54)
content.BackgroundTransparency = 1
content.ZIndex = 3

-- --- Pages system (kept) ---
local pages = {}
local function makePage(name)
	local p = Instance.new("Frame", content)
	p.Name = name .. "Page"
	p.Size = UDim2.new(1, 0, 1, 0)
	p.BackgroundTransparency = 1
	p.Visible = false
	p.ZIndex = 5

	local pad = Instance.new("UIPadding", p)
	pad.PaddingTop = UDim.new(0, 14)
	pad.PaddingLeft = UDim.new(0, 16)
	pad.PaddingRight = UDim.new(0, 16)

	local list = Instance.new("UIListLayout", p)
	list.Padding = UDim.new(0, 12)
	list.SortOrder = Enum.SortOrder.LayoutOrder

	pages[name] = p
	return p
end

local combatPage = makePage("Combat")
local visualsPage = makePage("Visuals")
combatPage.Visible = true

-- --- Visuals Card (Modernized, same toggle variable) ---
local hvCard = Instance.new("Frame", visualsPage)
hvCard.Name = "HunterVisionCard"
hvCard.Size = UDim2.new(1, -10, 0, 92)
hvCard.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
hvCard.LayoutOrder = 1
hvCard.ZIndex = 6
Instance.new("UICorner", hvCard).CornerRadius = UDim.new(0, 14)
local hvStroke = Instance.new("UIStroke", hvCard)
hvStroke.Color = Color3.fromRGB(70, 70, 90)
hvStroke.Transparency = 0.6
hvStroke.Thickness = 1

local hvGrad = Instance.new("UIGradient", hvCard)
hvGrad.Rotation = 25
hvGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 34)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 20)),
})
hvGrad.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.08),
	NumberSequenceKeypoint.new(1, 0.18),
})

-- Accent strip
local hvStrip = Instance.new("Frame", hvCard)
hvStrip.Name = "AccentStrip"
hvStrip.Size = UDim2.new(0, 3, 1, -18)
hvStrip.Position = UDim2.new(0, 14, 0, 9)
hvStrip.BackgroundColor3 = ACCENT_COLOR
hvStrip.BackgroundTransparency = 0.1
hvStrip.ZIndex = 7
Instance.new("UICorner", hvStrip).CornerRadius = UDim.new(1, 0)

local hvTitle = Instance.new("TextLabel", hvCard)
hvTitle.Name = "Title"
hvTitle.Text = "HUNTER VISION"
hvTitle.Size = UDim2.new(1, -170, 0, 24)
hvTitle.Position = UDim2.new(0, 28, 0, 14)
hvTitle.Font = Enum.Font.GothamBlack
hvTitle.TextSize = 18
hvTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
hvTitle.TextXAlignment = Enum.TextXAlignment.Left
hvTitle.BackgroundTransparency = 1
hvTitle.ZIndex = 7

local hvDesc = Instance.new("TextLabel", hvCard)
hvDesc.Name = "Desc"
hvDesc.Text = "Adaptive ESP (3000m)"
hvDesc.Size = UDim2.new(1, -170, 0, 20)
hvDesc.Position = UDim2.new(0, 28, 0, 40)
hvDesc.Font = Enum.Font.GothamMedium
hvDesc.TextSize = 13
hvDesc.TextColor3 = UI_TEXT_DIM
hvDesc.TextXAlignment = Enum.TextXAlignment.Left
hvDesc.BackgroundTransparency = 1
hvDesc.ZIndex = 7

-- Toggle (modern switch)
local toggle = Instance.new("TextButton", hvCard)
toggle.Name = "Toggle"
toggle.Size = UDim2.new(0, 64, 0, 30)
toggle.Position = UDim2.new(1, -86, 0.5, -15)
toggle.BackgroundColor3 = Color3.fromRGB(34, 34, 42)
toggle.AutoButtonColor = false
toggle.Text = ""
toggle.ZIndex = 7
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
local tg2Stroke = Instance.new("UIStroke", toggle)
tg2Stroke.Color = Color3.fromRGB(85, 85, 110)
tg2Stroke.Transparency = 0.6
tg2Stroke.Thickness = 1

local tCircle = Instance.new("Frame", toggle)
tCircle.Name = "Circle"
tCircle.Size = UDim2.new(0, 22, 0, 22)
tCircle.Position = UDim2.new(0, 4, 0.5, -11)
tCircle.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
tCircle.ZIndex = 8
Instance.new("UICorner", tCircle).CornerRadius = UDim.new(1, 0)
local tcStroke = Instance.new("UIStroke", tCircle)
tcStroke.Color = Color3.fromRGB(0, 0, 0)
tcStroke.Transparency = 0.85
tcStroke.Thickness = 1

-- Subtle toggle gloss
local tgGloss = Instance.new("Frame", toggle)
tgGloss.Name = "Gloss"
tgGloss.Size = UDim2.new(1, -4, 0, 10)
tgGloss.Position = UDim2.new(0, 2, 0, 2)
tgGloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tgGloss.BackgroundTransparency = 0.92
tgGloss.ZIndex = 8
Instance.new("UICorner", tgGloss).CornerRadius = UDim.new(1, 0)

-- Combat page label (kept)
local combatLabel = Instance.new("TextLabel", combatPage)
combatLabel.Text = "No Combat features available yet."
combatLabel.Size = UDim2.new(1, -10, 0, 30)
combatLabel.TextColor3 = Color3.fromRGB(120, 120, 135)
combatLabel.BackgroundTransparency = 1
combatLabel.Font = Enum.Font.GothamMedium
combatLabel.TextSize = 14
combatLabel.ZIndex = 6

-- --- Tabs (modern, with indicator) ---
local currentTab = nil
local indicator = Instance.new("Frame", sideBar)
indicator.Name = "Indicator"
indicator.Size = UDim2.new(0, 3, 0, 34)
indicator.Position = UDim2.new(0, 10, 0, 0)
indicator.BackgroundColor3 = ACCENT_COLOR
indicator.BackgroundTransparency = 0.1
indicator.ZIndex = 6
Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

local function createTab(name, icon, order)
	local btn = Instance.new("TextButton", sideBar)
	btn.Name = name .. "Tab"
	btn.Size = UDim2.new(1, -24, 0, 44)
	btn.Position = UDim2.new(0, 12, 0, 8 + (order * 52))
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundTransparency = 0.94
	btn.Text = ("   %s   %s"):format(icon, name)
	btn.TextColor3 = Color3.fromRGB(165, 165, 180)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.AutoButtonColor = false
	btn.ZIndex = 5
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

	local st = Instance.new("UIStroke", btn)
	st.Color = Color3.fromRGB(70, 70, 90)
	st.Transparency = 0.8
	st.Thickness = 1

	local function setActive(active)
		if active then
			tween(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.86,
				TextColor3 = ACCENT_COLOR
			})
			tween(st, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Transparency = 0.55
			})
			tween(indicator, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, 10, 0, btn.Position.Y.Offset + 5)
			})
		else
			tween(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.94,
				TextColor3 = Color3.fromRGB(165, 165, 180)
			})
			tween(st, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Transparency = 0.8
			})
		end
	end

	btn.MouseEnter:Connect(function()
		if currentTab ~= btn then
			tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.9})
		end
	end)
	btn.MouseLeave:Connect(function()
		if currentTab ~= btn then
			tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.94})
		end
	end)

	btn.MouseButton1Click:Connect(function()
		for _, b in pairs(sideBar:GetChildren()) do
			if b:IsA("TextButton") then
				setActive(false)
			end
		end
		currentTab = btn
		setActive(true)

		for _, pg in pairs(pages) do
			pg.Visible = false
		end
		pages[name].Visible = true
	end)

	if order == 0 then
		currentTab = btn
		setActive(true)
	end
end

createTab("Combat", "⚔️", 0)
createTab("Visuals", "👁️", 1)

-- --- Topbar controls (modern buttons) ---
local function createCtrl(txt, pos, color)
	local b = Instance.new("TextButton", topBar)
	b.Size = UDim2.new(0, 34, 0, 34)
	b.Position = UDim2.new(1, pos, 0, 10)
	b.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	b.BackgroundTransparency = 0.1
	b.AutoButtonColor = false
	b.Text = txt
	b.TextColor3 = color
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.ZIndex = 6
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)

	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(75, 75, 100)
	s.Transparency = 0.7
	s.Thickness = 1

	b.MouseEnter:Connect(function()
		tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
	end)
	b.MouseLeave:Connect(function()
		tween(b, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1})
	end)

	return b
end

local closeBtn = createCtrl("X", -48, Color3.fromRGB(255, 95, 95))
local minBtn = createCtrl("—", -92, Color3.fromRGB(230, 230, 235))

-- Animate open
task.delay(2.0, function()
	rootFrame.Visible = true
	rootFrame.Size = UDim2.new(0, 560, 0, 330)
	rootFrame.Position = UDim2.new(0.5, -280, 0.5, -165)
	mainBg.BackgroundTransparency = 0.02
	tween(rootFrame, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 600, 0, 360),
		Position = UDim2.new(0.5, -300, 0.5, -180)
	})
end)

-- --- ESP CLEANUP (unchanged) ---
local function cleanESP()
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

closeBtn.MouseButton1Click:Connect(function()
	IsUnloaded = true
	cleanESP()
	screenGui:Destroy()
end)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	local tSize = minimized and UDim2.new(0, 600, 0, 64) or UDim2.new(0, 600, 0, 360)
	tween(rootFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = tSize})
end)

toggle.MouseButton1Click:Connect(function()
	ESP_ENABLED = not ESP_ENABLED

	tween(tCircle, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = ESP_ENABLED and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 4, 0.5, -11),
		BackgroundColor3 = ESP_ENABLED and Color3.fromRGB(255, 245, 245) or Color3.fromRGB(230, 230, 235)
	})
	tween(toggle, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = ESP_ENABLED and ACCENT_COLOR or Color3.fromRGB(34, 34, 42)
	})
	tween(tg2Stroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = ESP_ENABLED and 0.75 or 0.6
	})

	if not ESP_ENABLED then
		cleanESP()
	end
end)

-- Dragging (unchanged behavior)
local dragToggle, dragStart, startPos
topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragToggle = true
		dragStart = input.Position
		startPos = rootFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		rootFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragToggle = false
	end
end)

-- --- DYNAMIC ESP ---
local function createDynamicTag(char)
	local bill = Instance.new("BillboardGui", char)
	bill.Name = "HunterTag"
	bill.Size = UDim2.new(0, 200, 0, 50)
	bill.AlwaysOnTop = true
	bill.ExtentsOffset = Vector3.new(0, 0.5, 0)
	bill.ClipsDescendants = false

	local bg = Instance.new("Frame", bill)
	bg.Name = "Container"
	bg.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
	bg.BackgroundTransparency = 0.5
	bg.AutomaticSize = Enum.AutomaticSize.XY
	bg.Size = UDim2.fromScale(0, 0)
	bg.AnchorPoint = Vector2.new(0.5, 1)
	bg.Position = UDim2.new(0.5, 0, 1, 0)
	Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)
	Instance.new("UIStroke", bg).Color = Color3.fromRGB(0, 0, 0)
	Instance.new("UIStroke", bg).Transparency = 0.6

	local pad = Instance.new("UIPadding", bg)
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 4)
	pad.PaddingLeft = UDim.new(0, 8)
	pad.PaddingRight = UDim.new(0, 8)

	local label = Instance.new("TextLabel", bg)
	label.Name = "InfoText"
	label.AutomaticSize = Enum.AutomaticSize.XY
	label.Size = UDim2.fromScale(0, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextSize = 12
	label.RichText = true
	label.TextColor3 = Color3.fromRGB(255, 255, 255)

	return bill
end

task.spawn(function()
	while task.wait(0.05) do
		if IsUnloaded then break end
		if not ESP_ENABLED then continue end

		local myChar = player.Character
		if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then continue end

		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local char = p.Character
				local dist = (myChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude

				if dist <= FIXED_DISTANCE then

					-- 1. DETECTION LOGIC
					local isHidden = false

					-- Detect if we already force-moded it (Prevent flickering)
					for _, part in pairs(char:GetDescendants()) do
						if part:IsA("BasePart") and part:FindFirstChild("GhostModeTag") then
							isHidden = true
							break
						end
					end

					-- If not flagged by tag, check transparency naturally
					if not isHidden then
						-- Check a few key parts
						local checkParts = {char:FindFirstChild("Head"), char:FindFirstChild("Torso"), char:FindFirstChild("UpperTorso")}
						for _, part in pairs(checkParts) do
							if part and part.Transparency > 0.8 then
								isHidden = true
								break
							end
						end
					end

					-- 2. APPLY VISUALS (Ghost Mode)
					if isHidden then
						for _, part in pairs(char:GetDescendants()) do
							if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
								if part.Transparency > 0.8 or part:FindFirstChild("GhostModeTag") then
									part.Transparency = 0.5
									if not part:FindFirstChild("GhostModeTag") then
										local tag = Instance.new("BoolValue", part)
										tag.Name = "GhostModeTag"
									end
								end
							end
						end
					end

					-- 3. DETERMINE COLORS
					local hlColor = isHidden and COL_ESP_HID or COL_ESP_VIS
					local nmColor = isHidden and COL_NAME_HID or COL_NAME_VIS

					-- 4. HIGHLIGHT
					local hl = char:FindFirstChild("HunterHL") or Instance.new("Highlight", char)
					hl.Name = "HunterHL"
					hl.FillColor = hlColor
					hl.FillTransparency = 0.75
					hl.OutlineColor = hlColor
					hl.OutlineTransparency = 0
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					hl.Enabled = true

					-- 5. TAG
					local tag = char:FindFirstChild("HunterTag") or createDynamicTag(char)
					tag.Enabled = true

					local hiddenPrefix = isHidden and string.format("<font color='%s'>[HIDDEN] </font>", toRgbStr(COL_TAG_HID)) or ""
					local nameText = string.format("<font color='%s'>%s</font>", toRgbStr(nmColor), p.Name)
					local distText = string.format("<font color='%s'>[%dm]</font>", toRgbStr(COL_DIST), math.floor(dist))

					tag.Container.InfoText.Text = hiddenPrefix .. nameText .. " " .. distText
					tag.ExtentsOffset = Vector3.new(0, 0.2, 0)
				else
					if char:FindFirstChild("HunterHL") then char.HunterHL.Enabled = false end
					if char:FindFirstChild("HunterTag") then char.HunterTag.Enabled = false end
				end
			end
		end
	end
end)
