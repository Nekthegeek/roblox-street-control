local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Config = require(ReplicatedStorage.Shared:WaitForChild("Config"))
local ServiceUtil = require(ServerScriptService.Util:WaitForChild("ServiceUtil"))

local TerritoryService = {
    Territories = {},
}

local function buildTerritoryState()
    local territories = {}

    for territoryId, territoryConfig in pairs(Config.Territories) do
        territories[territoryId] = {
            Id = territoryId,
            DisplayName = territoryConfig.DisplayName,
            Controller = nil,
            Influence = {},
        }

        for crewId in pairs(Config.Crews) do
            territories[territoryId].Influence[crewId] = 0
        end
    end

    return territories
end

function TerritoryService:Init(manager)
    self.PlayerDataService = manager:GetService("PlayerDataService")
    self.CrewService = manager:GetService("CrewService")
    self.StreetRepService = manager:GetService("StreetRepService")
    self.Territories = buildTerritoryState()

    local remotesFolder = ServiceUtil:GetOrCreateFolder(ReplicatedStorage, "Remotes")
    self.TerritoryChangedRemote = ServiceUtil:GetOrCreateRemoteEvent(remotesFolder, "TerritoryChanged")
end

function TerritoryService:GetTerritory(territoryId)
    return self.Territories[territoryId]
end

function TerritoryService:GetDominantCrew(territoryId)
    local territory = self:GetTerritory(territoryId)

    if not territory then
        return nil, 0
    end

    local bestCrewId = nil
    local bestInfluence = 0

    for crewId, influence in pairs(territory.Influence) do
        if influence > bestInfluence then
            bestCrewId = crewId
            bestInfluence = influence
        end
    end

    return bestCrewId, bestInfluence
end

function TerritoryService:AddInfluence(player, territoryId, amount, reason)
    local territory = self:GetTerritory(territoryId)

    if not territory then
        warn(("[TerritoryService] Unknown territory '%s'"):format(tostring(territoryId)))
        return false
    end

    local crewId = self.CrewService:GetPlayerCrew(player)

    if crewId == Config.Game.DefaultCrew then
        return false
    end

    territory.Influence[crewId] = math.max(0, (territory.Influence[crewId] or 0) + amount)

    local territoryConfig = Config.Territories[territoryId]
    local dominantCrewId, dominantInfluence = self:GetDominantCrew(territoryId)
    local previousController = territory.Controller

    if dominantCrewId and dominantInfluence >= territoryConfig.CaptureThreshold then
        territory.Controller = dominantCrewId
    end

    if territory.Controller ~= previousController then
        self.PlayerDataService:IncrementValue(player, "TerritoriesCaptured", 1)
        self.PlayerDataService:AddCash(player, Config.Economy.CashPerTerritoryTick)
        self.StreetRepService:AwardAction(player, "CaptureTerritory")
    end

    self.TerritoryChangedRemote:FireAllClients(territoryId, territory, reason)
    return true
end

function TerritoryService:GetSnapshot()
    return self.Territories
end

return TerritoryService
