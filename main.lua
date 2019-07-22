Camera = require "lib.camera"
Gamestate = require "lib.gamestate"
Vector = require "lib.vector-light"
class = require "lib.30log"
tiny = require "lib.tiny"
require "gui.editorgui"
require "util"
requiredir "entities"
requiredir "systems"
requiredir "gamestate"
requiredir "events"

mainFont = love.graphics.newFont("assets/Delicious.ttf", 20)
-- These globals are changed depending on the 
-- gamestate and represents the current worlds.
physicsWorld = true
systemWorld = true

function love.load()
  love.graphics.setFont(mainFont)
  Gamestate.registerEvents()
  Gamestate.switch(editor)
end
