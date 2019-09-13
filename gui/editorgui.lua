EditorGUI = class "EditorGUI"

function EditorGUI:init()
  local Layout = require 'lib.luigi.layout'
  local Widget = require 'lib.luigi.widget'
  local layout = require 'gui.layout.itemlayout'
  local menu = require 'gui.layout.menulayout'
  layout:setTheme(require "lib.luigi.theme.dark")
  menu:setMaster(layout)
  self.itemPressCallback = function()end

  local data = {
    {
      name="Essentials",
      "Core",
      "Small Cell",
      "Medium Cell",
      "Large Cell"
    },
    {
      name="Offense",
      "Small Turret"
    },
    {
      name="Defense"
    },
    {
      name="Utility"
    }
  }

  for _, v in ipairs(data) do
    local button = layout.categories:addChild({ type = 'button', text = v.name })
    local content = Widget(layout, { flow = 'x', height = 'auto'})
    button:onPress(function (e)
      layout.contents[1] = nil
      layout.contents:addChild(content)
    end)
    for i=1, #v do
      local spawntype = content:addChild({ type = 'button', width = 90, height = 90, text = v[i]})
      local idname = v[i]:gsub("%s+", "_"):lower()
      spawntype:onPressStart(function (e)
        self.itemPressCallback(idname)
      end)
    end
    if not layout.contents[1] then
      layout.contents:addChild(content)
    end
  end
  layout.menu:onPress(function (e)
    menu:show()
  end)
  self.layout = layout
  systemWorld:addEntity(self)
end
