
-- Require

local Util = require("Util")
local Transform = require("Transform")



-- Methods

local function start(gameObject)
    for _, component in pairs(gameObject.components) do
        if component.beforeStart then
            component:beforeStart()
        end
    end

    gameObject.started = true
    for _, child in ipairs(gameObject.children) do
        child:start()
    end

    for _, component in pairs(gameObject.components) do
        if component.afterStart then
            component:afterStart()
        end
    end
end

local function stop(gameObject)
    for _, component in pairs(gameObject.components) do
        if component.beforeStop then
            component:beforeStop()
        end
    end


    for _, child in ipairs(gameObject.children) do
        child:stop()
    end
    gameObject.started = false

    for _, component in pairs(gameObject.components) do
        if component.afterStop then
            component:afterStop()
        end
    end
end


local function pause(gameObject)
    gameObject.notPaused = false
end

local function resume(gameObject)
    gameObject.notPaused = true
end

local function togglePause(gameObject)
    gameObject.notPaused = not gameObject.notPaused
end


local function compose(gameObject, componentName, component)
    gameObject.components[componentName] = component
    component.gameObject = gameObject
end


local function removeParent(gameObject)
    local currentParent = gameObject.parent
    if currentParent then
        local siblings = currentParent.children
        table.remove(siblings, Util.findIndexLinear(siblings, gameObject))

        gameObject.parent = nil
    end

    for _, component in pairs(gameObject.components) do
        if component.removeParent then
            component:removeParent()
        end
    end
end

local function changeParent(gameObject, newParent, index)
    gameObject:removeParent()

    gameObject.parent = newParent

    local siblings = newParent.children
    if index then
        table.insert(siblings, index, gameObject)
    else
        table.insert(siblings, gameObject)
    end

    if newParent.loaded and not gameObject.loaded then
        gameObject:load()
    end

    if newParent.started and not gameObject.started then
        gameObject:start()
    end
end


local function load(gameObject)
    local onLoad = gameObject.onLoad
    if onLoad then
        onLoad(gameObject)
    end

    for _, child in ipairs(gameObject.children) do
        child:load()
    end
    gameObject.loaded = true

    local afterLoad = gameObject.afterLoad
    if afterLoad then
        afterLoad(gameObject)
    end
end

local function update(gameObject, dt)
    if gameObject.notPaused then
        local onUpdate = gameObject.onUpdate
        if onUpdate then
            onUpdate(gameObject, dt)
        end

        for _, child in ipairs(gameObject.children) do
            if child.started then
                child:update(dt)
            end
        end

        local afterUpdate = gameObject.afterUpdate
        if afterUpdate then
            afterUpdate(gameObject, dt)
        end
    end
end

local function draw(gameObject, parentTransform)
    local transform = gameObject.transform
    local composedTransform = Transform.new()

    composedTransform.x = parentTransform.x + parentTransform.xScale*transform.x
    composedTransform.y = parentTransform.y + parentTransform.yScale*transform.y
    composedTransform.rotation = parentTransform.rotation + transform.rotation
    composedTransform.xScale = parentTransform.xScale * transform.xScale
    composedTransform.yScale = parentTransform.yScale * transform.yScale

    local onDraw = gameObject.onDraw
    if onDraw then
        onDraw(gameObject, composedTransform)
    end

    for _, child in ipairs(gameObject.children) do
        child:draw(composedTransform)
    end

    local afterDraw = gameObject.afterDraw
    if afterDraw then
        afterDraw(gameObject, composedTransform)
    end
end



-- Class

local gameObjectMt = {
    start = start,
    stop = stop,

    pause = pause,
    resume = resume,
    togglePause = togglePause,

    compose = compose,

    removeParent = removeParent,
    changeParent = changeParent,

    load = load,
    update = update,
    draw = draw,
}
gameObjectMt.__index = gameObjectMt

local function new(params)
    return setmetatable({
        parent = nil,
        children = {},
        components = {},
        started = false,
        notPaused = true,
        onLoad = params.onLoad,
        afterLoad = params.afterLoad,
        onUpdate = params.onUpdate,
        afterUpdate = params.afterUpdate,
        onDraw = params.onDraw,
        afterDraw = params.afterDraw,
        transform = Transform.new(),
    }, gameObjectMt)
end

local root = new({
    onLoad = start,
})


local GameObject = {}

GameObject.new = new
GameObject.root = root

return GameObject
