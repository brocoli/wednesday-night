
local Messages = require("Messages")



-- Methods

local function beforeStart(responder)
    Messages.listen(responder)
end

local function afterStop(responder)
    Messages.neglect(responder)
end



-- Class

local function new(responses)
    return {
        responses = responses,
        beforeStart = beforeStart,
        afterStop = afterStop,
    }
end


local ReponderComponent = {}

ResponderComponent.new = new

return ResponderComponent