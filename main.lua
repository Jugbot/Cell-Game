Camera = require "hump.camera"

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

  --let's create a ball
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 0, 0, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  -- objects.ball.fixture:setRestitution(0.9) --let the ball bounce
  --another one
  objects.ball2 = {}
  objects.ball2.body = love.physics.newBody(world, 50, 50, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball2.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
  objects.ball2.fixture = love.physics.newFixture(objects.ball2.body, objects.ball2.shape, 1) -- Attach fixture to body and give it a density of 1.
  -- objects.ball2.fixture:setRestitution(0.9) --let the ball bounce

	-- love.physics.newPrismaticJoint( objects.ball.body, objects.ball2.body, 0, 0, 1, 1, true )
	-- love.physics.newRevoluteJoint(objects.ball.body, objects.ball2.body, 0, 0, true )
	joint = love.physics.newWeldJoint(objects.ball.body, objects.ball2.body, 0, 0, true )
	joint:setFrequency(0.5)
	 -- <1 springlike
	joint:setDampingRatio(10)

  camera = Camera(objects.ball.body:getX(), objects.ball.body:getY())

end


function love.update(dt)
  world:update(dt) --this puts the world into motion

  local dx,dy = objects.ball.body:getX() - camera.x, objects.ball.body:getY() - camera.y
  camera:move(dx * dt, dy * dt)

  --here we are going to create some keyboard events
  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    objects.ball.body:applyForce(400, 0)
  elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    objects.ball.body:applyForce(-400, 0)
  elseif love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
    objects.ball.body:applyForce(0, -400)
  elseif love.keyboard.isDown("down") then --press the up arrow key to set the ball in the air
    objects.ball.body:applyForce(0, 400)
  end
end

function love.draw()
	camera:attach()
  love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape2:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape3:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape4:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

  love.graphics.setColor(0.76, 0.18, 0.05) --set the drawing color to red for the ball
  love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

  love.graphics.setColor(0.76, 0.18, 0.55) --set the drawing color to red for the ball
  love.graphics.circle("fill", objects.ball2.body:getX(), objects.ball2.body:getY(), objects.ball2.shape:getRadius())
	camera:detach()
end
