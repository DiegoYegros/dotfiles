return {
  'xiyaowong/transparent.nvim',
  config = function()
    require('transparent').setup { -- Optional, you don't have to run setup.
      groups = { -- table: default groups
        'Normal',
        'NormalNC',
        'Comment',
        'Constant',
        'Special',
        'Identifier',
        'Statement',
        'PreProc',
        'Type',
        'Underlined',
        'Todo',
        'String',
        'Function',
        'Conditional',
        'Repeat',
        'Operator',
        'Structure',
        'LineNr',
        'NonText',
        'SignColumn',
        'CursorLine',
        'CursorLineNr',
        'StatusLine',
        'StatusLineNC',
        'EndOfBuffer',
      },
      extra_groups = {
        'NormalFloat', -- plugins which have float panel such as Lazy, Mason, LspInfo
        'FloatBorder',
        'LspInfoBorder',
        'LspInfoNormal',
        'LspInfoTitle',
        'DiagnosticFloatingError',
        'DiagnosticFloatingWarn',
        'DiagnosticFloatingInfo',
        'DiagnosticFloatingHint',
        'DiagnosticVirtualTextInfo',
        'DiagnosticVirtualTextHint',
        'DiagnosticVirtualTextOk',
        'DiagnosticVirtualTextError',
        'DiagnosticVirtualTextWarn',
        'LspReferenceText',
        'LspReferenceRead',
        'LspReferenceWrite',

        -- Completion Menu
        'Pmenu',
        'PmenuSel',
        'PmenuSbar',
        'PmenuThumb',

        -- Telescope
        'TelescopeSelection',
        'TelescopeNormal',
        'TelescopeBorder',
        'TelescopePromptNormal',
        'TelescopeResultsNormal',
        'TelescopePreviewNormal',

        -- Fidget (LSP progress)
        'FidgetTask',
        'FidgetTitle',

        --Nvim Tree
        'NvimTreeNormal',

        'FidgetTask',
        'FidgetTitle',
        -- Misc
        'VertSplit',
        'SignColumn',
        'LineNr',
        'CursorLine',
        'CursorLineNr',
        'NvimTreeNormal',
        'WhichKeyFloat',
        'kickstart-lsp-attach',
        'LspInlayHint',
      }, -- table: additional groups that should be cleared
      exclude_groups = {}, -- table: groups you don't want to clear
    }
  end,
}
