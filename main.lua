Camera = require "hump.camera"
Gamestate = require "hump.gamestate"
Vector = require "hump.vector-light"
Squish = require "cell"
Organism = require "organism"

local menu = {}
local game = {}
local editor = {}

shader = love.graphics.newShader(love.filesystem.read("blob_shader.glsl"))

screenWidth = nil
screenHeight = nil

function love.resize(dw, dh)
  screenWidth = dw
  screenHeight = dh 
end

function love.load()
  screenWidth, screenHeight = love.graphics.getDimensions()
  world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

  objects = {} -- table to hold all our physical objects
  objects.player = Organism.new()

  camera = Camera(0, 0)

  Gamestate.registerEvents()
  Gamestate.switch(editor)

end

function editor:update(dt)
  world:update(dt)
  objects.player:update(dt)
end

function drawWorld()
  love.graphics.setBackgroundColor(220/256.0, 226/256.0, 200/256.0)
  objects.player:draw()
end

function drawUI()

end

function editor:draw()
  camera:draw(drawWorld)
  drawUI()
  love.graphics.setColor(1,0.5,0.5)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

local mouseJoint = nil

function love.mousepressed(mx,my,button) 
  local x, y = camera:worldCoords(mx, my)
  local squishies = objects.player.cells
  for i=1,#squishies do
    local squish = squishies[i]
    local dx, dy = squish.body:getPosition()
    if button == 1 and squish.shape:testPoint(dx,dy,0,x,y) then
      if mouseJoint then mouseJoint:destroy() end
      squish.body:setType("dynamic")
      mouseJoint = love.physics.newMouseJoint(squish.body, x, y)
    end
  end
  
  if button == 2 then
    local r = math.random() * 50 + 20
    table.insert(objects.player.cells, Squish.new(x, y, r))
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
