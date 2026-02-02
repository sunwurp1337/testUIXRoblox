-- Run once to create local repo config
local cfg = [[
return {
  User   = "sunwurp1337",
  Repo   = "testUIXRoblox",
  Branch = "main"
}
]]

if writefile then
  writefile("tronwurp_repo.lua", cfg)
  print("[TRONWURP] tronwurp_repo.lua written.")
else
  warn("[TRONWURP] writefile not available in this environment.")
end
