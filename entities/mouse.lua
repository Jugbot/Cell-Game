Mouse = class "Mouse"

function Mouse:init()
  self.mousejoint = nil
  self.attached = nil
  systemWorld:addEntity(self)
end

function Mouse:attach(body)
  if self.mousejoint then self.mousejoint:destroy() end
  local x, y = camera:worldCoords(love.mouse.getPosition())
  self.mousejoint = love.physics.newMouseJoint(body, x, y)
  self.attached = body:getUserData()
end

function Mouse:detach()
  print("detach")
  if self.mousejoint then self.mousejoint:destroy() end
  self.mousejoint = nil
  self.attached = nil
end

