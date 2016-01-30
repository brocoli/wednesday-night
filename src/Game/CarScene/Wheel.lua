
local GameObject = require("GameObject")


local function onDraw(wheel, transform)
    love.graphics.setColor(0,0,0,255)
    love.graphics.circle("fill", transform.x, transform.y, 28 * transform.xScale, 50)
    love.graphics.setColor(255,255,255,255)
    love.graphics.circle("fill", transform.x, transform.y, 26 * transform.xScale, 50)
    love.graphics.setColor(0,0,0,255)
    love.graphics.circle("fill", transform.x, transform.y, 25 * transform.xScale, 50)
    love.graphics.setColor(255,255,255,255)
    love.graphics.circle("fill", transform.x, transform.y, 23 * transform.xScale, 50)
    love.graphics.setColor(0,0,0,255)
    love.graphics.circle("fill", transform.x, transform.y, 21 * transform.xScale, 50)
    love.graphics.setColor(255,255,255,255)


    local rotation = (wheel.position/30) % (2*math.pi)
    local cosRot = math.cos(rotation)
    local sinRot = math.sin(rotation)

    love.graphics.line(
        transform.x + transform.xScale*cosRot*(-23), transform.y + transform.yScale*sinRot*(-23),
        transform.x + transform.xScale*cosRot*(23), transform.y + transform.yScale*sinRot*(23)
    )

    love.graphics.line(
        transform.x - transform.xScale*sinRot*(-23), transform.y + transform.yScale*cosRot*(-23),
        transform.x - transform.xScale*sinRot*(23), transform.y + transform.yScale*cosRot*(23)
    )
end


local function new()
    return GameObject.new({
        onDraw = onDraw,
    })
end


local Wheel = {}

Wheel.new = new

return Wheel