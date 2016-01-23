
-- Require

local Util = require("Util")



-- Specs

-- config = {
--     beforeStart -- function
--     afterStart -- function
--     beforeStop -- function
--     afterStop -- function
-- }



-- Private methods

local function startChildren(gameObject)
    for _, child in ipairs(gameObject.children) do
        child:start()
    end
end

local function stopChildren(gameObject)
    for _, child in ipairs(gameObject.children) do
        child:stop()
    end
end



-- Methods

local function start(gameObject)
    local config = gameObject.config

    local beforeStart = config.beforeStart
    if beforeStart then
        beforeStart(gameObject)
    end
    for _, component in pairs(gameObject.components) do
        component:beforeStart()
    end

    gameObject.started = true
    startChildren(gameObject)

    local afterStart = config.afterStart
    if afterStart then
        afterStart(gameObject)
    end
    for _, component in pairs(gameObject.components) do
        component:afterStart()
    end
end

local function stop(gameObject)
    local config = gameObject.config

    local beforeStop = config.beforeStop
    if beforeStop then
        beforeStop(gameObject)
    end
    for _, component in pairs(gameObject.components) do
        component:beforeStop()
    end

    stopChildren(gameObject)
    gameObject.started = false

    local afterStop = config.afterStop
    if afterStop then
        afterStop(gameObject)
    end
    for _, component in pairs(gameObject.components) do
        component:afterStop()
    end
end


local function unparent(gameObject)
    local currentParent = gameObject.parent
    if currentParent then
        local siblings = currentParent.children
        table.remove(siblings, Util.findIndexLinear(siblings, gameObject))
    end
end

local function changeParent(gameObject, newParent, index)
    gameObject:unparent()

    gameObject.parent = newParent

    local siblings = newParent.children
    if index then
        table.insert(siblings, index, gameObject)
    else
        table.insert(siblings, gameObject)
    end

    if newParent.started and not gameObject.started then
        gameObject:start()
    end
end

local function insertComponent(gameObject, componentName, component)
    gameObject.components[componentName] = component
    component.gameObject = gameObject

    if gameObject.started then
        component:start()
    end
end



-- Class

local gameObjectMt = {
    start = start,
    stop  = stop,
    unparent = unparent,
    changeParent = changeParent,
}
gameObjectMt.mt = gameObjectMt
gameObjectMt.__index = gameObjectMt

local function new(config)
    return setmetatable({
        config = config,
        started = false,
        children = {},
        parent = nil,
        components = {},
    }, gameObjectMt)
end

local mainGameObject = new({})
mainGameObject:start()


local GameObject = {}

GameObject.new = new
GameObject.main = main

return GameObject
