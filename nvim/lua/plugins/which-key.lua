return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    require('which-key').setup()
    local wk = require 'which-key'
    -- Register key mappings with the new spec
    wk.add {
      { '<leader>c', group = '[C]ode', nowait = true, remap = false },
      { '<leader>d', group = '[D]ocument', nowait = true, remap = false },
      { '<leader>r', group = '[R]ename', nowait = true, remap = false },
      { '<leader>s', group = '[S]earch', nowait = true, remap = false },
      { '<leader>w', group = '[W]orkspace', nowait = true, remap = false },
    }
  end,
}
