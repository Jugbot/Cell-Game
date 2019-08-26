AddItemSystem = tiny.processingSystem(class "AddItemSystem")

function AddItemSystem:init()
  self.filter = function (_, e)
    return e.Item -- and e.events and e.events.grabbed ~= nil
  end
end

function AddItemSystem:process(e, dt) -- TODO
  -- if e.events.mouseup and not e.parent then
  if e.events.dropped then
    local slot = e.events.availableslot
    if slot then
      slot.events.additem = e
      -- slot:attach(e)
    end
    e.events.dropped = false
  end
end