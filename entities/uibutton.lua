require "entities.uibox"
UIButton = UIBox:extend(class "UIButton")

function UIButton:init(args)
  local args = args or {}
  self.super.init(self, args)
  self.radius = args.radius or 0
  self.colorPressed = args.colorPressed or table.clone(self.color)
  self.isPressed = false
  systemWorld:addEntity(self)
end

function UIButton:drawUI()
  if self.isPressed then
    love.graphics.setColor(unpack(self.colorPressed))
  else
    love.graphics.setColor(unpack(self.color))
  end
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.radius, self.radius)
  for i=1, #self.children do
    self.children[i]:drawUI()
  end
end

function UIButton:mouseUp()
  print("up")
end

function UIButton:mouseDown()
  print("down")
end
