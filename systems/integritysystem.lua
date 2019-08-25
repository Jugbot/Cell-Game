IntegritySystem = tiny.processingSystem(class "IntegritySystem")

function IntegritySystem:init()
  self.filter = tiny.requireAll("Organism")
end

local function dfs(currentBody, visited)
    if currentBody:isDestroyed() then return end
    local owner = currentBody:getUserData()
    if visited[owner] then return end 
    visited[owner] = true
    local joints = currentBody:getJoints()
    for j=1, #joints do
        if not joints[j]:isDestroyed() and joints[j]:getUserData() == self then
        local b1, b2 = joints[j]:getBodies()
        dfs(b1, visited)
        dfs(b2, visited)
        end
    end
end

function IntegritySystem:process(e, dt)
    if e.dirty and e.cellsCount > 0 then
        print("integrity check")
        local cells = e.cells
        -- if e.core then 
        --   local currentBody = e.core.body
        --   e.core.visited = true
        --   dfs(currentBody, e.cells)
        -- end
        local first = next(cells).body
        local visited = {}
        dfs(first, visited)
        for cell, _ in pairs(cells) do
        if not visited[cell] then
            e:detachCell(cell)
        end
        end
        e.dirty = false
    end
end