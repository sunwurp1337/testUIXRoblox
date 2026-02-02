-- TRONWURP UI - Tabs (Animated, premium)

local Tabs = {}
Tabs.__index = Tabs

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
  s.Transparency = transparency or 0.25
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

function Tabs.new(ctx, window)
  local self = setmetatable({}, Tabs)
  self.ctx = ctx
  self.win = window
  self.Theme = ctx.Theme
  self.Tween = ctx.Tween
  self.Assets = ctx.Assets

  self.current = nil
  self.tabs = {}
  self.pages = {}

  local holder = Instance.new("Frame")
  holder.Name = "TabList"
  holder.BackgroundTransparency = 1
  holder.Size = UDim2.new(1,0,1,0)
  holder.Parent = window.Sidebar

  local list = Instance.new("UIListLayout")
  list.Padding = UDim.new(0, 10)
  list.SortOrder = Enum.SortOrder.LayoutOrder
  list.Parent = holder

  local indicator = Instance.new("Frame")
  indicator.Name = "Indicator"
  indicator.BackgroundColor3 = self.Theme.Accent
  indicator.BackgroundTransparency = 0.2
  indicator.BorderSizePixel = 0
  indicator.Size = UDim2.new(0, 3, 0, 30)
  indicator.Position = UDim2.new(0, 6, 0, 12)
  indicator.Parent = window.Sidebar
  Corner(indicator, 99)
  self.Indicator = indicator
  self.Holder = holder

  local pages = Instance.new("Folder")
  pages.Name = "Pages"
  pages.Parent = window.Surface
  self.PagesFolder = pages

  return self
end

local function makePage(self, name)
  local page = Instance.new("Frame")
  page.Name = name
  page.BackgroundTransparency = 1
  page.Size = UDim2.new(1,0,1,0)
  page.Visible = false
  page.Parent = self.PagesFolder

  local title = Instance.new("TextLabel")
  title.BackgroundTransparency = 1
  title.Size = UDim2.new(1,0,0,28)
  title.Font = Enum.Font.GothamBold
  title.TextSize = 18
  title.TextXAlignment = Enum.TextXAlignment.Left
  title.TextColor3 = self.Theme.Text
  title.Text = name
  title.Parent = page

  local hint = Instance.new("TextLabel")
  hint.BackgroundTransparency = 1
  hint.Position = UDim2.new(0,0,0,30)
  hint.Size = UDim2.new(1,0,0,18)
  hint.Font = Enum.Font.GothamMedium
  hint.TextSize = 12
  hint.TextXAlignment = Enum.TextXAlignment.Left
  hint.TextColor3 = self.Theme.Muted
  hint.Text = "Add your controls here."
  hint.Parent = page

  return page
end

function Tabs:CreateTab(name, iconKey)
  local wrap = Instance.new("Frame")
  wrap.BackgroundTransparency = 1
  wrap.Size = UDim2.new(1,0,0,46)
  wrap.Parent = self.Holder

  local btn = Instance.new("TextButton")
  btn.BackgroundColor3 = self.Theme.Card
  btn.BorderSizePixel = 0
  btn.Size = UDim2.new(1,0,1,0)
  btn.Text = ""
  btn.AutoButtonColor = false
  btn.Parent = wrap
  Corner(btn, 14)
  Stroke(btn, 1, self.Theme.Border, 0.38)
  Padding(btn, 14, 0, 14, 0)

  local grad = Instance.new("UIGradient")
  grad.Rotation = 90
  grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24,24,36)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18,18,26)),
  })
  grad.Parent = btn

  local icon = Instance.new("TextLabel")
  icon.BackgroundTransparency = 1
  icon.Size = UDim2.new(0, 26, 1, 0)
  icon.Font = Enum.Font.GothamBold
  icon.TextSize = 14
  icon.TextXAlignment = Enum.TextXAlignment.Left
  icon.TextColor3 = self.Theme.Muted
  icon.Text = self.Assets.IconMap[iconKey] or self.Assets.IconMap.dot
  icon.Parent = btn

  local label = Instance.new("TextLabel")
  label.BackgroundTransparency = 1
  label.Position = UDim2.new(0, 28, 0, 0)
  label.Size = UDim2.new(1, -60, 1, 0)
  label.Font = Enum.Font.GothamMedium
  label.TextSize = 13
  label.TextXAlignment = Enum.TextXAlignment.Left
  label.TextColor3 = self.Theme.Muted
  label.Text = name
  label.Parent = btn

  local pill = Instance.new("Frame")
  pill.BackgroundColor3 = self.Theme.Accent
  pill.BackgroundTransparency = 1
  pill.BorderSizePixel = 0
  pill.Size = UDim2.new(0, 8, 0, 8)
  pill.AnchorPoint = Vector2.new(1, 0.5)
  pill.Position = UDim2.new(1, 0, 0.5, 0)
  pill.Parent = btn
  Corner(pill, 999)

  local page = makePage(self, name)

  btn.MouseEnter:Connect(function()
    if self.current ~= name then
      self.Tween:To(btn, self.Tween.Fast, {BackgroundColor3 = Color3.fromRGB(32,32,48)})
      self.Tween:To(label, self.Tween.Fast, {TextColor3 = self.Theme.Text})
      self.Tween:To(icon, self.Tween.Fast, {TextColor3 = self.Theme.Text})
    end
  end)

  btn.MouseLeave:Connect(function()
    if self.current ~= name then
      self.Tween:To(btn, self.Tween.Fast, {BackgroundColor3 = self.Theme.Card})
      self.Tween:To(label, self.Tween.Fast, {TextColor3 = self.Theme.Muted})
      self.Tween:To(icon, self.Tween.Fast, {TextColor3 = self.Theme.Muted})
    end
  end)

  btn.MouseButton1Down:Connect(function()
    self.Tween:To(btn, self.Tween.Fast, {Size = UDim2.new(1,0,1,-2)})
  end)
  btn.MouseButton1Up:Connect(function()
    self.Tween:To(btn, self.Tween.Fast, {Size = UDim2.new(1,0,1,0)})
  end)

  btn.MouseButton1Click:Connect(function()
    self:Select(name)
  end)

  self.tabs[name] = { Wrap = wrap, Button = btn, Label = label, Icon = icon, Pill = pill }
  self.pages[name] = page

  local tabApi = {}
  function tabApi:AddToggle(opt) return self.ctx.Controls:AddToggle(self, page, opt) end
  function tabApi:AddSlider(opt) return self.ctx.Controls:AddSlider(self, page, opt) end
  function tabApi:AddButton(opt) return self.ctx.Controls:AddButton(self, page, opt) end
  return tabApi
end

function Tabs:Select(name)
  if not self.tabs[name] then return end
  if self.current == name then return end
  self.current = name

  for tabName, t in pairs(self.tabs) do
    local active = (tabName == name)
    self.Tween:To(t.Button, self.Tween.Fast, {
      BackgroundColor3 = active and Color3.fromRGB(34,34,52) or self.Theme.Card
    })
    self.Tween:To(t.Label, self.Tween.Fast, {
      TextColor3 = active and self.Theme.Text or self.Theme.Muted
    })
    self.Tween:To(t.Icon, self.Tween.Fast, {
      TextColor3 = active and self.Theme.Accent or self.Theme.Muted
    })
    self.Tween:To(t.Pill, self.Tween.Fast, {
      BackgroundTransparency = active and 0.15 or 1
    })
  end

  for pageName, pg in pairs(self.pages) do
    pg.Visible = (pageName == name)
  end

  task.defer(function()
    local wrap = self.tabs[name].Wrap
    local relY = wrap.AbsolutePosition.Y - self.win.Sidebar.AbsolutePosition.Y
    self.Tween:To(self.Indicator, self.Tween.Med, {Position = UDim2.new(0, 6, 0, relY + 8)})
  end)
end

return Tabs
