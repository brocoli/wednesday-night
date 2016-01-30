
local GameObject = require("GameObject")

local SceneFrame = require("Game.SceneFrame")

local QuestionBalloon = require("Game.ConversationScene.QuestionBalloon")



local function onLoad(conversationScene)
    local sceneFrame = SceneFrame.new()
    sceneFrame:changeParent(conversationScene)
    conversationScene.sceneFrame = sceneFrame

    local questionBalloon = QuestionBalloon.new({ "Hi!", "I'm a text! haha", "Horray!", })
    questionBalloon:changeParent(conversationScene)
    table.insert(conversationScene.questionBalloons, questionBalloon)
end

local function onUpdate(conversationScene, dt)
end

local function onDraw(conversationScene, transform)
    local width, height = love.graphics.getDimensions()

    local questionBalloons = conversationScene.questionBalloons
    local answerBalloons = conversationScene.answerBalloons

    local questionBalloonX = -width/4 + 25
    local answerBalloonX = width/4 - 25

    local y = height/4 - 12

    local i = 1
    while i <= #questionBalloons and i <= #answerBalloons do
        local questionBalloon = questionBalloons[i]
        local answerBalloon = answerBalloons[i]

        questionBalloon.transform.x = questionBalloonX
        questionBalloon.transform.y = y

        y = y - questionBalloon.height - 12

        answerBalloon.transform.x = answerBalloonX
        answerBalloon.transform.y = y

        y = y - answerBalloon.height - 12

        i = i+1
    end
    while i <= #questionBalloons do -- runs at most once
        local questionBalloon = questionBalloons[i]

        questionBalloon.transform.x = questionBalloonX
        questionBalloon.transform.y = y

        i = i+1
    end
end


local function new()
    local conversationScene = GameObject.new({
        onLoad = onLoad,
        onDraw = onDraw,
    })

    conversationScene.questionBalloons = {}
    conversationScene.answerBalloons = {}

    return conversationScene
end


local ConversationScene = {}

ConversationScene.new = new

return ConversationScene