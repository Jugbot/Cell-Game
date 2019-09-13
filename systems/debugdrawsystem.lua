    
DebugDrawSystem = tiny.sortedProcessingSystem(class "DebugDrawSystem")

function DebugDrawSystem:init()
    self.filter = tiny.requireAll("debug")
end

function DebugDrawSystem:process(e, dt)
    e:debug()
end

function DebugDrawSystem:compare(e1, e2)
    if e1.drawLayer == nil or e2.drawLayer == nil then return false end
    return e1.drawLayer < e2.drawLayer
end