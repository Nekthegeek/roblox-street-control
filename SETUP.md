# Setup

## Repository

```bash
git clone https://github.com/Nekthegeek/roblox-street-control.git
```

## Roblox Studio Placement

Create the same folders in Roblox Studio and place each script/module in the matching service:

```text
ReplicatedStorage
└── Shared
    └── Config.lua

ServerScriptService
├── Main.server.lua
├── ServiceManager.lua
├── Services
│   ├── PlayerDataService.lua
│   ├── CrewService.lua
│   ├── StreetRepService.lua
│   └── TerritoryService.lua
└── Util
    └── ServiceUtil.lua
```

`Main.server.lua` is the entrypoint. It registers services in dependency order and starts the gameplay core.

## Studio Testing Notes

- Player data uses runtime profiles during Studio testing.
- DataStore saving is skipped in Studio to avoid accidental writes while tuning gameplay.
- Territory capture currently exposes server functions only. Add map zone parts or proximity triggers later and call `TerritoryService:AddInfluence(player, territoryId, amount, reason)` from trusted server scripts.
- Any future client UI should treat remotes as display updates only. Gameplay rewards and territory changes should remain server-validated.
