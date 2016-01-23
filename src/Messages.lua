
-- Private

local registry = {}

local function listenOne(message, responder, callable)
    local entries = registry[message]
    if not entries then
        entries = {}
        registry[message] = entries
    end

    entries[responder] = callable
end

local function neglectOne(message, responder, callable)
    local entries = registry[message]
    if entries then
        entries[responder] = nil

        if next(entries) == nil then
            registry[message] = nil
        end
    end
end



-- Library

local function listen(responder)
    for message, callable in pairs(responder.responses) do
        listenOne(message, responder, callable)
    end
end

local function neglect(responder)
    for message, callable in pairs(responder.responses) do
        neglectOne(message, responder, callable)
    end
end


local function sendMessage(message, ...)
    local ret = {}

    local entries = registry[message]
    if entries then
        for responder, callable in pairs(entries) do
            local gameObject = responder.gameObject
            ret[gameObject] = { callable(gameObject, ...) }
        end
    end

    return ret
end


local Messages = {}

Messages.listen = listen
Messages.neglect = neglect

Messages.sendMessage = sendMessage

return Messages
