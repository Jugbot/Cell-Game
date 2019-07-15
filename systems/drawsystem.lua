    
DrawSystem = tiny.sortedProcessingSystem(class "DrawSystem")

DrawSystem.drawService = true
function DrawSystem:init(camera)
    self.camera = camera
    self.filter = tiny.requireAll("draw")
end

function DrawSystem:preProcess(dt)
    self.camera:attach()
end

function DrawSystem:process(e, dt)
    e:draw()
end

function DrawSystem:postProcess(dt)
    self.camera:detach()
    love.graphics.setColor(255, 255, 255, 255)
end

function DrawSystem:compare(e1, e2)
    if e1.drawLayer == nil or e2.drawLayer == nil then return false end
    return e1.drawLayer < e2.drawLayer
end