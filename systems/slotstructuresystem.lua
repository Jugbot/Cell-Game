SlotStructureSystem = tiny.processingSystem(class "SlotStructureSystem")

function SlotStructureSystem:init()
  self.filter = function (_, e)
    return e.name == "Slot"
  end
end

function SlotStructureSystem:process(slot, dt)
  -- ADD ITEM
  local item = slot.events.additem
  if item then
    assert(slot:canAttach(item), "Tried to fit invalid item to slot")
    if slot.joint then return end
    local x, y = slot:getPosition()
    slot.joint = love.physics.newWeldJoint(slot.cell.body, item.body, 0,0, false)
    slot.joint:setUserData(slot)
    slot.item = item
    item.body:setType("dynamic")
    item.parent = slot
  end
  slot.events.additem = false
  -- REMOVE ITEM
  if slot.events.removeitem then
    slot.joint:destroy()
    slot.joint = nil
    for _, j in ipairs(slot.item.body:getJoints()) do
      if j:getUserData() == slot.item.parent then j:destroy() end
    end
    slot.item.parent = nil
    slot.item = nil
  end
  slot.events.removeitem = false
end