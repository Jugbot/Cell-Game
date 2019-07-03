Camera = require "hump.camera"
Gamestate = require "hump.gamestate"
Vector = require "hump.vector-light"
Squish = require "cell"

local menu = {}
local game = {}
local editor = {}

shader = love.graphics.newShader(love.filesystem.read("blob_shader.glsl"))


local squishies = {}

function squishies:positions()
  positions = {}
  for i, s in ipairs(self) do
    table.insert(positions, {s.body:getX(), s.body:getY()})
  end
  return positions
end

function squishies:radii()
  radii = {}
  for i, s in ipairs(self) do
    table.insert(radii, s.radius)
  end
  return radii
end

w = 650
h = 600

function love.resize(dw, dh)
  w = dw
  h = dh 
end

function love.load()
  love.window.setMode(w, h, {resizable = true})
  world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

  objects = {} -- table to hold all our physical objects
  --let's create the ground
  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, 0, 0) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  objects.ground.shape = love.physics.newRectangleShape(0, h/2, w, 50, 0) --make a rectangle with a width of 650 and a height of 50
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape); --attach shape to body
  objects.ground.shape2 = love.physics.newRectangleShape(0, -h/2, w, 50, 0) --make a rectangle with a width of 650 and a height of 50
  objects.ground.fixture2 = love.physics.newFixture(objects.ground.body, objects.ground.shape2); --attach shape to body
  objects.ground.shape3 = love.physics.newRectangleShape(w/2, 0, 50, h, 0) --make a rectangle with a width of 650 and a height of 50
  objects.ground.fixture3 = love.physics.newFixture(objects.ground.body, objects.ground.shape3); --attach shape to body
  objects.ground.shape4 = love.physics.newRectangleShape(-w/2, 0, 50, h, 0) --make a rectangle with a width of 650 and a height of 50
  objects.ground.fixture4 = love.physics.newFixture(objects.ground.body, objects.ground.shape4); --attach shape to body

  camera = Camera(0, 0)

  Gamestate.registerEvents()
  Gamestate.switch(editor)

end

function editor:update(dt)
  world:update(dt)
  if #squishies:positions() == 0 then return end
  shader:send("positions", unpack(squishies:positions()))
  shader:send("radii", unpack(squishies:radii()))
  shader:send("objects", #squishies)
  shader:send("cameraPosition", {camera:worldCoords(camera:position())})
end

function drawWorld()
  -- love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
  -- love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  -- love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape2:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  -- love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape3:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  -- love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape4:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

  -- for i=1,#squishies do
  --   squishies[i]:draw()
  -- end
  love.graphics.setBackgroundColor(220/256.0, 226/256.0, 200/256.0)
  for i=1, #squishies do
    squishies[i]:draw()
  end
  love.graphics.setShader(shader)
  love.graphics.setColor(101/256, 222/256, 241/256, 0.5)
  love.graphics.push()
  love.graphics.translate(-w/2, -h/2) 
  love.graphics.polygon("fill", 0,0,0, h, w, h, w, 0)
  love.graphics.pop()
  love.graphics.setShader()
  love.graphics.setColor(1,0,0)
end

function drawUI()

end

function editor:draw()
  camera:draw(drawWorld)
  drawUI()
end

local mouseJoint = nil

function love.mousepressed(mx,my,button) 
  local x, y = camera:worldCoords(mx, my)
  for i=1,#squishies do
    local squish = squishies[i]
    local dx, dy = squish.body:getPosition()
    if button == 1 and squish.shape:testPoint(dx,dy,0,x,y) then
      if mouseJoint then mouseJoint:destroy() end
      squish.body:setType("dynamic")
      mouseJoint = love.physics.newMouseJoint(squish.body, x, y)
      -- mouseJoint:setFrequency(5)
      -- mouseJoint:setDampingRatio(1)
    end
  end
  
  if button == 2 then
    table.insert(squishies, Squish.new(x, y, math.random( 20,30 )))
  end
end

function love.mousemoved(mx, my)
  local x, y = camera:worldCoords(mx, my)
  if mouseJoint then
    mouseJoint:setTarget(x, y)
  end
end

function love.mousereleased()
  if mouseJoint then 
    mouseJoint:getBodies():setType("static")
    mouseJoint:destroy() 
  end
  mouseJoint = nil
end
