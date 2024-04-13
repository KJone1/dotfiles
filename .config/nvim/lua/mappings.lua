local M = {}

M.general = {
  n = { -- Normal mode mappings
    ['pt'] = {':Twilight<CR>','Twilight Mode' },
  },
  i = { -- Insert mode mappings
  },
  v = { -- Visual mode mappings
  },
}

M.git = {
  n = {
    ['lg'] = {':LazyGit<CR>', 'Lazy Git' },
  },
}

M.ssr = {
  n = {
    ["<leader>sr"] = {':Spectre<CR>', 'Search and Replace (Spectre)' },
    ["<leader>ss"] = { function() require("custom").ssr_line() end , 'Search and Replace in line' },
    ["<leader>sa"] = { function() require("custom").ssr_buffer() end , 'Search and Replace in current buffer' }
  }
}

M.text = {
  n = {
    ['pm'] = {':MarkdownPreview<CR>','Open Markdown Preview' },
    ['<A-UP>'] = {':m .-2<CR>==','Move one line up' },
    ['<A-DOWN>'] = {':m .+1<CR>==','Move one line down' },
    ['<leader>/'] = {'<Cmd>lua require("Comment.api").toggle.linewise.current()<CR>', 'Comment linewise' },
    ['<S-A-DOWN>'] = {':t.<CR>', 'Duplicate line' },
  },
  v = {
    ['<A-UP>'] = {":m '<-2<CR>gv=gv",'Move selected lines up' },
    ['<A-DOWN>'] = {":m '>+1<CR>gv=gv",'Move selected lines down' },
    ['<leader>/'] = {'<ESC><Cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', 'Comment linewise selected text' },
    ['<S-A-DOWN>'] = {":t'>\\<CR>gv=gv", 'Duplicate line' },
    ['<Tab>'] = {">gv", 'Indent' },
    ['<S-Tab>'] = {"<gv", 'Outdent' },

  },
  i = {
    ['<A-UP>'] = {'<C-o>:m .-2<CR>','Move one line up' },
    ['<A-DOWN>'] = {'<C-o>:m .+1<CR>','Move one line down' },
    ['<C-z>'] = {'<C-o>u', 'Undo' },
    ['<C-y>'] = {'<C-o>:redo<CR>', 'Redo' },
    ['<C-x>'] = {'<C-o>dd', 'Cut' },
    ['<C-s>'] = {'<C-o>:w<CR>', 'Save' },
    ['<C-v>'] = {'<C-R>+', 'paste' },
    ['<Tab>'] = {'<C-t>', 'Indent line' },
    ['<S-Tab>'] = {'<C-d>', 'Outdent line' },
    ['<S-A-DOWN>'] = {'<C-o>:t.<CR><C-o>==', 'Duplicate line' },
  }
}

M.telescope = {
  n = {
    ['<leader>p']       = { ":lua require'telescope'.extensions.project.project{display_type = 'full'}<CR>", 'Open Saved Projects' },
    ['<leader>t']       = { ":TodoTelescope keywords=TODO,FIX<CR>", 'List TODOs' },
    -- ['<leader>e']       = { require('telescope.builtin').find_files, 'Explore Files in current dir' },
    ['<leader>e']       = { ':Telescope file_browser cwd=%:p:h<CR>', 'Explore Files in current dir' },
    ['<leader>sd']      = { require('telescope.builtin').diagnostics, '[S]earch [D]iagnostics' },
    ['<leader>so']      = { require('telescope.builtin').oldfiles, 'Find recently opened files' },
    ['<leader><space>'] = { require('telescope.builtin').buffers, 'Find open buffers' },
    ['<leader>f'] = { function()
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
        wrap_results = true,
      })
      end, '[/] Fuzzily search in current buffer' },
    ['<leader>cs'] = {
      function()
        vim.api.nvim_exec_autocmds("User", { pattern = "ColorSchemeLoad" })
        require("telescope.builtin").colorscheme()
      end, 'Explore colorschemes'}
  }
}
return M
