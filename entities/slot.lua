Slot = class "Slot"

function Slot:init(cell, x, y, size, type)
  assert(cell:instanceOf(Cell), "Tried to attach slot to non-Cell!")
  self.size = size
  self.type = type
  self.localX, self.localY = x, y
  self.radius = math.nthgratio(size + 4)
  -- local cx, cy = cell.body:getPosition()
  -- self.body = love.physics.newBody(physicsWorld, cx + x, cy + y, "dynamic")
  -- self.body:setUserData(self)
  -- self.body:setMass(0)
  -- self.shape = love.physics.newCircleShape(self.radius)
  -- self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  -- self.fixture:setUserData(self)
  -- self.fixture:setSensor(true)
  self.color = {0,0,0,0.1}
  self.cell = cell
  self.organism = cell.parent
  systemWorld:addEntity(self)
end

function Slot:getPosition()
  return self.cell.body:getWorldPoint(self.localX, self.localY)
end

