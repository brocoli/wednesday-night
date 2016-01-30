
local GameObject = require("GameObject")
local Messages = require("Messages")

local Timer = require("Game.Timer")



local function onLoad(actionController)
    actionController.timeRemaining = 1

    local timer = Timer.new()
    timer:changeParent(actionController)
    actionController.timer = timer
end

local function onUpdate(actionController, dt)
    actionController.timeRemaining = math.max(0, actionController.timeRemaining - dt/2)

    actionController.timer.timeRemaining = actionController.timeRemaining

    if actionController.timeRemaining == 0 then
        Messages.send("timesUp")
        actionController:stop() --TODO: move to GameScene
        actionController:removeParent() --TODO: move to GameScene
    end
end


local function new(clockSpeed)
    local actionController = GameObject.new({
        onLoad = onLoad,
        onUpdate = onUpdate,
        onDraw = onDraw,
    })

    actionController.clockSpeed = clockSpeed

    return actionController
end


local ActionController = {}

ActionController.new = new

return ActionController