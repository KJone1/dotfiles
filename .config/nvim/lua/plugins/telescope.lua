return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-project.nvim',
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      -- refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
      config = function()
        require('telescope').setup {
          extensions = {
          },
          defaults = {
            theme = "center",
            sorting_strategy = "ascending",
            results_title = false,
            prompt_prefix = "  ",
            selection_caret = " ",
            file_ignore_patterns = {".git"},
            mappings = {
              i = {
                ['<C-u>'] = false,
                ['<C-d>'] = require('telescope.actions').delete_buffer,
              },
            },
          },
        }
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension,'fzf')
      end
    },
  },
}
