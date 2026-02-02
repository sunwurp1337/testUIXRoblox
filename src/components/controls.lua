-- TRONWURP UI - Controls (Premium)

local Controls = {}

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
  s.Transparency = transparency or 0.3
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

local function EnsureLayout(page)
  if page:FindFirstChild("ControlsHolder") then
    return page.ControlsHolder
  end

  local holder = Instance.new("Frame")
  holder.Name = "ControlsHolder"
  holder.BackgroundTransparency = 1
  holder.Position = UDim2.new(0,0,0,64)
  holder.Size = UDim2.new(1,0,1,-64)
  holder.Parent = page

  local list = Instance.new("UIListLayout")
  list.Padding = UDim.new(0, 12)
  list.SortOrder = Enum.SortOrder.LayoutOrder
  list.Parent = holder

  return holder
end

local function Card(ctx, parent, height)
  local frame = Instance.new("Frame")
  frame.BackgroundColor3 = Color3.fromRGB(18,18,26)
  frame.BorderSizePixel = 0
  frame.Size = UDim2.new(1, 0, 0, height)
  frame.Parent = parent
  Corner(frame, 16)
  Stroke(frame, 1, ctx.Theme.Border, 0.36)
  Padding(frame, 14, 12, 14, 12)

  local grad = Instance.new("UIGradient")
  grad.Rotation = 90
  grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24,24,36)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(16,16,22)),
  })
  grad.Parent = frame

  return frame
end

function Controls:AddButton(tabs, page, opt)
  opt = opt or {}
  local ctx = tabs.ctx
  local holder = EnsureLayout(page)

  local card = Card(ctx, holder, 54)

  local btn = Instance.new("TextButton")
  btn.BackgroundColor3 = Color3.fromRGB(28,28,42)
  btn.BorderSizePixel = 0
  btn.Size = UDim2.new(1,0,1,0)
  btn.Text = opt.Name or "Button"
  btn.TextColor3 = ctx.Theme.Text
  btn.Font = Enum.Font.GothamSemibold
  btn.TextSize = 13
  btn.AutoButtonColor = false
  btn.Parent = card
  Corner(btn, 14)
  Stroke(btn, 1, ctx.Theme.Border, 0.4)

  btn.MouseEnter:Connect(function()
    ctx.Tween:To(btn, ctx.Tween.Fast, {BackgroundColor3 = Color3.fromRGB(34,34,52)})
  end)
  btn.MouseLeave:Connect(function()
    ctx.Tween:To(btn, ctx.Tween.Fast, {BackgroundColor3 = Color3.fromRGB(28,28,42)})
  end)
  btn.MouseButton1Down:Connect(function()
    ctx.Tween:To(btn, ctx.Tween.Fast, {Size = UDim2.new(1,0,1,-2)})
  end)
  btn.MouseButton1Up:Connect(function()
    ctx.Tween:To(btn, ctx.Tween.Fast, {Size = UDim2.new(1,0,1,0)})
  end)

  btn.MouseButton1Click:Connect(function()
    if opt.Callback then opt.Callback() end
  end)

  return btn
end

function Controls:AddToggle(tabs, page, opt)
  opt = opt or {}
  local ctx = tabs.ctx
  local holder = EnsureLayout(page)

  local card = Card(ctx, holder, 66)

  local label = Instance.new("TextLabel")
  label.BackgroundTransparency = 1
  label.Size = UDim2.new(1, -90, 0, 22)
  label.Text = opt.Name or "Toggle"
  label.TextColor3 = ctx.Theme.Text
  label.Font = Enum.Font.GothamMedium
  label.TextSize = 13
  label.TextXAlignment = Enum.TextXAlignment.Left
  label.Parent = card

  local hint = Instance.new("TextLabel")
  hint.BackgroundTransparency = 1
  hint.Position = UDim2.new(0,0,0,26)
  hint.Size = UDim2.new(1, -90, 0, 18)
  hint.Text = opt.Description or ""
  hint.TextColor3 = ctx.Theme.Muted
  hint.Font = Enum.Font.GothamMedium
  hint.TextSize = 11
  hint.TextXAlignment = Enum.TextXAlignment.Left
  hint.Parent = card

  local toggle = Instance.new("TextButton")
  toggle.BackgroundColor3 = Color3.fromRGB(28,28,42)
  toggle.BorderSizePixel = 0
  toggle.AnchorPoint = Vector2.new(1,0.5)
  toggle.Position = UDim2.new(1, 0, 0.5, 0)
  toggle.Size = UDim2.new(0, 66, 0, 30)
  toggle.Text = ""
  toggle.AutoButtonColor = false
  toggle.Parent = card
  Corner(toggle, 999)
  Stroke(toggle, 1, ctx.Theme.Border, 0.45)

  local knob = Instance.new("Frame")
  knob.BackgroundColor3 = ctx.Theme.Text
  knob.BorderSizePixel = 0
  knob.Size = UDim2.new(0, 24, 0, 24)
  knob.Position = UDim2.new(0, 3, 0.5, -12)
  knob.Parent = toggle
  Corner(knob, 999)

  local state = opt.Default and true or false

  local function render()
    if state then
      ctx.Tween:To(toggle, ctx.Tween.Fast, {BackgroundColor3 = ctx.Theme.Accent})
      ctx.Tween:To(knob, ctx.Tween.Fast, {Position = UDim2.new(1, -27, 0.5, -12)})
    else
      ctx.Tween:To(toggle, ctx.Tween.Fast, {BackgroundColor3 = Color3.fromRGB(28,28,42)})
      ctx.Tween:To(knob, ctx.Tween.Fast, {Position = UDim2.new(0, 3, 0.5, -12)})
    end
  end

  toggle.MouseButton1Click:Connect(function()
    state = not state
    render()
    if opt.Callback then opt.Callback(state) end
  end)

  render()

  return {
    Set = function(v)
      state = v and true or false
      render()
    end
  }
end

function Controls:AddSlider(tabs, page, opt)
  opt = opt or {}
  local ctx = tabs.ctx
  local holder = EnsureLayout(page)

  local min = opt.Min or 0
  local max = opt.Max or 100
  local val = opt.Default or min
  if val < min then val = min end
  if val > max then val = max end

  local card = Card(ctx, holder, 78)

  local label = Instance.new("TextLabel")
  label.BackgroundTransparency = 1
  label.Size = UDim2.new(1, 0, 0, 22)
  label.Text = opt.Name or "Slider"
  label.TextColor3 = ctx.Theme.Text
  label.Font = Enum.Font.GothamMedium
  label.TextSize = 13
  label.TextXAlignment = Enum.TextXAlignment.Left
  label.Parent = card

  local valueText = Instance.new("TextLabel")
  valueText.BackgroundTransparency = 1
  valueText.AnchorPoint = Vector2.new(1,0)
  valueText.Position = UDim2.new(1, 0, 0, 0)
  valueText.Size = UDim2.new(0, 90, 0, 22)
  valueText.Text = tostring(val)
  valueText.TextColor3 = ctx.Theme.Muted
  valueText.Font = Enum.Font.GothamMedium
  valueText.TextSize = 12
  valueText.TextXAlignment = Enum.TextXAlignment.Right
  valueText.Parent = card

  local bar = Instance.new("Frame")
  bar.BackgroundColor3 = Color3.fromRGB(28,28,42)
  bar.BorderSizePixel = 0
  bar.Position = UDim2.new(0, 0, 0, 40)
  bar.Size = UDim2.new(1, 0, 0, 12)
  bar.Parent = card
  Corner(bar, 999)
  Stroke(bar, 1, ctx.Theme.Border, 0.45)

  local fill = Instance.new("Frame")
  fill.BackgroundColor3 = ctx.Theme.Accent
  fill.BorderSizePixel = 0
  fill.Size = UDim2.new(0, 0, 1, 0)
  fill.Parent = bar
  Corner(fill, 999)

  local knob = Instance.new("Frame")
  knob.BackgroundColor3 = ctx.Theme.Text
  knob.BorderSizePixel = 0
  knob.Size = UDim2.new(0, 18, 0, 18)
  knob.AnchorPoint = Vector2.new(0.5, 0.5)
  knob.Position = UDim2.new(0, 0, 0.5, 0)
  knob.Parent = bar
  Corner(knob, 999)

  local dragging = false

  local function setValueFromX(x)
    local absPos = bar.AbsolutePosition.X
    local absSize = bar.AbsoluteSize.X
    local t = (x - absPos) / absSize
    if t < 0 then t = 0 end
    if t > 1 then t = 1 end

    local newVal = math.floor((min + (max - min) * t) + 0.5)
    val = newVal
    valueText.Text = tostring(val)

    ctx.Tween:To(fill, ctx.Tween.Fast, {Size = UDim2.new(t, 0, 1, 0)})
    ctx.Tween:To(knob, ctx.Tween.Fast, {Position = UDim2.new(t, 0, 0.5, 0)})

    if opt.Callback then opt.Callback(val) end
  end

  local function render()
    local t = (val - min) / (max - min)
    if t ~= t then t = 0 end
    fill.Size = UDim2.new(t, 0, 1, 0)
    knob.Position = UDim2.new(t, 0, 0.5, 0)
    valueText.Text = tostring(val)
  end

  bar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
      dragging = true
      setValueFromX(input.Position.X)
    end
  end)

  bar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
      dragging = false
    end
  end)

  game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
      setValueFromX(input.Position.X)
    end
  end)

  render()

  return {
    Set = function(v)
      v = tonumber(v) or min
      if v < min then v = min end
      if v > max then v = max end
      val = v
      render()
    end
  }
end

return Controls
