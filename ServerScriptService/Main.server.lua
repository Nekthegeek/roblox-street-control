local ServerScriptService = game:GetService("ServerScriptService")

local ServiceManager = require(ServerScriptService:WaitForChild("ServiceManager"))
local PlayerDataService = require(ServerScriptService.Services:WaitForChild("PlayerDataService"))
local CrewService = require(ServerScriptService.Services:WaitForChild("CrewService"))
local StreetRepService = require(ServerScriptService.Services:WaitForChild("StreetRepService"))
local TerritoryService = require(ServerScriptService.Services:WaitForChild("TerritoryService"))

local manager = ServiceManager.new()

-- Register data first, then gameplay systems that depend on it.
manager:AddService("PlayerDataService", PlayerDataService)
manager:AddService("CrewService", CrewService)
manager:AddService("StreetRepService", StreetRepService)
manager:AddService("TerritoryService", TerritoryService)

manager:StartServices()
