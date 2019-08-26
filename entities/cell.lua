Cell = class "Cell"

function Cell:init(x, y, size)
  self.color = {0.588, 0.737, 0.761}
  self.size = size
  self.radius = math.nthgratio(size+6)
  self.body = love.physics.newBody(physicsWorld, x, y, "dynamic")
  self.body:setUserData(self)
  self.shape = love.physics.newCircleShape(self.radius)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setUserData(self)
  self.parent = nil
  self.slots = {}
  self:_addSlots()
  self.organelles = {}
  self:_addOrganelles()
  -- subscribe to systems which require these events
  self.events = { mousepressed=false, grabbed=false }

  systemWorld:addEntity(self)
end

function Cell:_addSlots()
  local pattern = {
    {
      {count=1, size=0}
    },
    {
      {count=0, size=0},
      {count=3, size=0}
    },
    {
      {count=1, size=0},
      {count=3, size=1},
    },
    {
      {count=1, size=1},
      {count=3, size=2},
      {count=3, size=0}
    }
  }
  self.slots[Slot(self, 0, 0, self.size, "primary")] = true 
  local distance = 0
  for _, set in ipairs(pattern[self.size+1]) do
    local count, size = set.count, set.size
    local angle = 0
    for i2=1, count do 
      local x, y = math.sin(angle) * distance, math.cos(angle) * distance
      -- print(x,y)
      local s = Slot(self, x, y, size, "secondary")
      -- local j = love.physics.newWeldJoint(s.body, self.body, x, y)
      -- j:setUserData(self)
      self.slots[s] = true
      angle = angle + math.pi * 2 / count
    end
    distance = distance + self.radius / #pattern[self.size+1]
    print(size, distance)
  end
end

function Cell:_addOrganelles()
  for i=0, self.size do
    local x, y = self.body:getX() + math.random(), self.body:getY() + math.random()
    local o = Organelle(x, y, i)
    local j = love.physics.newDistanceJoint(o.body, self.body, x, y, self.body:getX(), self.body:getY(), false)
    j:setLength(math.random() * (self.radius - 2 * o.radius) + o.radius)
    j:setUserData(self)
    self.organelles[#self.organelles + 1] = o
  end
end

Cell.drawLayer = 4
function Cell:draw()
  if not self.parent then
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], 0.5)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
    love.graphics.setColor(unpack(self.color))
    love.graphics.setLineWidth(8)
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
  end
end

function Cell:debug()
  love.graphics.setColor(1,0,0)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

