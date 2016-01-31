
local GameObject = require("GameObject")




local function onDraw(timer, transform)
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle( "fill", transform.x - 7, transform.y - 30, 14, 6)
    love.graphics.setLineWidth(4)
    love.graphics.arc( "line", transform.x, transform.y -29, 3, 0, -math.pi, 20)
    love.graphics.setLineWidth(2)
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle( "fill", transform.x - 6, transform.y - 29, 12, 4)
    love.graphics.arc( "line", transform.x, transform.y -29, 3, 0, -math.pi, 20)

    love.graphics.setColor(0,0,0,255)
    love.graphics.circle( "fill", transform.x, transform.y, 25, 50 )
    love.graphics.setColor(255,255,255,255)
    love.graphics.circle( "fill", transform.x, transform.y, 24, 50 )

    love.graphics.setColor(0,0,0,255)
    love.graphics.circle( "fill", transform.x, transform.y, 22, 50 )
    love.graphics.setColor(255,255,255,255)
    love.graphics.arc( "fill", transform.x, transform.y, 20, -math.pi/2 - timer.timeRemaining*2*math.pi, -math.pi/2, 50 )
end


local function new()
    return GameObject.new({
        onDraw = onDraw,
    })
end


local Timer = {}

Timer.new = new

return Timer
