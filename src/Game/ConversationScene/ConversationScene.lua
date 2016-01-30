
local GameObject = require("GameObject")

local SceneFrame = require("Game.SceneFrame")

local QuestionBalloon = require("Game.ConversationScene.QuestionBalloon")
local AnswerBalloon = require("Game.ConversationScene.AnswerBalloon")



local function onLoad(conversationScene)
    local sceneFrame = SceneFrame.new()
    sceneFrame:changeParent(conversationScene)
    conversationScene.sceneFrame = sceneFrame

    local mask = GameObject.new({
        onDraw = function(mask, transform)
            local width, height = love.graphics.getDimensions()

            local function maskStencil()
                love.graphics.rectangle("fill", transform.x - width/4 + 5, transform.y - height/4 + 5, width/2 - 10, height/2 - 10)
            end

            love.graphics.stencil(maskStencil, "replace", 1)
            love.graphics.setStencilTest("greater", 0)
        end,
        afterDraw = function(mask, transform)
            love.graphics.setStencilTest()
        end,
    })
    mask:changeParent(conversationScene)

    local questionBalloon = QuestionBalloon.new({ "Hi!", "I'm a text! haha", "Horray!", })
    questionBalloon:changeParent(mask)
    table.insert(conversationScene.questionBalloons, questionBalloon)

    local questionBalloon = AnswerBalloon.new({ "Hi!", "I'm a text! haha", "Horray!", })
    questionBalloon:changeParent(mask)
    table.insert(conversationScene.answerBalloons, questionBalloon)

    local questionBalloon = QuestionBalloon.new({ "Hi!", "I'm a text! haha", "Horray!", })
    questionBalloon:changeParent(mask)
    table.insert(conversationScene.questionBalloons, questionBalloon)

    local questionBalloon = AnswerBalloon.new({ "Hi!", "I'm a text! haha", "Horray!", })
    questionBalloon:changeParent(mask)
    table.insert(conversationScene.answerBalloons, questionBalloon)

    local questionBalloon = QuestionBalloon.new({ "Hi!", "I'm a text! haha", "Horray!", })
    questionBalloon:changeParent(mask)
    table.insert(conversationScene.questionBalloons, questionBalloon)

    local questionBalloon = AnswerBalloon.new({ "Hi!", "I'm a text! haha", "Horray!", })
    questionBalloon:changeParent(mask)
    table.insert(conversationScene.answerBalloons, questionBalloon)

    local questionBalloon = QuestionBalloon.new({ "Hi!", "I'm a text! haha", "Horray!", })
    questionBalloon:changeParent(mask)
    table.insert(conversationScene.questionBalloons, questionBalloon)

    local questionBalloon = AnswerBalloon.new({ "Hi!", "I'm a text! haha", "Horray!", })
    questionBalloon:changeParent(mask)
    table.insert(conversationScene.answerBalloons, questionBalloon)
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
    while i <= #questionBalloons do
        local questionBalloon = questionBalloons[i]

        questionBalloon.transform.x = questionBalloonX
        questionBalloon.transform.y = y

        y = y - questionBalloon.height - 12

        i = i+1
    end
    while i <= #answerBalloons do
        local answerBalloon = answerBalloons[i]

        answerBalloon.transform.x = answerBalloonX
        answerBalloon.transform.y = y

        y = y - answerBalloon.height - 12

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