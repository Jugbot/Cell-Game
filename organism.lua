
local Cell = require "cell"

local Organism = {}
Organism.__index = Organism

function Organism.new()
  local organism = {}
  setmetatable(organism, Organism)

  organism.cells = {}

  return organism
end

function Organism:draw()
  for i=1, #self.cells do
    self.cells[i]:draw()
  end
  love.graphics.setShader(shader)
  love.graphics.setColor(101/256, 222/256, 241/256, 0.5)
  love.graphics.push()
  love.graphics.translate(-w/2, -h/2) 
  love.graphics.polygon("fill", 0,0,0, h, w, h, w, 0)
  love.graphics.pop()
  love.graphics.setShader()
end

function Organism:update()
  if #squishies:positions() == 0 then return end
  shader:send("positions", unpack(squishies:positions()))
  shader:send("radii", unpack(squishies:radii()))
  shader:send("objects", #squishies)
  shader:send("cameraPosition", {camera:worldCoords(camera:position())})
end

return Organism