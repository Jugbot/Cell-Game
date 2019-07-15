Player = class "Player"

function Player:init(organism)
  self.organism = organism
  systemWorld:addEntity(self)
end
