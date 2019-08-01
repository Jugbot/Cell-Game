    
DrawSlotSystem = tiny.processingSystem(class "DrawSlotSystem")

function DrawSlotSystem:init(mouse)
    self.filter = tiny.requireAll("Slot")
    self.mouse = mouse
end

function DrawSlotSystem:preProcess(dt)
    camera:attach()
end

function DrawSlotSystem:process(e, dt)
  local heldItem = self.mouse.attached
  if heldItem and heldItem.plug and heldItem.plug.type == e.type and heldItem.plug.size <= e.size then
    love.graphics.setColor(unpack(e.color))
    local x, y = e:getPosition()
    local r = e.radius
    love.graphics.circle("fill", x, y, r)
  end
end

function DrawSlotSystem:postProcess(dt)
    camera:detach()
    love.graphics.setColor(255, 255, 255, 255)
end