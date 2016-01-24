
-- Require

local Messages = require("Messages")



-- Class

local function new(responses)
    return {
        responses = responses,
        beforeStart = Messages.listen,
        afterStop = Messages.neglect,
    }
end


local Responder = {}

Responder.new = new

return Responder