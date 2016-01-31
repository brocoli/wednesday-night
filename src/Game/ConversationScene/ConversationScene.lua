
local GameObject = require("GameObject")

local Responder = require("Components.Responder")

local SceneFrame = require("Game.SceneFrame")

local QuestionBalloon = require("Game.ConversationScene.QuestionBalloon")
local AnswerBalloon = require("Game.ConversationScene.AnswerBalloon")
local Instructions = require("Game.ConversationScene.Instructions")



local talkSources = {
    love.audio.newSource("assets/talk1.wav"),
    love.audio.newSource("assets/talk2.wav"),
    love.audio.newSource("assets/talk3.wav"),
    love.audio.newSource("assets/talk4.wav"),
}

local function cleanBalloons(conversationScene)
    if #conversationScene.balloons >= 8 and conversationScene.balloonYAnimationOffset == 0 then
        for i = #conversationScene.balloons, 8, -1 do
            local deadBalloon = conversationScene.balloons[i].balloon
            deadBalloon:stop()
            deadBalloon:removeParent()
            table.remove(conversationScene.balloons, i)
        end
    end
end

local function insertQuestionBalloon(conversationScene, textLines)
    local questionBalloon = QuestionBalloon.new(textLines)
    questionBalloon:changeParent(conversationScene.maskedGroup)
    table.insert(conversationScene.balloons, 1, { is = "question", balloon = questionBalloon })

    cleanBalloons(conversationScene)

    conversationScene.balloonYAnimationOffset = conversationScene.balloonYAnimationOffset + questionBalloon.height + 12

    conversationScene.instructions:changeParent(conversationScene)
end

local function insertAnswerBalloon(conversationScene, textLines)
    local answerBalloon = AnswerBalloon.new(textLines)
    answerBalloon:changeParent(conversationScene.maskedGroup)
    table.insert(conversationScene.balloons, 1, { is = "answer", balloon = answerBalloon })

    cleanBalloons(conversationScene)

    conversationScene.balloonYAnimationOffset = conversationScene.balloonYAnimationOffset + answerBalloon.height + 12

    conversationScene.instructions:changeParent(conversationScene)

    local source = talkSources[love.math.random(1,#talkSources)]
    source:rewind()
    source:play()
end


local questionTexts = {
    [1] = {"My aunt has passed away", "this afternoon."},
    [2] = {"I'm bored."},
    [3] = {"There's something we need", "to talk about..."},
}

local answerTexts = {
    [1] = {
        [1] = {"LOL get rekt!", "D:", "OOPS wrong chat!!"},
        [2] = {"I'm sorry.", "Are you ok?"},
        [3] = {"I'm sorry...", "let's go to a pub,", "it'll make you feel better."},
    },
    [2] = {
        [1] = {"http://giphy.com/gifs/", "cat-doodle-RgM33sAlSxzfq"},
        [2] = {"Me too."},
        [3] = {"Hey, I'm looking to", "buy this thing for us...", "what do you think?"},
    },
    [3] = {
        [1] = {"Sure, but I already told you", "I'm not into THAT,", "you know? :P"},
        [2] = {"Sure, what's bothering you?"},
        [3] = {"Sorry, not now.", "I'm sleepy"},
    },
}

local replyTexts = {
    [1] = {
        [1] = {"Could you pay attention?", "I'm feeling pretty down."},
        [2] = {"I'm alright I guess.", "A little down, but I'll manage."},
        [3] = {"Actually, that's a good idea."},
    },
    [2] = {
        [1] = {"heh", "I didn't expect that :P"},
        [2] = {"..."},
        [3] = {"Sure", "I don't have anything", "to do right now anyway."},
    },
    [3] = {
        [1] = {"hahahha", "well, I'm pretty sure", "you'd enjoy it ;)", "No, but seriously,"},
        [2] = {"*sigh* well...", "here it goes:"},
        [3] = {"No you're not,", "you're just avoiding it.", "Why do I even bother..."},
    },
}

local function prepareAction(conversationScene, index)
    local notIndex = (index + love.math.random(0,1))%3 + 1
    insertQuestionBalloon(conversationScene, questionTexts[notIndex])

    conversationScene.notIndex = notIndex

    if conversationScene.didNotPlayStartSound then
        conversationScene.didNotPlayStartSound = false

        local source = talkSources[love.math.random(1,#talkSources)]
        source:rewind()
        source:play()
    end
end

local function runAction(conversationScene, index)
    if not conversationScene.lost then
        insertAnswerBalloon(conversationScene, answerTexts[conversationScene.notIndex][index])
        insertQuestionBalloon(conversationScene, replyTexts[conversationScene.notIndex][index])

        if index == conversationScene.notIndex then
            conversationScene.lost = true
            return false
        else
            return true
        end
    end
end


local function onLoad(conversationScene)
    local sceneFrame = SceneFrame.new()
    sceneFrame:changeParent(conversationScene)

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
    maskedGroup:changeParent(conversationScene)
    conversationScene.maskedGroup = maskedGroup

    conversationScene.balloonYAnimationOffset = 0

    local instructions = Instructions.new()
    instructions:changeParent(maskedGroup)
    conversationScene.instructions = instructions

    conversationScene.didNotPlayStartSound = true
end

local function onUpdate(conversationScene, dt)
    conversationScene.balloonYAnimationOffset = math.max(0, conversationScene.balloonYAnimationOffset - dt*800*_G.clockSpeed)
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

    local instructions = conversationScene.instructions
    instructions.transform.x = width/4 - 90
    instructions.transform.y = -height/4 + 40
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
