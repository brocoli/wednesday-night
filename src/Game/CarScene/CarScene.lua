
local GameObject = require("GameObject")

local Responder = require("Components.Responder")

local SceneFrame = require("Game.SceneFrame")

local Background = require("Game.CarScene.Background")
local Car = require("Game.CarScene.Car")
local Floor = require("Game.CarScene.Floor")
local Instructions = require("Game.CarScene.Instructions")



local motorSound = love.audio.newSource("assets/motor.ogg")
local motorbgSound = love.audio.newSource("assets/motorbg.ogg")
local explosionSound = love.audio.newSource("assets/explosion.ogg")

motorbgSound:setLooping(true)



local function prepareAction(carScene, index)
    carScene.notIndex = (index + love.math.random(0,1))%3 + 1
end

local function runAction(carScene, index)
    if not carScene.lost then
        if index == carScene.notIndex then
            local background = carScene.background
            background:stop()
            background:removeParent()
            carScene.background = nil

            local enemy = carScene.enemy
            enemy:stop()
            enemy:removeParent()
            carScene.enemy = nil

            local car = carScene.car
            car:stop()
            car:removeParent()
            carScene.car = nil

            local floor = carScene.floor
            floor:stop()
            floor:removeParent()
            carScene.floor = nil

            local instructions = carScene.instructions
            instructions:stop()
            instructions:removeParent()
            carScene.instructions = nil

            explosionSound:rewind()
            explosionSound:play()

            motorbgSound:stop()

            carScene.lost = true
            return false
        elseif index == 1 then
            carScene.carMovementX = -2
            carScene.carMovementShape = 1
            carScene.carMovementSign = -1

            motorSound:rewind()
            motorSound:play()

            return true
        elseif index == 2 then
            --TODO how???

            motorSound:rewind()
            motorSound:play()

            return true
        elseif index == 3 then
            carScene.carMovementX = 2
            carScene.carMovementShape = -1
            carScene.carMovementSign = 1

            motorSound:rewind()
            motorSound:play()

            return true
        end
    end
end


local function onLoad(carScene)
    local sceneFrame = SceneFrame.new()
    sceneFrame:changeParent(carScene)
    carScene.sceneFrame = sceneFrame

    local maskedGroup = GameObject.new({
        onDraw = function(maskedGroup, transform)
            local width, height = love.graphics.getDimensions()

            local function maskStencil()
                love.graphics.rectangle("fill", transform.x - width/4 + 5, transform.y - height/4 + 5, width/2 - 10, height/2 - 10)
            end
            love.graphics.stencil(maskStencil, "replace", 1)

            love.graphics.setStencilTest("greater", 0)
        end,
        afterDraw = function(maskedGroup, transform)
            love.graphics.setStencilTest()
        end,
    })
    maskedGroup:changeParent(carScene)
    carScene.maskedGroup = maskedGroup


    motorbgSound:play()
    carScene:compose("motorbgSoundStop", {
        afterStop = function()
            motorbgSound:stop()
        end
    })


    carScene.position = 0
    carScene.velocity = 100
    carScene.enemyX = 1.5

    carScene.carMovementX = 0
    carScene.carMovementShape = 1
    carScene.carMovementSign = 1

    local background = Background.new()
    background:changeParent(maskedGroup)
    carScene.background = background

    local enemy = Car.new(7/3)
    enemy:changeParent(maskedGroup)
    carScene.enemy = enemy

    local car = Car.new(11/5)
    car:changeParent(maskedGroup)
    carScene.car = car

    local floor = Floor.new()
    floor:changeParent(maskedGroup)
    carScene.floor = floor

    local instructions = Instructions.new()
    instructions:changeParent(maskedGroup)
    carScene.instructions = instructions
end

local function onUpdate(carScene, dt)
    carScene.position = carScene.position + carScene.velocity*dt

    local carMovementX = carScene.carMovementX
    if carMovementX > 0 then
        carScene.carMovementX = math.max(0, carMovementX - dt*16*_G.clockSpeed)
    elseif carMovementX < 0 then
        carScene.carMovementX = math.min(0, carMovementX + dt*16*_G.clockSpeed)
    end

    local notIndex = carScene.notIndex
    if notIndex == 3 then -- can't accelerate
        if carScene.enemyX < -1 then
            carScene.enemyX = ((math.max(-2.4, carScene.enemyX - dt*8*_G.clockSpeed) + 1.5)%3 - 1.5)
        elseif carScene.enemyX < 1.1 then
            carScene.enemyX = math.min(1.1, carScene.enemyX + dt*8*_G.clockSpeed)
        else
            carScene.enemyX = math.max(1.1, carScene.enemyX - dt*8*_G.clockSpeed)
        end
    elseif notIndex == 1 then --- can't brake
        if carScene.enemyX > 1 then
            carScene.enemyX = ((math.min(2.4, carScene.enemyX + dt*8*_G.clockSpeed) + 1.5)%3 - 1.5)
        elseif carScene.enemyX > -1.1 then
            carScene.enemyX = math.max(-1.1, carScene.enemyX - dt*8*_G.clockSpeed)
        else
            carScene.enemyX = math.min(-1.1, carScene.enemyX + dt*8*_G.clockSpeed)
        end
    elseif notIndex == 2 then -- can't switch lanes
        if carScene.enemyX > 0.2 then
            carScene.enemyX = math.max(0.2, carScene.enemyX - dt*8*_G.clockSpeed)
        else
            carScene.enemyX = math.min(0.2, carScene.enemyX + dt*8*_G.clockSpeed)
        end
    end
end

local function onDraw(carScene, transform)
    if carScene.lost then
        love.graphics.line(
            transform.x + transform.xScale*( -90), transform.y + transform.yScale*(  70),
            transform.x + transform.xScale*( -75), transform.y + transform.yScale*(  25),
            transform.x + transform.xScale*(-110), transform.y + transform.yScale*(  10),
            transform.x + transform.xScale*( -70), transform.y + transform.yScale*( -10),
            transform.x + transform.xScale*( -75), transform.y + transform.yScale*( -50),
            transform.x + transform.xScale*( -35), transform.y + transform.yScale*( -30),
            transform.x + transform.xScale*( -25), transform.y + transform.yScale*( -80),
            transform.x + transform.xScale*(  20), transform.y + transform.yScale*( -60),
            transform.x + transform.xScale*(  40), transform.y + transform.yScale*(-100),
            transform.x + transform.xScale*(  55), transform.y + transform.yScale*( -65),

            transform.x + transform.xScale*(  90), transform.y + transform.yScale*( -70),
            transform.x + transform.xScale*(  75), transform.y + transform.yScale*( -25),
            transform.x + transform.xScale*( 110), transform.y + transform.yScale*( -10),
            transform.x + transform.xScale*(  70), transform.y + transform.yScale*(  10),
            transform.x + transform.xScale*(  75), transform.y + transform.yScale*(  50),
            transform.x + transform.xScale*(  35), transform.y + transform.yScale*(  30),
            transform.x + transform.xScale*(  25), transform.y + transform.yScale*(  80),
            transform.x + transform.xScale*( -20), transform.y + transform.yScale*(  60),
            transform.x + transform.xScale*( -40), transform.y + transform.yScale*( 100),
            transform.x + transform.xScale*( -55), transform.y + transform.yScale*(  65),

            transform.x + transform.xScale*( -90), transform.y + transform.yScale*(  70)
        )

        love.graphics.setFont(_G.bigFont)
        love.graphics.print("CRASH!", transform.x - 55, transform.y + 5, -math.pi*0.15)
        love.graphics.setFont(_G.font)
    else
        local width, height = love.graphics.getDimensions()

        local enemy = carScene.enemy
        enemy.position = carScene.position
        enemy.transform.x = carScene.enemyX * width/4
        enemy.transform.y = height/4 - 50
        enemy.transform.xScale = 0.66
        enemy.transform.yScale = 0.66

        local poly = carScene.carMovementX + carScene.carMovementShape

        local car = carScene.car
        car.position = carScene.position
        car.transform.x = carScene.carMovementSign * 80 * (1 - poly*poly)
        car.transform.y = height/4 - 50
        car.transform.xScale = 0.75
        car.transform.yScale = 0.75

        local floor = carScene.floor
        floor.position = carScene.position
        floor.transform.y = height/4 - 50

        local instructions = carScene.instructions
        instructions.transform.x = width/4 - 90
        instructions.transform.y = -height/4 + 40
    end
end


local function new()
    local carScene = GameObject.new({
        onLoad = onLoad,
        onUpdate = onUpdate,
        onDraw = onDraw,
    })

    carScene:compose("responder", Responder.new({
        prepareAction = prepareAction,
        runAction = runAction,
    }))

    return carScene
end


local CarScene = {}

CarScene.new = new

return CarScene
