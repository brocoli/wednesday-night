
-- Require

local Util = require("Util")



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
    for _, component in pairs(gameObject.components) do
        local beforeStart = component.beforeStart
        if beforeStart then
            component:beforeStart()
        end
    end

    gameObject.started = true
    startChildren(gameObject)

    for _, component in pairs(gameObject.components) do
        local afterStart = component.afterStart
        if afterStart then
            component:afterStart()
        end
    end
end

local function stop(gameObject)
    for _, component in pairs(gameObject.components) do
        local beforeStop = component.beforeStop
        if beforeStop then
            component:beforeStop()
        end
    end

    stopChildren(gameObject)
    gameObject.started = false

    for _, component in pairs(gameObject.components) do
        local afterStop = component.afterStop
        if afterStop then
            component:afterStop()
        end
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

local function compose(gameObject, componentName, component)
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
    compose = compose,
}
gameObjectMt.mt = gameObjectMt
gameObjectMt.__index = gameObjectMt

local function new()
    return setmetatable({
        parent = nil,
        children = {},
        components = {},
        started = false,
    }, gameObjectMt)
end

local root = new({})
root:start()


local GameObject = {}

GameObject.new = new
GameObject.root = root

return GameObject
