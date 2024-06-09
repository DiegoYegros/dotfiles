local M = {}

M.servers = {
  'lua_ls',
  'cssls',
  'html',
  'tsserver',
  'jsonls',
  'eslint',
  'gopls',
  'bashls',
  'jdtls',
  'yamlls',
  'dockerls',
}

M.parsers = {
  'lua',
  'markdown',
  'javascript',
  'typescript',
  'tsx',
  'html',
  'css',
  'json',
  'yaml',
  'go',
  'c',
  'bash',
  'java',
  'dockerfile',
}

M.fmtNLint = {
  'prettier',
  'stylua',
}

return M
