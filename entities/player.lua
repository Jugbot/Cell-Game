Player = class "Player"

function Player:init(organism, controller)
  self.organism = organism
  self.controller = controller
  systemWorld:addEntity(self)
end
