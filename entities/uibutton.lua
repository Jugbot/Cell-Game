require "entities.uibox"
UIButton = UIBox:extend(class "UIButton")

function UIButton:init(...)
  self.super:init(...)
  self.radius = 0
  self.color = {101/256, 222/256, 241/256, 0.5}
  self.colorPressed = {101/256, 222/256, 241/256, 1}
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
end

function UIButton:mouseUp()
  print("up")
end

function UIButton:mouseDown()
  print("down")
end
