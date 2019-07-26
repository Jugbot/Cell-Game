CellBuildSystem = tiny.processingSystem(class "CellBuildSystem")

function CellBuildSystem:init(player)
  self.filter = function (_, e)
    return e.name == "Cell" and e.mouseevent
  end
  self.player = player
end

function CellBuildSystem:process(e, dt)
  if not e.mouseevent.grabbed and not e.parent then
    self.player.organism:attachCell(e)
  end
end