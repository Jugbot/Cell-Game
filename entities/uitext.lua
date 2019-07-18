require "entities.uibox"
UIText = UIBox:extend(class "UIText")

function UIText:init(args)
  local args = args or {}
  self.super.init(self, args)
  self.text = args.text or ""
  self.align = args.align or "center"
  systemWorld:addEntity(self)
end

function UIText:drawUI()
  love.graphics.setColor(unpack(self.color))
  love.graphics.printf( self.text, math.floor(self.x), math.floor(self.y), self.width, self.align)--, r, sx, sy, ox, oy, kx, ky )
end
