ItemDragSystem = tiny.processingSystem(class "ItemDragSystem")

function ItemDragSystem:init(mouse)
    self.filter = function (_, e)
      return e.mouseevent
    end
    self.mouse = mouse
end

function ItemDragSystem:process(e, dt)
  if e.mouseevent.mousepressed then
    local mx, my, button = unpack(e.mouseevent.mousepressed)
    if button == 1 then
      e.mouseevent.mousepressed = nil
      e.mouseevent.grabbed = true
      e.body:setType("dynamic")
      if e.name == "Cell" and e.parent then
        e.parent:detachCell(e)
      end
      self.mouse:attach(e.body)
    end
  end
end