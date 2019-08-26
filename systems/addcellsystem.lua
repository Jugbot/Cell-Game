AddCellSystem = tiny.processingSystem(class "AddCellSystem")

function AddCellSystem:init(player)
  self.filter = function (_, e)
    return e.name == "Cell" -- and e.events and e.events.grabbed ~= nil
  end
  self.player = player
end

function AddCellSystem:process(e, dt)
  if not e.events.grabbed and not e.parent then
    self.player.organism:attachCell(e)
  end
end