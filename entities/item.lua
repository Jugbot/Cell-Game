Item = class "Item"
Item:with(MouseComponent)

function Item:init(size, type)
  self.plug = {size=size, type=type}
  self.parent = nil
end

-- Removes joints owned by parent (ie: slot-item joints)
function Item:_detachParent()
  for _, j in ipairs(self.body:getJoints()) do
    if j:getUserData() == self.parent then j:destroy() end
  end
  self.parent = nil
end