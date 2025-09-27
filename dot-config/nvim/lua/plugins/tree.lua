return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true,
      enable_diagnostics = true,
      default_component_configs = {
        icon = {
          folder_closed = '󰉋 ',
          folder_open = ' ',
          folder_empty = '󱧵 ',
          folder_empty_open = '󱧵 ',
          default = ' ',
        },
        git_status = {
          symbols = {
            -- Change type
            added = ' ',
            modified = ' ',
            deleted = ' ',
            renamed = '󰔾 ',
            -- Status type
            untracked = '',
            ignored = ' ',
            unstaged = '',
            staged = ' ',
            conflict = ' ',
          },
        },
      },
      window = {
        position = 'float',
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_by_name = {
            '.git',
          },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        hijack_netrw_behavior = 'open_default',
      },
    }
  end,
}
