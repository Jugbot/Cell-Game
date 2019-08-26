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
  editorSystems.mouseJointSystem = MouseJointSystem()
  editorSystems.mouseDragSystem = MouseDragSystem(mouse)
  editorSystems.mouseDropSystem = MouseDropSystem()
  editorSystems.itemSnapSystem = ItemSnapSystem()
  editorSystems.organismIntegritySystem = OrganismIntegritySystem()
  editorSystems.addCellSystem = AddCellSystem(player)
  editorSystems.addItemSystem = AddItemSystem()
  editorSystems.drawSystem = DrawSystem(camera)
  editorSystems.drawSlotSystem = DrawSlotSystem(mouse)
  editorSystems.organismStructureSystem = OrganismStructureSystem()
  editorSystems.slotStructureSystem = SlotStructureSystem()
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
  systemWorld:update(dt, tiny.rejectAll('DrawSystem'))
end

function editor:draw()
  camera:attach()
  systemWorld:update(dt, tiny.requireAll('DrawSystem'))
  camera:detach()
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end
 
function getObjUnderMouse(mx, my)
  local x, y = camera:worldCoords(mx, my)
  local obj, index
  physicsWorld:queryBoundingBox( x, y, x, y, function (fixture)
    newobj = fixture:getUserData()
    if newobj and fixture:testPoint(x,y) then
      -- if newobj.Item then return newobj end -- removeme
      if (newobj.drawLayer == nil or index == nil or index < newobj.drawLayer) and newobj.events then 
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
    obj.events.mousepressed = {mx, my, ...}
  end
end

function editor:mousereleased(mx, my, ...)
  local obj = getObjUnderMouse(mx, my)
  if obj then
    obj.events.mousereleased = {mx, my, ...}
  end
end

function editor:itemselect(id)
  print(id)
  local x, y = camera:worldCoords(love.mouse.getPosition())
  if id == "small_cell" then
    local cell = Cell(x, y, 0)
    cell.events.mousepressed = {x, y, 1}
  elseif id == "medium_cell" then
    local cell = Cell(x, y, 1)
    cell.events.mousepressed = {x, y, 1}
  elseif id == "large_cell" then
    local cell = Cell(x, y, 2)
    cell.events.mousepressed = {x, y, 1}
  elseif id == "core" then
    local core = Core(x, y)
    core.events.mousepressed = {x, y, 1}
  end
end
