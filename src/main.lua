
-- Require

local Messages = require("Messages")
local GameObject = require("GameObject")
local Transform = require("Transform")



-- Init

_G.bigFont = love.graphics.newFont(30)
_G.midFont = love.graphics.newFont(18)
_G.font = love.graphics.newFont(12)
love.graphics.setFont(_G.font)

love.graphics.setLineWidth(2)
love.graphics.setLineStyle("rough")


local GameScene = require("Game.GameScene")

local function bootstrap()
    local gameScene = GameScene.new()
    gameScene:changeParent(GameObject.root)
end



-- Love callbacks

function love.load(...)
    bootstrap()
    return GameObject.root:load(...)
end

function love.update(...)
    return GameObject.root:update(...)
end

function love.draw(...)
    local width, height = love.graphics.getDimensions()

    local baseTransform = Transform.new()
    baseTransform.x = width/2
    baseTransform.y = height/2

    return GameObject.root:draw(baseTransform, ...)
end

-- function love.mousepressed(...)
--     return Messages.send("love.mousepressed", ...)
-- end

-- function love.mousereleased(...)
--     return Messages.send("love.mousereleased", ...)
-- end

-- function love.keypressed(...)
--     return Messages.send("love.keypressed", ...)
-- end

function love.keyreleased(key, ...)
    if key == "escape" then
        love.event.quit()
    else
        return Messages.send("love.keyreleased", key, ...)
    end
end

function love.focus(...)
    return Messages.send("love.focus", ...)
end

function love.quit(...)
    Messages.send("love.quit", ...)
end
