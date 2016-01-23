
local function new()
    return {
        x = 0,
        y = 0,
        rotation = 0,
        xScale = 1,
        yScale = 1,
    }
end


local Transform = {}

Transform.new = new

return Transform