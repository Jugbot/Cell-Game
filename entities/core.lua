Core = class "Core"
Core:with(MouseComponent)

function Core:init(x, y)
  self.radius = math.nthgratio(6)
  self.body = love.physics.newBody(physicsWorld, x, y, "dynamic")
  self.body:setUserData(self)
  self.shape = love.physics.newCircleShape(self.radius)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)
  self.color = {0.835, 0.69, 0.675}
  self.colorborder = {0.561, 0.443, 0.447}
  self.plug = {size=0, type="primary"}
  self.grabbed = false
  systemWorld:addEntity(self)
end

Core.drawLayer = 3
function Core:draw()
  love.graphics.setColor(unpack(self.color))
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
  love.graphics.setLineWidth(10)
  love.graphics.setColor(unpack(self.colorborder))
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
  -- self:debug()
end

function Core:debug()
  love.graphics.setColor(0,1,0)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end
