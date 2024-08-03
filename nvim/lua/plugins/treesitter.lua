return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    ensure_installed = 'bash',
    'c',
    'html',
    'go',
    'lua',
    'markdown',
    'rust',
    'vim',
    'markdown',
    'java',
    'sql',
    'zsh',
    'vimdoc',
    'json',
    'yaml',
    'markdown_inline',
    'dockerfile',
    'gitignore',
    'css',
    'tsx',
    'javascript',
    'typescript',
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
  config = function(_, opts)
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)
  end,
}
