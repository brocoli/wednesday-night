
local GameObject = require("GameObject")



local function onLoad(task)
    task.finishTime = love.timer.getTime() + task.time
end

local function onUpdate(task, dt)
    if love.timer.getTime() >= task.finishTime then
        task.callback()

        task.repetitions = task.repetitions - 1

        if task.repetitions == 0 then
            task:stop()
            task:removeParent()
        else
            task.finishTime = task.finishTime + task.time
        end
    end
end


local function new(time, repetitions, callback)
    local task = GameObject.new({
        onLoad = onLoad,
        onUpdate = onUpdate,
    })

    task.time = time
    task.repetitions = repetitions
    task.callback = callback

    return task
end


local Task = {}

Task.new = new

return Task
