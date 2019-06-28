local Organelle = {}
Organelle.__index = Organelle

function Organelle.new(x, y, radius)
  local organelle = {}
  setmetatable(organelle, Organelle)

  organelle.radius = radius
  organelle.body = love.physics.newBody(world, x, y, "dynamic")
  organelle.shape = love.physics.newCircleShape(organelle.radius)
  organelle.fixture = love.physics.newFixture(organelle.body, organelle.shape, 1)

  return organelle
end

function Organelle:detach() 

end

function Organelle:draw()
  love.graphics.setColor(101/256, 222/256, 241/256)
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
  -- self:debug()
end

function Organelle:debug()
  love.graphics.setColor(0,1,0)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

return Organelle
