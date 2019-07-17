AttachSystem = tiny.processingSystem(class "AttachSystem")

function AttachSystem:init()
  self.filter = tiny.requireAll("grabbed", "attach")
end

function AttachSystem:process(e, dt)
  if not grabbed then
    e:attach()
  end
end