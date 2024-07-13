local M = {}

M.general = {
  n = { -- Normal mode mappings
    { '[d', vim.diagnostic.goto_prev, desc = 'Go to previous diagnostic message' },
    { ']d', vim.diagnostic.goto_next, desc = 'Go to next diagnostic message' },
    { '<F1>', '<ESC>', desc = 'Remap F1 as escape' },
    {
      '<C-k>',
      function()
        require('cinnamon').scroll '<C-u>zz'
      end,
      desc = 'Remap Ctrl-u',
    },
    {
      '<C-j>',
      function()
        require('cinnamon').scroll '<C-d>zz'
      end,
      desc = 'Remap Ctrl-d',
    },
  },
  i = { -- Insert mode mappings
    { '<F1>', '<ESC>', desc = 'Remap F1 as escape' },
  },
  v = { -- Visual mode mappings
    {
      'xa',
      function()
        require('align').align_to_char { length = 1 }
      end,
      desc = 'Align to char',
    },
    {
      '<C-k>',
      function()
        require('cinnamon').scroll '<C-u>zz'
      end,
      desc = 'Remap Ctrl-u',
    },
    {
      '<C-j>',
      function()
        require('cinnamon').scroll '<C-d>zz'
      end,
      desc = 'Remap Ctrl-d',
    },
  },
}

M.git = {
  n = {
    { '<leader>l', ':LazyGit<cr>', desc = 'Open LazyGit' },
  },
}

M.harpoon = {
  n = {
    { '<leader>h', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', desc = 'Browse harpooned files' },
    { 'ha', ':lua require("harpoon.mark").add_file()<CR>', desc = 'Harpoon file' },
    { 'hn', ':lua require("harpoon.ui").nav_next()<CR>', desc = 'Navigate to next harpooned file' },
    { 'hb', ':lua require("harpoon.ui").nav_prev()<CR>', desc = 'Navigate to previous harpooned file' },
  },
}

M.ssr = {
  n = {
    { '<leader>sr', ':Spectre<CR>', desc = 'Search and Replace (Spectre)' },
    {
      '<leader>ss',
      function()
        require('custom').ssr_line()
      end,
      desc = 'Search and Replace in line',
    },
    {
      '<leader>sa',
      function()
        require('custom').ssr_buffer()
      end,
      desc = 'Search and Replace in current buffer',
    },
  },
}

M.text = {
  n = {
    { '<A-DOWN>', ':m .+1<CR>==', desc = 'Move one line down' },
    { '<A-UP>', ':m .-2<CR>==', desc = 'Move one line up' },
    { '<S-A-DOWN>', ':t.<CR>', desc = 'Duplicate line' },
    { '<leader>/', '<Cmd>lua require("Comment.api").toggle.linewise.current()<CR>', desc = 'Comment linewise' },
    { '<leader>md', ':MarkdownPreview<CR>', desc = 'Open Markdown Preview' },
  },
  v = {
    { '<A-UP>', ":m '<-2<CR>gv=gv", desc = 'Move selected lines up' },
    { '<A-DOWN>', ":m '>+1<CR>gv=gv", desc = 'Move selected lines down' },
    { '<leader>/', '<ESC><Cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', desc = 'Comment linewise selected text' },
    { '<S-A-DOWN>', ":t'>\\<CR>gv=gv", desc = 'Duplicate line' },
    { '<Tab>', '>gv', desc = 'Indent' },
    { '<S-Tab>', '<gv', desc = 'Outdent' },
  },
  i = {
    { '<A-DOWN>', '<C-o>:m .+1<CR>', desc = 'Move one line down' },
    { '<A-UP>', '<C-o>:m .-2<CR>', desc = 'Move one line up' },
    { '<C-s>', '<C-o>:w<CR>', desc = 'Save' },
    { '<C-v>', '<C-R>+', desc = 'paste' },
    { '<C-x>', '<C-o>dd', desc = 'Cut' },
    { '<C-y>', '<C-o>:redo<CR>', desc = 'Redo' },
    { '<C-z>', '<C-o>u', desc = 'Undo' },
    { '<S-A-DOWN>', '<C-o>:t.<CR><C-o>==', desc = 'Duplicate line' },
    { '<S-Tab>', '<C-d>', desc = 'Outdent line' },
    { '<Tab>', '<C-t>', desc = 'Indent line' },
  },
}

M.telescope = {
  n = {
    { '<leader>p', ':CdProject<CR>', desc = 'Open Saved Projects' },
    { '<leader>t', ':TodoTelescope keywords=TODO,FIX<CR>', desc = 'List TODOs' },
    { '<leader>e', ':Neotree<CR>', desc = 'Explore Files in current dir' },
    { '<leader>g', ':Telescope live_grep theme=ivy layout_config={height=0.55,width=0.8}<CR>', desc = 'live grep' },
    { '<leader>sd', require('telescope.builtin').diagnostics, desc = '[S]earch [D]iagnostics' },
    { '<leader>so', require('telescope.builtin').oldfiles, desc = 'Find recently opened files' },
    { '<leader>f', ':Telescope current_buffer_fuzzy_find theme=ivy layout_config={height=0.55}<CR>', desc = '[/] Fuzzily search in current buffer' },
    {
      '<leader>cs',
      function()
        vim.api.nvim_exec_autocmds('User', { pattern = 'ColorSchemeLoad' })
        require('telescope.builtin').colorscheme()
      end,
      desc = 'Explore colorschemes',
    },
  },
}
return M
