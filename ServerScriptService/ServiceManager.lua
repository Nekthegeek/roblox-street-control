local ServiceManager = {}

-- Service Boot Sequence
function ServiceManager:StartServices()
    -- Placeholder for service initialization logic
    print("Starting Services...")
    
    -- Call individual services to start
    for _, service in ipairs(self.Services) do
        service:Start()
    end
end

function ServiceManager:AddService(service)
    self.Services = self.Services or {}
    table.insert(self.Services, service)
end

return ServiceManager