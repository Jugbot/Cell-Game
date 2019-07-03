
local Cell = require "cell"

local Organism = {}
Organism.__index = Organism

function Organism.new()
  local organism = {}
  setmetatable(organism, Organism)

  organism.cells = {}
  organism.cellsData = love.image.newImageData(4096, 1, "rgba16f")
  organism.cellsDataImage = love.graphics.newImage(organism.cellsData)

  return organism
end

function Organism:draw()
  for i=1, #self.cells do
    self.cells[i]:draw()
  end
  self.cellsDataImage:replacePixels(self.cellsData)
  shader:send("positionradii", self.cellsDataImage)
  shader:send("objects", #self.cells)
  shader:send("cameraPosition", {camera:worldCoords(camera:position())})
  love.graphics.setShader(shader)
  love.graphics.setColor(101/256, 222/256, 241/256, 0.5)
  love.graphics.push()
  love.graphics.translate(-screenWidth/2, -screenHeight/2) 
  love.graphics.polygon("fill", 0,0,0, screenHeight, screenWidth, screenHeight, screenWidth, 0)
  love.graphics.pop()
  love.graphics.setShader()
end

function Organism:update()
  for i=1, #self.cells do
    local cell = self.cells[i]
    cell:update()
    self.cellsData:setPixel(i-1, 0, cell.body:getX(), cell.body:getY(), cell.radius, 0)
  end
end

return Organism