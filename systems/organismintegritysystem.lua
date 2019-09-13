OrganismIntegritySystem = tiny.processingSystem(class "OrganismIntegritySystem")

function OrganismIntegritySystem:init()
  self.filter = tiny.requireAll("Organism")
end

local function dfs(currentBody, visited)
  if not currentBody or currentBody:isDestroyed() then return end
  local owner = currentBody:getUserData()
  if not owner or not owner.Cell or visited[owner] then return end 
  visited[owner] = true
  local joints = currentBody:getJoints()
  for _, joint in ipairs(joints) do
    if not joint:isDestroyed() then
      local b1, b2 = joint:getBodies()
      dfs(b1, visited)
      dfs(b2, visited)
    end
  end
end

function OrganismIntegritySystem:process(e, dt)
  if e.dirty and e.cellsCount > 0 then
    print("integrity check")
    local cells = e.cells
    local first
    local visited = {}
    if e.core then
      first = e.core.body
    else
      first = next(cells).body
    end
    dfs(first, visited)
    for cell, _ in pairs(cells) do
      if not visited[cell] then
        table.insert(e.events.removecell, cell)
      end
    end
    -- debug
    print(e)
    for cell, _ in pairs(visited) do
      print("\t",cell)
    end
    --
    e.dirty = false
  end
end