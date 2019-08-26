MouseDragSystem = tiny.processingSystem(class "MouseDragSystem")

function MouseDragSystem:init(mouse)
    self.filter = function (_, e)
      return e.events and e.events.mousepressed ~= nil
    end
    self.mouse = mouse
end

function MouseDragSystem:process(e, dt)
  if e.events.mousepressed then
    local mx, my, button = unpack(e.events.mousepressed)
    if button == 1 then
      e.events.mousepressed = false
      e.body:setType("dynamic")
      if e.name == "Cell" and e.parent then
        table.insert(e.parent.events.removecell, e)
      end
      self.mouse:attach(e.body)
    end
  end
end