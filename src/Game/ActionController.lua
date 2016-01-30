
local GameObject = require("GameObject")
local Messages = require("Messages")

local Responder = require("Components.Responder")

local Timer = require("Game.Timer")


local function afterRunAction(actionController)
    actionController.actionIndex = actionController.actionIndex + 1
    actionController:prepareNextAction()
end

local function prepareNextAction(actionController)
    local actions = actionController.actions
    local actionIndex = actionController.actionIndex

    if actionIndex > #actions then
        print("no more actions!")
    else
        local action = actions[actionIndex]
        Messages.send("prepareAction", action)
    end
end


local function prepareAction(actionController)
    actionController.timeRemaining = 1
    actionController.actionTaken = false
end

local function runAction(actionController)
    actionController.actionTaken = true
end

local function listenKeyReleased(actionController, key, scancode)
    if actionController.timeRemaining > 0 and not actionController.actionTaken then
        if scancode == "z" then
            Messages.send("runAction", 1)
            afterRunAction(actionController)
        elseif scancode == "x" then
            Messages.send("runAction", 2)
            afterRunAction(actionController)
        elseif scancode == "c" then
            Messages.send("runAction", 3)
            afterRunAction(actionController)
        end
    end
end


local function onLoad(actionController)
    local actions = {}
    actionController.actions = actions
    for i=1, actionController.amountActions do
        actions[i] = love.math.random(1,3)
    end

    actionController.actionIndex = 1
    actionController.timeRemaining = 0
    actionController.actionTaken = true

    local timer = Timer.new()
    timer:changeParent(actionController)
    actionController.timer = timer
end

local function onUpdate(actionController, dt)
    actionController.timeRemaining = math.max(0, actionController.timeRemaining - dt*actionController.clockSpeed)

    actionController.timer.timeRemaining = actionController.timeRemaining

    if actionController.timeRemaining == 0 then
        Messages.send("timesUp")
    end
end


local function new(amountActions, clockSpeed)
    local actionController = GameObject.new({
        onLoad = onLoad,
        onUpdate = onUpdate,
        onDraw = onDraw,
    })

    actionController.prepareNextAction = prepareNextAction

    actionController.amountActions = amountActions
    actionController.clockSpeed = clockSpeed

    actionController:compose("responder", Responder.new({
        prepareAction = prepareAction,
        runAction = runAction,
        ["love.keyreleased"] = listenKeyReleased,
    }))

    return actionController
end


local ActionController = {}

ActionController.new = new

return ActionController