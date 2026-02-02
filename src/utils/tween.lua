-- TRONWURP UI - Tween Utility

local TweenService = game:GetService("TweenService")

local Tween = {}

Tween.Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
Tween.Med  = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
Tween.Slow = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function Tween:To(obj, info, props)
  local t = TweenService:Create(obj, info, props)
  t:Play()
  return t
end

return Tween
