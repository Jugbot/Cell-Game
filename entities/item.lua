Item = class "Item"

function Item:init(size, type)
  self.plug = {size=size, type=type}
  self.parent = nil
  -- subscribe to systems which require these events
  self.events = { mousepressed=false, grabbed=false }
end