UpdateSystem = tiny.processingSystem(class "UpdateSystem")

function UpdateSystem:init()
    self.filter = tiny.requireAll("update")
end

function UpdateSystem:process(e, dt)
    e:update(dt)
end