editor = {}
local camera = Camera(70, 30)
local editorPhysicsWorld = love.physics.newWorld(0, 0, false)
local editorSystemWorld = tiny.world(
  DrawSystem(camera), UpdateSystem())
local editorGUI
local editorEvents

function editor:init()
  physicsWorld = editorPhysicsWorld
  systemWorld = editorSystemWorld
  editorGUI = EditorGUI()
  editorEvents = EditorEventHandler(editor, camera, editorGUI)
end

function editor:enter()
  camera:lookAt(0, 0)
  physicsWorld = editorPhysicsWorld
  systemWorld = editorSystemWorld
  love.graphics.setBackgroundColor(220/256.0, 226/256.0, 200/256.0)
  editorGUI.layout:show()
  -- Temporary things to play with
  local organism = Organism()
  local player = Player(organism)
  local cell = Cell(0, 0, 2)
  cell.body:setType("static")
  systemWorld:addSystem(BuildableSystem(player))
end

function editor:update(dt)
  physicsWorld:update(dt)
  systemWorld:update(dt, tiny.rejectAny("drawSystem"))
end

function editor:draw()
  systemWorld:update(0, tiny.requireAny("drawSystem"))
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end
