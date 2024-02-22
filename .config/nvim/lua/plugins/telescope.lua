return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-project.nvim',
    'SalOrak/whaler',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
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
            whaler = {
              oneoff_directories = {
                "~/DEV/dotfiles"
              },
              file_explorer = "telescope_file_browser",
              hidden = true,
            }
          },
          defaults = {
            theme = "center",
            sorting_strategy = "ascending",
            results_title = "false",
            prompt_prefix = "  ",
            selection_caret = " ",
            file_ignore_patterns = {".git"},
            -- layout_config = {
            --   prompt_position = "bottom",
            --   horizontal = {
            --     width_padding = 0.04,
            --     height_padding = 0.1,
            --     preview_width = 0.5,
            --   },
            --   vertical = {
            --     width_padding = 0.05,
            --     height_padding = 1,
            --     preview_height = 0.5,
            --   },
            -- },
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
      pcall(require('telescope').load_extension,'whaler')
      end
    },
  },
}
