UIEventSystem = tiny.processingSystem(class "UIEventSystem")

function UIEventSystem:init()
    self.filter = tiny.requireAll("isPressed")
    self.lastState = false
    self.isDown = love.mouse.isDown
    self.getPosition = love.mouse.getPosition
end

function UIEventSystem:preWrap()
    self.isDown = love.mouse.isDown(1)
    self.mx, self.my = love.mouse.getPosition()
end

function UIEventSystem:testPoint(e)
    return (e.x < self.mx and self.mx < e.x + e.width) and
        (e.y < self.my and self.my < e.y + e.height)
end

function UIEventSystem:process(e, dt)
    if self.isDown and not self.lastState then
        self.lastState = true
        if not e.isPressed and self:testPoint(e) then
            e.isPressed = true
            if e.mouseDown ~= nil then
                e:mouseDown()
            end
        end
    end
    if not self.isDown and self.lastState then
        self.lastState = false
        if e.isPressed and self:testPoint(e) then
            e.isPressed = false
            if e.mouseUp ~= nil then
                e:mouseUp()
            end
        end
    end
    if e.isPressed and not self:testPoint(e) then
        e.isPressed = false
    end
end

