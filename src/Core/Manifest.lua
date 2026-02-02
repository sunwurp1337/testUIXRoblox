-- Core/Manifest.lua
return {
    Metadata = {
        Name = "TRONWURP VIP",
        Version = "1.0.0",
    },
    Modules = {
        Core = {"Library"}, -- Manifest zaten yüklü, Library'yi ekledik
        Features = {"Visuals", "Combat", "World"}
    }
}
