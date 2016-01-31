
local GameObject = require("GameObject")

local Responder = require("Components.Responder")

local SceneFrame = require("Game.SceneFrame")
local Timer = require("Game.Timer")



local function ranAction(actionDisplay, success)
    if success then
        table.insert(actionDisplay.completeActions, true)
    end
end


local function onLoad(actionDisplay)
    local sceneFrame = SceneFrame.new()
    sceneFrame:changeParent(actionDisplay)

    if #_G.tutorials == 0 then
        local timer = Timer.new()
        timer:changeParent(actionDisplay)
        actionDisplay.timer = timer
    end
end

local function onDraw(actionDisplay, transform)
    local width, height = love.graphics.getDimensions()

    local timer = actionDisplay.timer
    if timer then
        timer.transform.x = width/4
        timer.transform.y = -height/4
        timer.transform.xScale = 1.5
        timer.transform.yScale = 1.5

        timer.timeRemaining = actionDisplay.actionController.timeRemaining
    end

    love.graphics.rectangle( "fill", transform.x - width/4 + 12, transform.y - height/4 + 12, width/2 - 24, height/2 - 24)
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle( "fill", transform.x - width/4 + 20, transform.y - 34, width/2 - 40, 68 )

    local amountActions = actionDisplay.actionController.amountActions
    local left = -width/4 + 4
    local right = width/4 - 4
    local objWidth = (right - left) / (amountActions + 1)

    local completeActions = actionDisplay.completeActions

    love.graphics.setFont(_G.bigFont)
    love.graphics.printf( "Progress", transform.x - 100, transform.y - 80, 200, "center" )

    love.graphics.printf( string.format("%d/%d",#completeActions,amountActions), transform.x - 100, transform.y + 50, 200, "center" )
    love.graphics.setFont(_G.font)

    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle( "fill", transform.x - width/4 + 24, transform.y - 30, (width/2 - 48)*#completeActions/amountActions, 60 )
    -- for i=0, amountActions - 1 do
    --     local lObjs = i
    --     local rObjs = amountActions - 1 - i
    --     local x = (lObjs * objWidth / 2) - (rObjs * objWidth / 2)
    --     love.graphics.rectangle( "fill", transform.x + x - 20, transform.y + 20, 40, 4)

    --     local completeAction = completeActions[i+1]
    --     if completeAction then
    --         love.graphics.print( completeAction, transform.x + x - 10, transform.y - 10)
    --     end
    -- end
end


local function new(actionController)
    local actionDisplay = GameObject.new({
        onLoad = onLoad,
        onDraw = onDraw,
    })

    actionDisplay.actionController = actionController
    actionDisplay.completeActions = {}

    actionDisplay:compose("responder", Responder.new({
        ranAction = ranAction,
    }))

    return actionDisplay
end


local ActionDisplay = {}

ActionDisplay.new = new

return ActionDisplay