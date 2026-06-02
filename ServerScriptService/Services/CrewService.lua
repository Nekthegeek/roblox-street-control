local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Config = require(ReplicatedStorage.Shared:WaitForChild("Config"))
local ServiceUtil = require(ServerScriptService.Util:WaitForChild("ServiceUtil"))

local CrewService = {
    Crews = {},
}

function CrewService:Init(manager)
    self.PlayerDataService = manager:GetService("PlayerDataService")
    self.Crews = table.clone(Config.Crews)

    local remotesFolder = ServiceUtil:GetOrCreateFolder(ReplicatedStorage, "Remotes")
    self.CrewChangedRemote = ServiceUtil:GetOrCreateRemoteEvent(remotesFolder, "CrewChanged")
end

function CrewService:GetCrew(crewId)
    return self.Crews[crewId]
end

function CrewService:IsValidCrew(crewId)
    return self.Crews[crewId] ~= nil
end

function CrewService:GetPlayerCrew(player)
    local profile = self.PlayerDataService:GetProfile(player)
    return profile.Crew or Config.Game.DefaultCrew
end

function CrewService:SetPlayerCrew(player, crewId)
    if not self:IsValidCrew(crewId) then
        warn(("[CrewService] Invalid crew '%s'"):format(tostring(crewId)))
        return false
    end

    self.PlayerDataService:SetValue(player, "Crew", crewId)
    self.CrewChangedRemote:FireClient(player, crewId, self.Crews[crewId])
    return true
end

function CrewService:GetCrewDisplayName(crewId)
    local crew = self:GetCrew(crewId)
    return crew and crew.DisplayName or crewId
end

return CrewService
