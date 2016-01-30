
local GameObject = require("GameObject")

local SceneFrame = require("Game.SceneFrame")


local function onLoad(actionDisplay)
    local sceneFrame = SceneFrame.new()
    sceneFrame:changeParent(actionDisplay)


end


local function new(actionController)
    local actionDisplay = GameObject.new({
        onLoad = onLoad,
        onDraw = onDraw,
    })

    return actionDisplay
end


local ActionDisplay = {}

ActionDisplay.new = new

return ActionDisplay