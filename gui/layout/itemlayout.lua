local Layout = require 'lib.luigi.layout'

return Layout({ id='main',
  { type='panel', height='auto', flow='x',
    { type='button', id='menu', text='=', width='50', height='50'},
    { type='button', id='save', text='Save', width='150', height=50}
  },
  { }, -- Fill empty space above 
  { type = 'panel', height = 'auto',
    { flow = 'x', id='categories', height='auto'

    },
    { id='contents', height='auto'

    }
  }
})