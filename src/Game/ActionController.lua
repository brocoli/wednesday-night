
local GameObject = require("GameObject")
local Messages = require("Messages")
local Task = require("Task")

local Responder = require("Components.Responder")

local ActionDisplay = require("Game.ActionDisplay")
local Timer = require("Game.Timer")


local function afterRunAction(actionController)
    if actionController.lost then
        Messages.send("gameLose", actions, actionIndex)
    else
        actionController.actionIndex = actionController.actionIndex + 1
        actionController:prepareNextAction()
    end
end

local function prepareNextAction(actionController)
    local actions = actionController.actions
    local actionIndex = actionController.actionIndex

    if actionIndex > #actions then
        Messages.send("gameWin", actions)
    else
        local action = actions[actionIndex]
        Messages.send("prepareAction", action)
    end
end


local function prepareAction(actionController)
    actionController.timeRemaining = 1
    actionController.actionTaken = false
end

local function runAction(actionController, action, actionIndex)
    actionController.actionTaken = true

    -- if action ~= actionController.actions[actionIndex] then
    --     actionController.lost = true
    -- end
end

local function listenKeyReleased(actionController, key, scancode)
    if actionController.timeRemaining > 0 and not actionController.actionTaken then
        if scancode == "z" then
            Messages.send("runAction", 1, actionController.actionIndex)
            afterRunAction(actionController)
        elseif scancode == "x" then
            Messages.send("runAction", 2, actionController.actionIndex)
            afterRunAction(actionController)
        elseif scancode == "c" then
            Messages.send("runAction", 3, actionController.actionIndex)
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


    local actionDisplay = ActionDisplay.new(actionController.amountActions)
    actionDisplay:changeParent(actionController)
    actionController.actionDisplay = actionDisplay

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

local function onDraw(actionController, transform)
    local width, height = love.graphics.getDimensions()

    actionController.actionDisplay.transform.x = -width/4
    actionController.actionDisplay.transform.y = height/4
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