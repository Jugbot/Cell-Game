Item = class "Item"

function Item:init(size, type)
  self.plug = {size=size, type=type}
  self.parent = nil
  -- subscribe to systems which require these events
  self.events = { mousepressed=false, grabbed=false }
end

-- Removes joints owned by parent (ie: slot-item joints)
function Item:_detachParent()
  for _, j in ipairs(self.body:getJoints()) do
    if j:getUserData() == self.parent then j:destroy() end
  end
  self.parent = nil
end