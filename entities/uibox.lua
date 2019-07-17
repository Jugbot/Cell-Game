UIBox = class "UIBox"

-- p: percent size
-- p_offset: offset in percent
-- min: minimum size in pixels
-- max: maximum size in pixels
function UIBox:init(p, p_offset, min, max)
  self.flow = "row"
  self.min, self.max = min, max
  self.percent, self.percent_offset = p or 1, p_offset or 0
  self.x, self.y, self.width, self.height = 0,0,love.graphics.getWidth(),love.graphics.getHeight()
  self.color = {0,0,0,0.1}
  self.parent = nil
  self.children = {}
  systemWorld:addEntity(self)
end

function UIBox:setParent(parent)
  self.parent = parent
end

function UIBox:setChildren(flow, ...)
  self.flow = flow
  local children = {...}
  for i=1, #children do
    children[i].parent = self
  end
  self.children = children
  return self
end

function UIBox:refresh()
  self:setChildren(self.flow, unpack(self.children))
  local children = self.children
  for i=1, #children do
    local child = children[i]
    if self.flow == "column" then
      child.x = self.x 
      child.width = self.width
      child.y = self.y + self.height * child.percent_offset
      child.height = self.height * child.percent
    else -- == "row"
      child.x = self.x + self.width * child.percent_offset
      child.width = self.width * child.percent
      child.y = self.y 
      child.height = self.height
      -- local diff = 0
      -- if child.min ~= nil and child.min > child.width then 
      --   diff = child.min - child.width
      --   child.width = child.min
      -- end
      -- if child.max ~= nil and child.max < child.width then
      --   diff = child.max - child.width
      --   child.width = child.max
      -- end
      -- child.x = child.x + diff/2-- * ((child.x - self.x) / (self.width - child.width))
    end
    self.children[i]:refresh()
  end
end

function UIBox:drawUI()
  if self.color then
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.radius, self.radius)
  end
  for i=1, #self.children do
    self.children[i]:drawUI()
  end
end
