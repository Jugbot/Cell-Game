Slot = class "Slot"

function Slot:init(cell, x, y, size, type)
  assert(cell:instanceOf(Cell), "Tried to attach slot to non-Cell!")
  self.size = size
  self.type = type
  self.localX, self.localY = x, y
  self.radius = math.nthgratio(size + 4)
  self.color = {0,0,0,0.1}
  self.cell = cell
  self.organism = cell.parent
  systemWorld:addEntity(self)
end

function Slot:getPosition()
  return self.cell.body:getWorldPoint(self.localX, self.localY)
end

