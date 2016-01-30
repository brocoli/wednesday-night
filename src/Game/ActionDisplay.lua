
local GameObject = require("GameObject")

local Responder = require("Components.Responder")

local SceneFrame = require("Game.SceneFrame")
local Timer = require("Game.Timer")



local function runAction(actionDisplay, action, actionIndex)
    local completeActions = actionDisplay.completeActions
    if action == 1 then
        completeActions[actionIndex] = string.upper(love.keyboard.getKeyFromScancode("z"))
    elseif action == 2 then
        completeActions[actionIndex] = string.upper(love.keyboard.getKeyFromScancode("x"))
    elseif action == 3 then
        completeActions[actionIndex] = string.upper(love.keyboard.getKeyFromScancode("c"))
    end
end


local function onLoad(actionDisplay)
    local sceneFrame = SceneFrame.new()
    sceneFrame:changeParent(actionDisplay)

    local timer = Timer.new()
    timer:changeParent(actionDisplay)
    actionDisplay.timer = timer

    actionDisplay.font = love.graphics.newFont(30)
end

local function onDraw(actionDisplay, transform)
    local width, height = love.graphics.getDimensions()

    actionDisplay.timer.transform.x = width/4
    actionDisplay.timer.transform.y = -height/4

    actionDisplay.timer.timeRemaining = actionDisplay.actionController.timeRemaining

    local amountActions = actionDisplay.actionController.amountActions
    local left = -width/4 + 4
    local right = width/4 - 4
    local objWidth = (right - left) / (amountActions + 1)

    local completeActions = actionDisplay.completeActions
    love.graphics.setFont(actionDisplay.font)

    for i=0, amountActions - 1 do
        local lObjs = i
        local rObjs = amountActions - 1 - i
        local x = (lObjs * objWidth / 2) - (rObjs * objWidth / 2)
        love.graphics.rectangle( "fill", transform.x + x - 20, transform.y + 20, 40, 4)

        local completeAction = completeActions[i+1]
        if completeAction then
            love.graphics.print( completeAction, transform.x + x - 10, transform.y - 10)
        end
    end

    love.graphics.setFont(_G.font)
end


local function new(actionController)
    local actionDisplay = GameObject.new({
        onLoad = onLoad,
        onDraw = onDraw,
    })

    actionDisplay.actionController = actionController
    actionDisplay.completeActions = {}

    actionDisplay:compose("responder", Responder.new({
        runAction = runAction,

    }))

    return actionDisplay
end


local ActionDisplay = {}

ActionDisplay.new = new

return ActionDisplay