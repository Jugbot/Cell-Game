editor = {}
local mouse
local editorPhysicsWorld
local editorSystemWorld
local editorGUI
local editorEvents

function editor:init()
  editorPhysicsWorld = love.physics.newWorld(0, 0, false)
  editorSystemWorld = tiny.world(DrawSystem(camera), IntegritySystem(), MouseJointSystem(), ItemDropSystem(), ItemSnapSystem())
  physicsWorld = editorPhysicsWorld
  systemWorld = editorSystemWorld
  editorGUI = EditorGUI()
  editorGUI.itemPressCallback = function (id) self:itemselect(id) end
  -- editorEvents = EditorEventHandler(editor, camera, editorGUI)
  -- Temporary things to play with
  local organism = Organism()
  local player = Player(organism)
  local cell = Cell(0, 0, 2)
  cell.body:setType("static")
  systemWorld:addSystem(CellBuildSystem(player))
  mouse = Mouse()
  systemWorld:addSystem(ItemDragSystem(mouse))
  systemWorld:addSystem(DrawSlotSystem(mouse))
end

function editor:enter()
  camera:lookAt(0, 0)
  physicsWorld = editorPhysicsWorld
  systemWorld = editorSystemWorld
  love.graphics.setBackgroundColor(220/256.0, 226/256.0, 200/256.0)
  editorGUI.layout:show()
end

function editor:update(dt)
  physicsWorld:update(dt)
  systemWorld:update(dt, tiny.rejectAny("DrawSystem", "DrawSlotSystem"))
end

function editor:draw()
  systemWorld:update(0, tiny.requireAny("DrawSystem", "DrawSlotSystem"))
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function getObjUnderMouse(mx, my)
  local x, y = camera:worldCoords(mx, my)
  local obj, index
  physicsWorld:queryBoundingBox( x, y, x, y, function (fixture)
    newobj = fixture:getUserData()
    if newobj and fixture:testPoint(x,y) then
      if (newobj.drawLayer == nil or index == nil or index < newobj.drawLayer) and newobj.mouseevent then 
        obj = newobj
        index = obj.drawLayer
      end
    end
    return true
  end)
  return obj
end

function editor:mousepressed(mx, my, ...)
  local obj = getObjUnderMouse(mx, my)
  if obj then
    obj.mouseevent.mousepressed = {mx, my, ...}
  end
end

function editor:mousereleased(mx, my, ...)
  local obj = getObjUnderMouse(mx, my)
  if obj then
    obj.mouseevent.mousereleased = {mx, my, ...}
  end
end

function editor:itemselect(id)
  print(id)
  local x, y = camera:worldCoords(love.mouse.getPosition())
  if id == "small_cell" then
    local cell = Cell(x, y, 0)
    cell.mouseevent.mousepressed = {x, y, 1}
    cell.body:setType("static")
  elseif id == "medium_cell" then
    local cell = Cell(x, y, 1)
    cell.mouseevent.mousepressed = {x, y, 1}
    cell.body:setType("static")
  elseif id == "large_cell" then
    local cell = Cell(x, y, 2)
    cell.mouseevent.mousepressed = {x, y, 1}
    cell.body:setType("static")
  elseif id == "core" then
    local core = Core(x, y)
    core.mouseevent.mousepressed = {x, y, 1}
    core.body:setType("static")
  end
end
