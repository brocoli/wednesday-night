
local function findIndexLinear(theArray, searchedValue)
    for i, value in ipairs(theArray) do
        if value == searchedValue then
            return i
        end
    end
end


local Util = {}

Util.findIndexLinear = findIndexLinear

return Util
