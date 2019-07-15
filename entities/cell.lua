Cell = class "Cell"

function Cell:init(x, y, size)
  self.radius = math.nthgratio(size+6)
  self.body = love.physics.newBody(physicsWorld, x, y, "dynamic")
  self.body:setUserData(self)
  self.shape = love.physics.newCircleShape(self.radius)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.grabbed = false
  self.parent = nil
  
  self.organelles = {}

  for i=0, size do
    -- local r = math.random() * self.radius/2
    -- local rtheta = math.random() * 2 * math.pi
    -- local x, y = math.sin(rtheta) * r + self.body:getX(), math.cos(rtheta) * r + self.body:getY()
    local x, y = self.body:getX() + math.random(), self.body:getY() + math.random()
    local o = Organelle(x, y, i)
    local j = love.physics.newDistanceJoint(o.body, self.body, x, y, self.body:getX(), self.body:getY(), false)
    j:setLength(math.random() * (self.radius - 2 * o.radius) + o.radius)
    self.organelles[#self.organelles + 1] = o
  end
  systemWorld:addEntity(self)
end

Cell.drawLayer = 4
function Cell:draw()
  if not self.parent then
    love.graphics.setColor(101/256, 222/256, 241/256, 0.5)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
    love.graphics.setColor(101/256, 222/256, 241/256, 1)
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
  end
end

function Cell:update()

end

function Cell:kill()
  self.body:destroy()
end

function Cell:debug()
  love.graphics.setColor(1,0,0)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

