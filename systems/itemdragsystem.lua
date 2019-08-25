ItemDragSystem = tiny.processingSystem(class "ItemDragSystem")

function ItemDragSystem:init(mouse)
    self.filter = function (_, e)
      return e.events and e.events.mousepressed ~= nil
    end
    self.mouse = mouse
end

function ItemDragSystem:process(e, dt)
  if e.events.mousepressed then
    local mx, my, button = unpack(e.events.mousepressed)
    if button == 1 then
      e.events.mousepressed = nil
      e.events.grabbed = true
      e.body:setType("dynamic")
      if e.name == "Cell" and e.parent then
        e.parent:detachCell(e)
      end
      self.mouse:attach(e.body)
    end
  end
end