local ServiceManager = {}
ServiceManager.__index = ServiceManager

function ServiceManager.new()
    return setmetatable({
        Services = {},
        ServiceByName = {},
        Started = false,
    }, ServiceManager)
end

function ServiceManager:AddService(name, service)
    assert(type(name) == "string", "Service name must be a string")
    assert(type(service) == "table", "Service must be a table")
    assert(self.ServiceByName[name] == nil, ("Service '%s' is already registered"):format(name))

    service.Name = service.Name or name
    table.insert(self.Services, service)
    self.ServiceByName[name] = service
end

function ServiceManager:GetService(name)
    return self.ServiceByName[name]
end

function ServiceManager:InitServices()
    for _, service in ipairs(self.Services) do
        if type(service.Init) == "function" then
            local success, err = pcall(function()
                service:Init(self)
            end)

            if not success then
                error(("[ServiceManager] Failed to init %s: %s"):format(service.Name, tostring(err)))
            end
        end
    end
end

function ServiceManager:StartServices()
    if self.Started then
        return
    end

    self:InitServices()

    for _, service in ipairs(self.Services) do
        if type(service.Start) == "function" then
            local success, err = pcall(function()
                service:Start()
            end)

            if not success then
                error(("[ServiceManager] Failed to start %s: %s"):format(service.Name, tostring(err)))
            end
        end
    end

    self.Started = true
    print(("[ServiceManager] Started %d services"):format(#self.Services))
end

return ServiceManager
