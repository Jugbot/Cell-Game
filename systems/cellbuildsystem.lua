CellBuildSystem = tiny.processingSystem(class "CellBuildSystem")

function CellBuildSystem:init(player)
  self.filter = function (_, e)
    return e.name == "Cell" and e.events and e.events.grabbed ~= nil
  end
  self.player = player
end

function CellBuildSystem:process(e, dt)
  if not e.events.grabbed and not e.parent then
    self.player.organism:attachCell(e)
  end
end