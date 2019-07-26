AttachSystem = tiny.processingSystem(class "AttachSystem")

function AttachSystem:init()
  self.filter = tiny.requireAll("grabbed", "slot")
  self.snapDistance = 10
end

function AttachSystem:process(e, dt)
  if e.grabbed then
    local x, y = e.body:getPosition()
    local d = self.snapDistance
    physicsWorld:queryBoundingBox(x-d, y-d, x+d, y+d, function(fixture)
      
    end)
  end
end