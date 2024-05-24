return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Only load if `make` is available. Make sure you have the system requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
      config = function()
        require("telescope").setup {
          defaults = {
            theme                = "center",
            sorting_strategy     = "ascending",
            results_title        = false,
            prompt_prefix        = "  ",
            selection_caret      = " ",
            mappings = {
              i = {
                ['<C-u>'] = false,
                ['<C-d>'] = require('telescope.actions').delete_buffer,
              },
            },
          },
          pickers = {
            live_grep = {
              vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--column",
                "--smart-case",
                "--trim",
                "--hidden",
                "--glob",
                "!**/.git/*"
              },
            },
          },
        }
      -- Enable telescope extensions, if installed
      pcall(require("telescope").load_extension,"harpoon")
      pcall(require("telescope").load_extension,"spaceport")
      pcall(require('telescope').load_extension,'fzf')
      end
    },
  },
}
