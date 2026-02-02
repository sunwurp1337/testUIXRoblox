-- Load framework using your local tronwurp_repo.lua config
local TronwurpFactory = loadstring(game:HttpGet(getgenv().TRONWURP_BASEURL .. "init.lua"))()
local Tronwurp = TronwurpFactory()

local win = Tronwurp:CreateWindow({
  Title = "TRONWURP",
  Subtitle = "Premium Dark UI",
  Accent = Color3.fromRGB(255, 70, 90),
})

local combat = win:CreateTab("Combat", "sword")
combat:AddToggle({ Name="Silent Aim", Default=false, Description="Example toggle", Callback=function(v) print(v) end })
combat:AddSlider({ Name="FOV", Min=0, Max=360, Default=120, Callback=function(v) print(v) end })
combat:AddButton({ Name="Run Action", Callback=function() print("clicked") end })

win:SelectTab("Combat")
