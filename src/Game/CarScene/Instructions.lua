
local GameObject = require("GameObject")



local function onDraw(instructions, transform)
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle( "fill", transform.x - 70, transform.y - 20, 140, 40 )
    love.graphics.setColor(255,255,255,255)

    love.graphics.print("brake   lane   accel", transform.x - 60, transform.y - 18)
    love.graphics.setFont(_G.midFont)
    love.graphics.print(
        string.format(
            "  %s     %s     %s",
            string.upper(love.keyboard.getKeyFromScancode("z")),
            string.upper(love.keyboard.getKeyFromScancode("x")),
            string.upper(love.keyboard.getKeyFromScancode("c"))
        ),
        transform.x - 60, transform.y - 4
    )
    love.graphics.setFont(_G.font)
end


local function new()
    return GameObject.new({
        onDraw = onDraw,
    })
end


local Instructions = {}

Instructions.new = new

return Instructions