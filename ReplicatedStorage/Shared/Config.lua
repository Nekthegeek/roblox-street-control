-- Shared gameplay tuning for Roblox Street Control.
-- Keep balance values here so client UI and server services can agree.

local Config = {
    Game = {
        Name = "Roblox Street Control",
        MaxPlayers = 20,
        DefaultCrew = "Independent",
        AutosaveIntervalSeconds = 60,
    },

    DataStore = {
        Enabled = true,
        Name = "RobloxStreetControl_PlayerData_v1",
    },

    Economy = {
        StartingCash = 250,
        CashPerTag = 25,
        CashPerTerritoryTick = 10,
    },

    StreetRep = {
        StartingRep = 0,
        Actions = {
            TagWall = 5,
            WinFight = 25,
            DefendTerritory = 15,
            CaptureTerritory = 75,
            LoseFight = -10,
        },
        Ranks = {
            { Name = "Unknown", RequiredRep = 0 },
            { Name = "Block Regular", RequiredRep = 100 },
            { Name = "Corner Name", RequiredRep = 250 },
            { Name = "Street Captain", RequiredRep = 500 },
            { Name = "City Legend", RequiredRep = 1000 },
        },
    },

    Crews = {
        Independent = {
            DisplayName = "Independent",
            Color = Color3.fromRGB(210, 210, 210),
        },
        Redline = {
            DisplayName = "Redline Crew",
            Color = Color3.fromRGB(235, 65, 65),
        },
        BlueKings = {
            DisplayName = "Blue Kings",
            Color = Color3.fromRGB(55, 120, 255),
        },
        ViperSet = {
            DisplayName = "Viper Set",
            Color = Color3.fromRGB(80, 220, 120),
        },
    },

    Territories = {
        Downtown = {
            DisplayName = "Downtown",
            CaptureThreshold = 100,
            InfluenceDecayPerTick = 1,
        },
        Backstreets = {
            DisplayName = "Backstreets",
            CaptureThreshold = 100,
            InfluenceDecayPerTick = 1,
        },
        Industrial = {
            DisplayName = "Industrial Yard",
            CaptureThreshold = 125,
            InfluenceDecayPerTick = 2,
        },
    },
}

return Config
