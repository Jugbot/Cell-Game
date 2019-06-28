local Organelle = require "organelle"

local Cell = {}
Cell.__index = Cell

function Cell.new(x, y, radius)
  local cell = {}
  setmetatable(cell, Cell)

  cell.radius = radius
  cell.body = love.physics.newBody(world, x, y, "dynamic")
  cell.shape = love.physics.newCircleShape(cell.radius)
  cell.fixture = love.physics.newFixture(cell.body, cell.shape, 1)
  
  cell.organelles = {}
  local i = 16
  while i < radius/2 do
    local r = math.random() * (radius - i * 2) + i
    local rtheta = math.random() * 2 * math.pi
    local x, y = math.sin(rtheta) * r + cell.body:getX(), math.cos(rtheta) * r + cell.body:getY()
    local o = Organelle.new(x, y, i)
    love.physics.newDistanceJoint(o.body, cell.body, x, y, cell.body:getX(), cell.body:getY(), false)
    cell.organelles[#cell.organelles + 1] = o
    i = i * 1.5
  end

  return cell
end

function Cell:draw()
  for i = 1, #self.organelles do
    self.organelles[i]:draw()
  end
  -- self:debug()
end

function Cell:debug()
  love.graphics.setColor(1,0,0)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

return Cell
