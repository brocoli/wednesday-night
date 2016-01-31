
local GameObject = require("GameObject")
local Messages = require("Messages")
local Task = require("Task")

local Responder = require("Components.Responder")



local alarmSound = love.audio.newSource("assets/alarm.ogg")

local function afterRunAction(actionController, action, results)
    local lost = false
    for minigame, minigameResult in pairs(results) do
        if minigameResult[1] == false then
            lost = true
            break
        end
    end

    Messages.send("ranAction", not lost)

    if lost then
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
end

local function listenKeyReleased(actionController, key, scancode)
    if actionController.timeRemaining > 0 and not actionController.actionTaken then
        if scancode == "z" then
            local results = Messages.send("runAction", 1)
            afterRunAction(actionController, 1, results)
        elseif scancode == "x" then
            local results = Messages.send("runAction", 2)
            afterRunAction(actionController, 2, results)
        elseif scancode == "c" then
            local results = Messages.send("runAction", 3)
            afterRunAction(actionController, 3, results)
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
    actionController.timeRemaining = 1
    actionController.actionTaken = true
end

local function onUpdate(actionController, dt)
    if not _G.tutorials[#_G.tutorials] then
        actionController.timeRemaining = math.max(0, actionController.timeRemaining - dt*_G.clockSpeed)

        if actionController.timeRemaining == 0 then
            alarmSound:rewind()
            alarmSound:play()
            Messages.send("gameLose")
        end
    end
end


local function new(amountActions)
    local actionController = GameObject.new({
        onLoad = onLoad,
        onUpdate = onUpdate,
        onDraw = onDraw,
    })

    actionController.prepareNextAction = prepareNextAction

    actionController.amountActions = amountActions

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