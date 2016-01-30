
local GameObject = require("GameObject")
local Task = require("Task")

local Wheel = require("Game.CarScene.Wheel")



local function onLoad(car)
    car.yOffset = 0

    Task.new(car.bumpDelay, 0, function()
        car.yOffset = 2
        Task.new(0.1, 1 + love.math.random(0,1)*2, function()
            if car.yOffset == 2 then
                car.yOffset = 0
            elseif car.yOffset == 0 then
                car.yOffset = 2
            end
        end):changeParent(car)
    end):changeParent(car)

    local wheel1 = Wheel.new()
    wheel1:changeParent(car)
    car.wheel1 = wheel1

    local wheel2 = Wheel.new()
    wheel2:changeParent(car)
    car.wheel2 = wheel2
end

local function onDraw(car, transform)
    local yOffset = car.yOffset

    local triangles = love.math.triangulate(
        transform.x + transform.xScale*(- 130), transform.y + transform.yScale*(yOffset - 25 - 10),
        transform.x + transform.xScale*(- 130), transform.y + transform.yScale*(yOffset - 25 - 45),
        transform.x + transform.xScale*(- 100), transform.y + transform.yScale*(yOffset - 25 - 50),
        transform.x + transform.xScale*(-  75), transform.y + transform.yScale*(yOffset - 25 - 85),
        transform.x + transform.xScale*(   60), transform.y + transform.yScale*(yOffset - 25 - 85),
        transform.x + transform.xScale*(  100), transform.y + transform.yScale*(yOffset - 25 - 50),
        transform.x + transform.xScale*(  150), transform.y + transform.yScale*(yOffset - 25 - 45),
        transform.x + transform.xScale*(  150), transform.y + transform.yScale*(yOffset - 25 - 10),
        transform.x + transform.xScale*(   60), transform.y + transform.yScale*(yOffset - 25),
        transform.x + transform.xScale*(-  60), transform.y + transform.yScale*(yOffset - 25)
    )
    love.graphics.setColor(0,0,0,255)
    for _, triangle in ipairs(triangles) do
        love.graphics.polygon( "fill", unpack(triangle))
    end
    love.graphics.setColor(255,255,255,255)

    love.graphics.line(
        transform.x + transform.xScale*(- 130), transform.y + transform.yScale*(yOffset - 25 - 10),
        transform.x + transform.xScale*(- 130), transform.y + transform.yScale*(yOffset - 25 - 45),
        transform.x + transform.xScale*(- 100), transform.y + transform.yScale*(yOffset - 25 - 50),
        transform.x + transform.xScale*(-  75), transform.y + transform.yScale*(yOffset - 25 - 85),
        transform.x + transform.xScale*(   60), transform.y + transform.yScale*(yOffset - 25 - 85),
        transform.x + transform.xScale*(  100), transform.y + transform.yScale*(yOffset - 25 - 50),
        transform.x + transform.xScale*(  150), transform.y + transform.yScale*(yOffset - 25 - 45),
        transform.x + transform.xScale*(  150), transform.y + transform.yScale*(yOffset - 25 - 10),
        transform.x + transform.xScale*(   60), transform.y + transform.yScale*(yOffset - 25),
        transform.x + transform.xScale*(-  60), transform.y + transform.yScale*(yOffset - 25),
        transform.x + transform.xScale*(- 130), transform.y + transform.yScale*(yOffset - 25 - 10)
    )

    love.graphics.line(
        transform.x + transform.xScale*96, transform.y + transform.yScale*(yOffset - 25 - 50),
        transform.x + transform.xScale*40, transform.y + transform.yScale*(yOffset - 25 - 50),
        transform.x + transform.xScale*40, transform.y + transform.yScale*(yOffset - 25 - 82)
    )

    local wheel1 = car.wheel1
    wheel1.position = car.position
    wheel1.transform.x = -80
    wheel1.transform.y = -29 + yOffset

    local wheel2 = car.wheel2
    wheel2.position = car.position
    wheel2.transform.x = 90
    wheel2.transform.y = -29 + yOffset
end


local function new(bumpDelay)
    local car = GameObject.new({
        onLoad = onLoad,
        onDraw = onDraw,
    })

    car.bumpDelay = bumpDelay

    return car
end


local Car = {}

Car.new = new

return Car