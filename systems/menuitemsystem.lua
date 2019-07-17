MenuItemSystem = tiny.processingSystem(class "MenuItemSystem")

function MenuItemSystem:init()
  self.filter = tiny.requireAll("isitem")
end

function MenuItemSystem:process(e, dt)
  if not e.isitem then 
    e.isitem = nil
    return
  end
  if love.mouse.isDown(1) then
    local mx, my = self.camera:mousePosition()
    if e.fixture:testPoint(mx, my) then
      e.grabbed = false
      e.isitem = nil
    end
  end
end