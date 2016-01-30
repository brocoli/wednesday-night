
local GameObject = require("GameObject")


local lineSpacing = 12
local refWidth = 200

local function onLoad(questionBalloon)
    local borderHeight = (#questionBalloon.textLines + 1) * lineSpacing
    questionBalloon.height = borderHeight

    local left = 0
    local top = -borderHeight
    local right = refWidth
    local down = 0

    questionBalloon.borderMesh = love.graphics.newMesh({
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

local function onDraw(questionBalloon, transform)
    local textLines = questionBalloon.textLines
    local amountLines = #textLines

    love.graphics.draw(questionBalloon.borderMesh, transform.x, transform.y, transform.rotation, transform.xScale, transform.yScale)

    local y = transform.y - (amountLines + 0.5)*lineSpacing
    for i, line in ipairs(textLines) do
        love.graphics.print(line, transform.x + lineSpacing/2, y, transform.rotation, transform.xScale, transform.yScale)
        y = y + lineSpacing
    end
end


local function new(textLines)
    local questionBalloon = GameObject.new({
        onLoad = onLoad,
        onDraw = onDraw,
    })

    questionBalloon.textLines = textLines

    return questionBalloon
end


local QuestionBalloon = {}

QuestionBalloon.new = new

return QuestionBalloon