local M = {}

M.general = {
  n = { -- Normal mode mappings
    ['[d'] = { vim.diagnostic.goto_prev, 'Go to previous diagnostic message' },
    [']d'] = { vim.diagnostic.goto_next, 'Go to next diagnostic message' },
    ['<F1>'] = { '<ESC>', 'Remap F1 as escape' },
    ['<C-k>'] = {
      function()
        require('cinnamon').scroll '<C-u>zz'
      end,
      'Remap Ctrl-u',
    },
    ['<C-j>'] = {
      function()
        require('cinnamon').scroll '<C-d>zz'
      end,
      'Remap Ctrl-d',
    },
  },
  i = { -- Insert mode mappings
    ['<F1>'] = { '<ESC>', 'Remap F1 as escape' },
  },
  v = { -- Visual mode mappings
    ['xa'] = {
      function()
        require('align').align_to_char { length = 1 }
      end,
      'Align to char',
    },
    ['<C-k>'] = {
      function()
        require('cinnamon').scroll '<C-u>zz'
      end,
      'Remap Ctrl-u',
    },
    ['<C-j>'] = {
      function()
        require('cinnamon').scroll '<C-d>zz'
      end,
      'Remap Ctrl-d',
    },
  },
}

M.git = {
  n = {
    ['<leader>l'] = { ':LazyGit<cr>', 'Open LazyGit' },
  },
}

M.harpoon = {
  n = {
    ['<leader>h'] = { ':lua require("harpoon.ui").toggle_quick_menu()<CR>', 'Browse harpooned files' },
    ['ha'] = { ':lua require("harpoon.mark").add_file()<CR>', 'Harpoon file' },
    ['hn'] = { ':lua require("harpoon.ui").nav_next()<CR>', 'Navigate to next harpooned file' },
    ['hb'] = { ':lua require("harpoon.ui").nav_prev()<CR>', 'Navigate to previous harpooned file' },
  },
}

M.ssr = {
  n = {
    ['<leader>sr'] = { ':Spectre<CR>', 'Search and Replace (Spectre)' },
    ['<leader>ss'] = {
      function()
        require('custom').ssr_line()
      end,
      'Search and Replace in line',
    },
    ['<leader>sa'] = {
      function()
        require('custom').ssr_buffer()
      end,
      'Search and Replace in current buffer',
    },
  },
}

M.text = {
  n = {
    ['<leader>md'] = { ':MarkdownPreview<CR>', 'Open Markdown Preview' },
    ['<A-UP>'] = { ':m .-2<CR>==', 'Move one line up' },
    ['<A-DOWN>'] = { ':m .+1<CR>==', 'Move one line down' },
    ['<leader>/'] = { '<Cmd>lua require("Comment.api").toggle.linewise.current()<CR>', 'Comment linewise' },
    ['<S-A-DOWN>'] = { ':t.<CR>', 'Duplicate line' },
  },
  v = {
    ['<A-UP>'] = { ":m '<-2<CR>gv=gv", 'Move selected lines up' },
    ['<A-DOWN>'] = { ":m '>+1<CR>gv=gv", 'Move selected lines down' },
    ['<leader>/'] = { '<ESC><Cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', 'Comment linewise selected text' },
    ['<S-A-DOWN>'] = { ":t'>\\<CR>gv=gv", 'Duplicate line' },
    ['<Tab>'] = { '>gv', 'Indent' },
    ['<S-Tab>'] = { '<gv', 'Outdent' },
  },
  i = {
    ['<A-UP>'] = { '<C-o>:m .-2<CR>', 'Move one line up' },
    ['<A-DOWN>'] = { '<C-o>:m .+1<CR>', 'Move one line down' },
    ['<C-z>'] = { '<C-o>u', 'Undo' },
    ['<C-y>'] = { '<C-o>:redo<CR>', 'Redo' },
    ['<C-x>'] = { '<C-o>dd', 'Cut' },
    ['<C-s>'] = { '<C-o>:w<CR>', 'Save' },
    ['<C-v>'] = { '<C-R>+', 'paste' },
    ['<Tab>'] = { '<C-t>', 'Indent line' },
    ['<S-Tab>'] = { '<C-d>', 'Outdent line' },
    ['<S-A-DOWN>'] = { '<C-o>:t.<CR><C-o>==', 'Duplicate line' },
  },
}

M.telescope = {
  n = {
    ['<leader>p'] = { ':CdProject<CR>', 'Open Saved Projects' },
    ['<leader>t'] = { ':TodoTelescope keywords=TODO,FIX<CR>', 'List TODOs' },
    ['<leader>e'] = { ':Neotree<CR>', 'Explore Files in current dir' },
    ['<leader>g'] = { ':Telescope live_grep theme=ivy layout_config={height=0.55,width=0.8}<CR>', 'live grep' },
    ['<leader>sd'] = { require('telescope.builtin').diagnostics, '[S]earch [D]iagnostics' },
    ['<leader>so'] = { require('telescope.builtin').oldfiles, 'Find recently opened files' },
    ['<leader>f'] = { ':Telescope current_buffer_fuzzy_find theme=ivy layout_config={height=0.55}<CR>', '[/] Fuzzily search in current buffer' },
    ['<leader>cs'] = {
      function()
        vim.api.nvim_exec_autocmds('User', { pattern = 'ColorSchemeLoad' })
        require('telescope.builtin').colorscheme()
      end,
      'Explore colorschemes',
    },
  },
}
return M
