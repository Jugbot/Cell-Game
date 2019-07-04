local Organelle = require "objects/organelle"

local Cell = {}
Cell.__index = Cell

function Cell.new(x, y, size)
  local cell = {}
  setmetatable(cell, Cell)

  cell.radius = math.nthgratio(size+6)
  cell.body = love.physics.newBody(world, x, y, "dynamic")
  cell.shape = love.physics.newCircleShape(cell.radius)
  cell.fixture = love.physics.newFixture(cell.body, cell.shape, 1)
  
  cell.organelles = {}

  for i=0, size do
    -- local r = math.random() * cell.radius/2
    -- local rtheta = math.random() * 2 * math.pi
    -- local x, y = math.sin(rtheta) * r + cell.body:getX(), math.cos(rtheta) * r + cell.body:getY()
    local x, y = cell.body:getX() + math.random(), cell.body:getY() + math.random()
    local o = Organelle.new(x, y, i)
    local j = love.physics.newDistanceJoint(o.body, cell.body, x, y, cell.body:getX(), cell.body:getY(), false)
    j:setLength(math.random() * (cell.radius - 2 * o.radius) + o.radius)
    cell.organelles[#cell.organelles + 1] = o
  end

  return cell
end

function Cell:draw()
  for i = 1, #self.organelles do
    self.organelles[i]:draw()
  end
  -- self:debug()
end

function Cell:update()

end

function Cell:debug()
  love.graphics.setColor(1,0,0)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

return Cell
