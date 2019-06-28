
local Cell = require "cell"

local Organism = {}
Organism.__index = Organism

function Organism.new()
  local organism = {}
  setmetatable(organism, Organism)

  organism.squishies = {}

  return organism
end

function Organism:draw()

end

function Organism:update()

end

return Organism