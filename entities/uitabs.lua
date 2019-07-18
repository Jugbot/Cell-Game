require "entities.uibox"
require "entities.uibutton"
require "entities.uitext"
UITabs = UIBox:extend(class "UITabs")

function UITabs:init(args)
  local args = args or {}
  self.super.init(self, args)
  self.flow = "column"
  self.tabHeight = args.tabHeight
  self.activeTab = 1
  systemWorld:addEntity(self)
end

function UITabs:setChildren(flow, args)
  local header = UIBox({min=self.tabHeight, max=self.tabHeight, size=1/5})
  local content = UIBox({offset=1/5, size=4/5})
  local children = {header, content}
  local labels = {}
  local contents = {}         
  for k, v in pairs(args) do
    table.insert(labels, UIButton():setChildren("row", UIText({text=k})))
    table.insert(contents, UIBox():setChildren("row", v))
  end
  for i=1, #labels do
    labels[i].size = 1/#labels
  end
  header:setChildren("row", unpack(labels))
  content:setChildren("row", unpack(contents))
  return self.super.setChildren(self, flow, unpack(children))
end
