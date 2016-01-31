
local GameObject = require("GameObject")

local SceneFrame = require("Game.SceneFrame")



local function onLoad(conversationSceneTutorial)
    local sceneFrame = SceneFrame.new()
    sceneFrame:changeParent(conversationSceneTutorial)
end

local function onDraw(conversationSceneTutorial, transform)
    local width, height = love.graphics.getDimensions()

    love.graphics.setFont(_G.bigFont)
    love.graphics.printf(
        string.format(
            "23:00 - Chat with SO.\n\n%s: be funny.\n%s: be serious.\n%s: dodge the question.\n\nDon't disappoint.",
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


local ConversationSceneTutorial = {}

ConversationSceneTutorial.new = new

return ConversationSceneTutorial
