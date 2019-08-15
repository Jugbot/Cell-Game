ItemSnapSystem = tiny.processingSystem(class "ItemSnapSystem")

function ItemSnapSystem:init()
  self.filter = function (_, e)
    return e.name == "Mouse" 
  end
end

function ItemSnapSystem:_getCellsNearMouse()
  local x, y = camera:worldCoords(love.mouse.getPosition())
  local cells = {}
  physicsWorld:queryBoundingBox( x, y, x, y, function (fixture)
    newobj = fixture:getUserData()
    if newobj and newobj.name=="Cell" then
      table.insert(cells, newobj)
      return false
    end
    return true
  end)
  return cells
end

function ItemSnapSystem:process(e, dt)
  if e.attached and e.attached.plug then
    local x, y = camera:worldCoords(love.mouse.getPosition())
    local item = e.attached
    local cells = self:_getCellsNearMouse()

    local chosen = false
    local closest = false
    for _, cell in ipairs(cells) do
      for slot, _ in pairs(cell.slots) do
        local x2, y2 = slot:getPosition()
        local dist = vector.dist2(x,y,x2,y2)
        if dist < slot.radius * slot.radius and (closest == false or dist < closest) and slot:canFit(item) then
          chosen = slot 
          closest = dist
        end
      end
    end

    if chosen ~= false then
      item.body:setType("static")
      item.body:setPosition(chosen:getPosition())
    else
      item.body:setType("dynamic")
    end
  end
end