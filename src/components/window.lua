-- TRONWURP UI - Window (Premium, no blur)
local CoreGui = game:GetService("CoreGui")

local Window = {}
Window.__index = Window

local function Corner(obj, px)
  local c = Instance.new("UICorner")
  c.CornerRadius = UDim.new(0, px)
  c.Parent = obj
  return c
end

local function Stroke(obj, thickness, color, transparency)
  local s = Instance.new("UIStroke")
  s.Thickness = thickness or 1
  s.Color = color
  s.Transparency = transparency or 0.2
  s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  s.Parent = obj
  return s
end

local function Padding(obj, l,t,r,b)
  local p = Instance.new("UIPadding")
  p.PaddingLeft = UDim.new(0,l or 0)
  p.PaddingTop = UDim.new(0,t or 0)
  p.PaddingRight = UDim.new(0,r or 0)
  p.PaddingBottom = UDim.new(0,b or 0)
  p.Parent = obj
  return p
end

local function Shadow(parent, assetId)
  local sh = Instance.new("ImageLabel")
  sh.Name = "Shadow"
  sh.AnchorPoint = Vector2.new(0.5, 0.5)
  sh.Position = UDim2.new(0.5, 0, 0.5, 10)
  sh.Size = UDim2.new(1, 72, 1, 72)
  sh.BackgroundTransparency = 1
  sh.Image = assetId
  sh.ImageTransparency = 0.55
  sh.ImageColor3 = Color3.new(0,0,0)
  sh.ScaleType = Enum.ScaleType.Slice
  sh.SliceCenter = Rect.new(49,49,450,450)
  sh.ZIndex = 0
  sh.Parent = parent
  return sh
end

function Window.new(ctx, cfg)
  local self = setmetatable({}, Window)
  self.ctx = ctx
  self.cfg = cfg or {}
  self.Theme = ctx.Theme
  self.Tween = ctx.Tween

  if CoreGui:FindFirstChild("Tronwurp_UI") then
    CoreGui.Tronwurp_UI:Destroy()
  end

  local gui = Instance.new("ScreenGui")
  gui.Name = "Tronwurp_UI"
  gui.IgnoreGuiInset = true
  gui.ResetOnSpawn = false
  gui.Parent = CoreGui

  local main = Instance.new("Frame")
  main.Name = "Main"
  main.AnchorPoint = Vector2.new(0.5, 0.5)
  main.Position = UDim2.new(0.5, 0, 0.5, 0)
  main.Size = UDim2.new(0, 720, 0, 440)
  main.BackgroundColor3 = self.Theme.Bg1
  main.BorderSizePixel = 0
  main.Parent = gui
  Corner(main, 18)

  Shadow(main, ctx.Assets.Shadow)

  -- Double-stroke: crisp border + soft glow edge
  Stroke(main, 1, self.Theme.Border, 0.35)

  local glowStroke = Instance.new("UIStroke")
  glowStroke.Thickness = 2
  glowStroke.Color = self.Theme.Glow
  glowStroke.Transparency = 0.88
  glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  glowStroke.Parent = main

  -- Depth gradient
  local grad = Instance.new("UIGradient")
  grad.Rotation = 90
  grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, self.Theme.Bg2),
    ColorSequenceKeypoint.new(1, self.Theme.Bg0),
  })
  grad.Parent = main

  -- Noise overlay (premium “material” feel)
  local noise = Instance.new("ImageLabel")
  noise.Name = "Noise"
  noise.BackgroundTransparency = 1
  noise.Size = UDim2.new(1,0,1,0)
  noise.Image = ctx.Assets.Noise
  noise.ImageTransparency = 0.86
  noise.ScaleType = Enum.ScaleType.Tile
  noise.TileSize = UDim2.new(0, 180, 0, 180)
  noise.ZIndex = 6
  noise.Parent = main

  -- Topbar (drag handle)
  local top = Instance.new("Frame")
  top.Name = "Topbar"
  top.BackgroundTransparency = 1
  top.Size = UDim2.new(1,0,0,66)
  top.Parent = main

  local title = Instance.new("TextLabel")
  title.BackgroundTransparency = 1
  title.Position = UDim2.new(0, 18, 0, 14)
  title.Size = UDim2.new(1, -160, 0, 26)
  title.Font = Enum.Font.GothamBlack
  title.TextSize = 20
  title.TextXAlignment = Enum.TextXAlignment.Left
  title.TextColor3 = self.Theme.Text
  title.Text = (cfg.Title or "TRONWURP")
  title.ZIndex = 10
  title.Parent = top

  local subtitle = Instance.new("TextLabel")
  subtitle.BackgroundTransparency = 1
  subtitle.Position = UDim2.new(0, 18, 0, 40)
  subtitle.Size = UDim2.new(1, -160, 0, 18)
  subtitle.Font = Enum.Font.GothamMedium
  subtitle.TextSize = 12
  subtitle.TextXAlignment = Enum.TextXAlignment.Left
  subtitle.TextColor3 = self.Theme.Muted
  subtitle.Text = (cfg.Subtitle or "Premium Dark UI Framework")
  subtitle.ZIndex = 10
  subtitle.Parent = top

  local function smallBtn(text, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 42, 0, 36)
    b.Position = UDim2.new(1, x, 0, 16)
    b.BackgroundColor3 = self.Theme.Card
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = self.Theme.Muted
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.AutoButtonColor = false
    b.ZIndex = 10
    b.Parent = top
    Corner(b, 12)
    Stroke(b, 1, self.Theme.Border, 0.4)

    b.MouseEnter:Connect(function()
      self.Tween:To(b, self.Tween.Fast, {BackgroundColor3 = Color3.fromRGB(30,30,44)})
      self.Tween:To(b, self.Tween.Fast, {TextColor3 = self.Theme.Text})
    end)
    b.MouseLeave:Connect(function()
      self.Tween:To(b, self.Tween.Fast, {BackgroundColor3 = self.Theme.Card})
      self.Tween:To(b, self.Tween.Fast, {TextColor3 = self.Theme.Muted})
    end)

    return b
  end

  local close = smallBtn("✕", -56)
  close.MouseButton1Click:Connect(function()
    gui:Destroy()
  end)

  -- Body
  local body = Instance.new("Frame")
  body.Name = "Body"
  body.BackgroundTransparency = 1
  body.Position = UDim2.new(0,0,0,66)
  body.Size = UDim2.new(1,0,1,-66)
  body.Parent = main

  -- Sidebar
  local sidebar = Instance.new("Frame")
  sidebar.Name = "Sidebar"
  sidebar.Size = UDim2.new(0, 220, 1, 0)
  sidebar.BackgroundColor3 = self.Theme.Bg2
  sidebar.BorderSizePixel = 0
  sidebar.Parent = body
  Corner(sidebar, 18)
  Stroke(sidebar, 1, self.Theme.Border, 0.35)
  Padding(sidebar, 12, 12, 12, 12)

  local sbGrad = Instance.new("UIGradient")
  sbGrad.Rotation = 90
  sbGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(26,26,38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(16,16,22)),
  })
  sbGrad.Parent = sidebar

  -- Content
  local content = Instance.new("Frame")
  content.Name = "Content"
  content.BackgroundTransparency = 1
  content.Position = UDim2.new(0, 220, 0, 0)
  content.Size = UDim2.new(1, -220, 1, 0)
  content.Parent = body

  local surface = Instance.new("Frame")
  surface.Name = "Surface"
  surface.BackgroundColor3 = self.Theme.Card
  surface.BorderSizePixel = 0
  surface.Position = UDim2.new(0, 12, 0, 12)
  surface.Size = UDim2.new(1, -24, 1, -24)
  surface.Parent = content
  Corner(surface, 18)
  Stroke(surface, 1, self.Theme.Border, 0.35)
  Padding(surface, 18, 18, 18, 18)

  local accentLine = Instance.new("Frame")
  accentLine.Name = "AccentLine"
  accentLine.BackgroundColor3 = self.Theme.Accent
  accentLine.BackgroundTransparency = 0.15
  accentLine.BorderSizePixel = 0
  accentLine.Size = UDim2.new(1, 0, 0, 2)
  accentLine.Position = UDim2.new(0,0,0,0)
  accentLine.ZIndex = 7
  accentLine.Parent = surface
  Corner(accentLine, 99)

  ctx.Draggable:Make(main, top)

  self.Gui = gui
  self.Main = main
  self.Sidebar = sidebar
  self.Surface = surface

  return self
end

function Window:Destroy()
  if self.Gui then self.Gui:Destroy() end
end

return Window
