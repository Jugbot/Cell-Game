
local Widget = require 'lib.luigi.widget'
local Layout = require 'lib.luigi.layout'

local menuLayout = Layout({
    type='panel', id='outside', background={0, 0, 0, 64}, 
    padding=50,
    {
        type = 'panel',
        id='inside',
        outline={ 128, 128, 128, 255},
        margin=1,
        {
            align = 'middle center',
            height = 36,
            size = 16,
            type = 'panel', text = 'Options',
            background={0,0,0, 64} 
        },
        {
            align = 'left middle',
            wrap = true, padding = 24,
            {   flow='x', height='auto',
                {text='this is an option'},
                {type='button', text='option1'}
            },
            {},
            {}
        },
        { 
            flow = 'x',
            height = 'auto',
            type = 'panel',
            {}, -- spacer
            { type = 'button', width = 100, id = 'closeButton', text = 'Close' }
        }
    }
})

menuLayout.outside:onPress(function() menuLayout:hide() end)
menuLayout.inside:onPress(function() return true end) -- stop propagation
menuLayout.closeButton:onPress(function() menuLayout:hide() end)

return menuLayout