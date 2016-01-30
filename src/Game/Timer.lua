
local GameObject = require("GameObject")
local Messages = require("Messages")



local function onLoad(timer)
    timer.timeRemaining = 1
end

local function onUpdate(timer, dt)
    timer.timeRemaining = math.max(0, timer.timeRemaining - dt/2)
    if timer.timeRemaining == 0 then
        Messages.send("timesUp")
        timer:stop() --TODO: move to GameScene
        timer:removeParent() --TODO: move to GameScene
    end
end

local function onDraw(timer, transform)
    love.graphics.circle( "fill", transform.x, transform.y, 24, 50 )
    love.graphics.setColor(0,0,0,255)
    love.graphics.circle( "fill", transform.x, transform.y, 22, 50 )
    love.graphics.setColor(255,255,255,255)
    love.graphics.arc( "fill", transform.x, transform.y, 20, -math.pi/2 - timer.timeRemaining*2*math.pi, -math.pi/2, 50 )
end


local function new()
    return GameObject.new({
        onLoad = onLoad,
        onUpdate = onUpdate,
        onDraw = onDraw,
    })
end


local Timer = {}

Timer.new = new

return Timer
