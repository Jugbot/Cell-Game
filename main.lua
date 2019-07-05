Camera = require "hump.camera"
Gamestate = require "hump.gamestate"
Vector = require "hump.vector-light"
Squish = require "objects/cell"
Organism = require "objects/organism"
editor = require "gamestate/editor"
require "util"

local menu = {}
local game = {}

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

