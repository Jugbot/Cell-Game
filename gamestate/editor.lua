editor = {}
local camera = Camera(70, 30)
local editorPhysicsWorld = love.physics.newWorld(0, 0, false)
local editorSystemWorld = tiny.world(
  DrawSystem(camera), UpdateSystem(), MouseDragSystem(camera), UIEventSystem())
local editorMenu = true

function editor:init()
  physicsWorld = editorPhysicsWorld
  systemWorld = editorSystemWorld
  editorMenu = UIBox():setChildren("column",
    UIBox({size=1/5}),
    UIBox({size=1/5, offset=4/5, max=200}):setChildren("column",
      UIBox({size=1/5}):setChildren("row",
        UIButton({size=1})
      )
    )
  )
  editorMenu:refresh()
end

function editor:enter()
  camera:lookAt(0, 0)
  physicsWorld = editorPhysicsWorld
  systemWorld = editorSystemWorld
  love.graphics.setBackgroundColor(220/256.0, 226/256.0, 200/256.0)
  -- Temporary things to play with
  local organism = Organism()
  local cell = Cell(0, 0, 2)
  cell.body:setType("static")
  cell.parent = organism
  organism:attachCell(Cell(0, 0, 1))
  table.insert(organism.cells, cell)
  local player = Player(organism)
  Cell(0, 0, 0)
end

function love.resize(w, h)
  editorMenu.width, editorMenu.height = w, h
  editorMenu:refresh()
end

function editor:update(dt)
  physicsWorld:update(dt)
  systemWorld:update(dt, tiny.rejectAny("drawSystem"))
end

function editor:draw()
  systemWorld:update(0, tiny.requireAny("drawSystem"))
  editorMenu:drawUI()
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end
