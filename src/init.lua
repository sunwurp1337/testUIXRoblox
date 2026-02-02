
-- TRONWURP UI - Init (No hardcoded user/repo)
-- Loads modules via BaseUrl (getgenv().TRONWURP_BASEURL or opts.BaseUrl)

local function assertHttp()
  if not game or not game.HttpGet then
    error("[TRONWURP] game:HttpGet not available.")
  end
end

local function getBaseUrl(opts)
  opts = opts or {}
  local base = opts.BaseUrl or (getgenv and getgenv().TRONWURP_BASEURL)
  if not base then
    error("[TRONWURP] BaseUrl not set. Set getgenv().TRONWURP_BASEURL or pass {BaseUrl=...}.")
  end
  if base:sub(-1) ~= "/" then base = base .. "/" end
  return base
end

local function makeImporter(base)
  local cache = {}

  local function fetch(path)
    assertHttp()
    local url = base .. path
    return game:HttpGet(url)
  end

  local function import(path)
    if cache[path] then
      return cache[path]
    end
    local src = fetch(path)
    local fn, err = loadstring(src)
    if not fn then
      error("[TRONWURP] Failed loading " .. path .. ": " .. tostring(err))
    end
    local mod = fn()
    cache[path] = mod
    return mod
  end

  return import
end

return function(opts)
  local base = getBaseUrl(opts)
  local import = makeImporter(base)

  local Theme     = import("theme.lua")
  local Tween     = import("utils/tween.lua")
  local Assets    = import("utils/assets.lua")
  local Draggable = import("utils/draggable.lua")

  local Window   = import("components/window.lua")
  local Tabs     = import("components/tabs.lua")
  local Controls = import("components/controls.lua")

  local Tronwurp = {}
  Tronwurp.__index = Tronwurp

  function Tronwurp:CreateWindow(config)
    config = config or {}
    local theme = Theme:Create(config)

    local ctx = {
      Theme = theme,
      Tween = Tween,
      Assets = Assets,
      Draggable = Draggable,
      Controls = Controls,
    }

    local win = Window.new(ctx, config)
    local tabs = Tabs.new(ctx, win)

    local api = {}

    function api:CreateTab(name, icon)
      return tabs:CreateTab(name, icon)
    end

    function api:SelectTab(name)
      tabs:Select(name)
    end

    function api:Destroy()
      win:Destroy()
    end

    return api
  end

  return setmetatable(Tronwurp, Tronwurp)
end
