
local GameObject = require("GameObject")


local lineSpacing = 12
local refWidth = 200

local function onLoad(answerBalloon)
    local borderHeight = (#answerBalloon.textLines + 1) * lineSpacing
    answerBalloon.height = borderHeight

    local left = 0
    local top = -borderHeight
    local right = refWidth
    local down = 0

    answerBalloon.borderMesh = love.graphics.newMesh({
        { left, top,             0, 0,  255, 255, 255, 255 },
        { left+2, top+2,         0, 0,  255, 255, 255, 255 },

        { right, top,            0, 0,  255, 255, 255, 255 },
        { right-2, top+2,        0, 0,  255, 255, 255, 255 },

        { right, down,           0, 0,  255, 255, 255, 255 },
        { right-2, down-2,       0, 0,  255, 255, 255, 255 },

        { left - 15, down,       0, 0,  255, 255, 255, 255 },
        { left+7 - 15, down-2,   0, 0,  255, 255, 255, 255 },

        { left, down - 10,       0, 0,  255, 255, 255, 255 },
        { left+2, down-2 - 6,    0, 0,  255, 255, 255, 255 },

        { left, top,             0, 0,  255, 255, 255, 255 },
        { left+2, top+2,         0, 0,  255, 255, 255, 255 },
    }, "strip", "static")
end

local function onDraw(answerBalloon, transform)
    local textLines = answerBalloon.textLines
    local amountLines = #textLines

    love.graphics.draw(answerBalloon.borderMesh, transform.x, transform.y, transform.rotation, transform.xScale, transform.yScale)

    local y = transform.y - (amountLines + 0.5)*lineSpacing
    for i, line in ipairs(textLines) do
        love.graphics.print(line, transform.x - refWidth + lineSpacing/2, y, transform.rotation, transform.xScale, transform.yScale)
        y = y + lineSpacing
    end
end


local function new(textLines)
    local answerBalloon = GameObject.new({
        onLoad = onLoad,
        onDraw = onDraw,
    })

    answerBalloon.textLines = textLines

    return answerBalloon
end


local AnswerBalloon = {}

AnswerBalloon.new = new

return AnswerBalloon