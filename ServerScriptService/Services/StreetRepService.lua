local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Config = require(ReplicatedStorage.Shared:WaitForChild("Config"))
local ServiceUtil = require(ServerScriptService.Util:WaitForChild("ServiceUtil"))

local StreetRepService = {}

function StreetRepService:Init(manager)
    self.PlayerDataService = manager:GetService("PlayerDataService")

    local remotesFolder = ServiceUtil:GetOrCreateFolder(ReplicatedStorage, "Remotes")
    self.RepChangedRemote = ServiceUtil:GetOrCreateRemoteEvent(remotesFolder, "StreetRepChanged")
end

function StreetRepService:GetRank(rep)
    local currentRank = Config.StreetRep.Ranks[1]

    for _, rank in ipairs(Config.StreetRep.Ranks) do
        if rep >= rank.RequiredRep then
            currentRank = rank
        else
            break
        end
    end

    return currentRank
end

function StreetRepService:AddRep(player, amount, reason)
    local newRep = math.max(0, self.PlayerDataService:IncrementValue(player, "StreetRep", amount))
    self.PlayerDataService:SetValue(player, "StreetRep", newRep)

    local rank = self:GetRank(newRep)
    player:SetAttribute("StreetRank", rank.Name)
    self.RepChangedRemote:FireClient(player, newRep, rank, reason)

    return newRep, rank
end

function StreetRepService:AwardAction(player, actionName)
    local amount = Config.StreetRep.Actions[actionName]

    if amount == nil then
        warn(("[StreetRepService] Unknown rep action '%s'"):format(tostring(actionName)))
        return nil
    end

    return self:AddRep(player, amount, actionName)
end

return StreetRepService
