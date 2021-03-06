    
DrawSystem = tiny.sortedProcessingSystem(class "DrawSystem")

function DrawSystem:init()
    self.filter = tiny.requireAll("draw")
end

function DrawSystem:process(e, dt)
    e:draw()
end

function DrawSystem:compare(e1, e2)
    if e1.drawLayer == nil or e2.drawLayer == nil then return false end
    return e1.drawLayer < e2.drawLayer
end