EditorGUI = class "EditorGUI"

function EditorGUI:init()
  local Layout = require 'lib.luigi.layout'
  local Widget = require 'lib.luigi.widget'
  local layout = Layout(require 'gui.layout.itemlayout' )

  local data = {
    {
      name="Category Uno",
      "Cell 1",
      "Cell 2",
      "Cell 3"
    },
    {
      name="Category Dos",
      "Thing 1"
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
      content:addChild({ type = 'button', width = 90, height = 90, text = v[i]})
    end
    if not layout.contents[1] then
      layout.contents:addChild(content)
    end
  end
  self.layout = layout
  systemWorld:addEntity(self)
end
