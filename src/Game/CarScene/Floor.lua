
local GameObject = require("GameObject")


local function onDraw(floor, transform)
    local width, height = love.graphics.getDimensions()

    love.graphics.line(
        transform.x - width/4, transform.y,
        transform.x + width/4, transform.y
    )

    local stop = width/4
    local cursor = -width/4 - 50 - floor.position%12

    while cursor <= stop do
        love.graphics.line(
            transform.x + cursor, transform.y + 50,
            transform.x + cursor + 50, transform.y
        )
        cursor = cursor + 12
    end
end


local function new()
    local floor = GameObject.new({
        onDraw = onDraw,
    })

    return floor
end


local Floor = {}

Floor.new = new

return Floor