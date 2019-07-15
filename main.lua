Camera = require "lib.camera"
Gamestate = require "lib.gamestate"
Vector = require "lib.vector-light"
class = require "lib.30log"
tiny = require "lib.tiny"
require "util"
requiredir "entities"
requiredir "systems"
requiredir "gamestate"


-- defining global worlds here for clarity
physicsWorld = true
systemWorld = true

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(editor)
end

