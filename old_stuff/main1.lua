Camera = require "hump.camera"
Squish = require "squish"

local squishies = {}

function love.load()
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 0, false) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

  objects = {} -- table to hold all our physical objects
	w = 650
	h = 600
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
  table.insert(squishies, Squish.new(50, 50, 100))

end

function love.update(dt)
  world:update(dt) --this puts the world into motion

  -- local dx,dy = squish:getX() - camera.x, squish:getY() - camera.y
  -- camera:move(dx * dt, dy * dt)

  -- --here we are going to create some keyboard events
  -- if love.keyboard.isDown("d") then --press the right arrow key to push the ball to the right
  --   squish:body():applyForce(400, 0)
  -- elseif love.keyboard.isDown("a") then --press the left arrow key to push the ball to the left
  --   squish:body():applyForce(-400, 0)
  -- elseif love.keyboard.isDown("w") then --press the up arrow key to set the ball in the air
  --   squish:body():applyForce(0, -400)
  -- elseif love.keyboard.isDown("s") then --press the up arrow key to set the ball in the air
  --   squish:body():applyForce(0, 400)
  -- end

end

function love.draw()
	camera:attach()
  love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape2:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape3:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape4:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

  for i=1,#squishies do
    squishies[i]:draw()
  end

	camera:detach()
end

local mouseJoint = nil

function love.mousepressed(mx,my,button) 
  local x, y = camera:worldCoords(mx, my)
  for i=1,#squishies do
    local squish = squishies[i]
    local dx, dy = squish:body():getPosition()
    if button == 1 and squish:shape():testPoint(dx,dy,0,x,y) then
      if mouseJoint then mouseJoint:destroy() end
      mouseJoint = love.physics.newMouseJoint(squish:body(), x, y)
      -- mouseJoint:setFrequency(5)
      -- mouseJoint:setDampingRatio(1)
    end
  end
  
  if button == 2 then
    table.insert(squishies, Squish.new(x, y, 100))
  end
end

function love.mousemoved(mx, my)
  local x, y = camera:worldCoords(mx, my)
  if mouseJoint then
    mouseJoint:setTarget(x, y)
  end
end

function love.mousereleased()
  if mouseJoint then mouseJoint:destroy() end
  mouseJoint = nil
end
