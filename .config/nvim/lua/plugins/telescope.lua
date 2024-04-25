return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-project.nvim',
    "nvim-telescope/telescope-file-browser.nvim",
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
            file_ignore_patterns = {".git$"},
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
          extensions = {
            file_browser = {
              layout_config = {
                width = 0.65,
              },
              previewer        = false,
              hijack_netrw     = true,
              grouped          = true,
              auto_depth       = true,
              prompt_path      = true,
              select_buffer    = true,
              display_stat     = false,
              dir_icon         = " ",
              git_status       = true,
              hidden = {
                file_browser   = true,
                folder_browser = false,
              },
              mappings = {
                ["i"] = {
                  ["<bs>"]     = false  -- disable <bs> from going back to parent dir.
                },
              },
            },
          },
        }
      -- Enable telescope extensions, if installed
      pcall(require("telescope").load_extension,"harpoon")
      pcall(require("telescope").load_extension,"file_browser")
      pcall(require('telescope').load_extension,'fzf')
      end
    },
  },
}
