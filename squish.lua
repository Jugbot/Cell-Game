
local Squish = {}
Squish.__index = Squish

function Squish:init(x,y,size) 
  num = size/2
  self.center = {}
  self.nodes = {}
  local body = love.physics.newBody(world, x, y, "dynamic")
  self.center.body = body
  self.center.shape = love.physics.newCircleShape(20)
  self.center.fixture = love.physics.newFixture(self.center.body, self.center.shape, 1)
  self.nodeshape = love.physics.newCircleShape(10)

  last = false
  for i=1,num do 
    local angle = (2*math.pi)/num*i;
    
    local posx = x+size*math.cos(angle);
    local posy = y+size*math.sin(angle);
    self.nodes[i] = {}
    local body = love.physics.newBody(world, posx, posy, "dynamic")
    body:setBullet(true)
    body:setAngularDamping(5000)
    body:setMass(1)
    self.nodes[i].body = body
    local fixture = love.physics.newFixture(self.nodes[i].body, self.nodeshape, 1)
    -- fixture:setCategory(2)
    -- fixture:setMask(2)
    self.nodes[i].fixture = fixture
    joint = love.physics.newDistanceJoint(self.nodes[i].body, self.center.body, posx, posy, posx, posy, true )
    joint:setDampingRatio(0.2)
    joint:setFrequency(0.8)
  end

  for i = 1, #self.nodes do
    if i < #self.nodes then
      local j = love.physics.newDistanceJoint(self.nodes[i].body, self.nodes[i+1].body, self.nodes[i].body:getX(), self.nodes[i].body:getY(),
      self.nodes[i+1].body:getX(), self.nodes[i+1].body:getY(), false);
      self.nodes[i].joint2 = j;
    else
      local j = love.physics.newDistanceJoint(self.nodes[i].body, self.nodes[1].body, self.nodes[i].body:getX(), self.nodes[i].body:getY(),
      self.nodes[1].body:getX(), self.nodes[1].body:getY(), false);
      self.nodes[i].joint3 = j;
    end
  end
end

local lineThickness = 10
function Squish:getPoints()
  local points = {}
  for i=1, #self.nodes do 
    local padding = self.nodeshape:getRadius() - lineThickness/2
    local distance = math.sqrt((self.center.body:getX() - self.nodes[i].body:getX())^2 + (self.center.body:getY() - self.nodes[i].body:getY())^2)
    local normal = {x=-(self.center.body:getX() - self.nodes[i].body:getX())/distance, y=-(self.center.body:getY() - self.nodes[i].body:getY())/distance}
    table.insert(points, self.nodes[i].body:getX() + normal.x*padding)
    table.insert(points, self.nodes[i].body:getY() + normal.y*padding)
  end
  return points
end

function Squish:draw()
  love.graphics.setColor(0.76, 0.18, 0.55) --set the drawing color to red for the ball
  love.graphics.circle("fill", self.center.body:getX(), self.center.body:getY(), self.center.shape:getRadius())
  
  love.graphics.setLineStyle("smooth");
  love.graphics.setLineJoin("miter");
  love.graphics.setLineWidth(lineThickness);
  local points = self:getPoints()
  love.graphics.setColor(101/256, 222/256, 241/256, 0.46) --set the drawing color to red for the ball
  love.graphics.polygon("fill", points);
  love.graphics.setColor(101/256, 222/256, 241/256) --set the drawing color to red for the ball
  love.graphics.polygon("line", points);
  
  love.graphics.setColor(0.76, 0.18, 0.05)
  love.graphics.setLineWidth(1);
  for i=1, #self.nodes do 
    -- love.graphics.circle("line", self.nodes[i].body:getX(), self.nodes[i].body:getY(), self.nodeshape:getRadius())
  end
end

function Squish:update() 
  --here we are going to create some keyboard events
  if love.keyboard.isDown("d") then --press the right arrow key to push the ball to the right
    self.center.body:applyForce(400, 0)
  elseif love.keyboard.isDown("a") then --press the left arrow key to push the ball to the left
    self.center.body:applyForce(-400, 0)
  elseif love.keyboard.isDown("w") then --press the up arrow key to set the ball in the air
    self.center.body:applyForce(0, -400)
  elseif love.keyboard.isDown("s") then --press the up arrow key to set the ball in the air
    self.center.body:applyForce(0, 400)
  end
end

function Squish:getX() return self.center.body:getX() end
function Squish:getY() return self.center.body:getY() end

return Squish