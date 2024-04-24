return {
  'nvim-lualine/lualine.nvim',
  opts = {
      options = {
        icons_enabled = true,
        component_separators = '',
        section_separators = ' ',
      },
      sections = {
          lualine_a = {
            { 'mode',right_padding = 2 },
          },
          lualine_b = {
            {
              require("custom").current_file_component,
              color = {
                bg  = "NONE",
                fg  = "white",
                gui = "bold"
              }
            },
            {
              'branch',
              color = {
                bg  = "NONE",
                fg  = "white",
                gui = "bold"
              }
            },
            {
              'diff',
              symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
              color = {
                bg  = "NONE",
                fg  = "white",
                gui = "bold"
              },
              diff_color = {
                added    = { fg = '#98be65' },
                modified = { fg = '#FF8800' },
                removed  = { fg = '#ec5f67' },
              },
            },
          },
          lualine_c = {
           {
              'diagnostics',
              source            = { 'nvim' },
              sections          = { 'error' },
              separator         = { left = ' ' },
              diagnostics_color = { error = { bg = '#ca1243', fg = '#f3f3f3' } },
            },
            {
              'diagnostics',
              source            = { 'nvim' },
              sections          = { 'warn' },
              separator         = { left = ' '},
              diagnostics_color = { warn = { bg = '#fe8019', fg = '#f3f3f3' } },
            },
            {
              '%w',
              cond = function()
                return vim.wo.previewwindow
              end,
            },
            {
              '%r',
              cond = function()
                return vim.bo.readonly
              end,
            },
            {
              '%q',
              cond = function()
                return vim.bo.buftype == 'quickfix'
              end,
            },
          },
          lualine_x = {
            {
              require("custom").harpoon_component,
              color = {
                bg = "NONE",
                fg = "white"
              }
            }
          },
          lualine_y = {
            {
              'filetype',
              color = {
                bg = "NONE",
                fg = "white",
              }
            },
            {
              'encoding',
              fmt = string.upper,
              color = {
                bg = "NONE",
                fg = "white",
              }
            },
            {
              'fileformat',
              fmt = string.upper,icons_enabled = false,
              color = {
                bg = "NONE",
                fg = "white",
              }
            }
          },
          lualine_z = {},
      },
    },
  }

