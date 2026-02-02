-- TRONWURP UI - Theme Tokens

local Theme = {}
Theme.__index = Theme

function Theme:Create(cfg)
  cfg = cfg or {}
  local accent = cfg.Accent or Color3.fromRGB(255, 70, 90)

  local t = {
    Bg0   = Color3.fromRGB(10, 10, 14),
    Bg1   = Color3.fromRGB(14, 14, 18),
    Bg2   = Color3.fromRGB(18, 18, 26),
    Card  = Color3.fromRGB(20, 20, 30),

    Text  = Color3.fromRGB(238, 238, 244),
    Muted = Color3.fromRGB(152, 152, 170),

    Accent = accent,
    Border = Color3.fromRGB(56, 56, 82),

    Shadow = Color3.fromRGB(0, 0, 0),
    Glow   = accent,
  }

  return setmetatable(t, Theme)
end

return setmetatable(Theme, Theme)
