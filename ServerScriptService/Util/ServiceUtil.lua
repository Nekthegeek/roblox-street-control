-- ServiceUtil.lua

local ServiceUtil = {}

function ServiceUtil:GetOrCreateFolder(parent, name)
    local folder = parent:FindFirstChild(name)

    if not folder then
        folder = Instance.new("Folder")
        folder.Name = name
        folder.Parent = parent
    end

    return folder
end

function ServiceUtil:GetOrCreateRemoteEvent(parent, name)
    local remote = parent:FindFirstChild(name)

    if not remote then
        remote = Instance.new("RemoteEvent")
        remote.Name = name
        remote.Parent = parent
    end

    return remote
end

function ServiceUtil:GetOrCreateBindableEvent(parent, name)
    local event = parent:FindFirstChild(name)

    if not event then
        event = Instance.new("BindableEvent")
        event.Name = name
        event.Parent = parent
    end

    return event
end

return ServiceUtil
