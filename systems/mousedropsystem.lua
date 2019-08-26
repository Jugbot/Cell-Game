MouseDropSystem = tiny.processingSystem(class "MouseDropSystem")

function MouseDropSystem:init()
  self.filter = function (_, e)
    return e.name == "Mouse" 
  end
end

function MouseDropSystem:process(e, dt)
  if e.attached then
    if not love.mouse.isDown(1) then
      e.attached.body:setType("static")
      e:detach()
    end
  end
end