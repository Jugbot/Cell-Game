BuildableSystem = tiny.processingSystem(class "BuildableSystem")

function BuildableSystem:init(player)
  self.filter = tiny.requireAll("grabbed")
  self.player = player
end

function BuildableSystem:process(e, dt)
  if not e.parent and not e.grabbed then
    self.player.organism:attachCell(e)
  end
end