vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('VimLeave', {
  desc = "Since there's no way to query the cursor shape, we need an autocommand",
  group = vim.api.nvim_create_augroup('restore-cursor-shape-on-exit', { clear = true }),
  callback = function()
    vim.opt.guicursor = 'a:ver25'
  end,
})
