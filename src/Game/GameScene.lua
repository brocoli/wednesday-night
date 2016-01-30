
local GameObject = require("GameObject")
local Messages = require("Messages")

local ConversationScene = require("Game.ConversationScene.ConversationScene")
local ActionController = require("Game.ActionController")



local function onLoad(gameScene)
    local conversationScene = ConversationScene.new()
    conversationScene:changeParent(gameScene)
    gameScene.bottomRightScene = conversationScene

    local actionController = ActionController.new(5, 0.01)
    actionController:changeParent(gameScene)
    gameScene.actionController = actionController
end

local function afterLoad(gameScene)
    gameScene.actionController:prepareNextAction()
end

local function onDraw(gameScene)
    local width, height = love.graphics.getDimensions()

    gameScene.bottomRightScene.transform.x = width/4
    gameScene.bottomRightScene.transform.y = height/4
end


local function new()
    return GameObject.new({
        onLoad = onLoad,
        afterLoad = afterLoad,
        onDraw = onDraw,
    })
end


local GameScene = {}

GameScene.new = new

return GameScene