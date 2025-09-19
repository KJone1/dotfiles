local M = {}

M.general = {
  n = { -- Normal mode mappings
    { '[d', vim.diagnostic.goto_prev, desc = 'Go to previous diagnostic message' },
    { ']d', vim.diagnostic.goto_next, desc = 'Go to next diagnostic message' },
    { '<leader>e', ':Neotree toggle reveal_force_cwd<CR>', desc = 'Explore Files in current dir' },
    {
      '<leader>j',
      function()
        require('snipe').open_buffer_menu()
      end,
      desc = 'Open Snipe buffer menu',
    },
    { '<F1>', '<ESC>', desc = 'Remap F1 as escape' },
  },
  i = { -- Insert mode mappings
    { '<F1>', '<ESC>', desc = 'Remap F1 as escape' },
  },
  v = { -- Visual mode mappings
  },
}

local c = require 'cinnamon'
M.scroll = {
  n = {
    {
      '<C-k>',
      function()
        c.scroll '10kzz'
      end,
      desc = 'Remap Ctrl-u',
    },
    {
      '<C-j>',
      function()
        c.scroll '10jzz'
      end,
      desc = 'Remap Ctrl-d',
    },
  },
  i = {},
  v = {
    {
      '<C-k>',
      function()
        c.scroll '10kzz'
      end,
      desc = 'Remap Ctrl-u',
    },
    {
      '<C-j>',
      function()
        c.scroll '10jzz'
      end,
      desc = 'Remap Ctrl-d',
    },
  },
}

M.git = {
  n = {
    { '<leader>l', ':LazyGit<cr>', desc = 'Open LazyGit', icon = { icon = '󰊢 ' } },
  },
}

M.ssr = {
  n = {
    {
      '<leader>sl',
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

M.lsp = {
  n = {
    { '<F2>', vim.lsp.buf.rename, desc = 'Refactor Rename' },
  },
}

M.telescope = {
  n = {
    { '<leader>t', ':TodoFzfLua keywords=TODO,FIX<CR>', desc = 'List TODOs' },
    { '<leader>fg', ':FzfLua live_grep_native resume=true<CR>', desc = 'Live grep Project', icon = { icon = ' ' } },
    { '<leader>ff', ':FzfLua lgrep_curbuf resume=true<CR>', desc = 'Live grep current buffer', icon = { icon = ' ' } },
    { '<leader>fw', ':FzfLua git_status<CR>', desc = 'Search modified files', icon = { icon = ' ' } },
    { '<leader>fr', ':FzfLua oldfiles<CR>', desc = 'Search file history', icon = { icon = ' ' } },
    { '<leader><space>', ':FzfLua files<CR>', desc = 'Search files in project' },
    { ';', ':FzfLua commands<CR>', desc = 'Open commands list using fzf' },
    { '<leader>cs', ':FzfLua colorschemes<CR>', desc = 'Explore colorschemes' },
  },
}
return M
