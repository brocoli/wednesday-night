
local GameObject = require("GameObject")

local ConversationScene = require("Game.ConversationScene.ConversationScene")
local Timer = require("Game.Timer")



local function onLoad(gameScene)
    local conversationScene = ConversationScene.new()
    conversationScene:changeParent(GameObject.root)
    gameScene.bottomLeftScene = conversationScene

    local timer = Timer.new()
    timer.transform.x = 0
    timer.transform.y = 0
    timer:changeParent(GameObject.root)
end

local function onDraw(gameScene)
    local width, height = love.graphics.getDimensions()

    gameScene.bottomLeftScene.transform.x = -width/4
    gameScene.bottomLeftScene.transform.y = height/4
end


local function new()
    return GameObject.new({
        onLoad = onLoad,
        onDraw = onDraw,
    })
end


local GameScene = {}

GameScene.new = new

return GameScene