Organism = class "Organism"
Organism.shader = love.graphics.newShader(love.filesystem.read("blob_shader.glsl"))

function Organism:init()
  self.dirty = false -- Should check integrity and split if need be
  self.cells = {}
  self.cellsData = love.image.newImageData(1024, 1, "rgba16f")
  self.cellsDataImage = love.graphics.newImage(self.cellsData)
  systemWorld:addEntity(self)
end

function Organism:spawn() 
  for i=1, #self.cells do
    self.cells[i]:spawn()
  end
end

Organism.drawLayer = 5
function Organism:draw()
  for i=1, #self.cells do
    local cell = self.cells[i]
    local x, y, r = cell.body:getX(), cell.body:getY(), cell.radius
    self.cellsData:setPixel(i-1, 0, x, y, r, 0)
  end
  self.cellsDataImage:replacePixels(self.cellsData)
  self.shader:send("positionradii", self.cellsDataImage)
  self.shader:send("objects", #self.cells)
  love.graphics.setShader(self.shader)
  love.graphics.setColor(101/256, 222/256, 241/256, 0.5)
  w, h = love.graphics.getDimensions()
  love.graphics.rectangle("fill", -w/2,-h/2,w,h)
  love.graphics.setShader()
end

function dfs(currentBody, outArray)
  if currentBody:isDestroyed() then return end
  local owner = currentBody:getUserData()
  if owner.visited then return end
  owner.visited = true
  table.insert(outArray, owner)
  local joints = currentBody:getJoints()
  for j=1, #joints do
    if not joints[j]:isDestroyed() and joints[j]:getUserData() == "cell" then
      local b1, b2 = joints[j]:getBodies()
      dfs(b1, outArray)
      dfs(b2, outArray)
    end
  end
end

function Organism:update()
  if self.dirty then
    local allCells = table.clone(self.cells) --shallow copy
    self.cells = {}
    if self.core then 
      local currentBody = self.core.body
      self.core.visited = true
      dfs(currentBody, self.cells)
    end
    for i=1, #allCells do
      if not allCells[i].visited then
        local newGroup = {}
        dfs(allCells[i].body, newGroup)
        if #self.cells == 0 then 
          self.cells = newGroup
        else
          local o = Organism()
          o.cells = newGroup
        end
      end
    end
    for i=1, #allCells do
      allCells[i].visited = false
    end
    self.dirty = false
  end
end

function Organism:attachCell(cell)
  local cells = self.cells
  local success = false
  if #cells == 0 then
    table.insert(self.cells, cell)
    cell.parent = self
    return true
  end
  for i=1, #cells do
    local dist = love.physics.getDistance(cells[i].fixture, cell.fixture)
    if dist < 5 then
      local b1, b2 = cells[i].body, cell.body
      local j = love.physics.newDistanceJoint(b1, b2, b1:getX(), b1:getY(), b2:getX(), b2:getY(), false)
      j:setUserData("cell")
      table.insert(self.cells, cell)
      cell.parent = self
      success = true
    end
  end
  return success
end
