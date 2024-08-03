return {
  -- A blazing fast and easy to configure Neovim statusline written in Lua.
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = { theme = 'codedark' },
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      {},
    }
  end,
}
