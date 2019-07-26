Core = class "Core"

function Core:init(x, y)
  self.radius = math.nthgratio(4)
  self.body = love.physics.newBody(physicsWorld, x, y, "dynamic")
  self.shape = love.physics.newCircleShape(self.radius)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setCategory()
  self.color = {0.733, 0.553, 0.969}
  self.slots={
    primary=self.body
  }
  self.grabbed = false
  systemWorld:addEntity(self)
end

Core.drawLayer = 3
function Core:draw()
  love.graphics.setColor(unpack(self.color))
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
  love.graphics.setLineWidth(4)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
  -- self:debug()
end

function Core:debug()
  love.graphics.setColor(0,1,0)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end
