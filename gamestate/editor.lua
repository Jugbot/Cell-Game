editor = {}
local camera = Camera(70, 30)
local editorPhysicsWorld = love.physics.newWorld(0, 0, false)
local editorSystemWorld = tiny.world(
  DrawSystem(camera), UpdateSystem(), MouseDragSystem(camera))

function editor:enter()
  camera:lookAt(0, 0)
  physicsWorld = editorPhysicsWorld
  systemWorld = editorSystemWorld
  love.graphics.setBackgroundColor(220/256.0, 226/256.0, 200/256.0)
  local organism = Organism()
  local cell = Cell(0, 0, 2)
  cell.body:setType("static")
  organism:attachCell(cell)
  table.insert(organism.cells, Cell(0, 0, 1))
  local player = Player(organism)
  print(#player.organism.cells)
end

function editor:update(dt)
  physicsWorld:update(dt)
  systemWorld:update(dt, tiny.requireAny("drawSystem"))
end

function editor:draw()
  systemWorld:update(dt, tiny.rejectAny("drawSystem"))
  love.graphics.setColor(1,0.5,0.5)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

-- function editor:mousepressed(mx,my,button) 
--   local x, y = camera:worldCoords(mx, my)
--   if button == 1 and currentCell then
--     local squish = currentCell
--     local dx, dy = squish.body:getPosition()
--     if squish.shape:testPoint(dx,dy,0,x,y) then
--       if mouseJoint then mouseJoint:destroy() end
--       squish.body:setType("dynamic")
--       mouseJoint = love.physics.newMouseJoint(squish.body, x, y)
--     end
--   end
  
--   if button == 2 then
--     local cells = objects.player.cells
--     local isdirty = false
--     for i=1, #cells do
--       print(i, cells[i])
--       local dx, dy = cells[i].body:getPosition()
--       if cells[i].shape:testPoint(dx,dy,0,x,y) then
--         cells[i]:kill()
--         isdirty = true
--       end
--     end
--     objects.player.dirty = isdirty
--   end
-- end

-- function editor:mousemoved(mx, my)
--   local x, y = camera:worldCoords(mx, my)
--   if mouseJoint then
--     mouseJoint:setTarget(x, y)
--   end
-- end

-- function editor:mousereleased()
--   print("up") 
--   if mouseJoint then 
--     local body = mouseJoint:getBodies()
--     body:setType("static")
--     mouseJoint:destroy() 
--     if objects.player:attachCell(currentCell) then
--       currentCell = nil
--     else
--       currentCell.body:setPosition(0, 0)
--     end
--   end
--   mouseJoint = nil
-- end
