
local GameObject = require("GameObject")

local Responder = require("Components.Responder")

local SceneFrame = require("Game.SceneFrame")

local QuestionBalloon = require("Game.ConversationScene.QuestionBalloon")
local AnswerBalloon = require("Game.ConversationScene.AnswerBalloon")



local function insertQuestionBalloon(conversationScene, textLines)
    local questionBalloon = QuestionBalloon.new(textLines)
    questionBalloon:changeParent(conversationScene.mask)
    table.insert(conversationScene.balloons, 1, { is = "question", balloon = questionBalloon })

    conversationScene.balloonYAnimationOffset = conversationScene.balloonYAnimationOffset + questionBalloon.height + 12
end

local function insertAnswerBalloon(conversationScene, textLines)
    local answerBalloon = AnswerBalloon.new(textLines)
    answerBalloon:changeParent(conversationScene.mask)
    table.insert(conversationScene.balloons, 1, { is = "answer", balloon = answerBalloon })

    conversationScene.balloonYAnimationOffset = conversationScene.balloonYAnimationOffset + answerBalloon.height + 12
end


local questionTexts = {
    [1] = {"Not Action 1 text", "sample"},
    [2] = {"Not Action 2 text", "sample"},
    [3] = {"Not Action 3 text", "sample"},
}

local answerTexts = {
    [1] = {"Action 1 text", "sample"},
    [2] = {"Action 2 text", "sample"},
    [3] = {"Action 3 text", "sample"},
}

local okReplyTexts = {
    [1] = {"OK Reply 1 text", "sample"},
    [2] = {"OK Reply 2 text", "sample"},
    [3] = {"OK Reply 3 text", "sample"},
}

local badReplyTexts = {
    [1] = {"Bad Reply 1 text", "sample"},
    [2] = {"Bad Reply 2 text", "sample"},
    [3] = {"Bad Reply 3 text", "sample"},
}

local function prepareAction(conversationScene, notIndex)
    insertQuestionBalloon(conversationScene, questionTexts[notIndex])

    conversationScene.notIndex = notIndex
end

local function runAction(conversationScene, index)
    insertAnswerBalloon(conversationScene, answerTexts[index])

    print(index, conversationScene.notIndex)
    if index == conversationScene.notIndex then
        insertQuestionBalloon(conversationScene, badReplyTexts[index])
    else
        insertQuestionBalloon(conversationScene, okReplyTexts[index])
    end
end


local function onLoad(conversationScene)
    print("onLoad conversationScene")
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
    conversationScene.mask = mask

    conversationScene.balloonYAnimationOffset = 0
end

local function onUpdate(conversationScene, dt)
    conversationScene.balloonYAnimationOffset = math.max(0, conversationScene.balloonYAnimationOffset - dt*200)
end

local function onDraw(conversationScene, transform)
    local width, height = love.graphics.getDimensions()

    local balloons = conversationScene.balloons

    local questionBalloonX = -width/4 + 25
    local answerBalloonX = width/4 - 25

    local y = height/4 - 12 + conversationScene.balloonYAnimationOffset

    for i, balloonData in ipairs(balloons) do
        local balloon = balloonData.balloon

        if balloonData.is == "question" then
            balloon.transform.x = questionBalloonX
        elseif balloonData.is == "answer" then
            balloon.transform.x = answerBalloonX
        end

        balloon.transform.y = y
        y = y - balloon.height - 12
    end
end


local function new()
    local conversationScene = GameObject.new({
        onLoad = onLoad,
        onUpdate = onUpdate,
        onDraw = onDraw,
    })

    conversationScene.balloons = {}

    conversationScene:compose("responder", Responder.new({
        prepareAction = prepareAction,
        runAction = runAction,
    }))

    return conversationScene
end


local ConversationScene = {}

ConversationScene.new = new

return ConversationScene