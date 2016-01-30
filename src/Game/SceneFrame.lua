
local GameObject = require("GameObject")


local function onDraw(sceneFrame, transform)
    local width, height = love.graphics.getDimensions()

    love.graphics.rectangle( "fill", transform.x - width/4 + 2, transform.y - height/4 + 2, width/2 - 4, height/2 - 4)
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle( "fill", transform.x - width/4 + 4, transform.y - height/4 + 4, width/2 - 8, height/2 - 8)
    love.graphics.setColor(255,255,255,255)
end


local function new()
    return GameObject.new({
        onDraw = onDraw,
    })
end


local SceneFrame = {}

SceneFrame.new = new

return SceneFrame