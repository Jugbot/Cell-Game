MouseDragSystem = tiny.processingSystem(class "MouseDragSystem")

function MouseDragSystem:init(camera)
    self.filter = tiny.requireAll("grabbed")
    self.mousejoint = nil
    self.lastType = nil
    self.camera = camera
end

function MouseDragSystem:process(e, dt)
    local mx, my = self.camera:mousePosition()
    if self.mousejoint then
        if love.mouse.isDown(1) then
            self.mousejoint:setTarget(mx, my)
        else
            self.mousejoint:destroy()
            e.body:setType(self.lastType)
            self.mousejoint = nil
            self.lastType = nil
            e.grabbed = false
        end
    else
        if love.mouse.isDown(1) then
            if e.fixture:testPoint(mx, my) then
                local x, y = e.body:getPosition()
                self.lastType = e.body:getType()
                e.body:setType("dynamic")
                self.mousejoint = love.physics.newMouseJoint(e.body, x, y)
                e.grabbed = true
            end
        end
    end

end
