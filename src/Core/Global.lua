-- Global.lua
local Global = {}

-- GitHub Bilgileri
Global.User = "sunwurp1337"
Global.Repo = "testUIXRoblox"
Global.Branch = "main"

-- Erişim Linki Oluşturucu
Global.BaseURL = string.format(
    "https://raw.githubusercontent.com/%s/%s/%s/src/",
    Global.User, 
    Global.Repo, 
    Global.Branch
)

-- Global Tablolar (Script içi iletişim için)
Global.Flags = {}      -- Toggle durumları (ESP = true vb.)
Global.Instances = {}  -- Oluşturulan UI objeleri

return Global
