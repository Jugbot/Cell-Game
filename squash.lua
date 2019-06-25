
local Squash = {}
Squash.__index = Squash

function Squash.new(x, y, size)
  local self = setmetatable({}, Squish)

  self.radius = size/2
  self.body = love.physics.newBody(world, x, y, "dynamic")
  self.shape = love.physics.newCircleShape(self.radius)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)

  return self
end

function Squash:draw()
  love.graphics.setColor(101/256, 222/256, 241/256, 0.46)
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
  love.graphics.setColor(101/256, 222/256, 241/256)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

return Squash
