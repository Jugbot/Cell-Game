local editor = {}

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

function editor:mousepressed(mx,my,button) 
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
    local r = math.random(0, 3)
    table.insert(objects.player.cells, Squish.new(x, y, r))
  end
end

function editor:mousemoved(mx, my)
  local x, y = camera:worldCoords(mx, my)
  if mouseJoint then
    mouseJoint:setTarget(x, y)
  end
end

function editor:mousereleased()
  if mouseJoint then 
    mouseJoint:getBodies():setType("static")
    mouseJoint:destroy() 
  end
  mouseJoint = nil
end


return editor