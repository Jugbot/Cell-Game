Organelle = class "Organelle"

function Organelle:init(x, y, points)
  self.points = points
  self.radius = math.nthgratio(points + 4)
  self.body = love.physics.newBody(physicsWorld, x, y, "dynamic")
  self.shape = love.physics.newCircleShape(self.radius)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setCategory()
  self.color = {101/256, 222/256, 241/256}
  systemWorld:addEntity(self)
end

function Organelle:detach() 

end

Organelle.drawLayer = 3
function Organelle:draw()
  love.graphics.setColor(unpack(self.color))
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
  -- self:debug()
end

function Organelle:debug()
  love.graphics.setColor(0,1,0)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end