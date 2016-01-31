
local GameObject = require("GameObject")

local SceneFrame = require("Game.SceneFrame")



local function onLoad(carSceneTutorial)
    local sceneFrame = SceneFrame.new()
    sceneFrame:changeParent(carSceneTutorial)
end

local function onDraw(carSceneTutorial, transform)
    local width, height = love.graphics.getDimensions()

    love.graphics.setFont(_G.bigFont)
    love.graphics.printf(
        string.format(
            "22:00 - Returning home.\n\n%s: brake.\n%s: change lanes.\n%s: accelerate.\n\nDon't crash.",
            string.upper(love.keyboard.getKeyFromScancode("z")),
            string.upper(love.keyboard.getKeyFromScancode("x")),
            string.upper(love.keyboard.getKeyFromScancode("c"))
        ),
        transform.x + -width/4 + 12, transform.y + -height/4 + 12,
        width/2 - 24, "left"
    )
    love.graphics.setFont(_G.font)
end


local function new()
    return GameObject.new({
        onLoad = onLoad,
        onDraw = onDraw,
    })
end


local CarSceneTutorial = {}

CarSceneTutorial.new = new

return CarSceneTutorial
