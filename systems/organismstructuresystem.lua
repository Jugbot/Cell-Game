OrganismStructureSystem = tiny.processingSystem(class "OrganismStructureSystem")

function OrganismStructureSystem:init()
  self.filter = function (_, e)
    return e.name == "Organism"
  end
end

function OrganismStructureSystem:onAdd(e)
  e.events.addcell = {} -- array of events
  e.events.removecell = {}
  e.events.additem = {}
  e.events.removeitem = {}
end

function OrganismStructureSystem:process(organism, dt)
  -- ADD CELL
  for i, cell in ipairs(organism.events.addcell) do
    assert(cell:instanceOf(Cell), "tried to attach non-cell to organism!")
    local cells = organism.cells
    local success = false
    if organism.cellsCount == 0 then
      success = true
    else
      for other, _ in pairs(cells) do
        local dist = love.physics.getDistance(other.fixture, cell.fixture)
        local b1, b2 = other.body, cell.body
        if dist < 5 and dist >= 0 and b1 ~= b2 then
          local j = love.physics.newDistanceJoint(b1, b2, b1:getX(), b1:getY(), b2:getX(), b2:getY(), false)
          j:setUserData(organism)
          success = true
        end
      end
    end
    if success then
      organism:_addCell(cell)
    end
    for slot, _ in pairs(cell.slots) do -- propagate additems
      if slot.item then 
        table.insert(organism.events.additem, slot.item) 
      end
    end
  end
  organism.events.addcell = {}

  -- REMOVE CELL
  for i, cell in ipairs(organism.events.removecell) do
    for slot, _ in pairs(cell.slots) do -- propagate removeitems
      if slot.item then 
        table.insert(organism.events.removeitem, slot.item) 
      end
    end
    assert(cell:instanceOf(Cell), "tried to detach non-cell from organism!")
    assert(organism.cells[cell], "Tried to detach unowned cell!")
    for _, j in ipairs(cell.body:getJoints()) do
      if j:getUserData() == cell.parent then j:destroy() end
    end
    cell.parent = nil
    organism:_removeCell(cell)
  end
  organism.events.removecell = {}

  -- ADD ITEM
  for i, item in ipairs(organism.events.additem) do
    if item.name == "Core" then
      organism.core = item.parent.cell
    end
  end
  organism.events.additem = {}

  -- REMOVE ITEM
  for i, item in ipairs(organism.events.removeitem) do
    if item.name == "Core" then
      organism.core = nil
    end
  end
  organism.events.removeitem = {}
end