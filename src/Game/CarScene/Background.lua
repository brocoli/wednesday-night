
local GameObject = require("GameObject")



local function onDraw(background, transform)
    love.graphics.circle( "fill", transform.x - 135, transform.y - 90, transform.xScale * 16, 50)
end


local function new()
    return GameObject.new({
        onDraw = onDraw,
    })
end


local Background = {}

Background.new = new

return Background