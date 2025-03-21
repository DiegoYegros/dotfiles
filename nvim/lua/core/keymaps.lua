keymap = vim.keymap.set

keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
keymap({ 'n', 'v' }, '<C-c>', '"+y', { desc = 'Copy to system clipboard' })
keymap('v', '<C-c>', '"+y<Esc>', { desc = 'Copy to system clipboard and exit visual mode' })
keymap({ 'n', 'v' }, '<C-v>', '"+p', { desc = 'Paste from system clipboard' })
