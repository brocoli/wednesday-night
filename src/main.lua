
-- Require

local Messages = require("Messages")
local GameObject = require("GameObject")

local Responder = require("Components.Responder")
local Transform = require("Components.Transform")



-- Game

local function main()

end



-- Love callbacks

function love.load(...)
    main()
    GameObject.root:load(...)
end

function love.update(...)
    GameObject.root:update(...)
end

function love.draw(...)
    GameObject.root:draw(...)
end

function love.mousepressed(...)
    Messages.send("love.mousepressed", ...)
end

function love.mousereleased(...)
    Messages.send("love.mousereleased", ...)
end

function love.keypressed(...)
    Messages.send("love.keypressed", ...)
end

function love.keyreleased(...)
    Messages.send("love.keyreleased", ...)
end

function love.focus(...)
    Messages.send("love.focus", ...)
end

function love.quit(...)
    Messages.send("love.quit", ...)
end
