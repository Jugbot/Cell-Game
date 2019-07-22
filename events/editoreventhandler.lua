EditorEventHandler = class "EditorEventHandler"

function EditorEventHandler:init(gamestate, camera, gui)
    self.mouseJoint = nil
    self.camera = camera
    self.gui = gui
    -- hook into gamestate io callbacks
    self.gamestate = {}
    self.gamestate.mousepressed = gamestate.mousepressed or function () end
    gamestate.mousepressed = function (gs, ...) 
        self:mousepressed(...) 
        self.gamestate.mousepressed(gs, ...)
    end
    self.gamestate.mousemoved = gamestate.mousemoved or function () end
    gamestate.mousemoved = function (gs, ...) 
        self:mousemoved(...) 
        self.gamestate.mousemoved(gs, ...)
    end
    self.gamestate.mousereleased = gamestate.mousereleased or function () end
    gamestate.mousereleased = function (gs, ...) 
        self:mousereleased(...) 
        self.gamestate.mousereleased(gs, ...)
    end
end

function EditorEventHandler:mousepressed(mx,my,button) 
  local x, y = self.camera:worldCoords(mx, my)
  
  if button == 1 then
    local grabbedSomething = false
    physicsWorld:queryBoundingBox( x, y, x, y, function (fixture)
      local obj = fixture:getUserData()
      if obj and obj.grabbed == false and fixture:testPoint(x,y) then
        if self.mouseJoint then self.mouseJoint:destroy() end
        obj.grabbed = true
        obj.body:setType("dynamic")
        if obj.parent then
          obj.parent:detachCell(obj)
        end
        self.mouseJoint = love.physics.newMouseJoint(obj.body, x, y)
        grabbedSomething = true
        return false
      else 
        return true
      end
    end)
    if not grabbedSomething then
      local selectedComponent = self.gui.selected
      print(selectedComponent)
      if selectedComponent == "small_cell" then
        local cell = Cell(x, y, 0)
        cell.body:setType("static")
      elseif selectedComponent == "medium_cell" then
        local cell = Cell(x, y, 1)
        cell.body:setType("static")
      elseif selectedComponent == "large_cell" then
        local cell = Cell(x, y, 2)
        cell.body:setType("static")
      end
    end
  end
end

function EditorEventHandler:mousemoved(mx, my)
  local x, y = self.camera:worldCoords(mx, my)
  if self.mouseJoint then
    self.mouseJoint:setTarget(x, y)
  end
end

function EditorEventHandler:mousereleased(mx,my,button)
  if self.mouseJoint then 
    local body = self.mouseJoint:getBodies()
    body:getUserData().grabbed = false
    body:setType("static")
    self.mouseJoint:destroy() 
  end
  self.mouseJoint = nil
end
