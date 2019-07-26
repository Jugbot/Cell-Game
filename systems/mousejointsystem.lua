MouseJointSystem = tiny.processingSystem(class "MouseJointSystem")

function MouseJointSystem:init()
  self.filter = tiny.requireAll("Mouse")
end

function MouseJointSystem:process(e, dt)
  if e.mousejoint then
    local x, y = camera:worldCoords(love.mouse.getPosition())
    e.mousejoint:setTarget(x, y)
  end
end