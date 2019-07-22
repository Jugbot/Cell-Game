EditorEventHandler = class "EditorEventHandler"

function EditorEventHandler:init(gamestate, camera)
    self.mouseJoint = nil
    self.camera = camera
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
        return false
      else 
        return true
      end
    end)
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
