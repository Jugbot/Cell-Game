Organism = class "Organism"
Organism.shader = love.graphics.newShader(love.filesystem.read("blob_shader.glsl"))

function Organism:init()
  self.dirty = false -- Should check integrity and split if need be
  self.cellsCount = 0
  self.cells = {}
  self.cellsData = love.image.newImageData(1024, 1, "rgba16f")
  self.cellsDataImage = love.graphics.newImage(self.cellsData)
  systemWorld:addEntity(self)
end

Organism.drawLayer = 5
function Organism:draw()
  local i = 0
  for cell, _ in pairs(self.cells) do
    local x, y, r = cell.body:getX(), cell.body:getY(), cell.radius
    self.cellsData:setPixel(i, 0, x, y, r, 0)
    i = i + 1
  end
  self.cellsDataImage:replacePixels(self.cellsData)
  self.shader:send("positionradii", self.cellsDataImage)
  self.shader:send("objects", self.cellsCount)
  love.graphics.setShader(self.shader)
  love.graphics.setColor(101/256, 222/256, 241/256, 0.5)
  w, h = love.graphics.getDimensions()
  love.graphics.rectangle("fill", -w/2,-h/2,w,h)
  love.graphics.setShader()
end

function Organism:_addCell(cell)
  self.cells[cell] = true
  self.cellsCount = self.cellsCount + 1
  cell.parent = self
  print('attach', self.cellsCount)
end

function Organism:_removeCell(cell)
  self.cells[cell] = nil
  self.cellsCount = self.cellsCount - 1
  cell.parent = nil
  self.dirty = true
  print('detach', self.cellsCount)
end

function Organism:attachCell(cell)
  assert(cell:instanceOf(Cell), "tried to attach non-cell to organism!")
  local cells = self.cells
  if self.cellsCount == 0 then
    self:_addCell(cell)
    return true
  end
  local success = false
  for other, _ in pairs(cells) do
    local dist = love.physics.getDistance(other.fixture, cell.fixture)
    local b1, b2 = other.body, cell.body
    if dist < 5 and dist >= 0 and b1 ~= b2 then
      local j = love.physics.newDistanceJoint(b1, b2, b1:getX(), b1:getY(), b2:getX(), b2:getY(), false)
      j:setUserData(self)
      success = true
    end
  end
  if success then
    self:_addCell(cell)
  end
  return success
end

function Organism:detachCell(cell)
  assert(cell:instanceOf(Cell), "tried to detach non-cell from organism!")
  if self.cells[cell] then
    cell:_detachParent()
    self:_removeCell(cell)
  end
end
