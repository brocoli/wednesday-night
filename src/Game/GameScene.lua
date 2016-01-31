
local GameObject = require("GameObject")
local Messages = require("Messages")
local Task = require("Task")

local Responder = require("Components.Responder")

local CarScene = require("Game.CarScene.CarScene")
local ConversationScene = require("Game.ConversationScene.ConversationScene")
local ActionController = require("Game.ActionController")
local ActionDisplay = require("Game.ActionDisplay")



local function performOnFadeIn(gameScene)
    gameScene.fadeIn = nil
    gameScene.fadeOut = 1


    local actionController = ActionController.new(5)
    actionController:changeParent(gameScene)
    actionController:stop()
    gameScene.actionController = actionController


    if gameScene.topRightScene then
        gameScene.topRightScene:stop()
        gameScene.topRightScene:removeParent()
    end

    local carScene = CarScene.new()
    carScene:changeParent(gameScene)
    gameScene.topRightScene = carScene


    if gameScene.bottomRightScene then
        gameScene.bottomRightScene:stop()
        gameScene.bottomRightScene:removeParent()
    end

    local conversationScene = ConversationScene.new()
    conversationScene:changeParent(gameScene)
    gameScene.bottomRightScene = conversationScene


    if gameScene.bottomLeftScene then
        gameScene.bottomLeftScene:stop()
        gameScene.bottomLeftScene:removeParent()
    end

    local actionDisplay = ActionDisplay.new(gameScene.actionController)
    actionDisplay:changeParent(gameScene)
    gameScene.bottomLeftScene = actionDisplay
end

local function onFadeIn(gameScene)
    if not gameScene.waitingForPerformFadeIn then
        gameScene.waitingForPerformFadeIn = true
        Task.new(1, 1, function()
            gameScene.waitingForPerformFadeIn = nil
            performOnFadeIn(gameScene)
        end):changeParent(gameScene)
    end
end

local function onFadeOut(gameScene)
    gameScene.fadeIn = nil
    gameScene.fadeOut = nil
    gameScene.fadeMessage = nil

    gameScene.actionController:start()
    gameScene.actionController:prepareNextAction()
end


local function gameLose(gameScene, reason)
    gameScene.actionController:stop()

    Task.new(1, 1, function()
        gameScene.fadeIn = 0
        gameScene.fadeMessage = function(gameScene, transform, fadeAlpha)
            love.graphics.setColor(255,255,255,fadeAlpha*255)
            love.graphics.printf(
                "You lost.\nTry again!",
                transform.x - 45, transform.y - 12,
                90, "center"
            )
            love.graphics.setColor(255,255,255,255)
        end
    end):changeParent(gameScene)
end

local function gameWin(gameScene)
    gameScene.actionController:stop()

    Task.new(1, 1, function()
        gameScene.fadeIn = 0
        gameScene.fadeMessage = function(gameScene, transform, fadeAlpha)
            love.graphics.setColor(255,255,255,fadeAlpha*255)
            love.graphics.printf(
                "You won!\nSpeed up!",
                transform.x - 45, transform.y - 12,
                90, "center"
            )
            love.graphics.setColor(255,255,255,255)
        end

        _G.clockSpeed = _G.clockSpeed + math.sqrt(1/_G.clockSpeed)/12
    end):changeParent(gameScene)
end


local function onLoad(gameScene)
    _G.clockSpeed = 0.25

    gameScene.fadeIn = 1
    gameScene.fadeOut = nil
    gameScene.fadeMessage = function(gameScene, transform, fadeAlpha)
        love.graphics.setColor(255,255,255,fadeAlpha*255)
        love.graphics.printf(
            string.format(
                "Get Ready!\nUse the %s, %s and %s keys",
                string.upper(love.keyboard.getKeyFromScancode("z")),
                string.upper(love.keyboard.getKeyFromScancode("x")),
                string.upper(love.keyboard.getKeyFromScancode("c"))
            ),
            transform.x - 80, transform.y - 12,
            160, "center"
        )
        love.graphics.setColor(255,255,255,255)
    end
end

local function onDraw(gameScene, transform)
    local width, height = love.graphics.getDimensions()

    if gameScene.topRightScene then
        gameScene.topRightScene.transform.x = width/4
        gameScene.topRightScene.transform.y = -height/4
    end

    if gameScene.bottomRightScene then
        gameScene.bottomRightScene.transform.x = width/4
        gameScene.bottomRightScene.transform.y = height/4
    end

    if gameScene.bottomLeftScene then
        gameScene.bottomLeftScene.transform.x = -width/4
        gameScene.bottomLeftScene.transform.y = height/4
    end
end

local function afterDraw(gameScene, transform)
    local width, height = love.graphics.getDimensions()

    local fadeAlpha = gameScene.fadeIn or gameScene.fadeOut
    if fadeAlpha then
        love.graphics.setColor(0,0,0,fadeAlpha*255)
        love.graphics.rectangle( "fill", -2, -2, width + 4, height + 4 )
        love.graphics.setColor(255,255,255,255)

        local fadeMessage = gameScene.fadeMessage
        if fadeMessage then
            fadeMessage(gameScene, transform, fadeAlpha)
        end
    end
end

local function onUpdate(gameScene, dt)
    if gameScene.fadeIn then
        if gameScene.fadeIn == 1 then
            onFadeIn(gameScene)
        else
            gameScene.fadeIn = math.min(1, gameScene.fadeIn + dt*3)
        end
    elseif gameScene.fadeOut then
        if gameScene.fadeOut == 0 then
            onFadeOut(gameScene)
        else
            gameScene.fadeOut = math.max(0, gameScene.fadeOut - dt*3)
        end
    end
end


local function new()
    local gameScene = GameObject.new({
        onLoad = onLoad,
        onUpdate = onUpdate,
        onDraw = onDraw,
        afterDraw = afterDraw,
    })

    gameScene:compose("responder", Responder.new({
        gameLose = gameLose,
        gameWin = gameWin,
    }))

    return gameScene
end


local GameScene = {}

GameScene.new = new

return GameScene