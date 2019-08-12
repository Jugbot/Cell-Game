editor = {}
local editorPhysicsWorld
local editorSystemWorld
local editorGUI
local editorSystems = {}

function editor:init()
  editorPhysicsWorld = love.physics.newWorld(0, 0, false)
  editorSystemWorld = tiny.world()
  physicsWorld = editorPhysicsWorld
  systemWorld = editorSystemWorld
  editorGUI = EditorGUI()
  editorGUI.itemPressCallback = function (id) self:itemselect(id) end
  -- priviliged objects
  local mouse = Mouse()
  local player = Player(Organism())
  -- systems (game logic)
  editorSystems.drawSystem = DrawSystem(camera)
  editorSystems.integritySystem = IntegritySystem()
  editorSystems.mouseJointSystem = MouseJointSystem()
  editorSystems.itemDropSystem = ItemDropSystem()
  editorSystems.itemSnapSystem = ItemSnapSystem()
  editorSystems.cellBuildSystem = CellBuildSystem(player)
  editorSystems.itemDragSystem = ItemDragSystem(mouse)
  editorSystems.drawSlotSystem = DrawSlotSystem(mouse)
  -- add all the systems
  for _, system in pairs(editorSystems) do
    systemWorld:addSystem(system)
  end
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
  systemWorld:update(dt)
end

function editor:draw()
  editorSystems.drawSystem:update()
  editorSystems.drawSlotSystem:update()
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
