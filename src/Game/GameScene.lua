
local GameObject = require("GameObject")
local Messages = require("Messages")
local Task = require("Task")

local Responder = require("Components.Responder")

local CarScene = require("Game.CarScene.CarScene")
local CarSceneTutorial = require("Game.CarScene.CarSceneTutorial")

local ConversationScene = require("Game.ConversationScene.ConversationScene")
local ConversationSceneTutorial = require("Game.ConversationScene.ConversationSceneTutorial")

local ActionController = require("Game.ActionController")
local ActionDisplay = require("Game.ActionDisplay")



_G.tutorials = {
    {
        scene = "conversationScene",
        notActions = { 3, 1, 2, 1, 2 },
    },
    {
        scene = "carScene",
        notActions = { 2, 1, 3, 2, 3 },
    },
}

local function performOnFadeIn(gameScene)
    gameScene.fadeIn = nil
    gameScene.fadeOut = 1

    local actionController = ActionController.new(5)
    actionController:changeParent(gameScene)
    actionController:stop()
    gameScene.actionController = actionController


    local currentTutorial = _G.tutorials[#_G.tutorials]

    if gameScene.topLeftScene then
        gameScene.topLeftScene:stop()
        gameScene.topLeftScene:removeParent()
        gameScene.topLeftScene = nil
    end
    if gameScene.topRightScene then
        gameScene.topRightScene:stop()
        gameScene.topRightScene:removeParent()
        gameScene.topRightScene = nil
    end
    if gameScene.bottomRightScene then
        gameScene.bottomRightScene:stop()
        gameScene.bottomRightScene:removeParent()
        gameScene.bottomRightScene = nil
    end
    if gameScene.bottomLeftScene then
        gameScene.bottomLeftScene:stop()
        gameScene.bottomLeftScene:removeParent()
        gameScene.bottomLeftScene = nil
    end

    if not currentTutorial or currentTutorial.scene == "carScene" then
        local carScene = CarScene.new()
        carScene:changeParent(gameScene)
        gameScene.topRightScene = carScene

        if currentTutorial then
            local carSceneTutorial = CarSceneTutorial.new()
            carSceneTutorial:changeParent(gameScene)
            gameScene.topLeftScene = carSceneTutorial
        end
    end

    if not currentTutorial or currentTutorial.scene == "conversationScene" then
        local conversationScene = ConversationScene.new()
        conversationScene:changeParent(gameScene)
        gameScene.bottomRightScene = conversationScene

        if currentTutorial then
            local conversationSceneTutorial = ConversationSceneTutorial.new()
            conversationSceneTutorial:changeParent(gameScene)
            gameScene.topRightScene = conversationSceneTutorial
        end
    end

    local actionDisplay = ActionDisplay.new(gameScene.actionController)
    actionDisplay:changeParent(gameScene)
    gameScene.bottomLeftScene = actionDisplay
end

local function onFadeIn(gameScene)
    if not gameScene.waitingForPerformFadeIn then
        gameScene.waitingForPerformFadeIn = true
        Task.new(gameScene.fadeMessage and 2 or 0.5, 1, function()
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
            love.graphics.setFont(_G.bigFont)
            love.graphics.printf(
                "You lost.\nTry again!",
                transform.x - 300, transform.y - 30,
                600, "center"
            )
            love.graphics.setFont(_G.font)
            love.graphics.setColor(255,255,255,255)
        end
    end):changeParent(gameScene)
end

local function gameWin(gameScene)
    gameScene.actionController:stop()

    Task.new(1, 1, function()
        gameScene.fadeIn = 0

        local completedTutorial = table.remove(_G.tutorials)
        if completedTutorial then
            if #_G.tutorials == 0 then
                gameScene.fadeMessage = function(gameScene, transform, fadeAlpha)
                    love.graphics.setColor(255,255,255,fadeAlpha*255)
                    love.graphics.setFont(_G.bigFont)
                    love.graphics.printf(
                        string.format(
                            "Good.\nNow, get ready!",
                            string.upper(love.keyboard.getKeyFromScancode("z")),
                            string.upper(love.keyboard.getKeyFromScancode("x")),
                            string.upper(love.keyboard.getKeyFromScancode("c"))
                        ),
                        transform.x - 90, transform.y - 8,
                        180, "center"
                    )
                    love.graphics.setFont(_G.font)
                    love.graphics.setColor(255,255,255,255)
                end
            else
                gameScene.fadeMessage = nil
            end
        else
            _G.clockSpeed = _G.clockSpeed + math.sqrt(1/_G.clockSpeed)/12

            gameScene.fadeMessage = function(gameScene, transform, fadeAlpha)
                love.graphics.setColor(255,255,255,fadeAlpha*255)
                love.graphics.setFont(_G.bigFont)
                love.graphics.printf(
                    "You won!\nSpeed up!",
                    transform.x - 45, transform.y - 12,
                    90, "center"
                )
                love.graphics.setFont(_G.font)
                love.graphics.setColor(255,255,255,255)
            end
        end
    end):changeParent(gameScene)
end


local function onLoad(gameScene)
    _G.clockSpeed = 0.2

    gameScene.fadeIn = 1
    gameScene.fadeOut = nil
    gameScene.fadeMessage = function(gameScene, transform, fadeAlpha)
        love.graphics.setColor(255,255,255,fadeAlpha*255)
        love.graphics.setFont(_G.bigFont)
        love.graphics.printf(
            string.format(
                "Wednesday Night\n\nUse the %s, %s and %s keys",
                string.upper(love.keyboard.getKeyFromScancode("z")),
                string.upper(love.keyboard.getKeyFromScancode("x")),
                string.upper(love.keyboard.getKeyFromScancode("c"))
            ),
            transform.x - 300, transform.y - 50,
            600, "center"
        )
        love.graphics.setFont(_G.font)
        love.graphics.setColor(255,255,255,255)
    end
end

local function onDraw(gameScene, transform)
    local width, height = love.graphics.getDimensions()

    if gameScene.topLeftScene then
        gameScene.topLeftScene.transform.x = -width/4
        gameScene.topLeftScene.transform.y = -height/4
    end

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