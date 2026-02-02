-- TRONWURP Loader
-- Loads config from:
-- 1) local file tronwurp_repo.lua (readfile)
-- 2) remote src/tronwurp_repo.lua (HttpGet)
-- 3) fallback: parse this loader URL (repo/branch) and assume /src/
--
-- Then it loads src/init.lua and returns the Tronwurp factory.

local HttpGet = function(url)
    return game:HttpGet(url)
end

local function safeLoad(src)
    local fn, err = loadstring(src)
    if not fn then return nil, err end
    local ok, res = pcall(fn)
    if not ok then return nil, res end
    return res
end

local function safeHttp(url)
    local ok, res = pcall(HttpGet, url)
    if not ok then return nil end
    return res
end

-- 1) Try local config (executor filesystem)
local function loadLocalConfig()
    if isfile and readfile and isfile("tronwurp_repo.lua") then
        local cfgSrc = readfile("tronwurp_repo.lua")
        local cfg, err = safeLoad(cfgSrc)
        if type(cfg) == "table" then
            return cfg
        end
    end
    return nil
end

-- 2) Try remote config at base/src/tronwurp_repo.lua
local function loadRemoteConfig(base)
    local src = safeHttp(base .. "tronwurp_repo.lua")
    if not src then return nil end
    local cfg = safeLoad(src)
    if type(cfg) == "table" then
        return cfg
    end
    return nil
end

-- 3) Figure out base url
local function deriveBaseFromLoaderUrl()
    -- Best-effort: parse from "https://raw.githubusercontent.com/user/repo/branch/src/tronwurp-loader.lua"
    -- If executor provides getscripturl(), we can use it. Otherwise fallback to your known repo.
    local loaderUrl = nil
    if getscripturl then
        local ok, u = pcall(getscripturl)
        if ok and type(u) == "string" then
            loaderUrl = u
        end
    end

    -- Hard fallback: your current repo
    if not loaderUrl then
        loaderUrl = "https://raw.githubusercontent.com/sunwurp1337/testUIXRoblox/main/src/tronwurp-loader.lua"
    end

    -- chop until "/src/"
    local base = loaderUrl:match("^(.-/src/)")
    if not base then
        -- if loader is not in /src/, assume root and append /src/
        base = loaderUrl:match("^(.-/)[^/]+$")
        base = (base or "https://raw.githubusercontent.com/sunwurp1337/testUIXRoblox/main/") .. "src/"
    end

    return base
end

local base = deriveBaseFromLoaderUrl()

-- Load config: local -> remote -> fallback
local cfg = loadLocalConfig()
if not cfg then
    cfg = loadRemoteConfig(base)
end

if type(cfg) == "table" then
    local user = cfg.User or "sunwurp1337"
    local repo = cfg.Repo or "testUIXRoblox"
    local branch = cfg.Branch or "main"
    base = ("https://raw.githubusercontent.com/%s/%s/%s/src/"):format(user, repo, branch)
end

-- expose base url globally (init.lua reads it too if needed)
if getgenv then
    getgenv().TRONWURP_BASEURL = base
end

-- Load init factory
local initSrc = safeHttp(base .. "init.lua")
if not initSrc then
    error("[TRONWURP] Failed to fetch init.lua from: " .. tostring(base))
end

local initFactory, err = loadstring(initSrc)
if not initFactory then
    error("[TRONWURP] init.lua loadstring error: " .. tostring(err))
end

local ok, TronwurpFactory = pcall(initFactory)
if not ok then
    error("[TRONWURP] init.lua runtime error: " .. tostring(TronwurpFactory))
end

-- init.lua returns a function(opts)->Tronwurp
-- We call it with BaseUrl so it never relies on globals only.
return TronwurpFactory({ BaseUrl = base })
