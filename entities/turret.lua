
-- Turret:with(MouseComponent)
require "entities.item"
Turret = Item:extend("Turret")
Turret.image = love.graphics.newImage("/assets/turret.png")

function Turret:init(x, y)
  self.super.init(self, 0, "secondary")
  self.radius = math.nthgratio(4)
  self.body = love.physics.newBody(physicsWorld, x, y, "dynamic")
  self.body:setUserData(self)
  self.shape = love.physics.newCircleShape(self.radius)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)
  self.color = {1.00, 0.525, 0.18}
  self.colorBorder = {0.976, 0.412, 0}
  systemWorld:addEntity(self)
end

Turret.drawLayer = 7
function Turret:draw()
  love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
  self:debug()
end

function Turret:debug()
  love.graphics.setLineWidth(1.0)
  love.graphics.setColor(0,1,0)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end
