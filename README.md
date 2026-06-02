# Roblox Street Control

3D Roblox open-world action game foundation with Street Rep, crews, and territory influence.

## Current Gameplay Core

This repo now includes a server-side gameplay foundation designed to be dropped into Roblox Studio:

- `PlayerDataService` loads runtime player profiles, creates leaderstats, tracks cash, crew, street rep, and session stats.
- `CrewService` manages player crew membership from shared config.
- `StreetRepService` centralizes rep rewards, penalties, and rank calculation.
- `TerritoryService` tracks territory influence and awards captures when a crew crosses the capture threshold.
- `ServiceManager` provides a simple `Init` then `Start` service lifecycle.

## Layout

```text
ReplicatedStorage/
  Shared/
    Config.lua

ServerScriptService/
  Main.server.lua
  ServiceManager.lua
  Services/
    PlayerDataService.lua
    CrewService.lua
    StreetRepService.lua
    TerritoryService.lua
  Util/
    ServiceUtil.lua
```

## Next Gameplay Milestones

1. Add actual map territory parts/triggers that call `TerritoryService:AddInfluence(...)`.
2. Add combat/job systems that call `StreetRepService:AwardAction(...)`.
3. Add UI that listens to the `StreetRepChanged`, `CrewChanged`, and `TerritoryChanged` remotes.
4. Tune crews, territories, rewards, and ranks in `ReplicatedStorage/Shared/Config.lua`.
