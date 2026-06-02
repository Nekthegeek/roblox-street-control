local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage.Shared:WaitForChild("Config"))

local PlayerDataService = {
    Profiles = {},
}

local function getDefaultProfile()
    return {
        Cash = Config.Economy.StartingCash,
        StreetRep = Config.StreetRep.StartingRep,
        Crew = Config.Game.DefaultCrew,
        TerritoriesCaptured = 0,
        TagsPlaced = 0,
        FightsWon = 0,
    }
end

local function mergeDefaults(profile)
    local defaults = getDefaultProfile()

    for key, value in pairs(defaults) do
        if profile[key] == nil then
            profile[key] = value
        end
    end

    return profile
end

function PlayerDataService:Init()
    self.Store = nil

    if Config.DataStore.Enabled then
        self.Store = DataStoreService:GetDataStore(Config.DataStore.Name)
    end
end

function PlayerDataService:Start()
    Players.PlayerAdded:Connect(function(player)
        self:LoadPlayer(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        self:SavePlayer(player)
        self.Profiles[player] = nil
    end)

    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(function()
            self:LoadPlayer(player)
        end)
    end

    task.spawn(function()
        while true do
            task.wait(Config.Game.AutosaveIntervalSeconds)

            for _, player in ipairs(Players:GetPlayers()) do
                self:SavePlayer(player)
            end
        end
    end)
end

function PlayerDataService:LoadPlayer(player)
    local profile = getDefaultProfile()

    if self.Store and not RunService:IsStudio() then
        local success, savedProfile = pcall(function()
            return self.Store:GetAsync(tostring(player.UserId))
        end)

        if success and type(savedProfile) == "table" then
            profile = mergeDefaults(savedProfile)
        elseif not success then
            warn(("[PlayerDataService] Failed to load %s: %s"):format(player.Name, tostring(savedProfile)))
        end
    end

    self.Profiles[player] = profile
    self:CreateLeaderstats(player, profile)
    self:ApplyAttributes(player, profile)
end

function PlayerDataService:SavePlayer(player)
    local profile = self.Profiles[player]

    if not profile or not self.Store or RunService:IsStudio() then
        return
    end

    local success, err = pcall(function()
        self.Store:SetAsync(tostring(player.UserId), profile)
    end)

    if not success then
        warn(("[PlayerDataService] Failed to save %s: %s"):format(player.Name, tostring(err)))
    end
end

function PlayerDataService:GetProfile(player)
    local profile = self.Profiles[player]

    if not profile then
        profile = getDefaultProfile()
        self.Profiles[player] = profile
    end

    return profile
end

function PlayerDataService:CreateLeaderstats(player, profile)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local cash = Instance.new("IntValue")
    cash.Name = "Cash"
    cash.Value = profile.Cash
    cash.Parent = leaderstats

    local rep = Instance.new("IntValue")
    rep.Name = "StreetRep"
    rep.Value = profile.StreetRep
    rep.Parent = leaderstats
end

function PlayerDataService:ApplyAttributes(player, profile)
    player:SetAttribute("Crew", profile.Crew)
    player:SetAttribute("StreetRep", profile.StreetRep)
    player:SetAttribute("Cash", profile.Cash)
end

function PlayerDataService:SetValue(player, key, value)
    local profile = self:GetProfile(player)
    profile[key] = value
    player:SetAttribute(key, value)

    local leaderstats = player:FindFirstChild("leaderstats")
    local stat = leaderstats and leaderstats:FindFirstChild(key)

    if stat and stat:IsA("ValueBase") then
        stat.Value = value
    end
end

function PlayerDataService:IncrementValue(player, key, amount)
    local profile = self:GetProfile(player)
    local value = (profile[key] or 0) + amount
    self:SetValue(player, key, value)
    return value
end

function PlayerDataService:AddCash(player, amount)
    return self:IncrementValue(player, "Cash", amount)
end

return PlayerDataService
