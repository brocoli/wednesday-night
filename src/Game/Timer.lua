
local GameObject = require("GameObject")




local function onDraw(timer, transform)
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle( "fill", transform.x - transform.xScale * 7, transform.y - transform.yScale * 30, transform.xScale * 14, 6)
    love.graphics.setLineWidth(4)
    love.graphics.arc( "line", transform.x, transform.y - transform.yScale * 29, transform.xScale * 3, 0, -math.pi, 20)
    love.graphics.setLineWidth(2)
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle( "fill", transform.x - transform.xScale * 6, transform.y - transform.yScale * 29, transform.xScale * 12, transform.yScale * 4)
    love.graphics.arc( "line", transform.x, transform.y - transform.yScale * 29, transform.xScale * 3, 0, -math.pi, 20)

    love.graphics.setColor(0,0,0,255)
    love.graphics.circle( "fill", transform.x, transform.y, transform.xScale * 25, 50 )
    love.graphics.setColor(255,255,255,255)
    love.graphics.circle( "fill", transform.x, transform.y, transform.xScale * 24, 50 )

    love.graphics.setColor(0,0,0,255)
    love.graphics.circle( "fill", transform.x, transform.y, transform.xScale * 22, 50 )
    love.graphics.setColor(255,255,255,255)
    love.graphics.arc( "fill", transform.x, transform.y, transform.xScale * 20, -math.pi/2 - timer.timeRemaining*2*math.pi, -math.pi/2, 50 )
end


local function new()
    return GameObject.new({
        onDraw = onDraw,
    })
end


local Timer = {}

Timer.new = new

return Timer
